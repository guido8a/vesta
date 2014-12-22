package vesta.proyectos

import org.springframework.dao.DataIntegrityViolationException
import vesta.seguridad.Shield


/**
 * Controlador que muestra las pantallas de manejo de PoliticaAplicaProyecto
 */
class PoliticaAplicaProyectoController extends Shield {

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
            def c = PoliticaAplicaProyecto.createCriteria()
            list = c.list(params) {
                or {
                    /* TODO: cambiar aqui segun sea necesario */

                    ilike("descripcion", "%" + params.search + "%")
                }
            }
        } else {
            list = PoliticaAplicaProyecto.list(params)
        }
        if (!all && params.offset.toInteger() > 0 && list.size() == 0) {
            params.offset = params.offset.toInteger() - 1
            list = getList(params, all)
        }
        return list
    }

    /**
     * Acción que muestra la lista de elementos
     * @return politicaAplicaProyectoInstanceList: la lista de elementos filtrados, politicaAplicaProyectoInstanceCount: la cantidad total de elementos (sin máximo)
     */
    def list() {
        def politicaAplicaProyectoInstanceList = getList(params, false)
        def politicaAplicaProyectoInstanceCount = getList(params, true).size()
        return [politicaAplicaProyectoInstanceList: politicaAplicaProyectoInstanceList, politicaAplicaProyectoInstanceCount: politicaAplicaProyectoInstanceCount]
    }

    /**
     * Acción llamada con ajax que muestra la información de un elemento particular
     * @return politicaAplicaProyectoInstance el objeto a mostrar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def show_ajax() {
        if (params.id) {
            def politicaAplicaProyectoInstance = PoliticaAplicaProyecto.get(params.id)
            if (!politicaAplicaProyectoInstance) {
                render "ERROR*No se encontró PoliticaAplicaProyecto."
                return
            }
            return [politicaAplicaProyectoInstance: politicaAplicaProyectoInstance]
        } else {
            render "ERROR*No se encontró PoliticaAplicaProyecto."
        }
    } //show para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que muestra un formaulario para crear o modificar un elemento
     * @return politicaAplicaProyectoInstance el objeto a modificar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def form_ajax() {
        def politicaAplicaProyectoInstance = new PoliticaAplicaProyecto()
        if (params.id) {
            politicaAplicaProyectoInstance = PoliticaAplicaProyecto.get(params.id)
            if (!politicaAplicaProyectoInstance) {
                render "ERROR*No se encontró PoliticaAplicaProyecto."
                return
            }
        }
        politicaAplicaProyectoInstance.properties = params
        return [politicaAplicaProyectoInstance: politicaAplicaProyectoInstance]
    } //form para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que guarda la información de un elemento
     * @render ERROR*[mensaje] cuando no se pudo grabar correctamente, SUCCESS*[mensaje] cuando se grabó correctamente
     */
    def save_ajax() {
        def politicaAplicaProyectoInstance = new PoliticaAplicaProyecto()
        if (params.id) {
            politicaAplicaProyectoInstance = PoliticaAplicaProyecto.get(params.id)
            if (!politicaAplicaProyectoInstance) {
                render "ERROR*No se encontró PoliticaAplicaProyecto."
                return
            }
        }
        politicaAplicaProyectoInstance.properties = params
        if (!politicaAplicaProyectoInstance.save(flush: true)) {
            render "ERROR*Ha ocurrido un error al guardar PoliticaAplicaProyecto: " + renderErrors(bean: politicaAplicaProyectoInstance)
            return
        }
        render "SUCCESS*${params.id ? 'Actualización' : 'Creación'} de PoliticaAplicaProyecto exitosa."
        return
    } //save para grabar desde ajax

    /**
     * Acción llamada con ajax que permite eliminar un elemento
     * @render ERROR*[mensaje] cuando no se pudo eliminar correctamente, SUCCESS*[mensaje] cuando se eliminó correctamente
     */
    def delete_ajax() {
        if (params.id) {
            def politicaAplicaProyectoInstance = PoliticaAplicaProyecto.get(params.id)
            if (!politicaAplicaProyectoInstance) {
                render "ERROR*No se encontró PoliticaAplicaProyecto."
                return
            }
            try {
                politicaAplicaProyectoInstance.delete(flush: true)
                render "SUCCESS*Eliminación de PoliticaAplicaProyecto exitosa."
                return
            } catch (DataIntegrityViolationException e) {
                render "ERROR*Ha ocurrido un error al eliminar PoliticaAplicaProyecto"
                return
            }
        } else {
            render "ERROR*No se encontró PoliticaAplicaProyecto."
            return
        }
    } //delete para eliminar via ajax

}
