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
import vesta.proyectos.Cronograma
import vesta.proyectos.Financiamiento
import vesta.proyectos.MarcoLogico
import vesta.proyectos.Proyecto
import vesta.seguridad.Shield


/**
 * Controlador que muestra las pantallas de manejo de Asignacion
 */
class AsignacionController extends Shield {

    static allowedMethods = [save_ajax: "POST", delete_ajax: "POST"]
    def buscadorService
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

    def getTotalPriorizadoProyectos(Anio anio) {
        def total = 0
        def asignaciones = Asignacion.findAllByAnio(anio)
        if (asignaciones.size() > 0) {
            total = asignaciones.sum { it.priorizado }
        }
        return total
    }

    def asignacionProyectov2() {
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
                if (!maxInvR)
                    maxInvR = 0

                return [asignaciones: asignaciones, actual: actual, proyecto: proyecto, total: totalR, totalUnidad: totalUnidadR, maxInv: maxInvR]

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
                            total = totalR + asg.getValorReal()
                        }
                    }
                }
//                asignaciones.sort { it.unidad.nombre }
                def unidad = UnidadEjecutora.findByPadreIsNull()
                maxInv = PresupuestoUnidad.findByAnioAndUnidad(actual, unidad)?.maxInversion
                if (!maxInv)
                    maxInv = 0
                return [asignaciones: asignaciones, actual: actual, proyecto: proyecto, total: total, totalUnidad: totalUnidad, maxInv: maxInv]
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
            if (!maxInv)
                maxInv = 0
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
        if (params.dist && params.dist != "" && params.dist != "undefined")
            dist = DistribucionAsignacion.get(params.dist)
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

    /**
     * Acción
     */
    def creaHijo = {
//        println "parametros creaHijo:" + params
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
//        println "parametros creaHijo:" + params
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

//        println("params " + params)
        def proyecto = Proyecto.get(params.id)
        def asignaciones = []
        def actual
        def componentes = []
        def responsables = []
        params.anio = params.anio.toDouble();
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

        asignaciones.each {

            componentes += it.marcoLogico.marcoLogico
            responsables += it.unidad

        }

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
        if (params.anio)
            actual = Anio.get(params.anio)
        else
            actual = Anio.findByAnio(new Date().format("yyyy"))
        if (!actual)
            actual = Anio.list([sort: 'anio', order: 'desc']).pop()
        //def unidad =UnidadEjecutora.get(params.id)
        if (actual.estado != 0)
            redirect(action: 'programacionAsignacionesInversionPrio', params: params)

        def proyecto = Proyecto.get(params.id)

        def asgProy = []
        MarcoLogico.findAll("from MarcoLogico where proyecto = ${proyecto.id} and tipoElemento=3 and estado=0").each {
            def asig = Asignacion.findAllByMarcoLogicoAndAnio(it, actual, [sort: "id"])
            if (asig)
                asgProy += asig
        }

        def meses = Mes.list([sort: "id"])
        [inversiones: asgProy, actual: actual, meses: meses, proyecto: proyecto]
    }

    /**
     * Acción
     */
    def programacionAsignacionesInversionPrio() {

        def actual
        if (params.anio)
            actual = Anio.get(params.anio)
        else
            actual = Anio.findByAnio(new Date().format("yyyy"))
        if (!actual)
            actual = Anio.list([sort: 'anio', order: 'desc']).pop()
        //def unidad =UnidadEjecutora.get(params.id)

        def proyecto = Proyecto.get(params.id)

        def asgProy = []
        MarcoLogico.findAll("from MarcoLogico where proyecto = ${proyecto.id} and tipoElemento=3 and estado=0").each {
            def asig = Asignacion.findAllByMarcoLogicoAndAnio(it, actual, [sort: "id"])
            if (asig)
                asgProy += asig
        }

        def meses = Mes.list([sort: "id"])
        [inversiones: asgProy, actual: actual, meses: meses, proyecto: proyecto]
    }

    /**
     * Acción
     */
    def guardarProgramacion() {
        println "guardar prog " + params
        def asig = Asignacion.get(params.asignacion)
        def datos = params.datos.split(";")
        datos.each {
            def partes = it.split(":")

            def prog = ProgramacionAsignacion.findByAsignacionAndMes(asig, Mes.get(partes[0]))
            if (!prog) {
                prog = new ProgramacionAsignacion()
                prog.asignacion = asig
                prog.mes = Mes.get(partes[0])
            }
            prog.valor = partes[1].toDouble()
            if (!prog.save(flush: true))
                println "errors " + prog.errors


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
        if (params.anio)
            actual = Anio.get(params.anio)
        else
            actual = Anio.findByAnio(new Date().format("yyyy"))

        if (params.comp) {
            cmp = MarcoLogico.get(params.comp)

        } else {
            if (comp.size() > 0)
                cmp = comp[0]
        }

        if (cmp)
            acts = MarcoLogico.findAllByMarcoLogico(cmp)

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
        if (maxUnidad)
            maxUnidad = maxUnidad.maxInversion
        else
            maxUnidad = 0

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
        if (params.anio)
            actual = Anio.get(params.anio)
        else
            actual = Anio.findByAnio(new Date().format("yyyy"))
        if (!actual)
            actual = Anio.list([sort: 'anio', order: 'desc']).pop()
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
            if (asg.size() > 0)
                asgInv += asg
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


}
