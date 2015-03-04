package vesta.parametros.poaPac

import org.springframework.dao.DataIntegrityViolationException
import vesta.seguridad.Persona
import vesta.seguridad.Shield


/**
 * Controlador que muestra las pantallas de manejo de Presupuesto
 */
class PresupuestoController extends Shield {

    static allowedMethods = [save_ajax: "POST", delete_ajax: "POST"]

    /**
     * Acción que muestra las partidas presupuestarias en forma de árbol
     */
    def arbol() {
        return [arbol: makeTree()]
    }

    /**
     * Acción llamada con ajax que permite realizar búsquedas en el árbol
     */
    def arbolSearch_ajax() {
        def search = params.str.trim()
        if (search != "") {
            def c = Presupuesto.createCriteria()
            def find = c.list(params) {
                or {
                    ilike("numero", "%" + search + "%")
                    ilike("descripcion", "%" + search + "%")
                }
            }
            println find
            def presupuestos = []
            find.each { pres ->
                if (pres.presupuesto && !presupuestos.contains(pres.presupuesto)) {
                    def pr = pres
                    while (pr) {
                        if (pr.presupuesto && !presupuestos.contains(pr.presupuesto)) {
                            presupuestos.add(pr.presupuesto)
                        }
                        pr = pr.presupuesto
                    }
                }
            }
            presupuestos = presupuestos.reverse()

            def ids = "["
            if (find.size() > 0) {
                ids += "\"#root\","
                presupuestos.each { pr ->
                    ids += "\"#lid_" + pr.id + "\","
                }
                ids = ids[0..-2]
            }
            ids += "]"
            render ids
        } else {
            render ""
        }
    }

    /**
     * Función que genera el árbol de partidas presupuestarias
     */
    def makeTree() {
        def lista = Presupuesto.findAllByNivel(1, [sort: "numero"]).id//Presupuesto.list(sort: "codigo")
        def res = ""
        res += "<ul>"
        res += "<li id='root' data-level='0' class='root jstree-open' data-jstree='{\"type\":\"root\"}'>"
        res += "<a href='#' class='label_arbol'>Presupuesto</a>"
        res += "<ul>"
        lista.each {
            res += imprimeHijos(it)
        }
        res += "</ul>"
        res += "</ul>"
    }

    /**
     * Función que genera las hojas del árbol de un padre específico
     */
    def imprimeHijos(padre) {
        def band = true
        def t = ""
        def txt = ""

        def presupuesto = Presupuesto.get(padre)

        def l = Presupuesto.findAllByPresupuesto(presupuesto, [sort: 'numero']);

        l.each {
            band = false;
            t += imprimeHijos(it.id)
        }

        if (!band) {
            def clase = "jstree-open"
            if (presupuesto.nivel >= 2) {
                clase = "jstree-closed"
            }
            txt += "<li id='li_" + presupuesto.id + "' data-level='" + presupuesto.nivel + "' class='padre " + clase + "' data-jstree='{\"type\":\"padre\"}'>"
            txt += "<a href='#' class='label_arbol'>" + presupuesto + "</a>"
            txt += "<ul>"
            txt += t
            txt += "</ul>"
        } else {
            txt += "<li id='li_" + presupuesto.id + "' data-level='" + presupuesto.nivel + "' class='hijo jstree-leaf' data-jstree='{\"type\":\"hijo\"}'>"
            txt += "<a href='#' class='label_arbol'>" + presupuesto + "</a>"
        }
        txt += "</li>"
        return txt
    }

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
            def c = Presupuesto.createCriteria()
            list = c.list(params) {
                or {
                    /* TODO: cambiar aqui segun sea necesario */

                    ilike("descripcion", "%" + params.search + "%")
                    ilike("numero", "%" + params.search + "%")
                }
            }
        } else {
            list = Presupuesto.list(params)
        }
        if (!all && params.offset.toInteger() > 0 && list.size() == 0) {
            params.offset = params.offset.toInteger() - 1
            list = getList(params, all)
        }
        return list
    }

    /**
     * Acción que muestra la lista de elementos
     * @return presupuestoInstanceList: la lista de elementos filtrados, presupuestoInstanceCount: la cantidad total de elementos (sin máximo)
     */
    def list() {
        def presupuestoInstanceList = getList(params, false)
        def presupuestoInstanceCount = getList(params, true).size()
        return [presupuestoInstanceList: presupuestoInstanceList, presupuestoInstanceCount: presupuestoInstanceCount]
    }

    /**
     * Acción llamada con ajax que muestra la información de un elemento particular
     * @return presupuestoInstance el objeto a mostrar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def show_ajax() {
        if (params.id) {
            def presupuestoInstance = Presupuesto.get(params.id)
            if (!presupuestoInstance) {
                render "ERROR*No se encontró Presupuesto."
                return
            }
            return [presupuestoInstance: presupuestoInstance]
        } else {
            render "ERROR*No se encontró Presupuesto."
        }
    } //show para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que muestra un formulario para crear o modificar un elemento
     * @return presupuestoInstance el objeto a modificar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def form_ajax() {
        def presupuestoInstance = new Presupuesto()
        if (params.id) {
            presupuestoInstance = Presupuesto.get(params.id)
            if (!presupuestoInstance) {
                render "ERROR*No se encontró Presupuesto."
                return
            }
        }
        presupuestoInstance.properties = params
        def nivel = 1
        if (!params.id) {
            presupuestoInstance.movimiento = 0
        } else {
            nivel = presupuestoInstance.nivel
        }
        if (params.padre) {
            def padre = Presupuesto.get(params.padre.toLong())
            nivel = padre.nivel + 1
            presupuestoInstance.presupuesto = padre
        }

        presupuestoInstance.nivel = nivel

        return [presupuestoInstance: presupuestoInstance]
    } //form para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que guarda la información de un elemento
     * @render ERROR*[mensaje] cuando no se pudo grabar correctamente, SUCCESS*[mensaje] cuando se grabó correctamente
     */
    def save_ajax() {
        def presupuestoInstance = new Presupuesto()
        if (params.id) {
            presupuestoInstance = Presupuesto.get(params.id)
            if (!presupuestoInstance) {
                render "ERROR*No se encontró Presupuesto."
                return
            }
        }
        presupuestoInstance.properties = params
        if (!presupuestoInstance.save(flush: true)) {
            render "ERROR*Ha ocurrido un error al guardar Presupuesto: " + renderErrors(bean: presupuestoInstance)
            return
        }
        render "SUCCESS*${params.id ? 'Actualización' : 'Creación'} de Presupuesto exitosa."
        return
    } //save para grabar desde ajax

    /**
     * Acción llamada con ajax que permite eliminar un elemento
     * @render ERROR*[mensaje] cuando no se pudo eliminar correctamente, SUCCESS*[mensaje] cuando se eliminó correctamente
     */
    def delete_ajax() {
        if (params.id) {
            def presupuestoInstance = Presupuesto.get(params.id)
            if (!presupuestoInstance) {
                render "ERROR*No se encontró Presupuesto."
                return
            }
            def hijos = Presupuesto.findAllByPresupuesto(presupuestoInstance)
            if (hijos == 0) {
                try {
                    presupuestoInstance.delete(flush: true)
                    render "SUCCESS*Eliminación de Presupuesto exitosa."
                    return
                } catch (DataIntegrityViolationException e) {
                    render "ERROR*Ha ocurrido un error al eliminar Presupuesto"
                    return
                }
            } else {
                render "ERROR*El presupuesto tiene presupuestos asociados, no puede eliminarlo"
            }
        } else {
            render "ERROR*No se encontró Presupuesto."
            return
        }
    } //delete para eliminar via ajax

}
