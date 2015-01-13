package vesta.proyectos

import org.springframework.dao.DataIntegrityViolationException
import vesta.seguridad.Shield


/**
 * Controlador que muestra las pantallas de manejo de Responsable
 */
class ResponsableController extends Shield {

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
            def c = Responsable.createCriteria()
            list = c.list(params) {
                or {
                    /* TODO: cambiar aqui segun sea necesario */

                    ilike("apellido", "%" + params.search + "%")
                    ilike("cargo", "%" + params.search + "%")
                    ilike("cedula", "%" + params.search + "%")
                    ilike("email", "%" + params.search + "%")
                    ilike("email2", "%" + params.search + "%")
                    ilike("nombre", "%" + params.search + "%")
                    ilike("observaciones", "%" + params.search + "%")
                    ilike("telefono", "%" + params.search + "%")
                }
            }
        } else {
            list = Responsable.list(params)
        }
        if (!all && params.offset.toInteger() > 0 && list.size() == 0) {
            params.offset = params.offset.toInteger() - 1
            list = getList(params, all)
        }
        return list
    }

    /**
     * Acción que muestra la lista de elementos
     * @return responsableInstanceList: la lista de elementos filtrados, responsableInstanceCount: la cantidad total de elementos (sin máximo)
     */
    def list() {
        def responsableInstanceList = getList(params, false)
        def responsableInstanceCount = getList(params, true).size()
        return [responsableInstanceList: responsableInstanceList, responsableInstanceCount: responsableInstanceCount]
    }

    /**
     * Acción llamada con ajax que muestra la información de un elemento particular
     * @return responsableInstance el objeto a mostrar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def show_ajax() {
        if (params.id) {
            def responsableInstance = Responsable.get(params.id)
            if (!responsableInstance) {
                render "ERROR*No se encontró Responsable."
                return
            }
            return [responsableInstance: responsableInstance]
        } else {
            render "ERROR*No se encontró Responsable."
        }
    } //show para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que muestra un formulario para crear o modificar un elemento
     * @return responsableInstance el objeto a modificar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def form_ajax() {
        def responsableInstance = new Responsable()
        if (params.id) {
            responsableInstance = Responsable.get(params.id)
            if (!responsableInstance) {
                render "ERROR*No se encontró Responsable."
                return
            }
        }
        responsableInstance.properties = params
        return [responsableInstance: responsableInstance]
    } //form para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que guarda la información de un elemento
     * @render ERROR*[mensaje] cuando no se pudo grabar correctamente, SUCCESS*[mensaje] cuando se grabó correctamente
     */
    def save_ajax() {
        def responsableInstance = new Responsable()
        if (params.id) {
            responsableInstance = Responsable.get(params.id)
            if (!responsableInstance) {
                render "ERROR*No se encontró Responsable."
                return
            }
        }
        responsableInstance.properties = params
        if (!responsableInstance.save(flush: true)) {
            render "ERROR*Ha ocurrido un error al guardar Responsable: " + renderErrors(bean: responsableInstance)
            return
        }
        render "SUCCESS*${params.id ? 'Actualización' : 'Creación'} de Responsable exitosa."
        return
    } //save para grabar desde ajax

    /**
     * Acción llamada con ajax que permite eliminar un elemento
     * @render ERROR*[mensaje] cuando no se pudo eliminar correctamente, SUCCESS*[mensaje] cuando se eliminó correctamente
     */
    def delete_ajax() {
        if (params.id) {
            def responsableInstance = Responsable.get(params.id)
            if (!responsableInstance) {
                render "ERROR*No se encontró Responsable."
                return
            }
            try {
                responsableInstance.delete(flush: true)
                render "SUCCESS*Eliminación de Responsable exitosa."
                return
            } catch (DataIntegrityViolationException e) {
                render "ERROR*Ha ocurrido un error al eliminar Responsable"
                return
            }
        } else {
            render "ERROR*No se encontró Responsable."
            return
        }
    } //delete para eliminar via ajax

    /**
     * Acción llamada con ajax que valida que no se duplique la propiedad email
     * @render boolean que indica si se puede o no utilizar el valor recibido
     */
    def validar_unique_email_ajax() {
        params.email = params.email.toString().trim()
        if (params.id) {
            def obj = Responsable.get(params.id)
            if (obj.email.toLowerCase() == params.email.toLowerCase()) {
                render true
                return
            } else {
                render Responsable.countByEmailIlike(params.email) == 0
                return
            }
        } else {
            render Responsable.countByEmailIlike(params.email) == 0
            return
        }
    }

    /**
     * Acción llamada con ajax que valida que no se duplique la propiedad email2
     * @render boolean que indica si se puede o no utilizar el valor recibido
     */
    def validar_unique_email2_ajax() {
        params.email2 = params.email2.toString().trim()
        if (params.id) {
            def obj = Responsable.get(params.id)
            if (obj.email2.toLowerCase() == params.email2.toLowerCase()) {
                render true
                return
            } else {
                render Responsable.countByEmail2Ilike(params.email2) == 0
                return
            }
        } else {
            render Responsable.countByEmail2Ilike(params.email2) == 0
            return
        }
    }

}
