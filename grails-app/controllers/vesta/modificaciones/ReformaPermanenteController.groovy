package vesta.modificaciones

import org.apache.tools.ant.taskdefs.Tar
import vesta.alertas.Alerta
import vesta.avales.EstadoAval
import vesta.parametros.TipoElemento
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
import vesta.proyectos.ModificacionAsignacion
import vesta.reportes.ReportesReformaController
import vesta.seguridad.Firma
import vesta.seguridad.Persona
import vesta.seguridad.Prfl
import vesta.seguridad.Sesn
import vesta.seguridad.Shield



class ReformaPermanenteController extends  Shield{

    def firmasService
    def dbConnectionService
    def mailService

    def index() {}


    def macro_ajax() {
        println "macro_ajax params: $params"
        if (!params.mod) {
            params.mod = ""
        }
        def objetivo = ObjetivoGastoCorriente.get(params.objetivo)
        def macroActividades = MacroActividad.findAllByObjetivoGastoCorriente(objetivo)
        println "macros: $macroActividades"
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

        def txto = "select distinct asgn.anio__id, anioanio from asgn, anio " +
                "where mrlg__id is null and anio.anio__id = asgn.anio__id and " +
                "cast(anioanio as integer) >= ${actual.anio} order by anioanio"
        println "txto: $txto"
        def anios__id = cn.rows(txto.toString()).anio__id

        def anios = Anio.findAllByIdInList(anios__id)

        def personasFirma = firmasService.listaDirectoresUnidad(unidad)

        def reforma
        def detalle
        if(params.id){
            reforma = Reforma.findByIdAndTipoAndTipoSolicitud(params.id, "R","Q")
            detalle = DetalleReforma.findAllByReforma(reforma, [sort: 'tipoReforma.id', order: 'desc'])
        }

        println "anios: $anios, detalle: $detalle"
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
            detalleReforma.anio = asignacion.anio

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
            detalleReforma.anio = asignacion.anio

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
            detalleReforma.anio = asignacion.anio

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
            detalleReforma.anio = asignacion.anio

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
        def anio

        if(params.anio){
            anio = Anio.get(params.anio)
        }


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
            detalleReforma.anio = anio

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
            detalleReforma.anio = anio

            if(!detalleReforma.save(flush: true)){
                println("error al guardar detalle de reforma C  " + errors);
                render "no"
            }else{
                render "ok"
            }
        }
    }


    /**
     * Lista de las reformas de GP pendientes para enviar a revisión y luego a firmar solicitud "depende del perfil"
     */
    def pendientes() {
        def estadoPendiente = EstadoAval.findByCodigo("P01")
        def estadoDevueltoReq = EstadoAval.findByCodigo("D01")
        def estadoPorRevisar = EstadoAval.findByCodigo("R01")
        def estadoSolicitado = EstadoAval.findByCodigo("E01")
        def estadoDevueltoDirReq = EstadoAval.findByCodigo("D02")
        def estadoDevueltoAnPlan = EstadoAval.findByCodigo("D03")
        def tx = ""
        def cn = dbConnectionService.getConnection()
        def totales = [:]
        def estados = []
        def perfil = session.perfil.codigo.toString()
        def unidades
        unidades = UnidadEjecutora.get(session.unidad.id).getUnidadesPorPerfil(perfil)

        def filtroDirector = null,
            filtroPersona = null

        switch (perfil) {
            case "RQ":
                estados = [estadoPendiente, estadoDevueltoReq]
                filtroPersona = Persona.get(session.usuario.id)
                break;
            case "DRRQ":
                estados = [estadoPorRevisar, estadoDevueltoDirReq]
                filtroDirector = Persona.get(session.usuario.id)
                break;
            case "ASAF":    // analista de planificacion
                estados = [estadoSolicitado, estadoDevueltoAnPlan]
                break;
        }

        def reformas = Reforma.withCriteria {
            eq("tipo", "R")
            eq("tipoSolicitud", "Q")
            if (estados.size() > 0) {
                inList("estado", estados)
            }
            if (unidades.size() > 0) {
                persona {
                    inList("unidad", unidades)
                }
            }
            if (filtroPersona) {
                eq("persona", filtroPersona)
            }
            if (filtroDirector) {
                eq("director", filtroDirector)
            }
        }

        def actual
        if (params.anio) {
            actual = Anio.get(params.anio)
        } else {
            actual = Anio.findByAnio(new Date().format("yyyy"))
        }

        def gerencias = []

        reformas.each {rf ->
            switch (rf.tipoSolicitud){
                case ['E', 'P', 'A']:
                    tx = "select sum(dtrfvlor) suma from dtrf where rfrm__id = ${rf.id} and asgn__id is not null"
                    break
                case ['Q']:
                    tx = "select sum(dtrfvlor) suma from dtrf where rfrm__id = ${rf.id} and tprf__id != '6'"
                    break
                default:
                    tx = "select sum(dtrfvlor) suma from dtrf where rfrm__id = ${rf.id} and asgn__id is null"
                    break
            }
            cn.eachRow(tx.toString()){
                totales[rf.id] = it.suma
            }
        }
        cn.close()

        reformas.each {
            gerencias += firmasService.requirentes(it.persona.unidad)
        }

//        println("reformas " + reformas)
//        println("gerencias " + gerencias)

        return [reformas: reformas, actual: actual, gerencias: gerencias, totales: totales]
    }


    /** evía a revisón la solicitud de reforma
     * define a donde va el aviso de alerta **/
    def saveNuevaReforma_ajax () {
        println("save nueva ref GP " + params)
        def anio = Anio.get(params.anio.toLong())
        def personaRevisa
        def estado = EstadoAval.findByCodigo("P01") //pendiente
        if (params.send == "S") {
            estado = EstadoAval.findByCodigo("R01") //por revisar
        }
        def now = new Date()
        def usu = Persona.get(session.usuario.id)
        def reforma
        if (params.id) {
            reforma = Reforma.get(params.id)
            personaRevisa = Persona.get(params.firma.toLong())
        }

        reforma.anio = anio
        reforma.persona = usu
        reforma.estado = estado
        reforma.concepto = params.concepto.trim()
        reforma.fecha = now
        reforma.tipo = "R"
        reforma.tipoSolicitud = "Q"
        reforma.director = personaRevisa
        if (!reforma.save(flush: true)) {
            println "error al guardar la reforma: " + reforma.errors
            render "ERROR*" + renderErrors(bean: reforma)
            return
        }

        def tipoStr = elm.tipoReformaStr(tipo: 'Reforma', tipoSolicitud: reforma.tipoSolicitud)

        if (params.send == "S") {
            println "nueva reforma : se hace la alerta y se manda mail"
            def alerta = new Alerta()
            alerta.from = usu
            alerta.persona = personaRevisa
            alerta.fechaEnvio = now
            alerta.mensaje = "Solicitud de ${tipoStr} (${now.format('dd-MM-yyyy')}): " + reforma.concepto
            alerta.controlador = "reformaPermanente"
            alerta.accion = "pendientes"
            alerta.id_remoto = reforma.id
            if (!alerta.save(flush: true)) {
                println "error alerta: " + alerta.errors
                render "ERROR*" + renderErrors(bean: reforma)
            }
            try {
                def mail = personaRevisa.mail
                if (mail) {
                    mailService.sendMail {
                        to mail
                        subject "Solicitud de reforma (${now.format('dd-MM-yyyy')}): " + reforma.concepto
                        body "Tiene una Solicitud de reforma pendiente que requiere su revisión"
                    }
                } else {
                    println "El usuario ${personaRevisa} no tiene email"
                }
                render "SUCCESS*Reforma solicitada exitosamente"
            } catch (e) {
                println "error email " + e.printStackTrace()
            }
        } else {
            println "no se manda: no se hace alerta ni se manda mail"
        }
        render "SUCCESS*Reforma solicitada exitosamente"
    }

    /**
     * Acción que muestra la lista de todas las reformas, con su estado y una opción para ver el pdf
     * Tipo de la solicitud     E: existente (ajustes -> 1 y reformas -> 1)
     P: inclusión de nuevas partidas (ajustes -> 2 y reformas -> 2)
     I: incremento de recursos (reformas -> 3)
     A: nueva actividad con financiamiento del área (ajustes -> 3 y reformas -> 4)
     C: nueva actividad sin financiamiento del área tipo --> 5
     T: Ajuste por modificación de techo presupuestario (ajustes -> 4)
     */
    def lista() {
//        println "lista ref: $params"
        def actual
        if (params.anio) {
            actual = Anio.get(params.anio)
        } else {
            actual = Anio.findByAnio(new Date().format("yyyy"))
        }
        def reformas
        def perfil = session.perfil.codigo
        def unidades = UnidadEjecutora.get(session.unidad.id).getUnidadesPorPerfil(perfil)

        def cn = dbConnectionService.getConnection()
        def totales = [:]
        def tx = ""
        reformas = Reforma.withCriteria {
            eq("tipo", "R")
            persona {
                if(params.requirente){
                    eq("unidad", UnidadEjecutora.get(params.requirente))
                } else {
                    inList("unidad", unidades)
                    order("unidad", "asc")
                }
            }
            if(params.anio){
                eq("anio", Anio.get(params.anio))
            }
            if(params.numero){
                eq("numeroReforma", params.numero.toInteger())
            }

            order("fecha", "desc")
        }

        reformas.each {rf ->
            switch (rf.tipoSolicitud){
                case ['E', 'P', 'A']:
                    tx = "select sum(dtrfvlor) suma from dtrf where rfrm__id = ${rf.id} and asgn__id is not null"
                    break
                case ['Q']:
                    tx = "select sum(dtrfvlor) suma from dtrf where rfrm__id = ${rf.id} and tprf__id != '6'"
                    break
                default:
                    tx = "select sum(dtrfvlor) suma from dtrf where rfrm__id = ${rf.id} and asgn__id is null"
                    break
            }
            cn.eachRow(tx.toString()){
                totales[rf.id] = it.suma
            }
        }
        cn.close()

        unidades = unidades.sort { it.nombre }

        params.actual = params.actual?:actual.id
        params.numero = params.numero
        params.requirente = params.requirente

        return [reformas: reformas, totales: totales, unidades: unidades, params: params]
    }

    def revisionSolicitud() {
        def reforma = Reforma.get(params.id)
        def estadosOK = ["R01", "D02"] //por revisar o devuelto dal dir req
        if (!reforma || !estadosOK.contains(reforma.estado.codigo)) {
            redirect(action: "lista")
        }

        def gerentes = firmasService.listaGerentesUnidad(reforma.persona.unidad)

        def detallesX = DetalleReforma.findAllByReforma(reforma)

        return [reforma: reforma, gerentes: gerentes, detallesX: detallesX ]
    }


    def enviarAGerente_ajax() {
        println "enviarAGerente_ajax params: $params"
        def solicitud = Reforma.get(params.id)
        def tipoStr = elm.tipoReformaStr(tipo: 'Reforma', tipoSolicitud: solicitud.tipoSolicitud)
        def usu = Persona.get(session.usuario.id)
        if (params.auth.toString().trim().encodeAsMD5() == usu.autorizacion) {
            def estadoSolicitadoSinFirma = EstadoAval.findByCodigo("EF4")
            def personaFirma, firma = null
            if (solicitud.estado.codigo == 'D02') {
                firma = solicitud.firmaSolicitud
                personaFirma = firma.usuario
            } else {
                personaFirma = Persona.get(params.firma.toLong())
            }

            if (personaFirma) {
                def mail = personaFirma.mail
                solicitud.estado = estadoSolicitadoSinFirma

                if (!firma) {
                    def accion
                    switch (solicitud.tipoSolicitud) {
                        case "E":
                            accion = "existente"
                            break;
                        case "A":
                            accion = "actividad"
                            break;
                        case "C":
                            accion = "incrementoActividad"
                            break;
                        case "I":
                            accion = "incremento"
                            break;
                        case "P":
                            accion = "partida"
                            break;
                        case "T":
                            accion = "techo"
                            break;
                        case "X":
                            accion = "nuevaReforma"
                            break;
                        case "Q":
                            accion = "reformaGp"
                            break;

                    }
                    firma = new Firma()
                    firma.usuario = personaFirma

                    firma.controlador = "reformaPermanente"
                    firma.accion = "firmarReforma"
                    firma.idAccion = solicitud.id

                    firma.controladorNegar = "reformaPermanente"
                    firma.accionNegar = "devolverADirectorRequirente"
                    firma.idAccionNegar = solicitud.id

                    firma.controladorVer = "reportesReforma"
                    firma.accionVer = accion
                    firma.idAccionVer = solicitud.id

                    firma.tipoFirma = "RFRM"
//                    firma.documento = "SolicitudDeAval_" + solicitud.proceso.nombre
                    firma.concepto = "Solicitud de ${tipoStr}: " + solicitud.concepto
                    if (!firma.save(flush: true)) {
                        println "error al guardar firma: " + firma.errors
                    } else {
                        solicitud.firmaSolicitud = firma
                    }
                } else {
                    firma.estado = "S"
                    firma.concepto = "Solicitud de ${tipoStr}: " + solicitud.concepto
                    if (!firma.save(flush: true)) {
                        println "error al guardar firma: " + firma.errors
                    }
                }
                solicitud.save(flush: true)

                def alerta1 = new Alerta()
                alerta1.from = usu
                alerta1.persona = personaFirma
                alerta1.fechaEnvio = new Date()
                alerta1.mensaje = "Solicitud de ${tipoStr}: " + solicitud.concepto
                alerta1.controlador = "firma"
                alerta1.accion = "firmasPendientes"
                alerta1.parametros = "tab=RFRM"
                alerta1.tipo = 'slct'
                alerta1.id_remoto = solicitud.id
                println alerta1
                if (!alerta1.save(flush: true)) {
                    println "error alerta1: " + alerta1.errors
                }
                if (mail) {
                    mailService.sendMail {
                        to mail
                        subject "Solicitud de ${tipoStr} requiere aprobación "
                        body "La solicitud de ${tipoStr}: " + solicitud.concepto + " requiere su firma de aprobación"
                    }
                } else {
                    println "no tiene mail..."
                }
                render "SUCCESS*Firma solicitada exitosamente"
            } else {
                render("ERROR*No se encontró la persona a la cual desea enviar la solicitud")
            }
        } else {
            render("ERROR*Clave de autorización incorrecta")
        }
    }


    /**
     * Acción para que un director requirente firme una solicitud de reforma
     */
    def firmarReforma() {
        def firma = Firma.findByKey(params.key)
        if (!firma) {
            response.sendError(403)
        } else {
            def reforma = Reforma.findByFirmaSolicitud(firma)
            def estadoSolicitado = EstadoAval.findByCodigo("E01")

//            def num = reforma.persona.unidad.gerencia.siguienteNumeroSolicitudReformaGp
            def num = firmasService.requirentes(reforma.persona.unidad).siguienteNumeroSolicitudReformaGp

            reforma.numero = num
            reforma.estado = estadoSolicitado
            reforma.save(flush: true)

            def perfilAnalista = Prfl.findByCodigo("ASAF")
            def analistas = Sesn.findAllByPerfil(perfilAnalista).usuario
            def now = new Date()
            def usu = Persona.get(session.usuario.id)
            def tipoStr = elm.tipoReformaStr(tipo: 'Reforma', tipoSolicitud: reforma.tipoSolicitud)
//            def accion
            def mensaje = "Solicitud de ${tipoStr}: "

            analistas.each { a ->
                def alerta = new Alerta()
                alerta.from = usu
                alerta.persona = a
                alerta.fechaEnvio = now
                alerta.mensaje = mensaje + reforma.concepto
                alerta.controlador = "reformaPermanente"
                alerta.accion = "pendientes"
                alerta.id_remoto = reforma.id
                if (!alerta.save(flush: true)) {
                    println "error alerta: " + alerta.errors
                }
            }

            render "ok"
        }
    }


    /**
     * Acción para que el analista de planificación apruebe y pida firmas o niegue la solicitud
     */
    def procesar() {
        def reforma = Reforma.get(params.id)
//        println "init: reforma=${reforma.id} estado reforma id=${reforma.estado.id} cod=${reforma.estado.codigo}"
        if (reforma.estado.codigo == "E01" || reforma.estado.codigo == "D03") {

        /*    def d

            switch (reforma.tipoSolicitud) {
                case "E": //existente
                    d = ReportesReformaController.generaDetallesSolicitudExistente(reforma)
                    break;
                case "A": //actividad
                    d = ReportesReformaController.generaDetallesSolicitudActividad(reforma)
                    break;
                case "C": //incremento actividad (a nuevas actividades sin origen)
                    d = ReportesReformaController.generaDetallesSolicitudIncrementoActividad(reforma)
                    break;
                case "P": //partida
                    d = ReportesReformaController.generaDetallesSolicitudPartida(reforma)
                    break;
                case "I": //incremento
                    d = ReportesReformaController.generaDetallesSolicitudIncremento(reforma)
                    break;
                case "X": //incremento
                    d = null
                    break;
            }
            def det = d?.det
            def det2 = d?.det2
            def detallado = d?.detallado
            def total = d?.total
            def totalSaldo
            if(d?.saldo){
                totalSaldo = Math.round(d?.saldo?:0 * 100)/100
            }else{
                totalSaldo = 0
            }*/

            def detallesX = null

            if(reforma?.tipoSolicitud == 'Q'){
                detallesX = DetalleReforma.findAllByReforma(reforma, [sort: 'tipoReforma.id', order: 'desc'])

            }
            println "........ detallesX: $detallesX"

            def firmas = firmasService.listaFirmasCorrientes()
            return [reforma : reforma, personas: firmas.directores,
                    gerentes: firmas.gerentes, tipo: reforma.tipoSolicitud, detallesX: detallesX]
        } else {
//            println "redireccionando: reforma=${reforma.id} estado reforma=${reforma.estado.codigo}"
            redirect(action: "pendientes")
        }
    }

    def asignacionOrigen_ajax () {
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

        List<ObjetivoGastoCorriente> objetivos = []
        ActividadCorriente.findAllByAnio(actual).each { ac ->
            def ob = ac.macroActividad.objetivoGastoCorriente
            if (!objetivos.contains(ob)) {
                objetivos += ob
            }
        }
        objetivos.sort { it.descripcion }

        println "objetivos: $objetivos"
        if(params.id){
            detalle = DetalleReforma.get(params.id)
        }

        return [objetivos:  objetivos, detalle: detalle]
    }


    /**
     * Acción que marca una solicitud como aprobada y a la espera de las firmas de aprobación
     */
    def aprobar() {
        println "aprobar.. ref GP: $params"
        def usu = Persona.get(session.usuario.id)
        def ok = true
        if (ok) {
            def now = new Date()
            def reforma = Reforma.get(params.id)
            def estadoAprobadoSinFirmas = EstadoAval.findByCodigo("EF1")

            def edit = reforma.estado.codigo == "D02"

            reforma.estado = estadoAprobadoSinFirmas
            reforma.fechaRevision = now
            reforma.analista = usu
            reforma.nota = params.observaciones.trim()

            def personaFirma1
            def personaFirma2

            def tipoStr = elm.tipoReformaStr(tipo: 'Reforma', tipoSolicitud: reforma.tipoSolicitud)

            def accion
            def mensaje = "Aprobación de ${tipoStr}"

            //E: existente, A: actividad, P: partida, I: incremento
            switch (reforma.tipoSolicitud) {
/*
                case "E":
                    accion = "existentePreviewReforma"
//                    accion = "existenteReforma"
//                mensaje = "Aprobación de ${tipoStr}"
                    break;
                case "A":
                    accion = "actividadPreviewReforma"
//                    accion = "actividadReforma"
//                mensaje = "Aprobación de ${tipoStr}"
                    break;
                case "C":
                    accion = "incrementoActividadPreviewReforma"
//                mensaje = "Aprobación de reforma de incremento a nuevas actividades"
                    break;
                case "P":
//                    accion = "partidaPreviewReforma"
                    accion = "partidaReforma"
//                mensaje = "Aprobación de reforma a nuevas partidas"
                    break;
                case "I":
                    accion = "incrementoPreviewReforma"
//                    accion = "incrementoReforma"
//                mensaje = "Aprobación de reforma de incremento"
                    params.each { k, v ->
                        if (k.toString().startsWith("r")) {
                            def parts = v.split("_")
                            if (parts.size() == 2) {
                                def detalle = DetalleReforma.get(parts[0].toLong())
                                def asignacionOrigen = Asignacion.get(parts[1].toLong())
                                detalle.asignacionOrigen = asignacionOrigen
                                detalle.save(flush: true)
                            }
                        }
                    }
                    break;
*/
                case "Q":
                    accion = "reformaGpPreviewReforma"
                    break;
            }

            if (edit) {
                def firma1 = reforma.firma1
                def firma2 = reforma.firma2

                personaFirma1 = firma1.usuario
                personaFirma2 = firma2.usuario

                firma1.estado = "S"
                firma1.concepto = "${mensaje} (${reforma.fecha.format('dd-MM-yyyy')}): " + reforma.concepto
                firma1.accionVer = accion
                firma2.estado = "S"
                firma2.concepto = "${mensaje} (${reforma.fecha.format('dd-MM-yyyy')}): " + reforma.concepto
                firma2.accionVer = accion

                firma1.save(flush: true)
                firma2.save(flush: true)

            } else {
                personaFirma1 = Persona.get(params.firma1.toLong())
                personaFirma2 = Persona.get(params.firma2.toLong())

                def firma1 = new Firma()
                firma1.usuario = personaFirma1
                firma1.fecha = now
                if(reforma.tipoSolicitud == 'X'){
                    firma1.accion = "firmarAprobarNuevaReforma"
                }else{
                    firma1.accion = "firmarAprobarReforma"
                }
                firma1.controlador = "reformaPermanente"
                firma1.idAccion = reforma.id
                firma1.accionVer = accion
                firma1.controladorVer = "reportesReforma"
                firma1.idAccionVer = reforma.id
                firma1.accionNegar = "devolverAprobarReforma"
                firma1.controladorNegar = "reformaPermanente"
                firma1.idAccionNegar = reforma.id
                firma1.concepto = "${mensaje} (${reforma.fecha.format('dd-MM-yyyy')}): " + reforma.concepto
                firma1.tipoFirma = "RFRM"
                if (!firma1.save(flush: true)) {
                    println "error al crear firma: " + firma1.errors
                    render "ERROR*" + renderErrors(bean: firma1)
                    return
                }
                reforma.firma1 = firma1

                def firma2 = new Firma()
                firma2.usuario = personaFirma2
                firma2.fecha = now
                if(reforma.tipoSolicitud == 'X'){
                    firma2.accion = "firmarAprobarNuevaReforma"
                }else{
                    firma2.accion = "firmarAprobarReforma"
                }
                firma2.controlador = "reformaPermanente"
                firma2.idAccion = reforma.id
                firma2.accionVer = accion
                firma2.controladorVer = "reportesReforma"
                firma2.idAccionVer = reforma.id
                firma2.accionNegar = "devolverAprobarReforma"
                firma2.controladorNegar = "reformaPermanente"
                firma2.idAccionNegar = reforma.id
                firma2.concepto = "${mensaje} (${reforma.fecha.format('dd-MM-yyyy')}): " + reforma.concepto
                firma2.tipoFirma = "RFRM"
                if (!firma2.save(flush: true)) {
                    println "error al crear firma: " + firma2.errors
                    render "ERROR*" + renderErrors(bean: firma2)
                    return
                }
                reforma.firma2 = firma2
            }

            def alerta = new Alerta()
            alerta.from = usu
            alerta.persona = personaFirma1
            alerta.fechaEnvio = now
            alerta.mensaje = "${mensaje} (${reforma.fecha.format('dd-MM-yyyy')}): " + reforma.concepto
            alerta.controlador = "firma"
            alerta.accion = "firmasPendientes"
            alerta.id_remoto = reforma.id /*agregado*/
            if (!alerta.save(flush: true)) {
                println "error alerta: " + alerta.errors
            }
            def alerta2 = new Alerta()
            alerta2.from = usu
            alerta2.persona = personaFirma2
            alerta2.fechaEnvio = now
            alerta2.mensaje = "${mensaje} (${reforma.fecha.format('dd-MM-yyyy')}): " + reforma.concepto
            alerta2.controlador = "firma"
            alerta2.accion = "firmasPendientes"
            alerta2.id_remoto = alerta.id_remoto
            if (!alerta2.save(flush: true)) {
                println "error alerta: " + alerta2.errors
            }

            reforma.save(flush: true)

            render "SUCCESS*Firmas solicitadas exitosamente"
        } else {
            render "ERROR*Clave de autorización incorrecta"
        }
    }

    def guardar() {
        def usu = Persona.get(session.usuario.id)
        def reforma = Reforma.get(params.id)
        reforma.analista = usu
        reforma.nota = params.observaciones.trim()
        reforma.save(flush: true)
        render "SUCCESS*Observaciones guardadas exitosamente"
    }


    /** firma de reforma y afectación de saldos gasto permanente **/
    def firmarAprobarReforma () {
        println "firmarAprobarReforma params: $params"
        def errores = ""

        def firma = Firma.findByKey(params.key)
        if (!firma) {
            response.sendError(403)
        } else {
            def reforma = Reforma.findByFirma1OrFirma2(firma, firma)

            if (reforma.firma1.estado == "F" && reforma.firma2.estado == "F") { //ya hay 2 firmas
                //busco el último número asignado para asignar el siguiente
                def ultimoNum = Reforma.withCriteria {
                    eq("tipo", "R")
                    projections {
                        max "numeroReformaGp"
                    }
                }

                def num = 1
                if (ultimoNum && ultimoNum.size() == 1) {
                    num = ultimoNum.first() + 1
                }

                def estadoAprobado = EstadoAval.findByCodigo("E02")
                reforma.estado = estadoAprobado
                reforma.numeroReformaGp = num
                reforma.save(flush: true)
                def usu = Persona.get(session.usuario.id)
                def now = new Date()

                def detalles

                detalles = DetalleReforma.findAllByReforma(reforma)

                println("detalles " + detalles)

                detalles.each { d->

                    switch (d?.tipoReforma?.codigo){
                        case "O":   //asignacion origen
                            println("entro origen")

                            def modificacionOrigen = new ModificacionAsignacion()
                            modificacionOrigen.usuario = usu
                            modificacionOrigen.desde = d?.asignacionOrigen
                            modificacionOrigen.fecha = now
                            modificacionOrigen.valor = d?.valor
                            modificacionOrigen.estado = 'A'
                            modificacionOrigen.detalleReforma = d
                            modificacionOrigen.originalOrigen = d?.asignacionOrigen?.priorizado

                            if (!modificacionOrigen.save(flush: true)) {
                                println "error al guardar modificacion tipo O: " + modificacionOrigen.errors
                                errores += renderErrors(bean: modificacionOrigen)
                            } else {
                                def asig = Asignacion.get(d?.asignacionOrigen?.id)
                                asig?.priorizado -= d?.valor
                                if (!asig.save(flush: true)) {
                                    println "error al guardar origen O: " + asig.errors
                                    errores += renderErrors(bean: asig)
                                }
                            }
                            break;

                        case "E":  //incremento
                            println("entro incremento")

                            def modificacionIncremento = new ModificacionAsignacion()
                            modificacionIncremento.usuario = usu
                            modificacionIncremento.recibe = d?.asignacionOrigen
                            modificacionIncremento.fecha = now
                            modificacionIncremento.valor = d?.valor
                            modificacionIncremento.estado = 'A'
                            modificacionIncremento.detalleReforma = d
                            modificacionIncremento.originalDestino = d?.asignacionOrigen?.priorizado

                            if (!modificacionIncremento.save(flush: true)) {
                                println "error al guardar modificacion tipo E: " + modificacionIncremento.errors
                                errores += renderErrors(bean: modificacionIncremento)
                            } else {
                                def asigDestino = Asignacion.get(d?.asignacionOrigen?.id)
                                asigDestino?.priorizado += d?.valor
                                if (!asigDestino.save(flush: true)) {
                                    println "error al guardar origen E: " + asigDestino.errors
                                    errores += renderErrors(bean: asigDestino)
                                }
                            }

                            break;
/*
                        case "A":  //creacion actividad
                            println("entro actividad")
                            def ultimoNumAct = MarcoLogico.withCriteria {
                                projections {
                                    max "numero"
                                }
                            }

                            def numAct = 1
                            if (ultimoNumAct && ultimoNumAct.size() == 1) {
                                numAct = ultimoNumAct.first() + 1
                            }

                            def nuevaActividad = new MarcoLogico()
                            nuevaActividad.proyecto = d?.componente?.proyecto
                            nuevaActividad.tipoElemento = TipoElemento.get(3)
                            nuevaActividad.marcoLogico = d?.componente
                            nuevaActividad.objeto = d?.descripcionNuevaActividad
                            nuevaActividad.monto = d?.valor
                            nuevaActividad.estado = 0
                            nuevaActividad.categoria = d?.categoria
                            nuevaActividad.fechaInicio = d?.fechaInicioNuevaActividad
                            nuevaActividad.fechaFin = d?.fechaFinNuevaActividad
                            nuevaActividad.responsable = reforma.persona.unidad
                            nuevaActividad.numero = numAct
                            nuevaActividad.reforma = reforma

                            if (!nuevaActividad.save(flush: true)) {
                                println "error al guardar la actividad A " + nuevaActividad.errors
                                errores += renderErrors(bean: nuevaActividad)
                            } else {

                                def destinoActividad = new Asignacion()
                                destinoActividad.anio = reforma.anio
                                destinoActividad.fuente = d?.fuente
                                destinoActividad.marcoLogico = nuevaActividad
                                destinoActividad.presupuesto = d?.presupuesto
                                destinoActividad.planificado = 0
                                destinoActividad.unidad = nuevaActividad.responsable
                                destinoActividad.priorizado = d?.valor
                                if (!destinoActividad.save(flush: true)) {
                                    println "error al guardar la asignacion A " + destinoActividad.errors
                                    errores += renderErrors(bean: destinoActividad)
                                    destinoActividad = null
                                }else{
                                    def modificacionActividad = new ModificacionAsignacion()
                                    modificacionActividad.usuario = usu
                                    modificacionActividad.recibe = destinoActividad
                                    modificacionActividad.fecha = now
                                    modificacionActividad.valor = d?.valor
                                    modificacionActividad.estado = 'A'
                                    modificacionActividad.detalleReforma = d
                                    modificacionActividad.originalDestino = destinoActividad?.priorizado

                                    if (!modificacionActividad.save(flush: true)) {
                                        println "error al guardar modificacion tipo A: " + modificacionActividad.errors
                                        errores += renderErrors(bean: modificacionActividad)
                                    } else {
//                                        render "ok"
                                    }
                                }

                            }
                            break;
*/
                        case "P":  //partida - priorizado original en 0, valor ingresado en priorizado, no tiene padre
                            println("entro partida")

                            def nuevaPartida = new Asignacion()
//                            nuevaPartida.anio = reforma.anio
                            nuevaPartida.anio = d?.anio
                            nuevaPartida.fuente = d?.fuente
                            nuevaPartida.tarea  = Tarea.get(d?.tarea)
                            nuevaPartida.presupuesto = d?.presupuesto
                            nuevaPartida.planificado = 0
                            nuevaPartida.priorizadoOriginal = 0
                            nuevaPartida.unidad = d?.responsable
                            nuevaPartida.priorizado = d?.valor
                            if (!nuevaPartida.save(flush: true)) {
                                println "error al guardar la nueva partida   " + nuevaPartida.errors
                                errores += renderErrors(bean: nuevaPartida)
                                nuevaPartida = null
                            }else{
                                def modificacionPartida = new ModificacionAsignacion()
                                modificacionPartida.usuario = usu
                                modificacionPartida.recibe = nuevaPartida
                                modificacionPartida.fecha = now
                                modificacionPartida.valor = d?.valor
                                modificacionPartida.estado = 'A'
                                modificacionPartida.detalleReforma = d
                                modificacionPartida.originalDestino = nuevaPartida?.priorizado

                                if (!modificacionPartida.save(flush: true)) {
                                    println "error al guardar modificacion tipo P: " + modificacionPartida.errors
                                    errores += renderErrors(bean: modificacionPartida)
                                } else {
//                                    render "ok"
                                }
                            }
                            break;
                    }
                }
            }
            println("errores "  + errores)
            if(errores != ""){

            }else{
                render "ok"
            }
        }
    }


}

