package vesta.parametros

import org.springframework.dao.DataIntegrityViolationException
import vesta.seguridad.Shield


/**
 * Controlador que muestra las pantallas de manejo de TipoAprobacion
 */
class TipoAprobacionController extends Shield {

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
            def c = TipoAprobacion.createCriteria()
            list = c.list(params) {
                or {
                    /* TODO: cambiar aqui segun sea necesario */

                    ilike("codigo", "%" + params.search + "%")
                    ilike("descripcion", "%" + params.search + "%")
                }
            }
        } else {
            list = TipoAprobacion.list(params)
        }
        if (!all && params.offset.toInteger() > 0 && list.size() == 0) {
            params.offset = params.offset.toInteger() - 1
            list = getList(params, all)
        }
        return list
    }

    /**
     * Acción que muestra la lista de elementos
     * @return tipoAprobacionInstanceList: la lista de elementos filtrados, tipoAprobacionInstanceCount: la cantidad total de elementos (sin máximo)
     */
    def list() {
        def tipoAprobacionInstanceList = getList(params, false)
        def tipoAprobacionInstanceCount = getList(params, true).size()
        return [tipoAprobacionInstanceList: tipoAprobacionInstanceList, tipoAprobacionInstanceCount: tipoAprobacionInstanceCount]
    }

    /**
     * Acción llamada con ajax que muestra la información de un elemento particular
     * @return tipoAprobacionInstance el objeto a mostrar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def show_ajax() {
        if (params.id) {
            def tipoAprobacionInstance = TipoAprobacion.get(params.id)
            if (!tipoAprobacionInstance) {
                render "ERROR*No se encontró TipoAprobacion."
                return
            }
            return [tipoAprobacionInstance: tipoAprobacionInstance]
        } else {
            render "ERROR*No se encontró TipoAprobacion."
        }
    } //show para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que muestra un formaulario para crear o modificar un elemento
     * @return tipoAprobacionInstance el objeto a modificar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def form_ajax() {
        def tipoAprobacionInstance = new TipoAprobacion()
        if (params.id) {
            tipoAprobacionInstance = TipoAprobacion.get(params.id)
            if (!tipoAprobacionInstance) {
                render "ERROR*No se encontró TipoAprobacion."
                return
            }
        }
        tipoAprobacionInstance.properties = params
        return [tipoAprobacionInstance: tipoAprobacionInstance]
    } //form para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que guarda la información de un elemento
     * @render ERROR*[mensaje] cuando no se pudo grabar correctamente, SUCCESS*[mensaje] cuando se grabó correctamente
     */
    def save_ajax() {
        def tipoAprobacionInstance = new TipoAprobacion()
        if (params.id) {
            tipoAprobacionInstance = TipoAprobacion.get(params.id)
            if (!tipoAprobacionInstance) {
                render "ERROR*No se encontró TipoAprobacion."
                return
            }
        }
        tipoAprobacionInstance.properties = params
        if (!tipoAprobacionInstance.save(flush: true)) {
            render "ERROR*Ha ocurrido un error al guardar TipoAprobacion: " + renderErrors(bean: tipoAprobacionInstance)
            return
        }
        render "SUCCESS*${params.id ? 'Actualización' : 'Creación'} de TipoAprobacion exitosa."
        return
    } //save para grabar desde ajax

    /**
     * Acción llamada con ajax que permite eliminar un elemento
     * @render ERROR*[mensaje] cuando no se pudo eliminar correctamente, SUCCESS*[mensaje] cuando se eliminó correctamente
     */
    def delete_ajax() {
        if (params.id) {
            def tipoAprobacionInstance = TipoAprobacion.get(params.id)
            if (!tipoAprobacionInstance) {
                render "ERROR*No se encontró TipoAprobacion."
                return
            }
            try {
                tipoAprobacionInstance.delete(flush: true)
                render "SUCCESS*Eliminación de TipoAprobacion exitosa."
                return
            } catch (DataIntegrityViolationException e) {
                render "ERROR*Ha ocurrido un error al eliminar TipoAprobacion"
                return
            }
        } else {
            render "ERROR*No se encontró TipoAprobacion."
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
            def obj = TipoAprobacion.get(params.id)
            if (obj.codigo.toLowerCase() == params.codigo.toLowerCase()) {
                render true
                return
            } else {
                render TipoAprobacion.countByCodigoIlike(params.codigo) == 0
                return
            }
        } else {
            render TipoAprobacion.countByCodigoIlike(params.codigo) == 0
            return
        }
    }

}
