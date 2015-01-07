package vesta.poa

import org.springframework.dao.DataIntegrityViolationException
import vesta.parametros.PresupuestoUnidad
import vesta.parametros.UnidadEjecutora
import vesta.parametros.poaPac.Anio
import vesta.proyectos.MarcoLogico
import vesta.proyectos.Proyecto
import vesta.seguridad.Shield


/**
 * Controlador que muestra las pantallas de manejo de Asignacion
 */
class AsignacionController extends Shield {

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
            def c = Asignacion.createCriteria()
            list = c.list(params) {
                or {
                    /* TODO: cambiar aqui segun sea necesario */

                    ilike("actividad", "%" + params.search + "%")
                    ilike("indicador", "%" + params.search + "%")
                    ilike("meta", "%" + params.search + "%")
                    ilike("reubicada", "%" + params.search + "%")
                }
            }
        } else {
            list = Asignacion.list(params)
        }
        if (!all && params.offset.toInteger() > 0 && list.size() == 0) {
            params.offset = params.offset.toInteger() - 1
            list = getList(params, all)
        }
        return list
    }

    /**
     * Acción que muestra la lista de elementos
     * @return asignacionInstanceList: la lista de elementos filtrados, asignacionInstanceCount: la cantidad total de elementos (sin máximo)
     */
    def list() {
        def asignacionInstanceList = getList(params, false)
        def asignacionInstanceCount = getList(params, true).size()
        return [asignacionInstanceList: asignacionInstanceList, asignacionInstanceCount: asignacionInstanceCount]
    }

    /**
     * Acción llamada con ajax que muestra la información de un elemento particular
     * @return asignacionInstance el objeto a mostrar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def show_ajax() {
        if (params.id) {
            def asignacionInstance = Asignacion.get(params.id)
            if (!asignacionInstance) {
                render "ERROR*No se encontró Asignacion."
                return
            }
            return [asignacionInstance: asignacionInstance]
        } else {
            render "ERROR*No se encontró Asignacion."
        }
    } //show para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que muestra un formaulario para crear o modificar un elemento
     * @return asignacionInstance el objeto a modificar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def form_ajax() {
        def asignacionInstance = new Asignacion()
        if (params.id) {
            asignacionInstance = Asignacion.get(params.id)
            if (!asignacionInstance) {
                render "ERROR*No se encontró Asignacion."
                return
            }
        }
        asignacionInstance.properties = params
        return [asignacionInstance: asignacionInstance]
    } //form para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que guarda la información de un elemento
     * @render ERROR*[mensaje] cuando no se pudo grabar correctamente, SUCCESS*[mensaje] cuando se grabó correctamente
     */
    def save_ajax() {
        def asignacionInstance = new Asignacion()
        if (params.id) {
            asignacionInstance = Asignacion.get(params.id)
            if (!asignacionInstance) {
                render "ERROR*No se encontró Asignacion."
                return
            }
        }
        asignacionInstance.properties = params
        if (!asignacionInstance.save(flush: true)) {
            render "ERROR*Ha ocurrido un error al guardar Asignacion: " + renderErrors(bean: asignacionInstance)
            return
        }
        render "SUCCESS*${params.id ? 'Actualización' : 'Creación'} de Asignacion exitosa."
        return
    } //save para grabar desde ajax

    /**
     * Acción llamada con ajax que permite eliminar un elemento
     * @render ERROR*[mensaje] cuando no se pudo eliminar correctamente, SUCCESS*[mensaje] cuando se eliminó correctamente
     */
    def delete_ajax() {
        if (params.id) {
            def asignacionInstance = Asignacion.get(params.id)
            if (!asignacionInstance) {
                render "ERROR*No se encontró Asignacion."
                return
            }
            try {
                asignacionInstance.delete(flush: true)
                render "SUCCESS*Eliminación de Asignacion exitosa."
                return
            } catch (DataIntegrityViolationException e) {
                render "ERROR*Ha ocurrido un error al eliminar Asignacion"
                return
            }
        } else {
            render "ERROR*No se encontró Asignacion."
            return
        }
    } //delete para eliminar via ajax


    /*Yachay  */
    def asignacionProyectov2 () {
        println "params " + params
        def proyecto = Proyecto.get(params.id)
        def asignaciones = []
        def actual

        def proyectosUnidad

        if (params.resp || params.comp) {
//            println("con filtro!"  + params.resp + " " + params.comp)

            def unidadE
            def compon

            if (params.resp) {
                unidadE = UnidadEjecutora.findByNombre(params.resp)
                if (params.anio)
                    actual = Anio.get(params.anio)
                else
                    actual = Anio.findByAnio(new Date().format("yyyy"))
                if (!actual)
                    actual = Anio.list([sort: 'anio', order: 'desc']).pop()

                def totalR = 0
                def totalUnidadR = 0
                def maxInvR = 0
                MarcoLogico.findAll("from MarcoLogico where proyecto = ${proyecto.id} and tipoElemento=3 and estado=0 and responsable=${unidadE.id}").each {
                    def asig = Asignacion.findAll("from Asignacion where marcoLogico=${it.id} and anio=${actual.id}  order by id")
                    if (asig) {
                        asignaciones += asig
                        asig.each { asg ->
                            totalR = totalR + asg.getValorReal()
                        }
                    }
                }
                asignaciones.sort { it.unidad.nombre }
                def unidad = UnidadEjecutora.findByPadreIsNull()
                maxInvR = PresupuestoUnidad.findByAnioAndUnidad(actual, unidad)?.maxInversion
                if (!maxInvR)
                    maxInvR = 0

                [asignaciones: asignaciones, actual: actual, proyecto: proyecto, total: totalR, totalUnidad: totalUnidadR, maxInv: maxInvR]

            } else {
                compon = MarcoLogico.findByObjeto(params.comp)
                if (params.anio)
                    actual = Anio.get(params.anio)
                else
                    actual = Anio.findByAnio(new Date().format("yyyy"))
                if (!actual)
                    actual = Anio.list([sort: 'anio', order: 'desc']).pop()

                def total = 0
                def totalUnidad = 0
                def maxInv = 0
                MarcoLogico.findAll("from MarcoLogico where proyecto = ${proyecto.id} and tipoElemento=3 and estado=0").each {
                    def asig = Asignacion.findAll("from Asignacion where marcoLogico=${it.id} and anio=${actual.id}   order by id")
                    if (asig) {
                        asignaciones += asig
                        asig.each { asg ->
                            total = total + asg.getValorReal()
                        }
                    }
                }
                asignaciones.sort { it.unidad.nombre }
                def unidad = UnidadEjecutora.findByPadreIsNull()
                maxInv = PresupuestoUnidad.findByAnioAndUnidad(actual, unidad)?.maxInversion
                if (!maxInv)
                    maxInv = 0
                [asignaciones: asignaciones, actual: actual, proyecto: proyecto, total: total, totalUnidad: totalUnidad, maxInv: maxInv]
            }


        } else {
            if (params.anio) {
                actual = Anio.get(params.anio)
            } else {
                actual = Anio.findByAnio(new Date().format('yyyy'))
            }

            if (!actual) {
                actual = Anio.list([sort: 'anio', order: 'desc']).pop()
            }


            def total = 0
            def totalUnidad = 0
            def maxInv = 0
            MarcoLogico.findAll("from MarcoLogico where proyecto = ${proyecto.id} and tipoElemento=3 and estado=0").each {
                def asig = Asignacion.findAll("from Asignacion where marcoLogico=${it.id} and anio=${actual.id}  order by id")
                if (asig) {
                    asignaciones += asig
//                    println "add " + asig.id + " " + asig.unidad
                    asig.each { asg ->
                        total = total + asg.getValorReal()
                    }
                }
            }

            asignaciones.sort { it.unidad.nombre }
            def unidad = UnidadEjecutora.findByPadreIsNull()
            maxInv = PresupuestoUnidad.findByAnioAndUnidad(actual, unidad)?.maxInversion
            if (!maxInv)
                maxInv = 0

            [asignaciones: asignaciones, actual: actual, proyecto: proyecto, total: total, totalUnidad: totalUnidad, maxInv: maxInv]

        }


    }









}
