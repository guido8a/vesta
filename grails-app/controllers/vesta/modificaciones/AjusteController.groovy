package vesta.modificaciones

import vesta.alertas.Alerta
import vesta.avales.EstadoAval
import vesta.parametros.TipoElemento
import vesta.parametros.UnidadEjecutora
import vesta.parametros.poaPac.Anio
import vesta.parametros.poaPac.Fuente
import vesta.parametros.poaPac.Presupuesto
import vesta.poa.Asignacion
import vesta.proyectos.Categoria
import vesta.proyectos.MarcoLogico
import vesta.proyectos.ModificacionAsignacion
import vesta.proyectos.Proyecto
import vesta.seguridad.Firma
import vesta.seguridad.Persona
import vesta.seguridad.Shield

class AjusteController extends Shield {
    /**
     * Acción que muestra los diferentes tipos de reforma posibles y permite seleccionar uno para comenzar el proceso
     */
    def ajustes() {

    }

    /**
     * Acción que muestra la lista de todos las reformas, con su estado y una opción para ver el pdf
     */
    def lista() {
        def reformas = Reforma.findAllByTipo('A', [sort: "fecha", order: "desc"])
        return [reformas: reformas]
    }

    /**
     * Acción que permite realizar una solicitud de reforma a asignaciones existentes
     */
    def existente() {
        def proyectos = []
        def actual
        Asignacion.list().each {
//            println "p "+proyectos
            def p = it.marcoLogico.proyecto
            if (!proyectos?.id.contains(p.id)) {
                proyectos.add(p)
            }
        }
        if (params.anio) {
            actual = Anio.get(params.anio)
        } else {
            actual = Anio.findByAnio(new Date().format("yyyy"))
        }

        proyectos = proyectos.sort { it.nombre }

        def proyectos2 = Proyecto.findAllByAprobadoPoa('S', [sort: 'nombre'])

        def proyectos3 = Proyecto.findAllByAprobadoPoa('S', [sort: 'nombre'])

        def campos = ["numero": ["Número", "string"], "descripcion": ["Descripción", "string"]]
//        println "pro "+proyectos
        def unidad = UnidadEjecutora.findByCodigo("DPI") // DIRECCIÓN DE PLANIFICACIÓN E INVERSIÓN
        def personasFirmas = Persona.findAllByUnidad(unidad)
        def gerentes = Persona.findAllByUnidad(unidad.padre)

        def total = 0

        def reforma = null, detalles = [], editable = true
        if (params.id) {
            editable = false
            reforma = Reforma.get(params.id)
            detalles = DetalleReforma.findAllByReforma(reforma)
            def solicitadoSinFirma = EstadoAval.findByCodigo("EF4")
            def devuelto = EstadoAval.findByCodigo("D02")
            def estados = [solicitadoSinFirma, devuelto]
            if (estados.contains(reforma.estado)) {
                editable = true
            }
            if (detalles.size() > 0) {
                total = detalles.sum { it.valor }
            }
        }

        return [proyectos: proyectos3, proyectos2: proyectos3, actual: actual, campos: campos, personas: gerentes + personasFirmas,
                gerentes : gerentes, total: total, editable: editable, reforma: reforma, detalles: detalles]
    }

    /**
     * Acción que permite realizar una solicitud de reforma a nueva partida
     */
    def partida() {
        def proyectos = []
        def actual
        Asignacion.list().each {
//            println "p "+proyectos
            def p = it.marcoLogico.proyecto
            if (!proyectos?.id.contains(p.id)) {
                proyectos.add(p)
            }
        }
        if (params.anio) {
            actual = Anio.get(params.anio)
        } else {
            actual = Anio.findByAnio(new Date().format("yyyy"))
        }

        proyectos = proyectos.sort { it.nombre }

        def proyectos2 = Proyecto.findAllByAprobadoPoa('S', [sort: 'nombre'])

        def proyectos3 = Proyecto.findAllByAprobadoPoa('S', [sort: 'nombre'])

        def campos = ["numero": ["Número", "string"], "descripcion": ["Descripción", "string"]]
//        println "pro "+proyectos
        def unidad = UnidadEjecutora.findByCodigo("DPI") // DIRECCIÓN DE PLANIFICACIÓN E INVERSIÓN
        def personasFirmas = Persona.findAllByUnidad(unidad)
        def gerentes = Persona.findAllByUnidad(unidad.padre)

        def total = 0

        def reforma = null, detalles = [], editable = true
        if (params.id) {
            editable = false
            reforma = Reforma.get(params.id)
            detalles = DetalleReforma.findAllByReforma(reforma)
            def solicitadoSinFirma = EstadoAval.findByCodigo("EF4")
            def devuelto = EstadoAval.findByCodigo("D02")
            def estados = [solicitadoSinFirma, devuelto]
            if (estados.contains(reforma.estado)) {
                editable = true
            }
            if (detalles.size() > 0) {
                total = detalles.sum { it.valor }
            }
        }

        return [proyectos: proyectos3, proyectos2: proyectos3, actual: actual, campos: campos, personas: gerentes + personasFirmas,
                gerentes : gerentes, total: total, editable: editable, reforma: reforma, detalles: detalles]
    }

    /**
     * Acción que permite realizar una solicitud de reforma a nueva actividad
     */
    def actividad() {
        def proyectos = []
        def actual
        Asignacion.list().each {
//            println "p "+proyectos
            def p = it.marcoLogico.proyecto
            if (!proyectos?.id.contains(p.id)) {
                proyectos.add(p)
            }
        }
        if (params.anio) {
            actual = Anio.get(params.anio)
        } else {
            actual = Anio.findByAnio(new Date().format("yyyy"))
        }

        proyectos = proyectos.sort { it.nombre }

        def proyectos2 = Proyecto.findAllByAprobadoPoa('S', [sort: 'nombre'])

        def proyectos3 = Proyecto.findAllByAprobadoPoaAndUnidadAdministradora('S', session.unidad, [sort: 'nombre'])

        def campos = ["numero": ["Número", "string"], "descripcion": ["Descripción", "string"]]
//        println "pro "+proyectos
        def unidad = UnidadEjecutora.findByCodigo("DPI") // DIRECCIÓN DE PLANIFICACIÓN E INVERSIÓN
        def personasFirmas = Persona.findAllByUnidad(unidad)
        def gerentes = Persona.findAllByUnidad(unidad.padre)

        def total = 0

        def reforma = null, detalles = [], editable = true
        if (params.id) {
            editable = false
            reforma = Reforma.get(params.id)
            detalles = DetalleReforma.findAllByReforma(reforma)
            def solicitadoSinFirma = EstadoAval.findByCodigo("EF4")
            def devuelto = EstadoAval.findByCodigo("D01")
            def estados = [solicitadoSinFirma, devuelto]
            if (estados.contains(reforma.estado)) {
                editable = true
            }
            if (detalles.size() > 0) {
                total = detalles.sum { it.valor }
            }
        }

        return [proyectos      : proyectos3, proyectos2: proyectos3, actual: actual, campos: campos, personas: gerentes + personasFirmas,
                personasGerente: gerentes, total: total, editable: editable, reforma: reforma, detalles: detalles, unidad: UnidadEjecutora.get(session.unidad.id)]
    }

    /**
     * Acción llamada con ajax que guarda una solicitud de reforma de asignaciones existentes
     */
    def saveExistente_ajax() {
        def anio = Anio.get(params.anio.toLong())
        def personaFirma1, personaFirma2
        def aprobadoSinFirma = EstadoAval.findByCodigo("EF1")

        def now = new Date()
        def usu = Persona.get(session.usuario.id)

        def reforma
        if (params.id) {
            reforma = Reforma.get(params.id)
            if (!reforma) {
                reforma = new Reforma()
            }
            personaFirma1 = reforma.firma1.usuario
            personaFirma2 = reforma.firma2.usuario
        } else {
            reforma = new Reforma()
            personaFirma1 = Persona.get(params.firma1.toLong())
            personaFirma2 = Persona.get(params.firma2.toLong())
        }

        reforma.anio = anio
        reforma.persona = usu
        reforma.analista = usu
        reforma.estado = aprobadoSinFirma
        reforma.concepto = params.concepto.trim()
        reforma.fecha = now
        reforma.tipo = "A"
        reforma.tipoSolicitud = "E"
        if (!reforma.save(flush: true)) {
            println "error al crear el ajuste: " + reforma.errors
            render "ERROR*" + renderErrors(bean: reforma)
            return
        }

        if (params.id) {
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
            firma1.controlador = "ajuste"
            firma1.idAccion = reforma.id
            firma1.accionVer = "existente"
            firma1.controladorVer = "reportesReforma"
            firma1.idAccionVer = reforma.id
            firma1.accionNegar = "devolverAprobarAjuste"
            firma1.controladorNegar = "ajuste"
            firma1.idAccionNegar = reforma.id
            firma1.concepto = "Ajuste a asignaciones existentes (${now.format('dd-MM-yyyy')}): " + reforma.concepto
            firma1.tipoFirma = "AJST"
            if (!firma1.save(flush: true)) {
                println "error al crear firma1: " + firma1.errors
                render "ERROR*" + renderErrors(bean: firma1)
                return
            }
            def firma2 = new Firma()
            firma2.usuario = personaFirma2
            firma2.fecha = now
            firma2.accion = "firmarAprobarAjuste"
            firma2.controlador = "ajuste"
            firma2.idAccion = reforma.id
            firma2.accionVer = "existente"
            firma2.controladorVer = "reportesReforma"
            firma2.idAccionVer = reforma.id
            firma1.accionNegar = "devolverAprobarAjuste"
            firma2.controladorNegar = "ajuste"
            firma2.idAccionNegar = reforma.id
            firma2.concepto = "Ajuste a asignaciones existentes (${now.format('dd-MM-yyyy')}): " + reforma.concepto
            firma2.tipoFirma = "AJST"
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
        alerta1.mensaje = "Ajuste a asignaciones existentes (${now.format('dd-MM-yyyy')}): " + reforma.concepto
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
        alerta2.mensaje = "Ajuste a asignaciones existentes (${now.format('dd-MM-yyyy')}): " + reforma.concepto
        alerta2.controlador = "firma"
        alerta2.accion = "firmasPendientes"
        alerta2.id_remoto = 0
        if (!alerta2.save(flush: true)) {
            println "error alerta: " + alerta2.errors
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
                    if (!detalle.save(flush: true)) {
                        println "error al guardar detalle: " + detalle.errors
                        errores += renderErrors(bean: detalle)
                    }
                }
            }
        }
        if (errores == "") {
            render "SUCCESS*Ajuste solicitado exitosamente"
        } else {
            render "ERROR*" + errores
        }
    }

    /**
     * Acción llamada con ajax que guarda una solicitud de reforma de nueva actividad
     */
    def saveActividad_ajax() {
//        println params
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
        def personaRevisa
        def solicitadoSinFirma = EstadoAval.findByCodigo("EF4")

        def now = new Date()
        def usu = Persona.get(session.usuario.id)

        def reforma
        if (params.id) {
            reforma = Reforma.get(params.id)
            if (!reforma) {
                reforma = new Reforma()
            }
            personaRevisa = reforma.firmaSolicitud.usuario
        } else {
            reforma = new Reforma()
            personaRevisa = Persona.get(params.firma.toLong())
        }

        reforma.anio = anio
        reforma.persona = usu
        reforma.estado = solicitadoSinFirma
        reforma.concepto = params.concepto.trim()
        reforma.fecha = now
        reforma.tipo = "R"
        reforma.tipoSolicitud = "A"
        if (!reforma.save(flush: true)) {
            println "error al crear la reforma: " + reforma.errors
            render "ERROR*" + renderErrors(bean: reforma)
            return
        }

        if (params.id) {
            def firmaRevisa = reforma.firmaSolicitud
            firmaRevisa.estado = "S"
            firmaRevisa.save(flush: true)
        } else {
            def firmaRevisa = new Firma()
            firmaRevisa.usuario = personaRevisa
            firmaRevisa.fecha = now
            firmaRevisa.accion = "firmarReforma"
            firmaRevisa.controlador = "reforma"
            firmaRevisa.idAccion = reforma.id
            firmaRevisa.accionVer = "actividad"
            firmaRevisa.controladorVer = "reportesReforma"
            firmaRevisa.idAccionVer = reforma.id
            firmaRevisa.accionNegar = "devolverReforma"
            firmaRevisa.controladorNegar = "reforma"
            firmaRevisa.idAccionNegar = reforma.id
            firmaRevisa.concepto = "Reforma a nuevas actividades (${now.format('dd-MM-yyyy')}): " + reforma.concepto
            firmaRevisa.tipoFirma = "RFRM"
            if (!firmaRevisa.save(flush: true)) {
                println "error al crear firma: " + firmaRevisa.errors
                render "ERROR*" + renderErrors(bean: firmaRevisa)
                return
            }
            reforma.firmaSolicitud = firmaRevisa
            reforma.save(flush: true)
        }
        def alerta = new Alerta()
        alerta.from = usu
        alerta.persona = personaRevisa
        alerta.fechaEnvio = now
        alerta.mensaje = "Solicitud de reforma a nuevas actividades (${now.format('dd-MM-yyyy')}): " + reforma.concepto
        alerta.controlador = "firma"
        alerta.accion = "firmasPendientes"
        alerta.id_remoto = 0
        if (!alerta.save(flush: true)) {
            println "error alerta: " + alerta.errors
        }

        def errores = ""
        detalles.each { k, det ->
            def monto = det.monto.replaceAll(",", "").toDouble()

            def asignacionOrigen = Asignacion.get(det.origen.toLong())
            def presupuesto = Presupuesto.get(det.partida.toLong())
            def componente = MarcoLogico.get(det.componente.toLong())

            def detalle = new DetalleReforma()
            detalle.reforma = reforma
            detalle.asignacionOrigen = asignacionOrigen
            detalle.valor = monto
            detalle.presupuesto = presupuesto
            detalle.componente = componente
            detalle.descripcionNuevaActividad = det.actividad.trim()
            detalle.fechaInicioNuevaActividad = new Date().parse("dd-MM-yyyy", det.inicio)
            detalle.fechaFinNuevaActividad = new Date().parse("dd-MM-yyyy", det.fin)
            detalle.categoria = Categoria.get(det.categoria.toLong())

            if (!detalle.save(flush: true)) {
                println "error al guardar detalle: " + detalle.errors
                errores += renderErrors(bean: detalle)
            }
        }
        if (errores == "") {
            render "SUCCESS*Reforma solicitada exitosamente"
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
        def solicitadoSinFirma = EstadoAval.findByCodigo("EF4")

        def now = new Date()
        def usu = Persona.get(session.usuario.id)

        def reforma
        if (params.id) {
            reforma = Reforma.get(params.id)
            if (!reforma) {
                reforma = new Reforma()
            }
            personaFirma1 = reforma.firma1.usuario
            personaFirma2 = reforma.firma2.usuario
        } else {
            reforma = new Reforma()
            personaFirma1 = Persona.get(params.firma1.toLong())
            personaFirma2 = Persona.get(params.firma2.toLong())
        }

        reforma.anio = anio
        reforma.persona = usu
        reforma.analista = usu
        reforma.estado = solicitadoSinFirma
        reforma.concepto = params.concepto.trim()
        reforma.fecha = now
        reforma.tipo = "A"
        reforma.tipoSolicitud = "P"
        if (!reforma.save(flush: true)) {
            println "error al crear el ajuste: " + reforma.errors
            render "ERROR*" + renderErrors(bean: reforma)
            return
        }

        if (params.id) {
            def firma1 = reforma.firma1
            firma1.estado = "S"
            firma1.save(flush: true)
        } else {
            def firma1 = new Firma()
            firma1.usuario = personaFirma1
            firma1.fecha = now
            firma1.accion = "firmarAprobarAjuste"
            firma1.controlador = "ajuste"
            firma1.idAccion = reforma.id
            firma1.accionVer = "partida"
            firma1.controladorVer = "reportesReforma"
            firma1.idAccionVer = reforma.id
            firma1.accionNegar = "devolverAprobarAjuste"
            firma1.controladorNegar = "ajuste"
            firma1.idAccionNegar = reforma.id
            firma1.concepto = "Ajuste a nuevas partidas (${now.format('dd-MM-yyyy')}): " + reforma.concepto
            firma1.tipoFirma = "AJST"
            if (!firma1.save(flush: true)) {
                println "error al crear firma1: " + firma1.errors
                render "ERROR*" + renderErrors(bean: firma1)
                return
            }
            def firma2 = new Firma()
            firma2.usuario = personaFirma2
            firma2.fecha = now
            firma2.accion = "firmarAprobarAjuste"
            firma2.controlador = "ajuste"
            firma2.idAccion = reforma.id
            firma2.accionVer = "partida"
            firma2.controladorVer = "reportesReforma"
            firma2.idAccionVer = reforma.id
            firma2.accionNegar = "devolverAprobarAjuste"
            firma2.controladorNegar = "ajuste"
            firma2.idAccionNegar = reforma.id
            firma2.concepto = "Ajuste a nuevas partidas (${now.format('dd-MM-yyyy')}): " + reforma.concepto
            firma2.tipoFirma = "AJST"
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
        alerta1.mensaje = "Ajuste a nuevas partidas (${now.format('dd-MM-yyyy')}): " + reforma.concepto
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
        alerta2.mensaje = "Ajuste a nuevas partidas (${now.format('dd-MM-yyyy')}): " + reforma.concepto
        alerta2.controlador = "firma"
        alerta2.accion = "firmasPendientes"
        alerta2.id_remoto = 0
        if (!alerta2.save(flush: true)) {
            println "error alerta: " + alerta2.errors
        }
//          [r1:[monto:500.00, origen:322, partida:218, fuente:9], r0:[origen:322, fuente:9, partida:223, monto:150.00]]
        def errores = ""
        detalles.each { k, det ->
            def monto = det.monto.replaceAll(",", "").toDouble()

            def asignacionOrigen = Asignacion.get(det.origen.toLong())
            def presupuesto = Presupuesto.get(det.partida.toLong())
            def fuente = Fuente.get(det.fuente.toLong())

            def detalle = new DetalleReforma()
            detalle.reforma = reforma
            detalle.asignacionOrigen = asignacionOrigen
            detalle.valor = monto
            detalle.presupuesto = presupuesto
            detalle.fuente = fuente

            if (!detalle.save(flush: true)) {
                println "error al guardar detalle: " + detalle.errors
                errores += renderErrors(bean: detalle)
            }
        }
        if (errores == "") {
            render "SUCCESS*Ajuste solicitado exitosamente"
        } else {
            render "ERROR*" + errores
        }
    }

    /**
     * Acción para firmar la aprobación de la reforma
     */
    def firmarAprobarAjuste() {
        def firma = Firma.findByKey(params.key)
        if (!firma) {
            response.sendError(403)
        } else {
            def reforma = Reforma.findByFirma1OrFirma2(firma, firma)
            if (reforma.firma1.estado == "F" && reforma.firma2.estado == "F") {
                //busco el ultimo numero asignado para signar el siguiente
                def ultimoNum = Reforma.withCriteria {
                    eq("tipo", "A")
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
                detalles.each { detalle ->
                    def origen = detalle.asignacionOrigen
                    def destino
                    //E: existente, A: actividad, P: partida, I: incremento
                    switch (reforma.tipoSolicitud) {
                        case "E":
                            destino = detalle.asignacionDestino
                            break;
                        case "A":
                            //busco el ultimo numero asignado para signar el siguiente
                            def ultimoNumAct = MarcoLogico.withCriteria {
                                projections {
                                    max "numero"
                                }
                            }

                            def numAct = 1
                            if (ultimoNumAct && ultimoNumAct.size() == 1) {
                                numAct = ultimoNumAct.first() + 1
                            }

                            def nuevaActividad = new MarcoLogico()
                            nuevaActividad.proyecto = detalle.componente.proyecto
                            nuevaActividad.tipoElemento = TipoElemento.get(3)
                            nuevaActividad.marcoLogico = detalle.componente
                            nuevaActividad.objeto = detalle.descripcionNuevaActividad
                            nuevaActividad.monto = detalle.valor
                            nuevaActividad.estado = 0
                            nuevaActividad.categoria = detalle.categoria
                            nuevaActividad.fechaInicio = detalle.fechaInicioNuevaActividad
                            nuevaActividad.fechaFin = detalle.fechaFinNuevaActividad
                            nuevaActividad.responsable = reforma.persona.unidad
                            nuevaActividad.numero = numAct

                            if (!nuevaActividad.save(flush: true)) {
                                println "error al guardar la actividad (A) " + nuevaActividad.errors
                                errores += renderErrors(bean: nuevaActividad)
                            } else {
                                destino = new Asignacion()
                                destino.anio = reforma.anio
                                destino.fuente = origen.fuente
                                destino.marcoLogico = nuevaActividad
                                destino.presupuesto = detalle.presupuesto
                                destino.planificado = detalle.valor
                                destino.unidad = nuevaActividad.responsable
                                destino.priorizado = 0
                                if (!destino.save(flush: true)) {
                                    println "error al guardar la asignacion (A) " + destino.errors
                                    errores += renderErrors(bean: destino)
                                    destino = null
                                }
                            }
                            break;
                        case "P":
                            destino = new Asignacion()
                            destino.anio = reforma.anio
                            destino.fuente = origen.fuente
                            destino.marcoLogico = origen.marcoLogico
                            destino.presupuesto = detalle.presupuesto
                            destino.planificado = detalle.valor
                            destino.unidad = origen.marcoLogico.responsable
                            destino.priorizado = 0
                            if (!destino.save(flush: true)) {
                                println "error al guardar la asignacion (P) " + destino.errors
                                errores += renderErrors(bean: destino)
                                destino = null
                            }
                            break;
                    }
                    if (origen && destino) {
                        def modificacion = new ModificacionAsignacion()
                        modificacion.usuario = usu
                        modificacion.desde = origen
                        modificacion.recibe = destino
                        modificacion.fecha = now
                        modificacion.valor = detalle.valor
                        modificacion.estado = 'A'
                        modificacion.detalleReforma = detalle
                        if (!modificacion.save(flush: true)) {
                            println "error save modificacion: " + modificacion.errors
                            errores += renderErrors(bean: modificacion)
                        } else {
                            origen.priorizado -= detalle.valor
                            destino.priorizado += detalle.valor
                            if (!origen.save(flush: true)) {
                                println "error save origen: " + origen.errors
                                errores += renderErrors(bean: origen)
                            }
                            if (!destino.save(flush: true)) {
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
        reforma.estado = EstadoAval.findByCodigo("D02") //devuelto al analista
        reforma.save(flush: true)

        def accion, mensaje
        //E: existente, A: actividad, P: partida
        switch (reforma.tipoSolicitud) {
            case "E":
                accion = "existente"
                mensaje = "Devolución de ajuste a asignaciones existentes: "
                break;
            case "A":
                accion = "actividad"
                mensaje = "Devolución de ajuste a nuevas actividades: "
                break;
            case "P":
                accion = "partida"
                mensaje = "Devolución de ajuste a nuevas partidas: "
                break;
            default:
                accion = "existente"
                mensaje = "Devolución de ajuste a asignaciones existentes: "
        }

        def alerta = new Alerta()
        alerta.from = usu
        alerta.persona = reforma.persona
        alerta.fechaEnvio = now
        alerta.mensaje = mensaje + reforma.concepto
        alerta.controlador = "ajuste"
        alerta.accion = accion
        alerta.id_remoto = reforma.id
        if (!alerta.save(flush: true)) {
            println "error alerta: " + alerta.errors
        }
        render "OK"
    }
}
