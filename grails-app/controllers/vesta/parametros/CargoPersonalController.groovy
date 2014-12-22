package vesta.parametros

import org.springframework.dao.DataIntegrityViolationException
import vesta.seguridad.Shield


/**
 * Controlador que muestra las pantallas de manejo de CargoPersonal
 */
class CargoPersonalController extends Shield {

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
            def c = CargoPersonal.createCriteria()
            list = c.list(params) {
                or {
                    /* TODO: cambiar aqui segun sea necesario */

                    ilike("codigo", "%" + params.search + "%")
                    ilike("descripcion", "%" + params.search + "%")
                }
            }
        } else {
            list = CargoPersonal.list(params)
        }
        if (!all && params.offset.toInteger() > 0 && list.size() == 0) {
            params.offset = params.offset.toInteger() - 1
            list = getList(params, all)
        }
        return list
    }

    /**
     * Acción que muestra la lista de elementos
     * @return cargoPersonalInstanceList: la lista de elementos filtrados, cargoPersonalInstanceCount: la cantidad total de elementos (sin máximo)
     */
    def list() {
        def cargoPersonalInstanceList = getList(params, false)
        def cargoPersonalInstanceCount = getList(params, true).size()
        return [cargoPersonalInstanceList: cargoPersonalInstanceList, cargoPersonalInstanceCount: cargoPersonalInstanceCount]
    }

    /**
     * Acción llamada con ajax que muestra la información de un elemento particular
     * @return cargoPersonalInstance el objeto a mostrar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def show_ajax() {
        if (params.id) {
            def cargoPersonalInstance = CargoPersonal.get(params.id)
            if (!cargoPersonalInstance) {
                render "ERROR*No se encontró CargoPersonal."
                return
            }
            return [cargoPersonalInstance: cargoPersonalInstance]
        } else {
            render "ERROR*No se encontró CargoPersonal."
        }
    } //show para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que muestra un formaulario para crear o modificar un elemento
     * @return cargoPersonalInstance el objeto a modificar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def form_ajax() {
        def cargoPersonalInstance = new CargoPersonal()
        if (params.id) {
            cargoPersonalInstance = CargoPersonal.get(params.id)
            if (!cargoPersonalInstance) {
                render "ERROR*No se encontró CargoPersonal."
                return
            }
        }
        cargoPersonalInstance.properties = params
        return [cargoPersonalInstance: cargoPersonalInstance]
    } //form para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que guarda la información de un elemento
     * @render ERROR*[mensaje] cuando no se pudo grabar correctamente, SUCCESS*[mensaje] cuando se grabó correctamente
     */
    def save_ajax() {
        def cargoPersonalInstance = new CargoPersonal()
        if (params.id) {
            cargoPersonalInstance = CargoPersonal.get(params.id)
            if (!cargoPersonalInstance) {
                render "ERROR*No se encontró CargoPersonal."
                return
            }
        }
        cargoPersonalInstance.properties = params
        if (!cargoPersonalInstance.save(flush: true)) {
            render "ERROR*Ha ocurrido un error al guardar CargoPersonal: " + renderErrors(bean: cargoPersonalInstance)
            return
        }
        render "SUCCESS*${params.id ? 'Actualización' : 'Creación'} de CargoPersonal exitosa."
        return
    } //save para grabar desde ajax

    /**
     * Acción llamada con ajax que permite eliminar un elemento
     * @render ERROR*[mensaje] cuando no se pudo eliminar correctamente, SUCCESS*[mensaje] cuando se eliminó correctamente
     */
    def delete_ajax() {
        if (params.id) {
            def cargoPersonalInstance = CargoPersonal.get(params.id)
            if (!cargoPersonalInstance) {
                render "ERROR*No se encontró CargoPersonal."
                return
            }
            try {
                cargoPersonalInstance.delete(flush: true)
                render "SUCCESS*Eliminación de CargoPersonal exitosa."
                return
            } catch (DataIntegrityViolationException e) {
                render "ERROR*Ha ocurrido un error al eliminar CargoPersonal"
                return
            }
        } else {
            render "ERROR*No se encontró CargoPersonal."
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
            def obj = CargoPersonal.get(params.id)
            if (obj.codigo.toLowerCase() == params.codigo.toLowerCase()) {
                render true
                return
            } else {
                render CargoPersonal.countByCodigoIlike(params.codigo) == 0
                return
            }
        } else {
            render CargoPersonal.countByCodigoIlike(params.codigo) == 0
            return
        }
    }

}
