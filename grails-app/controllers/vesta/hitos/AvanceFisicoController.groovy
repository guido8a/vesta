package vesta.hitos

import org.springframework.dao.DataIntegrityViolationException
import vesta.seguridad.Shield


/**
 * Controlador que muestra las pantallas de manejo de AvanceFisico
 */
class AvanceFisicoController extends Shield {

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
            def c = AvanceFisico.createCriteria()
            list = c.list(params) {
                or {
                    /* TODO: cambiar aqui segun sea necesario */

                    ilike("observaciones", "%" + params.search + "%")
                }
            }
        } else {
            list = AvanceFisico.list(params)
        }
        if (!all && params.offset.toInteger() > 0 && list.size() == 0) {
            params.offset = params.offset.toInteger() - 1
            list = getList(params, all)
        }
        return list
    }

    /**
     * Acción que muestra la lista de elementos
     * @return avanceFisicoInstanceList: la lista de elementos filtrados, avanceFisicoInstanceCount: la cantidad total de elementos (sin máximo)
     */
    def list() {
        def avanceFisicoInstanceList = getList(params, false)
        def avanceFisicoInstanceCount = getList(params, true).size()
        return [avanceFisicoInstanceList: avanceFisicoInstanceList, avanceFisicoInstanceCount: avanceFisicoInstanceCount]
    }

    /**
     * Acción llamada con ajax que muestra la información de un elemento particular
     * @return avanceFisicoInstance el objeto a mostrar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def show_ajax() {
        if (params.id) {
            def avanceFisicoInstance = AvanceFisico.get(params.id)
            if (!avanceFisicoInstance) {
                render "ERROR*No se encontró AvanceFisico."
                return
            }
            return [avanceFisicoInstance: avanceFisicoInstance]
        } else {
            render "ERROR*No se encontró AvanceFisico."
        }
    } //show para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que muestra un formaulario para crear o modificar un elemento
     * @return avanceFisicoInstance el objeto a modificar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def form_ajax() {
        def avanceFisicoInstance = new AvanceFisico()
        if (params.id) {
            avanceFisicoInstance = AvanceFisico.get(params.id)
            if (!avanceFisicoInstance) {
                render "ERROR*No se encontró AvanceFisico."
                return
            }
        }
        avanceFisicoInstance.properties = params
        return [avanceFisicoInstance: avanceFisicoInstance]
    } //form para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que guarda la información de un elemento
     * @render ERROR*[mensaje] cuando no se pudo grabar correctamente, SUCCESS*[mensaje] cuando se grabó correctamente
     */
    def save_ajax() {
        def avanceFisicoInstance = new AvanceFisico()
        if (params.id) {
            avanceFisicoInstance = AvanceFisico.get(params.id)
            if (!avanceFisicoInstance) {
                render "ERROR*No se encontró AvanceFisico."
                return
            }
        }
        avanceFisicoInstance.properties = params
        if (!avanceFisicoInstance.save(flush: true)) {
            render "ERROR*Ha ocurrido un error al guardar AvanceFisico: " + renderErrors(bean: avanceFisicoInstance)
            return
        }
        render "SUCCESS*${params.id ? 'Actualización' : 'Creación'} de AvanceFisico exitosa."
        return
    } //save para grabar desde ajax

    /**
     * Acción llamada con ajax que permite eliminar un elemento
     * @render ERROR*[mensaje] cuando no se pudo eliminar correctamente, SUCCESS*[mensaje] cuando se eliminó correctamente
     */
    def delete_ajax() {
        if (params.id) {
            def avanceFisicoInstance = AvanceFisico.get(params.id)
            if (!avanceFisicoInstance) {
                render "ERROR*No se encontró AvanceFisico."
                return
            }
            try {
                avanceFisicoInstance.delete(flush: true)
                render "SUCCESS*Eliminación de AvanceFisico exitosa."
                return
            } catch (DataIntegrityViolationException e) {
                render "ERROR*Ha ocurrido un error al eliminar AvanceFisico"
                return
            }
        } else {
            render "ERROR*No se encontró AvanceFisico."
            return
        }
    } //delete para eliminar via ajax

}
