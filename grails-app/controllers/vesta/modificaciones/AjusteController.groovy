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
import vesta.reportes.ReportesReformaController
import vesta.seguridad.Firma
import vesta.seguridad.Persona
import vesta.seguridad.Shield

class AjusteController extends Shield {

    def firmasService
    def proyectosService
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
        def perfil = session.perfil.codigo.toString()
//        def perfiles = ["GAF", "ASPL"]
//
//        if (perfiles.contains(perfil)) {
//            reformas = Reforma.withCriteria {
//                eq("tipo", "A")
//                persona {
//                    order("unidad", "asc")
//                }
//                order("fecha", "desc")
//            }
//        } else {
//            def unidades = proyectosService.getUnidadesUnidad(UnidadEjecutora.get(session.unidad.id))
//            def personas = Persona.findAllByUnidadInList(unidades)
//
//            reformas = Reforma.findAllByTipoAndPersonaInList('A', personas, [sort: "fecha", order: "desc"])
//        }
//        def unidades = proyectosService.getUnidadesUnidad(UnidadEjecutora.get(session.unidad.id), perfil)
        def unidades = UnidadEjecutora.get(session.unidad.id).getUnidadesPorPerfil(perfil)
        reformas = Reforma.withCriteria {
            eq("tipo", "A")
            persona {
                inList("unidad", unidades)
                order("unidad", "asc")
            }
            order("fecha", "desc")
        }
        return [reformas: reformas]
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
            case "ASPL":
                estados = [estadoPendiente, estadoDevueltoAnPlan]
                break;
        }

        def reformas = Reforma.withCriteria {
            eq("tipo", "A")
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
        def tipo = 'A'
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
//        def proyectos = []
        def actual
//        Asignacion.list().each {
////            println "p "+proyectos
//            def p = it.marcoLogico.proyecto
//            if (!proyectos?.id.contains(p.id)) {
//                proyectos.add(p)
//            }
//        }
        if (params.anio) {
            actual = Anio.get(params.anio)
        } else {
            actual = Anio.findByAnio(new Date().format("yyyy"))
        }

//        proyectos = proyectos.sort { it.nombre }
//
//        def proyectos2 = Proyecto.findAllByAprobadoPoa('S', [sort: 'nombre'])
//
//        def proyectos3 = Proyecto.findAllByAprobadoPoa('S', [sort: 'nombre'])

//        def proyectos3 = proyectosService.getProyectosUnidad(UnidadEjecutora.get(session.unidad.id), actual, session.perfil.codigo.toString())
        def proyectos3 = UnidadEjecutora.get(session.unidad.id).getProyectosUnidad(actual, session.perfil.codigo.toString())

        def campos = ["numero": ["Número", "string"], "descripcion": ["Descripción", "string"]]
//        println "pro "+proyectos
//        def unidad = UnidadEjecutora.findByCodigo("DPI") // DIRECCIÓN DE PLANIFICACIÓN E INVERSIÓN
//        def personasFirmas = Persona.findAllByUnidad(unidad)
//        def gerentes = Persona.findAllByUnidad(unidad.padre)
        def estadoDevuelto = EstadoAval.findByCodigo("D03")
        def estadoPendiente = EstadoAval.findByCodigo("P01")
        def estados = [estadoPendiente, estadoDevuelto]

        def firmas = firmasService.listaFirmasCombos()

        def total = 0

        def reforma = null, detalles = [], editable = true
        if (params.id) {
            editable = false
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

        return [proyectos: proyectos3, proyectos2: proyectos3, actual: actual, campos: campos, personas: firmas.directores,
                gerentes : firmas.gerentes, total: total, reforma: reforma, detalles: detalles]
    }

    /**
     * Acción que permite realizar una solicitud de reforma a nueva partida
     */
    def partida() {
//        def proyectos = []
        def actual
//        Asignacion.list().each {
////            println "p "+proyectos
//            def p = it.marcoLogico.proyecto
//            if (!proyectos?.id.contains(p.id)) {
//                proyectos.add(p)
//            }
//        }
        if (params.anio) {
            actual = Anio.get(params.anio)
        } else {
            actual = Anio.findByAnio(new Date().format("yyyy"))
        }

//        proyectos = proyectos.sort { it.nombre }
//
//        def proyectos2 = Proyecto.findAllByAprobadoPoa('S', [sort: 'nombre'])
//
//        def proyectos3 = Proyecto.findAllByAprobadoPoa('S', [sort: 'nombre'])

//        def proyectos3 = proyectosService.getProyectosUnidad(UnidadEjecutora.get(session.unidad.id), actual, session.perfil.codigo.toString())
        def proyectos3 = UnidadEjecutora.get(session.unidad.id).getProyectosUnidad(actual, session.perfil.codigo.toString())

        def campos = ["numero": ["Número", "string"], "descripcion": ["Descripción", "string"]]
//        println "pro "+proyectos
//        def unidad = UnidadEjecutora.findByCodigo("DPI") // DIRECCIÓN DE PLANIFICACIÓN E INVERSIÓN
//        def personasFirmas = Persona.findAllByUnidad(unidad)
//        def gerentes = Persona.findAllByUnidad(unidad.padre)
        def firmas = firmasService.listaFirmasCombos()
        def estadoDevuelto = EstadoAval.findByCodigo("D03")
        def estadoPendiente = EstadoAval.findByCodigo("P01")
        def estados = [estadoPendiente, estadoDevuelto]

        def total = 0

        def reforma = null, detalles = [], editable = true
        if (params.id) {
            editable = false
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

        return [proyectos: proyectos3, proyectos2: proyectos3, actual: actual, campos: campos, personas: firmas.directores,
                gerentes : firmas.gerentes, total: total, reforma: reforma, detalles: detalles]
    }

    /**
     * Acción que permite realizar una solicitud de reforma por modificacion de techo presupuestario
     */
    def techo() {
//        def proyectos = []
        def actual
//        Asignacion.list().each {
////            println "p "+proyectos
//            def p = it.marcoLogico.proyecto
//            if (!proyectos?.id.contains(p.id)) {
//                proyectos.add(p)
//            }
//        }
        if (params.anio) {
            actual = Anio.get(params.anio)
        } else {
            actual = Anio.findByAnio(new Date().format("yyyy"))
        }

//        proyectos = proyectos.sort { it.nombre }
//
//        def proyectos2 = Proyecto.findAllByAprobadoPoa('S', [sort: 'nombre'])
//
//        def proyectos3 = Proyecto.findAllByAprobadoPoa('S', [sort: 'nombre'])
//        def proyectos3 = proyectosService.getProyectosUnidad(UnidadEjecutora.get(session.unidad.id), actual, session.perfil.codigo.toString())
        def proyectos3 = UnidadEjecutora.get(session.unidad.id).getProyectosUnidad(actual, session.perfil.codigo.toString())

        def campos = ["numero": ["Número", "string"], "descripcion": ["Descripción", "string"]]
//        println "pro "+proyectos
//        def unidad = UnidadEjecutora.findByCodigo("DPI") // DIRECCIÓN DE PLANIFICACIÓN E INVERSIÓN
//        def personasFirmas = Persona.findAllByUnidad(unidad)
//        def gerentes = Persona.findAllByUnidad(unidad.padre)
        def firmas = firmasService.listaFirmasCombos()
        def estadoDevuelto = EstadoAval.findByCodigo("D03")
        def estadoPendiente = EstadoAval.findByCodigo("P01")
        def estados = [estadoPendiente, estadoDevuelto]

        def total = 0

        def reforma = null, detalles = [], editable = true
        if (params.id) {
            editable = false
            reforma = Reforma.get(params.id)
            if (!estados.contains(reforma.estado)) {
                println "esta en estado: ${reforma.estado.descripcion} (${reforma.estado.codigo}) asiq redirecciona a la lista"
                redirect(action: "lista")
                return
            }
            if (reforma) {
                def det = ReportesReformaController.generaDetallesSolicitudTecho(reforma)
                detalles = det.det
                total = det.total
            }
        }

        return [proyectos: proyectos3, proyectos2: proyectos3, actual: actual, campos: campos, personas: firmas.directores,
                gerentes : firmas.gerentes, total: total, reforma: reforma, detalles: detalles]
    }

    def validarTecho_ajax() {
        def proyecto = Proyecto.get(params.id)
        def anio = Anio.get(params.anio.toLong())
        def valor = proyecto.monto
        def priorizado = proyecto.getValorPriorizadoAnio(anio)
        render valor + "|" + priorizado
    }

    /**
     * Acción que permite realizar una solicitud de reforma a nueva actividad
     */
    def actividad() {
//        def proyectos = []
        def actual
//        Asignacion.list().each {
////            println "p "+proyectos
//            def p = it.marcoLogico.proyecto
//            if (!proyectos?.id.contains(p.id)) {
//                proyectos.add(p)
//            }
//        }
        if (params.anio) {
            actual = Anio.get(params.anio)
        } else {
            actual = Anio.findByAnio(new Date().format("yyyy"))
        }

//        proyectos = proyectos.sort { it.nombre }
//
//        def proyectos2 = Proyecto.findAllByAprobadoPoa('S', [sort: 'nombre'])
//
//        def proyectos3 = Proyecto.findAllByAprobadoPoa('S', [sort: 'nombre'])

//        def proyectos3 = proyectosService.getProyectosUnidad(UnidadEjecutora.get(session.unidad.id), actual, session.perfil.codigo.toString())
        def proyectos3 = UnidadEjecutora.get(session.unidad.id).getProyectosUnidad(actual, session.perfil.codigo.toString())

        def campos = ["numero": ["Número", "string"], "descripcion": ["Descripción", "string"]]
//        println "pro "+proyectos
//        def unidad = UnidadEjecutora.findByCodigo("DPI") // DIRECCIÓN DE PLANIFICACIÓN E INVERSIÓN
//        def personasFirmas = Persona.findAllByUnidad(unidad)
//        def gerentes = Persona.findAllByUnidad(unidad.padre)
        def firmas = firmasService.listaFirmasCombos()
        def estadoDevuelto = EstadoAval.findByCodigo("D03")
        def estadoPendiente = EstadoAval.findByCodigo("P01")
        def estados = [estadoPendiente, estadoDevuelto]

        def total = 0

        def reforma = null, detalles = [], editable = true
        if (params.id) {
            editable = false
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

        return [proyectos: proyectos3, proyectos2: proyectos3, actual: actual, campos: campos, personas: firmas.directores,
                gerentes : firmas.gerentes, total: total, reforma: reforma, detalles: detalles, unidad: UnidadEjecutora.get(session.unidad.id)]
    }

    /**
     * Acción llamada con ajax que guarda una solicitud de reforma de asignaciones existentes
     */
    def saveExistente_ajax() {
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
        reforma.tipo = "A"
        reforma.tipoSolicitud = "E"
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
                firma1.controlador = "ajuste"
                firma1.idAccion = reforma.id
                firma1.accionVer = "existente"
                firma1.controladorVer = "reportesReforma"
                firma1.idAccionVer = reforma.id
                firma1.accionNegar = "devolverAprobarAjuste"
                firma1.controladorNegar = "ajuste"
                firma1.idAccionNegar = reforma.id
                firma1.concepto = "${tipoStr} (${now.format('dd-MM-yyyy')}): " + reforma.concepto
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
                firma2.concepto = "${tipoStr} (${now.format('dd-MM-yyyy')}): " + reforma.concepto
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
            alerta2.mensaje = "${tipoStr} (${now.format('dd-MM-yyyy')}): " + reforma.concepto
            alerta2.controlador = "firma"
            alerta2.accion = "firmasPendientes"
            alerta2.id_remoto = 0
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



    def saveNuevoAjuste_ajax () {

        println("save nuevo ajuste " + params)

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
        reforma.tipoSolicitud = "Z"
        if (!reforma.save(flush: true)) {
            println "error al guardar el ajuste: " + reforma.errors
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
                firma1.accion = "firmarAprobarNuevoAjuste"
                firma1.controlador = "ajuste"
                firma1.idAccion = reforma.id
                firma1.accionVer = "verNuevoAjuste"
                firma1.controladorVer = "reportesReforma"
                firma1.idAccionVer = reforma.id
                firma1.accionNegar = "devolverAprobarAjuste"
                firma1.controladorNegar = "ajuste"
                firma1.idAccionNegar = reforma.id
                firma1.concepto = "${tipoStr} (${now.format('dd-MM-yyyy')}): " + reforma.concepto
                firma1.tipoFirma = "AJST"
                if (!firma1.save(flush: true)) {
                    println "error al crear firma1: " + firma1.errors
                    render "ERROR*" + renderErrors(bean: firma1)
                    return
                }
                def firma2 = new Firma()
                firma2.usuario = personaFirma2
                firma2.fecha = now
                firma2.accion = "firmarAprobarNuevoAjuste"
                firma2.controlador = "ajuste"
                firma2.idAccion = reforma.id
                firma2.accionVer = "verNuevoAjuste"
                firma2.controladorVer = "reportesReforma"
                firma2.idAccionVer = reforma.id
                firma1.accionNegar = "devolverAprobarAjuste"
                firma2.controladorNegar = "ajuste"
                firma2.idAccionNegar = reforma.id
                firma2.concepto = "${tipoStr} (${now.format('dd-MM-yyyy')}): " + reforma.concepto
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
                render "SUCCESS*Ajuste solicitado exitosamente"
            } else {
                render "SUCCESS*Ajuste guardado exitosamente*" + reforma.id
            }
        } else {
            render "ERROR*" + errores
        }
    }


    /**
     * Acción llamada con ajax que guarda una solicitud de reforma de nueva actividad
     */
    def saveActividad_ajax() {
        println params
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
        reforma.tipo = "A"
        reforma.tipoSolicitud = "A"
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
                firma1.controlador = "ajuste"
                firma1.idAccion = reforma.id
                firma1.accionVer = "actividad"
                firma1.controladorVer = "reportesReforma"
                firma1.idAccionVer = reforma.id
                firma1.accionNegar = "devolverAprobarAjuste"
                firma1.controladorNegar = "ajuste"
                firma1.idAccionNegar = reforma.id
                firma1.concepto = "${tipoStr} (${now.format('dd-MM-yyyy')}): " + reforma.concepto
                firma1.tipoFirma = "AJST"
                if (!firma1.save(flush: true)) {
                    println "error al crear firma1: " + firma1.errors
                    render "ERROR*" + renderErrors(bean: firma1)
                    return
                }
                println "firma1: " + firma1
                def firma2 = new Firma()
                firma2.usuario = personaFirma2
                firma2.fecha = now
                firma2.accion = "firmarAprobarAjuste"
                firma2.controlador = "ajuste"
                firma2.idAccion = reforma.id
                firma2.accionVer = "actividad"
                firma2.controladorVer = "reportesReforma"
                firma2.idAccionVer = reforma.id
                firma2.accionNegar = "devolverAprobarAjuste"
                firma2.controladorNegar = "ajuste"
                firma2.idAccionNegar = reforma.id
                firma2.concepto = "${tipoStr} (${now.format('dd-MM-yyyy')}): " + reforma.concepto
                firma2.tipoFirma = "AJST"
                if (!firma2.save(flush: true)) {
                    println "error al crear firma2: " + firma2.errors
                    render "ERROR*" + renderErrors(bean: firma2)
                    return
                }
                println "firma2: " + firma2
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
            alerta2.mensaje = "${tipoStr} (${now.format('dd-MM-yyyy')}): " + reforma.concepto
            alerta2.controlador = "firma"
            alerta2.accion = "firmasPendientes"
            alerta2.id_remoto = 0
            if (!alerta2.save(flush: true)) {
                println "error alerta: " + alerta2.errors
            }
        } else {
            println "no se manda: no se hace alerta ni se manda mail ni se hacen firmas"
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
            detalle.valorOrigenInicial = asignacionOrigen.priorizado
            detalle.valorDestinoInicial = 0
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
            estado = EstadoAval.findByCodigo("EF1") //por revisar
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
        reforma.tipo = "A"
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
                firma1.controlador = "ajuste"
                firma1.idAccion = reforma.id
                firma1.accionVer = "partida"
                firma1.controladorVer = "reportesReforma"
                firma1.idAccionVer = reforma.id
                firma1.accionNegar = "devolverAprobarAjuste"
                firma1.controladorNegar = "ajuste"
                firma1.idAccionNegar = reforma.id
                firma1.concepto = "${tipoStr} (${now.format('dd-MM-yyyy')}): " + reforma.concepto
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
                firma2.concepto = "${tipoStr} (${now.format('dd-MM-yyyy')}): " + reforma.concepto
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
            alerta2.mensaje = "${tipoStr} (${now.format('dd-MM-yyyy')}): " + reforma.concepto
            alerta2.controlador = "firma"
            alerta2.accion = "firmasPendientes"
            alerta2.id_remoto = 0
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
     * Acción llamada con ajax que guarda una solicitud de reforma modificacion de techos
     */
    def saveTecho_ajax() {
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
        reforma.tipo = "A"
        reforma.tipoSolicitud = "T"
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
                firma1.controlador = "ajuste"
                firma1.idAccion = reforma.id
                firma1.accionVer = "techo"
                firma1.controladorVer = "reportesReforma"
                firma1.idAccionVer = reforma.id
                firma1.accionNegar = "devolverAprobarAjuste"
                firma1.controladorNegar = "ajuste"
                firma1.idAccionNegar = reforma.id
                firma1.concepto = "${tipoStr} (${now.format('dd-MM-yyyy')}): " + reforma.concepto
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
                firma2.accionVer = "techo"
                firma2.controladorVer = "reportesReforma"
                firma2.idAccionVer = reforma.id
                firma2.accionNegar = "devolverAprobarAjuste"
                firma2.controladorNegar = "ajuste"
                firma2.idAccionNegar = reforma.id
                firma2.concepto = "${tipoStr} (${now.format('dd-MM-yyyy')}): " + reforma.concepto
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
            alerta2.mensaje = "${tipoStr} (${now.format('dd-MM-yyyy')}): " + reforma.concepto
            alerta2.controlador = "firma"
            alerta2.accion = "firmasPendientes"
            alerta2.id_remoto = 0
            if (!alerta2.save(flush: true)) {
                println "error alerta: " + alerta2.errors
            }
        } else {
            println "no se manda: no se hace alerta ni se manda mail ni se hacen firmas"
        }
        /*
            r0[tipo]:+,
            r0[partida]:220,
            r0[fuente]:9,
            r0[actividad]:131,
            r0[monto]:1500.00,

            r1[monto]:1000.00,
            r1[asignacion]:416,
            r1[tipo]:+,

            r2[monto]:-100.00,
            r2[asignacion]:408,
            r2[tipo]:-,
         */

        def errores = ""
        detalles.each { k, det ->
            def monto = det.monto.replaceAll(",", "").toDouble()

            def detalle = new DetalleReforma()
            detalle.reforma = reforma
            detalle.valor = monto
            detalle.valorOrigenInicial = 0
            detalle.valorDestinoInicial = 0

            if (det.asignacion) {
                def asignacionOrigen = Asignacion.get(det.asignacion.toLong())

                detalle.asignacionOrigen = asignacionOrigen
                detalle.valorOrigenInicial = asignacionOrigen.priorizado
            } else if (det.actividad) {
                def presupuesto = Presupuesto.get(det.partida.toLong())
                def actividad = MarcoLogico.get(det.actividad.toLong())
                def fuente = Fuente.get(det.fuente.toLong())

                detalle.presupuesto = presupuesto
                detalle.componente = actividad
                detalle.fuente = fuente
            } else {
                println "el detalle ${det} no puede ser procesado!!!"
            }

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
                            nuevaActividad.reforma = reforma

                            if (!nuevaActividad.save(flush: true)) {
                                println "error al guardar la actividad (AA) " + nuevaActividad.errors
                                errores += renderErrors(bean: nuevaActividad)
                            } else {
                                destino = new Asignacion()
                                destino.anio = reforma.anio
                                destino.fuente = origen.fuente
                                destino.marcoLogico = nuevaActividad
                                destino.presupuesto = detalle.presupuesto
                                destino.planificado = 0
                                destino.unidad = nuevaActividad.responsable
                                destino.priorizado = 0
                                if (!destino.save(flush: true)) {
                                    println "error al guardar la asignacion (AA) " + destino.errors
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
                            destino.planificado = 0
                            destino.unidad = origen.marcoLogico.responsable
                            destino.priorizado = 0
                            if (!destino.save(flush: true)) {
                                println "error al guardar la asignacion (AP) " + destino.errors
                                errores += renderErrors(bean: destino)
                                destino = null
                            }
                            break;
                        case "T":
                            destino = null
                            //caso 1: incremento o decremento de asignacion existente
                            //origen = detalle.asignacionOrigen

                            //caso 2: incremento a nueva asignacion
                            if (detalle.componente) {
                                origen = new Asignacion()
                                origen.anio = reforma.anio
                                origen.fuente = detalle.fuente
                                origen.marcoLogico = detalle.componente
                                origen.presupuesto = detalle.presupuesto
                                origen.planificado = 0
                                origen.unidad = detalle.componente.responsable
                                origen.priorizado = 0
                                if (!origen.save(flush: true)) {
                                    println "error al guardar la asignacion (AP) " + origen.errors
                                    errores += renderErrors(bean: destino)
                                    origen = null
                                }
                            }
                            break;
                    }
                    if ((origen && destino) || (origen && reforma.tipoSolicitud == "T")) {
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
                            if (reforma.tipoSolicitud == "T") {
                                origen.priorizado += detalle.valor // si es positivo suma, si es negativo resta
                            } else {
                                origen.priorizado -= detalle.valor
                                destino.priorizado += detalle.valor
                            }
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
     * Acción para firmar la aprobación de la reforma
     */
    def firmarAprobarNuevoAjuste() {
        println "firmarAprobarNuevoAjuste params: $params"
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

                       case "A": //creacion actividad
//                           println("entro actividad")
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
                           nuevaActividad.proyecto = d?.componente?.proyecto
                           nuevaActividad.tipoElemento = TipoElemento.get(3)
                           nuevaActividad.marcoLogico = d?.componente
                           nuevaActividad.objeto = d?.descripcionNuevaActividad
                           nuevaActividad.monto = d?.valor
                           nuevaActividad.estado = 0
                           nuevaActividad.categoria = d?.categoria
                           nuevaActividad.fechaInicio = d?.fechaInicioNuevaActividad
                           nuevaActividad.fechaFin = d?.fechaFinNuevaActividad
                           nuevaActividad.responsable = d.responsable
                           nuevaActividad.numero = numAct
                           nuevaActividad.reforma = reforma

                           println "pone responsable de actividad a: ${d.responsable}"

                           if (!nuevaActividad.save(flush: true)) {
                               println "error al guardar la actividad A " + nuevaActividad.errors
                               errores += renderErrors(bean: nuevaActividad)
                           } else {

                               def destinoActividad = new Asignacion()
                               destinoActividad.anio = reforma.anio
                               destinoActividad.fuente = d?.fuente
                               destinoActividad.marcoLogico = nuevaActividad
                               destinoActividad.presupuesto = d?.presupuesto
                               destinoActividad.planificado = 0
                               destinoActividad.unidad = nuevaActividad.responsable
                               destinoActividad.priorizado = d?.valor
                               if (!destinoActividad.save(flush: true)) {
                                   println "error al guardar la asignacion A " + destinoActividad.errors
                                   errores += renderErrors(bean: destinoActividad)
                                   destinoActividad = null
                               }else{
                                   def modificacionActividad = new ModificacionAsignacion()
                                   modificacionActividad.usuario = usu
                                   modificacionActividad.recibe = destinoActividad
                                   modificacionActividad.fecha = now
                                   modificacionActividad.valor = d?.valor
                                   modificacionActividad.estado = 'A'
                                   modificacionActividad.detalleReforma = d
                                   modificacionActividad.originalDestino = destinoActividad?.priorizado

                                   if (!modificacionActividad.save(flush: true)) {
                                       println "error al guardar modificacion tipo A: " + modificacionActividad.errors
                                       errores += renderErrors(bean: modificacionActividad)
                                   } else {
//                                        render "ok"
                                   }
                               }
                           }
                           break;

                       case "P": //partida - priorizado original en 0, valor ingresado en priorizado, no tiene padre
//                           println("entro partida")
                           def nuevaPartida = new Asignacion()
                           nuevaPartida.anio = reforma.anio
                           nuevaPartida.fuente = d?.fuente
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
                               modificacionPartida.originalDestino = nuevaPartida?.priorizado

                               if (!modificacionPartida.save(flush: true)) {
                                   println "error al guardar modificacion tipo P: " + modificacionPartida.errors
                                   errores += renderErrors(bean: modificacionPartida)
                               } else {
//                                    render "ok"
                               }
                           }
                           break;

                       case "N": //partida - priorizado original en 0, valor ingresado en priorizado, no tiene padre
//                           println("entro techo")
                           def nuevaPartida = new Asignacion()
                           nuevaPartida.anio = reforma.anio
                           nuevaPartida.fuente = d?.fuente
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
                           } else {
                               def modificacionPartida = new ModificacionAsignacion()
                               modificacionPartida.usuario = usu
                               modificacionPartida.recibe = nuevaPartida
                               modificacionPartida.fecha = now
                               modificacionPartida.valor = d?.valor
                               modificacionPartida.estado = 'A'
                               modificacionPartida.detalleReforma = d
                               modificacionPartida.originalDestino = nuevaPartida?.priorizado

                               if (!modificacionPartida.save(flush: true)) {
                                   println "error al guardar modificacion tipo N: " + modificacionPartida.errors
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

        def tipoStr = elm.tipoReformaStr(tipo: 'Ajuste', tipoSolicitud: reforma.tipoSolicitud)
        def accion
        def mensaje = "Devolución de ${tipoStr}"
        //E: existente, A: actividad, P: partida
        switch (reforma.tipoSolicitud) {
            case "E":
                accion = "existente"
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
                accion = "existente"
//                mensaje = "Devolución de ${tipoStr}: "
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


    def nuevoAjuste () {

        def cn = dbConnectionService.getConnection()
        def actual
        if (params.anio) {
            actual = Anio.get(params.anio)
        } else {
            actual = Anio.findByAnio(new Date().format("yyyy"))
        }

        def unidad = UnidadEjecutora.get(session.unidad.id)
        def proyectos = unidad.getProyectosUnidad(actual, session.perfil.codigo.toString())

        def anios__id = cn.rows("select distinct asgn.anio__id, anioanio from asgn, mrlg, anio " +
                "where mrlg.mrlg__id = asgn.mrlg__id and proy__id in (${proyectos.id.join(',')}) and " +
                "anio.anio__id = asgn.anio__id and cast(anioanio as integer) >= ${actual.anio} " +
                "order by anioanio".toString()).anio__id
        def anios = Anio.findAllByIdInList(anios__id)

        def personasFirma = firmasService.listaDirectoresUnidad(unidad)
        def firmas = firmasService.listaFirmasCombos()

        def reforma
        def detalle
        if(params.id){
            reforma = Reforma.findByIdAndTipoAndTipoSolicitud(params.id, "A", "Z")
            detalle = DetalleReforma.findAllByReforma(reforma, [sort: 'tipoReforma.id', order: 'desc'],[sort: 'id', order: 'desc'])
        }

        return [actual: actual, proyectos: proyectos, reforma: reforma, detalle: detalle,
                anios: anios, gerentes : firmas.gerentes, personas: firmas.directores]

    }


    def guardarNuevoAjuste () {
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
            reforma.tipoSolicitud = 'Z'
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
            reforma.tipoSolicitud = 'Z'
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

    def asignacionOrigenAjuste_ajax () {


        println("params a ajuste " + params)

        def actual
        if (params.anio) {
            actual = Anio.get(params.anio)
        } else {
            actual = Anio.findByAnio(new Date().format("yyyy"))
        }

        def  proyectos3 = UnidadEjecutora.get(session.unidad.id).getProyectosUnidad(actual, session.perfil.codigo.toString())

        def detalle = null

        if(params.id){
            detalle = DetalleReforma.get(params.id)
        }

        return [proyectos:  proyectos3, detalle: detalle]


    }

    def incrementoAjuste_ajax () {

        def actual
        if (params.anio) {
            actual = Anio.get(params.anio)
        } else {
            actual = Anio.findByAnio(new Date().format("yyyy"))
        }

        def proyectos3 = UnidadEjecutora.get(session.unidad.id).getProyectosUnidad(actual, session.perfil.codigo.toString())

        def detalle = null

        if(params.id){
            detalle = DetalleReforma.get(params.id)
        }

        return [proyectos:  proyectos3, detalle: detalle]

    }


    def partidaAjuste_ajax() {

        def actual
        if (params.anio) {
            actual = Anio.get(params.anio)
        } else {
            actual = Anio.findByAnio(new Date().format("yyyy"))
        }

        def proyectos3 = UnidadEjecutora.get(session.unidad.id).getProyectosUnidad(actual, session.perfil.codigo.toString())



        def detalle = null

        if(params.id){
            detalle = DetalleReforma.get(params.id)
        }

        return [proyectos:  proyectos3, detalle: detalle]

    }


    def actividadAjuste_ajax () {

        def actual
        if (params.anio) {
            actual = Anio.get(params.anio)
        } else {
            actual = Anio.findByAnio(new Date().format("yyyy"))
        }

//        def proyectos3 = UnidadEjecutora.get(session.unidad.id).getProyectosUnidad(actual, session.perfil.codigo.toString())
        def proyectos3 = Proyecto.list([sort: 'nombre'])

        def detalle = null

        if(params.id){
            detalle = DetalleReforma.get(params.id)
        }

        return [proyectos: proyectos3, detalle: detalle]
    }


    def techoAjuste_ajax () {


        def actual
        if (params.anio) {
            actual = Anio.get(params.anio)
        } else {
            actual = Anio.findByAnio(new Date().format("yyyy"))
        }

        def proyectos3 = UnidadEjecutora.get(session.unidad.id).getProyectosUnidad(actual, session.perfil.codigo.toString())

        def detalle = null

        if(params.id){
            detalle = DetalleReforma.get(params.id)
        }

        return [proyectos:  proyectos3, detalle: detalle]
    }


    def grabarDetalleE () {


        println("params E " + params)
//
        def reforma = Reforma.get(params.reforma)
        def tipoReforma = TipoReforma.findByCodigo(params.tipoReforma)
        def componente = MarcoLogico.get(params.componente)
        def actividad = MarcoLogico.get(params.actividad)
        def fuente = Fuente.get(params.fuente)
        def partida = Presupuesto.get(params.partida)

        def detalleReforma

        if(!params.id){
            //crear

            detalleReforma = new DetalleReforma()
            detalleReforma.reforma = reforma
            detalleReforma.componente = actividad
            detalleReforma.tipoReforma = tipoReforma
            detalleReforma.valor = params.monto.toDouble()
            detalleReforma.valorOrigenInicial = 0
            detalleReforma.valorDestinoInicial = 0
            detalleReforma.fuente = fuente
            detalleReforma.presupuesto = partida
            detalleReforma.responsable = session.usuario.unidad

            if(!detalleReforma.save(flush: true)){
                println("error al guardar detalle de reforma E  " + errors);
                render "no"
            }else{
                render "ok"
            }


        }else{
            //editar

            detalleReforma = DetalleReforma.get(params.id)
            detalleReforma.reforma = reforma
            detalleReforma.componente = actividad
            detalleReforma.tipoReforma = tipoReforma
            detalleReforma.valor = params.monto.toDouble()
            detalleReforma.valorOrigenInicial = 0
            detalleReforma.valorDestinoInicial = 0
            detalleReforma.fuente = fuente
            detalleReforma.presupuesto = partida
            detalleReforma.responsable = session.usuario.unidad

            if(!detalleReforma.save(flush: true)){
                println("error al guardar detalle de reforma E  " + errors);
                render "no"
            }else{
                render "ok"
            }
        }


    }
}
