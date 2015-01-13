package vesta.proyectos

import org.springframework.dao.DataIntegrityViolationException
import vesta.seguridad.Shield


/**
 * Controlador que muestra las pantallas de manejo de EntidadesProyecto
 */
class EntidadesProyectoController extends Shield {

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
            def c = EntidadesProyecto.createCriteria()
            list = c.list(params) {
                or {
                    /* TODO: cambiar aqui segun sea necesario */

                    ilike("rol", "%" + params.search + "%")
                }
            }
        } else {
            list = EntidadesProyecto.list(params)
        }
        if (!all && params.offset.toInteger() > 0 && list.size() == 0) {
            params.offset = params.offset.toInteger() - 1
            list = getList(params, all)
        }
        return list
    }

    /**
     * Acción que muestra la lista de elementos
     * @return entidadesProyectoInstanceList: la lista de elementos filtrados, entidadesProyectoInstanceCount: la cantidad total de elementos (sin máximo)
     */
    def list() {
        def entidadesProyectoInstanceList = getList(params, false)
        def entidadesProyectoInstanceCount = getList(params, true).size()
        return [entidadesProyectoInstanceList: entidadesProyectoInstanceList, entidadesProyectoInstanceCount: entidadesProyectoInstanceCount]
    }

    /**
     * Acción llamada con ajax que muestra la información de un elemento particular
     * @return entidadesProyectoInstance el objeto a mostrar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def show_ajax() {
        if (params.id) {
            def entidadesProyectoInstance = EntidadesProyecto.get(params.id)
            if (!entidadesProyectoInstance) {
                render "ERROR*No se encontró EntidadesProyecto."
                return
            }
            return [entidadesProyectoInstance: entidadesProyectoInstance]
        } else {
            render "ERROR*No se encontró EntidadesProyecto."
        }
    } //show para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que muestra un formulario para crear o modificar un elemento
     * @return entidadesProyectoInstance el objeto a modificar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def form_ajax() {
        def entidadesProyectoInstance = new EntidadesProyecto()
        if (params.id) {
            entidadesProyectoInstance = EntidadesProyecto.get(params.id)
            if (!entidadesProyectoInstance) {
                render "ERROR*No se encontró EntidadesProyecto."
                return
            }
        }
        entidadesProyectoInstance.properties = params
        return [entidadesProyectoInstance: entidadesProyectoInstance]
    } //form para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que guarda la información de un elemento
     * @render ERROR*[mensaje] cuando no se pudo grabar correctamente, SUCCESS*[mensaje] cuando se grabó correctamente
     */
    def save_ajax() {
        def entidadesProyectoInstance = new EntidadesProyecto()
        if (params.id) {
            entidadesProyectoInstance = EntidadesProyecto.get(params.id)
            if (!entidadesProyectoInstance) {
                render "ERROR*No se encontró EntidadesProyecto."
                return
            }
        }
        entidadesProyectoInstance.properties = params
        if (!entidadesProyectoInstance.save(flush: true)) {
            render "ERROR*Ha ocurrido un error al guardar EntidadesProyecto: " + renderErrors(bean: entidadesProyectoInstance)
            return
        }
        render "SUCCESS*${params.id ? 'Actualización' : 'Creación'} de EntidadesProyecto exitosa."
        return
    } //save para grabar desde ajax

    /**
     * Acción llamada con ajax que permite eliminar un elemento
     * @render ERROR*[mensaje] cuando no se pudo eliminar correctamente, SUCCESS*[mensaje] cuando se eliminó correctamente
     */
    def delete_ajax() {
        if (params.id) {
            def entidadesProyectoInstance = EntidadesProyecto.get(params.id)
            if (!entidadesProyectoInstance) {
                render "ERROR*No se encontró EntidadesProyecto."
                return
            }
            try {
                entidadesProyectoInstance.delete(flush: true)
                render "SUCCESS*Eliminación de EntidadesProyecto exitosa."
                return
            } catch (DataIntegrityViolationException e) {
                render "ERROR*Ha ocurrido un error al eliminar EntidadesProyecto"
                return
            }
        } else {
            render "ERROR*No se encontró EntidadesProyecto."
            return
        }
    } //delete para eliminar via ajax

}
