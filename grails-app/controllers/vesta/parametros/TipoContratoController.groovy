package vesta.parametros

import org.springframework.dao.DataIntegrityViolationException
import vesta.seguridad.Shield


/**
 * Controlador que muestra las pantallas de manejo de TipoContrato
 */
class TipoContratoController extends Shield {

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
            def c = TipoContrato.createCriteria()
            list = c.list(params) {
                or {
                    /* TODO: cambiar aqui segun sea necesario */

                    ilike("descripcion", "%" + params.search + "%")
                }
            }
        } else {
            list = TipoContrato.list(params)
        }
        if (!all && params.offset.toInteger() > 0 && list.size() == 0) {
            params.offset = params.offset.toInteger() - 1
            list = getList(params, all)
        }
        return list
    }

    /**
     * Acción que muestra la lista de elementos
     * @return tipoContratoInstanceList: la lista de elementos filtrados, tipoContratoInstanceCount: la cantidad total de elementos (sin máximo)
     */
    def list() {
        def tipoContratoInstanceList = getList(params, false)
        def tipoContratoInstanceCount = getList(params, true).size()
        return [tipoContratoInstanceList: tipoContratoInstanceList, tipoContratoInstanceCount: tipoContratoInstanceCount]
    }

    /**
     * Acción llamada con ajax que muestra la información de un elemento particular
     * @return tipoContratoInstance el objeto a mostrar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def show_ajax() {
        if (params.id) {
            def tipoContratoInstance = TipoContrato.get(params.id)
            if (!tipoContratoInstance) {
                render "ERROR*No se encontró TipoContrato."
                return
            }
            return [tipoContratoInstance: tipoContratoInstance]
        } else {
            render "ERROR*No se encontró TipoContrato."
        }
    } //show para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que muestra un formulario para crear o modificar un elemento
     * @return tipoContratoInstance el objeto a modificar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def form_ajax() {
        def tipoContratoInstance = new TipoContrato()
        if (params.id) {
            tipoContratoInstance = TipoContrato.get(params.id)
            if (!tipoContratoInstance) {
                render "ERROR*No se encontró TipoContrato."
                return
            }
        }
        tipoContratoInstance.properties = params
        return [tipoContratoInstance: tipoContratoInstance]
    } //form para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que guarda la información de un elemento
     * @render ERROR*[mensaje] cuando no se pudo grabar correctamente, SUCCESS*[mensaje] cuando se grabó correctamente
     */
    def save_ajax() {
        def tipoContratoInstance = new TipoContrato()
        if (params.id) {
            tipoContratoInstance = TipoContrato.get(params.id)
            if (!tipoContratoInstance) {
                render "ERROR*No se encontró TipoContrato."
                return
            }
        }
        tipoContratoInstance.properties = params
        if (!tipoContratoInstance.save(flush: true)) {
            render "ERROR*Ha ocurrido un error al guardar TipoContrato: " + renderErrors(bean: tipoContratoInstance)
            return
        }
        render "SUCCESS*${params.id ? 'Actualización' : 'Creación'} de TipoContrato exitosa."
        return
    } //save para grabar desde ajax

    /**
     * Acción llamada con ajax que permite eliminar un elemento
     * @render ERROR*[mensaje] cuando no se pudo eliminar correctamente, SUCCESS*[mensaje] cuando se eliminó correctamente
     */
    def delete_ajax() {
        if (params.id) {
            def tipoContratoInstance = TipoContrato.get(params.id)
            if (!tipoContratoInstance) {
                render "ERROR*No se encontró TipoContrato."
                return
            }
            try {
                tipoContratoInstance.delete(flush: true)
                render "SUCCESS*Eliminación de TipoContrato exitosa."
                return
            } catch (DataIntegrityViolationException e) {
                render "ERROR*Ha ocurrido un error al eliminar TipoContrato"
                return
            }
        } else {
            render "ERROR*No se encontró TipoContrato."
            return
        }
    } //delete para eliminar via ajax

}
