package vesta.parametros

import org.springframework.dao.DataIntegrityViolationException
import vesta.parametros.poaPac.Anio
import vesta.proyectos.ModificacionTechos
import vesta.proyectos.Proyecto
import vesta.seguridad.Persona
import vesta.seguridad.Shield


/**
 * Controlador que muestra las pantallas de manejo de Entidad
 */
class EntidadController extends Shield {

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
            def c = Entidad.createCriteria()
            list = c.list(params) {
                or {
                    /* TODO: cambiar aqui segun sea necesario */

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
            list = Entidad.list(params)
        }
        if (!all && params.offset.toInteger() > 0 && list.size() == 0) {
            params.offset = params.offset.toInteger() - 1
            list = getList(params, all)
        }
        return list
    }

    /**
     * Acción que muestra la lista de elementos
     * @return entidadInstanceList: la lista de elementos filtrados, entidadInstanceCount: la cantidad total de elementos (sin máximo)
     */
    def list() {
        def entidadInstanceList = getList(params, false)
        def entidadInstanceCount = getList(params, true).size()
        return [entidadInstanceList: entidadInstanceList, entidadInstanceCount: entidadInstanceCount]
    }

    /**
     * Acción llamada con ajax que muestra la información de un elemento particular
     * @return entidadInstance el objeto a mostrar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def show_ajax() {
        if (params.id) {
            def entidadInstance = Entidad.get(params.id)
            if (!entidadInstance) {
                render "ERROR*No se encontró Entidad."
                return
            }
            return [entidadInstance: entidadInstance]
        } else {
            render "ERROR*No se encontró Entidad."
        }
    } //show para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que muestra un formulario para crear o modificar un elemento
     * @return entidadInstance el objeto a modificar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def form_ajax() {
        def entidadInstance = new Entidad()
        if (params.id) {
            entidadInstance = Entidad.get(params.id)
            if (!entidadInstance) {
                render "ERROR*No se encontró Entidad."
                return
            }
        }
        entidadInstance.properties = params
        return [entidadInstance: entidadInstance]
    } //form para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que guarda la información de un elemento
     * @render ERROR*[mensaje] cuando no se pudo grabar correctamente, SUCCESS*[mensaje] cuando se grabó correctamente
     */
    def save_ajax() {
        def entidadInstance = new Entidad()
        if (params.id) {
            entidadInstance = Entidad.get(params.id)
            if (!entidadInstance) {
                render "ERROR*No se encontró Entidad."
                return
            }
        }
        entidadInstance.properties = params
        if (!entidadInstance.save(flush: true)) {
            render "ERROR*Ha ocurrido un error al guardar Entidad: " + renderErrors(bean: entidadInstance)
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
            def entidadInstance = Entidad.get(params.id)
            if (!entidadInstance) {
                render "ERROR*No se encontró Entidad."
                return
            }
            try {
                entidadInstance.delete(flush: true)
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
     * Acción llamada con ajax que valida que no se duplique la propiedad email
     * @render boolean que indica si se puede o no utilizar el valor recibido
     */
    def validar_unique_email_ajax() {
        params.email = params.email.toString().trim()
        if (params.id) {
            def obj = Entidad.get(params.id)
            if (obj.email.toLowerCase() == params.email.toLowerCase()) {
                render true
                return
            } else {
                render Entidad.countByEmailIlike(params.email) == 0
                return
            }
        } else {
            render Entidad.countByEmailIlike(params.email) == 0
            return
        }
    }

    /**
     * Acción que muestra la estructura institucional (entidades y usuarios) en forma de árbol
     */
    def arbol() {}

    /**
     * Acción llamada con ajax que permite realizar búsquedas en el árbol
     */
    def arbolSearch_ajax() {
        def search = params.str.trim()
        if (search != "") {
            def c = Persona.createCriteria()
            def find = c.list(params) {
                or {
                    ilike("nombre", "%" + search + "%")
                    ilike("apellido", "%" + search + "%")
                    ilike("login", "%" + search + "%")
                    unidad {
                        or {
                            ilike("nombre", "%" + search + "%")
                        }
                    }
                }
            }
//            println find
            def departamentos = []
            find.each { pers ->
                if (pers.unidad && !departamentos.contains(pers.unidad)) {
                    departamentos.add(pers.unidad)
                    def dep = pers.unidad
                    def padre = dep.padre
                    while (padre) {
                        dep = padre
                        padre = dep.padre
                        if (!departamentos.contains(dep)) {
                            departamentos.add(dep)
                        }
                    }
                }
            }
            departamentos = departamentos.reverse()
            def ids = "["
            if (find.size() > 0) {
                ids += "\"#root\","
                departamentos.each { dp ->
                    ids += "\"#lidep_" + dp.id + "\","
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
     * Acción llamada con ajax que permite realizar búsquedas en el árbol de proyectos
     */
    def arbolSearchProy_ajax() {
        def search = params.str.trim()
        if (search != "") {
            def c = Proyecto.createCriteria()
            def find = c.list(params) {
                or {
                    ilike("nombre", "%" + search + "%")
                    ilike("codigo", "%" + search + "%")
                    unidadEjecutora {
                        or {
                            ilike("nombre", "%" + search + "%")
                        }
                    }
                }
            }
//            println find
            def departamentos = []
            find.each { Proyecto proy ->
                if (proy.unidadEjecutora && !departamentos.contains(proy.unidadEjecutora)) {
                    departamentos.add(proy.unidadEjecutora)
                    def dep = proy.unidadEjecutora
                    def padre = dep.padre
                    while (padre) {
                        dep = padre
                        padre = dep.padre
                        if (!departamentos.contains(dep)) {
                            departamentos.add(dep)
                        }
                    }
                }
            }
            departamentos = departamentos.reverse()
            def ids = "["
            if (find.size() > 0) {
                ids += "\"#root\","
                departamentos.each { dp ->
                    ids += "\"#lidep_" + dp.id + "\","
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
     * Acción llamada con ajax que carga el árbol de la estructura institucional
     */
    def loadTreePart_ajax() {
        render(makeTreeNode(params))
    }

    /**
     * Acción llamada con ajax que carga el árbol de proyectos
     */
    def loadTreeProyPart_ajax() {
        render(makeTreeProyNode(params))
    }

    /**
     * Función que genera el string del nodo requerido para el árbol de la estructura institucional
     * @param params
     * @return String
     */
    def makeTreeNode(params) {
        def id = params.id
        if (!params.sort) {
            params.sort = "apellido"
        }
        if (!params.order) {
            params.order = "asc"
        }
        String tree = "", clase = "", rel = ""
        def padre
        def hijos = []

        if (id == "#") {
            //root
            def hh = UnidadEjecutora.countByPadreIsNull([sort: "nombre"])
            if (hh > 0) {
                clase = "hasChildren jstree-closed"
            }

            tree = "<li id='root' class='root ${clase}' data-jstree='{\"type\":\"root\"}' data-level='0' >" +
                    "<a href='#' class='label_arbol'>Estructura institucional</a>" +
                    "</li>"
            if (clase == "") {
                tree = ""
            }
        } else if (id == "root") {
            hijos = UnidadEjecutora.findAllByPadreIsNull([sort: 'orden'])
        } else {
            def parts = id.split("_")
            def node_id = parts[1].toLong()
            padre = UnidadEjecutora.get(node_id)
            if (padre) {
                hijos = []
                hijos += Persona.findAllByUnidad(padre, [sort: params.sort, order: params.order])
                hijos += UnidadEjecutora.findAllByPadre(padre, [sort: "nombre"])
            }
        }

        if (tree == "" && (padre || hijos.size() > 0)) {
            tree += "<ul>"
            def lbl = ""

            hijos.each { hijo ->
                def tp = ""
                def data = ""
                def ico = ""
                if (hijo instanceof UnidadEjecutora) {
                    lbl = hijo.nombre
                    if (hijo.codigo) {
                        lbl += " (${hijo.codigo})"
                    }
                    tp = "dep"
                    def hijosH = UnidadEjecutora.findAllByPadre(hijo, [sort: "nombre"])
                    if (hijo.padre) {
                        rel = (hijosH.size() > 0) ? "unidadPadre" : "unidadHijo"
                    } else {
                        rel = "yachay"
                    }

                    if (hijo.padre) {
                        if (!hijo.fechaFin || hijo.fechaFin > new Date()) {
                            rel += "Activo"
                        } else {
                            rel += "Inactivo"
                        }
                    }

                    hijosH += Persona.findAllByUnidad(hijo, [sort: "apellido"])
                    clase = (hijosH.size() > 0) ? "jstree-closed hasChildren" : ""
                    if (hijosH.size() > 0) {
                        clase += " ocupado "
                    }
                } else if (hijo instanceof Persona) {
                    switch (params.sort) {
                        case 'apellido':
                            lbl = "${hijo.apellido} ${hijo.nombre} ${hijo.login ? '(' + hijo.login + ')' : ''}"
                            break;
                        case 'nombre':
                            lbl = "${hijo.nombre} ${hijo.apellido} ${hijo.login ? '(' + hijo.login + ')' : ''}"
                            break;
                        default:
                            lbl = "${hijo.apellido} ${hijo.nombre} ${hijo.login ? '(' + hijo.login + ')' : ''}"
                    }

                    if (hijo.esDirector) {
                        ico = ", \"icon\":\"fa fa-user-secret text-warning\""
                    } else if (hijo.esGerente) {
                        ico = ", \"icon\":\"fa fa-user-secret text-danger\""
                    }

                    tp = "usu"
                    rel = "usuario"
                    clase = "usuario"

                    data += "data-usuario='${hijo.login}'"

                    if (hijo.estaActivo == 1) {
                        rel += "Activo"
                    } else {
                        rel += "Inactivo"
                    }
                }

                tree += "<li id='li${tp}_" + hijo.id + "' class='" + clase + "' ${data} data-jstree='{\"type\":\"${rel}\" ${ico}}' >"
                tree += "<a href='#' class='label_arbol'>" + lbl + "</a>"
                tree += "</li>"
            }

            tree += "</ul>"
        }
//        println "arbol: $tree"
        return tree
    }

    /**
     * Función que genera el string del nodo requerido para el árbol de proyectos
     * @param params
     * @return String
     */
    def makeTreeProyNode(params) {
        def id = params.id

        String tree = "", clase = "", rel = ""
        def padre
        def hijos = []

        println "tree proy " + params

        if (id == "#") {
            //root
            def hh = UnidadEjecutora.countByPadreIsNull([sort: "nombre"])
            if (hh > 0) {
                clase = "hasChildren jstree-closed"
            }

            tree = "<li id='root' class='root ${clase}' data-jstree='{\"type\":\"root\"}' data-level='0' >" +
                    "<a href='#' class='label_arbol'>Entidades</a>" +
                    "</li>"
            if (clase == "") {
                tree = ""
            }
        } else if (id == "root") {
            hijos = UnidadEjecutora.findAllByPadreIsNull([sort: 'orden'])
//            hijos = Proyecto.findAllByUnidadEjecutora(padre)
        } else {
            def parts = id.split("_")
            def node_id = parts[1].toLong()
            padre = UnidadEjecutora.get(node_id)
            if (padre) {
//                hijos = []
//                hijos += Persona.findAllByUnidad(padre, [sort: params.sort, order: params.order])
//                hijos += UnidadEjecutora.findAllByPadre(padre, [sort: "nombre"])
                hijos = Proyecto.findAllByUnidadEjecutora(padre, [sort: "nombre"])
            }
        }

        if (tree == "" && (padre || hijos.size() > 0)) {
            tree += "<ul>"
            def lbl = ""

            hijos.each { hijo ->
                def tp = ""
                def data = ""
                if (hijo instanceof UnidadEjecutora) {
                    lbl = hijo.nombre
                    if (hijo.codigo) {
                        lbl += " (${hijo.codigo})"
                    }
                    tp = "dep"
                    def hijosH = UnidadEjecutora.findAllByPadre(hijo, [sort: "nombre"])
                    if (hijo.padre) {
                        rel = (hijosH.size() > 0) ? "unidadPadre" : "unidadHijo"
                    } else {
                        rel = "yachay"
                    }

                    if (hijo.padre) {
                        if (!hijo.fechaFin || hijo.fechaFin > new Date()) {
                            rel += "Activo"
                        } else {
                            rel += "Inactivo"
                        }
                    }

                    hijosH += Persona.findAllByUnidad(hijo, [sort: "apellido"])
                    clase = (hijosH.size() > 0) ? "jstree-closed hasChildren" : ""
                    if (hijosH.size() > 0) {
                        clase += " ocupado "
                    }
                } else if (hijo instanceof Proyecto) {
                    lbl = hijo.nombre
                    if (hijo.codigo) {
                        lbl += " (${hijo.codigo})"
                    }
                    tp = "proy"
                    rel = "proy"
                    clase = ""
                }

                tree += "<li id='li${tp}_" + hijo.id + "' class='" + clase + "' ${data} data-jstree='{\"type\":\"${rel}\"}' >"
                tree += "<a href='#' class='label_arbol'>" + lbl + "</a>"
                tree += "</li>"
            }

            tree += "</ul>"
        }
        return tree
    }

    /**
     * Acción llamada con ajax que carga el presupuesto de la entidad
     */
    def presupuestoEntidad_ajax() {
        def unidad = UnidadEjecutora.get(params.id)
        return [unidad: unidad]
    }

    /**
     * Acción llamada con ajax que busca el presupuesto de un año de una unidad ejecutora
     * @param anio el id del año
     * @param unidad el id de la unidad
     */
    def getPresupuestoAnio_ajax() {
        def anio = Anio.get(params.anio)
        def unidad = UnidadEjecutora.get(params.unidad)
        def presupuesto = PresupuestoUnidad.findByAnioAndUnidad(anio, unidad)
        def str = (presupuesto ? g.formatNumber(number: presupuesto.maxInversion, maxFractionDigits: 2, minFractionDigits: 2) : '0,00')
        str += "_"
        str += (presupuesto ? g.formatNumber(number: presupuesto?.originalCorrientes, maxFractionDigits: 2, minFractionDigits: 2) : '0,00')
        render(str)
    }

    /**
     * Acción llamada con ajax que guarda las modificaciones del presupuesto anual de una unidad ejecutora
     */
    def savePresupuestoEntidad_ajax() {
        def unidad = UnidadEjecutora.get(params.unidad)
        def anio = Anio.get(params.anio)
        def inversion = params.maxInversion
        def corrientes = params.maxCorrientes
        def originalCorrientes = params.originalCorrientes
        def originalInversion = params.originalInversion

        if (!inversion) inversion = 0
        if (!corrientes) corrientes = 0
        if (!originalInversion) originalInversion = 0
        if (!originalCorrientes) originalCorrientes = 0

        inversion = (inversion.toString().replaceAll(",", "")).toDouble()
        corrientes = (corrientes.toString().replaceAll(",", "")).toDouble()
        originalInversion = (originalInversion.toString().replaceAll(",", "")).toDouble()
        originalCorrientes = (originalCorrientes.toString().replaceAll(",", "")).toDouble()

        // se pone valores originales d einversión y corrientes solo cuando estos son ceros
        if(inversion > 0 && originalInversion == 0) {
            originalInversion = inversion
        }
        if(corrientes > 0 && originalCorrientes == 0) {
            originalCorrientes = corrientes
        }

        def presupuestoUnidad = PresupuestoUnidad.findAllByUnidadAndAnio(unidad, anio)
        if (presupuestoUnidad.size() == 1) {
            presupuestoUnidad = presupuestoUnidad.first()
        } else if (presupuestoUnidad.size() == 0) {
            presupuestoUnidad = new PresupuestoUnidad()
            presupuestoUnidad.unidad = unidad
            presupuestoUnidad.anio = anio
        } else {
            println "Hay ${presupuestoUnidad.size()} presupuestos para el anio ${anio.anio}, unidad ${unidad.codigo}"
            presupuestoUnidad = presupuestoUnidad.first()
        }
        presupuestoUnidad.maxCorrientes = corrientes
        presupuestoUnidad.originalCorrientes = originalCorrientes
        presupuestoUnidad.originalInversion = originalInversion
        presupuestoUnidad.maxInversion = inversion

        if (!presupuestoUnidad.save(flush: true)) {
            render "ERROR*" + renderErrors(bean: presupuestoUnidad)
        } else {
            render "SUCCESS*Presupuesto modificado exitosamente"
        }
    }

    /**
     * Acción llamada con ajax que carga los techos
     */
    def modificarPresupuesto_ajax() {
        def unidad = UnidadEjecutora.get(params.id)
        def actual
        if (params.anio) {
            actual = Anio.get(params.anio)
        } else {
            actual = Anio.findByAnio(new Date().format("yyyy"))
        }
        def techo = PresupuestoUnidad.findByUnidadAndAnio(unidad, actual)
        [unidad: unidad, techo: techo, actual: actual]
    }

    def saveModificarPresupuesto_ajax() {
        def techo = PresupuestoUnidad.get(params.id)
        params.inversiones = (params.inversiones.toString().replaceAll(",", "")).toDouble()
        // hacer un bloque idéntico para modificaciones de corrientes
        if (techo.maxInversion != params.inversiones) {
            def mod = new ModificacionTechos()
            mod.desde = techo
            mod.fecha = new Date()
            mod.tipo = 4
            mod.usuario = session.usuario
            mod.valor = params.inversiones.toDouble() - techo.maxInversion
            if (mod.save(flush: true)) {
                techo.maxInversion = params.inversiones.toDouble()
                if (techo.save(flush: true)) {
                    render "SUCCESS*Persupuesto modificado exitosamente"
                } else {
                    render "ERROR*" + renderErrors(bean: techo)
                }
            } else {
                render "ERROR*" + renderErrors(bean: mod)
            }
        } else {
            render "ERROR*No se ha modificao el valor del máximo de inversión, sigue igual a " +
                    g.formatNumber(number: params.inversiones.toDouble(), maxFractionDigits: 2, minFractionDigits: 2)
        }
    }

    def arbol_asg() {

    }
}
