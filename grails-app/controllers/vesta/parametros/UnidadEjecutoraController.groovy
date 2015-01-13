package vesta.parametros

import org.springframework.dao.DataIntegrityViolationException
import vesta.seguridad.Shield


/**
 * Controlador que muestra las pantallas de manejo de UnidadEjecutora
 */
class UnidadEjecutoraController extends Shield {

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
            def c = UnidadEjecutora.createCriteria()
            list = c.list(params) {
                or {
                    /* TODO: cambiar aqui segun sea necesario */

                    ilike("codigo", "%" + params.search + "%")
                    ilike("direccion", "%" + params.search + "%")
                    ilike("email", "%" + params.search + "%")
                    ilike("fax", "%" + params.search + "%")
                    ilike("nombre", "%" + params.search + "%")
                    ilike("objetivo", "%" + params.search + "%")
                    ilike("observaciones", "%" + params.search + "%")
                    ilike("sigla", "%" + params.search + "%")
                    ilike("telefono", "%" + params.search + "%")
                }
            }
        } else {
            list = UnidadEjecutora.list(params)
        }
        if (!all && params.offset.toInteger() > 0 && list.size() == 0) {
            params.offset = params.offset.toInteger() - 1
            list = getList(params, all)
        }
        return list
    }

    /**
     * Acción que muestra la lista de elementos
     * @return unidadEjecutoraInstanceList: la lista de elementos filtrados, unidadEjecutoraInstanceCount: la cantidad total de elementos (sin máximo)
     */
    def list() {
        def unidadEjecutoraInstanceList = getList(params, false)
        def unidadEjecutoraInstanceCount = getList(params, true).size()
        return [unidadEjecutoraInstanceList: unidadEjecutoraInstanceList, unidadEjecutoraInstanceCount: unidadEjecutoraInstanceCount]
    }

    /**
     * Acción llamada con ajax que muestra la información de un elemento particular
     * @return unidadEjecutoraInstance el objeto a mostrar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def show_ajax() {
        if (params.id) {
            def unidadEjecutoraInstance = UnidadEjecutora.get(params.id)
            if (!unidadEjecutoraInstance) {
                render "ERROR*No se encontró UnidadEjecutora."
                return
            }
            def c = PresupuestoUnidad.createCriteria()
            def presupuestos = c.list {
                eq("unidad", unidadEjecutoraInstance)
                anio {
                    order("anio", "asc")
                }
            }
            return [unidadEjecutoraInstance: unidadEjecutoraInstance, presupuestos: presupuestos]
        } else {
            render "ERROR*No se encontró UnidadEjecutora."
        }
    } //show para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que muestra un formulario para crear o modificar un elemento
     * @return unidadEjecutoraInstance el objeto a modificar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def form_ajax() {
        def unidadEjecutoraInstance = new UnidadEjecutora()
        if (params.id) {
            unidadEjecutoraInstance = UnidadEjecutora.get(params.id)
            if (!unidadEjecutoraInstance) {
                render "ERROR*No se encontró Entidad."
                return
            }
        }
        unidadEjecutoraInstance.properties = params
        if (params.padre) {
            def padre = UnidadEjecutora.get(params.padre.toLong())
            unidadEjecutoraInstance.padre = padre;
        }
        return [unidadEjecutoraInstance: unidadEjecutoraInstance]
    } //form para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que guarda la información de un elemento
     * @render ERROR*[mensaje] cuando no se pudo grabar correctamente, SUCCESS*[mensaje] cuando se grabó correctamente
     */
    def save_ajax() {
        def unidadEjecutoraInstance = new UnidadEjecutora()
        if (params.id) {
            unidadEjecutoraInstance = UnidadEjecutora.get(params.id)
            if (!unidadEjecutoraInstance) {
                render "ERROR*No se encontró Entidad."
                return
            }
        }
        if (params.codigo) {
            params.codigo = params.codigo.trim()
        }
        unidadEjecutoraInstance.properties = params
        if (!unidadEjecutoraInstance.save(flush: true)) {
            render "ERROR*Ha ocurrido un error al guardar Entidad: " + renderErrors(bean: unidadEjecutoraInstance)
            return
        }
        render "SUCCESS*${params.id ? 'Actualización' : 'Creación'} de Entidad exitosa."
        return
    } //save para grabar desde ajax

    /**
     * Acción llamada con ajax que permite eliminar un elemento
     * @render ERROR*[mensaje] cuando no se pudo eliminar correctamente, SUCCESS*[mensaje] cuando se eliminó correctamente
     */
    def delete_ajax() {
        if (params.id) {
            def unidadEjecutoraInstance = UnidadEjecutora.get(params.id)
            if (!unidadEjecutoraInstance) {
                render "ERROR*No se encontró UnidadEjecutora."
                return
            }
            try {
                unidadEjecutoraInstance.delete(flush: true)
                render "SUCCESS*Eliminación de Entidad exitosa."
                return
            } catch (DataIntegrityViolationException e) {
                render "ERROR*Ha ocurrido un error al eliminar Entidad"
                return
            }
        } else {
            render "ERROR*No se encontró Entidad."
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
            def obj = UnidadEjecutora.get(params.id)
            if (obj.codigo.toLowerCase() == params.codigo.toLowerCase()) {
                render true
                return
            } else {
                render UnidadEjecutora.countByCodigoIlike(params.codigo) == 0
                return
            }
        } else {
            render UnidadEjecutora.countByCodigoIlike(params.codigo) == 0
            return
        }
    }

    /**
     * Acción llamada con ajax que valida que no se duplique la propiedad email
     * @render boolean que indica si se puede o no utilizar el valor recibido
     */
    def validar_unique_email_ajax() {
        params.email = params.email.toString().trim()
        if (params.id) {
            def obj = UnidadEjecutora.get(params.id)
            if (obj.email.toLowerCase() == params.email.toLowerCase()) {
                render true
                return
            } else {
                render UnidadEjecutora.countByEmailIlike(params.email) == 0
                return
            }
        } else {
            render UnidadEjecutora.countByEmailIlike(params.email) == 0
            return
        }
    }

}
