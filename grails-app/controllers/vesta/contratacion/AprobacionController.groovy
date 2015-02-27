package vesta.contratacion

import org.springframework.dao.DataIntegrityViolationException
import sun.util.calendar.BaseCalendar
import vesta.parametros.TipoAprobacion
import vesta.parametros.UnidadEjecutora
import vesta.seguridad.Persona
import vesta.seguridad.Prfl
import vesta.seguridad.Shield


/**
 * Controlador que muestra las pantallas de manejo de Aprobacion
 */
class AprobacionController extends Shield {

    static allowedMethods = [save_ajax: "POST", delete_ajax: "POST"]

    /**
     * Acción que redirecciona a la lista (acción "list")
     */
    def index() {
        redirect(action:"list", params: params)
    }

    /**
     * Función que saca la lista de elementos según los parámetros recibidos
     * @param params objeto que contiene los parámetros para la búsqueda:: max: el máximo de respuestas, offset: índice del primer elemento (para la paginación), search: para efectuar búsquedas
     * @param all boolean que indica si saca todos los resultados, ignorando el parámetro max (true) o no (false)
     * @return lista de los elementos encontrados
     */
    def getList(params, all) {
        params = params.clone()
        params.max = params.max ? Math.min(params.max.toInteger(), 100) : 10
        params.offset = params.offset ?: 0
        if(all) {
            params.remove("max")
            params.remove("offset")
        }
        def list
        if(params.search) {
            def c = Aprobacion.createCriteria()
            list = c.list(params) {
                or {
                    /* TODO: cambiar aqui segun sea necesario */
                    
                    ilike("aprobada", "%" + params.search + "%")  
                    ilike("asistentes", "%" + params.search + "%")  
                    ilike("numero", "%" + params.search + "%")  
                    ilike("observaciones", "%" + params.search + "%")  
                    ilike("pathPdf", "%" + params.search + "%")  
                }
            }
        } else {
            list = Aprobacion.list(params)
        }
        if (!all && params.offset.toInteger() > 0 && list.size() == 0) {
            params.offset = params.offset.toInteger() - 1
            list = getList(params, all)
        }
        return list
    }

    /**
     * Acción que muestra la lista de elementos
     * @return aprobacionInstanceList: la lista de elementos filtrados, aprobacionInstanceCount: la cantidad total de elementos (sin máximo)
     */
    def list() {
        println(params)
//        def aprobacionInstanceList = getList(params, false)
        def aprobacionInstanceCount = getList(params, true).size()

        def title = g.message(code: "aprobacion.list", default: "Aprobacion List")
        params.sort = "fecha"
        params.order = "desc"
        params.max = Math.min(params.max ? params.int('max') : 10, 100)

        def c = Aprobacion.createCriteria()
        def lista = c.list(params) {
            if (params.search) {
                solicitudes {
                    ilike("nombreProceso", "%" + params.search.trim() + "%")
                    unidadEjecutora{
                        ilike("nombre", "%" + params.search.trim() + "%")
                    }
                }
            }
        }
       def c2 = Aprobacion.createCriteria()
        def total = c2.list() {
            if (params.search) {
                solicitudes {
                    ilike("nombreProceso", "%" + params.search.trim() + "%")
                    unidadEjecutora{
                        ilike("nombre", "%" + params.search.trim() + "%")
                    }
                }
            }
        }.size()
        [aprobacionInstanceList: lista, aprobacionInstanceTotal: total,title: title, params: params, aprobacionInstanceCount: aprobacionInstanceCount ]

    }

    /**
     * Acción que muestra una lista de las actas subidas
     */
    def listaActas () {
        /*
        Gerencia de Planificación, Dirección Planificación y  Dirección de Seguimiento,
                GP                      DP                          DS
        Dirección de Contratación Pública y la Dirección Administrativa, Gerencia Técnica
                DCP                                  DA                      GT
            TODAS
         */

        def perfil = session.perfil
        def usuario = Persona.get(session.usuario.id)
        def unidad = usuario.unidad
        def todos = ["GP", "DP", "DS", "DCP", "DA", "GT"]
        def aprobaciones = []
        def a = Aprobacion.withCriteria {
            isNotNull("fechaRealizacion")
            isNotNull("pathPdf")
        }
        if (todos.contains(perfil.codigo)) {
            aprobaciones = a
        }

        return [aprobaciones: aprobaciones]
    }

    /**
     * Acción llamada con ajax para cargar un datepicker para la reunión de aprobación
     */
    def setFechaReunion_ajax () {

    }

    /**
     * Acción llamada con ajax que guarda la fecha de una reunión de aprobación
     */
    def saveFechaReunion_ajax () {

        def aprobacion = Aprobacion.get(params.id)
        def fecha = new Date().parse("dd-MM-yyyy HH:mm", params.fecha)
        aprobacion.fecha = fecha
        if (!aprobacion.save(flush: true)) {
            println "Error al guardar la fecha: " + aprobacion.errors
            render "ERROR*Error al guardar la fecha de la reunión de aprobación"
            return
        } else {
            render "SUCCESS*Se ha guardado la fecha de la reunión de aprobación"
            return
        }

    }

    /**
     * Acción llamada con ajax para cargar un dialog de subir archivos
     */
    def subirActa_ajax () {
        def reunion = Aprobacion.get(params.id)
        return [reunion: reunion]
    }

    def reunion () {

            def ahora = new Date()
            def hoy1 = new Date().parse("dd-MM-yyyy HH:mm", ahora.format("dd-MM-yyyy") + " 00:00")
            def hoy2 = new Date().parse("dd-MM-yyyy HH:mm", ahora.format("dd-MM-yyyy") + " 23:59")

            def perfil = Prfl.get(session.perfil.id)
            def reuniones, reunion = null
            if (params.id) {
                reunion = Aprobacion.get(params.id.toLong())
            }
            if (!reunion) {
                reuniones = Aprobacion.findAllByFechaBetween(hoy1, hoy2)
            } else {
                reuniones = [reunion]
            }
            if (reuniones.size() == 1) {

                reunion = reuniones.first()
                if (reunion.aprobada == 'A') {
                    params.show = 1
                }

                def unidadGerenciaPlan = UnidadEjecutora.findByCodigo("DRPL") // GERENCIA DE PLANIFICACIÓN
                def unidadDireccionPlan = UnidadEjecutora.findByCodigo("DPI") // DIRECCIÓN DE PLANIFICACIÓN E INVERSIÓN
                def unidadGerenciaTec = UnidadEjecutora.findByCodigo("GT") // GERENCIA TÉCNICA

                def firmaGerenciaPlanif = Persona.findAllByUnidad(unidadGerenciaPlan)
                def firmaDireccionPlanif = Persona.findAllByUnidad(unidadDireccionPlan)
                def firmaGerenciaTec = Persona.findAllByUnidad(unidadGerenciaTec)

                return [reunion: reunion, params: params, perfil: perfil, firmaGerenciaPlanif: firmaGerenciaPlanif,
                        firmaDireccionPlanif: firmaDireccionPlanif, firmaGerenciaTec: firmaGerenciaTec/*, firmaRequirente: firmaRequirente*/]
            } else if (reuniones.size() == 0) {
                flash.message = "<div class='ui-state-error ui-corner-all' style='padding:5px;'>" +
                        "<span style=\"float: left; margin-right: .3em;\" class=\"ui-icon ui-icon-alert\"></span>" +
                        "No hay reuniones programadas para el día de hoy. Seleccione una o cree una nueva." +
                        "</div>"
            } else {
                flash.message = "Hay ${reuniones.size()} reuniones programadas para el día de hoy. Seleccione una."
            }
            redirect(action: "list")


    }


    def prepararReunionAprobacion () {
        def title = g.message(code: "default.list.label", args: ["Solicitud"], default: "Solicitud List")

        params.max = Math.min(params.max ? params.int('max') : 25, 100)

        def list = Solicitud.findAllByIncluirReunion("S", params)
        def count = Solicitud.countByIncluirReunion("S")
        def reunion = null
        if (params.id) {
            reunion = Aprobacion.get(params.id.toLong())
            flash.message = "<div class='' style='padding:5px;'>" +
                    "<span style=\"float: left; margin-right: .3em;\" class=\"ui-icon ui-icon-info\"></span> Preparar reunión "
            if (reunion.fecha) {
                flash.message += "del " + reunion.fecha.format("dd-MM-yyyy HH:mm")
            } else {
                flash.message += " sin fecha establecida"
            }
            flash.message += "</div>"
        }

        [solicitudInstanceList: list, solicitudInstanceTotal: count, title: title, params: params, reunion: reunion]
    }

    def detalles_ajax () {
        def aprobacionInstance = Aprobacion.get(params.id)
        if (!aprobacionInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'aprobacion.label', default: 'Aprobacion'), params.id])}"
            redirect(action: "list")
        } else {

            def title = g.message(code: "aprobacion.show", default: "Show Aprobacion")

            [aprobacionInstance: aprobacionInstance, title: title]
        }
    }

    /**
     * Acción que permite eliminar un sector y redirecciona a la acción List
     * @param id id del elemento a ser eliminado
     */
//    def delete () {
//        def aprobacionInstance = Aprobacion.get(params.id)
//        if (aprobacionInstance) {
//            try {
//                aprobacionInstance.delete(flush: true)
//                flash.message = "${message(code: 'default.deleted.message', args: [message(code: 'aprobacion.label', default: 'Aprobacion'), params.id])}"
//                redirect(action: "list")
//            }
//            catch (org.springframework.dao.DataIntegrityViolationException e) {
//                flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'aprobacion.label', default: 'Aprobacion'), params.id])}"
////                redirect(action: "show", id: params.id)
//                render "ERROR*Ocurrio un error."
//                return
//            }
//        } else {
//            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'aprobacion.label', default: 'Aprobacion'), params.id])}"
//            render "ERROR*Ocurrio un error."
//            return
//        }
//    }

    /**
     * Acción llamada con ajax que muestra el diálogo para agendar reunión de contratación: fecha, hora, comentarios para cada solicitud
     */
    def agendarReunion_ajax = {
//        println "AQUI " + params
        def reunion = new Aprobacion()
        if (params.id) {
            reunion = Aprobacion.get(params.id.toLong())
            if (!reunion) {
                reunion = new Aprobacion()
            }
        }

        def ids = params.ids.split("_")
        if (ids instanceof String) {
            ids = [ids]
        }
        ids = ids*.toLong()

        def solicitudes = Solicitud.findAllByIdInList(ids)
        if (reunion.id) {
            solicitudes = Solicitud.findAllByIdInListOrAprobacion(ids, reunion)
        }

        return [reunion: reunion, solicitudes: solicitudes]
    }

    /**
     * Acción llamada con ajax que crea una reunión de aprobación asignando una lista de solicitudes a tratar
     */
    def agendarReunion = {
//        println params
//        def f = params.fecha
//        def h = params.horas.toString().toInteger()
//        def m = params.minutos.toString().toInteger() * 5
//        def fecha = new Date().parse("dd-MM-yyyy HH:mm", f + " " + h + ":" + m)

        def ok = true
        def aprobacion = null
        if (params.id) {
            aprobacion = Aprobacion.get(params.id)
            if (!aprobacion) {
                aprobacion = new Aprobacion()
                if (!aprobacion.save(flush: true)) {
                    ok = false
                    println "Error al crear reunion de aprobacion: " + aprobacion.errors
                    render "ERROR*Error al crear la reunión de aprobación"
                    return
                }
            }
        } else {
            aprobacion = new Aprobacion()
            if (!aprobacion.save(flush: true)) {
                ok = false
                println "Error al crear reunion de aprobacion: " + aprobacion.errors
                render "ERROR*Error al crear la reunión de aprobación"
                return
            }
        }

        if (ok) {
            params.each { k, v ->
                if (k.toString().startsWith("revision")) {
                    def parts = k.split("_");
                    if (parts.size() == 2) {
                        def id = parts[1].toLong()
                        def solicitud = Solicitud.get(id)
                        solicitud.aprobacion = aprobacion
                        solicitud.revisionDireccionPlanificacionInversion = v
                        if (!solicitud.save(flush: true)) {
                            ok = false
                            println "Error asignando aprobacion a la solicitud: " + solicitud.errors
                            render "ERROR*Error asignando aprobación a la solicitud"
                            return
                        }
                    }
                }
            }
        }
//        render(ok ? "OK" : "NO")
        render (ok ? "SUCCESS*Se creo la reunión de aprobación" : "ERROR*Error asignando aprobación a la solicitud")
        return
    }




    /**
     * Acción llamada con ajax que muestra la información de un elemento particular
     * @return aprobacionInstance el objeto a mostrar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def show_ajax() {
        if(params.id) {
            def aprobacionInstance = Aprobacion.get(params.id)
            if(!aprobacionInstance) {
                render "ERROR*No se encontró Aprobacion."
                return
            }
            return [aprobacionInstance: aprobacionInstance]
        } else {
            render "ERROR*No se encontró Aprobacion."
        }
    } //show para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que muestra un formulario para crear o modificar un elemento
     * @return aprobacionInstance el objeto a modificar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def form_ajax() {
        def aprobacionInstance = new Aprobacion()
        if(params.id) {
            aprobacionInstance = Aprobacion.get(params.id)
            if(!aprobacionInstance) {
                render "ERROR*No se encontró Aprobacion."
                return
            }
        }
        aprobacionInstance.properties = params
        return [aprobacionInstance: aprobacionInstance]
    } //form para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que guarda la información de un elemento
     * @render ERROR*[mensaje] cuando no se pudo grabar correctamente, SUCCESS*[mensaje] cuando se grabó correctamente
     */
    def save_ajax() {
        def aprobacionInstance = new Aprobacion()
        if(params.id) {
            aprobacionInstance = Aprobacion.get(params.id)
            if(!aprobacionInstance) {
                render "ERROR*No se encontró Aprobacion."
                return
            }
        }
        aprobacionInstance.properties = params
        if(!aprobacionInstance.save(flush: true)) {
            render "ERROR*Ha ocurrido un error al guardar Aprobacion: " + renderErrors(bean: aprobacionInstance)
            return
        }
        render "SUCCESS*${params.id ? 'Actualización' : 'Creación'} de Aprobacion exitosa."
        return
    } //save para grabar desde ajax

    /**
     * Acción llamada con ajax que permite eliminar un elemento
     * @render ERROR*[mensaje] cuando no se pudo eliminar correctamente, SUCCESS*[mensaje] cuando se eliminó correctamente
     */
    def delete_ajax() {
        if(params.id) {
            def aprobacionInstance = Aprobacion.get(params.id)
            if (!aprobacionInstance) {
                render "ERROR*No se encontró Aprobacion."
                return
            }
            try {
                aprobacionInstance.delete(flush: true)
                render "SUCCESS*Eliminación de Aprobacion exitosa."
                return
            } catch (DataIntegrityViolationException e) {
                render "ERROR*Ha ocurrido un error al eliminar Aprobacion"
                return
            }
        } else {
            render "ERROR*No se encontró Aprobacion."
            return
        }
    } //delete para eliminar via ajax


    /**
     * Acción que guarda los datos de la reunión de aprobación
     */
    def saveAprobacion () {
//        println "SAVE APROBACION>>>>> " + params

        def reunion = Aprobacion.get(params.id.toLong())
        reunion.observaciones = params.observaciones.trim()
        reunion.fechaRealizacion = new Date()
        if (!reunion.fecha) {
            reunion.fecha = new Date()
        }
        reunion.creadoPor = Persona.get(session.usuario.id)
        reunion.aprobada = params.aprobada

        if (!reunion.numero) {
            def numero = 1
            def maxNum = Aprobacion.list().numero*.toInteger().max()
            if (maxNum) {
                numero = maxNum.toInteger() + 1
            }
            reunion.numero = numero.toString()
            if (!reunion.save(flush: true)) {
                println "error al asignar numero a la reunión::: " + reunion.errors
//                render "ERROR*Error al asignar numero a la reunión."
                flash.message = "Error al asignar número a la reunión"

            }
        }

        if (!reunion.save(flush: true)) {
            println "Error al guardar la reunión: " + reunion.errors
//            render "ERROR*Error al guardar la reunión."
            flash.message = "Error al guardar la reunión"

        } else {
            def solicitudes = [:]
            params.each { k, v ->
                def parts = k.split("_")
                if (parts.size() == 2) {
                    def id = parts[0].toLong()
                    def campo = parts[1]
                    if (!solicitudes[id]) {
                        solicitudes[id] = Solicitud.get(id)
                    }
                    if (campo == "observaciones") {
                        solicitudes[id].observacionesAprobacion = solicitudes[id].observacionesAprobacion ?
                                solicitudes[id].observacionesAprobacion + "; " + v.trim() : v.trim()
                    } else if (campo == "asistentes") {
                        solicitudes[id].asistentesAprobacion = v.trim()
                    } else if (campo == "tipoAprobacion.id") {
                        solicitudes[id].tipoAprobacion = TipoAprobacion.get(v.toLong())
                    }
                }
            }
            solicitudes.each { id, solicitud ->
                solicitud.estado = "A" // --> ya fue tratada en una reunión, ya no se puede modificar...
                if (!solicitud.save(flush: true)) {
                    println "error al guardar la solicitud: " + solicitud.errors
                    flash.message = "Error al guardar la solicitud"

//                    render "ERROR*Error al guardar la solicitud."
//                    return
                }
            }
        }
        flash.message = "Datos guardados correctamente"
//        render "SUCCESS*Guardado correctamente."
//        return
        if (params.aprobada == 'A') {
            redirect(action: "reunion", id: reunion.id, params: [show: 1])
        } else {
            redirect(action: "reunion", id: reunion.id)
        }
    }
    
}
