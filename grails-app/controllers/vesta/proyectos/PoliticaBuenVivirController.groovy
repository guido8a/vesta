package vesta.proyectos

import org.springframework.dao.DataIntegrityViolationException
import vesta.seguridad.Shield


/**
 * Controlador que muestra las pantallas de manejo de PoliticaBuenVivir
 */
class PoliticaBuenVivirController extends Shield {

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
            def c = PoliticaBuenVivir.createCriteria()
            list = c.list(params) {
                or {
                    /* TODO: cambiar aqui segun sea necesario */

                    ilike("descripcion", "%" + params.search + "%")
                }
            }
        } else {
            list = PoliticaBuenVivir.list(params)
        }
        if (!all && params.offset.toInteger() > 0 && list.size() == 0) {
            params.offset = params.offset.toInteger() - 1
            list = getList(params, all)
        }
        return list
    }

    /**
     * Acción que muestra la lista de elementos
     * @return politicaBuenVivirInstanceList: la lista de elementos filtrados, politicaBuenVivirInstanceCount: la cantidad total de elementos (sin máximo)
     */
    def list() {
        def politicaBuenVivirInstanceList = getList(params, false)
        def politicaBuenVivirInstanceCount = getList(params, true).size()
        return [politicaBuenVivirInstanceList: politicaBuenVivirInstanceList, politicaBuenVivirInstanceCount: politicaBuenVivirInstanceCount]
    }

    /**
     * Acción llamada con ajax que muestra la información de un elemento particular
     * @return politicaBuenVivirInstance el objeto a mostrar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def show_ajax() {
        if (params.id) {
            def politicaBuenVivirInstance = PoliticaBuenVivir.get(params.id)
            if (!politicaBuenVivirInstance) {
                render "ERROR*No se encontró PoliticaBuenVivir."
                return
            }
            return [politicaBuenVivirInstance: politicaBuenVivirInstance]
        } else {
            render "ERROR*No se encontró PoliticaBuenVivir."
        }
    } //show para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que muestra un formaulario para crear o modificar un elemento
     * @return politicaBuenVivirInstance el objeto a modificar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def form_ajax() {
        def politicaBuenVivirInstance = new PoliticaBuenVivir()
        if (params.id) {
            politicaBuenVivirInstance = PoliticaBuenVivir.get(params.id)
            if (!politicaBuenVivirInstance) {
                render "ERROR*No se encontró PoliticaBuenVivir."
                return
            }
        }
        politicaBuenVivirInstance.properties = params
        return [politicaBuenVivirInstance: politicaBuenVivirInstance]
    } //form para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que guarda la información de un elemento
     * @render ERROR*[mensaje] cuando no se pudo grabar correctamente, SUCCESS*[mensaje] cuando se grabó correctamente
     */
    def save_ajax() {
        def politicaBuenVivirInstance = new PoliticaBuenVivir()
        if (params.id) {
            politicaBuenVivirInstance = PoliticaBuenVivir.get(params.id)
            if (!politicaBuenVivirInstance) {
                render "ERROR*No se encontró PoliticaBuenVivir."
                return
            }
        }
        politicaBuenVivirInstance.properties = params
        if (!politicaBuenVivirInstance.save(flush: true)) {
            render "ERROR*Ha ocurrido un error al guardar PoliticaBuenVivir: " + renderErrors(bean: politicaBuenVivirInstance)
            return
        }
        render "SUCCESS*${params.id ? 'Actualización' : 'Creación'} de PoliticaBuenVivir exitosa."
        return
    } //save para grabar desde ajax

    /**
     * Acción llamada con ajax que permite eliminar un elemento
     * @render ERROR*[mensaje] cuando no se pudo eliminar correctamente, SUCCESS*[mensaje] cuando se eliminó correctamente
     */
    def delete_ajax() {
        if (params.id) {
            def politicaBuenVivirInstance = PoliticaBuenVivir.get(params.id)
            if (!politicaBuenVivirInstance) {
                render "ERROR*No se encontró PoliticaBuenVivir."
                return
            }
            try {
                politicaBuenVivirInstance.delete(flush: true)
                render "SUCCESS*Eliminación de PoliticaBuenVivir exitosa."
                return
            } catch (DataIntegrityViolationException e) {
                render "ERROR*Ha ocurrido un error al eliminar PoliticaBuenVivir"
                return
            }
        } else {
            render "ERROR*No se encontró PoliticaBuenVivir."
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
            def obj = PoliticaBuenVivir.get(params.id)
            if (obj.codigo.toLowerCase() == params.codigo.toLowerCase()) {
                render true
                return
            } else {
                render PoliticaBuenVivir.countByCodigoIlike(params.codigo) == 0
                return
            }
        } else {
            render PoliticaBuenVivir.countByCodigoIlike(params.codigo) == 0
            return
        }
    }

}
