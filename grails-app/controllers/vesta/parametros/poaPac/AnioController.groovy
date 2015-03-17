package vesta.parametros.poaPac

import org.springframework.dao.DataIntegrityViolationException
import vesta.parametros.UnidadEjecutora
import vesta.poa.Asignacion
import vesta.proyectos.Proyecto
import vesta.seguridad.Shield


/**
 * Controlador que muestra las pantallas de manejo de Anio
 */
class AnioController extends Shield {

    static allowedMethods = [save_ajax: "POST", delete_ajax: "POST"]
    def dbConnectionService
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
            def c = Anio.createCriteria()
            list = c.list(params) {
                or {
                    /* TODO: cambiar aqui segun sea necesario */

                    ilike("anio", "%" + params.search + "%")
                }
            }
        } else {
            list = Anio.list(params)
        }
        if (!all && params.offset.toInteger() > 0 && list.size() == 0) {
            params.offset = params.offset.toInteger() - 1
            list = getList(params, all)
        }
        return list
    }

    /**
     * Acción que muestra la lista de elementos
     * @return anioInstanceList: la lista de elementos filtrados, anioInstanceCount: la cantidad total de elementos (sin máximo)
     */
    def list() {
        def anioInstanceList = getList(params, false)
        def anioInstanceCount = getList(params, true).size()
        return [anioInstanceList: anioInstanceList, anioInstanceCount: anioInstanceCount]
    }

    /**
     * Acción llamada con ajax que muestra la información de un elemento particular
     * @return anioInstance el objeto a mostrar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def show_ajax() {
        if (params.id) {
            def anioInstance = Anio.get(params.id)
            if (!anioInstance) {
                render "ERROR*No se encontró Año."
                return
            }
            return [anioInstance: anioInstance]
        } else {
            render "ERROR*No se encontró Año."
        }
    } //show para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que muestra un formulario para crear o modificar un elemento
     * @return anioInstance el objeto a modificar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def form_ajax() {
        def anioInstance = new Anio()
        if (params.id) {
            anioInstance = Anio.get(params.id)
            if (!anioInstance) {
                render "ERROR*No se encontró Año."
                return
            }
        }
        anioInstance.properties = params
        return [anioInstance: anioInstance]
    } //form para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que guarda la información de un elemento
     * @render ERROR*[mensaje] cuando no se pudo grabar correctamente, SUCCESS*[mensaje] cuando se grabó correctamente
     */
    def save_ajax() {
        def anioInstance = new Anio()
        if (params.id) {
            anioInstance = Anio.get(params.id)
            if (!anioInstance) {
                render "ERROR*No se encontró Año."
                return
            }
        }
        anioInstance.properties = params
        if (!anioInstance.save(flush: true)) {
            render "ERROR*Ha ocurrido un error al guardar Año: " + renderErrors(bean: anioInstance)
            return
        }
        render "SUCCESS*${params.id ? 'Actualización' : 'Creación'} de Año exitosa."
        return
    } //save para grabar desde ajax

    /**
     * Acción llamada con ajax que permite eliminar un elemento
     * @render ERROR*[mensaje] cuando no se pudo eliminar correctamente, SUCCESS*[mensaje] cuando se eliminó correctamente
     */
    def delete_ajax() {
        if (params.id) {
            def anioInstance = Anio.get(params.id)
            if (!anioInstance) {
                render "ERROR*No se encontró Año."
                return
            }
            try {
                anioInstance.delete(flush: true)
                render "SUCCESS*Eliminación de Año exitosa."
                return
            } catch (DataIntegrityViolationException e) {
                render "ERROR*Ha ocurrido un error al eliminar Año"
                return
            }
        } else {
            render "ERROR*No se encontró Año."
            return
        }
    } //delete para eliminar via ajax

    /*Yachay */

    /*Vista para la aprobación de una proforma dependiendo el año*/

    def vistaAprobarAño() {
        def anios = Anio.findAllByEstado(0)
        [anios: anios]
    }

    /*Vista para la aprobación de una proforma dependiendo el año*/

    def vistaAprobarAnioUnidad() {
        def anios = Anio.findAllByEstado(0)
        [anios: anios]
    }
    /**
     * Acción
     */
    def aprobarAnio() {
        if (request.method == 'POST') {

            def anio = Anio.get(params.anio)
            anio.estado = 1
            anio.save(flush: true)
            Asignacion.executeUpdate("UPDATE Asignacion SET priorizado=planificado WHERE anio=${anio.id}")
            flash.message = "Las asignaciones del año ${anio.anio} han sido aprobadas."
            render "ok"

        } else {
            redirect(controller: "shield", action: "ataques")
        }
    }

    /**
     * Acción
     */
    def detalleAnio() {
        def anio = Anio.get(params.anio)
        def proyectos = Proyecto.list([sort: "codigo"])

        def arr = []
        def total = 0
        proyectos.each { proy ->
            def tot = proy.getValorPlanificado()
            def m = [:]
            m.proyecto = proy
            m.total = tot
            arr += m
            total += tot
        }

        arr = arr.sort { -it.total }

        return [anio: anio, arr: arr, total: total]
    }

    /**
     * Acción
     */
    def detalleAnioUnidad() {
        def anio = Anio.get(params.anio)
        def unidades = UnidadEjecutora.list([sort: "nombre"])
        def cn = dbConnectionService.getConnection()
        def datos = [:]
        unidades.each {
            def temp = []
            cn.eachRow("select count(asgn__id) as cont,sum(asgnplan) as suma from asgn where unej__id=${it.id} and anio__id = ${anio.id} and mrlg__id is not null ") { d ->
                if (d.suma == null)
                    temp.add(0)
                else
                    temp.add(d.suma.toFloat().round(2))
                if (d.cont == null)
                    temp.add(0)
                else
                    temp.add(d.cont)
            }
            cn.eachRow("select count(obra__id) as cont,sum(obracntd*obracsto) as suma from obra,asgn where asgn.asgn__id=obra.asgn__id and   asgn.unej__id=${it.id} and asgn.anio__id = ${anio.id} and asgn.mrlg__id is not null ") { d ->
                if (d.suma == null)
                    temp.add(0)
                else
                    temp.add(d.suma.toFloat().round(2))
                if (d.cont == null)
                    temp.add(0)
                else
                    temp.add(d.cont)
            }

            cn.eachRow("select count(asgn__id) as cont,sum(asgnplan) as suma from asgn where unej__id=${it.id} and anio__id = ${anio.id} ") { d ->
                if (d.suma == null)
                    temp.add(0)
                else
                    temp.add(d.suma.toFloat().round(2))
                if (d.cont == null)
                    temp.add(0)
                else
                    temp.add(d.cont)
            }
            cn.eachRow("select count(obra__id) as cont,sum(obracntd*obracsto) as suma from obra,asgn where asgn.asgn__id=obra.asgn__id and   asgn.unej__id=${it.id} and asgn.anio__id = ${anio.id}  ") { d ->
                if (d.suma == null)
                    temp.add(0)
                else
                    temp.add(d.suma.toFloat().round(2))
                if (d.cont == null)
                    temp.add(0)
                else
                    temp.add(d.cont)
            }
            temp.add(it.id)
            if ((temp[0] + temp[2] + temp[4] + temp[6]) > 0)
                datos.put(it.nombre, temp)
            temp = []

        }

        cn.close()

        [datos: datos, anio: anio]
    }
}
