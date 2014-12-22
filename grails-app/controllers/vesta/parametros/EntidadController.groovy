package vesta.parametros

import org.springframework.dao.DataIntegrityViolationException
import vesta.seguridad.Shield


/**
 * Controlador que muestra las pantallas de manejo de Entidad
 */
class EntidadController extends Shield {

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
            def c = Entidad.createCriteria()
            list = c.list(params) {
                or {
                    /* TODO: cambiar aqui segun sea necesario */

                    ilike("direccion", "%" + params.search + "%")
                    ilike("email", "%" + params.search + "%")
                    ilike("fax", "%" + params.search + "%")
                    ilike("nombre", "%" + params.search + "%")
                    ilike("objetivo", "%" + params.search + "%")
                    ilike("observaciones", "%" + params.search + "%")
                    ilike("sigla", "%" + params.search + "%")
                    ilike("telefono", "%" + params.search + "%")
                }
            }
        } else {
            list = Entidad.list(params)
        }
        if (!all && params.offset.toInteger() > 0 && list.size() == 0) {
            params.offset = params.offset.toInteger() - 1
            list = getList(params, all)
        }
        return list
    }

    /**
     * Acción que muestra la lista de elementos
     * @return entidadInstanceList: la lista de elementos filtrados, entidadInstanceCount: la cantidad total de elementos (sin máximo)
     */
    def list() {
        def entidadInstanceList = getList(params, false)
        def entidadInstanceCount = getList(params, true).size()
        return [entidadInstanceList: entidadInstanceList, entidadInstanceCount: entidadInstanceCount]
    }

    /**
     * Acción llamada con ajax que muestra la información de un elemento particular
     * @return entidadInstance el objeto a mostrar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def show_ajax() {
        if (params.id) {
            def entidadInstance = Entidad.get(params.id)
            if (!entidadInstance) {
                render "ERROR*No se encontró Entidad."
                return
            }
            return [entidadInstance: entidadInstance]
        } else {
            render "ERROR*No se encontró Entidad."
        }
    } //show para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que muestra un formaulario para crear o modificar un elemento
     * @return entidadInstance el objeto a modificar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def form_ajax() {
        def entidadInstance = new Entidad()
        if (params.id) {
            entidadInstance = Entidad.get(params.id)
            if (!entidadInstance) {
                render "ERROR*No se encontró Entidad."
                return
            }
        }
        entidadInstance.properties = params
        return [entidadInstance: entidadInstance]
    } //form para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que guarda la información de un elemento
     * @render ERROR*[mensaje] cuando no se pudo grabar correctamente, SUCCESS*[mensaje] cuando se grabó correctamente
     */
    def save_ajax() {
        def entidadInstance = new Entidad()
        if (params.id) {
            entidadInstance = Entidad.get(params.id)
            if (!entidadInstance) {
                render "ERROR*No se encontró Entidad."
                return
            }
        }
        entidadInstance.properties = params
        if (!entidadInstance.save(flush: true)) {
            render "ERROR*Ha ocurrido un error al guardar Entidad: " + renderErrors(bean: entidadInstance)
            return
        }
        render "SUCCESS*${params.id ? 'Actualización' : 'Creación'} de Entidad exitosa."
        return
    } //save para grabar desde ajax

    /**
     * Acción llamada con ajax que permite eliminar un elemento
     * @render ERROR*[mensaje] cuando no se pudo eliminar correctamente, SUCCESS*[mensaje] cuando se eliminó correctamente
     */
    def delete_ajax() {
        if (params.id) {
            def entidadInstance = Entidad.get(params.id)
            if (!entidadInstance) {
                render "ERROR*No se encontró Entidad."
                return
            }
            try {
                entidadInstance.delete(flush: true)
                render "SUCCESS*Eliminación de Entidad exitosa."
                return
            } catch (DataIntegrityViolationException e) {
                render "ERROR*Ha ocurrido un error al eliminar Entidad"
                return
            }
        } else {
            render "ERROR*No se encontró Entidad."
            return
        }
    } //delete para eliminar via ajax

    /**
     * Acción llamada con ajax que valida que no se duplique la propiedad email
     * @render boolean que indica si se puede o no utilizar el valor recibido
     */
    def validar_unique_email_ajax() {
        params.email = params.email.toString().trim()
        if (params.id) {
            def obj = Entidad.get(params.id)
            if (obj.email.toLowerCase() == params.email.toLowerCase()) {
                render true
                return
            } else {
                render Entidad.countByEmailIlike(params.email) == 0
                return
            }
        } else {
            render Entidad.countByEmailIlike(params.email) == 0
            return
        }
    }

}
