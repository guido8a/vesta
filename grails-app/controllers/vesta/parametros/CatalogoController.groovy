package vesta.parametros

import org.springframework.dao.DataIntegrityViolationException
import vesta.seguridad.Shield


/**
 * Controlador que muestra las pantallas de manejo de Catalogo
 */
class CatalogoController extends Shield {


    def dbConnectionService
    def kerberosService

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
            def c = Catalogo.createCriteria()
            list = c.list(params) {
                or {
                    /* TODO: cambiar aqui segun sea necesario */

                    ilike("codigo", "%" + params.search + "%")
                    ilike("nombre", "%" + params.search + "%")
                }
            }
        } else {
            list = Catalogo.list(params)
        }
        if (!all && params.offset.toInteger() > 0 && list.size() == 0) {
            params.offset = params.offset.toInteger() - 1
            list = getList(params, all)
        }
        return list
    }

    /**
     * Acción que muestra la lista de elementos
     * @return catalogoInstanceList: la lista de elementos filtrados, catalogoInstanceCount: la cantidad total de elementos (sin máximo)
     */
    def list() {
        def catalogoInstanceList = getList(params, false)
        def catalogoInstanceCount = getList(params, true).size()
        return [catalogoInstanceList: catalogoInstanceList, catalogoInstanceCount: catalogoInstanceCount]
    }

    /**
     * Acción llamada con ajax que muestra la información de un elemento particular
     * @return catalogoInstance el objeto a mostrar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def show_ajax() {
        if (params.id) {
            def catalogoInstance = Catalogo.get(params.id)
            if (!catalogoInstance) {
                render "ERROR*No se encontró Catálogo."
                return
            }
            return [catalogoInstance: catalogoInstance]
        } else {
            render "ERROR*No se encontró Catálogo."
        }
    } //show para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que muestra un formulario para crear o modificar un elemento
     * @return catalogoInstance el objeto a modificar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def form_ajax() {
        def catalogoInstance = new Catalogo()
        if (params.id) {
            catalogoInstance = Catalogo.get(params.id)
            if (!catalogoInstance) {
                render "ERROR*No se encontró Catálogo."
                return
            }
        }
        catalogoInstance.properties = params
        return [catalogoInstance: catalogoInstance]
    } //form para cargar con ajax en un dialog

    def form_item_ajax() {
        println("params " + params)
        def catalogo = Catalogo.get(params.cata)
        def itemCatalogoInstance

        if (params.id && params.id != 'undefined') {
            itemCatalogoInstance = ItemCatalogo.findByCatalogoAndId(catalogo, params.id)
        } else {
            itemCatalogoInstance = new ItemCatalogo()
        }
//        itemCatalogoInstance.properties = params

        println("item " + itemCatalogoInstance)

        return [itemCatalogoInstance: itemCatalogoInstance, catalogo: catalogo]
    } //form para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que guarda la información de un elemento
     * @render ERROR*[mensaje] cuando no se pudo grabar correctamente, SUCCESS*[mensaje] cuando se grabó correctamente
     */
    def save_ajax() {
        def catalogoInstance = new Catalogo()
        if (params.id) {
            catalogoInstance = Catalogo.get(params.id)
            if (!catalogoInstance) {
                render "ERROR*No se encontró Catálogo."
                return
            }
        }
        catalogoInstance.properties = params
        if (!catalogoInstance.save(flush: true)) {
            render "ERROR*Ha ocurrido un error al guardar Catálogo: " + renderErrors(bean: catalogoInstance)
            return
        }
        render "SUCCESS*${params.id ? 'Actualización' : 'Creación'} de Catálogo exitosa."
        return
    } //save para grabar desde ajax

    /**
     * Acción llamada con ajax que permite eliminar un elemento
     * @render ERROR*[mensaje] cuando no se pudo eliminar correctamente, SUCCESS*[mensaje] cuando se eliminó correctamente
     */
    def delete_ajax() {
        if (params.id) {
            def catalogoInstance = Catalogo.get(params.id)
            if (!catalogoInstance) {
                render "ERROR*No se encontró Catálogo."
                return
            }
            try {
                catalogoInstance.delete(flush: true)
                render "SUCCESS*Eliminación de Catálogo exitosa."
                return
            } catch (DataIntegrityViolationException e) {
                render "ERROR*Ha ocurrido un error al eliminar Catálogo"
                return
            }
        } else {
            render "ERROR*No se encontró Catálogo."
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
            def obj = Catalogo.get(params.id)
            if (obj.codigo.toLowerCase() == params.codigo.toLowerCase()) {
                render true
                return
            } else {
                render Catalogo.countByCodigoIlike(params.codigo) == 0
                return
            }
        } else {
            render Catalogo.countByCodigoIlike(params.codigo) == 0
            return
        }
    }

    /**
     * Acción llamada con ajax que valida que no se duplique la propiedad codigo
     * @render boolean que indica si se puede o no utilizar el valor recibido
     */
    def validar_unique_codigoItem_ajax() {
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


    def items() {
    }


    def saveItems = {

    }

    /**
     * Acción que muestra una lista de las acciones que puede ver un determinado catálogo
     * @param Catalogo es el identificador del catálogo
     * @param tpac es el identificador del tipo de acción.
     * @param ids es la lista de los módulos
     */
    def cargaItem = {
        println "---------parametros: ${params}"
        def ctlg = params.ctlg.toInteger()
        def resultado = []
        def i = 0
        def ids = params.ids

        if (params.menu?.size() > 0) ids = params.menu
        if (params.grabar) {
            //println "a grabar... ${Catalogo}, ${ids}"
        }

        def items = ItemCatalogo.findAllByCatalogo(Catalogo.get(params.ctlg.toLong()))
        return [items: items, mdlo__id: ids, catalogo: params.ctlg]

//        def cn = dbConnectionService.getConnection()
//        def tx = ""
//        // selecciona las acciones que no se han consedido permisos
//        tx = "select itct__id, itctcdgo, itctdscr, itctetdo, itctordn, itctorgn " +
//                "from itct " +
//                "where ctlg__id = " + ctlg + " order by itctnmbr"
//
//        println "ajaxPermisos SQL: ${tx}"
//        cn.eachRow(tx) { d ->
//            resultado[i] = [d.itct__id] + [d.itctcdgo] + [d.itctdscr] + [d.itctetdo] + [d.itctordn] + [d.itctorgn]
//            i++
//        }
//        cn.close()
//        //println "-------------------------" + resultado
//        render(view: 'lsta', model: [datos: resultado, mdlo__id: ids, catalogo: params.ctlg])
    }


}
