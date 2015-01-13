package vesta.hitos

import org.springframework.dao.DataIntegrityViolationException
import vesta.seguridad.Shield


/**
 * Controlador que muestra las pantallas de manejo de Hito
 */
class HitoController extends Shield {

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
            def c = Hito.createCriteria()
            list = c.list(params) {
                or {
                    /* TODO: cambiar aqui segun sea necesario */
                    
                    ilike("descripcion", "%" + params.search + "%")  
                    ilike("tipo", "%" + params.search + "%")  
                }
            }
        } else {
            list = Hito.list(params)
        }
        if (!all && params.offset.toInteger() > 0 && list.size() == 0) {
            params.offset = params.offset.toInteger() - 1
            list = getList(params, all)
        }
        return list
    }

    /**
     * Acción que muestra la lista de elementos
     * @return hitoInstanceList: la lista de elementos filtrados, hitoInstanceCount: la cantidad total de elementos (sin máximo)
     */
    def list() {
        def hitoInstanceList = getList(params, false)
        def hitoInstanceCount = getList(params, true).size()
        return [hitoInstanceList: hitoInstanceList, hitoInstanceCount: hitoInstanceCount]
    }

    /**
     * Acción llamada con ajax que muestra la información de un elemento particular
     * @return hitoInstance el objeto a mostrar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def show_ajax() {
        if(params.id) {
            def hitoInstance = Hito.get(params.id)
            if(!hitoInstance) {
                render "ERROR*No se encontró Hito."
                return
            }
            return [hitoInstance: hitoInstance]
        } else {
            render "ERROR*No se encontró Hito."
        }
    } //show para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que muestra un formulario para crear o modificar un elemento
     * @return hitoInstance el objeto a modificar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def form_ajax() {
        def hitoInstance = new Hito()
        if(params.id) {
            hitoInstance = Hito.get(params.id)
            if(!hitoInstance) {
                render "ERROR*No se encontró Hito."
                return
            }
        }
        hitoInstance.properties = params
        return [hitoInstance: hitoInstance]
    } //form para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que guarda la información de un elemento
     * @render ERROR*[mensaje] cuando no se pudo grabar correctamente, SUCCESS*[mensaje] cuando se grabó correctamente
     */
    def save_ajax() {
        def hitoInstance = new Hito()
        if(params.id) {
            hitoInstance = Hito.get(params.id)
            if(!hitoInstance) {
                render "ERROR*No se encontró Hito."
                return
            }
        }
        hitoInstance.properties = params
        if(!hitoInstance.save(flush: true)) {
            render "ERROR*Ha ocurrido un error al guardar Hito: " + renderErrors(bean: hitoInstance)
            return
        }
        render "SUCCESS*${params.id ? 'Actualización' : 'Creación'} de Hito exitosa."
        return
    } //save para grabar desde ajax

    /**
     * Acción llamada con ajax que permite eliminar un elemento
     * @render ERROR*[mensaje] cuando no se pudo eliminar correctamente, SUCCESS*[mensaje] cuando se eliminó correctamente
     */
    def delete_ajax() {
        if(params.id) {
            def hitoInstance = Hito.get(params.id)
            if (!hitoInstance) {
                render "ERROR*No se encontró Hito."
                return
            }
            try {
                hitoInstance.delete(flush: true)
                render "SUCCESS*Eliminación de Hito exitosa."
                return
            } catch (DataIntegrityViolationException e) {
                render "ERROR*Ha ocurrido un error al eliminar Hito"
                return
            }
        } else {
            render "ERROR*No se encontró Hito."
            return
        }
    } //delete para eliminar via ajax
    
}
