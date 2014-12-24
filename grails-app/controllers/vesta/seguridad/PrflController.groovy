package vesta.seguridad

import org.springframework.dao.DataIntegrityViolationException
import vesta.seguridad.Shield


/**
 * Controlador que muestra las pantallas de manejo de Prfl
 */
class PrflController extends Shield {

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
            def c = Prfl.createCriteria()
            list = c.list(params) {
                or {
                    /* TODO: cambiar aqui segun sea necesario */

                    ilike("codigo", "%" + params.search + "%")
                    ilike("descripcion", "%" + params.search + "%")
                    ilike("nombre", "%" + params.search + "%")
                    ilike("observaciones", "%" + params.search + "%")
                }
            }
        } else {
            list = Prfl.list(params)
        }
        if (!all && params.offset.toInteger() > 0 && list.size() == 0) {
            params.offset = params.offset.toInteger() - 1
            list = getList(params, all)
        }
        return list
    }

    /**
     * Acción que muestra la lista de elementos
     * @return prflInstanceList: la lista de elementos filtrados, prflInstanceCount: la cantidad total de elementos (sin máximo)
     */
    def list() {
        def prflInstanceList = getList(params, false)
        def prflInstanceCount = getList(params, true).size()
        return [prflInstanceList: prflInstanceList, prflInstanceCount: prflInstanceCount]
    }

    /**
     * Acción llamada con ajax que muestra la información de un elemento particular
     * @return prflInstance el objeto a mostrar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def show_ajax() {
        if (params.id) {
            def prflInstance = Prfl.get(params.id)
            if (!prflInstance) {
                render "ERROR*No se encontró Perfil."
                return
            }
            return [prflInstance: prflInstance]
        } else {
            render "ERROR*No se encontró Perfil."
        }
    } //show para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que muestra un formaulario para crear o modificar un elemento
     * @return prflInstance el objeto a modificar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def form_ajax() {
        def prflInstance = new Prfl()
        if (params.id) {
            prflInstance = Prfl.get(params.id)
            if (!prflInstance) {
                render "ERROR*No se encontró Perfil."
                return
            }
        }
        prflInstance.properties = params
        return [prflInstance: prflInstance]
    } //form para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que guarda la información de un elemento
     * @render ERROR*[mensaje] cuando no se pudo grabar correctamente, SUCCESS*[mensaje] cuando se grabó correctamente
     */
    def save_ajax() {
        def prflInstance = new Prfl()
        if (params.id) {
            prflInstance = Prfl.get(params.id)
            if (!prflInstance) {
                render "ERROR*No se encontró Perfil."
                return
            }
        }
        prflInstance.properties = params
        if (!prflInstance.save(flush: true)) {
            render "ERROR*Ha ocurrido un error al guardar Perfil: " + renderErrors(bean: prflInstance)
            return
        }
        render "SUCCESS*${params.id ? 'Actualización' : 'Creación'} de Perfil exitosa."
        return
    } //save para grabar desde ajax

    /**
     * Acción llamada con ajax que permite eliminar un elemento
     * @render ERROR*[mensaje] cuando no se pudo eliminar correctamente, SUCCESS*[mensaje] cuando se eliminó correctamente
     */
    def delete_ajax() {
        if (params.id) {
            def prflInstance = Prfl.get(params.id)
            if (!prflInstance) {
                render "ERROR*No se encontró Perfil."
                return
            }
            try {
                prflInstance.delete(flush: true)
                render "SUCCESS*Eliminación de Perfil exitosa."
                return
            } catch (DataIntegrityViolationException e) {
                render "ERROR*Ha ocurrido un error al eliminar Perfil"
                return
            }
        } else {
            render "ERROR*No se encontró Perfil."
            return
        }
    } //delete para eliminar via ajax

    /**
     * Acción llamada con ajax que valida que no se duplique la propiedad codigo
     * @render boolean que indica si se puede o no utilizar el valor recibido
     */
    def validar_unique_codigo_ajax() {
        params.codigo = params.codigo.toString().trim()
        if (params.id) {
            def obj = Prfl.get(params.id)
            if (obj.codigo.toLowerCase() == params.codigo.toLowerCase()) {
                render true
                return
            } else {
                render Prfl.countByCodigoIlike(params.codigo) == 0
                return
            }
        } else {
            render Prfl.countByCodigoIlike(params.codigo) == 0
            return
        }
    }
}
