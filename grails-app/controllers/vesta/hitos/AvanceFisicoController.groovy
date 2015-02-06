package vesta.hitos

import org.springframework.dao.DataIntegrityViolationException
import vesta.avales.ProcesoAval
import vesta.seguridad.Shield


/**
 * Controlador que muestra las pantallas de manejo de AvanceFisico
 */
class AvanceFisicoController extends Shield {

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
            def c = AvanceFisico.createCriteria()
            list = c.list(params) {
                or {
                    /* TODO: cambiar aqui segun sea necesario */

                    ilike("observaciones", "%" + params.search + "%")
                }
            }
        } else {
            list = AvanceFisico.list(params)
        }
        if (!all && params.offset.toInteger() > 0 && list.size() == 0) {
            params.offset = params.offset.toInteger() - 1
            list = getList(params, all)
        }
        return list
    }

    /**
     * Acción que muestra la lista de elementos
     * @return avanceFisicoInstanceList: la lista de elementos filtrados, avanceFisicoInstanceCount: la cantidad total de elementos (sin máximo)
     */
    def list() {
//        def avanceFisicoInstanceList = getList(params, false)
//        def avanceFisicoInstanceCount = getList(params, true).size()
//        return [avanceFisicoInstanceList: avanceFisicoInstanceList, avanceFisicoInstanceCount: avanceFisicoInstanceCount]
        def proceso = ProcesoAval.get(params.id)
        def ultimoAvance = AvanceFisico.findAllByProceso(proceso, [sort: "fecha", order: "desc"])
        def minAvance = 0
        def minDate = "";
        if (ultimoAvance.size() > 0) {
            def ua = ultimoAvance.first()
            minAvance = ua.avance
            minDate = (ua.fecha + 1).format("dd-MM-yyyy")
        }
        def maxAvance = 100 - minAvance

        def totalAvance = AvanceFisico.findAllByProceso(proceso)
        if (totalAvance.size() > 0) {
            totalAvance = totalAvance.sum { it.avance }
        } else {
            totalAvance = 0
        }
        maxAvance = 100 - totalAvance

        def tot = 0
        AvanceFisico.findAllByProceso(proceso).each {
            println "\t" + it.avance
            tot += it.avance
        }
        println "????? " + tot

        println ">>>>>>>>>>>>>>> " + totalAvance + " max " + maxAvance

        return [proceso: proceso, minAvance: minAvance, maxAvance: maxAvance, minDate: minDate]
    }

    /**
     * Acción cargada con ajax que retorna la lista de avances físicos de un proceso
     */
    def avanceFisicoProceso_ajax = {
        def proceso = ProcesoAval.get(params.id)
        def avances = AvanceFisico.findAllByProceso(proceso, [sort: "inicio"])
        println "AQUI::::: "+avances
        return [proceso: proceso, avances: avances]
    }


    /**
     * Acción llamada con ajax que agrega un avance físico a un proceso
     */
    def addAvanceFisicoProceso_ajax = {
//        println("params add " + params)
        def proceso = ProcesoAval.get(params.id)
        def avance = new AvanceFisico()
        params.inicio = new Date().parse("dd-MM-yyyy", params.inicio)
        params.fin = new Date().parse("dd-MM-yyyy", params.fin)
        params.avance = params.avance.toString().toDouble()
        avance.properties = params
        avance.proceso = proceso
        if (avance.save(flush: true)) {
            def max = 100 - avance.avance
            def totalAvance = AvanceFisico.findAllByProceso(proceso).sum { it.avance }
            max = 100 - totalAvance
            def minDate = (avance.fecha + 1).format("dd-MM-yyyy")
            render "SUCCESS*Nueva subactividad agregada exitosamente"
        } else {
            render "ERROR*No se pudo agregar la nueva subactividad."
        }
    }


    def agregarAvance = {
        def avance = AvanceFisico.get(params.id)
        def av = new AvanceAvance()
        av.avanceFisico = avance
        av.avance = params.avance.toDouble()
        av.descripcion = params.desc
        av.save(flush: true)
        render "ok"
    }


    def detalleAv = {
        def av = AvanceFisico.get(params.id)
        def busqueda =  AvanceAvance.findAllByAvanceFisico(av, [sort: "id"])
        [av: av, avances: busqueda]
    }

    def agregarSubact = {
        println("params " + params)
        def proceso = ProcesoAval.get(params.id)
        def fechaHoy = new Date().format("dd-MM-yyyy")
        [proceso: proceso, fechaHoy: fechaHoy]
    }


    /**
     * Acción llamada con ajax que elimina un avance físico a un proceso
     */
    def deleteAvanceFisicoProceso_ajax = {
        def avance = AvanceFisico.get(params.id)
        def proceso = avance.proceso
        try {
            avance.delete(flush: true)

            def ultimoAvance = AvanceFisico.findAllByProceso(proceso, [sort: "fecha", order: "desc"])
            def minAvance = 0
            def minDate = "";
            if (ultimoAvance.size() > 0) {
                def ua = ultimoAvance.first()
                minAvance = ua.avance
                minDate = (ua.fecha + 1).format("dd-MM-yyyy")
            }
            def maxAvance = 100 - minAvance
            def totalAvance = AvanceFisico.findAllByProceso(proceso).sum { it.avance }
            maxAvance = 100 - totalAvance
            render "OK_" + minAvance + "_" + maxAvance + "_" + minDate
        } catch (Exception e) {
            e.printStackTrace()
            render "NO"
        }
    }

    def completar = {
        def avance = AvanceFisico.get(params.id)
        avance.completado = new Date()
        avance.save(flash: true)
        render "OK"
    }


    /**
     * Acción llamada con ajax que muestra la información de un elemento particular
     * @return avanceFisicoInstance el objeto a mostrar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
//    def show_ajax() {
//        if (params.id) {
//            def avanceFisicoInstance = AvanceFisico.get(params.id)
//            if (!avanceFisicoInstance) {
//                render "ERROR*No se encontró AvanceFisico."
//                return
//            }
//            return [avanceFisicoInstance: avanceFisicoInstance]
//        } else {
//            render "ERROR*No se encontró AvanceFisico."
//        }
//    } //show para cargar con ajax en un dialog
//
//    /**
//     * Acción llamada con ajax que muestra un formulario para crear o modificar un elemento
//     * @return avanceFisicoInstance el objeto a modificar cuando se encontró el elemento
//     * @render ERROR*[mensaje] cuando no se encontró el elemento
//     */
//    def form_ajax() {
//        def avanceFisicoInstance = new AvanceFisico()
//        if (params.id) {
//            avanceFisicoInstance = AvanceFisico.get(params.id)
//            if (!avanceFisicoInstance) {
//                render "ERROR*No se encontró AvanceFisico."
//                return
//            }
//        }
//        avanceFisicoInstance.properties = params
//        return [avanceFisicoInstance: avanceFisicoInstance]
//    } //form para cargar con ajax en un dialog
//
//    /**
//     * Acción llamada con ajax que guarda la información de un elemento
//     * @render ERROR*[mensaje] cuando no se pudo grabar correctamente, SUCCESS*[mensaje] cuando se grabó correctamente
//     */
//    def save_ajax() {
//        def avanceFisicoInstance = new AvanceFisico()
//        if (params.id) {
//            avanceFisicoInstance = AvanceFisico.get(params.id)
//            if (!avanceFisicoInstance) {
//                render "ERROR*No se encontró AvanceFisico."
//                return
//            }
//        }
//        avanceFisicoInstance.properties = params
//        if (!avanceFisicoInstance.save(flush: true)) {
//            render "ERROR*Ha ocurrido un error al guardar AvanceFisico: " + renderErrors(bean: avanceFisicoInstance)
//            return
//        }
//        render "SUCCESS*${params.id ? 'Actualización' : 'Creación'} de AvanceFisico exitosa."
//        return
//    } //save para grabar desde ajax
//
//    /**
//     * Acción llamada con ajax que permite eliminar un elemento
//     * @render ERROR*[mensaje] cuando no se pudo eliminar correctamente, SUCCESS*[mensaje] cuando se eliminó correctamente
//     */
//    def delete_ajax() {
//        if (params.id) {
//            def avanceFisicoInstance = AvanceFisico.get(params.id)
//            if (!avanceFisicoInstance) {
//                render "ERROR*No se encontró AvanceFisico."
//                return
//            }
//            try {
//                avanceFisicoInstance.delete(flush: true)
//                render "SUCCESS*Eliminación de AvanceFisico exitosa."
//                return
//            } catch (DataIntegrityViolationException e) {
//                render "ERROR*Ha ocurrido un error al eliminar AvanceFisico"
//                return
//            }
//        } else {
//            render "ERROR*No se encontró AvanceFisico."
//            return
//        }
//    } //delete para eliminar via ajax

}
