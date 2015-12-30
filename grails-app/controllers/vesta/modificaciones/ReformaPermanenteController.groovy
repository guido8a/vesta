package vesta.modificaciones

import org.apache.tools.ant.taskdefs.Tar
import vesta.avales.EstadoAval
import vesta.parametros.UnidadEjecutora
import vesta.parametros.poaPac.Anio
import vesta.parametros.poaPac.Fuente
import vesta.parametros.poaPac.Presupuesto
import vesta.poa.Asignacion
import vesta.poaCorrientes.ActividadCorriente
import vesta.poaCorrientes.MacroActividad
import vesta.poaCorrientes.ObjetivoGastoCorriente
import vesta.poaCorrientes.Tarea
import vesta.proyectos.MarcoLogico
import vesta.seguridad.Shield



class ReformaPermanenteController extends  Shield{

    def firmasService
    def dbConnectionService

    def index() {}


    def macro_ajax() {
        if (!params.mod) {
            params.mod = ""
        }
        def objetivo = ObjetivoGastoCorriente.get(params.objetivo)
        def macroActividades = MacroActividad.findAllByObjetivoGastoCorriente(objetivo)
        return [macro: macroActividades, params: params, valor: params.mac ?: '']

    }

    def actividad_ajax() {

        println("params " + params)
        if (!params.mod) {
            params.mod = ""
        }

        def anio
        if (params.anio) {
            anio = Anio.get(params.anio)
        } else {
            anio = Anio.findByAnio(new Date().format("yyyy"))
        }

        def macro = MacroActividad.get(params.id)
        def actividades = ActividadCorriente.findAllByAnioAndMacroActividad(anio, macro)

//        println("actividades " + actividades)

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



    def nuevaReformaCorriente () {

        def cn = dbConnectionService.getConnection()
        def actual
        if (params.anio) {
            actual = Anio.get(params.anio)
        } else {
            actual = Anio.findByAnio(new Date().format("yyyy"))
        }

        def unidad = UnidadEjecutora.get(session.unidad.id)
        def proyectos = unidad.getProyectosUnidad(actual, session.perfil.codigo.toString())

        def anios__id = cn.rows("select distinct asgn.anio__id, anioanio from asgn, mrlg, anio " +
                "where mrlg.mrlg__id = asgn.mrlg__id and proy__id in (${proyectos.id.join(',')}) and " +
                "anio.anio__id = asgn.anio__id and cast(anioanio as integer) >= ${actual.anio} " +
                "order by anioanio".toString()).anio__id

        def anios = Anio.findAllByIdInList(anios__id)

        def personasFirma = firmasService.listaDirectoresUnidad(unidad)

        def reforma
        def detalle
        if(params.id){
            reforma = Reforma.findByIdAndTipoAndTipoSolicitud(params.id, "R","Q")
            detalle = DetalleReforma.findAllByReforma(reforma)
        }

        return [personas: personasFirma, actual: actual, proyectos: proyectos, reforma: reforma, detalle: detalle,
                anios: anios]
    }


    def origen_ajax () {


        println("params a " + params)

        def actual
        if (params.anio) {
            actual = Anio.get(params.anio)
        } else {
            actual = Anio.findByAnio(new Date().format("yyyy"))
        }

        def detalle = null

        if(params.id){
            detalle = DetalleReforma.get(params.id)
        }

        //objetivos

        List<ObjetivoGastoCorriente> objetivos = []
        ActividadCorriente.findAllByAnio(actual).each { ac ->
            def ob = ac.macroActividad.objetivoGastoCorriente
            if (!objetivos.contains(ob)) {
                objetivos += ob
            }
        }
        objetivos.sort { it.descripcion }

        return [detalle: detalle, objetivos: objetivos]
    }


    def incrementoCorriente_ajax () {


        println("params b " + params)

        def actual
        if (params.anio) {
            actual = Anio.get(params.anio)
        } else {
            actual = Anio.findByAnio(new Date().format("yyyy"))
        }

        def detalle = null

        if(params.id){
            detalle = DetalleReforma.get(params.id)
        }

        //objetivos

        List<ObjetivoGastoCorriente> objetivos = []
        ActividadCorriente.findAllByAnio(actual).each { ac ->
            def ob = ac.macroActividad.objetivoGastoCorriente
            if (!objetivos.contains(ob)) {
                objetivos += ob
            }
        }
        objetivos.sort { it.descripcion }

        return [detalle: detalle, objetivos: objetivos]
    }

    def partidaCorriente_ajax () {


        def actual
        if (params.anio) {
            actual = Anio.get(params.anio)
        } else {
            actual = Anio.findByAnio(new Date().format("yyyy"))
        }

        def unidad = UnidadEjecutora.get(session.usuario.unidad.id)
        def gerencias = firmasService.requirentes(unidad)

        def detalle = null

        if (params.id) {
            detalle = DetalleReforma.get(params.id)
        }

        //objetivos
        List<ObjetivoGastoCorriente> objetivos = []
        ActividadCorriente.findAllByAnio(actual).each { ac ->
            def ob = ac.macroActividad.objetivoGastoCorriente
            if (!objetivos.contains(ob)) {
                objetivos += ob
            }
        }
        objetivos.sort {it.descripcion}

        return [gerencias: gerencias, detalle: detalle, objetivos: objetivos]
    }


    def grabarDetalleA () {

        println("params A " + params)

        def reforma = Reforma.get(params.reforma)
        def tipoReforma = TipoReforma.findByCodigo(params.tipoReforma)
        def asignacion = Asignacion.get(params.asignacion)
        def fuente = Fuente.get(asignacion?.fuente?.id)
        def macro = MacroActividad.get(params.macro)
        def objetivo = ObjetivoGastoCorriente.get(params.objetivo)
        def acti = ActividadCorriente.get(params.actividad)
        def tar = Tarea.get(params.tarea)

        def detalleReforma

        if(!params.id){
            //crear

            detalleReforma = new DetalleReforma()
            detalleReforma.reforma = reforma
            detalleReforma.asignacionOrigen = asignacion
            detalleReforma.tipoReforma = tipoReforma
            detalleReforma.valor = params.monto.toDouble()
            detalleReforma.valorOrigenInicial = asignacion.priorizado
            detalleReforma.valorDestinoInicial = 0
            detalleReforma.fuente = fuente
            detalleReforma.responsable = asignacion.unidad
            detalleReforma.presupuesto = asignacion.presupuesto
            detalleReforma.macroActividad = macro
            detalleReforma.objetivoGastoCorriente = objetivo
            detalleReforma.tarea = tar.id

            if(params.adicional){
                detalleReforma.solicitado = params.adicional
            }
            if(!detalleReforma.save(flush: true)){
                println("error al guardar detalle de reforma A " + detalleReforma.errors);
                render "no"
            }else{
                render "ok"
            }
        }else{
            //editar

            detalleReforma = DetalleReforma.get(params.id)
            detalleReforma.reforma = reforma
            detalleReforma.asignacionOrigen = asignacion
            detalleReforma.tipoReforma = tipoReforma
            detalleReforma.valor = params.monto.toDouble()
            detalleReforma.valorOrigenInicial = asignacion.priorizado
            detalleReforma.valorDestinoInicial = 0
            detalleReforma.fuente = fuente
            detalleReforma.responsable = asignacion.unidad
            detalleReforma.presupuesto = asignacion.presupuesto
            detalleReforma.macroActividad = macro
            detalleReforma.objetivoGastoCorriente = objetivo
            detalleReforma.tarea = tar.id

            if(!detalleReforma.save(flush: true)){
                println("error al guardar detalle de reforma A " + detalleReforma.errors);
                render "no"
            }else{
                render "ok"
            }
        }

    }


    def grabarDetalleB () {
//        println("params B " + params)

        def reforma = Reforma.get(params.reforma)
        def tipoReforma = TipoReforma.findByCodigo(params.tipoReforma)
        def asignacion = Asignacion.get(params.asignacion)
        def fuente = Fuente.get(asignacion?.fuente?.id)
        def macro = MacroActividad.get(params.macro)
        def objetivo = ObjetivoGastoCorriente.get(params.objetivo)
        def acti = ActividadCorriente.get(params.actividad)
        def tar = Tarea.get(params.tarea)

        def detalleReforma

        if(!params.id){
            //crear

            detalleReforma = new DetalleReforma()
            detalleReforma.reforma = reforma
            detalleReforma.asignacionOrigen = asignacion
            detalleReforma.tipoReforma = tipoReforma
            detalleReforma.valor = params.monto.toDouble()
            detalleReforma.valorOrigenInicial = 0
            detalleReforma.valorDestinoInicial = asignacion.priorizado
            detalleReforma.fuente = fuente
            detalleReforma.responsable = asignacion.unidad
            detalleReforma.presupuesto = asignacion.presupuesto
            detalleReforma.macroActividad = macro
            detalleReforma.objetivoGastoCorriente = objetivo
            detalleReforma.tarea = tar.id

            if(!detalleReforma.save(flush: true)){
                println("error al guardar detalle de reforma B " + errors);
                render "no"
            }else{
                render "ok"
            }
        }else{
            //editar

            detalleReforma = new DetalleReforma()
            detalleReforma.reforma = reforma
            detalleReforma.asignacionOrigen = asignacion
            detalleReforma.tipoReforma = tipoReforma
            detalleReforma.valor = params.monto.toDouble()
            detalleReforma.valorOrigenInicial = 0
            detalleReforma.valorDestinoInicial = asignacion.priorizado
            detalleReforma.fuente = fuente
            detalleReforma.responsable = asignacion.unidad
            detalleReforma.presupuesto = asignacion.presupuesto
            detalleReforma.macroActividad = macro
            detalleReforma.objetivoGastoCorriente = objetivo
            detalleReforma.tarea = tar.id

            if(!detalleReforma.save(flush: true)){
                println("error al guardar detalle de reforma B " + errors);
                render "no"
            }else{
                render "ok"
            }
        }
    }


    def grabarDetalleC () {

        println("params C " + params)
//
        def reforma = Reforma.get(params.reforma)
        def tipoReforma = TipoReforma.findByCodigo(params.tipoReforma)
        def asignacion = Asignacion.get(params.asignacion)
        def macro = MacroActividad.get(params.macro)
        def objetivo = ObjetivoGastoCorriente.get(params.objetivo)
        def tar = Tarea.get(params.tarea)
        def fuente = Fuente.get(params.fuente)
        def partida = Presupuesto.get(params.partida)

        def detalleReforma

        if(!params.id){
            //crear

            detalleReforma = new DetalleReforma()
            detalleReforma.reforma = reforma
            detalleReforma.tipoReforma = tipoReforma
            detalleReforma.valor = params.monto.toDouble()
            detalleReforma.valorOrigenInicial = 0
            detalleReforma.valorDestinoInicial = 0
            detalleReforma.fuente = fuente
            detalleReforma.presupuesto = partida
            detalleReforma.responsable = session.usuario.unidad
            detalleReforma.macroActividad = macro
            detalleReforma.objetivoGastoCorriente = objetivo
            detalleReforma.tarea = tar.id

            if(!detalleReforma.save(flush: true)){
                println("error al guardar detalle de reforma C  " + errors);
                render "no"
            }else{
                render "ok"
            }


        }else{
            //editar

            detalleReforma = DetalleReforma.get(params.id)
            detalleReforma.reforma = reforma
            detalleReforma.tipoReforma = tipoReforma
            detalleReforma.valor = params.monto.toDouble()
            detalleReforma.valorOrigenInicial = 0
            detalleReforma.valorDestinoInicial = 0
            detalleReforma.fuente = fuente
            detalleReforma.presupuesto = partida
            detalleReforma.responsable = session.usuario.unidad
            detalleReforma.macroActividad = macro
            detalleReforma.objetivoGastoCorriente = objetivo
            detalleReforma.tarea = tar.id

            if(!detalleReforma.save(flush: true)){
                println("error al guardar detalle de reforma C  " + errors);
                render "no"
            }else{
                render "ok"
            }
        }


    }



}

