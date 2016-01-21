package vesta.poa

import org.springframework.dao.DataIntegrityViolationException
import vesta.avales.DistribucionAsignacion
import vesta.parametros.PresupuestoUnidad
import vesta.parametros.TipoElemento
import vesta.parametros.UnidadEjecutora
import vesta.parametros.poaPac.Anio
import vesta.parametros.poaPac.Fuente
import vesta.parametros.poaPac.Mes
import vesta.parametros.poaPac.Presupuesto
import vesta.parametros.poaPac.ProgramaPresupuestario
import vesta.poaCorrientes.ActividadCorriente
import vesta.poaCorrientes.MacroActividad
import vesta.poaCorrientes.ObjetivoGastoCorriente
import vesta.poaCorrientes.Tarea
import vesta.proyectos.Cronograma
import vesta.proyectos.Financiamiento
import vesta.proyectos.MarcoLogico
import vesta.proyectos.ModificacionAsignacion
import vesta.proyectos.Proyecto
import vesta.seguridad.Shield


/**
 * Controlador que muestra las pantallas de manejo de Asignacion
 */
class AsignacionController extends Shield {

    static allowedMethods = [save_ajax: "POST", delete_ajax: "POST"]

    def buscadorService
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
     * Acción llamada con ajax que muestra un formulario para crear o modificar un elemento
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
     * Acción llamada con ajax que guarda una asignación de gasto corriente
     * @render ERROR*[mensaje] cuando no se pudo grabar correctamente, SUCCESS*[mensaje] cuando se grabó correctamente
     */
    def guardarAsignacion() {
        println("params guardar asg " + params)
        params.valor = params.valor.toDouble();

        def unidad = UnidadEjecutora.get(params.responsable)
        def anio = Anio.get(params.anio)
        def tarea = Tarea.get(params.tarea)
        def fuente = Fuente.get(params.fuente)
        def partida = Presupuesto.get(params.partida)


        def asignacionInstance = new Asignacion()

        if (params.id) {
            asignacionInstance = Asignacion.get(params.id)

            asignacionInstance.tarea = tarea
            asignacionInstance.unidad = unidad
            asignacionInstance.actividad = params.asignacion
            asignacionInstance.presupuesto = partida
            asignacionInstance.fuente = fuente
            asignacionInstance.planificado = params.valor.toDouble()
            asignacionInstance.priorizado = params.valor.toDouble()

            if (!asignacionInstance) {
                render "ERROR*No se encontró Asignacion."
                return
            }
        } else {

            asignacionInstance.planificado = params.valor
            asignacionInstance.priorizado = params.valor
            asignacionInstance.unidad = unidad
            asignacionInstance.anio = anio
            asignacionInstance.tarea = tarea
            asignacionInstance.fuente = fuente
            asignacionInstance.actividad = params.asignacion
            asignacionInstance.presupuesto = partida

            if (!asignacionInstance.save(flush: true)) {
                render "ERROR*Ha ocurrido un error al guardar la Asignación: " + renderErrors(bean: asignacionInstance)
                return
            }
        }

        render "SUCCESS*${params.id ? 'Actualización' : 'Creación'} de Asignación exitosa.*${asignacionInstance?.id}"
        return
    }

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
                render "SUCCESS*Asignacion borrada exitosamente."
                return
            } catch (DataIntegrityViolationException e) {
                render "ERROR*Ha ocurrido un error al eliminar la Asignacion"
                return
            }
        } else {
            render "ERROR*No se encontró Asignacion."
            return
        }
    } //delete para eliminar via ajax

    /*Yachay  */

    def getTotalPriorizadoProyectos(Anio anio) {
        def total = 0
        def asignaciones = Asignacion.findAllByAnio(anio)
        if (asignaciones.size() > 0) {
            total = asignaciones.sum { it.priorizado }
        }
        return total
    }

    def asignacionProyectov2() {
//        println "params asignacionProyectov2: " + params
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
                if (params.anio) {
                    actual = Anio.get(params.anio)
                } else {
                    actual = Anio.findByAnio(new Date().format("yyyy"))
                }
                if (!actual) {
                    actual = Anio.list([sort: 'anio', order: 'desc']).pop()
                }

                def totalR = 0
                def totalUnidadR = 0
                def maxInvR = 0
//                MarcoLogico.findAll("from MarcoLogico where proyecto = ${proyecto.id} and tipoElemento=3 and estado=0 and responsable=${unidadE.id}").each {
//                    def asig = Asignacion.findAll("from Asignacion where marcoLogico=${it.id} and anio=${actual.id}  order by id")
//                    if (asig) {
//                        asignaciones += asig
//                        asig.each { asg ->
//                            totalR = totalR + asg.getValorReal()
//                        }
//                    }
//                }

                MarcoLogico.withCriteria {
                    eq("proyecto", proyecto)
                    eq("tipoElemento", TipoElemento.get(3))
                    eq("estado", 0)
                    eq("responsable", unidadE)
                    marcoLogico {
                        order("numeroComp", "asc")
                    }
                    order("numero", "asc")
                }.each { ml ->
                    def asig = Asignacion.withCriteria {
                        eq("marcoLogico", ml)
                        eq("anio", actual)
                        order("id", "asc")
                    }
                    if (asig) {
                        asignaciones += asig
                        asig.each { asg ->
                            totalR = totalR + asg.getValorReal()
                        }
                    }
                }

//                asignaciones.sort { it.unidad.nombre }
                def unidad = UnidadEjecutora.findByPadreIsNull()
                maxInvR = PresupuestoUnidad.findByAnioAndUnidad(actual, unidad)?.maxInversion
                if (!maxInvR) {
                    maxInvR = 0
                }

//                println "++++++++++++ actual: $actual"
                return [asignaciones: asignaciones, actual: actual, proyecto: proyecto, total: totalR, totalUnidad: totalUnidadR,
                        maxInv      : maxInvR, priorizado: getTotalPriorizadoProyectos(actual)]

            } else {
                compon = MarcoLogico.findByProyectoAndObjeto(Proyecto.get(params.id), params.comp)
//                println "--- marcolo lógico: $compon.id"
                if (params.anio) {
                    actual = Anio.get(params.anio)
                } else {
                    actual = Anio.findByAnio(new Date().format("yyyy"))
                }
                if (!actual) {
                    actual = Anio.list([sort: 'anio', order: 'desc']).pop()
                }

                def total = 0
                def totalUnidad = 0
                def maxInv = 0
//                MarcoLogico.findAll("from MarcoLogico where proyecto = ${proyecto.id} and tipoElemento=3 and estado=0").each {
//                    def asig = Asignacion.findAll("from Asignacion where marcoLogico=${it.id} and anio=${actual.id}   order by id")
//                    if (asig) {
//                        asignaciones += asig
//                        asig.each { asg ->
//                            total = total + asg.getValorReal()
//                        }
//                    }
//                }
                MarcoLogico.withCriteria {
                    eq("proyecto", proyecto)
                    eq("tipoElemento", TipoElemento.get(3))
                    eq("estado", 0)
                    eq("marcoLogico", compon)
                    order("numero", "asc")
                }.each { ml ->
                    def asig = Asignacion.withCriteria {
                        eq("marcoLogico", ml)
                        eq("anio", actual)
                        order("id", "asc")
                    }
                    if (asig) {
                        asignaciones += asig
                        asig.each { asg ->
//                            total = totalR + asg.getValorReal()
                            total += asg.getValorReal()
                        }
                    }
                }
//                asignaciones.sort { it.unidad.nombre }
                def unidad = UnidadEjecutora.findByPadreIsNull()
                maxInv = PresupuestoUnidad.findByAnioAndUnidad(actual, unidad)?.maxInversion
                if (!maxInv) {
                    maxInv = 0
                }

//                println "+++++++++++***+ actual: $actual"
                return [asignaciones: asignaciones, actual: actual, proyecto: proyecto, total: total, totalUnidad: totalUnidad,
                        maxInv      : maxInv, priorizado: getTotalPriorizadoProyectos(actual)]
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
//            MarcoLogico.findAll("from MarcoLogico where proyecto = ${proyecto.id} and tipoElemento=3 and estado=0").each {
//                def asig = Asignacion.findAll("from Asignacion where marcoLogico=${it.id} and anio=${actual.id}  order by id")
//                if (asig) {
//                    asignaciones += asig
////                    println "add " + asig.id + " " + asig.unidad
//                    asig.each { asg ->
//                        total = total + asg.getValorReal()
//                    }
//                }
//            }
            MarcoLogico.withCriteria {
                eq("proyecto", proyecto)
                eq("tipoElemento", TipoElemento.get(3))
                eq("estado", 0)
                marcoLogico {
                    order("numeroComp", "asc")
                }
                order("numero", "asc")
            }.each { ml ->
                def asig = Asignacion.withCriteria {
                    eq("marcoLogico", ml)
                    eq("anio", actual)
                    order("id", "asc")
                }
                if (asig) {
                    asignaciones += asig
                    asig.each { asg ->
                        total = total + asg.getValorReal()
                    }
                }
            }
//            asignaciones.sort { it.unidad.nombre }
            def unidad = UnidadEjecutora.findByPadreIsNull()
            maxInv = PresupuestoUnidad.findByAnioAndUnidad(actual, unidad)?.maxInversion
            if (!maxInv) {
                maxInv = 0
            }
            return [asignaciones: asignaciones, actual: actual, proyecto: proyecto, total: total, totalUnidad: totalUnidad,
                    maxInv      : maxInv, priorizado: getTotalPriorizadoProyectos(actual)]
        }

    }

    def agregaAsignacionPrio() {
        def campos = ["numero": ["Número", "string"], "descripcion": ["Descripción", "string"]]
        def listaFuentes = Financiamiento.findAllByProyectoAndAnio(Proyecto.get(params.proy), Anio.get(params.anio)).fuente
        def asgnInstance = Asignacion.get(params.id)

        return ['asignacionInstance': asgnInstance, 'fuentes': listaFuentes, campos: campos]
    }


    def agregaAsignacion() {
        def campos = ["numero": ["Número", "string"], "descripcion": ["Descripción", "string"]]
        def listaFuentes = Financiamiento.findAllByProyectoAndAnio(Proyecto.get(params.proy), Anio.get(params.anio)).fuente
        def asgnInstance = Asignacion.get(params.id)
        def dist = null
        if (params.dist && params.dist != "" && params.dist != "undefined") {
            dist = DistribucionAsignacion.get(params.dist)
        }
        ['asignacionInstance': asgnInstance, 'fuentes': listaFuentes, 'dist': dist, campos: campos]
    }

    def buscarPresupuesto() {

        def listaTitulos = ["Número", "Descripción"]
        def listaCampos = ["numero", "descripcion"]
        def funciones = [null, null]
        def url = g.createLink(action: "buscarPresupuesto", controller: "asignacion")
        def funcionJs = null
        def numRegistros = 20
        def extras = ""

        if (!params.reporte) {
            if (params.excel) {
                session.dominio = Presupuesto
                session.funciones = funciones
                def anchos = [30, 70]
                /*anchos para el set column view en excel (no son porcentajes)*/
                redirect(controller: "reportesBuscador", action: "reporteBuscadorExcel", params: [listaCampos: listaCampos, listaTitulos: listaTitulos, tabla: "Obra", orden: params.orden, ordenado: params.ordenado, criterios: params.criterios, operadores: params.operadores, campos: params.campos, titulo: "Partidas presupuestarias", anchos: anchos, extras: extras, landscape: true])
            } else {
                def lista = buscadorService.buscar(Presupuesto, "Presupuesto", "excluyente", params, true, extras)
                /* Dominio, nombre del dominio , excluyente o incluyente ,params tal cual llegan de la interfaz del buscador, ignore case */
                lista.pop()
                render(view: '../tablaBuscador', model: [listaTitulos: listaTitulos, listaCampos: listaCampos, lista: lista, funciones: funciones, url: url, controller: "asignacion", numRegistros: numRegistros, funcionJs: funcionJs, paginas: 10])
            }

        } else {
//            println "entro reporte"
            /*De esto solo cambiar el dominio, el parametro tabla, el paramtero titulo y el tamaño de las columnas (anchos)*/
            session.dominio = Presupuesto
            session.funciones = funciones
            def anchos = [30, 70]
            /*el ancho de las columnas en porcentajes... solo enteros*/
            redirect(controller: "reportesBuscador", action: "reporteBuscador", params: [listaCampos: listaCampos, listaTitulos: listaTitulos, tabla: "Obra", orden: params.orden, ordenado: params.ordenado, criterios: params.criterios, operadores: params.operadores, campos: params.campos, titulo: "Obras", anchos: anchos, extras: extras, landscape: true])
        }
    }


    def buscarPresupuesto_ajax() {

//        println "buscar " + params
        def prsp = []
        if (!params.tipo) {
            if (params.parametro && params.parametro.trim().size() > 0) {
                prsp = Presupuesto.findAll("from Presupuesto where numero like '%${params.parametro}%' and movimiento=1 order by numero")
            } else {
                println "aqui "
                prsp = Presupuesto.findAllByMovimiento(1, [sort: "numero", max: 20])
            }
        } else {
            if (params.tipo == "1") {
                if (params.parametro && params.parametro.trim().size() > 0) {
                    prsp = Presupuesto.findAll("from Presupuesto where numero like '%${params.parametro}%' and movimiento=1 order by numero")
                } else {
                    prsp = Presupuesto.findAllByMovimiento(1, [sort: "numero", max: 20])
                }
            } else {
                if (params.parametro && params.parametro.trim().size() > 0) {
                    prsp = Presupuesto.findAll("from Presupuesto where lower(descripcion) like lower('%${params.parametro}%') and movimiento=1 order by numero")
                } else {
                    prsp = Presupuesto.findAllByMovimiento(1, [sort: "descripcion", max: 20])
                }
            }
        }
//        println("--> " + prsp)

        [prsp: prsp]
    }

    /**
     * Acción
     */
    def creaHijo = {
        println "parametros creaHijo:" + params
        if (params.id) {
            def nueva = new Asignacion()
            def valor = params.valor.toFloat()
            def asgn = Asignacion.get(params.id)
            def fnte = Fuente.get(params.fuente)
            def prsp = Presupuesto.get(params.partida)
            def resultado = 0
            // debe borrar el registro actual de pras y crear uno nuevo con los nuevos valores
            ProgramacionAsignacion.findAllByAsignacion(Asignacion.get(params.id)).each {
                it.delete(flush: true)
            }
            asgn.planificado -= valor
            asgn.save(flush: true)
            if (asgn.errors.getErrorCount() == 0) {
                resultado += guardarPras(asgn)
            } else {
                resultado = 0
            }
            if (resultado) {
                nueva.marcoLogico = asgn.marcoLogico
                nueva.programa = asgn.programa
                nueva.actividad = asgn.actividad
                nueva.anio = asgn.anio
                nueva.indicador = asgn.indicador
                nueva.meta = asgn.meta
                nueva.componente = asgn.componente
                nueva.padre = asgn
                nueva.fuente = fnte
                nueva.presupuesto = prsp
                nueva.planificado = valor
                nueva.unidad = asgn.unidad

//            println "pone padre: ${nueva.padre}  ${nueva.unidad}"
                nueva.save(flush: true)
                if (nueva.errors.getErrorCount() == 0) {
                    println "crea la progrmaación de " + nueva.id
                    resultado += guardarPras(nueva)
                } else {
                    resultado = 0
                }
            }
            render(nueva.id)
        }

    }

    /**
     * Acción
     */
    def creaHijoPrio = {
        println "parametros creaHijo:" + params
        if (params.id) {
            def nueva = new Asignacion()
            def valor = params.valor.toFloat()
            def asgn = Asignacion.get(params.id)
            def fnte = Fuente.get(params.fuente)
            def prsp = Presupuesto.get(params.partida)
            def resultado = 0
            // debe borrar el registro actual de pras y crear uno nuevo con los nuevos valores
            ProgramacionAsignacion.findAllByAsignacion(Asignacion.get(params.id)).each {
                it.delete(flush: true)
            }
            asgn.priorizado -= valor
            asgn.save(flush: true)
            if (asgn.errors.getErrorCount() == 0) {
                resultado += guardarPrasPrio(asgn)
            } else {
                resultado = 0
            }
            if (resultado) {
                nueva.marcoLogico = asgn.marcoLogico
                nueva.programa = asgn.programa
                nueva.actividad = asgn.actividad
                nueva.anio = asgn.anio
                nueva.indicador = asgn.indicador
                nueva.meta = asgn.meta
                nueva.componente = asgn.componente
                nueva.padre = asgn
                nueva.fuente = fnte
                nueva.presupuesto = prsp
                nueva.planificado = valor
                nueva.priorizado = valor
                nueva.unidad = asgn.unidad

//            println "pone padre: ${nueva.padre}  ${nueva.unidad}"
                nueva.save(flush: true)
                if (nueva.errors.getErrorCount() == 0) {
                    println "crea la progrmaación de " + nueva.id
                    resultado += guardarPrasPrio(nueva)
                } else {
                    resultado = 0
                }
            }
            render(nueva.id)
        }

    }

    /**
     * Acción
     */
    def borrarAsignacion() {
//        println "parametros borrarAsignacion:" + params
        def asgn = Asignacion.get(params.id)
        def pdre = Asignacion.get(asgn.padre.id)
        def p = [:]
        // debe borrar el registro actual de pras y crear uno nuevo con los nuevos valores
        ProgramacionAsignacion.findAllByAsignacion(asgn).each {
            it.delete(flush: true)
        }
        def del = true
        try {
            asgn.delete(flush: true)
        } catch (e) {
            del = false
        }
        if (del) {
            pdre.planificado += asgn.planificado
            pdre.save(flush: true)
            ProgramacionAsignacion.findAllByAsignacion(pdre).each {
                it.delete(flush: true)
            }
            if (pdre.errors.getErrorCount() == 0) {
                guardarPras(pdre)
            }
            render("ok")
        } else {
            render("Error")
        }
    }
    /**
     * Acción
     */
    def borrarAsignacionPrio() {
        def asgn = Asignacion.get(params.id)
        def pdre = Asignacion.get(asgn.padre.id)
        ProgramacionAsignacion.findAllByAsignacion(asgn).each {
            it.delete(flush: true)
        }
        def del = true
        try {
            asgn.delete(flush: true)
        } catch (e) {
            del = false
        }
        if (del) {
            pdre.priorizado += asgn.priorizado
            pdre.save(flush: true)
            ProgramacionAsignacion.findAllByAsignacion(pdre).each {
                it.delete(flush: true)
            }
            if (pdre.errors.getErrorCount() == 0) {
                guardarPrasPrio(pdre)
            }
            render("ok")
        } else {
            render("Error")
        }
    }


    def guardarPras(asg) {
        if (asg) {
            def total = (asg.redistribucion == 0) ? (asg.planificado) : (asg.redistribucion)
            def valor = (total / 12).toFloat().round(2)
            def residuo = 0
            if (valor * 12 != total) {
                residuo = (total.toDouble() - valor.toDouble() * 12).toFloat().round(2)
            }

            12.times {
                def mes = Mes.get(it + 1)
                ProgramacionAsignacion.findByAsignacionAndMes(asg, mes)?.delete(flush: true)
                def programacion = new ProgramacionAsignacion()
                programacion.asignacion = asg
                programacion.mes = mes
                if (it < 11) {
                    programacion.valor = valor
                } else {
                    programacion.valor = valor + residuo
                }
                programacion.save(flush: true)
            }
            return asg.id
        } else {
            return 0
        }
    }

    def guardarPrasPrio(asg) {
        if (asg) {
            def total = asg.priorizado
            def valor = (total / 12).toFloat().round(2)
            def residuo = 0
            if (valor * 12 != total) {
                residuo = (total.toDouble() - valor.toDouble() * 12).toFloat().round(2)
            }
            12.times {
                def mes = Mes.get(it + 1)
                ProgramacionAsignacion.findByAsignacionAndMes(asg, mes)?.delete(flush: true)
                def programacion = new ProgramacionAsignacion()
                programacion.asignacion = asg
                programacion.mes = mes
                if (it < 11) {
                    programacion.valor = valor
                } else {
                    programacion.valor = valor + residuo
                }
                programacion.save(flush: true)
            }
            return asg.id
        } else {
            return 0
        }
    }

    def filtro = {

//        println("params filtro:" + params)
        def proyecto = Proyecto.get(params.id)
        def asignaciones = []
        def actual
        def componentes = []
        def responsables = []
        params.anio = params.anio.toDouble();
        if (params.anio) {
            actual = Anio.get(params.anio)
        } else {
            actual = Anio.findByAnio(new Date().format("yyyy"))
        }
        if (!actual) {
            actual = Anio.list([sort: 'anio', order: 'desc']).pop()
        }

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

        asignaciones.each {

            componentes += it.marcoLogico.marcoLogico
            responsables += it.unidad

        }

        componentes = componentes.unique()
        responsables = responsables.unique()

//        println("componentes " + componentes)
//        println("responsables " + responsables)

        return [asignaciones: asignaciones, camp: params.camp, componentes: componentes, responsables: responsables, proyecto: proyecto, anio: params.anio]


    }

    /**
     * Acción
     */
    def guardarPrio = {
//        println "params "+params
        def asg = Asignacion.get(params.id)
        def monto = params.prio.toDouble()
        asg.priorizado = monto
        asg.save(flush: true)
        render "ok"
    }

    /**
     * Acción
     */
    def aprobarPrio = {
//        println "aprob prio " + params
        def proy = Proyecto.get(params.id)
        proy.aprobadoPoa = "S"
        proy.save(flush: true)
        render "ok"
    }

    /**
     * Acción
     */
    def programacionAsignacionesInversion() {
        def actual
        if (params.anio) {
            actual = Anio.get(params.anio)
        } else {
            actual = Anio.findByAnio(new Date().format("yyyy"))
        }
        if (!actual) {
            actual = Anio.list([sort: 'anio', order: 'desc']).pop()
        }
        //def unidad =UnidadEjecutora.get(params.id)
        if (actual.estado != 0) {
            redirect(action: 'programacionAsignacionesInversionPrio', params: params)
        }
        def asgProy = []
        def proyecto


        if(params.id){
            proyecto = Proyecto.get(params.id)

            MarcoLogico.findAll("from MarcoLogico where proyecto = ${proyecto.id} and tipoElemento=3 and estado=0").each {
                def asig = Asignacion.findAllByMarcoLogicoAndAnio(it, actual, [sort: "id"])
                if (asig) {
                    asgProy += asig
                }
            }
        }else{
            def ml = MarcoLogico.findAll("from MarcoLogico where proyecto is null and tipoElemento= 3 and estado=0")
            if(ml.size() == 0){
                //insertar asignaciones de gasto corriente
            }
            ml.each {
                def asig = Asignacion.findAllByMarcoLogicoAndAnio(it, actual, [sort: "id"])

                if (asig) {
                    asgProy += asig
                }
            }
        }







        def meses = Mes.list([sort: "id"])
        [inversiones: asgProy, actual: actual, meses: meses, proyecto: proyecto]
    }

    /**
     * Acción
     */
    def programacionAsignacionesInversionPrio() {

        def actual
        if (params.anio) {
            actual = Anio.get(params.anio)
        } else {
            actual = Anio.findByAnio(new Date().format("yyyy"))
        }
        if (!actual) {
            actual = Anio.list([sort: 'anio', order: 'desc']).pop()
        }
        //def unidad =UnidadEjecutora.get(params.id)

        def asgProy = []
        def proyecto

        if(params.id){

            proyecto = Proyecto.get(params.id)

            MarcoLogico.findAll("from MarcoLogico where proyecto = ${proyecto.id} and tipoElemento=3 and estado=0").each {
                def asig = Asignacion.findAllByMarcoLogicoAndAnio(it, actual, [sort: "id"])
                if (asig) {
                    asgProy += asig
                }
            }
        }else{
            proyecto = Proyecto.get(params.id)

            MarcoLogico.findAll("from MarcoLogico where proyecto is null and tipoElemento=3 and estado=0").each {
                def asig = Asignacion.findAllByMarcoLogicoAndAnio(it, actual, [sort: "id"])
                if (asig) {
                    asgProy += asig
                }
            }

        }



        def meses = Mes.list([sort: "id"])
        [inversiones: asgProy, actual: actual, meses: meses, proyecto: proyecto]
    }


    def programacionAsignacionesCorrientes () {

//        println("params 111" + params)

        def actual
        if (params.anio) {
            actual = Anio.get(params.anio)
        } else {
            actual = Anio.findByAnio(new Date().format("yyyy"))
        }
        if (!actual) {
            actual = Anio.list([sort: 'anio', order: 'desc']).pop()
        }

        def unidad = UnidadEjecutora.get(params.id)
        def asgProy = Asignacion.findAll("from Asignacion where unidad=${unidad.id} and marcoLogico is not null and anio=${actual.id} order by id")
//        def asgCor = Asignacion.findAll("from Asignacion where unidad=${unidad.id} and actividad is not null and anio=${actual.id} and marcoLogico is null order by id")
        def asgCor = Asignacion.findAll("from Asignacion where actividad is not null and anio=${actual.id} and marcoLogico is null order by id")
        def max = PresupuestoUnidad.findByUnidadAndAnio(unidad,actual)
        def meses = []
        12.times {meses.add(it + 1)}
        [unidad: unidad, corrientes: asgCor, inversiones: asgProy, actual: actual, meses: meses,max: max]
    }



    /**
     * Acción
     */
    def guardarProgramacion() {
        println "guardarProgramacion params " + params
        def asig = Asignacion.get(params.asignacion)
        def datos = params.datos.split(";")
        datos.each {
            def partes = it.split(":")
            println "partes: $partes"
            def prog = ProgramacionAsignacion.findByAsignacionAndMes(asig, Mes.get(partes[0]))
            println "prog: $prog"
            if ((!prog) && (partes[1]?:0 > 0)) {
                prog = new ProgramacionAsignacion()
                prog.asignacion = asig
                prog.mes = Mes.get(partes[0])
                println "crea pras: ${prog.mes}"
                if (!prog.save(flush: true)) {
                    println "errors " + prog.errors
                }
            } else {
                prog.valor = partes[1]?.toDouble()
                println "actualiza prog a ${partes[1]}"
                if (!prog.save(flush: true)) {
                    println "errors " + prog.errors
                }
            }
        }
        render "ok"
    }

    /**
     * Acción
     */
    def agregarAsignacionInv() {

        println "crear asgn inv " + params
        def proy = Proyecto.get(params.id)
        def unidad = proy.unidadEjecutora
        def campos = ["numero": ["Número", "string"], "descripcion": ["Descripción", "string"]]
        def comp = MarcoLogico.findAllByProyectoAndTipoElemento(proy, TipoElemento.get(2), [sort: "id"])
        def cmp
        def acts = []

        def fuentes = Fuente.list()

        def actual
        if (params.anio) {
            actual = Anio.get(params.anio)
        } else {
            actual = Anio.findByAnio(new Date().format("yyyy"))
        }

        if (params.comp) {
            cmp = MarcoLogico.get(params.comp)

        } else {
            if (comp.size() > 0) {
                cmp = comp[0]
            }
        }

        if (cmp) {
            acts = MarcoLogico.findAllByMarcoLogico(cmp)
        }

        def asgn = []
        def totalUnidad = 0
        acts.each {
            def a = Asignacion.findAllByMarcoLogico(it)
            a.each { asignacion ->
                if (asignacion.anio.id == actual.id) {
                    asgn.add(asignacion)
                    totalUnidad += asignacion.getValorReal()
                }

            }
        }

        def un = UnidadEjecutora.findByPadreIsNull()
        def maxUnidad = PresupuestoUnidad.findByAnioAndUnidad(actual, un)
        if (maxUnidad) {
            maxUnidad = maxUnidad.maxInversion
        } else {
            maxUnidad = 0
        }

        def totalPriorizado = asgn.sum { it.priorizado }
        def financiamientos = Financiamiento.findAllByProyectoAndAnio(proy, actual)
        def totalAnio = financiamientos.sum { it.monto }

        [proy       : proy, comp: comp, fuentes: fuentes, unidad: unidad, actual: actual, cmp: cmp, acts: acts, asgn: asgn,
         totalUnidad: totalUnidad, maxUnidad: maxUnidad, totalPriorizado: totalPriorizado, totalAnio: totalAnio, campos: campos]

    }

    /**
     * Acción
     */
    def programacionInversion = {
        def actual
        def proyecto = Proyecto.get(params.proyecto)
        if (params.anio) {
            actual = Anio.get(params.anio)
        } else {
            actual = Anio.findByAnio(new Date().format("yyyy"))
        }
        if (!actual) {
            actual = Anio.list([sort: 'anio', order: 'desc']).pop()
        }
        //def unidad =UnidadEjecutora.get(params.id)
//        def unidad = UnidadEjecutora.get(params.id)
        //def dist = DistribucionAsignacion.findAllByUnidadEjecutora(unidad)
//        def asg = []
//        dist.each {
//            if(it.asignacion.anio==actual){
//                asg.add(it.asignacion)
//            }
//        }
        def asgInv = []
        def acts = MarcoLogico.findAll("from MarcoLogico where proyecto=${proyecto.id} and tipoElemento = 3")
        acts.each { act ->
            def asg = Asignacion.findAllByMarcoLogico(act)
            if (asg.size() > 0) {
                asgInv += asg
            }
        }
//        def asgInv = Asignacion.findAll("from Asignacion  where marcoLogico is not null and unidad=${unidad.id} " )
        asgInv.sort { it.unidad }
        def meses = []
        12.times { meses.add(it + 1) }
        [inversiones: asgInv, actual: actual, meses: meses, proyecto: proyecto]
    }

    def validarCronograma_ajax = {
//        println "validar crono " + params
        def proyecto = Proyecto.get(params.proyecto)
        def plani = params.planificado


        if (plani) {

            def planificado = params.planificado
            planificado = planificado.replaceAll(",", "")
            planificado = planificado.toDouble()

            def marco = MarcoLogico.get(params.marco)
            def anio = Anio.get(params.anio)

            def cronos = Cronograma.findAllByMarcoLogicoAndAnio(marco, anio)
            def total = cronos.sum { it.valor }

            if (cronos.size() == 0) {
                render "La actividad no tiene valores programados para este año."
            } else {
                if (planificado > total) {
                    render "No puede asignar un valor superior a " + g.formatNumber(number: total, format: "###,##0", maxFractionDigits: 2, minFractionDigits: 2)
                } else {
                    render "true"
                }
            }
        } else {
            render "Debe ingresar un valor en presupuesto!"
        }


    }

    /**
     * Acción
     */
    def agregaAsignacionMod = {
        println "parametros agregaAsignacion mod:" + params

        def fuentes = Fuente.list([sort: 'descripcion'])
        def asgnInstance = Asignacion.get(params.id)
        def unidad = UnidadEjecutora.get(params.unidad)
        def actual


        if (params.anio) {
            actual = Anio.get(params.anio)
        } else {
            actual = Anio.findByAnio(new Date().format("yyyy"))
        }


        return ['asignacionInstance': asgnInstance, 'fuentes': fuentes, unidad: unidad, actual: actual, proyecto: params.proy]
    }

    /**
     * Acción
     */
    def creaHijoMod = {

        println "reasignacion mod!! " + params
        def path = servletContext.getRealPath("/") + "modificacionesPoa/"
        new File(path).mkdirs()

        def f = request.getFile('archivo')

        if (f && !f.empty) {
            def fileName = f.getOriginalFilename()
            def ext

            def parts = fileName.split("\\.")
            fileName = ""
            parts.eachWithIndex { obj, i ->
                if (i < parts.size() - 1) {
                    fileName += obj
                } else {
                    ext = obj
                }
            }
            def reps = [
                    "a": "[àáâãäåæ]",
                    "e": "[èéêë]",
                    "i": "[ìíîï]",
                    "o": "[òóôõöø]",
                    "u": "[ùúûü]",

                    "A": "[ÀÁÂÃÄÅÆ]",
                    "E": "[ÈÉÊË]",
                    "I": "[ÌÍÎÏ]",
                    "O": "[ÒÓÔÕÖØ]",
                    "U": "[ÙÚÛÜ]",

                    "n": "[ñ]",
                    "c": "[ç]",

                    "N": "[Ñ]",
                    "C": "[Ç]",

                    "" : "[\\!@\\\$%\\^&*()='\"\\/<>:;\\.,\\?]",

                    "_": "[\\s]"
            ]

            reps.each { k, v ->
                fileName = (fileName.trim()).replaceAll(v, k)
            }

            fileName = fileName + "." + "pdf"

            def pathFile = path + File.separatorChar + fileName
            def src = new File(pathFile)
            def msn

            if (src.exists()) {
//                msn = "Ya existe un archivo con ese nombre. Por favor cámbielo."
//                redirect(action: 'poaCorrientesMod', params: [msn: msn, id: params.unidad])

                flash.message = 'Ya existe un archivo con ese nombre. Por favor cámbielo.'
                flash.estado = "error"
                flash.icon = "alert"
                redirect(controller: 'modificacion', action: 'poaInversionesMod', id: params.proyecto)
                return


            } else {
                println "parametros creaHijo:" + params
                def nueva = new Asignacion()
                def valor = params.valor.toFloat()
                def asgn = Asignacion.get(params.id)
                def fnte = Fuente.get(params.fuente)
                def prsp = Presupuesto.get(params.presupuesto.id)
                def resultado = 0
                // debe borrar el registro actual de pras y crear uno nuevo con los nuevos valores
                ProgramacionAsignacion.findAllByAsignacion(Asignacion.get(params.id)).each {
                    //println "proceso la asignación ${it}"
                    def p = [id: it.id, controllerName: 'asignacion', actionName: 'creaHijoMod']
                    //println "parametros de borrado: " + p
//                    kerberosService.delete(p, ProgramacionAsignacion, session.perfil, session.usuario)

                }
//                asgn.planificado -= valor

                println("asg " + asgn.priorizado)
                println("valor " + valor)


                if (valor >= asgn.priorizado) {
                    flash.message = 'El valor que se desea asignar es mayor al del presupuesto disponible'
                    flash.estado = "error"
                    flash.icon = "alert"
                    redirect(controller: 'modificacion', action: 'poaInversionesMod', id: params.proyecto)
                    return
                }

                asgn.priorizado -= valor


                asgn.save(flush: true)
                if (asgn.errors.getErrorCount() == 0) {
                    resultado += guardarPras(asgn)
                } else {
                    resultado = 0
                }
                if (resultado) {
                    nueva.properties = asgn.properties
                    nueva.padre = asgn
                    nueva.fuente = fnte
                    nueva.presupuesto = prsp
//                    nueva.planificado = valor
                    nueva.priorizado = valor
                    //println "pone padre: ${nueva.padre}"
//                    nueva = kerberosService.saveObject(nueva, Asignacion, session.perfil, session.usuario, "agregaAsignacion", "asignacion", session)
                    nueva.save(flush: true)
                    if (nueva.errors.getErrorCount() == 0) {
                        f.transferTo(new File(pathFile))
                        println "crea la progrmaación de " + nueva.id
                        resultado += guardarPras(nueva)
                        def mod = new ModificacionAsignacion()
                        mod.desde = asgn
                        mod.recibe = nueva
                        mod.fecha = new Date()
//                        mod.valor = nueva.planificado
                        mod.valor = nueva.priorizado
                        mod.pdf = fileName
                        mod.save(flush: true)
                    } else {
                        resultado = 0
                    }
                }
//                msn = "Modificación procesada"
//                redirect(controller: "modificacion", action: "poaCorrientesMod", params: [msn: msn, id: params.unidad])
                flash.message = 'Modificación procesada'
                flash.estado = "success"
                flash.icon = "alert"
//                redirect(controller: 'modificacion', action: 'poaInversionesMod', id: params.unidad)
                redirect(controller: 'modificacion', action: 'poaInversionesMod', id: params.proyecto)
                return
            }
        } else {


            flash.message = 'No ingreso ningún archivo de autorización'
            flash.estado = "error"
            flash.icon = "alert"
            redirect(controller: 'modificacion', action: 'poaInversionesMod', id: params.proyecto)
            return
        }
    }

    def crearProgramacionCorriente () {

        println ("params" + params)

        def asigna = Asignacion.get(params.id)

        def valorPriorizado = asigna?.priorizado



        def meses = 12
        def ini = 0

        while(ini != 12){
//            println("entrof " + ini)
            def nuevaProgramacion = new ProgramacionAsignacion();

            nuevaProgramacion.asignacion = asigna
            nuevaProgramacion.mes = Mes.findByNumero(ini+1)
            nuevaProgramacion.valor = (valorPriorizado/12).toDouble()

            ini++

            if (!nuevaProgramacion.save(flush: true)) {
                println "errors " + nuevaProgramacion.errors
            }

        }

        render "ok"

    }

    def asignacionesCorrientesv2 = {

//        println("params ac " + params)

        def band = true

        if (!session.unidad) {
            redirect(controller: 'login', action: 'logout')
        }

//        if (params.id.toLong() != session.unidad.id.toLong()) {
//            band = false
//        }
        if (session.perfil.id.toLong() == 1.toLong()) {
            band = true
        }
        if (!band) {
            response.sendError(404)
        } else {

            def unidad = UnidadEjecutora.get(params.id)
            def fuentes = Fuente.list([sort: 'descripcion'])
            def programas = ProgramaPresupuestario.list()
            programas = programas.sort { it.codigo.toInteger() }
            def actual, programa
            def componentes = Componente.list([sort: 'descripcion'])
            def componente
            if (params.anio) {
                actual = Anio.get(params.anio)
            } else {
                actual = Anio.findByAnio(new Date().format("yyyy"))
            }


            if (params.programa) {
                programa = ProgramaPresupuestario.get(params.programa)
            }
            if (params.componente) {
                componente = Componente.get(params.componente)
            }

            if (!actual) {
                actual = Anio.list([sort: 'anio', order: 'desc']).pop()
            }
            if (!programa) {
                programa = programas[0]
            }
//        def asignaciones = Asignacion.findAll("from Asignacion where anio=${actual.id} and unidad=${unidad.id} and marcoLogico is null and actividad is not null order by id")

            def c = Asignacion.createCriteria()

            def asignaciones = c.list {
                and {
                    eq("anio", actual)
                    eq("unidad", unidad)
                    eq("programa", programa)
                    isNull("marcoLogico")
                }
                order("id", "asc")
            }

            c = Asignacion.createCriteria()
            def asgs = c.list {
                and {
                    eq("anio", actual)
                    eq("unidad", unidad)
                    isNull("marcoLogico")
                }
                order("id", "asc")
            }

            if (params.todo == "1") {
                asignaciones = asgs
            }

            def total = 0
            asgs.each { asg ->
//                total += ((asg.redistribucion == 0) ? asg.planificado.toDouble() : asg.redistribucion.toDouble())
                total += 0
            }

            def maxUnidad
            def max
            if (PresupuestoUnidad.findByUnidadAndAnio(unidad, actual)) {
                max = PresupuestoUnidad.findByUnidadAndAnio(unidad, actual)
                maxUnidad = max.maxCorrientes
            } else {
                maxUnidad = 0
            }

            def objetivos = ObjetivoGastoCorriente.list()

            //cargar los detalles para el anio 'actual'
            def detalles

            def campos = ["numero": ["Número", "string"], "descripcion": ["Descripción", "string"]]

            return [unidad  : unidad, actual: actual, asignaciones: asignaciones, fuentes: fuentes, programas: programas, detalles: detalles,
                    programa: programa, totalUnidad: total, maxUnidad: maxUnidad, componentes: componentes, max: max, objetivos: objetivos, campos: campos]
        }
    }

    def macro_ajax() {
        println "macro_ajax: params: $params"
        if (!params.mod) {
            params.mod = ""
        }
        def objetivo = ObjetivoGastoCorriente.get(params.objetivo)
        def macroActividades = MacroActividad.findAllByObjetivoGastoCorriente(objetivo)
        return [macro: macroActividades, params: params, valor: params.mac ?: '']

    }

    def actividad_ajax() {
        println "actividad ajax ... params: $params"
        if (!params.mod) {
            params.mod = ""
        }
        def anio = Anio.get(params.anio)

        def macro = MacroActividad.get(params.id)

        def actividades = ActividadCorriente.findAllByAnioAndMacroActividad(anio, macro)
        println "actividades ${actividades.id}"
        return [actividades: actividades, params: params, valor: params.act ?: '']
    }

    def tarea_ajax() {
        if (!params.mod) {
            params.mod = ""
        }

        def actvidad = ActividadCorriente.get(params.id)

        def tareas = Tarea.findAllByActividad(actvidad)

        return [tareas: tareas, params: params, valor: params.tar ?: '']
    }

    def asignacion_ajax() {
        if (!params.mod) {
            params.mod = ""
        }

        def tarea = Tarea.get(params.id)

        def asignaciones = Asignacion.findAllByTarea(tarea)

        return [asignaciones: asignaciones, params: params]
    }


    def tablaDetalles_ajax() {
        def anio = Anio.get(params.anio)
        def asignaciones = []

        if (params.objetivo != -1 && params.objetivo != 'T') {

            def objetivo = ObjetivoGastoCorriente.get(params.objetivo)
            def unidad = UnidadEjecutora.get(params.unidad)
            def macros = MacroActividad.findAllByObjetivoGastoCorriente(objetivo)
            def actividades = ActividadCorriente.findAllByMacroActividadInList(macros)
            def tareas = Tarea.findAllByActividadInList(actividades)
            asignaciones = Asignacion.findAllByTareaInListAndAnioAndUnidad(tareas, anio, unidad, [sort: 'unidad', order: 'unidad'])

        }
        if (params.objetivo == 'T') {
            asignaciones = Asignacion.findAllByAnioAndTareaIsNotNull(anio, [sort: 'unidad', order: 'unidad'])
        }

        return [asignaciones: asignaciones]
    }

    def editarAsignacion_ajax() {


        println("params eda " + params)

        def asignacion = Asignacion.get(params.id)

        def campos = ["numero": ["Número", "string"], "descripcion": ["Descripción", "string"]]
        def fuentes = Fuente.list([sort: 'descripcion'])

        return [campos: campos, fuentes: fuentes, asignacion: asignacion]
    }

    def buscarPresupuesto2() {

        def listaTitulos = ["Número", "Descripción"]
        def listaCampos = ["numero", "descripcion"]
        def funciones = [null, null]
        def url = g.createLink(action: "buscarPresupuesto2", controller: "asignacion")
        def funcionJs = null
        def numRegistros = 20
        def extras = ""

        if (!params.reporte) {
            if (params.excel) {
                session.dominio = Presupuesto
                session.funciones = funciones
                def anchos = [30, 70]
                /*anchos para el set column view en excel (no son porcentajes)*/
                redirect(controller: "reportesBuscador", action: "reporteBuscadorExcel", params: [listaCampos: listaCampos, listaTitulos: listaTitulos, tabla: "Obra", orden: params.orden, ordenado: params.ordenado, criterios: params.criterios, operadores: params.operadores, campos: params.campos, titulo: "Partidas presupuestarias", anchos: anchos, extras: extras, landscape: true])
            } else {
                def lista = buscadorService.buscar(Presupuesto, "Presupuesto", "excluyente", params, true, extras)
                /* Dominio, nombre del dominio , excluyente o incluyente ,params tal cual llegan de la interfaz del buscador, ignore case */
                lista.pop()
                render(view: '../tablaBuscador', model: [listaTitulos: listaTitulos, listaCampos: listaCampos, lista: lista, funciones: funciones, url: url, controller: "asignacion", numRegistros: numRegistros, funcionJs: funcionJs, paginas: 10])
            }

        } else {
//            println "entro reporte"
            /*De esto solo cambiar el dominio, el parametro tabla, el paramtero titulo y el tamaño de las columnas (anchos)*/
            session.dominio = Presupuesto
            session.funciones = funciones
            def anchos = [30, 70]
            /*el ancho de las columnas en porcentajes... solo enteros*/
            redirect(controller: "reportesBuscador", action: "reporteBuscador", params: [listaCampos: listaCampos, listaTitulos: listaTitulos, tabla: "Obra", orden: params.orden, ordenado: params.ordenado, criterios: params.criterios, operadores: params.operadores, campos: params.campos, titulo: "Obras", anchos: anchos, extras: extras, landscape: true])
        }
    }


    def macroCreacion_ajax() {
        if (!params.mod) {
            params.mod = ""
        }

        println("paranms MC " + params)

        def objetivo = ObjetivoGastoCorriente.get(params.objetivo)

        def macroActividades = MacroActividad.findAllByObjetivoGastoCorriente(objetivo)

        println("ma " + macroActividades)

        return [macro: macroActividades, params: params]

    }


    def asignacionCreacion_ajax() {

        def fuentes = Fuente.list([sort: 'descripcion'])
        def campos = ["numero": ["Número", "string"], "descripcion": ["Descripción", "string"]]

        return [fuentes: fuentes, campos: campos]

    }


    def tareaCreacion_ajax() {
        def objetivo = ObjetivoGastoCorriente.get(params.objetivo);
        def macro = MacroActividad.get(params.macro)
        def actividad = ActividadCorriente.get(params.acti);
        def tarea = Tarea.get(params.id)

        return [objetivo: objetivo, macro: macro, actividad: actividad, tarea: tarea]
    }


    def actividadCreacion_ajax() {

        def objetivo = ObjetivoGastoCorriente.get(params.objetivo);
        def macro = MacroActividad.get(params.macro)
        def actividad = ActividadCorriente.get(params.actividad)

        return [objetivo: objetivo, macro: macro, actividad: actividad]

    }

    def guardarActividad_ajax() {
        println("params guardar act " + params)
        def macro = MacroActividad.get(params.macro)
        def anio = Anio.get(params.anio)

        def actividadCorrienteInstance = new ActividadCorriente()

        if (params.id) {

            actividadCorrienteInstance = ActividadCorriente.get(params.id)
            actividadCorrienteInstance.descripcion = params.desc
            actividadCorrienteInstance.meta = params.meta

            if (!actividadCorrienteInstance) {
                render "ERROR*No se encontró ninguna actividad"
                return
            }
        } else {

            actividadCorrienteInstance.macroActividad = macro
            actividadCorrienteInstance.descripcion = params.desc
            actividadCorrienteInstance.anio = anio
            actividadCorrienteInstance.meta = params.meta

            if (!actividadCorrienteInstance.save(flush: true)) {
                println(actividadCorrienteInstance.errors)
                render "ERROR*Ha ocurrido un error al grabar la actividad"
                return
            }
        }

        render "SUCCESS*${params.id ? 'Actualización' : 'Creación'} de actividad exitosa."
        return
    }

    def guardarTarea_ajax() {
        println("params gtarea " + params)
        def actividad = ActividadCorriente.get(params.actividad)
        def tareaInstance = new Tarea()

        if (params.id) {

            tareaInstance = Tarea.get(params.id)
            tareaInstance.descripcion = params.desc

            if (!tareaInstance) {

                render "ERROR*No se encontró ninguna tarea"
                return
            }
        } else {
            tareaInstance.descripcion = params.desc
            tareaInstance.actividad = actividad

            if (!tareaInstance.save(flush: true)) {
                println(tareaInstance.errors)
                render "ERROR*Ha ocurrido un error al grabar la tarea"
                return
            }
        }

        render "SUCCESS*${params.id ? 'Actualización' : 'Creación'} de tarea exitosa."
        return
    }


    def actividadesTareas_ajax() {

        def macro = MacroActividad.get(params.macro)

        return [macro: macro]
    }

    def totalObjetivo_ajax() {

//        println("params total" + params)

        def anio = Anio.get(params.anio)

        def objetivo = ObjetivoGastoCorriente.get(params.objetivo)

        def macro = MacroActividad.findAllByObjetivoGastoCorriente(objetivo)

        def actividad = ActividadCorriente.findAllByMacroActividadInList(macro)

        def tarea = Tarea.findAllByActividadInList(actividad)

        def asignacion = Asignacion.findAllByTareaInListAndAnio(tarea, anio)

        def totalObjetivo = 0

        asignacion.each {
            totalObjetivo += it?.planificado
        }

        def presupuesto = PresupuestoUnidad.findByAnio(anio)

        def restante = 0

        //por unidad

        def totalUnidad = 0

        def unidadEjecutora = UnidadEjecutora.get(params.unidad)

        def asignacionUnidad = Asignacion.findAllByUnidadAndAnioAndMarcoLogicoIsNull(unidadEjecutora, anio)

        asignacionUnidad.each {
            totalUnidad += it?.planificado
        }

        //restante

        def todasAsignaciones = Asignacion.findAllByAnioAndMarcoLogicoIsNull(anio)
        def totalTodas = 0

        if (todasAsignaciones.size() > 0) {
            todasAsignaciones.each {
                totalTodas += it?.planificado
            }
        }

//        println("total todas" + totalTodas)

        if (presupuesto) {
            restante = (presupuesto?.maxCorrientes - totalTodas)
        } else {
            restante = 0
        }



        return [totalObjetivo: totalObjetivo, maximo: presupuesto, restante: restante, totalUnidad: totalUnidad, totalTodas: totalTodas]

    }

    def totales() {
        def anio = Anio.get(params.anio)

        def objetivo = ObjetivoGastoCorriente.get(params.objetivo)

        def macro = MacroActividad.findAllByObjetivoGastoCorriente(objetivo)

        def actividad = ActividadCorriente.findAllByMacroActividadInList(macro)

        def tarea = Tarea.findAllByActividadInList(actividad)

        def asignacion = Asignacion.findAllByTareaInListAndAnio(tarea, anio)

        def totalObjetivo = 0

        asignacion.each {
            totalObjetivo += it?.planificado
        }

        def presupuesto = PresupuestoUnidad.findByAnio(anio)

        def restante = (presupuesto?.maxCorrientes) - (totalObjetivo)

        render restante
    }

    def partida_ajax () {
//        println("params " + params)
       def fuente = Fuente.get(params.fuente)
        def partidas

        if(fuente.codigo == '001'){
            partidas = Presupuesto.withCriteria {
                or{
                    ilike("numero", '5%')
                    ilike("numero", '7%')
                    ilike("numero", '8%')
                }
                order("numero","asc")
            }
        }else{
            if(fuente.codigo == '002'){
                partidas = Presupuesto.withCriteria {
                    ilike("numero", '6%')
                }
            }else {
            partidas = Presupuesto.list()
            }
        }
//        println("partidas " + partidas)

        return [ partidas: partidas]

    }

    def buscadorPartidas () {
        def cn = dbConnectionService.getConnection()

        params.old = params.criterio
        params.criterio = buscadorService.limpiaCriterio(params.criterio)

        def sql = armaSqlPartidas(params)
        def res = cn.rows(sql)
//        println "registro retornados del sql: ${res.size()}"
//        println ("sql :  " + sql)
        params.criterio = params.old
//        println("res " + res)
        return [res: res, params: params]
    }

    def armaSqlPartidas(params){
        def campos = buscadorService.parametrosPartidas()
        def operador = buscadorService.operadores()


        def sqlSelect = "select prsp__id, prspnmro, prspdscr  " +
                "from prsp"
        def sqlWhere = "where (prspnmro ilike '5%' or prspnmro ilike '7%' or prspnmro ilike '8%')"

        def sqlOrder = "order by prspnmro limit 40"

//        println "llega params: $params"
//        params.nombre = "Código"

        if(campos.find {it.campo == params.buscador}?.size() > 0) {
            def op = operador.find {it.valor == params.operador}
//            println "op: $op"
            sqlWhere += " and ${params.buscador} ${op.operador} ${op.strInicio}${params.criterio}${op.strFin}";
        }
//        println "txWhere: $sqlWhere"
//        println "sql armado: sqlSelect: ${sqlSelect} \n sqlWhere: ${sqlWhere} \n sqlOrder: ${sqlOrder}"
        //retorna sql armado:

        "$sqlSelect $sqlWhere $sqlOrder".toString()
    }


    def buscadorPartidasFiltradas () {

        def cn = dbConnectionService.getConnection()

        params.old = params.criterio
        params.criterio = buscadorService.limpiaCriterio(params.criterio)

        def sql = armaSqlPartidasFiltradas(params)
        def res = cn.rows(sql)
        params.criterio = params.old

        return [res: res, params: params]
    }


    def armaSqlPartidasFiltradas(params){
        def campos = buscadorService.parametrosPartidas()
        def operador = buscadorService.operadores()


        def sqlSelect = "select prsp__id, prspnmro, prspdscr  " +
                "from prsp"
        def sqlWhere = "where (prspnmro ilike '6%' or prspnmro ilike '7%' or prspnmro ilike '8%')"

        def sqlOrder = "order by prspnmro limit 40"


        if(campos.find {it.campo == params.buscador}?.size() > 0) {
            def op = operador.find {it.valor == params.operador}
            sqlWhere += " and ${params.buscador} ${op.operador} ${op.strInicio}${params.criterio}${op.strFin}";
        }

        "$sqlSelect $sqlWhere $sqlOrder".toString()
    }






}
