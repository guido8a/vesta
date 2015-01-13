package vesta.proyectos

import org.springframework.dao.DataIntegrityViolationException
import vesta.parametros.TipoElemento
import vesta.poa.Asignacion
import vesta.seguridad.Shield


/**
 * Controlador que muestra las pantallas de manejo de MarcoLogico
 */
class MarcoLogicoController extends Shield {

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
            def c = MarcoLogico.createCriteria()
            list = c.list(params) {
                or {
                    /* TODO: cambiar aqui segun sea necesario */

                    ilike("numeroComp", "%" + params.search + "%")
                    ilike("objeto", "%" + params.search + "%")
                    ilike("tieneAsignacion", "%" + params.search + "%")
                }
            }
        } else {
            list = MarcoLogico.list(params)
        }
        if (!all && params.offset.toInteger() > 0 && list.size() == 0) {
            params.offset = params.offset.toInteger() - 1
            list = getList(params, all)
        }
        return list
    }

    /**
     * Acción que muestra la lista de elementos
     * @return marcoLogicoInstanceList: la lista de elementos filtrados, marcoLogicoInstanceCount: la cantidad total de elementos (sin máximo)
     */
    def list() {
        def marcoLogicoInstanceList = getList(params, false)
        def marcoLogicoInstanceCount = getList(params, true).size()
        return [marcoLogicoInstanceList: marcoLogicoInstanceList, marcoLogicoInstanceCount: marcoLogicoInstanceCount]
    }

    /**
     * Acción llamada con ajax que muestra la información de un elemento particular
     * @return marcoLogicoInstance el objeto a mostrar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def show_ajax() {
        if (params.id) {
            def marcoLogicoInstance = MarcoLogico.get(params.id)
            if (!marcoLogicoInstance) {
                render "ERROR*No se encontró MarcoLogico."
                return
            }
            return [marcoLogicoInstance: marcoLogicoInstance]
        } else {
            render "ERROR*No se encontró MarcoLogico."
        }
    } //show para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que muestra un formulario para crear o modificar un elemento
     * @return marcoLogicoInstance el objeto a modificar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def form_ajax() {
        def marcoLogicoInstance = new MarcoLogico()
        if (params.id) {
            marcoLogicoInstance = MarcoLogico.get(params.id)
            if (!marcoLogicoInstance) {
                render "ERROR*No se encontró MarcoLogico."
                return
            }
        }
        marcoLogicoInstance.properties = params
        return [marcoLogicoInstance: marcoLogicoInstance]
    } //form para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que guarda la información de un elemento
     * @render ERROR*[mensaje] cuando no se pudo grabar correctamente, SUCCESS*[mensaje] cuando se grabó correctamente
     */
    def save_ajax() {
        def marcoLogicoInstance = new MarcoLogico()
        if (params.id) {
            marcoLogicoInstance = MarcoLogico.get(params.id)
            if (!marcoLogicoInstance) {
                render "ERROR*No se encontró MarcoLogico."
                return
            }
        }
        marcoLogicoInstance.properties = params
        if (!marcoLogicoInstance.save(flush: true)) {
            render "ERROR*Ha ocurrido un error al guardar MarcoLogico: " + renderErrors(bean: marcoLogicoInstance)
            return
        }
        render "SUCCESS*${params.id ? 'Actualización' : 'Creación'} de MarcoLogico exitosa."
        return
    } //save para grabar desde ajax

    /**
     * Acción llamada con ajax que permite eliminar un elemento
     * @render ERROR*[mensaje] cuando no se pudo eliminar correctamente, SUCCESS*[mensaje] cuando se eliminó correctamente
     */
    def delete_ajax() {
        if (params.id) {
            def marcoLogicoInstance = MarcoLogico.get(params.id)
            if (!marcoLogicoInstance) {
                render "ERROR*No se encontró MarcoLogico."
                return
            }
            try {
                marcoLogicoInstance.delete(flush: true)
                render "SUCCESS*Eliminación de MarcoLogico exitosa."
                return
            } catch (DataIntegrityViolationException e) {
                render "ERROR*Ha ocurrido un error al eliminar MarcoLogico"
                return
            }
        } else {
            render "ERROR*No se encontró MarcoLogico."
            return
        }
    } //delete para eliminar via ajax

    /**
     * Acción que muestra el marco lógico de un proyecto
     */
    def marcoLogicoProyecto() {
        def proyecto = Proyecto.get(params.id.toLong())

        def tipoElementoFin = TipoElemento.findByDescripcion("Fin")
        def tipoElementoProposito = TipoElemento.findByDescripcion("Proposito")
        def tipoElementoComponente = TipoElemento.findByDescripcion("Componente")

        def fin = MarcoLogico.withCriteria {
            eq("proyecto", proyecto)
            eq("tipoElemento", tipoElementoFin)
            eq("estado", 0)
        }
        def proposito = MarcoLogico.withCriteria {
            eq("proyecto", proyecto)
            eq("tipoElemento", tipoElementoProposito)
            eq("estado", 0)
        }
        def componentes = MarcoLogico.withCriteria {
            eq("proyecto", proyecto)
            eq("tipoElemento", tipoElementoComponente)
            eq("estado", 0)
            order("id", "asc")
        }

        if (!params.show) {
            params.show = 0
        }

        return [fin: fin, proposito: proposito, proyecto: proyecto, componentes: componentes, params: params]
    }

    /**
     * Acción llamada con ajax que muestra un formulario para crear o modificar un componente
     * @return marcoLogicoInstance el objeto a modificar cuando se encontró el componente
     * @render ERROR*[mensaje] cuando no se encontró el componente
     */
    def form_componente_ajax() {
//        println "Form componente: " + params
        def marcoLogicoInstance = new MarcoLogico()
        if (params.id) {
            marcoLogicoInstance = MarcoLogico.get(params.id)
            if (!marcoLogicoInstance) {
                render "ERROR*No se encontró Componente."
                return
            }
        }
        marcoLogicoInstance.properties = params
        return [marcoLogicoInstance: marcoLogicoInstance, show: params.show]
    }

    /**
     * Acción llamada con ajax que guarda la información de un componente
     * @render ERROR*[mensaje] cuando no se pudo grabar correctamente, SUCCESS*[mensaje] cuando se grabó correctamente
     */
    def save_componente_ajax() {
        def marcoLogicoInstance = new MarcoLogico()
        if (params.id) {
            marcoLogicoInstance = MarcoLogico.get(params.id)
            if (!marcoLogicoInstance) {
                render "ERROR*No se encontró Componente."
                return
            }
        }
        marcoLogicoInstance.properties = params
        if (!marcoLogicoInstance.save(flush: true)) {
            render "ERROR*Ha ocurrido un error al guardar Componente: " + renderErrors(bean: marcoLogicoInstance)
            return
        }
        render "SUCCESS*${params.id ? 'Actualización' : 'Creación'} de Componente exitosa."
        return
    } //save para grabar desde ajax

    /**
     * Acción llamada con ajax que permite eliminar un componente
     * @render ERROR*[mensaje] cuando no se pudo eliminar correctamente, SUCCESS*[mensaje] cuando se eliminó correctamente
     */
    def delete_marcoLogico_ajax() {
        def tipo = "Componente"
        if (params.tipo == "act") {
            tipo = "Actividad"
        }
        if (request.method == 'POST') {
            if (params.id) {
                def marcoLogicoInstance = MarcoLogico.get(params.id)
                if (!marcoLogicoInstance) {
                    render "ERROR*No se encontró " + tipo
                    return
                }
                try {
                    def control = MarcoLogico.findAllByMarcoLogico(marcoLogicoInstance).size()
                    control += Meta.findAllByMarcoLogico(marcoLogicoInstance).size()
                    control += Asignacion.findAllByMarcoLogico(marcoLogicoInstance).size()
                    if (control < 1) {
                        def indicadores = Indicador.findAllByMarcoLogico(marcoLogicoInstance)
                        indicadores.each { indi ->
                            MedioVerificacion.findAllByIndicador(indi).each { m ->
                                m.delete(flush: true)
                            }
                            indi.delete(flush: true)
                        }
                        Supuesto.findAllByMarcoLogico(marcoLogicoInstance).each { sup ->
                            sup.delete(flush: true)
                        }

                        marcoLogicoInstance.delete(flush: true)
                        render "SUCCESS*Eliminación de ${tipo} exitosa."
                    } else {
                        if (params.tipo == "comp") {
                            render "ERROR*El componente tiene actividades, metas o asignaciones por lo que no puede ser eliminado"
                        } else {
                            render "ERROR*La actividad tiene metas o asignaciones por lo que no puede ser eliminada"
                        }
                    }
                    return
                } catch (DataIntegrityViolationException e) {
                    render "ERROR*Ha ocurrido un error al eliminar " + tipo
                    return
                }
            } else {
                render "ERROR*No se encontró " + tipo
                return
            }
        } else {
            redirect(controller: "shield", action: "unauthorized")
        }
    }

    /**
     * Acción llamada con ajax que muestra un formulario para crear o modificar una actividad
     * @return marcoLogicoInstance el objeto a modificar cuando se encontró la actividad
     * @render ERROR*[mensaje] cuando no se encontró la actividad
     */
    def form_actividad_ajax() {
//        println "Form actividad: " + params
        def marcoLogicoInstance = new MarcoLogico()
        def totComp = 0
        def totFin = 0
        def totOtros = 0
        if (params.id) {
            marcoLogicoInstance = MarcoLogico.get(params.id)
            if (!marcoLogicoInstance) {
                render "ERROR*No se encontró Actividad."
                return
            }
        }
        marcoLogicoInstance.properties = params

        if (marcoLogicoInstance.marcoLogico) {
            def marcoLogico = marcoLogicoInstance.marcoLogico
            def actividades = MarcoLogico.findAllByMarcoLogicoAndEstado(marcoLogico, 0, [sort: "id"])
            actividades.each {
                totComp += it.monto
            }
            def proyecto = marcoLogico.proyecto
            Financiamiento.findAllByProyecto(proyecto).each {
                totFin += it.monto
            }
            MarcoLogico.withCriteria {
                eq("tipoElemento", TipoElemento.get(2))
                eq("proyecto", proyecto)
                eq("estado", 0)
                order("id", "asc")
            }.each {
                if (it.id.toLong() != marcoLogico.id.toLong()) {
                    MarcoLogico.findAllByMarcoLogicoAndEstado(it, 0, [sort: "id"]).each { ac ->
                        totOtros += ac.monto
                    }
                }
            }
        }

        return [marcoLogicoInstance: marcoLogicoInstance, show: params.show, totComp: totComp, totFin: totFin, totOtros: totOtros]
    }

    /**
     * Acción llamada con ajax que guarda la información de una actividad
     * @render ERROR*[mensaje] cuando no se pudo grabar correctamente, SUCCESS*[mensaje] cuando se grabó correctamente
     */
    def save_actividad_ajax() {
        def marcoLogicoInstance = new MarcoLogico()
        if (params.id) {
            marcoLogicoInstance = MarcoLogico.get(params.id)
            if (!marcoLogicoInstance) {
                render "ERROR*No se encontró Actividad."
                return
            }
        } else {
            def maxNum = MarcoLogico.list([sort: "numero", order: "desc", max: 1])
            if (maxNum.size() > 0) {
                maxNum = maxNum?.pop()?.numero
                if (maxNum)
                    maxNum = maxNum + 1
            } else {
                maxNum = 1
            }
            marcoLogicoInstance.numero = maxNum
        }
        marcoLogicoInstance.properties = params
        if (!marcoLogicoInstance.save(flush: true)) {
            render "ERROR*Ha ocurrido un error al guardar Actividad: " + renderErrors(bean: marcoLogicoInstance)
            return
        }
        render "SUCCESS*${params.id ? 'Actualización' : 'Creación'} de Actividad exitosa."
        return

    }
}
