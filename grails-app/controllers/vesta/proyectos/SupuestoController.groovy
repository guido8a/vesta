package vesta.proyectos

import org.springframework.dao.DataIntegrityViolationException
import vesta.seguridad.Shield


/**
 * Controlador que muestra las pantallas de manejo de Supuesto
 */
class SupuestoController extends Shield {

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
            def c = Supuesto.createCriteria()
            list = c.list(params) {
                or {
                    /* TODO: cambiar aqui segun sea necesario */

                    ilike("descripcion", "%" + params.search + "%")
                }
            }
        } else {
            list = Supuesto.list(params)
        }
        if (!all && params.offset.toInteger() > 0 && list.size() == 0) {
            params.offset = params.offset.toInteger() - 1
            list = getList(params, all)
        }
        return list
    }

    /**
     * Acción que muestra la lista de elementos
     * @return supuestoInstanceList: la lista de elementos filtrados, supuestoInstanceCount: la cantidad total de elementos (sin máximo)
     */
    def list() {
        def supuestoInstanceList = getList(params, false)
        def supuestoInstanceCount = getList(params, true).size()
        return [supuestoInstanceList: supuestoInstanceList, supuestoInstanceCount: supuestoInstanceCount]
    }

    /**
     * Acción llamada con ajax que muestra la información de un elemento particular
     * @return supuestoInstance el objeto a mostrar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def show_ajax() {
        if (params.id) {
            def supuestoInstance = Supuesto.get(params.id)
            if (!supuestoInstance) {
                render "ERROR*No se encontró Supuesto."
                return
            }
            return [supuestoInstance: supuestoInstance]
        } else {
            render "ERROR*No se encontró Supuesto."
        }
    } //show para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que muestra un formaulario para crear o modificar un elemento
     * @return supuestoInstance el objeto a modificar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def form_ajax() {
        def supuestoInstance = new Supuesto()
        if (params.id) {
            supuestoInstance = Supuesto.get(params.id)
            if (!supuestoInstance) {
                render "ERROR*No se encontró Supuesto."
                return
            }
        }
        supuestoInstance.properties = params
        return [supuestoInstance: supuestoInstance]
    } //form para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que guarda la información de un elemento
     * @render ERROR*[mensaje] cuando no se pudo grabar correctamente, SUCCESS*[mensaje] cuando se grabó correctamente
     */
    def save_ajax() {
        def supuestoInstance = new Supuesto()
        if (params.id) {
            supuestoInstance = Supuesto.get(params.id)
            if (!supuestoInstance) {
                render "ERROR*No se encontró Supuesto."
                return
            }
        }
        supuestoInstance.properties = params
        if (!supuestoInstance.save(flush: true)) {
            render "ERROR*Ha ocurrido un error al guardar Supuesto: " + renderErrors(bean: supuestoInstance)
            return
        }
        render "SUCCESS*${params.id ? 'Actualización' : 'Creación'} de Supuesto exitosa."
        return
    } //save para grabar desde ajax

    /**
     * Acción llamada con ajax que permite eliminar un elemento
     * @render ERROR*[mensaje] cuando no se pudo eliminar correctamente, SUCCESS*[mensaje] cuando se eliminó correctamente
     */
    def delete_ajax() {
        if (params.id) {
            def supuestoInstance = Supuesto.get(params.id)
            if (!supuestoInstance) {
                render "ERROR*No se encontró Supuesto."
                return
            }
            try {
                supuestoInstance.delete(flush: true)
                render "SUCCESS*Eliminación de Supuesto exitosa."
                return
            } catch (DataIntegrityViolationException e) {
                render "ERROR*Ha ocurrido un error al eliminar Supuesto"
                return
            }
        } else {
            render "ERROR*No se encontró Supuesto."
            return
        }
    } //delete para eliminar via ajax

}
