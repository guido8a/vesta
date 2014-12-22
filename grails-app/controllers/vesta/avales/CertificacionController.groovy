package vesta.avales

import org.springframework.dao.DataIntegrityViolationException
import vesta.seguridad.Shield


/**
 * Controlador que muestra las pantallas de manejo de Certificacion
 */
class CertificacionController extends Shield {

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
            def c = Certificacion.createCriteria()
            list = c.list(params) {
                or {
                    /* TODO: cambiar aqui segun sea necesario */

                    ilike("acuerdo", "%" + params.search + "%")
                    ilike("archivo", "%" + params.search + "%")
                    ilike("concepto", "%" + params.search + "%")
                    ilike("conceptoAnulacion", "%" + params.search + "%")
                    ilike("memorandoCertificado", "%" + params.search + "%")
                    ilike("memorandoSolicitud", "%" + params.search + "%")
                    ilike("numeroContrato", "%" + params.search + "%")
                    ilike("observaciones", "%" + params.search + "%")
                    ilike("pathAnulacion", "%" + params.search + "%")
                    ilike("pathLiberacion", "%" + params.search + "%")
                    ilike("pathSolicitud", "%" + params.search + "%")
                    ilike("pathSolicitudAnulacion", "%" + params.search + "%")
                }
            }
        } else {
            list = Certificacion.list(params)
        }
        if (!all && params.offset.toInteger() > 0 && list.size() == 0) {
            params.offset = params.offset.toInteger() - 1
            list = getList(params, all)
        }
        return list
    }

    /**
     * Acción que muestra la lista de elementos
     * @return certificacionInstanceList: la lista de elementos filtrados, certificacionInstanceCount: la cantidad total de elementos (sin máximo)
     */
    def list() {
        def certificacionInstanceList = getList(params, false)
        def certificacionInstanceCount = getList(params, true).size()
        return [certificacionInstanceList: certificacionInstanceList, certificacionInstanceCount: certificacionInstanceCount]
    }

    /**
     * Acción llamada con ajax que muestra la información de un elemento particular
     * @return certificacionInstance el objeto a mostrar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def show_ajax() {
        if (params.id) {
            def certificacionInstance = Certificacion.get(params.id)
            if (!certificacionInstance) {
                render "ERROR*No se encontró Certificacion."
                return
            }
            return [certificacionInstance: certificacionInstance]
        } else {
            render "ERROR*No se encontró Certificacion."
        }
    } //show para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que muestra un formaulario para crear o modificar un elemento
     * @return certificacionInstance el objeto a modificar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def form_ajax() {
        def certificacionInstance = new Certificacion()
        if (params.id) {
            certificacionInstance = Certificacion.get(params.id)
            if (!certificacionInstance) {
                render "ERROR*No se encontró Certificacion."
                return
            }
        }
        certificacionInstance.properties = params
        return [certificacionInstance: certificacionInstance]
    } //form para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que guarda la información de un elemento
     * @render ERROR*[mensaje] cuando no se pudo grabar correctamente, SUCCESS*[mensaje] cuando se grabó correctamente
     */
    def save_ajax() {
        def certificacionInstance = new Certificacion()
        if (params.id) {
            certificacionInstance = Certificacion.get(params.id)
            if (!certificacionInstance) {
                render "ERROR*No se encontró Certificacion."
                return
            }
        }
        certificacionInstance.properties = params
        if (!certificacionInstance.save(flush: true)) {
            render "ERROR*Ha ocurrido un error al guardar Certificacion: " + renderErrors(bean: certificacionInstance)
            return
        }
        render "SUCCESS*${params.id ? 'Actualización' : 'Creación'} de Certificacion exitosa."
        return
    } //save para grabar desde ajax

    /**
     * Acción llamada con ajax que permite eliminar un elemento
     * @render ERROR*[mensaje] cuando no se pudo eliminar correctamente, SUCCESS*[mensaje] cuando se eliminó correctamente
     */
    def delete_ajax() {
        if (params.id) {
            def certificacionInstance = Certificacion.get(params.id)
            if (!certificacionInstance) {
                render "ERROR*No se encontró Certificacion."
                return
            }
            try {
                certificacionInstance.delete(flush: true)
                render "SUCCESS*Eliminación de Certificacion exitosa."
                return
            } catch (DataIntegrityViolationException e) {
                render "ERROR*Ha ocurrido un error al eliminar Certificacion"
                return
            }
        } else {
            render "ERROR*No se encontró Certificacion."
            return
        }
    } //delete para eliminar via ajax

}
