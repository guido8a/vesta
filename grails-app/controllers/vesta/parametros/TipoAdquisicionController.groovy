package vesta.parametros

import org.springframework.dao.DataIntegrityViolationException
import vesta.seguridad.Shield


/**
 * Controlador que muestra las pantallas de manejo de TipoAdquisicion
 */
class TipoAdquisicionController extends Shield {

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
            def c = TipoAdquisicion.createCriteria()
            list = c.list(params) {
                or {
                    /* TODO: cambiar aqui segun sea necesario */

                    ilike("descripcion", "%" + params.search + "%")
                }
            }
        } else {
            list = TipoAdquisicion.list(params)
        }
        if (!all && params.offset.toInteger() > 0 && list.size() == 0) {
            params.offset = params.offset.toInteger() - 1
            list = getList(params, all)
        }
        return list
    }

    /**
     * Acción que muestra la lista de elementos
     * @return tipoAdquisicionInstanceList: la lista de elementos filtrados, tipoAdquisicionInstanceCount: la cantidad total de elementos (sin máximo)
     */
    def list() {
        def tipoAdquisicionInstanceList = getList(params, false)
        def tipoAdquisicionInstanceCount = getList(params, true).size()
        return [tipoAdquisicionInstanceList: tipoAdquisicionInstanceList, tipoAdquisicionInstanceCount: tipoAdquisicionInstanceCount]
    }

    /**
     * Acción llamada con ajax que muestra la información de un elemento particular
     * @return tipoAdquisicionInstance el objeto a mostrar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def show_ajax() {
        if (params.id) {
            def tipoAdquisicionInstance = TipoAdquisicion.get(params.id)
            if (!tipoAdquisicionInstance) {
                render "ERROR*No se encontró TipoAdquisicion."
                return
            }
            return [tipoAdquisicionInstance: tipoAdquisicionInstance]
        } else {
            render "ERROR*No se encontró TipoAdquisicion."
        }
    } //show para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que muestra un formaulario para crear o modificar un elemento
     * @return tipoAdquisicionInstance el objeto a modificar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def form_ajax() {
        def tipoAdquisicionInstance = new TipoAdquisicion()
        if (params.id) {
            tipoAdquisicionInstance = TipoAdquisicion.get(params.id)
            if (!tipoAdquisicionInstance) {
                render "ERROR*No se encontró TipoAdquisicion."
                return
            }
        }
        tipoAdquisicionInstance.properties = params
        return [tipoAdquisicionInstance: tipoAdquisicionInstance]
    } //form para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que guarda la información de un elemento
     * @render ERROR*[mensaje] cuando no se pudo grabar correctamente, SUCCESS*[mensaje] cuando se grabó correctamente
     */
    def save_ajax() {
        def tipoAdquisicionInstance = new TipoAdquisicion()
        if (params.id) {
            tipoAdquisicionInstance = TipoAdquisicion.get(params.id)
            if (!tipoAdquisicionInstance) {
                render "ERROR*No se encontró TipoAdquisicion."
                return
            }
        }
        tipoAdquisicionInstance.properties = params
        if (!tipoAdquisicionInstance.save(flush: true)) {
            render "ERROR*Ha ocurrido un error al guardar TipoAdquisicion: " + renderErrors(bean: tipoAdquisicionInstance)
            return
        }
        render "SUCCESS*${params.id ? 'Actualización' : 'Creación'} de TipoAdquisicion exitosa."
        return
    } //save para grabar desde ajax

    /**
     * Acción llamada con ajax que permite eliminar un elemento
     * @render ERROR*[mensaje] cuando no se pudo eliminar correctamente, SUCCESS*[mensaje] cuando se eliminó correctamente
     */
    def delete_ajax() {
        if (params.id) {
            def tipoAdquisicionInstance = TipoAdquisicion.get(params.id)
            if (!tipoAdquisicionInstance) {
                render "ERROR*No se encontró TipoAdquisicion."
                return
            }
            try {
                tipoAdquisicionInstance.delete(flush: true)
                render "SUCCESS*Eliminación de TipoAdquisicion exitosa."
                return
            } catch (DataIntegrityViolationException e) {
                render "ERROR*Ha ocurrido un error al eliminar TipoAdquisicion"
                return
            }
        } else {
            render "ERROR*No se encontró TipoAdquisicion."
            return
        }
    } //delete para eliminar via ajax

}
