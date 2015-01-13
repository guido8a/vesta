package vesta.parametros

import org.springframework.dao.DataIntegrityViolationException
import vesta.seguridad.Shield


/**
 * Controlador que muestra las pantallas de manejo de Contratista
 */
class ContratistaController extends Shield {

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
            def c = Contratista.createCriteria()
            list = c.list(params) {
                or {
                    /* TODO: cambiar aqui segun sea necesario */

                    ilike("apellido", "%" + params.search + "%")
                    ilike("direccion", "%" + params.search + "%")
                    ilike("estado", "%" + params.search + "%")
                    ilike("mail", "%" + params.search + "%")
                    ilike("nombre", "%" + params.search + "%")
                    ilike("nombreCont", "%" + params.search + "%")
                    ilike("observaciones", "%" + params.search + "%")
                    ilike("ruc", "%" + params.search + "%")
                    ilike("telefono", "%" + params.search + "%")
                }
            }
        } else {
            list = Contratista.list(params)
        }
        if (!all && params.offset.toInteger() > 0 && list.size() == 0) {
            params.offset = params.offset.toInteger() - 1
            list = getList(params, all)
        }
        return list
    }

    /**
     * Acción que muestra la lista de elementos
     * @return contratistaInstanceList: la lista de elementos filtrados, contratistaInstanceCount: la cantidad total de elementos (sin máximo)
     */
    def list() {
        def contratistaInstanceList = getList(params, false)
        def contratistaInstanceCount = getList(params, true).size()
        return [contratistaInstanceList: contratistaInstanceList, contratistaInstanceCount: contratistaInstanceCount]
    }

    /**
     * Acción llamada con ajax que muestra la información de un elemento particular
     * @return contratistaInstance el objeto a mostrar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def show_ajax() {
        if (params.id) {
            def contratistaInstance = Contratista.get(params.id)
            if (!contratistaInstance) {
                render "ERROR*No se encontró Contratista."
                return
            }
            return [contratistaInstance: contratistaInstance]
        } else {
            render "ERROR*No se encontró Contratista."
        }
    } //show para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que muestra un formulario para crear o modificar un elemento
     * @return contratistaInstance el objeto a modificar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def form_ajax() {
        def contratistaInstance = new Contratista()
        if (params.id) {
            contratistaInstance = Contratista.get(params.id)
            if (!contratistaInstance) {
                render "ERROR*No se encontró Contratista."
                return
            }
        }
        contratistaInstance.properties = params
        return [contratistaInstance: contratistaInstance]
    } //form para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que guarda la información de un elemento
     * @render ERROR*[mensaje] cuando no se pudo grabar correctamente, SUCCESS*[mensaje] cuando se grabó correctamente
     */
    def save_ajax() {
        def contratistaInstance = new Contratista()
        if (params.id) {
            contratistaInstance = Contratista.get(params.id)
            if (!contratistaInstance) {
                render "ERROR*No se encontró Contratista."
                return
            }
        }
        contratistaInstance.properties = params
        if (!contratistaInstance.save(flush: true)) {
            render "ERROR*Ha ocurrido un error al guardar Contratista: " + renderErrors(bean: contratistaInstance)
            return
        }
        render "SUCCESS*${params.id ? 'Actualización' : 'Creación'} de Contratista exitosa."
        return
    } //save para grabar desde ajax

    /**
     * Acción llamada con ajax que permite eliminar un elemento
     * @render ERROR*[mensaje] cuando no se pudo eliminar correctamente, SUCCESS*[mensaje] cuando se eliminó correctamente
     */
    def delete_ajax() {
        if (params.id) {
            def contratistaInstance = Contratista.get(params.id)
            if (!contratistaInstance) {
                render "ERROR*No se encontró Contratista."
                return
            }
            try {
                contratistaInstance.delete(flush: true)
                render "SUCCESS*Eliminación de Contratista exitosa."
                return
            } catch (DataIntegrityViolationException e) {
                render "ERROR*Ha ocurrido un error al eliminar Contratista"
                return
            }
        } else {
            render "ERROR*No se encontró Contratista."
            return
        }
    } //delete para eliminar via ajax

    /**
     * Acción llamada con ajax que valida que no se duplique la propiedad mail
     * @render boolean que indica si se puede o no utilizar el valor recibido
     */
    def validar_unique_mail_ajax() {
        params.mail = params.mail.toString().trim()
        if (params.id) {
            def obj = Contratista.get(params.id)
            if (obj.mail.toLowerCase() == params.mail.toLowerCase()) {
                render true
                return
            } else {
                render Contratista.countByMailIlike(params.mail) == 0
                return
            }
        } else {
            render Contratista.countByMailIlike(params.mail) == 0
            return
        }
    }

}
