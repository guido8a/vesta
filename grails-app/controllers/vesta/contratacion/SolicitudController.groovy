package vesta.contratacion

import org.springframework.dao.DataIntegrityViolationException
import vesta.seguridad.Shield


/**
 * Controlador que muestra las pantallas de manejo de Solicitud
 */
class SolicitudController extends Shield {

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
            def c = Solicitud.createCriteria()
            list = c.list(params) {
                or {
                    /* TODO: cambiar aqui segun sea necesario */

                    ilike("asistentesAprobacion", "%" + params.search + "%")
                    ilike("estado", "%" + params.search + "%")
                    ilike("formaPago", "%" + params.search + "%")
                    ilike("incluirReunion", "%" + params.search + "%")
                    ilike("nombreProceso", "%" + params.search + "%")
                    ilike("objetoContrato", "%" + params.search + "%")
                    ilike("observaciones", "%" + params.search + "%")
                    ilike("observacionesAdministrativaFinanciera", "%" + params.search + "%")
                    ilike("observacionesAprobacion", "%" + params.search + "%")
                    ilike("observacionesDireccionProyectos", "%" + params.search + "%")
                    ilike("observacionesJuridica", "%" + params.search + "%")
                    ilike("pathAnalisisCostos", "%" + params.search + "%")
                    ilike("pathAprobacion", "%" + params.search + "%")
                    ilike("pathCuadroComparativo", "%" + params.search + "%")
                    ilike("pathOferta1", "%" + params.search + "%")
                    ilike("pathOferta2", "%" + params.search + "%")
                    ilike("pathOferta3", "%" + params.search + "%")
                    ilike("pathPdfTdr", "%" + params.search + "%")
                    ilike("pathRevisionGAF", "%" + params.search + "%")
                    ilike("pathRevisionGDP", "%" + params.search + "%")
                    ilike("pathRevisionGJ", "%" + params.search + "%")
                    ilike("revisionDireccionPlanificacionInversion", "%" + params.search + "%")
                }
            }
        } else {
            list = Solicitud.list(params)
        }
        if (!all && params.offset.toInteger() > 0 && list.size() == 0) {
            params.offset = params.offset.toInteger() - 1
            list = getList(params, all)
        }
        return list
    }

    /**
     * Acción que muestra la lista de elementos
     * @return solicitudInstanceList: la lista de elementos filtrados, solicitudInstanceCount: la cantidad total de elementos (sin máximo)
     */
    def list() {
        def solicitudInstanceList = getList(params, false)
        def solicitudInstanceCount = getList(params, true).size()
        return [solicitudInstanceList: solicitudInstanceList, solicitudInstanceCount: solicitudInstanceCount]
    }

    /**
     * Acción llamada con ajax que muestra la información de un elemento particular
     * @return solicitudInstance el objeto a mostrar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def show_ajax() {
        if (params.id) {
            def solicitudInstance = Solicitud.get(params.id)
            if (!solicitudInstance) {
                render "ERROR*No se encontró Solicitud."
                return
            }
            return [solicitudInstance: solicitudInstance]
        } else {
            render "ERROR*No se encontró Solicitud."
        }
    } //show para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que muestra un formaulario para crear o modificar un elemento
     * @return solicitudInstance el objeto a modificar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def form_ajax() {
        def solicitudInstance = new Solicitud()
        if (params.id) {
            solicitudInstance = Solicitud.get(params.id)
            if (!solicitudInstance) {
                render "ERROR*No se encontró Solicitud."
                return
            }
        }
        solicitudInstance.properties = params
        return [solicitudInstance: solicitudInstance]
    } //form para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que guarda la información de un elemento
     * @render ERROR*[mensaje] cuando no se pudo grabar correctamente, SUCCESS*[mensaje] cuando se grabó correctamente
     */
    def save_ajax() {
        def solicitudInstance = new Solicitud()
        if (params.id) {
            solicitudInstance = Solicitud.get(params.id)
            if (!solicitudInstance) {
                render "ERROR*No se encontró Solicitud."
                return
            }
        }
        solicitudInstance.properties = params
        if (!solicitudInstance.save(flush: true)) {
            render "ERROR*Ha ocurrido un error al guardar Solicitud: " + renderErrors(bean: solicitudInstance)
            return
        }
        render "SUCCESS*${params.id ? 'Actualización' : 'Creación'} de Solicitud exitosa."
        return
    } //save para grabar desde ajax

    /**
     * Acción llamada con ajax que permite eliminar un elemento
     * @render ERROR*[mensaje] cuando no se pudo eliminar correctamente, SUCCESS*[mensaje] cuando se eliminó correctamente
     */
    def delete_ajax() {
        if (params.id) {
            def solicitudInstance = Solicitud.get(params.id)
            if (!solicitudInstance) {
                render "ERROR*No se encontró Solicitud."
                return
            }
            try {
                solicitudInstance.delete(flush: true)
                render "SUCCESS*Eliminación de Solicitud exitosa."
                return
            } catch (DataIntegrityViolationException e) {
                render "ERROR*Ha ocurrido un error al eliminar Solicitud"
                return
            }
        } else {
            render "ERROR*No se encontró Solicitud."
            return
        }
    } //delete para eliminar via ajax

}
