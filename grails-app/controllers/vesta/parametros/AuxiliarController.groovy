package vesta.parametros

import org.springframework.dao.DataIntegrityViolationException
import vesta.seguridad.Shield


/**
 * Controlador que muestra las pantallas de manejo de Auxiliar
 */
class AuxiliarController extends Shield {

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
            def c = Auxiliar.createCriteria()
            list = c.list(params) {
                or {
                    /* TODO: cambiar aqui segun sea necesario */
                    
                }
            }
        } else {
            list = Auxiliar.list(params)
        }
        if (!all && params.offset.toInteger() > 0 && list.size() == 0) {
            params.offset = params.offset.toInteger() - 1
            list = getList(params, all)
        }
        return list
    }

    /**
     * Acción que muestra la lista de elementos
     * @return auxiliarInstanceList: la lista de elementos filtrados, auxiliarInstanceCount: la cantidad total de elementos (sin máximo)
     */
    def list() {
        def auxiliarInstanceList = getList(params, false)
        def auxiliarInstanceCount = getList(params, true).size()
        return [auxiliarInstanceList: auxiliarInstanceList, auxiliarInstanceCount: auxiliarInstanceCount]
    }

    /**
     * Acción llamada con ajax que muestra la información de un elemento particular
     * @return auxiliarInstance el objeto a mostrar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def show_ajax() {
        if(params.id) {
            def auxiliarInstance = Auxiliar.get(params.id)
            if(!auxiliarInstance) {
                render "ERROR*No se encontró Auxiliar."
                return
            }
            return [auxiliarInstance: auxiliarInstance]
        } else {
            render "ERROR*No se encontró Auxiliar."
        }
    } //show para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que muestra un formulario para crear o modificar un elemento
     * @return auxiliarInstance el objeto a modificar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def form_ajax() {
        def auxiliarInstance = new Auxiliar()
        if(params.id) {
            auxiliarInstance = Auxiliar.get(params.id)
            if(!auxiliarInstance) {
                render "ERROR*No se encontró Auxiliar."
                return
            }
        }
        auxiliarInstance.properties = params
        return [auxiliarInstance: auxiliarInstance]
    } //form para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que guarda la información de un elemento
     * @render ERROR*[mensaje] cuando no se pudo grabar correctamente, SUCCESS*[mensaje] cuando se grabó correctamente
     */
    def save_ajax() {
        def auxiliarInstance = new Auxiliar()
        if(params.id) {
            auxiliarInstance = Auxiliar.get(params.id)
            if(!auxiliarInstance) {
                render "ERROR*No se encontró Auxiliar."
                return
            }
        }
        auxiliarInstance.properties = params
        if(!auxiliarInstance.save(flush: true)) {
            render "ERROR*Ha ocurrido un error al guardar Auxiliar: " + renderErrors(bean: auxiliarInstance)
            return
        }
        render "SUCCESS*${params.id ? 'Actualización' : 'Creación'} de Auxiliar exitosa."
        return
    } //save para grabar desde ajax

    /**
     * Acción llamada con ajax que permite eliminar un elemento
     * @render ERROR*[mensaje] cuando no se pudo eliminar correctamente, SUCCESS*[mensaje] cuando se eliminó correctamente
     */
    def delete_ajax() {
        if(params.id) {
            def auxiliarInstance = Auxiliar.get(params.id)
            if (!auxiliarInstance) {
                render "ERROR*No se encontró Auxiliar."
                return
            }
            try {
                auxiliarInstance.delete(flush: true)
                render "SUCCESS*Eliminación de Auxiliar exitosa."
                return
            } catch (DataIntegrityViolationException e) {
                render "ERROR*Ha ocurrido un error al eliminar Auxiliar"
                return
            }
        } else {
            render "ERROR*No se encontró Auxiliar."
            return
        }
    } //delete para eliminar via ajax
    
}
