package vesta.proyectos

import org.springframework.dao.DataIntegrityViolationException
import vesta.seguridad.Shield


/**
 * Controlador que muestra las pantallas de manejo de Proyecto
 */
class ProyectoController extends Shield {

    static allowedMethods = [save_ajax: "POST", delete_ajax: "POST"]

    /**
     * Acción que redirecciona a la lista (acción "list")
     */
    def index() {
        redirect(action:"list", params: params)
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
        if(all) {
            params.remove("max")
            params.remove("offset")
        }
        def list
        if(params.search) {
            def c = Proyecto.createCriteria()
            list = c.list(params) {
                or {
                    /* TODO: cambiar aqui segun sea necesario */
                    
                    ilike("aprobado", "%" + params.search + "%")  
                    ilike("aprobadoPoa", "%" + params.search + "%")  
                    ilike("codigo", "%" + params.search + "%")  
                    ilike("codigoEsigef", "%" + params.search + "%")  
                    ilike("codigoProyecto", "%" + params.search + "%")  
                    ilike("descripcion", "%" + params.search + "%")  
                    ilike("lineaBase", "%" + params.search + "%")  
                    ilike("nombre", "%" + params.search + "%")  
                    ilike("poblacionObjetivo", "%" + params.search + "%")  
                    ilike("problema", "%" + params.search + "%")  
                    ilike("producto", "%" + params.search + "%")  
                    ilike("subPrograma", "%" + params.search + "%")  
                }
            }
        } else {
            list = Proyecto.list(params)
        }
        if (!all && params.offset.toInteger() > 0 && list.size() == 0) {
            params.offset = params.offset.toInteger() - 1
            list = getList(params, all)
        }
        return list
    }

    /**
     * Acción que muestra la lista de elementos
     * @return proyectoInstanceList: la lista de elementos filtrados, proyectoInstanceCount: la cantidad total de elementos (sin máximo)
     */
    def list() {
        def proyectoInstanceList = getList(params, false)
        def proyectoInstanceCount = getList(params, true).size()
        return [proyectoInstanceList: proyectoInstanceList, proyectoInstanceCount: proyectoInstanceCount]
    }

    /**
     * Acción llamada con ajax que muestra la información de un elemento particular
     * @return proyectoInstance el objeto a mostrar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def show_ajax() {
        if(params.id) {
            def proyectoInstance = Proyecto.get(params.id)
            if(!proyectoInstance) {
                render "ERROR*No se encontró Proyecto."
                return
            }
            return [proyectoInstance: proyectoInstance]
        } else {
            render "ERROR*No se encontró Proyecto."
        }
    } //show para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que muestra un formaulario para crear o modificar un elemento
     * @return proyectoInstance el objeto a modificar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def form_ajax() {
        def proyectoInstance = new Proyecto()
        if(params.id) {
            proyectoInstance = Proyecto.get(params.id)
            if(!proyectoInstance) {
                render "ERROR*No se encontró Proyecto."
                return
            }
        }
        proyectoInstance.properties = params
        return [proyectoInstance: proyectoInstance]
    } //form para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que guarda la información de un elemento
     * @render ERROR*[mensaje] cuando no se pudo grabar correctamente, SUCCESS*[mensaje] cuando se grabó correctamente
     */
    def save_ajax() {
        def proyectoInstance = new Proyecto()
        if(params.id) {
            proyectoInstance = Proyecto.get(params.id)
            if(!proyectoInstance) {
                render "ERROR*No se encontró Proyecto."
                return
            }
        }
        proyectoInstance.properties = params
        if(!proyectoInstance.save(flush: true)) {
            render "ERROR*Ha ocurrido un error al guardar Proyecto: " + renderErrors(bean: proyectoInstance)
            return
        }
        render "SUCCESS*${params.id ? 'Actualización' : 'Creación'} de Proyecto exitosa."
        return
    } //save para grabar desde ajax

    /**
     * Acción llamada con ajax que permite eliminar un elemento
     * @render ERROR*[mensaje] cuando no se pudo eliminar correctamente, SUCCESS*[mensaje] cuando se eliminó correctamente
     */
    def delete_ajax() {
        if(params.id) {
            def proyectoInstance = Proyecto.get(params.id)
            if (!proyectoInstance) {
                render "ERROR*No se encontró Proyecto."
                return
            }
            try {
                proyectoInstance.delete(flush: true)
                render "SUCCESS*Eliminación de Proyecto exitosa."
                return
            } catch (DataIntegrityViolationException e) {
                render "ERROR*Ha ocurrido un error al eliminar Proyecto"
                return
            }
        } else {
            render "ERROR*No se encontró Proyecto."
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
            def obj = Proyecto.get(params.id)
            if (obj.codigo.toLowerCase() == params.codigo.toLowerCase()) {
                render true
                return
            } else {
                render Proyecto.countByCodigoIlike(params.codigo) == 0
                return
            }
        } else {
            render Proyecto.countByCodigoIlike(params.codigo) == 0
            return
        }
    }
        
    /**
     * Acción llamada con ajax que valida que no se duplique la propiedad codigoEsigef
     * @render boolean que indica si se puede o no utilizar el valor recibido
     */
    def validar_unique_codigoEsigef_ajax() {
        params.codigoEsigef = params.codigoEsigef.toString().trim()
        if (params.id) {
            def obj = Proyecto.get(params.id)
            if (obj.codigoEsigef.toLowerCase() == params.codigoEsigef.toLowerCase()) {
                render true
                return
            } else {
                render Proyecto.countByCodigoEsigefIlike(params.codigoEsigef) == 0
                return
            }
        } else {
            render Proyecto.countByCodigoEsigefIlike(params.codigoEsigef) == 0
            return
        }
    }
        
    /**
     * Acción llamada con ajax que valida que no se duplique la propiedad codigoProyecto
     * @render boolean que indica si se puede o no utilizar el valor recibido
     */
    def validar_unique_codigoProyecto_ajax() {
        params.codigoProyecto = params.codigoProyecto.toString().trim()
        if (params.id) {
            def obj = Proyecto.get(params.id)
            if (obj.codigoProyecto.toLowerCase() == params.codigoProyecto.toLowerCase()) {
                render true
                return
            } else {
                render Proyecto.countByCodigoProyectoIlike(params.codigoProyecto) == 0
                return
            }
        } else {
            render Proyecto.countByCodigoProyectoIlike(params.codigoProyecto) == 0
            return
        }
    }
        
}
