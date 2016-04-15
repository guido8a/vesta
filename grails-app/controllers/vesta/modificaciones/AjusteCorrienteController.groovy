package vesta.modificaciones

import vesta.alertas.Alerta
import vesta.avales.EstadoAval
import vesta.avales.ProcesoAsignacion
import vesta.parametros.TipoElemento
import vesta.parametros.UnidadEjecutora
import vesta.parametros.poaPac.Anio
import vesta.parametros.poaPac.Fuente
import vesta.parametros.poaPac.Presupuesto
import vesta.poa.Asignacion
import vesta.poaCorrientes.ActividadCorriente
import vesta.poaCorrientes.MacroActividad
import vesta.poaCorrientes.ObjetivoGastoCorriente
import vesta.poaCorrientes.Tarea
import vesta.proyectos.MarcoLogico
import vesta.proyectos.ModificacionAsignacion
import vesta.seguridad.Firma
import vesta.seguridad.Persona

class AjusteCorrienteController {

    def firmasService
    def dbConnectionService

    /**
     * Acción que muestra los diferentes tipos de reforma posibles y permite seleccionar uno para comenzar el proceso
     */
    def ajustes() {
    }

    /**
     * Acción que muestra la lista de todos las reformas, con su estado y una opción para ver el pdf
     */
    def lista() {
        def reformas
        def unidadPersona = Persona.get(session.usuario.id).unidad.codigo
        def perfil = session.perfil.codigo.toString()
//        def unidades = UnidadEjecutora.get(session.unidad.id).getUnidadesPorPerfil(perfil)
        def listaUnidades = ['DA', 'DF', 'GAF']
        def unidadesReales = UnidadEjecutora.findAllByCodigoInList(listaUnidades)
        println("unidades " + unidadesReales )
        reformas = Reforma.withCriteria {
//            eq("tipo", "C")
            eq("tipoSolicitud", "Y")
/*
            persona {
                inList("unidad", unidadesReales)
                order("unidad", "asc")
            }
*/
            order("fecha", "desc")
        }
        return [reformas: reformas, unidad: unidadPersona]
    }

    /**
     * Acción que muestra la lista de las reformas solicitadas para q un analista de planificación apruebe y pida firmas o niegue
     */
    def pendientes() {
        def unidadPersona = Persona.get(session.usuario.id).unidad.codigo
        def estadoPendiente = EstadoAval.findByCodigo("P01")
        def estadoDevueltoAnPlan = EstadoAval.findByCodigo("D03")

        def estados = []
        def perfil = session.perfil.codigo.toString()
        def unidades
        unidades = UnidadEjecutora.get(session.unidad.id).getUnidadesPorPerfil(perfil)

        def filtroDirector = null,
            filtroPersona = null

        switch (perfil) {
            case "ASAF":
                estados = [estadoPendiente, estadoDevueltoAnPlan]
                break;
        }

        def reformas = Reforma.withCriteria {
            eq("tipo", "A")
            eq("tipoSolicitud", "Y")
            if (estados.size() > 0) {
                inList("estado", estados)
            }
            if (unidades.size() > 0) {
                persona {
                    inList("unidad", unidades)
                }
            }
            if (filtroPersona) {
                eq("persona", filtroPersona)
            }
            if (filtroDirector) {
                eq("director", filtroDirector)
            }
        }
        def actual
        if (params.anio) {
            actual = Anio.get(params.anio)
        } else {
            actual = Anio.findByAnio(new Date().format("yyyy"))
        }

        def unidadesList

        def uns = UnidadEjecutora.get(session.unidad.id).getUnidadesPorPerfil(perfil)
        unidadesList = Asignacion.withCriteria {
            inList("unidad", uns)
            projections {
                distinct("unidad")
            }
        }

        unidadesList = unidadesList.sort { it.nombre }

        return [reformas: reformas, actual: actual, unidades: unidadesList, unidad: unidadPersona]
    }

    /**
     * Acción llamada con ajax que muestra un historial de reformas solicitadas
     */
    def historial_ajax() {
        def tipo = 'C'
        def estados = EstadoAval.list()
        def reformas
        def perfil = session.perfil.codigo.toString()
        def unidades
        unidades = UnidadEjecutora.get(session.unidad.id).getUnidadesPorPerfil(perfil)
        reformas = Reforma.withCriteria {
            eq("tipo", tipo)
            inList("estado", estados)
            persona {
                inList("unidad", unidades)
            }
            order("fecha", "desc")
        }
        return [reformas: reformas]
    }

    /**
     * Acción que permite realizar una solicitud de reforma a asignaciones existentes
     */
    def existente() {

        println("params" + params)

        def actual
        if (params.anio) {
            actual = Anio.get(params.anio)
        } else {
            actual = Anio.findByAnio(new Date().format("yyyy"))
        }

        List<ObjetivoGastoCorriente> objetivos = []
        ActividadCorriente.findAllByAnio(actual).each { ac ->
            def ob = ac.macroActividad.objetivoGastoCorriente
            if (!objetivos.contains(ob)) {
                objetivos += ob
            }
        }
        objetivos.sort { it.descripcion }

        def estadoDevuelto = EstadoAval.findByCodigo("D03")
        def estadoPendiente = EstadoAval.findByCodigo("P01")
        def estados = [estadoPendiente, estadoDevuelto]

        def firmas = firmasService.listaFirmasCorrientes()

        def total = 0

        def reforma = null, detalles = []
        if (params.id) {
            reforma = Reforma.get(params.id)
            if (!estados.contains(reforma.estado)) {
                println "esta en estado: ${reforma.estado.descripcion} (${reforma.estado.codigo}) asiq redirecciona a la lista"
                redirect(action: "lista")
                return
            }
            detalles = DetalleReforma.findAllByReforma(reforma)
            if (detalles.size() > 0) {
                total = detalles.sum { it.valor }
            }
        }

        return [objetivos: objetivos, objetivos2: objetivos, actual: actual, personas: firmas.directores,
                gerentes : firmas.gerentes, total: total, reforma: reforma, detalles: detalles]
    }

    /**
     * Acción que permite realizar una solicitud de reforma a nueva partida
     */
    def partida() {
        def actual
        if (params.anio) {
            actual = Anio.get(params.anio)
        } else {
            actual = Anio.findByAnio(new Date().format("yyyy"))
        }

        List<ObjetivoGastoCorriente> objetivos = []
        ActividadCorriente.findAllByAnio(actual).each { ac ->
            def ob = ac.macroActividad.objetivoGastoCorriente
            if (!objetivos.contains(ob)) {
                objetivos += ob
            }
        }
        objetivos.sort { it.descripcion }

        def campos = ["numero": ["Número", "string"], "descripcion": ["Descripción", "string"]]
        def firmas = firmasService.listaFirmasCorrientes()
        def estadoDevuelto = EstadoAval.findByCodigo("D03")
        def estadoPendiente = EstadoAval.findByCodigo("P01")
        def estados = [estadoPendiente, estadoDevuelto]

        def total = 0

        def reforma = null, detalles = []
        if (params.id) {
            reforma = Reforma.get(params.id)
            if (!estados.contains(reforma.estado)) {
                println "esta en estado: ${reforma.estado.descripcion} (${reforma.estado.codigo}) asiq redirecciona a la lista"
                redirect(action: "lista")
                return
            }
            detalles = DetalleReforma.findAllByReforma(reforma)
            if (detalles.size() > 0) {
                total = detalles.sum { it.valor }
            }
        }

        return [objetivos: objetivos, actual: actual, campos: campos, personas: firmas.directores,
                gerentes : firmas.gerentes, total: total, reforma: reforma, detalles: detalles]
    }

    /**
     * Acción llamada con ajax que guarda una solicitud de reforma de asignaciones existentes
     */
    def saveExistente_ajax() {
        def anio = Anio.get(params.anio.toLong())
        def personaFirma1, personaFirma2

        def estado = EstadoAval.findByCodigo("P01") //pendiente
        if (params.send == "S") {
            estado = EstadoAval.findByCodigo("EF1") //aprobado sin firma
        }

        def now = new Date()
        def usu = Persona.get(session.usuario.id)

        def reforma
        if (params.id) {
            reforma = Reforma.get(params.id)
            if (!reforma) {
                reforma = new Reforma()
            }
            personaFirma1 = reforma.firma1?.usuario
            personaFirma2 = reforma.firma2?.usuario
            if (!personaFirma1) {
                if (params.firma1) {
                    personaFirma1 = Persona.get(params.firma1.toLong())
                }
                if (params.firma2) {
                    personaFirma2 = Persona.get(params.firma2.toLong())
                }
            }
        } else {
            reforma = new Reforma()
            if (params.firma1) {
                personaFirma1 = Persona.get(params.firma1.toLong())
            }
            if (params.firma2) {
                personaFirma2 = Persona.get(params.firma2.toLong())
            }
        }

        reforma.anio = anio
        reforma.persona = usu
        reforma.analista = usu
        reforma.estado = estado
        reforma.concepto = params.concepto.trim()
        reforma.fecha = now
        reforma.tipo = "C"
        reforma.tipoSolicitud = "E"
        if (!reforma.save(flush: true)) {
            println "error al crear el ajuste: " + reforma.errors
            render "ERROR*" + renderErrors(bean: reforma)
            return
        }

        def tipoStr = elm.tipoReformaStr(tipo: 'Ajuste corriente', tipoSolicitud: reforma.tipoSolicitud)

        if (params.send == "S") {
            println "se va a mandar: se hace la alerta y se manda mail, se crean las firmas"
            if (params.id && reforma.firma1 && reforma.firma2) {
                def firma1 = reforma.firma1
                firma1.estado = "S"
                firma1.save(flush: true)
                def firma2 = reforma.firma2
                firma2.estado = "S"
                firma2.save(flush: true)
            } else {
                def firma1 = new Firma()
                firma1.usuario = personaFirma1
                firma1.fecha = now
                firma1.accion = "firmarAprobarAjuste"
                firma1.controlador = "ajusteCorriente"
                firma1.idAccion = reforma.id
                firma1.accionVer = "existente"
                firma1.controladorVer = "reportesReforma"
                firma1.idAccionVer = reforma.id
                firma1.accionNegar = "devolverAprobarAjuste"
                firma1.controladorNegar = "ajusteCorriente"
                firma1.idAccionNegar = reforma.id
                firma1.concepto = "${tipoStr} (${now.format('dd-MM-yyyy')}): " + reforma.concepto
                firma1.tipoFirma = "AJSC"
                if (!firma1.save(flush: true)) {
                    println "error al crear firma1: " + firma1.errors
                    render "ERROR*" + renderErrors(bean: firma1)
                    return
                }
                def firma2 = new Firma()
                firma2.usuario = personaFirma2
                firma2.fecha = now
                firma2.accion = firma1.accion
                firma2.controlador = firma1.controlador
                firma2.idAccion = firma1.idAccion
                firma2.accionVer = firma1.accionVer
                firma2.controladorVer = firma1.controladorVer
                firma2.idAccionVer = firma1.idAccionVer
                firma2.accionNegar = firma1.accionNegar
                firma2.controladorNegar = firma1.controladorNegar
                firma2.idAccionNegar = firma1.idAccionNegar
                firma2.concepto = firma1.concepto
                firma2.tipoFirma = firma1.tipoFirma
                if (!firma2.save(flush: true)) {
                    println "error al crear firma: " + firma2.errors
                    render "ERROR*" + renderErrors(bean: firma2)
                    return
                }
                reforma.firma1 = firma1
                reforma.firma2 = firma2
                reforma.save(flush: true)
            }
            def alerta1 = new Alerta()
            alerta1.from = usu
            alerta1.persona = personaFirma1
            alerta1.fechaEnvio = now
            alerta1.mensaje = "${tipoStr} (${now.format('dd-MM-yyyy')}): " + reforma.concepto
            alerta1.controlador = "firma"
            alerta1.accion = "firmasPendientes"
            alerta1.id_remoto = reforma.id
            if (!alerta1.save(flush: true)) {
                println "error alerta: " + alerta1.errors
            }
            def alerta2 = new Alerta()
            alerta2.from = usu
            alerta2.persona = personaFirma2
            alerta2.fechaEnvio = now
            alerta2.mensaje = alerta1.mensaje
            alerta2.controlador = alerta1.controlador
            alerta2.accion = alerta1.accion

            alerta2.id_remoto = alerta1.id_remoto
            if (!alerta2.save(flush: true)) {
                println "error alerta: " + alerta2.errors
            }
        } else {
            println "no se manda: no se hace alerta ni se manda mail ni se hacen firmas"
        }

        def errores = ""
        params.each { k, v ->
            if (k.toString().startsWith("r")) {
                def parts = v.toString().split("_")
                if (parts.size() >= 3) {
                    def origenId = parts[0].toLong()
                    def destinoId = parts[1].toLong()
                    def monto = parts[2].toString().replaceAll(",", "").toDouble()

                    def asignacionOrigen = Asignacion.get(origenId)
                    def asignacionDestino = Asignacion.get(destinoId)

                    def detalle = new DetalleReforma()
                    detalle.reforma = reforma
                    detalle.asignacionOrigen = asignacionOrigen
                    detalle.asignacionDestino = asignacionDestino
                    detalle.valor = monto
                    detalle.valorOrigenInicial = asignacionOrigen.priorizado
                    detalle.valorDestinoInicial = asignacionDestino.priorizado
                    detalle.anio = anio
                    if (!detalle.save(flush: true)) {
                        println "error al guardar detalle: " + detalle.errors
                        errores += renderErrors(bean: detalle)
                    }
                }
            }
        }
        if (errores == "") {
            if (params.send == "S") {
                render "SUCCESS*Ajuste solicitado exitosamente"
            } else {
                render "SUCCESS*Ajuste guardado exitosamente*" + reforma.id
            }
        } else {
            render "ERROR*" + errores
        }
    }

    /**
     * Acción llamada con ajax que guarda una solicitud de reforma de nueva partida
     */
    def savePartida_ajax() {
        println params
        //test
        def detalles = [:]
        params.each { k, v ->
            if (k.toString().startsWith("r")) {
                def parts = k.split("\\[")
                def pos = parts[0]
                def campo = parts[1].split("]")[0]
                if (!detalles[pos]) {
                    detalles[pos] = [:]
                }
                detalles[pos][campo] = v
            }
        }

        def anio = Anio.get(params.anio.toLong())
        def personaFirma1, personaFirma2
//        def aprobadoSinFirma = EstadoAval.findByCodigo("EF1")
        def estado = EstadoAval.findByCodigo("P01") //pendiente
        if (params.send == "S") {
            estado = EstadoAval.findByCodigo("EF1") //aprobado sin firma
        }

        def now = new Date()
        def usu = Persona.get(session.usuario.id)

        def reforma
        if (params.id) {
            reforma = Reforma.get(params.id)
            if (!reforma) {
                reforma = new Reforma()
            }
            personaFirma1 = reforma.firma1?.usuario
            personaFirma2 = reforma.firma2?.usuario
            if (!personaFirma1) {
                if (params.firma1) {
                    personaFirma1 = Persona.get(params.firma1.toLong())
                }
                if (params.firma2) {
                    personaFirma2 = Persona.get(params.firma2.toLong())
                }
            }
        } else {
            reforma = new Reforma()
            if (params.firma1) {
                personaFirma1 = Persona.get(params.firma1.toLong())
            }
            if (params.firma2) {
                personaFirma2 = Persona.get(params.firma2.toLong())
            }
        }

        reforma.anio = anio
        reforma.persona = usu
        reforma.analista = usu
        reforma.estado = estado
        reforma.concepto = params.concepto.trim()
        reforma.fecha = now
        reforma.tipo = "C"
        reforma.tipoSolicitud = "P"
        if (!reforma.save(flush: true)) {
            println "error al crear el ajuste: " + reforma.errors
            render "ERROR*" + renderErrors(bean: reforma)
            return
        }

        def tipoStr = elm.tipoReformaStr(tipo: 'Ajuste', tipoSolicitud: reforma.tipoSolicitud)

        if (params.send == "S") {
            println "se va a mandar: se hace la alerta y se manda mail, se crean las firmas"
            if (params.id && reforma.firma1 && reforma.firma2) {
                def firma1 = reforma.firma1
                firma1.estado = "S"
                firma1.save(flush: true)
                def firma2 = reforma.firma2
                firma2.estado = "S"
                firma2.save(flush: true)
            } else {
                def firma1 = new Firma()
                firma1.usuario = personaFirma1
                firma1.fecha = now
                firma1.accion = "firmarAprobarAjuste"
                firma1.controlador = "ajusteCorriente"
                firma1.idAccion = reforma.id
                firma1.accionVer = "partida"
                firma1.controladorVer = "reportesReforma"
                firma1.idAccionVer = reforma.id
                firma1.accionNegar = "devolverAprobarAjuste"
                firma1.controladorNegar = "ajusteCorriente"
                firma1.idAccionNegar = reforma.id
                firma1.concepto = "${tipoStr} (${now.format('dd-MM-yyyy')}): " + reforma.concepto
                firma1.tipoFirma = "AJSC"
                if (!firma1.save(flush: true)) {
                    println "error al crear firma1: " + firma1.errors
                    render "ERROR*" + renderErrors(bean: firma1)
                    return
                }
                def firma2 = new Firma()
                firma2.usuario = personaFirma2
                firma2.fecha = now
                firma2.accion = firma1.accion
                firma2.controlador = firma1.controlador
                firma2.idAccion = firma1.idAccion
                firma2.accionVer = firma1.accionVer
                firma2.controladorVer = firma1.controladorVer
                firma2.idAccionVer = firma1.idAccionVer
                firma2.accionNegar = firma1.accionNegar
                firma2.controladorNegar = firma1.controladorNegar
                firma2.idAccionNegar = firma1.idAccionNegar
                firma2.concepto = firma1.concepto
                firma2.tipoFirma = firma1.tipoFirma
                if (!firma2.save(flush: true)) {
                    println "error al crear firma2: " + firma2.errors
                    render "ERROR*" + renderErrors(bean: firma2)
                    return
                }
                reforma.firma1 = firma1
                reforma.firma2 = firma2
                reforma.save(flush: true)
            }
            def alerta1 = new Alerta()
            alerta1.from = usu
            alerta1.persona = personaFirma1
            alerta1.fechaEnvio = now
            alerta1.mensaje = "${tipoStr} (${now.format('dd-MM-yyyy')}): " + reforma.concepto
            alerta1.controlador = "firma"
            alerta1.accion = "firmasPendientes"
            alerta1.id_remoto = reforma.id
            if (!alerta1.save(flush: true)) {
                println "error alerta: " + alerta1.errors
            }
            def alerta2 = new Alerta()
            alerta2.from = usu
            alerta2.persona = personaFirma2
            alerta2.fechaEnvio = now
            alerta2.mensaje = alerta1.mensaje
            alerta2.controlador = alerta1.controlador
            alerta2.accion = alerta1.accion
            alerta2.id_remoto = alerta1.id_remoto
            if (!alerta2.save(flush: true)) {
                println "error alerta: " + alerta2.errors
            }
        } else {
            println "no se manda: no se hace alerta ni se manda mail ni se hacen firmas"
        }
//          [r1:[monto:500.00, origen:322, partida:218, fuente:9], r0:[origen:322, fuente:9, partida:223, monto:150.00]]
        def errores = ""
        detalles.each { k, det ->
            def monto = det.monto.replaceAll(",", "").toDouble()

            def asignacionOrigen = Asignacion.get(det.origen.toLong())
            def presupuesto = Presupuesto.get(det.partida.toLong())
//            def fuente = Fuente.get(det.fuente.toLong())

            def detalle = new DetalleReforma()
            detalle.reforma = reforma
            detalle.asignacionOrigen = asignacionOrigen
            detalle.valor = monto
            detalle.valorOrigenInicial = asignacionOrigen.priorizado
            detalle.valorDestinoInicial = 0
            detalle.presupuesto = presupuesto
            detalle.fuente = asignacionOrigen.fuente
            detalle.anio = anio

            if (!detalle.save(flush: true)) {
                println "error al guardar detalle: " + detalle.errors
                errores += renderErrors(bean: detalle)
            }
        }
        if (errores == "") {
            if (params.send == "S") {
                render "SUCCESS*Ajuste solicitado exitosamente"
            } else {
                render "SUCCESS*Ajuste guardado exitosamente*" + reforma.id
            }
        } else {
            render "ERROR*" + errores
        }
    }

    /**
     * Acción para firmar la aprobación de la reforma
     */
    def firmarAprobarAjuste() {
        println "firmar aprobar ajuste corriente: " + params
        def firma = Firma.findByKey(params.key)
        if (!firma) {
            response.sendError(403)
        } else {
            def reforma = Reforma.findByFirma1OrFirma2(firma, firma)
            if (reforma.firma1.estado == "F" && reforma.firma2.estado == "F") {
                println ">>> estan ya las 2 firmas: hace todos los cambios"
                //busco el ultimo numero asignado para signar el siguiente
                def ultimoNum = Reforma.withCriteria {
                    eq("tipo", "C")
                    projections {
                        max "numero"
                    }
                }

                def num = 1
                if (ultimoNum && ultimoNum.size() == 1) {
                    num = ultimoNum.first() + 1
                }

                println "va a ponerle numero: " + num

                def estadoAprobado = EstadoAval.findByCodigo("E02")
                reforma.estado = estadoAprobado
                reforma.numeroReforma = num
                if (!reforma.save(flush: true)) {
                    println "Error reforma: " + reforma.errors
                }
                def usu = Persona.get(session.usuario.id)
                def now = new Date()
                def errores = ""
                def detalles = DetalleReforma.findAllByReforma(reforma)
                detalles.each { detalle ->
                    def origen = detalle.asignacionOrigen
                    def destino
                    //E: existente, A: actividad, P: partida, I: incremento
                    switch (reforma.tipoSolicitud) {
                        case "E":
                            println "E"
                            destino = detalle.asignacionDestino
                            break;
                        case "P":
                            println "P"
                            destino = new Asignacion()
                            destino.anio = reforma.anio
                            destino.fuente = origen.fuente
                            destino.tarea = origen.tarea
                            destino.presupuesto = detalle.presupuesto
                            destino.planificado = 0
                            destino.unidad = origen.unidad
                            destino.priorizado = 0
                            if (!destino.save(flush: true)) {
                                println "error al guardar la asignacion (CP) " + destino.errors
                                errores += renderErrors(bean: destino)
                                destino = null
                            }
                            break;
                    }
                    println "origen: " + origen + "   destino: " + destino
                    if (origen && destino) {
                        println "hace la nueva modificacion con detalle reforma=" + detalle.id
                        def modificacion = new ModificacionAsignacion()
                        modificacion.usuario = usu
                        modificacion.desde = origen
                        if (destino) {
                            modificacion.recibe = destino
                            modificacion.originalDestino = destino.priorizado
                        }
                        modificacion.fecha = now
                        modificacion.valor = detalle.valor
                        modificacion.estado = 'A'
                        modificacion.detalleReforma = detalle
                        modificacion.originalOrigen = origen.priorizado
                        if (!modificacion.save(flush: true)) {
                            println "error save modificacion: " + modificacion.errors
                            errores += renderErrors(bean: modificacion)
                        } else {
                            println "ya guardo la modificacion, cambia los valores priorizados: "
                            println "AN origen: " + origen.priorizado
                            println "AN destino: " + destino.priorizado
                            origen.priorizado -= detalle.valor
                            destino.priorizado += detalle.valor
                            println "DE origen: " + origen.priorizado
                            println "DE destino: " + destino.priorizado
                            if (!origen.save(flush: true)) {
                                println "error save origen: " + origen.errors
                                errores += renderErrors(bean: origen)
                            }
                            if (destino && !destino.save(flush: true)) {
                                println "error save destino: " + destino.errors
                                errores += renderErrors(bean: destino)
                            }
                        }
                    }
                }
            }
            render "ok"
        }
    }

    /**
     * Acción para devolver la solicitud de reforma al analista de planificación
     */
    def devolverAprobarAjuste() {
        def now = new Date()
        def usu = Persona.get(session.usuario.id)

        def reforma = Reforma.get(params.id)
        reforma.estado = EstadoAval.findByCodigo("D03") //devuelto al analista
        reforma.save(flush: true)

        reforma.firma1.estado = "N"
        reforma.firma2.estado = "N"
        reforma.firma1.save(flush: true)
        reforma.firma2.save(flush: true)

        def tipoStr = elm.tipoReformaStr(tipo: 'Ajuste corriente', tipoSolicitud: reforma.tipoSolicitud)
        def accion
        def mensaje = "Devolución de ${tipoStr} "
        //E: existente, A: actividad, P: partida
        switch (reforma.tipoSolicitud) {
            case "E":
                accion = "existente"
                break;
            case "P":
                accion = "partida"
                break;
            default:
                accion = "existente"
        }

        def alerta = new Alerta()
        alerta.from = usu
        alerta.persona = reforma.persona
        alerta.fechaEnvio = now
        alerta.mensaje = mensaje + reforma.concepto
        alerta.controlador = "ajusteCorriente"
        alerta.accion = accion
        alerta.id_remoto = reforma.id
        if (!alerta.save(flush: true)) {
            println "error alerta: " + alerta.errors
        }
        render "OK"
    }

    def borrarAjuste_ajax () {
        println("params borrar" + params)

        def reforma = Reforma.get(params.id)
        def detalles = DetalleReforma.findAllByReforma(reforma)
        def band = 0


        if(detalles.size() > 0){
            detalles.each {d->
                try{
                    d.delete(flush: true)
                }catch(e){
                    println("error al borrar detalle del ajuste" + d.errors)
                    band ++
                }
            }
        }


        if(band == 0){
            try {
                reforma.delete(flush: true)
                render "ok"
            }catch (e){
                render "no"
                println("error al borrar reforma " + reforma.errors)
            }
        }

    }


    def nuevoAjusteCorriente () {

        def actual
        if (params.anio) {
            actual = Anio.get(params.anio)
        } else {
            actual = Anio.findByAnio(new Date().format("yyyy"))
        }

        def cn = dbConnectionService.getConnection()

        def unidad = UnidadEjecutora.get(session.unidad.id)
        def proyectos = unidad.getProyectosUnidad(actual, session.perfil.codigo.toString())

        def anios__id = cn.rows("select distinct asgn.anio__id, anioanio from asgn, anio " +
                "where mrlg__id is null and anio.anio__id = asgn.anio__id and cast(anioanio as integer) >= ${actual.anio} " +
                "order by anioanio".toString()).anio__id

        def anios = Anio.findAllByIdInList(anios__id)

        def firmas = firmasService.listaFirmasCorrientes()

        def reforma
        def detalle

        if(params.id){
            reforma = Reforma.findByIdAndTipoAndTipoSolicitud(params.id, "A", "Y")
            detalle = DetalleReforma.findAllByReforma(reforma, [sort: 'tipoReforma.id', order: 'desc'],[sort: 'id', order: 'desc'])
        }


        return [actual: actual, anios: anios, reforma: reforma, detalle: detalle, personas: firmas.directores, gerentes: firmas.gerentes]

    }

    def guardarNuevoAjusteCorriente () {
//        println("params nr " + params)
        def anio = Anio.get(params.anio)
        def estadoAval = EstadoAval.findByCodigo("P01")
        def usuario = Persona.get(session.usuario.id)

        def reforma

        if(!params.id){
            reforma = new Reforma()
            reforma.anio = anio
            reforma.concepto = params.texto
            reforma.estado = estadoAval
            reforma.persona = usuario
            reforma.tipo = 'A'
            reforma.tipoSolicitud = 'Y'
            reforma.numero = 0
            reforma.numeroReforma = 0
            reforma.fecha = new Date()

            if(!reforma.save(flush: true)){
                println("error al guardar el nuevo ajuste " + errors)
                render "no"
            } else {
                render "ok_${reforma.id}"
            }

        } else {
            //editar
//            println("entro b")

            reforma = Reforma.get(params.id)
            reforma.anio = anio
            reforma.concepto = params.texto
            reforma.estado = estadoAval
            reforma.persona = usuario
            reforma.tipo = 'A'
            reforma.tipoSolicitud = 'Y'
            reforma.numero = 0
            reforma.numeroReforma = 0
            reforma.fecha = new Date()

            if(!reforma.save(flush: true)){
                println("error al actualizar nuevo ajuste " + errors)
                render "no"
            }else{
                render "ok_${reforma.id}"
            }
        }
    }


    def origen_ajax () {
        println("params a " + params)
        def actual
        if (params.anio) {
            actual = Anio.get(params.anio)
        } else {
            actual = Anio.findByAnio(new Date().format("yyyy"))
        }

        def detalle = null
        if(params.id){
            detalle = DetalleReforma.get(params.id)
        }

        List<ObjetivoGastoCorriente> objetivos = []
        ActividadCorriente.findAllByAnio(actual).each { ac ->
            def ob = ac.macroActividad.objetivoGastoCorriente
            if (!objetivos.contains(ob)) {
                objetivos += ob
            }
        }
        objetivos.sort { it.descripcion }

        return [detalle: detalle, objetivos: objetivos]
    }

    def grabarDetalleA () {

        println("params A " + params)

        def reforma = Reforma.get(params.reforma)
        def tipoReforma = TipoReforma.findByCodigo(params.tipoReforma)
        def asignacion = Asignacion.get(params.asignacion)
        def fuente = Fuente.get(asignacion?.fuente?.id)
        def macro = MacroActividad.get(params.macro)
        def objetivo = ObjetivoGastoCorriente.get(params.objetivo)
        def acti = ActividadCorriente.get(params.actividad)
        def tar = Tarea.get(params.tarea)

        def detalleReforma
        def anio

        if(params.anio){
            anio = Anio.get(params.anio)
        }

        if(!params.id){
            //crear

            detalleReforma = new DetalleReforma()
            detalleReforma.reforma = reforma
            detalleReforma.asignacionOrigen = asignacion
            detalleReforma.tipoReforma = tipoReforma
            detalleReforma.valor = params.monto.toDouble()
            detalleReforma.valorOrigenInicial = asignacion.priorizado
            detalleReforma.valorDestinoInicial = 0
            detalleReforma.fuente = fuente
            detalleReforma.responsable = asignacion.unidad
            detalleReforma.presupuesto = asignacion.presupuesto
            detalleReforma.macroActividad = macro
            detalleReforma.objetivoGastoCorriente = objetivo
            detalleReforma.tarea = tar.id
            detalleReforma.anio = asignacion.anio

            if(params.adicional){
                detalleReforma.solicitado = params.adicional
            }
            if(!detalleReforma.save(flush: true)){
                println("error al guardar detalle de reforma A " + detalleReforma.errors);
                render "no"
            }else{
                render "ok"
            }
        }else{
            //editar

            detalleReforma = DetalleReforma.get(params.id)
            detalleReforma.reforma = reforma
            detalleReforma.asignacionOrigen = asignacion
            detalleReforma.tipoReforma = tipoReforma
            detalleReforma.valor = params.monto.toDouble()
            detalleReforma.valorOrigenInicial = asignacion.priorizado
            detalleReforma.valorDestinoInicial = 0
            detalleReforma.fuente = fuente
            detalleReforma.responsable = asignacion.unidad
            detalleReforma.presupuesto = asignacion.presupuesto
            detalleReforma.macroActividad = macro
            detalleReforma.objetivoGastoCorriente = objetivo
            detalleReforma.tarea = tar.id

            if(!detalleReforma.save(flush: true)){
                println("error al guardar detalle de reforma A " + detalleReforma.errors);
                render "no"
            }else{
                render "ok"
            }
        }
    }


    def incrementoCorriente_ajax () {

//        println("params b " + params)

        def actual
        if (params.anio) {
            actual = Anio.get(params.anio)
        } else {
            actual = Anio.findByAnio(new Date().format("yyyy"))
        }

        def detalle = null

        if (params.id) {
            detalle = DetalleReforma.get(params.id)
        }

        //objetivos

        List<ObjetivoGastoCorriente> objetivos = []
        ActividadCorriente.findAllByAnio(actual).each { ac ->
            def ob = ac.macroActividad.objetivoGastoCorriente
            if (!objetivos.contains(ob)) {
                objetivos += ob
            }
        }
        objetivos.sort { it.descripcion }

        def inc

        if(params.tipo){
            inc = "incremento"
        }

        return [detalle: detalle, objetivos: objetivos, incremento: inc]

    }

    def grabarDetalleB () {
        println("params B " + params)

        def reforma = Reforma.get(params.reforma)
        def tipoReforma = TipoReforma.findByCodigo(params.tipoReforma)
        def asignacion = Asignacion.get(params.asignacion)
        def fuente = Fuente.get(asignacion?.fuente?.id)
        def macro = MacroActividad.get(params.macro)
        def objetivo = ObjetivoGastoCorriente.get(params.objetivo)
        def acti = ActividadCorriente.get(params.actividad)
        def tar = Tarea.get(params.tarea)

        def detalleReforma
        def anio

        if(params.anio){
            anio = Anio.get(params.anio)
        }


        if(!params.id){
            //crear

            detalleReforma = new DetalleReforma()
            detalleReforma.reforma = reforma
            detalleReforma.asignacionOrigen = asignacion
            detalleReforma.tipoReforma = tipoReforma
            detalleReforma.valor = params.monto.toDouble()
            detalleReforma.valorOrigenInicial = 0
            detalleReforma.valorDestinoInicial = asignacion.priorizado
            detalleReforma.fuente = fuente
            detalleReforma.responsable = asignacion.unidad
            detalleReforma.presupuesto = asignacion.presupuesto
            detalleReforma.macroActividad = macro
            detalleReforma.objetivoGastoCorriente = objetivo
            detalleReforma.tarea = tar.id
            detalleReforma.anio = asignacion.anio

            if(!detalleReforma.save(flush: true)){
                println("error al guardar detalle de reforma B " + detalleReforma.errors);
                render "no"
            }else{
                render "ok"
            }
        }else{
            //editar

            detalleReforma = DetalleReforma.get(params.id)
            detalleReforma.reforma = reforma
            detalleReforma.asignacionOrigen = asignacion
            detalleReforma.tipoReforma = tipoReforma
            detalleReforma.valor = params.monto.toDouble()
            detalleReforma.valorOrigenInicial = 0
            detalleReforma.valorDestinoInicial = asignacion.priorizado
            detalleReforma.fuente = fuente
            detalleReforma.responsable = asignacion.unidad
            detalleReforma.presupuesto = asignacion.presupuesto
            detalleReforma.macroActividad = macro
            detalleReforma.objetivoGastoCorriente = objetivo
            detalleReforma.tarea = tar.id

            if(!detalleReforma.save(flush: true)){
                println("error al guardar detalle de reforma B " + detalleReforma.errors);
                render "no"
            }else{
                render "ok"
            }
        }
    }

    def partidaCorriente_ajax () {


        def actual
        if (params.anio) {
            actual = Anio.get(params.anio)
        } else {
            actual = Anio.findByAnio(new Date().format("yyyy"))
        }

        def unidad = UnidadEjecutora.get(session.usuario.unidad.id)
        def gerencias = firmasService.requirentes(unidad)

        def detalle = null

        if (params.id) {
            detalle = DetalleReforma.get(params.id)
        }

        //objetivos
        List<ObjetivoGastoCorriente> objetivos = []
        ActividadCorriente.findAllByAnio(actual).each { ac ->
            def ob = ac.macroActividad.objetivoGastoCorriente
            if (!objetivos.contains(ob)) {
                objetivos += ob
            }
        }
        objetivos.sort {it.descripcion}

        return [gerencias: gerencias, detalle: detalle, objetivos: objetivos]
    }


    def grabarDetalleC () {

        println("params C " + params)
//
        def reforma = Reforma.get(params.reforma)
        def tipoReforma = TipoReforma.findByCodigo(params.tipoReforma)
        def asignacion = Asignacion.get(params.asignacion)
        def macro = MacroActividad.get(params.macro)
        def objetivo = ObjetivoGastoCorriente.get(params.objetivo)
        def tar = Tarea.get(params.tarea)
        def fuente = Fuente.get(params.fuente)
        def partida = Presupuesto.get(params.partida)
        def anio
        def responsable = UnidadEjecutora.get(params.responsable)

        if(params.anio){
            anio = Anio.get(params.anio)
        }


        def detalleReforma

        if(!params.id){
            //crear

            println("crear")

            detalleReforma = new DetalleReforma()
            detalleReforma.reforma = reforma
            detalleReforma.tipoReforma = tipoReforma
            detalleReforma.valor = params.monto.toDouble()
            detalleReforma.valorOrigenInicial = 0
            detalleReforma.valorDestinoInicial = 0
            detalleReforma.fuente = fuente
            detalleReforma.presupuesto = partida
            detalleReforma.responsable = session.usuario.unidad
            detalleReforma.macroActividad = macro
            detalleReforma.objetivoGastoCorriente = objetivo
            detalleReforma.tarea = tar.id
            detalleReforma.anio = anio
            detalleReforma.responsable = responsable

            if(!detalleReforma.save(flush: true)){
                println("error al guardar detalle de reforma C  " + detalleReforma.errors);
                render "no"
            }else{
                render "ok"
            }


        }else{
            //editar

            detalleReforma = DetalleReforma.get(params.id)
            detalleReforma.reforma = reforma
            detalleReforma.tipoReforma = tipoReforma
            detalleReforma.valor = params.monto.toDouble()
            detalleReforma.valorOrigenInicial = 0
            detalleReforma.valorDestinoInicial = 0
            detalleReforma.fuente = fuente
            detalleReforma.presupuesto = partida
            detalleReforma.responsable = session.usuario.unidad
            detalleReforma.macroActividad = macro
            detalleReforma.objetivoGastoCorriente = objetivo
            detalleReforma.tarea = tar.id
            detalleReforma.responsable = responsable

            if(!detalleReforma.save(flush: true)){
                println("error al guardar detalle de reforma C  " + detalleReforma.errors);
                render "no"
            }else{
                render "ok"
            }
        }
    }



    def saveNuevoAjusteCorriente_ajax () {

        println("save nuevo ajuste corriente " + params)

        def anio = Anio.get(params.anio.toLong())
        def personaFirma1, personaFirma2

        def estado = EstadoAval.findByCodigo("P01") //pendiente
        if (params.send == "S") {
            estado = EstadoAval.findByCodigo("EF1") //aprobado sin firma
        }

        def now = new Date()
        def usu = Persona.get(session.usuario.id)
        def reforma

        if (params.id) {
            reforma = Reforma.get(params.id)
            personaFirma1 = reforma.firma1?.usuario
            personaFirma2 = reforma.firma2?.usuario

            if(!personaFirma1){
                personaFirma1 = Persona.get(params.firma1.toLong())
            }
            if(!personaFirma2){
                personaFirma2 = Persona.get(params.firma2.toLong())
            }
        }

        reforma.anio = anio
        reforma.persona = usu
        reforma.analista = usu
        reforma.estado = estado
        reforma.concepto = params.concepto.trim()
        reforma.fecha = now
        reforma.tipo = "A"
        reforma.tipoSolicitud = "Y"
        if (!reforma.save(flush: true)) {
            println ("error al guardar el ajuste corriente: " + reforma.errors)
            render "ERROR*" + renderErrors(bean: reforma)
            return
        }

        def tipoStr = elm.tipoReformaStr(tipo: 'Ajuste', tipoSolicitud: reforma.tipoSolicitud)

        if (params.send == "S") {
            println "nuevo ajuste: se hace la alerta y se manda mail, se crean las firmas"
            if (params.id && reforma.firma1 && reforma.firma2) {
                def firma1 = reforma.firma1
                firma1.estado = "S"
                firma1.save(flush: true)
                def firma2 = reforma.firma2
                firma2.estado = "S"
                firma2.save(flush: true)
            } else {
                def firma1 = new Firma()
                firma1.usuario = personaFirma1
                firma1.fecha = now
                firma1.accion = "firmarAprobarNuevoAjusteCorriente"
                firma1.controlador = "ajusteCorriente"
                firma1.idAccion = reforma.id
                firma1.accionVer = "ajusteGp"
                firma1.controladorVer = "reportesReforma"
                firma1.idAccionVer = reforma.id
                firma1.accionNegar = "devolverAprobarAjusteCorriente"
                firma1.controladorNegar = "ajusteCorriente"
                firma1.idAccionNegar = reforma.id
                firma1.concepto = "${tipoStr} (${now.format('dd-MM-yyyy')}): " + reforma.concepto
                firma1.tipoFirma = "AJSC"
                if (!firma1.save(flush: true)) {
                    println "error al crear firma1: " + firma1.errors
                    render "ERROR*" + renderErrors(bean: firma1)
                    return
                }
                def firma2 = new Firma()
                firma2.usuario = personaFirma2
                firma2.fecha = now
                firma2.accion = "firmarAprobarNuevoAjusteCorriente"
                firma2.controlador = "ajusteCorriente"
                firma2.idAccion = reforma.id
                firma2.accionVer = "ajusteGp"
                firma2.controladorVer = "reportesReforma"
                firma2.idAccionVer = reforma.id
                firma2.accionNegar = "devolverAprobarAjusteCorriente"
                firma2.controladorNegar = "ajusteCorriente"
                firma2.idAccionNegar = reforma.id
                firma2.concepto = "${tipoStr} (${now.format('dd-MM-yyyy')}): " + reforma.concepto
                firma2.tipoFirma = "AJSC"
                if (!firma2.save(flush: true)) {
                    println "error al crear firma2: " + firma2.errors
                    render "ERROR*" + renderErrors(bean: firma2)
                    return
                }
                reforma.firma1 = firma1
                reforma.firma2 = firma2
                reforma.save(flush: true)
            }
            def alerta1 = new Alerta()
            alerta1.from = usu
            alerta1.persona = personaFirma1
            alerta1.fechaEnvio = now
            alerta1.mensaje = "${tipoStr} (${now.format('dd-MM-yyyy')}): " + reforma.concepto
            alerta1.controlador = "firma"
            alerta1.accion = "firmasPendientes"
            alerta1.id_remoto = reforma.id
            if (!alerta1.save(flush: true)) {
                println "error alerta: " + alerta1.errors
            }
            def alerta2 = new Alerta()
            alerta2.from = usu
            alerta2.persona = personaFirma2
            alerta2.fechaEnvio = now
            alerta2.mensaje = "${tipoStr} (${now.format('dd-MM-yyyy')}): " + reforma.concepto
            alerta2.controlador = "firma"
            alerta2.accion = "firmasPendientes"
            alerta2.id_remoto = reforma.id
            if (!alerta2.save(flush: true)) {
                println "error alerta: " + alerta2.errors
            }
        } else {
            println "no se manda: no se hace alerta ni se manda mail ni se hacen firmas"
        }

        def errores = ""

        if (errores == "") {
            if (params.send == "S") {
                render "SUCCESS*Ajuste de gasto permanente solicitado exitosamente"
            } else {
                render "SUCCESS*Ajuste de gasto permanente guardado exitosamente*" + reforma.id
            }
        } else {
            render "ERROR*" + errores
        }
    }

    /**
     * Acción para firmar la aprobación de la reforma
     */
    def firmarAprobarNuevoAjusteCorriente() {
        println ("firmarAprobarNuevoAjusteCorriente params " + params)
        def firma = Firma.findByKey(params.key)
        if (!firma) {
            response.sendError(403)
        } else {
            def reforma = Reforma.findByFirma1OrFirma2(firma, firma)
            if (reforma.firma1.estado == "F" && reforma.firma2.estado == "F") {
                //busco el ultimo numero asignado para signar el siguiente
                def ultimoNum = Reforma.withCriteria {
                    eq("tipo", "A")
                    eq("tipoSolicitud", "Y")
                    projections {
                        max "numero"
                    }
                }

                def num = 1
                if (ultimoNum && ultimoNum.size() == 1) {
                    num = ultimoNum.first() + 1
                }

                def estadoAprobado = EstadoAval.findByCodigo("E02")
                reforma.estado = estadoAprobado
                reforma.numero = num
                reforma.save(flush: true)
                def usu = Persona.get(session.usuario.id)
                def now = new Date()
                def errores = ""
                def detalles = DetalleReforma.findAllByReforma(reforma)

                detalles.each { d->
                    println "..procesa id: ${d.id}, tipo: ${d?.tipoReforma?.codigo}"
                    switch (d?.tipoReforma?.codigo){
                        case "O":  //asignacion origen
//                           println("entro origen")
                            def modificacionOrigen = new ModificacionAsignacion()
                            modificacionOrigen.usuario = usu
                            modificacionOrigen.desde = d?.asignacionOrigen
                            modificacionOrigen.fecha = now
                            modificacionOrigen.valor = d?.valor
                            modificacionOrigen.estado = 'A'
                            modificacionOrigen.detalleReforma = d
                            modificacionOrigen.originalOrigen = d?.asignacionOrigen?.priorizado

                            if (!modificacionOrigen.save(flush: true)) {
                                println "error al guardar modificacion tipo O: " + modificacionOrigen.errors
                                errores += renderErrors(bean: modificacionOrigen)
                            } else {

                                def asig = Asignacion.get(d?.asignacionOrigen?.id)
                                asig?.priorizado -= d?.valor
                                if (!asig.save(flush: true)) {
                                    println "error al guardar origen O: " + asig.errors
                                    errores += renderErrors(bean: asig)
                                }
                            }
                            break;

                        case "E":  //incremento
//                           println("entro incremento")
                            def modificacionIncremento = new ModificacionAsignacion()
                            modificacionIncremento.usuario = usu
                            modificacionIncremento.recibe = d?.asignacionOrigen
                            modificacionIncremento.fecha = now
                            modificacionIncremento.valor = d?.valor
                            modificacionIncremento.estado = 'A'
                            modificacionIncremento.detalleReforma = d
                            modificacionIncremento.originalDestino = d?.asignacionOrigen?.priorizado

                            if (!modificacionIncremento.save(flush: true)) {
                                println "error al guardar modificacion tipo E: " + modificacionIncremento.errors
                                errores += renderErrors(bean: modificacionIncremento)
                            } else {
                                def asigDestino = Asignacion.get(d?.asignacionOrigen?.id)
                                asigDestino?.priorizado += d?.valor
                                if (!asigDestino.save(flush: true)) {
                                    println "error al guardar origen E: " + asigDestino.errors
                                    errores += renderErrors(bean: asigDestino)
                                }
                            }
                            break;
                        case "P": //partida - priorizado original en 0, valor ingresado en priorizado, no tiene padre
//                           println("entro partida")
                            def nuevaPartida = new Asignacion()
//                           nuevaPartida.anio = reforma.anio
                            nuevaPartida.anio = d?.anio
                            nuevaPartida.fuente = d?.fuente
                            nuevaPartida.tarea  = Tarea.get(d?.tarea)
                            nuevaPartida.marcoLogico = d?.componente
                            nuevaPartida.presupuesto = d?.presupuesto
                            nuevaPartida.planificado = 0
                            nuevaPartida.priorizadoOriginal = 0
                            nuevaPartida.unidad = d?.responsable
                            nuevaPartida.priorizado = d?.valor
                            if (!nuevaPartida.save(flush: true)) {
                                println "error al guardar la nueva partida   " + nuevaPartida.errors
                                errores += renderErrors(bean: nuevaPartida)
                                nuevaPartida = null
                            }else{

                                def modificacionPartida = new ModificacionAsignacion()
                                modificacionPartida.usuario = usu
                                modificacionPartida.recibe = nuevaPartida
                                modificacionPartida.fecha = now
                                modificacionPartida.valor = d?.valor
                                modificacionPartida.estado = 'A'
                                modificacionPartida.detalleReforma = d
                                modificacionPartida.originalDestino = 0

                                if (!modificacionPartida.save(flush: true)) {
                                    println "error al guardar modificacion tipo P: " + modificacionPartida.errors
                                    errores += renderErrors(bean: modificacionPartida)
                                } else {
//                                    render "ok"
                                }
                            }
                            break;
                    }
                }
            }
            render "ok"
        }
    }


    /**
     * Acción para devolver la solicitud de reforma al analista de planificación
     */
    def devolverAprobarAjusteCorriente() {
        def now = new Date()
        def usu = Persona.get(session.usuario.id)

        def reforma = Reforma.get(params.id)
        reforma.estado = EstadoAval.findByCodigo("D03") //devuelto al analista
        reforma.save(flush: true)

        reforma.firma1.estado = "N"
        reforma.firma2.estado = "N"
        reforma.firma1.save(flush: true)
        reforma.firma2.save(flush: true)

        def tipoStr = elm.tipoReformaStr(tipo: 'Ajuste', tipoSolicitud: reforma.tipoSolicitud)
        def accion
        def mensaje = "Devolución de ${tipoStr}"
        //E: existente, A: actividad, P: partida
        switch (reforma.tipoSolicitud) {
            case "E":
//                accion = "existente"
                accion = "nuevoAjusteCorriente"
//                mensaje = "Devolución de ${tipoStr}: "
                break;
            case "A":
                accion = "actividad"
//                mensaje = "Devolución de ${tipoStr}: "
                break;
            case "P":
                accion = "partida"
//                mensaje = "Devolución de ${tipoStr}: "
                break;
            default:
//                accion = "existente"
                accion = "nuevoAjusteCorriente"
//                mensaje = "Devolución de ${tipoStr}: "
        }

        def alerta = new Alerta()
        alerta.from = usu
        alerta.persona = reforma.persona
        alerta.fechaEnvio = now
        alerta.mensaje = mensaje + reforma.concepto
        alerta.controlador = "ajusteCorriente"
        alerta.accion = accion
        alerta.id_remoto = reforma.id
        if (!alerta.save(flush: true)) {
            println "error alerta: " + alerta.errors
        }
        render "OK"
    }


    def borrarReforma_ajax () {
        def reforma = Reforma.get(params.id)
//        println("reforma " +  reforma)
        def detalleReforma = DetalleReforma.findAllByReforma(reforma)
        if(!detalleReforma){
            reforma.delete(flush: true)
            render "ok"
        }else{
            render "no"
        }
    }

    /**
     * Acción llamada con ajax que calcula el monto máximo que se le puede dar a una asignación GP
     *   ********* se debe usar en lugar de Avalcorriente.getMaximoAsg
     * @param id el id de la asignación
     * @Renders el monto priorizado menos el monto utilizado
     *
     */
    def maximoAsgGP = {
        println "params maximoAsgGP $params"
        def asg = Asignacion.get(params.id)
        def monto = asg?.priorizado?:0
        def usado = 0;
        def estadoPendiente = EstadoAval.findByCodigo("P01")
        def estadoPorRevisar = EstadoAval.findByCodigo("R01")
        def estadoSolicitado = EstadoAval.findByCodigo("E01")
        def estadoLiberado = EstadoAval.findByCodigo("E05")
        def estadoSolicitadoSinFirma = EstadoAval.findByCodigo("EF4")
        def estadoAprobadoSinFirma = EstadoAval.findByCodigo("EF1")
        def estados = [estadoPendiente, estadoPorRevisar, estadoSolicitado, estadoSolicitadoSinFirma, estadoAprobadoSinFirma]
        def tprf = TipoReforma.findByCodigo("E")

        ProcesoAsignacion.findAllByAsignacion(asg).each {
            if(it.avalCorriente.estado?.id == estadoLiberado.id){
                usado += it.liberado
            }else{
                usado += it.monto
            }

            //toma en cuenta el poas de la solicitud actual
            if(it.avalCorriente.id == params?.avalCorriente?.toInteger()){
                usado += it.monto
            }
        }

        def locked = 0
        def detalles = DetalleReforma.withCriteria {   // reformas en proceso con disminución de recuros tprf = 'E'
            reforma {
                inList("estado", estados)
            }
            eq("asignacionOrigen", asg)
            eq("tipoReforma", tprf)
            eq("presupuesto", asg?.presupuesto)
        }
        if (detalles.size() > 0) {
            locked = detalles.sum { it.valor }
        }
//        println "regormas: ${detalles.reforma.id}"
        def disponible = monto - usado - locked
        disponible = Math.round(disponible * 100)/100

        println "get Maximo asgn $params  monto: $monto  usado: $usado reformas: $locked disponible: $disponible"
        render "" + (disponible)
    }



}
