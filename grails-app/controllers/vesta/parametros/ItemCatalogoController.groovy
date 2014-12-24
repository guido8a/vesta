package vesta.parametros

import org.springframework.dao.DataIntegrityViolationException
import vesta.seguridad.Shield


/**
 * Controlador que muestra las pantallas de manejo de ItemCatalogo
 */
class ItemCatalogoController extends Shield {

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
            def c = ItemCatalogo.createCriteria()
            list = c.list(params) {
                or {
                    /* TODO: cambiar aqui segun sea necesario */

                    ilike("codigo", "%" + params.search + "%")
                    ilike("descripcion", "%" + params.search + "%")
                    ilike("nombre", "%" + params.search + "%")
                }
            }
        } else {
            list = ItemCatalogo.list(params)
        }
        if (!all && params.offset.toInteger() > 0 && list.size() == 0) {
            params.offset = params.offset.toInteger() - 1
            list = getList(params, all)
        }
        return list
    }

    /**
     * Acción que muestra la lista de elementos
     * @return itemCatalogoInstanceList: la lista de elementos filtrados, itemCatalogoInstanceCount: la cantidad total de elementos (sin máximo)
     */
    def list() {
        def itemCatalogoInstanceList = getList(params, false)
        def itemCatalogoInstanceCount = getList(params, true).size()
        return [itemCatalogoInstanceList: itemCatalogoInstanceList, itemCatalogoInstanceCount: itemCatalogoInstanceCount]
    }

    /**
     * Acción llamada con ajax que muestra la información de un elemento particular
     * @return itemCatalogoInstance el objeto a mostrar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def show_ajax() {
        if (params.id) {
            def itemCatalogoInstance = ItemCatalogo.get(params.id)
            if (!itemCatalogoInstance) {
                render "ERROR*No se encontró ItemCatalogo."
                return
            }
            return [itemCatalogoInstance: itemCatalogoInstance]
        } else {
            render "ERROR*No se encontró ItemCatalogo."
        }
    } //show para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que muestra un formaulario para crear o modificar un elemento
     * @return itemCatalogoInstance el objeto a modificar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def form_ajax() {
        def itemCatalogoInstance = new ItemCatalogo()
        if (params.id) {
            itemCatalogoInstance = ItemCatalogo.get(params.id)
            if (!itemCatalogoInstance) {
                render "ERROR*No se encontró ItemCatalogo."
                return
            }
        }
        itemCatalogoInstance.properties = params
        return [itemCatalogoInstance: itemCatalogoInstance]
    } //form para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que guarda la información de un elemento
     * @render ERROR*[mensaje] cuando no se pudo grabar correctamente, SUCCESS*[mensaje] cuando se grabó correctamente
     */
    def save_ajax() {
        println("params save " + params)
        def itemCatalogoInstance = new ItemCatalogo()
        if (params.id) {
            itemCatalogoInstance = ItemCatalogo.get(params.id)
            if (!itemCatalogoInstance) {
                render "ERROR*No se encontró ItemCatalogo."
                return
            }
        }
        itemCatalogoInstance.properties = params
        if (!itemCatalogoInstance.save(flush: true)) {
            render "ERROR*Ha ocurrido un error al guardar ItemCatalogo: " + renderErrors(bean: itemCatalogoInstance)
            return
        }
        render "SUCCESS*${params.id ? 'Actualización' : 'Creación'} de ItemCatalogo exitosa."
        return
    } //save para grabar desde ajax

    /**
     * Acción llamada con ajax que permite eliminar un elemento
     * @render ERROR*[mensaje] cuando no se pudo eliminar correctamente, SUCCESS*[mensaje] cuando se eliminó correctamente
     */
    def delete_ajax() {
        if (params.id) {
            def itemCatalogoInstance = ItemCatalogo.get(params.id)
            if (!itemCatalogoInstance) {
                render "ERROR*No se encontró ItemCatalogo."
                return
            }
            try {
                itemCatalogoInstance.delete(flush: true)
                render "SUCCESS*Eliminación de ItemCatalogo exitosa."
                return
            } catch (DataIntegrityViolationException e) {
                render "ERROR*Ha ocurrido un error al eliminar ItemCatalogo"
                return
            }
        } else {
            render "ERROR*No se encontró ItemCatalogo."
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
            def obj = ItemCatalogo.get(params.id)
            if (obj.codigo.toLowerCase() == params.codigo.toLowerCase()) {
                render true
                return
            } else {
                render ItemCatalogo.countByCodigoIlike(params.codigo) == 0
                return
            }
        } else {
            render ItemCatalogo.countByCodigoIlike(params.codigo) == 0
            return
        }
    }

    /**
     * Acción llamada con ajax para borrar un item de un catálogo
     * @render ERROR*[mensaje] cuando no se pudo eliminar correctamente, SUCCESS*[mensaje] cuando se eliminó correctamente
     */

    def borrarItem () {
        if(params.id){
            def itemInstance = ItemCatalogo.get(params.id)
            if(!itemInstance){
                render "ERROR*No se encontró el Item."
                return
            }
            try{
               itemInstance.delete(flush: true)
               render "SUCCESS*Eliminación de Item exitosa."
                return
            } catch (DataIntegrityViolationException e){
                render "ERROR*Ha ocurrido un error al eliminar el Item"
                return
            }
        }else{
            render "ERROR*No se encontró el Item."
            return
        }
    }

}
