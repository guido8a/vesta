package vesta.proyectos

import org.springframework.dao.DataIntegrityViolationException
import vesta.seguridad.Shield


/**
 * Controlador que muestra las pantallas de manejo de EjecucionUE
 */
class EjecucionUEController extends Shield {

    static allowedMethods = [save_ajax: "POST", delete_ajax: "POST"]

    /**
     * Acción que redirecciona a la lista (acción "list")
     */
    def index() {
        redirect(action: "list", params: params)
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
        if (all) {
            params.remove("max")
            params.remove("offset")
        }
        def list
        if (params.search) {
            def c = EjecucionUE.createCriteria()
            list = c.list(params) {
                or {
                    /* TODO: cambiar aqui segun sea necesario */

                }
            }
        } else {
            list = EjecucionUE.list(params)
        }
        if (!all && params.offset.toInteger() > 0 && list.size() == 0) {
            params.offset = params.offset.toInteger() - 1
            list = getList(params, all)
        }
        return list
    }

    /**
     * Acción que muestra la lista de elementos
     * @return ejecucionUEInstanceList: la lista de elementos filtrados, ejecucionUEInstanceCount: la cantidad total de elementos (sin máximo)
     */
    def list() {
        def ejecucionUEInstanceList = getList(params, false)
        def ejecucionUEInstanceCount = getList(params, true).size()
        return [ejecucionUEInstanceList: ejecucionUEInstanceList, ejecucionUEInstanceCount: ejecucionUEInstanceCount]
    }

    /**
     * Acción llamada con ajax que muestra la información de un elemento particular
     * @return ejecucionUEInstance el objeto a mostrar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def show_ajax() {
        if (params.id) {
            def ejecucionUEInstance = EjecucionUE.get(params.id)
            if (!ejecucionUEInstance) {
                render "ERROR*No se encontró EjecucionUE."
                return
            }
            return [ejecucionUEInstance: ejecucionUEInstance]
        } else {
            render "ERROR*No se encontró EjecucionUE."
        }
    } //show para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que muestra un formaulario para crear o modificar un elemento
     * @return ejecucionUEInstance el objeto a modificar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def form_ajax() {
        def ejecucionUEInstance = new EjecucionUE()
        if (params.id) {
            ejecucionUEInstance = EjecucionUE.get(params.id)
            if (!ejecucionUEInstance) {
                render "ERROR*No se encontró EjecucionUE."
                return
            }
        }
        ejecucionUEInstance.properties = params
        return [ejecucionUEInstance: ejecucionUEInstance]
    } //form para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que guarda la información de un elemento
     * @render ERROR*[mensaje] cuando no se pudo grabar correctamente, SUCCESS*[mensaje] cuando se grabó correctamente
     */
    def save_ajax() {
        def ejecucionUEInstance = new EjecucionUE()
        if (params.id) {
            ejecucionUEInstance = EjecucionUE.get(params.id)
            if (!ejecucionUEInstance) {
                render "ERROR*No se encontró EjecucionUE."
                return
            }
        }
        ejecucionUEInstance.properties = params
        if (!ejecucionUEInstance.save(flush: true)) {
            render "ERROR*Ha ocurrido un error al guardar EjecucionUE: " + renderErrors(bean: ejecucionUEInstance)
            return
        }
        render "SUCCESS*${params.id ? 'Actualización' : 'Creación'} de EjecucionUE exitosa."
        return
    } //save para grabar desde ajax

    /**
     * Acción llamada con ajax que permite eliminar un elemento
     * @render ERROR*[mensaje] cuando no se pudo eliminar correctamente, SUCCESS*[mensaje] cuando se eliminó correctamente
     */
    def delete_ajax() {
        if (params.id) {
            def ejecucionUEInstance = EjecucionUE.get(params.id)
            if (!ejecucionUEInstance) {
                render "ERROR*No se encontró EjecucionUE."
                return
            }
            try {
                ejecucionUEInstance.delete(flush: true)
                render "SUCCESS*Eliminación de EjecucionUE exitosa."
                return
            } catch (DataIntegrityViolationException e) {
                render "ERROR*Ha ocurrido un error al eliminar EjecucionUE"
                return
            }
        } else {
            render "ERROR*No se encontró EjecucionUE."
            return
        }
    } //delete para eliminar via ajax

}
