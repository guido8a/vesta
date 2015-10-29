package vesta.avales

import vesta.modificaciones.DetalleReforma
import vesta.parametros.Auxiliar
import vesta.parametros.poaPac.Anio
import vesta.poa.Asignacion
import vesta.proyectos.MarcoLogico
import vesta.proyectos.Proyecto
import vesta.parametros.UnidadEjecutora
import vesta.alertas.Alerta
import vesta.seguridad.Firma
import vesta.seguridad.Prfl
import vesta.seguridad.Sesn
import vesta.seguridad.Persona

/**
 * Controlador que muestra las pantallas de manejo de avales
 */
class AvalesController extends vesta.seguridad.Shield {

    def mailService
    def firmasService
    def proyectosService

    /**
     * Acción que muestra la pantalla de lista de procesos por proyecto
     * @param proyecto el id del proyecto. Si no existe el proyecto muestra la lista de todos los procesos
     */
    def procesos = {
//        println "procesos " + params
        def proyecto = null
        if (params.proyecto) {
            proyecto = Proyecto.get(params.proyecto)
        }
        def procesos = []
        if (proyecto) {
            procesos = ProcesoAval.findAllByProyecto(proyecto)
        } else {
            procesos = ProcesoAval.list([sort: "nombre"])
        }
        [proyecto: proyecto, procesos: procesos]
    }

    /**
     * Acción que muestra la pantalla que permite crear un nuevo proceso o modificar uno existente
     * @param id el id del proceso en caso de que se quiera modificar uno existente
     * @param anio el id del año. Si no existe el año tomará el actual
     */
    def crearProceso_ajax = {
        println "PARAMS: " + params
        def proceso
        def actual
        def band = true
        def proyectos = []
        def unidad = session.usuario.unidad
        println "unidad" + unidad
        Asignacion.findAllByUnidad(unidad).each {
            def p = it.marcoLogico.proyecto
            if (!proyectos.contains(p)) {
                proyectos.add(p)
            }
        }
        println "proyectos" + proyectos
        proyectos.sort { it.nombre }
        if (params.anio) {
            actual = Anio.get(params.anio)
        } else {
            actual = Anio.findByAnio(new Date().format("yyyy"))
        }
        if (params.id) {
            proceso = ProcesoAval.get(params.id)
            def aval = Aval.findAllByProceso(proceso)

            aval.each {
                //println "aval "+it.estado.descripcion+"  "+it.estado.codigo
                if (it.estado?.codigo == "E01" || it.estado?.codigo == "E02" || it.estado.codigo == "E05" || it.estado.codigo == "E06" || it.estado.codigo == "EF1" || it.estado.codigo == "EF4") {
                    band = false
                }
            }
        }


        println("pro " + proyectos)
        [proyectos: proyectos, proceso: proceso, actual: actual, band: band, unidad: unidad]
    }

    /**
     * Acción llamada con ajax que muestra la pantalla que permite crear modificar una asignacion
     */
    def editarAsignacion_ajax() {
        def band = params.band
        def asg = ProcesoAsignacion.get(params.id)
        [band: band, asg: asg, max: params.max]

    }

    /**
     * Acción llamada con ajax que muestra las asignaciones de un proceso
     * @param id el id del proceso
     */
    def getDetalle_ajax = {
        def proceso
        def detalle = []
        proceso = ProcesoAval.get(params.id)
        detalle = ProcesoAsignacion.findAllByProceso(proceso, [sort: "id"])
        def aval = Aval.findAllByProceso(proceso)
        def band = true
        aval.each {
            //println "aval "+it.estado.descripcion+"  "+it.estado.codigo
            if (it.estado?.codigo == "E01" || it.estado?.codigo == "E02" || it.estado.codigo == "E05" || it.estado.codigo == "E06") {
                band = false
            }
        }

        def readOnly = params.readOnly == "true"

        [proceso: proceso, detalle: detalle, band: band, readOnly: readOnly]
    }

    /**
     * Acción que guarda el proceso
     */
    def saveProceso = {
        println "save proceso " + params

        def proceso
        if (params.id) {
            proceso = ProcesoAval.get(params.id)
        } else {
            proceso = new ProcesoAval()
        }
        proceso.properties = params
        if (!proceso.save(flush: true)) {
            render "ERROR*Ha ocurrido un error al guardar el proceso: " + renderErrors(bean: proceso)
            return
        } else {
            def texto
            if (params.id) {
                texto = "Actualización de proceso exitosa"
            } else {
                texto = "Creación de proceso exitosa"
            }
            render "SUCCESS*" + texto
            return
        }
    }

    /**
     * Acción llamada con ajax que permite agregar una asignación (ProcesoAsignacion) a un proceso
     * @param proceso el id del ProcesoAval
     * @param monto el monto de la asignación
     * @param id el id del ProcesoAsignacion en caso de que sea edición
     * @Renders "ok"
     */
    def agregarAsignacion = {
        println "agregar asg " + params
        def proceso = ProcesoAval.get(params.proceso)
        def asg = Asignacion.get(params.asg)
        def monto = params.monto.toDouble()
        def devengado = params.devengado.toDouble()

//        println "monto: " + monto + "    devengado: " + devengado

        def detalle = new ProcesoAsignacion()
        if (params.id && params.id != "") {
            detalle = ProcesoAsignacion.get(params.id)
        }
        detalle.asignacion = asg
        detalle.proceso = proceso
        detalle.monto = monto
        detalle.devengado = devengado
        detalle.save(flush: true)
        render "ok"
    }

    /**
     * Acción llamada con ajax que permite eliminar una asignación (ProcesoAsignacion) de un proceso
     * @param id el id del ProcesoAsignacion a ser eliminado
     * @Renders "ok" si la eliminación se efectuó, false sino. No se permite eliminar si el proceso tiene un aval o una solicitud pendiente
     */
    def borrarDetalle = {
        println "borrar " + params
        def detalle = ProcesoAsignacion.get(params.id)
        def aval = Aval.findAllByProceso(detalle.proceso)
        def band = true
        aval.each {
            if (it.estado?.codigo == "E01" || it.estado?.codigo == "E02") {
                band = false
            }
        }
        if (band) {
            detalle.delete()
            render "ok"
        } else {
            render "no"
        }
    }

    /**
     * Acción llamada con ajax que permite modificar una asignación (ProcesoAsignacion) de un proceso
     * @param id el id del ProcesoAsignacion a ser modificado
     * @param monto el monto nuevo
     * @Renders "ok"
     */
    def editarDetalle = {
        println "edtar " + params

        def detalle = ProcesoAsignacion.get(params.id)
        detalle.monto = params.monto.toDouble()
        detalle.save(flush: true)
        render "ok"
    }

    /**
     * Acción llamada con ajax que carga los componentes (MarcoLogico) de un cierto proyecto, año y unidad
     * @param id el proyecto padre de los componentes
     */
    def cargarComponentes_ajax = {
        def proyecto = Proyecto.get(params.id)
        def anio = Anio.get(params.anio)
//        def comps = proyectosService.getComponentesUnidadProyecto(UnidadEjecutora.get(session.unidad.id), anio, proyecto, session.perfil.codigo.toString())
        def comps = UnidadEjecutora.get(session.unidad.id).getComponentesUnidadProyecto(anio, proyecto, session.perfil.codigo.toString())
        return [comps: comps]
    }

    /**
     * Acción llamada con ajax que carga las actividades (MarcoLogico) de un cierto componente y una cierta unidad
     * @param id el componente padre de las actividades
     * @param unidad el id de la unidad
     */
    def cargarActividades_ajax = {
        def comp = MarcoLogico.get(params.id)
        def unidad = UnidadEjecutora.get(params.unidad)
        def anio = Anio.get(params.anio)
//        def acts = proyectosService.getActividadesUnidadComponente(UnidadEjecutora.get(session.unidad.id), anio, comp, session.perfil.codigo.toString())
        def acts = UnidadEjecutora.get(session.unidad.id).getActividadesUnidadComponente(anio, comp, session.perfil.codigo.toString())
        return [acts: acts]
    }

    /**
     * Acción llamada con ajax que carga las actividades (MarcoLogico) de un cierto componente y una cierta unidad
     * @param id el componente padre de las actividades
     * @param unidad el id de la unidad
     */
    def cargarActividades2_ajax = {
        def comp = MarcoLogico.get(params.id)
        def anio = Anio.get(params.anio)
//        def acts = proyectosService.getActividadesUnidadComponente(UnidadEjecutora.get(session.unidad.id), anio, comp, session.perfil.codigo.toString())
        def acts = UnidadEjecutora.get(session.unidad.id).getActividadesUnidadComponente(anio, comp, session.perfil.codigo.toString())
        return [acts: acts]
    }

    /**
     * Acción llamada con ajax que carga las actividades (MarcoLogico) de un cierto componente
     * @param id el componente padre de las actividades
     */
    def cargarActividadesAjuste_ajax = {
        def comp = MarcoLogico.get(params.id)
//        def acts = []
//        if (params.id != "-1") {
//            acts = MarcoLogico.findAllByMarcoLogico(comp, [sort: "numero"])
//        }
//        def acts = proyectosService.getActividadesUnidadComponente(session.asignaciones, comp)
        def anio = Anio.get(params.anio)
//        def acts = proyectosService.getActividadesUnidadComponente(UnidadEjecutora.get(session.unidad.id), anio, comp, session.perfil.codigo.toString())
        def acts = UnidadEjecutora.get(session.unidad.id).getActividadesUnidadComponente(anio, comp, session.perfil.codigo.toString())
        return [acts: acts, div: params.div]
    }

    /**
     * Acción llamada con ajax que carga las actividades (MarcoLogico) de un cierto componente
     * @param id el componente padre de las actividades
     */
    def cargarActividadesAjuste2_ajax = {
        def comp = MarcoLogico.get(params.id)
//        def acts = []
//        if (params.id != "-1") {
//            acts = MarcoLogico.findAllByMarcoLogico(comp, [sort: "numero"])
//        }
//        def acts = proyectosService.getActividadesUnidadComponente(session.asignaciones, comp)
        def anio = Anio.get(params.anio)
//        def acts = proyectosService.getActividadesUnidadComponente(UnidadEjecutora.get(session.unidad.id), anio, comp, session.perfil.codigo.toString())
        def acts = UnidadEjecutora.get(session.unidad.id).getActividadesUnidadComponente(anio, comp, session.perfil.codigo.toString())
        return [acts: acts, div: params.div]
    }

    /**
     * Acción llamada con ajax que carga las asignaciones de una cierta actividad (MarcoLogico) de un cierto año
     * @param id el id de la actividad
     * @param anio el id del año
     */
    def cargarAsignaciones_ajax = {
//        println "cargar asg " + params
        def act = MarcoLogico.get(params.id)
        def anio = Anio.get(params.anio)
//        println "asgs "+ Asignacion.findAllByMarcoLogicoAndAnio(act, anio)
//        def asg = Asignacion.findAllByMarcoLogicoAndAnio(act, anio)
//        def asg = proyectosService.getAsignacionesUnidadActividad(session.asignaciones, act)
//        def asg = proyectosService.getAsignacionesUnidadActividad(UnidadEjecutora.get(session.unidad.id), anio, act, session.perfil.codigo.toString())
        def asg = UnidadEjecutora.get(session.unidad.id).getAsignacionesUnidadActividad(anio, act, session.perfil.codigo.toString())
        [asgs: asg]
    }

    /**
     * Acción llamada con ajax que carga las asignaciones de una cierta actividad (MarcoLogico) de un cierto año
     * @param id el id de la actividad
     * @param anio el id del año
     */
    def cargarAsignaciones3_ajax = {
//        println "cargar asg " + params
        def act = MarcoLogico.get(params.id)
        def anio = Anio.get(params.anio)
//        println "asgs "+ Asignacion.findAllByMarcoLogicoAndAnio(act, anio)
//        def asg = Asignacion.findAllByMarcoLogicoAndAnio(act, anio)
//        def asg = proyectosService.getAsignacionesUnidadActividad(session.asignaciones, act)
//        def asg = proyectosService.getAsignacionesUnidadActividad(UnidadEjecutora.get(session.unidad.id), anio, act, session.perfil.codigo.toString())
        def asg = UnidadEjecutora.get(session.unidad.id).getAsignacionesUnidadActividad(anio, act, session.perfil.codigo.toString())
        [asgs: asg]
    }

    /**
     * Acción llamada con ajax que carga las asignaciones de una cierta actividad (MarcoLogico) de un cierto año
     * @param id el id de la actividad
     * @param anio el id del año
     */
    def cargarAsignaciones2_ajax = {
//        println "cargar asg " + params
        def act = MarcoLogico.get(params.id)
        def anio = Anio.get(params.anio)
//        println "asgs "+ Asignacion.findAllByMarcoLogicoAndAnio(act, anio)
//        def asg = proyectosService.getAsignacionesUnidadActividad(UnidadEjecutora.get(session.unidad.id), anio, act, session.perfil.codigo.toString())
        def asg = UnidadEjecutora.get(session.unidad.id).getAsignacionesUnidadActividad(anio, act, session.perfil.codigo.toString())
        [asgs: asg]
    }

    /**
     * Acción llamada con ajax que calcula el monto máximo que se le puede dar a una asignación
     * @param id el id de la asignación
     * @Renders el monto priorizado menos el monto utilizado
     */
    def getMaximoAsg = {
        println "get Maximo asg " + params
        def asg = Asignacion.get(params.id)
        def monto = asg.priorizado
        def usado = 0;
        def estadoPendiente = EstadoAval.findByCodigo("P01")
        def estadoPorRevisar = EstadoAval.findByCodigo("R01")
        def estadoSolicitado = EstadoAval.findByCodigo("E01")
        def estadoSolicitadoSinFirma = EstadoAval.findByCodigo("EF4")
        def estadoAprobadoSinFirma = EstadoAval.findByCodigo("EF1")
        def estados = [estadoPendiente, estadoPorRevisar, estadoSolicitado, estadoSolicitadoSinFirma, estadoAprobadoSinFirma]
        ProcesoAsignacion.findAllByAsignacion(asg).each {
            usado += it.monto
        }
        def locked = 0
        def detalles = DetalleReforma.withCriteria {
            reforma {
                inList("estado", estados)
            }
            eq("asignacionOrigen", asg)
        }
        if (detalles.size() > 0) {
            locked = detalles.sum { it.valor }
        }
        def disponible = monto - usado - locked
        println "get Maximo asg " + params + " :  monto: " + monto + "   usado: " + usado + "    locked: " + locked + "     disponible: " + disponible
        render "" + (disponible)
    }

    /**
     * Acción que muestra una pantalla con la lista de procesos
     */
    def listaProcesos = {
        def procesos = ProcesoAval.list([sort: "id"])

        def perfil = session.perfil.codigo.toString()
//        def perfiles = ["GAF", "ASPL"]
//        def unidades
//        if (perfiles.contains(perfil)) {
//            unidades = UnidadEjecutora.list()
//        } else {
//            unidades = proyectosService.getUnidadesUnidad(UnidadEjecutora.get(session.unidad.id))
//        }
//        def unidades = proyectosService.getUnidadesUnidad(UnidadEjecutora.get(session.unidad.id), perfil)
        def unidades = UnidadEjecutora.get(session.unidad.id).getUnidadesPorPerfil(perfil)
        def l = []
        procesos.each { p ->
            if (SolicitudAval.countByProcesoAndUnidadInList(p, unidades) > 0) {
                l += p
            }
        }
        def estadoDevuelto = EstadoAval.findByCodigo("D01")
        def estadoSolicitadoSinFirma = EstadoAval.findByCodigo("EF4")
        def estadoPendiente = EstadoAval.findByCodigo("P01")
        def estadoPorRevisar = EstadoAval.findByCodigo("R01")
        def estados = [estadoDevuelto, estadoSolicitadoSinFirma, estadoPendiente, estadoPorRevisar]
        return [procesos: l, estados: estados]
    }

    def procesos() {
        params.aval = 'no'
        redirect(action: listaProcesos, params: params)
    }

    /**
     * Acción que muestra la pantalla de creación de solicitud de aval
     */
    def nuevaSolicitud() {
        def proceso = null
        def solicitud = null
        def actual
        def band = true
        def proyectos = []
        def readOnly = false
        def unidad = session.usuario.unidad
//        Asignacion.findAllByUnidad(unidad).each {
//            def p = it.marcoLogico.proyecto
//            if (!proyectos.contains(p)) {
//                proyectos.add(p)
//            }
//        }
//        proyectos.sort { it.nombre }
        if (params.anio) {
            actual = Anio.get(params.anio)
        } else {
            actual = Anio.findByAnio(new Date().format("yyyy"))
        }
        if (params.id) {
            proceso = ProcesoAval.get(params.id)
            def aval = Aval.findAllByProceso(proceso)

            aval.each {
                //println "aval "+it.estado.descripcion+"  "+it.estado.codigo
                if (it.estado?.codigo == "E01" || it.estado?.codigo == "E02" || it.estado.codigo == "E05" || it.estado.codigo == "E06" || it.estado.codigo == "EF1" || it.estado.codigo == "EF4") {
                    band = false
                }
            }

            def r = verificarProceso(proceso)
            flash.message = r.message
            if (flash.message != "") {
                readOnly = true
            }
            def estadoDevuelto = EstadoAval.findByCodigo("D01")
            def estadoSolicitadoSinFirma = EstadoAval.findByCodigo("EF4")
            def estadoPendiente = EstadoAval.findByCodigo("P01")
            def estados = [estadoDevuelto, estadoSolicitadoSinFirma, estadoPendiente]
            def solicitudes = SolicitudAval.findAllByProcesoAndEstadoInList(proceso, estados)
            if (solicitudes.size() == 1) {
                solicitud = solicitudes.first()
            }
        }

//        proyectos = proyectosService.getProyectosUnidad(UnidadEjecutora.get(session.unidad.id), actual, session.perfil.codigo.toString())
        proyectos = UnidadEjecutora.get(session.unidad.id).getProyectosUnidad(actual, session.perfil.codigo.toString())

        return [proyectos: proyectos, proceso: proceso, actual: actual, band: band, unidad: unidad, readOnly: readOnly, solicitud: solicitud]
    }

    /**
     * Acción que guarda el proceso y redirecciona a la acción solicitudAsignaciones una vez completado.
     */
    def saveProcesoWizard = {
        println "save proceso " + params

        def usuario = Persona.get(session.usuario.id)

        def proceso
        if (params.id) {
            proceso = ProcesoAval.get(params.id)
        } else {
            proceso = new ProcesoAval()
        }

        println("personsa " + usuario)
        proceso.properties = params
        proceso.usuario = usuario
        println("persona desp " + proceso.usuario)
        if (!proceso.save(flush: true)) {
            flash.message = "Ha ocurrido un error al guardar el proceso: " + renderErrors(bean: proceso)
            flash.tipo = "error"
            redirect(action: 'nuevaSolicitud')
            return
        } else {
            def texto
            if (params.id) {
                texto = "Actualización"
            } else {
                texto = "Creación"
            }
            texto += "  de proceso exitosa. Por favor ingrese las asignaciones"
            flash.message = texto
            flash.tipo = "success"
            redirect(action: 'solicitudAsignaciones', id: proceso.id)
            return
        }
    }

    /**
     * Acción que muestra la pantalla de selección de asignaciones para el proceso de creación de solicitud de aval
     */
    def solicitudAsignaciones() {
        if (params.id) {
            def proceso = ProcesoAval.get(params.id)
            def unidad = session.usuario.unidad

            def band = true
            def aval = Aval.findAllByProceso(proceso)

            aval.each {
                //println "aval "+it.estado.descripcion+"  "+it.estado.codigo
                if (it.estado?.codigo == "E01" || it.estado?.codigo == "E02" || it.estado.codigo == "E05" || it.estado.codigo == "E06" || it.estado.codigo == "EF1" || it.estado.codigo == "EF4") {
                    band = false
                }
            }

            def readOnly = false
            def r = verificarProceso(proceso)
            flash.message = r.message
            if (flash.message != "") {
                readOnly = true
            }

            def actual
            if (params.anio) {
                actual = Anio.get(params.anio)
            } else {
                actual = Anio.findByAnio(new Date().format("yyyy"))
            }
            def solicitud = null
            def estadoDevuelto = EstadoAval.findByCodigo("D01")
            def estadoSolicitadoSinFirma = EstadoAval.findByCodigo("EF4")
            def estadoPendiente = EstadoAval.findByCodigo("P01")
            def estados = [estadoDevuelto, estadoSolicitadoSinFirma, estadoPendiente]
            def solicitudes = SolicitudAval.findAllByProcesoAndEstadoInList(proceso, estados)
            if (solicitudes.size() == 1) {
                solicitud = solicitudes.first()
            }

            def maxAnio = proceso.fechaFin.format("yyyy")
            def actualAnio = actual.anio
            def anios = Anio.withCriteria {
                ge("anio", actualAnio)
                le("anio", maxAnio)
                order("anio", "asc")
            }

//            def componentes = proyectosService.getComponentesUnidadProyecto(UnidadEjecutora.get(session.unidad.id), actual, proceso.proyecto, session.perfil.codigo.toString())
            def componentes = UnidadEjecutora.get(session.unidad.id).getComponentesUnidadProyecto(actual, proceso.proyecto, session.perfil.codigo.toString())

            return [proceso: proceso, unidad: unidad, band: band, readOnly: readOnly, actual: actual, componentes: componentes, solicitud: solicitud, anios: anios]
        } else {
            redirect(action: "nuevaSolicitud")
        }
    }

    /**
     * Acción que mustra la pantalla de creación de la solicitud de aval
     */
    def solicitudProceso() {
        def readOnly = false
        if (params.id) {
            def proceso = ProcesoAval.get(params.id)

            def unidad = UnidadEjecutora.get(session.unidad.id)
//            def personasFirma = Persona.findAllByUnidad(unidad)
            def personasFirma = firmasService.listaDirectoresUnidad(unidad)
//            println "Personas Firma: " + personasFirma
            def aux = Auxiliar.list()
            def referencial = 7000
            if (aux.size() > 0) {
                aux = aux.pop()
                referencial = aux.presupuesto * (2 * Math.pow(10, -7))
                referencial = referencial.round(2)
                println "referencial " + referencial
            }

            def estadoDevuelto = EstadoAval.findByCodigo("D01")
            def estadoSolicitadoSinFirma = EstadoAval.findByCodigo("EF4")
            def estadoPendiente = EstadoAval.findByCodigo("P01")

            def estadoPorRevisar = EstadoAval.findByCodigo("R01")
            def estadoSolicitado = EstadoAval.findByCodigo("E01")
//        def estadoDevueltoReq = EstadoAval.findByCodigo("D01")
            def estadoDevueltoDirReq = EstadoAval.findByCodigo("D02")

            def estados = [estadoDevuelto, estadoSolicitadoSinFirma, estadoPendiente, estadoPorRevisar, estadoSolicitado, estadoDevueltoDirReq]
            def solicitudes = SolicitudAval.findAllByProcesoAndEstadoInList(proceso, estados)
            def solicitud = null
            if (solicitudes.size() == 1) {
                solicitud = solicitudes.first()
            }

//            def numero
//            numero = SolicitudAval.findAllByUnidad(session.usuario.unidad, [sort: "numero", order: "desc", max: 1])
//            if (numero.size() > 0) {
//                numero = numero?.pop()?.numero
//            }
//            if (!numero) {
//                numero = 1
//            } else {
//                numero = numero + 1
//            }
//            numero = 0
            def r = verificarProceso(proceso, solicitud)
            flash.message = r.message
            if (flash.message != "") {
                readOnly = true
            }
            def disponible = r.disponible

//            def solicitudes = SolicitudAval.findAllByProcesoAndEstadoInList(proceso, [EstadoAval.findByCodigo("E01"), EstadoAval.findByCodigo("EF4")])

//            println "Aqui:   " + proceso + "    " + solicitud

            return [proceso  : proceso, disponible: disponible, personas: personasFirma, numero: 0,
                    refencial: referencial, readOnly: readOnly, solicitud: solicitud, params: params]
        } else {
            redirect(action: "nuevaSolicitud")
            return
        }
    }

    private verificarProceso(ProcesoAval proceso) {
        return verificarProceso(proceso, null)
    }

    private verificarProceso(ProcesoAval proceso, SolicitudAval solicitudAval) {
//        def band = true
        def message = ""
        def now = new Date()
/*
        if (proceso.fechaInicio < now) {    // ya se inició el proceso ... no se puede editar ni solicitar aval
            message = "El proceso ${proceso.nombre}  (${proceso.fechaInicio.format('dd-MM-yyyy')} - " +
                    "${proceso.fechaFin.format('dd-MM-yyyy')}) esta en ejecución, si desea solicitar un aval " +
                    "modifique las fechas de inicio y fin"
        }
*/
        def estadoAprobadoSinFirma = EstadoAval.findByCodigo("EF1")
        def estadoAprobado = EstadoAval.findByCodigo("E02")
        def estadoAnulado = EstadoAval.findByCodigo("E05")

//        def estadoPendiente = EstadoAval.findByCodigo("P01")
        def estadoPorRevisar = EstadoAval.findByCodigo("R01")
        def estadoSolicitadoSinFirma = EstadoAval.findByCodigo("EF4")
        def estadoSolicitado = EstadoAval.findByCodigo("E01")
//        def estadoDevueltoReq = EstadoAval.findByCodigo("D01")
        def estadoDevueltoDirReq = EstadoAval.findByCodigo("D02")

        def estadosEdit = ["D01", "EF4", "P01"]

        def avales = Aval.findAllByProcesoAndEstadoInList(proceso, [estadoAprobado, estadoAnulado, estadoAprobadoSinFirma])

        def solicitudes
        if (solicitudAval) {
            solicitudes = SolicitudAval.withCriteria {
                ne("id", solicitudAval.id)
                eq("proceso", proceso)
                inList("estado", [estadoPorRevisar, estadoSolicitadoSinFirma, estadoSolicitado, estadoDevueltoDirReq])
            }
        } else {
            solicitudes = SolicitudAval.findAllByProcesoAndEstadoInList(proceso, [estadoPorRevisar, estadoSolicitadoSinFirma, estadoSolicitado, estadoDevueltoDirReq])
        }

        def disponible = proceso.getMonto()

//        println "........ disponible: $disponible, estados edit: $estadosEdit, solicitud: $solicitudAval"
        if (avales.size() > 0) {
            disponible -= (avales.sum { it.monto })
            message = "Este proceso tiene un aval vigente"
        }
        if (solicitudAval) {
            if (!estadosEdit.contains(solicitudAval?.estado?.codigo)) {
                if (message == "") {
                    message = "Este proceso tiene "
                } else {
                    message += " y "
                }
                message += "${solicitudes.size() == 1 ? 'una' : solicitudes.size()} solicitud ${solicitudes.size() == 1 ? '' : 'es'} <strong>${solicitudes.estado.descripcion.join(', ')}</strong>"
            }
        }
        if (solicitudes.size() > 0) {
            disponible -= (solicitudes.sum { it.monto })
            if (message == "") {
                message = "Este proceso tiene "
            } else {
                message += " y "
            }
            message += "${solicitudes.size() == 1 ? 'una' : solicitudes.size()} solicitud${solicitudes.size() == 1 ? '' : 'es'} <strong>${solicitudes.estado.descripcion.join(', ')}</strong>"
        }
        if (message != "") {
            message += ", no puede solicitar otro."
        }

//        avales.each {
////            band = false
//            disponible -= it.monto
//        }
//        solicitudes.each {
////            band = false
//            disponible -= it.monto
//        }
//        if (!band) {
//            message = "Este proceso ya tiene un aval vigente o tiene una solicitud pendiente, no puede solicitar otro."
//        }
        return [message: message, disponible: disponible]
    }

    /**
     * Acción que muestra una pantalla con la lista de procesos por unidad
     */
    def listaProcesosUnidad = {
        def user = Persona.get(session.usuario.id)
        def proyectos = []
        def unidad = user.unidad
        Asignacion.findAllByUnidad(unidad).each {
            def p = it.marcoLogico.proyecto
            if (!proyectos.contains(p)) {
                proyectos.add(p)
            }
        }
        proyectos.sort { it.nombre }
        def procesos = ProcesoAval.findAllByProyectoInList(proyectos, [sort: "id"])
        [procesos: procesos]
    }

    /**
     * Acción que muestra una pantalla con la lista de avales de un proceso
     * @param id el id del proceso
     */
    def avalesProceso = {
        def proceso = ProcesoAval.get(params.id)
        def avales = Aval.findAllByProceso(proceso)
        def solicitudes = SolicitudAval.findAllByProceso(proceso, [sort: "fecha"])
        [avales: avales, proceso: proceso, solicitudes: solicitudes]
    }

    /**
     * Acción que muestra una pantalla que permite crear una solicitud de aval<br/>
     * Si el proceso ya tiene un aval vigente o tiene una solicitud pendiente, no puede solicitar otro y redirecciona a la acción avalesProceso
     * @param id el id del proceso
     */
    def solicitarAval = {
        //println "solicictar aval"
        def unidad = UnidadEjecutora.get(session.unidad.id)
        def personasFirma = Persona.findAllByUnidad(unidad)
        def aux = Auxiliar.list()
        def referencial = 7000
        if (aux.size() > 0) {
            aux = aux.pop()
            referencial = aux.presupuesto * (2 * Math.pow(10, -7))
            referencial = referencial.round(2)
            println "referencial " + referencial
        }
        def numero = null
        def band = true
        numero = SolicitudAval.findAllByUnidad(session.usuario.unidad, [sort: "numero", order: "desc", max: 1])
        if (numero.size() > 0) {
            numero = numero?.pop()?.numero
        }
        if (!numero) {
            numero = 1
        } else {
            numero = numero + 1
        }
        def proceso = ProcesoAval.get(params.id)
        def now = new Date()
        if (proceso.fechaInicio < now) {
            flash.message = "Error: El proceso ${proceso.nombre}  (${proceso.fechaInicio.format('dd-MM-yyyy')} - ${proceso.fechaFin.format('dd-MM-yyyy')}) esta en ejecución, si desea solicitar un aval modifique las fechas de inicio y fin"
            redirect(action: "avalesProceso", id: proceso.id)
            return
        }

        def avales = Aval.findAllByProcesoAndEstadoInList(proceso, [EstadoAval.findByCodigo("E02"), EstadoAval.findByCodigo("E05"), EstadoAval.findByCodigo("EF1")])
        def solicitudes = SolicitudAval.findAllByProcesoAndEstadoInList(proceso, [EstadoAval.findByCodigo("E01"), EstadoAval.findByCodigo("EF4")])
        def disponible = proceso.getMonto()
//        println "aval " + avales
//        println "sols " + solicitudes
        avales.each {
            band = false
            disponible -= it.monto
        }
        solicitudes.each {
            band = false
            disponible -= it.monto
        }
//        println "band " + band
        if (!band) {
            flash.message = "Este proceso ya tiene un aval vigente o tiene una solicitud pendiente, no puede solicitar otro."
            redirect(controller: "avales", action: "avalesProceso", id: proceso?.id)
            return
        } else {
            [proceso: proceso, disponible: disponible, personas: personasFirma, numero: numero, refencial: referencial]
        }
    }

    /**
     * Acción que muestra una pantalla que permite solicitar la anulación de un aval
     */
    def solicitarAnulacion = {
        def aval = null, solicitud = null
        if (params.id) {
            aval = Aval.get(params.id)
        }
        if (params.sol) {
            solicitud = SolicitudAval.get(params.sol.toLong())
            aval = Aval.findAllByProceso(solicitud.proceso)
            if (aval.size() == 1) {
                aval = aval.first()
            } else {
                aval = null
                println "HAY ${aval.size()} avales!!!! ${aval.id}"
            }
        }
        def numero = null
        def band = true
        numero = SolicitudAval.findAllByUnidad(session.usuario.unidad, [sort: "numero", order: "desc", max: 1])
        if (numero.size() > 0) {
            numero = numero?.pop()?.numero
        }
        if (!numero) {
            numero = 1
        } else {
            numero = numero + 1
        }
        def unidad = UnidadEjecutora.get(session.unidad.id)
        def personasFirma = firmasService.listaDirectoresUnidad(unidad)
        return [aval: aval, sol: solicitud, numero: numero, personas: personasFirma]
    }

    /**
     * Acción que guarda la solicitud de aval.<br/>
     * Si la solicitud se guarda correctamente redirecciona a la acción avalesProceso, caso contrario redirecciona a la acción solicitarAval
     * ejecuta:
     * @param params los parámetros enviados por el submit del formulario
     */
    def guardarSolicitudBck = {
        println "solicitud aval " + params
        /*TODO enviar alertas*/

//        if (params.monto) {
//            params.monto = params.monto.replaceAll("\\.", "")
//            params.monto = params.monto.replaceAll(",", ".")
//        }
        def referencial = params.referencial?.toDouble()
        def montoProceso = params.monto?.toDouble()
//        println "ref "+referencial+" monto "+montoProceso
        /* montoProceso: monto del proceso
           referencial:  saldo de la asignación
         */
        if (montoProceso > referencial) {
            println "if "
            def path = servletContext.getRealPath("/") + "pdf/solicitudAval/"
            new File(path).mkdirs()
            def f = request.getFile('file')
            def okContents = [
                    'application/pdf'     : 'pdf',
                    'application/download': 'pdf',
                    'application/vnd.ms-pdf' : 'pdf'
            ]
            def nombre = ""
            def pathFile
            if ((f && !f.empty) || params.solicitud != "null") {
                def fileName = f.getOriginalFilename() //nombre original del archivo
                def ext

                def parts = fileName.split("\\.")
                fileName = ""
                parts.eachWithIndex { obj, i ->
                    if (i < parts.size() - 1) {
                        fileName += obj
                    }
                }
                if (fileName.size() > 0) {
                    ext = okContents[f.getContentType()]
                    fileName = fileName.size() < 40 ? fileName : fileName[0..39]
                    fileName = fileName.tr(/áéíóúñÑÜüÁÉÍÓÚàèìòùÀÈÌÒÙÇç .!¡¿?&#°"'/, "aeiounNUuAEIOUaeiouAEIOUCc_")
                    if (!ext) {
                        ext = "pdf"
                    }
                    nombre = fileName + "." + ext
                    pathFile = path + nombre
                    def fn = fileName
                    def src = new File(pathFile)
                    def i = 1
                    while (src.exists()) {
                        nombre = fn + "_" + i + "." + ext
                        pathFile = path + nombre
                        src = new File(pathFile)
                        i++
                    }
                }
                try {

//                    println ">>>> " + params

                    if (fileName.size() > 0) {
                        f.transferTo(new File(pathFile))  // guarda el archivo subido al nuevo path
                    }
                    def proceso = ProcesoAval.get(params.proceso)
                    def usuFirma = Persona.get(params.firma1)

                    def monto = params.monto
                    monto = monto.toDouble()
                    def concepto = params.concepto
                    def momorando = params.memorando
                    def sol = new SolicitudAval()
                    if (params.solicitud) {  // no se crea otra solicitud se ya existe
                        sol = SolicitudAval.get(params.solicitud)
                    }
                    sol.proceso = proceso
                    if (params.aval) {
                        sol.aval = Aval.get(params.aval)
                    }
                    sol.usuario = session.usuario
                    sol.numero = params.numero?.toInteger()
                    sol.monto = monto
                    sol.concepto = concepto
                    sol.memo = momorando
                    if (nombre) {
                        sol.path = nombre
                    }
                    sol.notaTecnica = params.notaTecnica

                    def firma = new Firma()
                    firma.usuario = usuFirma
                    firma.accion = "firmarSolicitud"
                    firma.controlador = "avales"

                    if (params.tipo == "A") {
                        firma.accionVer = "imprimirSolicitudAnulacionAval"
                        firma.controladorVer = "reporteSolicitud"

                        firma.documento = "SolicitudDeAnulacionDeAval_" + sol.proceso.nombre
                        firma.concepto = "Solicitud de Anulación de aval del proceso: " + proceso.nombre
                    } else {
                        firma.accionVer = "imprimirSolicitudAval"
                        firma.controladorVer = "reporteSolicitud"

                        firma.documento = "SolicitudDeAval_" + sol.proceso.nombre
                        firma.concepto = "Solicitud de aval del proceso: " + proceso.nombre
                    }

                    if (!firma.save(flush: true)) {            // ******** guarda firmas
                        println "Error en firma: " + firma.errors
                    }
                    sol.firma = firma
                    sol.unidad = session.usuario.unidad
                    if (params.tipo) {
                        sol.tipo = params.tipo
                    }
                    sol.fecha = new Date();
                    sol.estado = EstadoAval.findByCodigo("EF4")
                    if (!sol.save(flush: true)) {              // ******** guarda solicitud
                        println "eror save " + sol.errors
                    } else {
                        firma.idAccion = sol.id
                        firma.idAccionVer = sol.id
                        firma.save(flush: true)
                    }

                    // si es por direccion: direccion de planificacion e inversion
//                    def usuarios = Persona.findAllByUnidad(UnidadEjecutora.findByCodigo("DPI"))

                    //si es por perfil: Direccion de planificacion y Analista de planificacion
                    def direccionPlanificacion = Prfl.findByCodigo("DP")
                    def analistaPlanificacion = Prfl.findByCodigo("ASPL")
                    def listPerfiles = [direccionPlanificacion, analistaPlanificacion]
                    def usuarios = Sesn.findAllByPerfilInList(listPerfiles).usuario

                    usuarios.each { usu ->
                        def alerta = new Alerta()
                        alerta.from = session.usuario
                        alerta.persona = usu
                        alerta.fechaEnvio = new Date()
                        alerta.mensaje = "Nueva solicitud de aval"
                        alerta.controlador = "revisionAval"
                        alerta.accion = "pendientes"
                        alerta.id_remoto = sol.id
                        if (!alerta.save(flush: true)) {
                            println "error alerta: " + alerta.errors
                        }
                    }
                    try {
                        def mail = sol.firma.usuario.mail
                        if (mail) {

                            mailService.sendMail {
                                to mail
                                subject "Nueva solicitud de aval"
                                body "Tiene una solicitud de aval pendiente que requiere su firma para aprobación "
                            }

                        } else {
                            println "El usuario ${sol.firma.usuario.login} no tiene email"
                        }
                    } catch (e) {
                        println "eror email " + e.printStackTrace()
                    }
                    flash.message = "Solicitud enviada"
                    redirect(action: 'avalesProceso', params: [id: params.proceso])
                    //println pathFile
                } catch (e) {
                    println "????????\n" + e + "\n???????????"
                    e.printStackTrace()
                }
            } else {
                flash.message = "Error: Seleccione un archivo valido"
                redirect(action: 'listaProcesos', params: [id: params.proceso])
            }
            /* fin del upload */
        } else {
            println "else"
            def proceso = ProcesoAval.get(params.proceso)
            def usuFirma = Persona.get(params.firma1)

            def monto = params.monto
            monto = monto.toDouble()
            def concepto = params.concepto
            def momorando = params.memorando
            def sol = new SolicitudAval()
            if (params.solicitud) {  // no se crea otra solicitud se ya existe
                sol = SolicitudAval.get(params.solicitud)
            }
            sol.proceso = proceso
            if (params.aval) {
                sol.aval = Aval.get(params.aval)
            }
            sol.usuario = session.usuario
            sol.numero = params.numero?.toInteger()
            sol.monto = monto
            sol.concepto = concepto
            sol.memo = momorando
            sol.notaTecnica = params.notaTecnica
            if (params.path) {
                sol.path = params.path
            }  // verificar

            def firma = new Firma()
            firma.usuario = usuFirma
            firma.accionVer = "imprimirSolicitudAval"
            firma.controladorVer = "reporteSolicitud"
            firma.accion = "firmarSolicitud"
            firma.controlador = "avales"
            firma.documento = "SolicitudDeAval_" + sol.proceso.nombre
            firma.concepto = "Solicitud de aval del proceso: " + proceso.nombre
            firma.save(flush: true)
            sol.firma = firma
            sol.unidad = session.usuario.unidad
            if (params.tipo) {
                sol.tipo = params.tipo
            }
            sol.fecha = new Date();
            sol.estado = EstadoAval.findByCodigo("EF4")    //pone solicitado sin firma

            if (!sol.save(flush: true)) {
                println "eror save " + sol.errors
            } else {
                firma.idAccion = sol.id
                firma.idAccionVer = sol.id
                firma.save(flush: true)
            }

            def usuarios = Persona.findAllByUnidad(UnidadEjecutora.findByCodigo("DPI"))
            usuarios.each { usu ->
                def alerta = new Alerta()
                alerta.from = session.usuario
                alerta.persona = usu
                alerta.fechaEnvio = new Date()
                alerta.mensaje = "Nueva solicitud de aval"
                alerta.controlador = "revisionAval"
                alerta.accion = "pendientes"
                alerta.id_remoto = sol.id
                if (!alerta.save(flush: true)) {
                    println "error alerta: " + alerta.errors
                }
            }
            try {
                def mail = sol.firma.usuario.mail
                if (mail) {

                    mailService.sendMail {
                        to mail
                        subject "Nueve solicitud de aval"
                        body "Tiene una solicitud de aval pendiente que requiere su firma para aprobación "
                    }

                } else {
                    println "El usuario ${sol.firma.usuario.login} no tiene email"
                }
            } catch (e) {
                println "eror email " + e.printStackTrace()
            }

            flash.message = "Solicitud enviada"
            redirect(action: 'avalesProceso', params: [id: params.proceso])
        }
    }

    def guardarSolicitud() {
        println "solicitud aval " + params

        def preview = params.preview == "S"

        def strSolicitud = params.tipo == "A" ? "solicitud de anulación" : "solicitud"

        def path = servletContext.getRealPath("/") + "pdf/solicitudAval/"
        new File(path).mkdirs()
        def f = request.getFile('file')
        def okContents = [
                'application/pdf'     : 'pdf',
                'application/download': 'pdf',
                'application/vnd.ms-pdf' : 'pdf'
        ]
        def nombre, pathFile
        def fileName = ""
        if (f && !f.empty) {
            fileName = f.getOriginalFilename() //nombre original del archivo
            def ext

//            println okContents.containsKey(f.getContentType())
            if (!okContents.containsKey(f.getContentType())) {
                redirect(action: 'solicitudProceso', params: [id: params.proceso, error: "Error: Seleccione un archivo de tipo PDF"])
                return
            }

            def parts = fileName.split("\\.")
            fileName = ""
            parts.eachWithIndex { obj, i ->
                if (i < parts.size() - 1) {
                    fileName += obj
                }
            }
            if (fileName.size() > 0) {
                ext = okContents[f.getContentType()]
                fileName = fileName.size() < 40 ? fileName : fileName[0..39]
                fileName = fileName.tr(/áéíóúñÑÜüÁÉÍÓÚàèìòùÀÈÌÒÙÇç .!¡¿?&#°"'/, "aeiounNUuAEIOUaeiouAEIOUCc_")
                if (!ext) {
                    ext = "pdf"
                }
                nombre = fileName + "." + ext
                pathFile = path + nombre
                def fn = fileName
                def src = new File(pathFile)
                def i = 1
                while (src.exists()) {
                    nombre = fn + "_" + i + "." + ext
                    pathFile = path + nombre
                    src = new File(pathFile)
                    i++
                }
                try {
                    if (fileName.size() > 0) {
                        f.transferTo(new File(pathFile))  // guarda el archivo subido al nuevo path
                    }
                } catch (e) {
                    println "????????\n" + e + "\n???????????"
                    e.printStackTrace()
                }
            }
        }

        def proceso = ProcesoAval.get(params.proceso)
        def usuFirma

        def monto = params.monto
        monto = monto.toDouble()
        def concepto = params.concepto
        def memorando = params.memorando
        def sol = new SolicitudAval()
        if (params.solicitud) {  // no se crea otra solicitud se ya existe
            sol = SolicitudAval.get(params.solicitud)
            usuFirma = sol.director
            if (!usuFirma) {
                usuFirma = Persona.get(params.firma1)
            }
        } else {
            usuFirma = Persona.get(params.firma1)
        }
//        println "usuFirma: " + usuFirma
        sol.director = usuFirma
//        println "director: " + sol.director
        sol.estado = EstadoAval.findByCodigo("P01")

        sol.proceso = proceso
        if (params.aval) {
            sol.aval = Aval.get(params.aval)
        }
        sol.usuario = session.usuario
        sol.numero = params.numero?.toInteger()
        sol.monto = monto
        sol.concepto = concepto
        sol.memo = memorando
        sol.notaTecnica = params.notaTecnica
        sol.unidad = session.usuario.unidad
        if (nombre) {
            sol.path = nombre
        } else if (params.path) {
            sol.path = params.path
        }  // verificar
        if (params.tipo) {
            sol.tipo = params.tipo
        }
        sol.fecha = new Date();

        if (!sol.save(flush: true)) {              // ******** guarda solicitud
            println "error save solicitud aval" + sol.errors
        } else {
            if (!preview) {
                println "No es preview: hace alerta y marca para revision"
                sol.estado = EstadoAval.findByCodigo("R01")
                if (!sol.save(flush: true)) {
                    println "ERROR: " + sol.errors
                }
//                def firma = new Firma()
//                firma.usuario = usuFirma
//
//                firma.accion = "firmarSolicitud"
//                firma.controlador = "avales"
//
//                firma.idAccion = sol.id
//                firma.idAccionVer = sol.id
//
//                if (params.tipo == "A") {
//                    firma.accionVer = "imprimirSolicitudAnulacionAval"
//                    firma.controladorVer = "reporteSolicitud"
//
//                    firma.documento = "SolicitudDeAnulacionDeAval_" + sol.proceso.nombre
//                    firma.concepto = "Solicitud de Anulación de aval del proceso: " + proceso.nombre
//                } else {
//                    firma.accionVer = "imprimirSolicitudAval"
//                    firma.controladorVer = "reporteSolicitud"
//
//                    firma.documento = "SolicitudDeAval_" + sol.proceso.nombre
//                    firma.concepto = "Solicitud de aval del proceso: " + proceso.nombre
//                }
//
//                if (!firma.save(flush: true)) {            // ******** guarda firmas
//                    println "Error en firma: " + firma.errors
//                }
//                sol.firma = firma

                def alerta = new Alerta()
                alerta.from = session.usuario
                alerta.persona = usuFirma
                alerta.fechaEnvio = new Date()
//                alerta.mensaje = "Nueva solicitud de aval: " + sol.concepto
                alerta.mensaje = "Nueva ${strSolicitud} de aval: " + sol.proceso.nombre
                alerta.controlador = "revisionAval"
                alerta.accion = "pendientes"
                alerta.id_remoto = sol.id
                if (!alerta.save(flush: true)) {
                    println "error alerta: " + alerta.errors
                }
                try {
                    def mail = usuFirma.mail
                    if (mail) {

                        mailService.sendMail {
                            to mail
                            subject "Nueva ${strSolicitud} de aval"
                            body "Tiene una ${strSolicitud} de aval pendiente que requiere su revisión para aprobación "
                        }

                    } else {
                        println "El usuario ${sol.firma.usuario.login} no tiene email"
                    }
                } catch (e) {
                    println "error email " + e.printStackTrace()
                }
            } else {
                println "Es preview: no hace ni firma ni alerta"
            }
        }
        if (preview) {
            flash.message = "${strSolicitud.capitalize()} guardada"
            redirect(action: 'solicitudProceso', params: [id: params.proceso])
            return
        } else {
            flash.message = "${strSolicitud.capitalize()} enviada"
            redirect(action: 'avalesProceso', params: [id: params.proceso])
            return
        }
    }

    /**
     * Acción que permite realizar la nueva revision antes de la firma
     */
    def revisarSolicitud() {
        def firma = Firma.findByKey(params.key)
        if (!firma) {
            response.sendError(403)
        } else {
            def sol = SolicitudAval.findByFirma(firma)
            sol.estado = EstadoAval.findByCodigo("R01")
//            def numero
//            numero = SolicitudAval.findAllByUnidad(session.usuario.unidad, [sort: "numero", order: "desc", max: 1])
//            if (numero.size() > 0) {
//                numero = numero?.pop()?.numero
//            }
//            if (!numero) {
//                numero = 1
//            } else {
//                numero = numero + 1
//            }
//            sol.numero = numero
            sol.save(flush: true)
            try {
                def gerentes = firmasService.listaGerentesUnidad(sol.usuario.unidad)

                if (gerentes.size() > 0) {
                    def persona = Persona.get(session.usuario.personaId)

//                    println "Se enviaran ${sesiones.size()} mails"
                    gerentes.each { usro ->
                        def mail = usro.mail
                        if (mail) {
                            mailService.sendMail {
                                to mail
                                subject "Nueva solicitud de aval"
                                body "Ha recibido una nueva solicitud de aval de la unidad " + sol.unidad
                            }
                        } else {
                            println "El usuario ${usro.login} no tiene email"
                        }
                    }
                } else {
                    println "No hay nadie registrado con perfil de direccion de planificacion: no se mandan mails"
                }
            } catch (e) {
                println "Error al enviar mail: ${e.printStackTrace()}"
            }
//            redirect(controller: "pdf",action: "pdfLink",params: [url:g.createLink(controller: firma.controladorVer,action: firma.accionVer,id: firma.idAccionVer)])
            def url = g.createLink(controller: "pdf", action: "pdfLink", params: [url: g.createLink(controller: firma.controladorVer, action: firma.accionVer, id: firma.idAccionVer)])
            render "${url}"
        }
    }

    /**
     * Acción que permite firmar electronicamente la solicitud
     * @param key de la firma
     */
    def firmarSolicitud = {
//        println "Firmar solicitud: " + params
        def firma = Firma.findByKey(params.key)
        if (!firma) {
            response.sendError(403)
        } else {
            def sol = SolicitudAval.findByFirma(firma)
            sol.estado = EstadoAval.findByCodigo("E01")

            def strSolicitud = sol.tipo == "A" ? "solicitud de anulación" : "solicitud"

            def numero
            def gerencia = firmasService.requirentes(session.usuario.unidad)
            println "solicitd a firmar para gerencia: $gerencia, numero actual : ${gerencia.numeroSolicitudAval}"

//            numero = SolicitudAval.findAllByUnidad(session.usuario.unidad, [sort: "numero", order: "desc", max: 1])
            numero = gerencia.numeroSolicitudAval
            if (numero == 0) {
                numero = 1
            } else {
                numero = numero + 1
            }
            sol.numero = numero
            sol.save(flush: true)

            def unej = UnidadEjecutora.get(gerencia.id)
            unej.numeroSolicitudAval = numero
            unej.save(flush: true)

//            def perfilDireccionPlanificacion = Prfl.findByCodigo("ASPL") //igual q en reformas
            def perfilDireccionPlanificacion = Prfl.findByCodigo("DP")
//            def perfilDireccionComprasPublicas = Prfl.findByCodigo("GJ")
            def perfiles = [perfilDireccionPlanificacion]
            def sesiones = Sesn.findAllByPerfilInList(perfiles)

//            println "sesiones: " + sesiones
//            println "personas: " + sesiones.usuario
            println "usuarios: " + sesiones.usuario.login

            if (sesiones.size() > 0) {
                def persona = Persona.get(session.usuario.id)
                def now = new Date()

//                    println "Se enviaran ${sesiones.size()} mails"
                sesiones.each { sesn ->
                    Persona usro = sesn.usuario
                    def mail = usro.mail

                    def alerta = new Alerta()
                    alerta.from = persona
                    alerta.persona = usro
                    alerta.fechaEnvio = now
//                    alerta.mensaje = "Solicitud de aval: " + sol.concepto
                    alerta.mensaje = "${strSolicitud.capitalize()} de aval: " + sol.proceso.nombre
                    alerta.controlador = "revisionAval"
                    alerta.accion = "pendientes"
                    alerta.id_remoto = sol.id
                    if (!alerta.save(flush: true)) {
                        println "error alerta: " + alerta.errors
                    }/* else {
                        println "alerta a ${usro}"
                    }*/
                    if (mail) {
                        try {
                            mailService.sendMail {
                                to mail
                                subject "Nueva ${strSolicitud} de aval"
                                body "Ha recibido una nueva ${strSolicitud} de aval de la unidad " + sol.unidad
                            }
                        } catch (e) {
                            println "Error al enviar mail: ${e.printStackTrace()}"
                        }
                    } else {
                        println "El usuario ${usro.login} no tiene email"
                    }
                }
            } else {
                println "No hay nadie registrado con perfil de direccion de planificacion: no se mandan mails"
            }

//            redirect(controller: "pdf",action: "pdfLink",params: [url:g.createLink(controller: firma.controladorVer,action: firma.accionVer,id: firma.idAccionVer)])
            def url = g.createLink(controller: "pdf", action: "pdfLink", params: [url: g.createLink(controller: firma.controladorVer, action: firma.accionVer, id: firma.idAccionVer)])
            render "${url}"
        }
    }

    /**
     * Acción llamada con ajax que valida la existencia del archivo de solicitud solicitado para descarga
     */
    def validarSolicitud_ajax() {
        def sol = SolicitudAval.get(params.id)
//        println "path solicitud "+cer.pathSolicitud
        def path = servletContext.getRealPath("/") + "pdf/solicitudAval/" + sol.path

        def src = new File(path)
        if (src.exists()) {
            render "SUCCESS"
        } else {
            render "ERROR*No se encontró el archivo solicitado"
        }
    }

    /**
     * Acción que permite descargar el archivo de la solicitud
     * @param id el id de la solicitud
     */
    def descargaSolicitud = {
        def sol = SolicitudAval.get(params.id)
//        println "path solicitud "+cer.pathSolicitud
        def path = servletContext.getRealPath("/") + "pdf/solicitudAval/" + sol.path

        def src = new File(path)
        if (src.exists()) {
            response.setContentType("application/octet-stream")
            response.setHeader("Content-disposition", "attachment;filename=${src.getName()}")

            response.outputStream << src.newInputStream()
        } else {
            render "archivo no encontrado"
        }
    }

    /**
     * Acción que permite descargar el archivo del aval
     * @param id el id del aval
     */
    def descargaAval = {
//        println "descar aval "+params
        def aval = Aval.get(params.id)
//        println "path "+aval.path
        def path = servletContext.getRealPath("/") + "avales/" + aval.path

        def src = new File(path)
        if (src.exists()) {
            response.setContentType("application/octet-stream")
            response.setHeader("Content-disposition", "attachment;filename=${src.getName()}")

            response.outputStream << src.newInputStream()
        } else {
            render "archivo no encontrado"
        }
    }


}

