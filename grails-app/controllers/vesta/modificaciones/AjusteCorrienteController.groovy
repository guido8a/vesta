package vesta.modificaciones

import vesta.alertas.Alerta
import vesta.avales.EstadoAval
import vesta.parametros.TipoElemento
import vesta.parametros.UnidadEjecutora
import vesta.parametros.poaPac.Anio
import vesta.parametros.poaPac.Presupuesto
import vesta.poa.Asignacion
import vesta.poaCorrientes.ActividadCorriente
import vesta.poaCorrientes.ObjetivoGastoCorriente
import vesta.proyectos.MarcoLogico
import vesta.proyectos.ModificacionAsignacion
import vesta.seguridad.Firma
import vesta.seguridad.Persona

class AjusteCorrienteController {

    def firmasService

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
            eq("tipo", "C")
            persona {
                inList("unidad", unidadesReales)
                order("unidad", "asc")
            }
            order("fecha", "desc")
        }
        return [reformas: reformas, unidad: unidadPersona]
    }

    /**
     * Acción que muestra la lista de las reformas solicitadas para q un analista de planificación apruebe y pida firmas o niegue
     */
    def pendientes() {
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
            eq("tipo", "C")
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

        return [reformas: reformas, actual: actual, unidades: unidadesList]
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

        def firmas = firmasService.listaFirmasCombos()

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
        def firmas = firmasService.listaFirmasCombos()
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
            alerta1.id_remoto = 0
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
            alerta1.id_remoto = 0
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

}
