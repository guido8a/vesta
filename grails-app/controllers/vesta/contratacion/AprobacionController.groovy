package vesta.contratacion

import org.springframework.dao.DataIntegrityViolationException
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

                def firmaGerenciaPlanif = Usro.findAllByUnidad(unidadGerenciaPlan)
                def firmaDireccionPlanif = Usro.findAllByUnidad(unidadDireccionPlan)
                def firmaGerenciaTec = Usro.findAllByUnidad(unidadGerenciaTec)

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
    
}
