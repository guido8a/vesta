package vesta.parametros

import org.springframework.dao.DataIntegrityViolationException
import vesta.seguridad.Shield


/**
 * Controlador que muestra las pantallas de manejo de SubSecretaria
 */
class SubSecretariaController extends Shield {

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
            def c = SubSecretaria.createCriteria()
            list = c.list(params) {
                or {
                    /* TODO: cambiar aqui segun sea necesario */

                    ilike("nombre", "%" + params.search + "%")
                    ilike("titulo", "%" + params.search + "%")
                }
            }
        } else {
            list = SubSecretaria.list(params)
        }
        if (!all && params.offset.toInteger() > 0 && list.size() == 0) {
            params.offset = params.offset.toInteger() - 1
            list = getList(params, all)
        }
        return list
    }

    /**
     * Acción que muestra la lista de elementos
     * @return subSecretariaInstanceList: la lista de elementos filtrados, subSecretariaInstanceCount: la cantidad total de elementos (sin máximo)
     */
    def list() {
        def subSecretariaInstanceList = getList(params, false)
        def subSecretariaInstanceCount = getList(params, true).size()
        return [subSecretariaInstanceList: subSecretariaInstanceList, subSecretariaInstanceCount: subSecretariaInstanceCount]
    }

    /**
     * Acción llamada con ajax que muestra la información de un elemento particular
     * @return subSecretariaInstance el objeto a mostrar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def show_ajax() {
        if (params.id) {
            def subSecretariaInstance = SubSecretaria.get(params.id)
            if (!subSecretariaInstance) {
                render "ERROR*No se encontró SubSecretaria."
                return
            }
            return [subSecretariaInstance: subSecretariaInstance]
        } else {
            render "ERROR*No se encontró SubSecretaria."
        }
    } //show para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que muestra un formaulario para crear o modificar un elemento
     * @return subSecretariaInstance el objeto a modificar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def form_ajax() {
        def subSecretariaInstance = new SubSecretaria()
        if (params.id) {
            subSecretariaInstance = SubSecretaria.get(params.id)
            if (!subSecretariaInstance) {
                render "ERROR*No se encontró SubSecretaria."
                return
            }
        }
        subSecretariaInstance.properties = params
        return [subSecretariaInstance: subSecretariaInstance]
    } //form para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que guarda la información de un elemento
     * @render ERROR*[mensaje] cuando no se pudo grabar correctamente, SUCCESS*[mensaje] cuando se grabó correctamente
     */
    def save_ajax() {
        def subSecretariaInstance = new SubSecretaria()
        if (params.id) {
            subSecretariaInstance = SubSecretaria.get(params.id)
            if (!subSecretariaInstance) {
                render "ERROR*No se encontró SubSecretaria."
                return
            }
        }
        subSecretariaInstance.properties = params
        if (!subSecretariaInstance.save(flush: true)) {
            render "ERROR*Ha ocurrido un error al guardar SubSecretaria: " + renderErrors(bean: subSecretariaInstance)
            return
        }
        render "SUCCESS*${params.id ? 'Actualización' : 'Creación'} de SubSecretaria exitosa."
        return
    } //save para grabar desde ajax

    /**
     * Acción llamada con ajax que permite eliminar un elemento
     * @render ERROR*[mensaje] cuando no se pudo eliminar correctamente, SUCCESS*[mensaje] cuando se eliminó correctamente
     */
    def delete_ajax() {
        if (params.id) {
            def subSecretariaInstance = SubSecretaria.get(params.id)
            if (!subSecretariaInstance) {
                render "ERROR*No se encontró SubSecretaria."
                return
            }
            try {
                subSecretariaInstance.delete(flush: true)
                render "SUCCESS*Eliminación de SubSecretaria exitosa."
                return
            } catch (DataIntegrityViolationException e) {
                render "ERROR*Ha ocurrido un error al eliminar SubSecretaria"
                return
            }
        } else {
            render "ERROR*No se encontró SubSecretaria."
            return
        }
    } //delete para eliminar via ajax

}
