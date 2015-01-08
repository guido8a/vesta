package vesta.proyectos

import org.springframework.dao.DataIntegrityViolationException
import vesta.seguridad.Shield


/**
 * Controlador que muestra las pantallas de manejo de Documento
 */
class DocumentoController extends Shield {

    static allowedMethods = [save_ajax: "POST", delete_ajax: "POST"]

    /**
     * Acción llamada con ajax que muestra y permite modificar los documentos de un proyecto
     */
    def list_ajax() {
        def proyecto = Proyecto.get(params.id)
        return [proyecto: proyecto]
    }

    /**
     * Acción llamada con ajax que guarda la información de un elemento
     * @render ERROR*[mensaje] cuando no se pudo grabar correctamente, SUCCESS*[mensaje] cuando se grabó correctamente
     */
    def save_ajax() {
        def documentoInstance = new Documento()
        if (params.id) {
            documentoInstance = Documento.get(params.id)
            if (!documentoInstance) {
                render "ERROR*No se encontró Documento."
                return
            }
        }
        documentoInstance.properties = params
        if (!documentoInstance.save(flush: true)) {
            render "ERROR*Ha ocurrido un error al guardar Documento: " + renderErrors(bean: documentoInstance)
            return
        }
        render "SUCCESS*${params.id ? 'Actualización' : 'Creación'} de Documento exitosa."
        return
    } //save para grabar desde ajax

    /**
     * Acción llamada con ajax que permite eliminar un elemento
     * @render ERROR*[mensaje] cuando no se pudo eliminar correctamente, SUCCESS*[mensaje] cuando se eliminó correctamente
     */
    def delete_ajax() {
        if (params.id) {
            def documentoInstance = Documento.get(params.id)
            if (!documentoInstance) {
                render "ERROR*No se encontró Documento."
                return
            }
            try {
                documentoInstance.delete(flush: true)
                render "SUCCESS*Eliminación de Documento exitosa."
                return
            } catch (DataIntegrityViolationException e) {
                render "ERROR*Ha ocurrido un error al eliminar Documento"
                return
            }
        } else {
            render "ERROR*No se encontró Documento."
            return
        }
    } //delete para eliminar via ajax

}
