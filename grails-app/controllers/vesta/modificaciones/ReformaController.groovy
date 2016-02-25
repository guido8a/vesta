package vesta.modificaciones

import vesta.ProyectosService
import vesta.alertas.Alerta
import vesta.avales.EstadoAval
import vesta.parametros.TipoElemento
import vesta.parametros.UnidadEjecutora
import vesta.parametros.poaPac.Anio
import vesta.parametros.poaPac.Fuente
import vesta.parametros.poaPac.Presupuesto
import vesta.poa.Asignacion
import vesta.poa.Componente
import vesta.proyectos.Categoria
import vesta.proyectos.MarcoLogico
import vesta.proyectos.ModificacionAsignacion
import vesta.proyectos.Proyecto
import vesta.reportes.ReportesReformaController
import vesta.seguridad.Firma
import vesta.seguridad.Persona
import vesta.seguridad.Prfl
import vesta.seguridad.Sesn
import vesta.seguridad.Shield


/**
 * Controlador que muestra las pantallas de manejo de Reforma
 */
class ReformaController extends Shield {

    def firmasService
//    def proyectosService
    def mailService
    def dbConnectionService

    /**
     * Acción que muestra los diferentes tipos de reforma posibles y permite seleccionar uno para comenzar el proceso
     */
    def reformas() {

    }

    /**
     * Acción que permite realizar una solicitud de reforma a asignaciones existentes
     */
    def existente() {

        def actual
        if (params.anio) {
            actual = Anio.get(params.anio)
        } else {
            actual = Anio.findByAnio(new Date().format("yyyy"))
        }
//        def proyectos3 = proyectosService.getProyectosUnidad(UnidadEjecutora.get(session.unidad.id), actual, session.perfil.codigo.toString())
        def proyectos3 = UnidadEjecutora.get(session.unidad.id).getProyectosUnidad(actual, session.perfil.codigo.toString())

//        def proyectos = []
//        Asignacion.list().each {
////            println "p "+proyectos
//            def p = it.marcoLogico.proyecto
//            if (!proyectos?.id.contains(p.id)) {
//                proyectos.add(p)
//            }
//        }

//        proyectosService.getAsignacionesUnidad(UnidadEjecutora.get(session.unidad.id))
//        proyectosService.getAsignacionesUnidad(UnidadEjecutora.findByCodigo("DTH"))
//        proyectosService.getAsignacionesUnidad(UnidadEjecutora.get(143))
//        proyectosService.getAsignacionesUnidad(UnidadEjecutora.get(133))

//        proyectos = proyectos.sort { it.nombre }
//
//        def proyectos2 = Proyecto.findAllByAprobadoPoa('S', [sort: 'nombre'])
//
//        def proyectos3 = Proyecto.findAllByAprobadoPoaAndUnidadAdministradora('S', session.unidad, [sort: 'nombre'])

        def campos = ["numero": ["Número", "string"], "descripcion": ["Descripción", "string"]]
//        println "pro "+proyectos
//        def unidad = UnidadEjecutora.findByCodigo("DPI") // DIRECCIÓN DE PLANIFICACIÓN E INVERSIÓN
//        def personasFirmas = Persona.findAllByUnidad(unidad)
//        def gerentes = Persona.findAllByUnidad(unidad.padre)
//        def firmas = firmasService.listaFirmasCombos()
        def estadoDevuelto = EstadoAval.findByCodigo("D01")
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
        def unidad = UnidadEjecutora.get(session.unidad.id)
        def personasFirma = firmasService.listaDirectoresUnidad(unidad)

        return [proyectos: proyectos3, proyectos2: proyectos3, actual: actual, campos: campos, personas: personasFirma,
                total    : total, reforma: reforma, detalles: detalles]
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
//        def proyectos3 = proyectosService.getProyectosUnidad(UnidadEjecutora.get(session.unidad.id), actual, session.perfil.codigo.toString())
        def proyectos3 = UnidadEjecutora.get(session.unidad.id).getProyectosUnidad(actual, session.perfil.codigo.toString())

//        def proyectos = []
//        def actual
//        Asignacion.list().each {
////            println "p "+proyectos
//            def p = it.marcoLogico.proyecto
//            if (!proyectos?.id.contains(p.id)) {
//                proyectos.add(p)
//            }
//        }
//        if (params.anio) {
//            actual = Anio.get(params.anio)
//        } else {
//            actual = Anio.findByAnio(new Date().format("yyyy"))
//        }
//
//        proyectos = proyectos.sort { it.nombre }
//
//        def proyectos2 = Proyecto.findAllByAprobadoPoa('S', [sort: 'nombre'])
//
//        def proyectos3 = Proyecto.findAllByAprobadoPoaAndUnidadAdministradora('S', session.unidad, [sort: 'nombre'])

        def campos = ["numero": ["Número", "string"], "descripcion": ["Descripción", "string"]]
//        println "pro "+proyectos
//        def unidad = UnidadEjecutora.findByCodigo("DPI") // DIRECCIÓN DE PLANIFICACIÓN E INVERSIÓN
//        def personasFirmas = Persona.findAllByUnidad(unidad)
//        def gerentes = Persona.findAllByUnidad(unidad.padre)
//        def firmas = firmasService.listaFirmasCombos()
        def estadoDevuelto = EstadoAval.findByCodigo("D01")
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
//            def solicitadoSinFirma = EstadoAval.findByCodigo("EF4")
//            def devuelto = EstadoAval.findByCodigo("D01")
            if (detalles.size() > 0) {
                total = detalles.sum { it.valor }
            }
        }
        def unidad = UnidadEjecutora.get(session.unidad.id)
        def personasFirma = firmasService.listaDirectoresUnidad(unidad)

        return [proyectos: proyectos3, proyectos2: proyectos3, actual: actual, campos: campos, personas: personasFirma,
                total    : total, editable: editable, reforma: reforma, detalles: detalles]
    }

    /**
     * Acción que permite realizar una solicitud de reforma a nueva actividad
     */
    def actividad() {
        def actual
        if (params.anio) {
            actual = Anio.get(params.anio)
        } else {
            actual = Anio.findByAnio(new Date().format("yyyy"))
        }
//        def proyectos3 = proyectosService.getProyectosUnidad(UnidadEjecutora.get(session.unidad.id), actual, session.perfil.codigo.toString())
        def proyectos3 = UnidadEjecutora.get(session.unidad.id).getProyectosUnidad(actual, session.perfil.codigo.toString())
//        def proyectos = []
//        def actual
//        Asignacion.list().each {
////            println "p "+proyectos
//            def p = it.marcoLogico.proyecto
//            if (!proyectos?.id.contains(p.id)) {
//                proyectos.add(p)
//            }
//        }
//        if (params.anio) {
//            actual = Anio.get(params.anio)
//        } else {
//            actual = Anio.findByAnio(new Date().format("yyyy"))
//        }
//
//        proyectos = proyectos.sort { it.nombre }
//
//        def proyectos2 = Proyecto.findAllByAprobadoPoa('S', [sort: 'nombre'])
//
//        def proyectos3 = Proyecto.findAllByAprobadoPoaAndUnidadAdministradora('S', session.unidad, [sort: 'nombre'])

        def campos = ["numero": ["Número", "string"], "descripcion": ["Descripción", "string"]]
//        println "pro "+proyectos
//        def unidad = UnidadEjecutora.findByCodigo("DPI") // DIRECCIÓN DE PLANIFICACIÓN E INVERSIÓN
//        def personasFirmas = Persona.findAllByUnidad(unidad)
//        def gerentes = Persona.findAllByUnidad(unidad.padre)
//        def firmas = firmasService.listaFirmasCombos()
        def estadoDevuelto = EstadoAval.findByCodigo("D01")
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
        def unidad = UnidadEjecutora.get(session.unidad.id)
        def personasFirma = firmasService.listaDirectoresUnidad(unidad)

        return [proyectos: proyectos3, proyectos2: proyectos3, actual: actual, campos: campos, personas: personasFirma,
                total    : total, editable: editable, reforma: reforma, detalles: detalles, unidad: UnidadEjecutora.get(session.unidad.id)]
    }

    /**
     * Acción que permite realizar una solicitud de reforma a nueva actividad sin asignación de origen
     */
    def incrementoActividad() {
        def actual
        if (params.anio) {
            actual = Anio.get(params.anio)
        } else {
            actual = Anio.findByAnio(new Date().format("yyyy"))
        }
//        def proyectos3 = proyectosService.getProyectosUnidad(UnidadEjecutora.get(session.unidad.id), actual, session.perfil.codigo.toString())
        def proyectos3 = UnidadEjecutora.get(session.unidad.id).getProyectosUnidad(actual, session.perfil.codigo.toString())
//        def proyectos = []
//        def actual
//        Asignacion.list().each {
////            println "p "+proyectos
//            def p = it.marcoLogico.proyecto
//            if (!proyectos?.id.contains(p.id)) {
//                proyectos.add(p)
//            }
//        }
//        if (params.anio) {
//            actual = Anio.get(params.anio)
//        } else {
//            actual = Anio.findByAnio(new Date().format("yyyy"))
//        }
//
//        proyectos = proyectos.sort { it.nombre }
//
//        def proyectos2 = Proyecto.findAllByAprobadoPoa('S', [sort: 'nombre'])
//
//        def proyectos3 = Proyecto.findAllByAprobadoPoaAndUnidadAdministradora('S', session.unidad, [sort: 'nombre'])

        def campos = ["numero": ["Número", "string"], "descripcion": ["Descripción", "string"]]
//        println "pro "+proyectos
//        def unidad = UnidadEjecutora.findByCodigo("DPI") // DIRECCIÓN DE PLANIFICACIÓN E INVERSIÓN
//        def personasFirmas = Persona.findAllByUnidad(unidad)
//        def gerentes = Persona.findAllByUnidad(unidad.padre)
//        def firmas = firmasService.listaFirmasCombos()
        def estadoDevuelto = EstadoAval.findByCodigo("D01")
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
        def unidad = UnidadEjecutora.get(session.unidad.id)
        def personasFirma = firmasService.listaDirectoresUnidad(unidad)

        return [proyectos: proyectos3, proyectos2: proyectos3, actual: actual, campos: campos, personas: personasFirma,
                total    : total, editable: editable, reforma: reforma, detalles: detalles, unidad: UnidadEjecutora.get(session.unidad.id)]
    }

    /**
     * Acción que permite realizar una solicitud de reforma de incremento
     */
    def incremento() {
        def actual
        if (params.anio) {
            actual = Anio.get(params.anio)
        } else {
            actual = Anio.findByAnio(new Date().format("yyyy"))
        }
//        def proyectos3 = proyectosService.getProyectosUnidad(UnidadEjecutora.get(session.unidad.id), actual, session.perfil.codigo.toString())
        def proyectos3 = UnidadEjecutora.get(session.unidad.id).getProyectosUnidad(actual, session.perfil.codigo.toString())
//        def proyectos = []
//        def actual
//        Asignacion.list().each {
////            println "p "+proyectos
//            def p = it.marcoLogico.proyecto
//            if (!proyectos?.id.contains(p.id)) {
//                proyectos.add(p)
//            }
//        }
//        if (params.anio) {
//            actual = Anio.get(params.anio)
//        } else {
//            actual = Anio.findByAnio(new Date().format("yyyy"))
//        }
//
//        proyectos = proyectos.sort { it.nombre }
//
//        def proyectos2 = Proyecto.findAllByAprobadoPoa('S', [sort: 'nombre'])
//
//        def proyectos3 = Proyecto.findAllByAprobadoPoaAndUnidadAdministradora('S', session.unidad, [sort: 'nombre'])

        def campos = ["numero": ["Número", "string"], "descripcion": ["Descripción", "string"]]
//        println "pro "+proyectos
//        def unidad = UnidadEjecutora.findByCodigo("DPI") // DIRECCIÓN DE PLANIFICACIÓN E INVERSIÓN
//        def personasFirmas = Persona.findAllByUnidad(unidad)
//        def gerentes = Persona.findAllByUnidad(unidad.padre)
//        def firmas = firmasService.listaFirmasCombos()
        def estadoDevuelto = EstadoAval.findByCodigo("D01")
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
        def unidad = UnidadEjecutora.get(session.unidad.id)
        def personasFirma = firmasService.listaDirectoresUnidad(unidad)

        return [proyectos: proyectos3, proyectos2: proyectos3, actual: actual, campos: campos, personas: personasFirma,
                total    : total, editable: editable, reforma: reforma, detalles: detalles, unidad: UnidadEjecutora.get(session.unidad.id)]
    }

    /**
     * Acción que muestra la lista de todas las reformas, con su estado y una opción para ver el pdf
     * Tipo de la solicitud     E: existente (ajustes -> 1 y reformas -> 1)
     P: inclusión de nuevas partidas (ajustes -> 2 y reformas -> 2)
     I: incremento de recursos (reformas -> 3)
     A: nueva actividad con financiamiento del área (ajustes -> 3 y reformas -> 4)
     C: nueva actividad sin financiamiento del área tipo --> 5
     T: Ajuste por modificación de techo presupuestario (ajustes -> 4)
     */
    def lista() {
//        println "lista ref: $params"
        def aprobado = EstadoAval.findByCodigo("E02")
        def liberado = EstadoAval.findByCodigo("E05")
        def actual
        if (params.anio) {
            actual = Anio.get(params.anio)
        } else {
            actual = Anio.findByAnio(new Date().format("yyyy"))
        }
        def reformas
        def perfil = session.perfil.codigo
        def unidades = UnidadEjecutora.get(session.unidad.id).getUnidadesPorPerfil(perfil)

        def cn = dbConnectionService.getConnection()
        def totales = [:]
        def tx = ""
        reformas = Reforma.withCriteria {
            eq("tipo", "R")
            inList("estado", aprobado, liberado)
            persona {
                if(params.requirente){
                    eq("unidad", UnidadEjecutora.get(params.requirente))
                } else {
                    inList("unidad", unidades)
                    order("unidad", "asc")
                }
            }
            if(params.anio){
                eq("anio", Anio.get(params.anio))
            }
            if(params.numero){
                eq("numeroReforma", params.numero.toInteger())
            }

            order("fecha", "desc")
        }

        reformas.each {rf ->
            switch (rf.tipoSolicitud){
                case ['E', 'P', 'A']:
                    tx = "select sum(dtrfvlor) suma from dtrf where rfrm__id = ${rf.id} and asgn__id is not null"
                    break
                case ['X']:
                    tx = "select sum(dtrfvlor) suma from dtrf where rfrm__id = ${rf.id} and tprf__id != '6'"
                    break
                default:
                    tx = "select sum(dtrfvlor) suma from dtrf where rfrm__id = ${rf.id} and asgn__id is null"
                    break
            }
            cn.eachRow(tx.toString()){
                totales[rf.id] = it.suma
            }
        }
        cn.close()

        unidades = unidades.sort { it.nombre }

        params.actual = params.actual?:actual.id
        params.numero = params.numero
        params.requirente = params.requirente

        return [reformas: reformas, totales: totales, unidades: unidades, params: params]
    }

    /**
     * Acción que muestra la lista de las reformas solicitadas para q un analista de planificación apruebe y pida firmas o niegue
     */
    def pendientes() {

        def estadoPendiente = EstadoAval.findByCodigo("P01")
        def estadoDevueltoReq = EstadoAval.findByCodigo("D01")
        def estadoPorRevisar = EstadoAval.findByCodigo("R01")
        def estadoSolicitado = EstadoAval.findByCodigo("E01")
        def estadoDevueltoDirReq = EstadoAval.findByCodigo("D02")
        def estadoDevueltoAnPlan = EstadoAval.findByCodigo("D03")
        def estadoSolicitadoSinFirma = EstadoAval.findByCodigo("EF4")
        def tx = ""
        def cn = dbConnectionService.getConnection()
        def totales = [:]
        def estados = []
        def perfil = session.perfil.codigo.toString()
        def unidades
        unidades = UnidadEjecutora.get(session.unidad.id).getUnidadesPorPerfil(perfil)

        def filtroDirector = null,
            filtroPersona = null

        switch (perfil) {
            case "RQ":
                estados = [estadoPendiente, estadoDevueltoReq]
                filtroPersona = Persona.get(session.usuario.id)
                break;
            case "DRRQ":
                estados = [estadoPorRevisar, estadoDevueltoDirReq]
                filtroDirector = Persona.get(session.usuario.id)
                break;
            case "ASPL":    // analista de planificacion
                estados = [estadoSolicitado, estadoDevueltoAnPlan]
                break;
        }

        def reformas = Reforma.withCriteria {
            eq("tipo", "R")
            ne("tipoSolicitud", "Q")
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

//        def unidadesList
//
//        def uns = UnidadEjecutora.get(session.unidad.id).getUnidadesPorPerfil(perfil)
//        unidadesList = Asignacion.withCriteria {
//            inList("unidad", uns)
//            projections {
//                distinct("unidad")
//            }
//        }
//
//        unidadesList = unidadesList.sort { it.nombre }

        def gerencias = []

        reformas.each {rf ->
            switch (rf.tipoSolicitud){
                case ['E', 'P', 'A']:
                    tx = "select sum(dtrfvlor) suma from dtrf where rfrm__id = ${rf.id} and asgn__id is not null"
                    break
                case ['X']:
                    tx = "select sum(dtrfvlor) suma from dtrf where rfrm__id = ${rf.id} and tprf__id != '6'"
                    break
                default:
                    tx = "select sum(dtrfvlor) suma from dtrf where rfrm__id = ${rf.id} and asgn__id is null"
                    break
            }
            cn.eachRow(tx.toString()){
                totales[rf.id] = it.suma
            }
        }
        cn.close()

        reformas.each {
            gerencias += firmasService.requirentes(it.persona.unidad)
        }

//        println("reformas " + reformas)
//        println("gerencias " + gerencias)

        return [reformas: reformas, actual: actual, gerencias: gerencias, totales: totales]
    }

    /**
     * Acción llamada con ajax que muestra un historial de reformas solicitadas
     */
    def historial_ajax() {
//        def estadoAprobado = EstadoAval.findByCodigo("E02")
//        def estadoNegado = EstadoAval.findByCodigo("E03")
//        def estadoAprobadoSinFirma = EstadoAval.findByCodigo("EF1")
        def tipo = 'R'
//        def estados = [estadoAprobadoSinFirma, estadoAprobado, estadoNegado]
        def estados = EstadoAval.list()
//        def reformas = Reforma.findAllByEstadoInListAndTipo(estados, tipo, [sort: "fecha", order: "desc"])
        def reformas
        def perfil = session.perfil.codigo.toString()
//        def perfiles = ["GAF", "ASPL"]
        def unidades
//        if (perfiles.contains(perfil)) {
//            unidades = UnidadEjecutora.list()
//        } else {
//            unidades = proyectosService.getUnidadesUnidad(UnidadEjecutora.get(session.unidad.id))
//        }
//        unidades = proyectosService.getUnidadesUnidad(UnidadEjecutora.get(session.unidad.id), perfil)
        unidades = UnidadEjecutora.get(session.unidad.id).getUnidadesPorPerfil(perfil)
        reformas = Reforma.withCriteria {
            eq("tipo", tipo)
            inList("estado", estados)
            persona {
                inList("unidad", unidades)
            }
            order("fecha", "desc")
        }

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
//            reformas = Reforma.withCriteria {
//                eq("tipo", tipo)
//                inList("estado", estados)
//                inList("persona", personas)
//                order("fecha", "desc")
//            }
//        }
        return [reformas: reformas]
    }

    /**
     * Acción llamada con ajax que guarda el nombre de una actividad modificado por el analista de planificación
     */
    def guardarNombreActividad_ajax() {
        def detalle = DetalleReforma.get(params.id)
        detalle.descripcionNuevaActividad = params.act.trim()
        if (detalle.save(flush: true)) {
            render "SUCCESS*Descripción de la actividad cambiada exitosamente"
        } else {
            render "ERROR*" + renderErrors(bean: detalle)
        }
    }

    /**
     * Acción para que el analista de planificación apruebe y pida firmas o niegue la solicitud
     */
    def procesar() {
        def reforma = Reforma.get(params.id)
//        println "init: reforma=${reforma.id} estado reforma id=${reforma.estado.id} cod=${reforma.estado.codigo}"
        if (reforma.estado.codigo == "E01" || reforma.estado.codigo == "D03") {
            def d

            switch (reforma.tipoSolicitud) {
                case "E": //existente
                    d = ReportesReformaController.generaDetallesSolicitudExistente(reforma)
                    break;
                case "A": //actividad
                    d = ReportesReformaController.generaDetallesSolicitudActividad(reforma)
                    break;
                case "C": //incremento actividad (a nuevas actividades sin origen)
                    d = ReportesReformaController.generaDetallesSolicitudIncrementoActividad(reforma)
                    break;
                case "P": //partida
                    d = ReportesReformaController.generaDetallesSolicitudPartida(reforma)
                    break;
                case "I": //incremento
                    d = ReportesReformaController.generaDetallesSolicitudIncremento(reforma)
                    break;
                case "X": //incremento
                    d = null
                    break;
            }
            def det = d?.det
            def det2 = d?.det2
            def detallado = d?.detallado
            def total = d?.total
            def totalSaldo
            if(d?.saldo){
                totalSaldo = Math.round(d?.saldo?:0 * 100)/100
            }else{
                totalSaldo = 0
            }

            def detallesX = null

            if(reforma?.tipoSolicitud == 'X'){
                detallesX = DetalleReforma.findAllByReforma(reforma)

            }
//            println "........ totalSaldo: $totalSaldo"

            def firmas = firmasService.listaFirmasCombos()
            return [reforma : reforma, det: det, det2: det2, detallado: detallado, total: total, personas: firmas.directores,
                    gerentes: firmas.gerentes, tipo: reforma.tipoSolicitud, totalSaldo: totalSaldo, detallesX: detallesX]
        } else {
//            println "redireccionando: reforma=${reforma.id} estado reforma=${reforma.estado.codigo}"
            redirect(action: "pendientes")
        }
    }

    def procesar_old() {
        def reforma = Reforma.get(params.id)
        println "init: reforma=${reforma.id} estado reforma id=${reforma.estado.id} cod=${reforma.estado.codigo}"
        if (reforma.estado.codigo == "E01" || reforma.estado.codigo == "D02") {
            def detalles, detalles2 = [:]

            if (reforma.tipoSolicitud == 'I' || reforma.tipoSolicitud == 'C') {
                detalles = DetalleReforma.findAllByReformaAndAsignacionOrigenIsNotNull(reforma, [sort: "id"])
                detalles2 = DetalleReforma.findAllByReformaAndAsignacionOrigenIsNull(reforma, [sort: "id"])
            } else {
                detalles = DetalleReforma.findAllByReforma(reforma, [sort: "id"])
            }

            def total = 0
            if (detalles.size() > 0) {
                total = detalles.sum { it.valor }
            }
//            def unidad = UnidadEjecutora.findByCodigo("DPI") // DIRECCIÓN DE PLANIFICACIÓN E INVERSIÓN
//            def personasFirmas = Persona.findAllByUnidad(unidad)
//            def gerentes = Persona.findAllByUnidad(unidad.padre)
            def firmas = firmasService.listaFirmasCombos()
            return [reforma: reforma, detalles: detalles, detalles2: detalles2, total: total, personas: firmas.directores, gerentes: firmas.gerentes]
        } else {
            println "redireccionando: reforma=${reforma.id} estado reforma=${reforma.estado.codigo}"
            redirect(action: "pendientes")
        }
    }

    /**
     * Acción llamada con ajax que le permite al analista de planificación seleccionar la asignación de origen para una asignación de destino en una reforma de incremento
     */
    def asignarOrigen_ajax() {
        def reforma = Reforma.get(params.id)
        def detalle = DetalleReforma.get(params.det.toLong())
//        def proyectos3 = Proyecto.findAllByAprobadoPoa('S', [sort: 'nombre'])
//        def proyectos3 = proyectosService.getProyectosUnidad(UnidadEjecutora.get(session.unidad.id), reforma.anio)
        def proyectos3 = UnidadEjecutora.get(session.unidad.id).getProyectosUnidad(reforma.anio, session.perfil.codigo.toString())

        return [reforma: reforma, proyectos: proyectos3, detalle: detalle, anio: reforma.anio.id]
    }

    /**
     * Acción llamada con ajax que guarda los pares de asignaciones seleccionados por el asistente de planificación para completar la solicitud de incremento
     */
    def asignarParAsignaciones_ajax() {
//        println "\tasignar par asignaciones: " + params
        def detalle = DetalleReforma.get(params.det.toLong())
        def asignacionOrigen = Asignacion.get(params.asg.toLong())
        def monto = ((params.mnt.toString().replaceAll(",", "")).toDouble() * 100).round() / 100

//        println "\tdetalle ANTES: ${detalle.id}, monto: ${detalle.valor}, saldo: ${detalle.saldo}"
        def nuevoDetalle = new DetalleReforma()
        nuevoDetalle.properties = detalle.properties
        nuevoDetalle.saldo = 0
        nuevoDetalle.valor = monto
        nuevoDetalle.asignacionOrigen = asignacionOrigen
        nuevoDetalle.detalleOriginal = detalle
        nuevoDetalle.valorOrigenInicial = asignacionOrigen.priorizado
        if (nuevoDetalle.save(flush: true)) {
            detalle.saldo -= monto
            if (!detalle.save(flush: true)) {
                println "error al disminuir saldo de detalle: " + detalle.errors
            }
//            println "\tdetalle DESPUES: ${detalle.id}, monto: ${detalle.valor}, saldo: ${detalle.saldo}"
        } else {
            println "error al guardar nuevo detalle: " + nuevoDetalle.errors
            render "ERROR*" + renderErrors(bean: nuevoDetalle)
            return
        }
        render "SUCCESS*Detalle guardado exitosamente"
    }

    /**
     * Acción llamada con ajax que eliminar un par de asignaciones seleccionado por el asistente de planificación para completar la solicitud de incremento
     */
    def eliminarParAsignaciones_ajax() {
        def detalle = DetalleReforma.get(params.id.toLong())
        def detalleOriginal = detalle.detalleOriginal
//        def detalleOriginal = []
//        if (detalle.reforma.tipoSolicitud == 'I') {
//            detalleOriginal = DetalleReforma.findAllByAsignacionDestinoAndAsignacionOrigenIsNull(detalle.asignacionDestino)
//        } else if (detalle.reforma.tipoSolicitud == 'C') {
//            detalleOriginal = DetalleReforma.findAllByDescripcionNuevaActividadAndAsignacionOrigenIsNull(detalle.descripcionNuevaActividad)
//        }
//        if (detalleOriginal.size() == 1) {
        def monto = detalle.valor
        try {
//            detalleOriginal = detalleOriginal.first()
            detalle.delete(flush: true)
//            println "saldo antes: " + detalleOriginal.saldo
            detalleOriginal.saldo += monto
//            println "saldo despues: " + detalleOriginal.saldo
            if (detalleOriginal.save(flush: true)) {
//                println "saldo saved"
                render "SUCCESS*Detalle eliminado exitosamente"
            } else {
                render "ERROR*" + renderErrors(bean: detalleOriginal)
            }
        } catch (e) {
            println "ERROR al eliminar detalle"
            e.printStackTrace()
            render "ERROR*Ha ocurrido un error grave, no puede eliminar este detalle"
        }
//        } else {
//            println "Detalle original: ${detalleOriginal}"
//            render "ERROR*Ha ocurrido un error grave, no puede eliminar este detalle"
//        }
    }

    def guardar() {
        def usu = Persona.get(session.usuario.id)
        def reforma = Reforma.get(params.id)
        reforma.analista = usu
        reforma.nota = params.observaciones.trim()
        reforma.save(flush: true)
        render "SUCCESS*Observaciones guardadas exitosamente"
    }

    /**
     * Acción que marca una solicitud como aprobada y a la espera de las firmas de aprobación
     */
    def aprobar() {
        def usu = Persona.get(session.usuario.id)
//        def ok = params.auth.toString().trim().encodeAsMD5() == usu.autorizacion
        def ok = true
        if (ok) {
            def now = new Date()
            def reforma = Reforma.get(params.id)
            def estadoAprobadoSinFirmas = EstadoAval.findByCodigo("EF1")

            def edit = reforma.estado.codigo == "D02"

            reforma.estado = estadoAprobadoSinFirmas
            reforma.fechaRevision = now
            reforma.analista = usu
            reforma.nota = params.observaciones.trim()

            def personaFirma1
            def personaFirma2

            def tipoStr = elm.tipoReformaStr(tipo: 'Reforma', tipoSolicitud: reforma.tipoSolicitud)

            def accion
            def mensaje = "Aprobación de ${tipoStr}"

            //E: existente, A: actividad, P: partida, I: incremento
            switch (reforma.tipoSolicitud) {
                case "E":
                    accion = "existentePreviewReforma"
//                    accion = "existenteReforma"
//                mensaje = "Aprobación de ${tipoStr}"
                    break;
                case "A":
                    accion = "actividadPreviewReforma"
//                    accion = "actividadReforma"
//                mensaje = "Aprobación de ${tipoStr}"
                    break;
                case "C":
                    accion = "incrementoActividadPreviewReforma"
//                mensaje = "Aprobación de reforma de incremento a nuevas actividades"
                    break;
                case "P":
//                    accion = "partidaPreviewReforma"
                    accion = "partidaReforma"
//                mensaje = "Aprobación de reforma a nuevas partidas"
                    break;
                case "I":
                    accion = "incrementoPreviewReforma"
//                    accion = "incrementoReforma"
//                mensaje = "Aprobación de reforma de incremento"
                    params.each { k, v ->
                        if (k.toString().startsWith("r")) {
                            def parts = v.split("_")
                            if (parts.size() == 2) {
                                def detalle = DetalleReforma.get(parts[0].toLong())
                                def asignacionOrigen = Asignacion.get(parts[1].toLong())
                                detalle.asignacionOrigen = asignacionOrigen
                                detalle.save(flush: true)
                            }
                        }
                    }
                    break;
                case "X":
                    accion = "nuevaReformaPreviewReforma"
                    break;

                default:
                    accion = "existentePreviewReforma"
                    mensaje = "Tipo de solicitud ${reforma.tipoSolicitud} no reconocido"
            }

            if (edit) {
                def firma1 = reforma.firma1
                def firma2 = reforma.firma2

                personaFirma1 = firma1.usuario
                personaFirma2 = firma2.usuario

                firma1.estado = "S"
                firma1.concepto = "${mensaje} (${reforma.fecha.format('dd-MM-yyyy')}): " + reforma.concepto
                firma1.accionVer = accion
                firma2.estado = "S"
                firma2.concepto = "${mensaje} (${reforma.fecha.format('dd-MM-yyyy')}): " + reforma.concepto
                firma2.accionVer = accion

                firma1.save(flush: true)
                firma2.save(flush: true)

            } else {
                personaFirma1 = Persona.get(params.firma1.toLong())
                personaFirma2 = Persona.get(params.firma2.toLong())

                def firma1 = new Firma()
                firma1.usuario = personaFirma1
                firma1.fecha = now
                if(reforma.tipoSolicitud == 'X'){
                    firma1.accion = "firmarAprobarNuevaReforma"
                }else{
                    firma1.accion = "firmarAprobarReforma"
                }
                firma1.controlador = "reforma"
                firma1.idAccion = reforma.id
                firma1.accionVer = accion
                firma1.controladorVer = "reportesReforma"
                firma1.idAccionVer = reforma.id
                firma1.accionNegar = "devolverAprobarReforma"
                firma1.controladorNegar = "reforma"
                firma1.idAccionNegar = reforma.id
                firma1.concepto = "${mensaje} (${reforma.fecha.format('dd-MM-yyyy')}): " + reforma.concepto
                firma1.tipoFirma = "RFRM"
                if (!firma1.save(flush: true)) {
                    println "error al crear firma: " + firma1.errors
                    render "ERROR*" + renderErrors(bean: firma1)
                    return
                }
                reforma.firma1 = firma1

                def firma2 = new Firma()
                firma2.usuario = personaFirma2
                firma2.fecha = now
                if(reforma.tipoSolicitud == 'X'){
                    firma2.accion = "firmarAprobarNuevaReforma"
                }else{
                    firma2.accion = "firmarAprobarReforma"
                }
                firma2.controlador = "reforma"
                firma2.idAccion = reforma.id
                firma2.accionVer = accion
                firma2.controladorVer = "reportesReforma"
                firma2.idAccionVer = reforma.id
                firma2.accionNegar = "devolverAprobarReforma"
                firma2.controladorNegar = "reforma"
                firma2.idAccionNegar = reforma.id
                firma2.concepto = "${mensaje} (${reforma.fecha.format('dd-MM-yyyy')}): " + reforma.concepto
                firma2.tipoFirma = "RFRM"
                if (!firma2.save(flush: true)) {
                    println "error al crear firma: " + firma2.errors
                    render "ERROR*" + renderErrors(bean: firma2)
                    return
                }
                reforma.firma2 = firma2
            }

            def alerta = new Alerta()
            alerta.from = usu
            alerta.persona = personaFirma1
            alerta.fechaEnvio = now
            alerta.mensaje = "${mensaje} (${reforma.fecha.format('dd-MM-yyyy')}): " + reforma.concepto
            alerta.controlador = "firma"
            alerta.accion = "firmasPendientes"
            alerta.id_remoto = reforma.id /*agregado*/
            if (!alerta.save(flush: true)) {
                println "error alerta: " + alerta.errors
            }
            def alerta2 = new Alerta()
            alerta2.from = usu
            alerta2.persona = personaFirma2
            alerta2.fechaEnvio = now
            alerta2.mensaje = "${mensaje} (${reforma.fecha.format('dd-MM-yyyy')}): " + reforma.concepto
            alerta2.controlador = "firma"
            alerta2.accion = "firmasPendientes"
            alerta2.id_remoto = alerta.id_remoto
            if (!alerta2.save(flush: true)) {
                println "error alerta: " + alerta2.errors
            }

            reforma.save(flush: true)

            render "SUCCESS*Firmas solicitadas exitosamente"
        } else {
            render "ERROR*Clave de autorización incorrecta"
        }
    }

    /**
     * Acción que marca una solicitud como negada
     */
    def negar() {
        def usu = Persona.get(session.usuario.id)
        def now = new Date()
//        def ok = params.auth.toString().trim().encodeAsMD5() == usu.autorizacion
        def ok = true
        if (ok) {
            def reforma = Reforma.get(params.id)
            def estadoNegado = EstadoAval.findByCodigo("E03")
            reforma.estado = estadoNegado
            reforma.fechaRevision = now
            reforma.analista = usu
            reforma.save(flush: true)
            render "SUCCESS*Solicitud negada exitosamente"
        } else {
            render "ERROR*Clave de autorización incorrecta"
        }
    }

    /**
     * no vale
     */
    def existente_old() {
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

        def campos = ["numero": ["Número", "string"], "descripcion": ["Descripción", "string"]]
//        println "pro "+proyectos
//        def unidad = UnidadEjecutora.findByCodigo("DPI") // DIRECCIÓN DE PLANIFICACIÓN E INVERSIÓN
//        def personasFirmas = Persona.findAllByUnidad(unidad)
//        def gerentes = Persona.findAllByUnidad(unidad.padre)
        def firmas = firmasService.listaFirmasCombos()

        def totalOrigen = 0
        def totalDestino = 0

        return [proyectos      : proyectos, proyectos2: proyectos2, actual: actual, campos: campos, personas: firmas.directores,
                personasGerente: firmas.gerentes, totalOrigen: totalOrigen, totalDestino: totalDestino]
    }

    /**
     * Acción llamada con ajax que elimina un detalle de una reforma existente
     */
    def deleteDetalle_ajax() {
        def detalle = DetalleReforma.get(params.id)
        try {
            detalle.delete(flush: true)
        } catch (e) {
            render "ERROR*Ha ocurrido un error al eliminar el detalle de la reforma"
        }
        render "SUCCESS*Detalle eliminado exitosamente"
    }


    def saveNuevaReforma_ajax () {
        println("save nueva ref " + params)
        def anio = Anio.get(params.anio.toLong())
        def personaRevisa
        def estado = EstadoAval.findByCodigo("P01") //pendiente
        if (params.send == "S") {
            estado = EstadoAval.findByCodigo("R01") //por revisar
        }
        def now = new Date()
        def usu = Persona.get(session.usuario.id)
        def reforma
        if (params.id) {
            reforma = Reforma.get(params.id)
            personaRevisa = Persona.get(params.firma.toLong())
        }

        reforma.anio = anio
        reforma.persona = usu
        reforma.estado = estado
        reforma.concepto = params.concepto.trim()
        reforma.fecha = now
        reforma.tipo = "R"
        reforma.tipoSolicitud = "X"
        reforma.director = personaRevisa
        if (!reforma.save(flush: true)) {
            println "error al guardar la reforma: " + reforma.errors
            render "ERROR*" + renderErrors(bean: reforma)
            return
        }

        def tipoStr = elm.tipoReformaStr(tipo: 'Reforma', tipoSolicitud: reforma.tipoSolicitud)

        if (params.send == "S") {
            println "nueva reforma : se hace la alerta y se manda mail"
            def alerta = new Alerta()
            alerta.from = usu
            alerta.persona = personaRevisa
            alerta.fechaEnvio = now
            alerta.mensaje = "Solicitud de ${tipoStr} (${now.format('dd-MM-yyyy')}): " + reforma.concepto
            alerta.controlador = "reforma"
            alerta.accion = "pendientes"
            alerta.id_remoto = reforma.id
            if (!alerta.save(flush: true)) {
                println "error alerta: " + alerta.errors
                render "ERROR*" + renderErrors(bean: reforma)
            }
            try {
                def mail = personaRevisa.mail
                if (mail) {
                    mailService.sendMail {
                        to mail
                        subject "Solicitud de reforma (${now.format('dd-MM-yyyy')}): " + reforma.concepto
                        body "Tiene una Solicitud de reforma pendiente que requiere su revisión"
                    }
                } else {
                    println "El usuario ${personaRevisa} no tiene email"
                }
                render "SUCCESS*Reforma solicitada exitosamente"
            } catch (e) {
                println "error email " + e.printStackTrace()
            }
        } else {
            println "no se manda: no se hace alerta ni se manda mail"
        }

        render "SUCCESS*Reforma solicitada exitosamente"
    }


    /**
     * Acción llamada con ajax que guarda una solicitud de reforma de asignaciones existentes
     */
    def saveExistente_ajax() {
        def anio = Anio.get(params.anio.toLong())
        def personaRevisa
        def estado = EstadoAval.findByCodigo("P01") //pendiente
        if (params.send == "S") {
            estado = EstadoAval.findByCodigo("R01") //por revisar
        }

        def now = new Date()
        def usu = Persona.get(session.usuario.id)

        def reforma
        if (params.id) {
            reforma = Reforma.get(params.id)
            if (!reforma) {
                reforma = new Reforma()
            }
            personaRevisa = reforma.director
        } else {
            reforma = new Reforma()
            personaRevisa = Persona.get(params.firma.toLong())
        }

        reforma.anio = anio
        reforma.persona = usu
        reforma.estado = estado
        reforma.concepto = params.concepto.trim()
        reforma.fecha = now
        reforma.tipo = "R"
        reforma.tipoSolicitud = "E"
        reforma.director = personaRevisa
        if (!reforma.save(flush: true)) {
            println "error al crear la reforma: " + reforma.errors
            render "ERROR*" + renderErrors(bean: reforma)
            return
        }
        def tipoStr = elm.tipoReformaStr(tipo: 'Reforma', tipoSolicitud: reforma.tipoSolicitud)
//        if (params.id) {
//            def firmaRevisa = reforma.firmaSolicitud
//            firmaRevisa.estado = "S"
//            firmaRevisa.concepto = "${tipoStr} (${now.format('dd-MM-yyyy')}): " + reforma.concepto
//            firmaRevisa.save(flush: true)
//        } else {
//            def firmaRevisa = new Firma()
//            firmaRevisa.usuario = personaRevisa
//            firmaRevisa.fecha = now
//            firmaRevisa.accion = "firmarReforma"
//            firmaRevisa.controlador = "reforma"
//            firmaRevisa.idAccion = reforma.id
//            firmaRevisa.accionVer = "existente"
//            firmaRevisa.controladorVer = "reportesReforma"
//            firmaRevisa.idAccionVer = reforma.id
//            firmaRevisa.accionNegar = "devolverReforma"
//            firmaRevisa.controladorNegar = "reforma"
//            firmaRevisa.idAccionNegar = reforma.id
//            firmaRevisa.concepto = "${tipoStr} (${now.format('dd-MM-yyyy')}): " + reforma.concepto
//            firmaRevisa.tipoFirma = "RFRM"
//            if (!firmaRevisa.save(flush: true)) {
//                println "error al crear firma: " + firmaRevisa.errors
//                render "ERROR*" + renderErrors(bean: firmaRevisa)
//                return
//            }
//            reforma.firmaSolicitud = firmaRevisa
//            reforma.save(flush: true)
//        }
        if (params.send == "S") {
            println "se va a mandar: se hace la alerta y se manda mail"
            def alerta = new Alerta()
            alerta.from = usu
            alerta.persona = personaRevisa
            alerta.fechaEnvio = now
            alerta.mensaje = "Solicitud de ${tipoStr} (${now.format('dd-MM-yyyy')}): " + reforma.concepto
            alerta.controlador = "reforma"
            alerta.accion = "pendientes"
            alerta.id_remoto = reforma.id
            if (!alerta.save(flush: true)) {
                println "error alerta: " + alerta.errors
            }
            try {
                def mail = personaRevisa.mail
                if (mail) {

                    mailService.sendMail {
                        to mail
                        subject "Solicitud de ${tipoStr} (${now.format('dd-MM-yyyy')}): " + reforma.concepto
                        body "Tiene una Solicitud de ${tipoStr} pendiente que requiere su revisión"
                    }

                } else {
                    println "El usuario ${personaRevisa} no tiene email"
                }
            } catch (e) {
                println "eror email " + e.printStackTrace()
            }
        } else {
            println "no se manda: no se hace alerta ni se manda mail"
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
                render "SUCCESS*Reforma solicitada exitosamente"
            } else {
                render "SUCCESS*Reforma guardada exitosamente*" + reforma.id
            }
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
        def estado = EstadoAval.findByCodigo("P01") //pendiente
        if (params.send == "S") {
            estado = EstadoAval.findByCodigo("R01") //por revisar
        }

        def now = new Date()
        def usu = Persona.get(session.usuario.id)

        def reforma
        if (params.id) {
            reforma = Reforma.get(params.id)
            if (!reforma) {
                reforma = new Reforma()
            }
            personaRevisa = reforma.director
        } else {
            reforma = new Reforma()
            personaRevisa = Persona.get(params.firma.toLong())
        }

        reforma.anio = anio
        reforma.persona = usu
        reforma.estado = estado
        reforma.concepto = params.concepto.trim()
        reforma.fecha = now
        reforma.tipo = "R"
        reforma.tipoSolicitud = "A"
        reforma.director = personaRevisa
        if (!reforma.save(flush: true)) {
            println "error al crear la reforma: " + reforma.errors
            render "ERROR*" + renderErrors(bean: reforma)
            return
        }
        def tipoStr = elm.tipoReformaStr(tipo: 'Reforma', tipoSolicitud: reforma.tipoSolicitud)
//        if (params.id) {
//            def firmaRevisa = reforma.firmaSolicitud
//            firmaRevisa.estado = "S"
//            firmaRevisa.concepto = "${tipoStr} (${now.format('dd-MM-yyyy')}): " + reforma.concepto
//            firmaRevisa.save(flush: true)
//        } else {
//            def firmaRevisa = new Firma()
//            firmaRevisa.usuario = personaRevisa
//            firmaRevisa.fecha = now
//            firmaRevisa.accion = "firmarReforma"
//            firmaRevisa.controlador = "reforma"
//            firmaRevisa.idAccion = reforma.id
//            firmaRevisa.accionVer = "actividad"
//            firmaRevisa.controladorVer = "reportesReforma"
//            firmaRevisa.idAccionVer = reforma.id
//            firmaRevisa.accionNegar = "devolverReforma"
//            firmaRevisa.controladorNegar = "reforma"
//            firmaRevisa.idAccionNegar = reforma.id
//            firmaRevisa.concepto = "${tipoStr} (${now.format('dd-MM-yyyy')}): " + reforma.concepto
//            firmaRevisa.tipoFirma = "RFRM"
//            if (!firmaRevisa.save(flush: true)) {
//                println "error al crear firma: " + firmaRevisa.errors
//                render "ERROR*" + renderErrors(bean: firmaRevisa)
//                return
//            }
//            reforma.firmaSolicitud = firmaRevisa
//            reforma.save(flush: true)
//        }
        if (params.send == "S") {
            println "se va a mandar: se hace la alerta y se manda mail"
            def alerta = new Alerta()
            alerta.from = usu
            alerta.persona = personaRevisa
            alerta.fechaEnvio = now
            alerta.mensaje = "Solicitud de ${tipoStr} (${now.format('dd-MM-yyyy')}): " + reforma.concepto
            alerta.controlador = "reforma"
            alerta.accion = "pendientes"
            alerta.id_remoto = reforma.id
            if (!alerta.save(flush: true)) {
                println "error alerta: " + alerta.errors
            }
            try {
                def mail = personaRevisa.mail
                if (mail) {

                    mailService.sendMail {
                        to mail
                        subject "Solicitud de ${tipoStr} (${now.format('dd-MM-yyyy')}): " + reforma.concepto
                        body "Tiene una Solicitud de ${tipoStr} pendiente que requiere su revisión"
                    }

                } else {
                    println "El usuario ${personaRevisa} no tiene email"
                }
            } catch (e) {
                println "eror email " + e.printStackTrace()
            }
        } else {
            println "no se manda: no se hace alerta ni se manda mail"
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

            detalle.valorOrigenInicial = asignacionOrigen.priorizado
            detalle.valorDestinoInicial = 0

            if (det.categoria) {
                detalle.categoria = Categoria.get(det.categoria.toLong())
            }

            if (!detalle.save(flush: true)) {
                println "error al guardar detalle: " + detalle.errors
                errores += renderErrors(bean: detalle)
            }
        }
        if (errores == "") {
            if (params.send == "S") {
                render "SUCCESS*Reforma solicitada exitosamente"
            } else {
                render "SUCCESS*Reforma guardada exitosamente*" + reforma.id
            }
        } else {
            render "ERROR*" + errores
        }
    }

    /**
     * Acción llamada con ajax que guarda una solicitud de reforma de incremento en nueva actividad
     */
    def saveIncrementoActividad_ajax() {
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
        def estado = EstadoAval.findByCodigo("P01") //pendiente
        if (params.send == "S") {
            estado = EstadoAval.findByCodigo("R01") //por revisar
        }

        def now = new Date()
        def usu = Persona.get(session.usuario.id)

        def reforma
        if (params.id) {
            reforma = Reforma.get(params.id)
            if (!reforma) {
                reforma = new Reforma()
            }
            personaRevisa = reforma.director
        } else {
            reforma = new Reforma()
            personaRevisa = Persona.get(params.firma.toLong())
        }

        reforma.anio = anio
        reforma.persona = usu
        reforma.estado = estado
        reforma.concepto = params.concepto.trim()
        reforma.fecha = now
        reforma.tipo = "R"
        reforma.tipoSolicitud = "C"
        reforma.director = personaRevisa
        if (!reforma.save(flush: true)) {
            println "error al crear la reforma: " + reforma.errors
            render "ERROR*" + renderErrors(bean: reforma)
            return
        }
        def tipoStr = elm.tipoReformaStr(tipo: 'Reforma', tipoSolicitud: reforma.tipoSolicitud)
//        if (params.id) {
//            def firmaRevisa = reforma.firmaSolicitud
//            firmaRevisa.estado = "S"
//            firmaRevisa.concepto = "${tipoStr} (${now.format('dd-MM-yyyy')}): " + reforma.concepto
//            firmaRevisa.save(flush: true)
//        } else {
//            def firmaRevisa = new Firma()
//            firmaRevisa.usuario = personaRevisa
//            firmaRevisa.fecha = now
//            firmaRevisa.accion = "firmarReforma"
//            firmaRevisa.controlador = "reforma"
//            firmaRevisa.idAccion = reforma.id
//            firmaRevisa.accionVer = "incrementoActividad"
//            firmaRevisa.controladorVer = "reportesReforma"
//            firmaRevisa.idAccionVer = reforma.id
//            firmaRevisa.accionNegar = "devolverReforma"
//            firmaRevisa.controladorNegar = "reforma"
//            firmaRevisa.idAccionNegar = reforma.id
//            firmaRevisa.concepto = "${tipoStr} (${now.format('dd-MM-yyyy')}): " + reforma.concepto
//            firmaRevisa.tipoFirma = "RFRM"
//            if (!firmaRevisa.save(flush: true)) {
//                println "error al crear firma: " + firmaRevisa.errors
//                render "ERROR*" + renderErrors(bean: firmaRevisa)
//                return
//            }
//            reforma.firmaSolicitud = firmaRevisa
//            reforma.save(flush: true)
//        }
        if (params.send == "S") {
            println "se va a mandar: se hace la alerta y se manda mail"
            def alerta = new Alerta()
            alerta.from = usu
            alerta.persona = personaRevisa
            alerta.fechaEnvio = now
            alerta.mensaje = "Solicitud de ${tipoStr} (${now.format('dd-MM-yyyy')}): " + reforma.concepto
            alerta.controlador = "reforma"
            alerta.accion = "pendientes"
            alerta.id_remoto = reforma.id
            if (!alerta.save(flush: true)) {
                println "error alerta: " + alerta.errors
            }
            try {
                def mail = personaRevisa.mail
                if (mail) {

                    mailService.sendMail {
                        to mail
                        subject "Solicitud de ${tipoStr} (${now.format('dd-MM-yyyy')}): " + reforma.concepto
                        body "Tiene una Solicitud de ${tipoStr} pendiente que requiere su revisión"
                    }

                } else {
                    println "El usuario ${personaRevisa} no tiene email"
                }
            } catch (e) {
                println "eror email " + e.printStackTrace()
            }
        } else {
            println "no se manda: no se hace alerta ni se manda mail"
        }

        def errores = ""
        detalles.each { k, det ->
            def monto = det.monto.replaceAll(",", "").toDouble()

//            def asignacionOrigen = Asignacion.get(det.origen.toLong())
            def presupuesto = Presupuesto.get(det.partida.toLong())
            def componente = MarcoLogico.get(det.componente.toLong())

            def detalle = new DetalleReforma()
            detalle.reforma = reforma
//            detalle.asignacionOrigen = asignacionOrigen
            detalle.valor = monto
            detalle.saldo = monto
            detalle.presupuesto = presupuesto
            detalle.componente = componente
            detalle.descripcionNuevaActividad = det.actividad.trim()
            detalle.fechaInicioNuevaActividad = new Date().parse("dd-MM-yyyy", det.inicio)
            detalle.fechaFinNuevaActividad = new Date().parse("dd-MM-yyyy", det.fin)
            detalle.fuente = Fuente.get(det.fuente.toLong())

            detalle.valorOrigenInicial = 0
            detalle.valorDestinoInicial = 0

            if (det.categoria) {
                detalle.categoria = Categoria.get(det.categoria.toLong())
            }

            if (!detalle.save(flush: true)) {
                println "error al guardar detalle: " + detalle.errors
                errores += renderErrors(bean: detalle)
            }
        }
        if (errores == "") {
            if (params.send == "S") {
                render "SUCCESS*Reforma solicitada exitosamente"
            } else {
                render "SUCCESS*Reforma guardada exitosamente*" + reforma.id
            }
        } else {
            render "ERROR*" + errores
        }
    }

    /**
     * Acción llamada con ajax que guarda una solicitud de reforma de nueva actividad
     */
    def saveIncremento_ajax() {
//        println "Incremento"
//        println params
//        render "ERROR*Aun no"
        def anio = Anio.get(params.anio.toLong())
        def personaRevisa
        def estado = EstadoAval.findByCodigo("P01") //pendiente
        if (params.send == "S") {
            estado = EstadoAval.findByCodigo("R01") //por revisar
        }

        def now = new Date()
        def usu = Persona.get(session.usuario.id)

        def reforma
        if (params.id) {
            reforma = Reforma.get(params.id)
            if (!reforma) {
                reforma = new Reforma()
            }
            personaRevisa = reforma.director
        } else {
            reforma = new Reforma()
            personaRevisa = Persona.get(params.firma.toLong())
        }

        reforma.anio = anio
        reforma.persona = usu
        reforma.estado = estado
        reforma.concepto = params.concepto.trim()
        reforma.fecha = now
        reforma.tipo = "R"
        reforma.tipoSolicitud = "I"
        reforma.director = personaRevisa
        if (!reforma.save(flush: true)) {
            println "error al crear la reforma: " + reforma.errors
            render "ERROR*" + renderErrors(bean: reforma)
            return
        }
        def tipoStr = elm.tipoReformaStr(tipo: 'Reforma', tipoSolicitud: reforma.tipoSolicitud)
//        if (params.id) {
//            def firmaRevisa = reforma.firmaSolicitud
//            firmaRevisa.estado = "S"
//            firmaRevisa.concepto = "${tipoStr} (${now.format('dd-MM-yyyy')}): " + reforma.concepto
//            firmaRevisa.save(flush: true)
//        } else {
//            def firmaRevisa = new Firma()
//            firmaRevisa.usuario = personaRevisa
//            firmaRevisa.fecha = now
//            firmaRevisa.accion = "firmarReforma"
//            firmaRevisa.controlador = "reforma"
//            firmaRevisa.idAccion = reforma.id
//            firmaRevisa.accionVer = "incremento"
//            firmaRevisa.controladorVer = "reportesReforma"
//            firmaRevisa.idAccionVer = reforma.id
//            firmaRevisa.accionNegar = "devolverReforma"
//            firmaRevisa.controladorNegar = "reforma"
//            firmaRevisa.idAccionNegar = reforma.id
//            firmaRevisa.concepto = "${tipoStr} (${now.format('dd-MM-yyyy')}): " + reforma.concepto
//            firmaRevisa.tipoFirma = "RFRM"
//            if (!firmaRevisa.save(flush: true)) {
//                println "error al crear firma: " + firmaRevisa.errors
//                render "ERROR*" + renderErrors(bean: firmaRevisa)
//                return
//            }
//            reforma.firmaSolicitud = firmaRevisa
//            reforma.save(flush: true)
//        }
        if (params.send == "S") {
            println "se va a mandar: se hace la alerta y se manda mail"
            def alerta = new Alerta()
            alerta.from = usu
            alerta.persona = personaRevisa
            alerta.fechaEnvio = now
            alerta.mensaje = "Solicitud de ${tipoStr} (${now.format('dd-MM-yyyy')}): " + reforma.concepto
            alerta.controlador = "reforma"
            alerta.accion = "pendientes"
            alerta.id_remoto = reforma.id
            if (!alerta.save(flush: true)) {
                println "error alerta: " + alerta.errors
            }
            try {
                def mail = personaRevisa.mail
                if (mail) {

                    mailService.sendMail {
                        to mail
                        subject "Solicitud de ${tipoStr} (${now.format('dd-MM-yyyy')}): " + reforma.concepto
                        body "Tiene una Solicitud de ${tipoStr} pendiente que requiere su revisión"
                    }

                } else {
                    println "El usuario ${personaRevisa} no tiene email"
                }
            } catch (e) {
                println "eror email " + e.printStackTrace()
            }
        } else {
            println "no se manda: no se hace alerta ni se manda mail"
        }

        def errores = ""
        params.each { k, v ->
            if (k.toString().startsWith("r")) {
                def parts = v.toString().split("_")
                if (parts.size() >= 2) {
                    def destinoId = parts[0].toLong()
                    def monto = parts[1].toString().replaceAll(",", "").toDouble()

                    def asignacionDestino = Asignacion.get(destinoId)

                    def detalle = new DetalleReforma()
                    detalle.reforma = reforma
                    detalle.asignacionDestino = asignacionDestino
                    detalle.valor = monto
                    detalle.saldo = monto

                    detalle.valorOrigenInicial = 0
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
                render "SUCCESS*Reforma solicitada exitosamente"
            } else {
                render "SUCCESS*Reforma guardada exitosamente*" + reforma.id
            }
        } else {
            render "ERROR*" + errores
        }
    }

    /**
     * Acción llamada con ajax que guarda una solicitud de reforma de nueva partida
     */
    def savePartida_ajax() {
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
        def estado = EstadoAval.findByCodigo("P01") //pendiente
        if (params.send == "S") {
            estado = EstadoAval.findByCodigo("R01") //por revisar
        }

        def now = new Date()
        def usu = Persona.get(session.usuario.id)

        def reforma
        if (params.id) {
            reforma = Reforma.get(params.id)
            if (!reforma) {
                reforma = new Reforma()
            }
            personaRevisa = reforma.director
        } else {
            reforma = new Reforma()
            personaRevisa = Persona.get(params.firma.toLong())
        }

        reforma.anio = anio
        reforma.persona = usu
        reforma.estado = estado
        reforma.concepto = params.concepto.trim()
        reforma.fecha = now
        reforma.tipo = "R"
        reforma.tipoSolicitud = "P"
        reforma.director = personaRevisa
        if (!reforma.save(flush: true)) {
            println "error al crear la reforma: " + reforma.errors
            render "ERROR*" + renderErrors(bean: reforma)
            return
        }
        def tipoStr = elm.tipoReformaStr(tipo: 'Reforma', tipoSolicitud: reforma.tipoSolicitud)
//        if (params.id) {
//            def firmaRevisa = reforma.firmaSolicitud
//            firmaRevisa.estado = "S"
//            firmaRevisa.concepto = "${tipoStr} (${now.format('dd-MM-yyyy')}): " + reforma.concepto
//            firmaRevisa.save(flush: true)
//        } else {
//            def firmaRevisa = new Firma()
//            firmaRevisa.usuario = personaRevisa
//            firmaRevisa.fecha = now
//            firmaRevisa.accion = "firmarReforma"
//            firmaRevisa.controlador = "reforma"
//            firmaRevisa.idAccion = reforma.id
//            firmaRevisa.accionVer = "partida"
//            firmaRevisa.controladorVer = "reportesReforma"
//            firmaRevisa.idAccionVer = reforma.id
//            firmaRevisa.accionNegar = "devolverReforma"
//            firmaRevisa.controladorNegar = "reforma"
//            firmaRevisa.idAccionNegar = reforma.id
//            firmaRevisa.concepto = "${tipoStr} (${now.format('dd-MM-yyyy')}): " + reforma.concepto
//            firmaRevisa.tipoFirma = "RFRM"
//            if (!firmaRevisa.save(flush: true)) {
//                println "error al crear firma: " + firmaRevisa.errors
//                render "ERROR*" + renderErrors(bean: firmaRevisa)
//                return
//            }
//            reforma.firmaSolicitud = firmaRevisa
//            reforma.save(flush: true)
//        }
        if (params.send == "S") {
            println "se va a mandar: se hace la alerta y se manda mail"
            def alerta = new Alerta()
            alerta.from = usu
            alerta.persona = personaRevisa
            alerta.fechaEnvio = now
            alerta.mensaje = "Solicitud de ${tipoStr} (${now.format('dd-MM-yyyy')}): " + reforma.concepto
            alerta.controlador = "reforma"
            alerta.accion = "pendientes"
            alerta.id_remoto = reforma.id
            if (!alerta.save(flush: true)) {
                println "error alerta: " + alerta.errors
            }
            try {
                def mail = personaRevisa.mail
                if (mail) {

                    mailService.sendMail {
                        to mail
                        subject "Solicitud de ${tipoStr} (${now.format('dd-MM-yyyy')}): " + reforma.concepto
                        body "Tiene una Solicitud de ${tipoStr} pendiente que requiere su revisión"
                    }

                } else {
                    println "El usuario ${personaRevisa} no tiene email"
                }
            } catch (e) {
                println "eror email " + e.printStackTrace()
            }
        } else {
            println "no se manda: no se hace alerta ni se manda mail"
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
            detalle.presupuesto = presupuesto
            detalle.fuente = asignacionOrigen.fuente

            detalle.valorOrigenInicial = asignacionOrigen.priorizado
            detalle.valorDestinoInicial = 0

            if (!detalle.save(flush: true)) {
                println "error al guardar detalle: " + detalle.errors
                errores += renderErrors(bean: detalle)
            }
        }
        if (errores == "") {
            if (params.send == "S") {
                render "SUCCESS*Reforma solicitada exitosamente"
            } else {
                render "SUCCESS*Reforma guardada exitosamente*" + reforma.id
            }
        } else {
            render "ERROR*" + errores
        }
    }

    /**
     * Acción para que un director requirente devuelva una reforma al requirente
     */
    def devolverReforma() {
        println "devolver: " + params
        def now = new Date()
        def usu = Persona.get(session.usuario.id)

        def reforma = Reforma.get(params.id)
        def tipoStr = elm.tipoReformaStr(tipo: 'Reforma', tipoSolicitud: reforma.tipoSolicitud)
        def accion

        def mensaje = "Devolución de solicitud de ${tipoStr}: "
        //E: existente, A: actividad, P: partida, I: incremento
        switch (reforma.tipoSolicitud) {
            case "E":
                accion = "existente"
//                mensaje = "Devolución de solicitud de reforma a asignaciones existentes: "
                break;
            case "A":
                accion = "actividad"
//                mensaje = "Devolución de solicitud de reforma a nuevas actividades: "
                break;
            case "C":
                accion = "incrementoActividad"
//                mensaje = "Devolución de solicitud de reforma de incremento a nuevas actividades: "
                break;
            case "P":
                accion = "partida"
//                mensaje = "Devolución de solicitud de reforma a nuevas partidas: "
                break;
            case "I":
                accion = "incremento"
//                mensaje = "Devolución de solicitud de reforma de incremento: "
                break;
            default:
                accion = "existente"
//                mensaje = "Devolución de solicitud de reforma a asignaciones existentes: "
        }

//        println "ESTADO ANTES: " + reforma.estado + "    " + reforma.estado.codigo
        reforma.estado = EstadoAval.findByCodigo("D01") //devuelto
//        println "ESTADO DESPUES: " + reforma.estado + "    " + reforma.estado.codigo
        reforma.save(flush: true)
        def alerta = new Alerta()
        alerta.from = usu
        alerta.persona = reforma.persona
        alerta.fechaEnvio = now
        alerta.mensaje = mensaje + reforma.concepto
        alerta.controlador = "reforma"
        alerta.accion = accion
        alerta.id_remoto = reforma.id
        if (!alerta.save(flush: true)) {
            println "error alerta: " + alerta.errors
        }
        render "OK"
    }

    /**
     * Acción para que un director requirente firme una reforma
     */
    def firmarReforma() {
        def firma = Firma.findByKey(params.key)
        if (!firma) {
            response.sendError(403)
        } else {
            def reforma = Reforma.findByFirmaSolicitud(firma)
            def estadoSolicitado = EstadoAval.findByCodigo("E01")

            // debe identificar la gerencia del requienre y pedir número
//            def num = reforma.persona.unidad.gerencia.siguienteNumeroSolicitudReforma
            def num = firmasService.requirentes(reforma.persona.unidad).siguienteNumeroSolicitudReforma

            reforma.numero = num
            reforma.estado = estadoSolicitado
            reforma.save(flush: true)

//            def perfilAnalistaPlan = Prfl.findByCodigo("ASPL")
            def perfilAnalistaPlan = Prfl.findByCodigo("DP")
            def analistas = Sesn.findAllByPerfil(perfilAnalistaPlan).usuario
            def now = new Date()
            def usu = Persona.get(session.usuario.id)
            def tipoStr = elm.tipoReformaStr(tipo: 'Reforma', tipoSolicitud: reforma.tipoSolicitud)
//            def accion
            def mensaje = "Solicitud de ${tipoStr}: "
            //E: existente, A: actividad, P: partida, I: incremento
//            switch (reforma.tipoSolicitud) {
//                case "E":
//                    accion = "existente"
////                    mensaje = "Solicitud de reforma a asignaciones existentes: "
//                    break;
//                case "A":
//                    accion = "actividad"
////                    mensaje = "Solicitud de reforma a nuevas actividades: "
//                    break;
//                case "C":
//                    accion = "incrementoActividad"
////                    mensaje = "Solicitud de reforma de incremento a nuevas actividades: "
//                    break;
//                case "P":
//                    accion = "partida"
////                    mensaje = "Solicitud de reforma a nuevas partidas: "
//                    break;
//                case "I":
//                    accion = "incremento"
////                    mensaje = "Solicitud de reforma de incremento: "
//                    break;
//                default:
//                    accion = "existente"
////                    mensaje = "Solicitud de reforma a asignaciones existentes: "
//            }

            analistas.each { a ->
                def alerta = new Alerta()
                alerta.from = usu
                alerta.persona = a
                alerta.fechaEnvio = now
                alerta.mensaje = mensaje + reforma.concepto
                alerta.controlador = "reforma"
                alerta.accion = "pendientes"
                alerta.id_remoto = reforma.id
                if (!alerta.save(flush: true)) {
                    println "error alerta: " + alerta.errors
                }
            }

            render "ok"
        }
    }

    /**
     * Acción para firmar la aprobación de la reforma
     */
    def firmarAprobarReforma() {
//        println "FIRMAR APROBAR REFORMA"
//        println params

        def firma = Firma.findByKey(params.key)
        if (!firma) {
            response.sendError(403)
        } else {
            def reforma = Reforma.findByFirma1OrFirma2(firma, firma)
//            println "existe la firma de la reforma " + reforma.id
//            println "estado firma 1: ${reforma.firma1.estado}, estado firma 2: ${reforma.firma2.estado}"
            if (reforma.firma1.estado == "F" && reforma.firma2.estado == "F") {
//                println "Estan las 2 firmas, entra a hacer la modificacion"
                //busco el ultimo numero asignado para signar el siguiente
                def ultimoNum = Reforma.withCriteria {
                    eq("tipo", "R")
                    projections {
                        max "numeroReforma"
                    }
                }

                def num = 1
                if (ultimoNum && ultimoNum.size() == 1) {
                    num = ultimoNum.first() + 1
                }

                def estadoAprobado = EstadoAval.findByCodigo("E02")
                reforma.estado = estadoAprobado
                reforma.numeroReforma = num
                reforma.save(flush: true)
//                println "Modificada la reforma al estado " + estadoAprobado.descripcion + " (" + estadoAprobado.id + ")"
                def usu = Persona.get(session.usuario.id)
                def now = new Date()
                def errores = ""
                def detalles
//                if (reforma.tipoSolicitud == 'I') {
                detalles = DetalleReforma.findAllByReformaAndAsignacionOrigenIsNotNull(reforma)
//                } else {
//                    detalles = DetalleReforma.findAllByReforma(reforma)
//                }
                detalles.each { detalle ->
                    def origen = detalle.asignacionOrigen
                    def destino
                    //E: existente, A: actividad, P: partida, I: incremento
                    switch (reforma.tipoSolicitud) {
                        case "E":
                        case "I":
                            destino = detalle.asignacionDestino
                            break;
                        case "A":
                        case "C":
//                            println "Entro aqui: " + reforma.tipoSolicitud
                            //1ro verifico si existe una actividad con el mismo nombre (especialmente para el caso tipo C)
//                            def testActividad = MarcoLogico.findAllByTipoElementoAndObjeto(TipoElemento.get(3), detalle.descripcionNuevaActividad)

                            def testActividad = MarcoLogico.withCriteria {
                                eq("marcoLogico", detalle.componente)
                                eq("objeto", detalle.descripcionNuevaActividad)
                            }

                            if (testActividad.size() == 0) {
                                //no existe la actividad, la creo
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
                                    println "error al guardar la actividad (A) " + nuevaActividad.errors
                                    errores += renderErrors(bean: nuevaActividad)
                                } else {
//                                    println "Creo la actividad nueva: " + nuevaActividad.objeto + " con numero " + nuevaActividad.numero + " y id " + nuevaActividad.id
                                    destino = new Asignacion()
                                    destino.anio = reforma.anio
                                    destino.fuente = origen.fuente
                                    destino.marcoLogico = nuevaActividad
                                    destino.presupuesto = detalle.presupuesto
                                    destino.planificado = 0
                                    destino.unidad = nuevaActividad.responsable
                                    destino.priorizado = 0
                                    if (!destino.save(flush: true)) {
                                        println "error al guardar la asignacion (RA) " + destino.errors
                                        errores += renderErrors(bean: destino)
                                        destino = null
                                    }
//                                    println "Creo la asignacion nueva con id " + destino?.id
                                }
                            } else if (testActividad.size() == 1) {
                                //ya existe la activida, utilizo esa
                                testActividad = testActividad.first()
                                def testDestino = Asignacion.findAllByMarcoLogico(testActividad)
                                if (testDestino.size() == 1) {
                                    destino = testDestino.first()
                                } else {
                                    destino = null
                                    println "LA actividad " + testActividad.id + " (" + testActividad.objeto + ") tiene ${testDestino.size()} asignaciones y no se cual utilizar"
                                }
                            } else {
                                println "Existen ${testActividad.size()} actividades con objeto ${detalle.descripcionNuevaActividad} y no se cual utilizar"
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
                                println "error al guardar la asignacion (P) " + destino.errors
                                errores += renderErrors(bean: destino)
                                destino = null
                            }
                            break;
                    }
                    if (origen && destino) {
//                        println "Existen el origen (${origen.id}) y el destino(${destino.id})"
                        def modificacion = new ModificacionAsignacion()
                        modificacion.usuario = usu
                        modificacion.desde = origen
                        modificacion.recibe = destino
                        modificacion.fecha = now
                        modificacion.valor = detalle.valor
                        modificacion.estado = 'A'
                        modificacion.detalleReforma = detalle
                        modificacion.originalOrigen = origen.priorizado
                        modificacion.originalDestino = destino.priorizado
                        if (!modificacion.save(flush: true)) {
                            println "error save modificacion: " + modificacion.errors
                            errores += renderErrors(bean: modificacion)
                        } else {
//                            println "Crear la modificacion nueva con id " + modificacion.id
//                            println "origen.priorizado=" + origen.priorizado
//                            println "destino.priorizado=" + destino.priorizado
                            origen.priorizado -= detalle.valor
                            destino.priorizado += detalle.valor
//                            println "????"
                            if (!origen.save(flush: true)) {
//                                println "1"
                                println "error save origen: " + origen.errors
                                errores += renderErrors(bean: origen)
                            }
//                            println "1 *****"
                            if (!destino.save(flush: true)) {
//                                println "2"
                                println "error save destino: " + destino.errors
                                errores += renderErrors(bean: destino)
                            }
//                            println "2 *****"
//                            println "origen.priorizado=" + origen.priorizado
//                            println "destino.priorizado=" + destino.priorizado
                        }
                    }
                }
            }
            render "ok"
        }
    }


    def firmarAprobarNuevaReforma () {

        println("params aprobar " + params)
        def errores = ""

        def firma = Firma.findByKey(params.key)
        if (!firma) {
            response.sendError(403)
        } else {
            def reforma = Reforma.findByFirma1OrFirma2(firma, firma)

            if (reforma.firma1.estado == "F" && reforma.firma2.estado == "F") {
//                println "Estan las 2 firmas, entra a hacer la modificacion"
                //busco el ultimo numero asignado para signar el siguiente
                def ultimoNum = Reforma.withCriteria {
                    eq("tipo", "R")
                    projections {
                        max "numeroReforma"
                    }
                }

                def num = 1
                if (ultimoNum && ultimoNum.size() == 1) {
                    num = ultimoNum.first() + 1
                }

                def estadoAprobado = EstadoAval.findByCodigo("E02")
                reforma.estado = estadoAprobado
                reforma.numeroReforma = num
                reforma.save(flush: true)
                def usu = Persona.get(session.usuario.id)
                def now = new Date()

                def detalles

                detalles = DetalleReforma.findAllByReforma(reforma)

                println("detalles " + detalles)

                detalles.each { d->

                    switch (d?.tipoReforma?.codigo){
                        case "O":
                            //asignacion origen


                            println("entro origen")

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
                        case "E":
                            //incremento

                            println("entro incremento")

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
                        case "A":

                            //creacion actividad


                            println("entro actividad")

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
                            nuevaActividad.responsable = reforma.persona.unidad
                            nuevaActividad.numero = numAct
                            nuevaActividad.reforma = reforma


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
                        case "P":

                            //partida - priorizado original en 0, valor ingresado en priorizado, no tiene padre

                            println("entro partida")

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
                    }

                }
            }
            println("errores "  + errores)
            if(errores != ""){

            }else{
                render "ok"
            }

        }



    }

    /**
     * Acción para devolver la solicitud de reforma al analista de planificación
     */
    def devolverAprobarReforma() {
        def now = new Date()
        def usu = Persona.get(session.usuario.id)

        def reforma = Reforma.get(params.id)
        reforma.estado = EstadoAval.findByCodigo("D03") //devuelto al analista
        reforma.save(flush: true)

        def perfilAnalistaPlan = Prfl.findByCodigo("ASPL")
        def analistas = Sesn.findAllByPerfil(perfilAnalistaPlan).usuario
        def tipoStr = elm.tipoReformaStr(tipo: 'Reforma', tipoSolicitud: reforma.tipoSolicitud)
        def mensaje = "Devolución de solicitud de ${tipoStr}"

        reforma.firma1.estado = "N"
        reforma.firma2.estado = "N"
        reforma.firma1.save(flush: true)
        reforma.firma2.save(flush: true)
//        def accion, mensaje
//        //E: existente, A: actividad, P: partida, I: incremento
//        switch (reforma.tipoSolicitud) {
//            case "E":
//                accion = "existente"
//                mensaje = "Devolución de solicitud de reforma a asignaciones existentes: "
//                break;
//            case "A":
//                accion = "actividad"
//                mensaje = "Devolución de solicitud de reforma a nuevas actividades: "
//                break;
//            case "C":
//                accion = "incrementoActividad"
//                mensaje = "Devolución de solicitud de reforma de incremento a nuevas actividades: "
//                break;
//            case "P":
//                accion = "partida"
//                mensaje = "Devolución de solicitud de reforma a nuevas partidas: "
//                break;
//            case "I":
//                accion = "incremento"
//                mensaje = "Devolución de solicitud de reforma de incremento: "
//                break;
//            default:
//                accion = "existente"
//                mensaje = "Devolución de solicitud de reforma a asignaciones existentes: "
//        }

        analistas.each { a ->
            def alerta = new Alerta()
            alerta.from = usu
            alerta.persona = a
            alerta.fechaEnvio = now
            alerta.mensaje = mensaje + reforma.concepto
            alerta.controlador = "reforma"
            alerta.accion = "pendientes"
            alerta.id_remoto = reforma.id
            if (!alerta.save(flush: true)) {
                println "error alerta: " + alerta.errors
            }
        }
        render "OK"
    }

    def revisionSolicitud() {
        def reforma = Reforma.get(params.id)
        def estadosOK = ["R01", "D02"] //por revisar o devuelto dal dir req
        if (!reforma || !estadosOK.contains(reforma.estado.codigo)) {
            redirect(action: "lista")
        }

        def rep = new ReportesReformaController()
        def det = null

        switch (reforma.tipoSolicitud) {
            case "A":
                det = rep.generaDetallesSolicitudActividad(reforma).det
                break;
            case "C":
                det = rep.generaDetallesSolicitudIncrementoActividad(reforma).det2
                break;
            case "E":
                det = rep.generaDetallesSolicitudExistente(reforma).det
                break;
            case "I":
                det = rep.generaDetallesSolicitudIncremento(reforma).det2
                break;
            case "P":
                det = rep.generaDetallesSolicitudPartida(reforma).det
                break;

        }

        def gerentes = firmasService.listaGerentesUnidad(reforma.persona.unidad)

        def detallesX = DetalleReforma.findAllByReforma(reforma)

        return [reforma: reforma, det: det, gerentes: gerentes, detallesX: detallesX ]
    }

    def enviarAGerente_ajax() {
        println "enviarAGerente_ajax params: $params"
        def solicitud = Reforma.get(params.id)
        def tipoStr = elm.tipoReformaStr(tipo: 'Reforma', tipoSolicitud: solicitud.tipoSolicitud)
        def usu = Persona.get(session.usuario.id)
        if (params.auth.toString().trim().encodeAsMD5() == usu.autorizacion) {
            def estadoSolicitadoSinFirma = EstadoAval.findByCodigo("EF4")
            def personaFirma, firma = null
            if (solicitud.estado.codigo == 'D02') {
                firma = solicitud.firmaSolicitud
                personaFirma = firma.usuario
            } else {
                personaFirma = Persona.get(params.firma.toLong())
            }

            if (personaFirma) {
                def mail = personaFirma.mail
                solicitud.estado = estadoSolicitadoSinFirma

                if (!firma) {
                    def accion
                    switch (solicitud.tipoSolicitud) {
                        case "E":
                            accion = "existente"
                            break;
                        case "A":
                            accion = "actividad"
                            break;
                        case "C":
                            accion = "incrementoActividad"
                            break;
                        case "I":
                            accion = "incremento"
                            break;
                        case "P":
                            accion = "partida"
                            break;
                        case "T":
                            accion = "techo"
                            break;
                        case "X":
                            accion = "nuevaReforma"
                            break;

                    }
                    firma = new Firma()
                    firma.usuario = personaFirma

                    firma.controlador = "reforma"
                    firma.accion = "firmarReforma"
                    firma.idAccion = solicitud.id

                    firma.controladorNegar = "reforma"
                    firma.accionNegar = "devolverADirectorRequirente"
                    firma.idAccionNegar = solicitud.id

                    firma.controladorVer = "reportesReforma"
                    firma.accionVer = accion
                    firma.idAccionVer = solicitud.id

                    firma.tipoFirma = "RFRM"
//                    firma.documento = "SolicitudDeAval_" + solicitud.proceso.nombre
                    firma.concepto = "Solicitud de ${tipoStr}: " + solicitud.concepto
                    if (!firma.save(flush: true)) {
                        println "error al guardar firma: " + firma.errors
                    } else {
                        solicitud.firmaSolicitud = firma
                    }
                } else {
                    firma.estado = "S"
                    firma.concepto = "Solicitud de ${tipoStr}: " + solicitud.concepto
                    if (!firma.save(flush: true)) {
                        println "error al guardar firma: " + firma.errors
                    }
                }
                solicitud.save(flush: true)

                def alerta1 = new Alerta()
                alerta1.from = usu
                alerta1.persona = personaFirma
                alerta1.fechaEnvio = new Date()
                alerta1.mensaje = "Solicitud de ${tipoStr}: " + solicitud.concepto
                alerta1.controlador = "firma"
                alerta1.accion = "firmasPendientes"
                alerta1.parametros = "tab=RFRM"
                alerta1.tipo = 'slct'
                alerta1.id_remoto = solicitud.id
                println alerta1
                if (!alerta1.save(flush: true)) {
                    println "error alerta1: " + alerta1.errors
                }
                if (mail) {
                    mailService.sendMail {
                        to mail
                        subject "Solicitud de ${tipoStr} requiere aprobación "
                        body "La solicitud de ${tipoStr}: " + solicitud.concepto + " requiere su firma de aprobación"
                    }
                } else {
                    println "no tiene mail..."
                }
                render "SUCCESS*Firma solicitada exitosamente"
            } else {
                render("ERROR*No se encontró la persona a la cual desea enviar la solicitud")
            }
        } else {
            render("ERROR*Clave de autorización incorrecta")
        }
    }

    def devolverADirectorRequirente() {
        println "devolver a dir req: " + params
        def now = new Date()
        def usu = Persona.get(session.usuario.id)

        def reforma = Reforma.get(params.id)
        def tipoStr = elm.tipoReformaStr(tipo: 'Reforma', tipoSolicitud: reforma.tipoSolicitud)
        def estadoDevueltoDirReq = EstadoAval.findByCodigo("D02")
        reforma.estado = estadoDevueltoDirReq
        if (reforma.save(flush: true)) {
            def mensaje = "Devolución de solicitud de ${tipoStr}: "

            def alerta = new Alerta()
            alerta.from = usu
            alerta.persona = reforma.director
            alerta.fechaEnvio = now
            alerta.mensaje = mensaje + reforma.concepto
            alerta.controlador = "reforma"
            alerta.accion = "pendientes"
            alerta.id_remoto = reforma.id
            if (!alerta.save(flush: true)) {
                println "error alerta: " + alerta.errors
            }
            def mail = reforma.director.mail
            if (mail) {
                try {
                    mailService.sendMail {
                        to mail
                        subject "Devolución de aval"
                        body "Su solicitud de ${tipoStr}: " + reforma.concepto + " ha sido devuelta por " + usu
                    }
                } catch (e) {
                    println "error al mandar mail"
                    e.printStackTrace()
                }
            } else {
                println "no tiene mail..."
            }
            render "SUCCESS*Devolución exitosa"
        } else {
            render "ERROR*" + renderErrors(bean: reforma)
        }
    }

    def devolverARequirente_ajax() {
        def solicitud = Reforma.get(params.id)
        def usu = Persona.get(session.usuario.id)
        if (params.auth.toString().trim().encodeAsMD5() == usu.autorizacion) {
            def msg = "<strong>Devuelto por ${usu.nombre} ${usu.apellido}:</strong> " + params.obs.trim()
            def estadoDevueltoReq = EstadoAval.findByCodigo("D01")
            solicitud.estado = estadoDevueltoReq

            def tipoStr = elm.tipoReformaStr(tipo: 'Reforma', tipoSolicitud: solicitud.tipoSolicitud)

            if (solicitud.observacionesDirector && solicitud.observacionesDirector != "") {
                solicitud.observacionesDirector = msg + "; " + solicitud.observacionesDirector
            } else {
                solicitud.observacionesDirector = msg
            }
            if (solicitud.save(flush: true)) {

                def alerta1 = new Alerta()
                alerta1.from = usu
                alerta1.persona = solicitud.persona
                alerta1.fechaEnvio = new Date()
                alerta1.mensaje = "Devolución de solicitud de ${tipoStr}: " + solicitud.concepto
                alerta1.controlador = "reforma"
                alerta1.accion = "pendientes"
                alerta1.id_remoto = solicitud.id
                if (!alerta1.save(flush: true)) {
                    println "error alerta1: " + alerta1.errors
                }
                try {
                    def mail = solicitud.persona.mail
                    if (mail) {

                        mailService.sendMail {
                            to mail
                            subject "Solicitud de ${tipoStr} (${new Date().format('dd-MM-yyyy')}): " + solicitud.concepto
                            body "Tiene una Solicitud de ${tipoStr} pendiente que requiere su revisión"
                        }

                    } else {
                        println "El usuario ${solicitud.persona} no tiene email"
                    }
                } catch (e) {
                    println "eror email " + e.printStackTrace()
                }
                render "SUCCESS*Devolución exitosa"
            } else {
                render "ERROR*" + renderErrors(bean: solicitud)
            }
        } else {
            render("ERROR*Clave de autorización incorrecta")
        }
    }

    def nuevaReforma () {
        def cn = dbConnectionService.getConnection()
        def actual
        if (params.anio) {
            actual = Anio.get(params.anio)
        } else {
            actual = Anio.findByAnio(new Date().format("yyyy"))
        }

        def unidad = UnidadEjecutora.get(session.unidad.id)
        def proyectos = unidad.getProyectosUnidad(actual, session.perfil.codigo.toString())

        def anios__id = 0
        try {
            anios__id = cn.rows("select distinct asgn.anio__id, anioanio from asgn, mrlg, anio " +
                    "where mrlg.mrlg__id = asgn.mrlg__id and proy__id in (${proyectos.id.join(',')}) and " +
                    "anio.anio__id = asgn.anio__id and cast(anioanio as integer) >= ${actual.anio} " +
                    "order by anioanio".toString()).anio__id

        } catch (e) {
            println e
        }

        def anios = []
        if(anios__id) {
            anios = Anio.findAllByIdInList(anios__id)
        }

//        println "anios: $anios"

        def personasFirma = firmasService.listaDirectoresUnidad(unidad)
//        def personasFirma = firmasService.listaDirectoresUnidadCorr(unidad)


        def reforma
        def detalle
        if(params.id){
            reforma = Reforma.findByIdAndTipoAndTipoSolicitud(params.id, "R","X")
            detalle = DetalleReforma.findAllByReforma(reforma, [sort: 'tipoReforma.id', order: 'desc'])
        }

        return [personas: personasFirma, actual: actual, proyectos: proyectos, reforma: reforma, detalle: detalle,
                anios: anios]
    }


    def asignacionOrigen_ajax () {
        println("params a " + params)

        def actual = params.anio ? Anio.get(params.anio) : Anio.findByAnio(new Date().format("yyyy"))

        def  proyectos3 = UnidadEjecutora.get(session.unidad.id).getProyectosUnidad(actual, session.perfil.codigo.toString())
//        def  proyectos3 = Proyecto.findAllByAprobadoIlike('a')
        println "proyectos3: $proyectos3"

        def detalle = null

        if(params.id){
            detalle = DetalleReforma.get(params.id)
        }
        return [proyectos:  proyectos3, detalle: detalle]
    }

    def asignacionDestino_ajax () {
        def actual
        if (params.anio) {
            actual = Anio.get(params.anio)
        } else {
            actual = Anio.findByAnio(new Date().format("yyyy"))
        }

        def proyectos3 = UnidadEjecutora.get(session.unidad.id).getProyectosUnidad(actual, session.perfil.codigo.toString())

        return [proyectos:  proyectos3]
    }

    def incremento_ajax () {

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

    def partida_ajax () {
        def actual
        if (params.anio) {
            actual = Anio.get(params.anio)
        } else {
            actual = Anio.findByAnio(new Date().format("yyyy"))
        }

        def proyectos3 = UnidadEjecutora.get(session.unidad.id).getProyectosUnidad(actual, session.perfil.codigo.toString())


        def unidad = UnidadEjecutora.get(session.usuario.unidad.id)
        def gerencias = firmasService.requirentes(unidad)

        def detalle = null

        if(params.id){
            detalle = DetalleReforma.get(params.id)
        }

        return [proyectos:  proyectos3, gerencias: gerencias, detalle: detalle]

    }


    def actividad_ajax () {

        def actual
        if (params.anio) {
            actual = Anio.get(params.anio)
        } else {
            actual = Anio.findByAnio(new Date().format("yyyy"))
        }

        def proyectos3 = UnidadEjecutora.get(session.unidad.id).getProyectosUnidad(actual, session.perfil.codigo.toString())

        def unidad = UnidadEjecutora.get(session.usuario.unidad.id)
        def gerencias = firmasService.requirentes(unidad)

        def detalle = null

        if(params.id){
            detalle = DetalleReforma.get(params.id)
        }

        return [proyectos: proyectos3, gerencias: gerencias, detalle: detalle]
    }


    def guardarNuevaReforma () {


//        println("params nr " + params)

        def anio = Anio.get(params.anio)
        def estadoAval = EstadoAval.findByCodigo("P01")
        def usuario = Persona.get(session.usuario.id)

        def reforma

        if(!params.id){
            //crear!!!!!!!!!!
//            println("entro a")

            reforma = new Reforma()
            reforma.anio = anio
            reforma.concepto = params.texto
            reforma.estado = estadoAval
            reforma.persona = usuario
            reforma.tipo = 'R'
            reforma.tipoSolicitud = 'X'
            reforma.numero = 0
            reforma.numeroReforma = 0
            reforma.fecha = new Date()

            if(!reforma.save(flush: true)){
                println("error al guardar nueva reforma " + errors)
                render "no"
            }else{
                render "ok_${reforma.id}"
            }

        }else{
            //editar
//            println("entro b")

            reforma = Reforma.get(params.id)
            reforma.anio = anio
            reforma.concepto = params.texto
            reforma.estado = estadoAval
            reforma.persona = usuario
            reforma.tipo = 'R'
            reforma.tipoSolicitud = 'X'
            reforma.numero = 0
            reforma.numeroReforma = 0
            reforma.fecha = new Date()

            if(!reforma.save(flush: true)){
                println("error al actualizar nueva reforma " + errors)
                render "no"
            }else{
                render "ok_${reforma.id}"
            }
        }


    }


    def grabarDetalleA () {

        println("params A " + params)

        def reforma = Reforma.get(params.reforma)
        def tipoReforma = TipoReforma.findByCodigo(params.tipoReforma)
        def componente = MarcoLogico.get(params.componente)
        def asignacion = Asignacion.get(params.asignacion)
        def fuente = Fuente.get(asignacion?.fuente?.id)

        def detalleReforma

        if(!params.id){
            //crear

            detalleReforma = new DetalleReforma()
            detalleReforma.reforma = reforma
            detalleReforma.componente = componente
            detalleReforma.asignacionOrigen = asignacion
            detalleReforma.tipoReforma = tipoReforma
            detalleReforma.valor = params.monto.toDouble()
            detalleReforma.valorOrigenInicial = asignacion.priorizado
            detalleReforma.valorDestinoInicial = 0
            detalleReforma.fuente = fuente
            detalleReforma.responsable = asignacion.unidad
            detalleReforma.anio = asignacion.anio
            if(params.adicional){
                println("entro")
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
            detalleReforma.componente = componente
            detalleReforma.asignacionOrigen = asignacion
            detalleReforma.tipoReforma = tipoReforma
            detalleReforma.valor = params.monto.toDouble()
            detalleReforma.valorOrigenInicial = asignacion.priorizado
            detalleReforma.valorDestinoInicial = 0
            detalleReforma.fuente = fuente
            detalleReforma.responsable = asignacion.unidad
//            detalleReforma.anio = asignacion.anio

            if(!detalleReforma.save(flush: true)){
                println("error al guardar detalle de reforma A " + detalleReforma.errors);
                render "no"
            }else{
                render "ok"
            }
        }

    }

    def grabarDetalleB () {
//        println("params B " + params)

        def reforma = Reforma.get(params.reforma)
        def tipoReforma = TipoReforma.findByCodigo(params.tipoReforma)
        def componente = MarcoLogico.get(params.componente)
        def asignacion = Asignacion.get(params.asignacion)
        def fuente = Fuente.get(asignacion?.fuente?.id)

        def detalleReforma

        if(!params.id){
            //crear

            detalleReforma = new DetalleReforma()
            detalleReforma.reforma = reforma
            detalleReforma.componente = componente
            detalleReforma.asignacionOrigen = asignacion
            detalleReforma.tipoReforma = tipoReforma
            detalleReforma.valor = params.monto.toDouble()
            detalleReforma.valorOrigenInicial = 0
            detalleReforma.valorDestinoInicial = asignacion.priorizado
            detalleReforma.fuente = fuente
            detalleReforma.responsable = asignacion.unidad
            detalleReforma.anio = asignacion.anio

            if(!detalleReforma.save(flush: true)){
                println("error al guardar detalle de reforma B " + errors);
                render "no"
            }else{
                render "ok"
            }
        }else{
            //editar

            detalleReforma = DetalleReforma.get(params.id)
            detalleReforma.reforma = reforma
            detalleReforma.componente = componente
            detalleReforma.asignacionOrigen = asignacion
            detalleReforma.tipoReforma = tipoReforma
            detalleReforma.valor = params.monto.toDouble()
            detalleReforma.valorOrigenInicial = 0
            detalleReforma.valorDestinoInicial = asignacion.priorizado
            detalleReforma.fuente = fuente
            detalleReforma.responsable = asignacion.unidad
//            detalleReforma.anio = asignacion.anio

            if(!detalleReforma.save(flush: true)){
                println("error al guardar detalle de reforma B " + errors);
                render "no"
            }else{
                render "ok"
            }
        }
    }


    def grabarDetalleC () {

        println("params C " + params)
//
        def reforma = Reforma.get(params.reforma)
        def tipoReforma = TipoReforma.findByCodigo(params.tipoReforma)
        def componente = MarcoLogico.get(params.componente)
        def actividad = MarcoLogico.get(params.actividad)
//        def asignacion = Asignacion.get(params.asignacion)
        def fuente = Fuente.get(params.fuente)
        def partida = Presupuesto.get(params.partida)
        def anio

        if(params.anio){
            anio = Anio.get(params.anio)
        }

        def detalleReforma

        if(!params.id){
            //crear

            detalleReforma = new DetalleReforma()
            detalleReforma.reforma = reforma
            detalleReforma.componente = actividad
//            detalleReforma.asignacionOrigen = asignacion
            detalleReforma.tipoReforma = tipoReforma
            detalleReforma.valor = params.monto.toDouble()
            detalleReforma.valorOrigenInicial = 0
//            detalleReforma.valorDestinoInicial = asignacion.priorizado
            detalleReforma.valorDestinoInicial = 0
            detalleReforma.fuente = fuente
            detalleReforma.presupuesto = partida
//            detalleReforma.responsable = actividad.responsable
            detalleReforma.responsable = UnidadEjecutora.get(params.responsable)
            detalleReforma.anio = anio

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
            detalleReforma.componente = actividad
//            detalleReforma.asignacionOrigen = asignacion
            detalleReforma.tipoReforma = tipoReforma
            detalleReforma.valor = params.monto.toDouble()
            detalleReforma.valorOrigenInicial = 0
//            detalleReforma.valorDestinoInicial = asignacion.priorizado
            detalleReforma.valorDestinoInicial = 0
            detalleReforma.fuente = fuente
            detalleReforma.presupuesto = partida
//            detalleReforma.responsable = actividad.responsable
            detalleReforma.responsable = UnidadEjecutora.get(params.responsable)


            if(!detalleReforma.save(flush: true)){
                println("error al guardar detalle de reforma C  " + detalleReforma.errors);
                render "no"
            }else{
                render "ok"
            }
        }


    }

    def grabarDetalleD () {

//        println("params D " + params)
        def reforma = Reforma.get(params.reforma)
        def tipoReforma = TipoReforma.findByCodigo(params.tipoReforma)
        def componente = MarcoLogico.get(params.componente)
        def fuente = Fuente.get(params.fuente)
        def partida = Presupuesto.get(params.partida)
        def categoria = Categoria.get(params.categoria)
        def inicio = new Date().parse("dd-MM-yyyy", params.inicio)
        def fin = new Date().parse("dd-MM-yyyy", params.fin)
        def responsable = UnidadEjecutora.get(params.responsable)
        def detalleReforma
        def anio

        if(params.anio){
            anio = Anio.get(params.anio)
        }


        if(!params.id){
            //crear

            detalleReforma = new DetalleReforma()
            detalleReforma.reforma = reforma
            detalleReforma.componente = componente
            detalleReforma.tipoReforma = tipoReforma
            detalleReforma.valor = params.monto.toDouble()
            detalleReforma.valorOrigenInicial = 0
            detalleReforma.valorDestinoInicial = 0
            detalleReforma.fuente = fuente
            detalleReforma.presupuesto = partida
            detalleReforma.categoria = categoria
            detalleReforma.fechaInicioNuevaActividad = inicio
            detalleReforma.fechaFinNuevaActividad = fin
            detalleReforma.descripcionNuevaActividad = params.actividad
            detalleReforma.responsable = responsable
            detalleReforma.anio = anio

            if(!detalleReforma.save(flush: true)){
                println("error al guardar detalle de reforma D  " + errors);
                render "no"
            }else{
                render "ok"
            }


        }else{
            //editar


            detalleReforma = DetalleReforma.get(params.id)
            detalleReforma.reforma = reforma
            detalleReforma.componente = componente
            detalleReforma.tipoReforma = tipoReforma
            detalleReforma.valor = params.monto.toDouble()
            detalleReforma.valorOrigenInicial = 0
            detalleReforma.valorDestinoInicial = 0
            detalleReforma.fuente = fuente
            detalleReforma.presupuesto = partida
            detalleReforma.categoria = categoria
            detalleReforma.fechaInicioNuevaActividad = inicio
            detalleReforma.fechaFinNuevaActividad = fin
            detalleReforma.descripcionNuevaActividad = params.actividad
            detalleReforma.responsable = responsable

            if(!detalleReforma.save(flush: true)){
                println("error al guardar detalle de reforma D  " + errors);
                render "no"
            }else{
                render "ok"
            }
        }
    }


    def borrarDetalle () {

        println("params borrar " + params)

        def detalleBorra = DetalleReforma.get(params.detalle)

        if(!detalleBorra.delete(flush: true)){

            render "ok"
        }else{
            println("error al borrar detalle de reforma " + errors);
            render "no"
        }
    }

    /* se guardan en reformas con "tipoSolicitud = Q" (rfrmtprf)*/
    def guardarReformaCorriente () {
        println "guardarReformaCorriente params: $params"
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
            reforma.tipo = 'R'
            reforma.tipoSolicitud = 'Q'
            reforma.numero = 0
            reforma.numeroReforma = 0
            reforma.fecha = new Date()

            if(!reforma.save(flush: true)){
                println("error al guardar nueva reforma permanente " + errors)
                render "no"
            }else{
                render "ok_${reforma.id}"
            }

        } else {
            reforma = Reforma.get(params.id)
            reforma.anio = anio
            reforma.concepto = params.texto
            reforma.estado = estadoAval
            reforma.persona = usuario
            reforma.tipo = 'R'
            reforma.tipoSolicitud = 'Q'
            reforma.numero = 0
            reforma.numeroReforma = 0
            reforma.fecha = new Date()

            if(!reforma.save(flush: true)){
                println("error al actualizar nueva reforma permanente " + errors)
                render "no"
            }else{
                render "ok_${reforma.id}"
            }
        }


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

}
