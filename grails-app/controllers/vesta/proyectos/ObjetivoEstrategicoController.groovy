package vesta.proyectos

import org.springframework.dao.DataIntegrityViolationException
import vesta.seguridad.Shield


/**
 * Controlador que muestra las pantallas de manejo de ObjetivoEstrategico
 */
class ObjetivoEstrategicoController extends Shield {

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
            def c = ObjetivoEstrategico.createCriteria()
            list = c.list(params) {
                or {
                    /* TODO: cambiar aqui segun sea necesario */

                    ilike("institucion", "%" + params.search + "%")
                    ilike("meta", "%" + params.search + "%")
                    ilike("objetivo", "%" + params.search + "%")
                    ilike("politica", "%" + params.search + "%")
                }
            }
        } else {
            list = ObjetivoEstrategico.list(params)
        }
        if (!all && params.offset.toInteger() > 0 && list.size() == 0) {
            params.offset = params.offset.toInteger() - 1
            list = getList(params, all)
        }
        return list
    }

    /**
     * Acción que muestra la lista de elementos
     * @return objetivoEstrategicoInstanceList: la lista de elementos filtrados, objetivoEstrategicoInstanceCount: la cantidad total de elementos (sin máximo)
     */
    def list() {
        def objetivoEstrategicoInstanceList = getList(params, false)
        def objetivoEstrategicoInstanceCount = getList(params, true).size()
        return [objetivoEstrategicoInstanceList: objetivoEstrategicoInstanceList, objetivoEstrategicoInstanceCount: objetivoEstrategicoInstanceCount]
    }

    /**
     * Acción llamada con ajax que muestra la información de un elemento particular
     * @return objetivoEstrategicoInstance el objeto a mostrar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def show_ajax() {
        if (params.id) {
            def objetivoEstrategicoInstance = ObjetivoEstrategico.get(params.id)
            if (!objetivoEstrategicoInstance) {
                render "ERROR*No se encontró ObjetivoEstrategico."
                return
            }
            return [objetivoEstrategicoInstance: objetivoEstrategicoInstance]
        } else {
            render "ERROR*No se encontró ObjetivoEstrategico."
        }
    } //show para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que muestra un formaulario para crear o modificar un elemento
     * @return objetivoEstrategicoInstance el objeto a modificar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def form_ajax() {
        def objetivoEstrategicoInstance = new ObjetivoEstrategico()
        if (params.id) {
            objetivoEstrategicoInstance = ObjetivoEstrategico.get(params.id)
            if (!objetivoEstrategicoInstance) {
                render "ERROR*No se encontró ObjetivoEstrategico."
                return
            }
        }
        objetivoEstrategicoInstance.properties = params
        return [objetivoEstrategicoInstance: objetivoEstrategicoInstance]
    } //form para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que guarda la información de un elemento
     * @render ERROR*[mensaje] cuando no se pudo grabar correctamente, SUCCESS*[mensaje] cuando se grabó correctamente
     */
    def save_ajax() {
        def objetivoEstrategicoInstance = new ObjetivoEstrategico()
        if (params.id) {
            objetivoEstrategicoInstance = ObjetivoEstrategico.get(params.id)
            if (!objetivoEstrategicoInstance) {
                render "ERROR*No se encontró ObjetivoEstrategico."
                return
            }
        }
        objetivoEstrategicoInstance.properties = params
        if (!objetivoEstrategicoInstance.save(flush: true)) {
            render "ERROR*Ha ocurrido un error al guardar ObjetivoEstrategico: " + renderErrors(bean: objetivoEstrategicoInstance)
            return
        }
        render "SUCCESS*${params.id ? 'Actualización' : 'Creación'} de ObjetivoEstrategico exitosa."
        return
    } //save para grabar desde ajax

    /**
     * Acción llamada con ajax que permite eliminar un elemento
     * @render ERROR*[mensaje] cuando no se pudo eliminar correctamente, SUCCESS*[mensaje] cuando se eliminó correctamente
     */
    def delete_ajax() {
        if (params.id) {
            def objetivoEstrategicoInstance = ObjetivoEstrategico.get(params.id)
            if (!objetivoEstrategicoInstance) {
                render "ERROR*No se encontró ObjetivoEstrategico."
                return
            }
            try {
                objetivoEstrategicoInstance.delete(flush: true)
                render "SUCCESS*Eliminación de ObjetivoEstrategico exitosa."
                return
            } catch (DataIntegrityViolationException e) {
                render "ERROR*Ha ocurrido un error al eliminar ObjetivoEstrategico"
                return
            }
        } else {
            render "ERROR*No se encontró ObjetivoEstrategico."
            return
        }
    } //delete para eliminar via ajax

}
