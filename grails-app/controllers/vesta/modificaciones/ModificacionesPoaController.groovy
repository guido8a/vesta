package vesta.modificaciones

import vesta.avales.ProcesoAsignacion
import vesta.parametros.TipoElemento
import vesta.parametros.UnidadEjecutora
import vesta.parametros.poaPac.Anio
import vesta.parametros.poaPac.Fuente
import vesta.parametros.poaPac.Mes
import vesta.parametros.poaPac.Presupuesto
import vesta.poa.Asignacion
import vesta.poa.ProgramacionAsignacion
import vesta.proyectos.MarcoLogico
import vesta.proyectos.ModificacionAsignacion
import vesta.proyectos.Proyecto
import vesta.seguridad.Firma
import vesta.seguridad.Persona
import vesta.seguridad.Shield

class ModificacionesPoaController extends Shield {

    def firmasService

    def index = {}

    def ajuste() {
        def proyectos = []
        def actual
        Asignacion.list().each {
//            println "p "+proyectos
            def p = it.marcoLogico.proyecto
            if (!proyectos?.id.contains(p.id)) {
                proyectos.add(p)
            }
        }
        if (params.anio)
            actual = Anio.get(params.anio)
        else
            actual = Anio.findByAnio(new Date().format("yyyy"))

        proyectos = proyectos.sort { it.nombre }

        def proyectos2 = Proyecto.findAllByAprobadoPoa('S', [sort: 'nombre'])

        def campos = ["numero": ["Número", "string"], "descripcion": ["Descripción", "string"]]
//        println "pro "+proyectos
        def unidad = UnidadEjecutora.findByCodigo("DPI") // DIRECCIÓN DE PLANIFICACIÓN E INVERSIÓN
        def personasFirmas = Persona.findAllByUnidad(unidad)
        def gerentes = Persona.findAllByUnidad(unidad.padre)

        [proyectos: proyectos, proyectos2: proyectos2, actual: actual, campos: campos, personas: gerentes + personasFirmas, personasGerente: gerentes]
    }

    def solicitar = {
        def proyectos = []
        def unidad = session.usuario.unidad
        def actual
        Asignacion.findAllByUnidad(unidad).each {
//            println "p "+proyectos
            def p = it.marcoLogico.proyecto
            println ">>> " + p + "   " + p.aprobadoPoa
            if (!proyectos?.id.contains(p.id) && p.aprobadoPoa == 'S') {
                proyectos.add(p)
            }
        }

        def proyectos2 = Proyecto.findAllByAprobadoPoa('S', [sort: 'nombre'])

        if (params.anio)
            actual = Anio.get(params.anio)
        else
            actual = Anio.findByAnio(new Date().format("yyyy"))

        def campos = ["numero": ["Número", "string"], "descripcion": ["Descripción", "string"]]
//        println "pro "+proyectos
        [proyectos: proyectos, actual: actual, campos: campos, proyectos2: proyectos2]
    }

    def modificar = {
        def proyectos = []
        def unidad = session.usuario.unidad
        Asignacion.findAllByUnidad(unidad).each {
//            println "p "+proyectos
            def p = it.marcoLogico.proyecto
            if (!proyectos?.id.contains(p.id)) {
                proyectos.add(p)
            }
        }

        def campos = ["numero": ["Número", "string"], "descripcion": ["Descripción", "string"]]
//        println "pro "+proyectos

        def solicitud = SolicitudModPoa.get(params.id)
        if (!solicitud) {
            redirect(action: "solicitar")
            return
        }

        def asignacionOrigen = solicitud.origen
        def actividadOrigen = asignacionOrigen.marcoLogico
        def componenteOrigen = actividadOrigen.marcoLogico
        def proyectoOrigen = componenteOrigen.proyecto
        def anioOrigen = asignacionOrigen.anio

        def componentesOrigen = MarcoLogico.findAllByProyectoAndTipoElemento(proyectoOrigen, TipoElemento.get(2))
        def actividadesOrigen = MarcoLogico.findAllByMarcoLogicoAndResponsable(componenteOrigen, unidad, [sort: "numero"])
        def asignacionesOrigen = Asignacion.findAllByMarcoLogicoAndAnio(actividadOrigen, anioOrigen)

        def asignacionDestino = solicitud.destino
        def actividadDestino = null
        def componenteDestino = null
        def proyectoDestino = null
        def anioDestino = null
        def componentesDestino = []
        def actividadesDestino = []
        def asignacionesDestino = []

        if (asignacionDestino) {
            actividadDestino = asignacionDestino.marcoLogico
            componenteDestino = actividadDestino.marcoLogico
            proyectoDestino = componenteDestino.proyecto
            anioDestino = asignacionDestino.anio

            componentesDestino = MarcoLogico.findAllByProyectoAndTipoElemento(proyectoDestino, TipoElemento.get(2))
            actividadesDestino = MarcoLogico.findAllByMarcoLogicoAndResponsable(componenteDestino, unidad, [sort: "numero"])
            asignacionesDestino = Asignacion.findAllByMarcoLogicoAndAnio(actividadDestino, anioDestino)
        }

        println "get Maximo asg " + params
        def monto = asignacionOrigen.priorizado
        def usado = 0;
        ProcesoAsignacion.findAllByAsignacion(asignacionOrigen).each {
            usado += it.monto
        }

        def max = (monto - usado)

        return [proyectos         : proyectos, campos: campos, solicitud: solicitud, max: max,
                anioOrigen        : anioOrigen, proyectoOrigen: proyectoOrigen, componenteOrigen: componenteOrigen, actividadOrigen: actividadOrigen, asignacionOrigen: asignacionOrigen,
                anioDestino       : anioDestino, proyectoDestino: proyectoDestino, componenteDestino: componenteDestino, actividadDestino: actividadDestino, asignacionDestino: asignacionDestino,
                componentesOrigen : componentesOrigen, actividadesOrigen: actividadesOrigen, asignacionesOrigen: asignacionesOrigen,
                componentesDestino: componentesDestino, actividadesDestino: actividadesDestino, asignacionesDestino: asignacionesDestino]
    }


    def componentesProyecto = {
//        println "comp "+params
        def proyecto = Proyecto.get(params.id)
        def comps = MarcoLogico.findAllByProyectoAndTipoElemento(proyecto, TipoElemento.get(2))
        [comps: comps, idCombo: params.idCombo, div: params.div]
    }


    def componentesProyectoAjuste_ajax = {
//        println "comp "+params
        def proyecto = Proyecto.get(params.id)
        def comps = MarcoLogico.findAllByProyectoAndTipoElemento(proyecto, TipoElemento.get(2))
        [comps: comps, idCombo: params.idCombo, div: params.div]
    }


    def componentesProyectoAjuste2_ajax = {
//        println "comp "+params
        def proyecto = Proyecto.get(params.id)
        def comps = MarcoLogico.findAllByProyectoAndTipoElemento(proyecto, TipoElemento.get(2))
        [comps: comps, idCombo: params.idCombo, div: params.div]
    }

    def getValor = {
        def asg = Asignacion.get(params.id)
        def valor = asg.priorizado
        if (!valor)
            valor = 0
        render "" + valor
    }

    def cargarActividades = {
        def comp = MarcoLogico.get(params.id)
        def unidad = session.usuario.unidad
        [acts: MarcoLogico.findAllByMarcoLogicoAndResponsable(comp, unidad, [sort: "numero"]), div: params.div, comboId: params.comboId]
    }

    def guardarAjuste() {
//        println "Guardar ajuste      " + params

        def origen = Asignacion.get(params.asg)
        def destino = Asignacion.get(params.asg_dest)

        def errores = ""

        def firma1 = new Firma()
        firma1.usuario = Persona.get(params.firma2.toLong())

        if (!firma1.save(flush: true)) {
            println "error al guardar firma1: " + firma1.errors
            errores += renderErrors(bean: firma1)
        }
        if (errores == "") {
            def firma2 = new Firma()
            firma2.usuario = Persona.get(params.firma3.toLong())

            if (!firma2.save(flush: true)) {
                println "error al guardar firma2: " + firma2.errors
                errores += renderErrors(bean: firma2)
            }
            if (errores == "") {
                def mod = new ModificacionAsignacion()
                mod.usuario = session.usuario
                mod.desde = origen
                mod.recibe = destino
                mod.valor = params.monto.toDouble()
                mod.fecha = new Date()
                mod.textoPdf = params.texto.trim()
                mod.firma1 = firma1
                mod.firma2 = firma2

                if (!mod.save(flush: true)) {
                    println "error al guardar mod temporal: " + mod.errors
                    errores += renderErrors(bean: mod)
                } else {
                    def concepto = "Ajuste de POA de ${g.formatNumber(number: mod.valor, type: 'currency')} de la actividad ${mod.desde.marcoLogico.numero} a ${mod.recibe.marcoLogico.numero}"
                    def controladorVer = "reporteReformaPoa"
                    def accionVer = "ajustePOA"
                    def controlador = "modificacionesPoa"
                    def accion = "firmarAjuste"
                    def controladorNegar = "modificacionesPoa"
                    def accionNegar = "negarAjuste"

                    firma1.concepto = concepto
                    firma1.controladorVer = controladorVer
                    firma1.accionVer = accionVer
                    firma1.idAccionVer = mod.id
                    firma1.controlador = controlador
                    firma1.accion = accion
                    firma1.idAccion = mod.id
                    firma1.accion = accion
                    firma1.idAccion = mod.id

                    firma2.concepto = concepto
                    firma2.controladorVer = controladorVer
                    firma2.accionVer = accionVer
                    firma2.idAccionVer = mod.id
                    firma2.controlador = controlador
                    firma2.accion = accion
                    firma2.idAccion = mod.id

                    if (!firma1.save(flush: true)) {
                        println "error al actualizar la firma 1: " + firma1.errors
                    }
                    if (!firma2.save(flush: true)) {
                        println "error al actualizar la firma 2: " + firma2.errors
                    }

                }
            }
        }
        if (errores == "") {
            render "SUCCESS*Ajuste guardado exitosamente"
        } else {
            render "ERROR*" + errores
        }
    }

    def listaAjustes() {

    }

    def listaAjustes_ajax() {
        println "LISTA: " + params
        /*
        search_hasta:07-04-2015,
        search_desde:01-04-2015,
        search_estado:P
         */
        def ajustes = ModificacionAsignacion.withCriteria {
            if (params.search_persona) {
                or {
                    firma1 {
                        eq("usuario", Persona.get(params.search_persona.toLong()))
                    }
                    firma2 {
                        eq("usuario", Persona.get(params.search_persona.toLong()))
                    }
                }
            }
            if (params.search_desde) {
                ge("fecha", new Date().parse("dd-MM-yyyy", params.search_desde))
            }
            if (params.search_hasta) {
                le("fecha", new Date().parse("dd-MM-yyyy", params.search_hasta))
            }
            if (params.search_estado == "P") {
                or {
                    firma1 {
                        eq("estado", "S")
                    }
                    firma2 {
                        eq("estado", "S")
                    }
                }
            } else if (params.search_estado == "A") {
                and {
                    firma1 {
                        eq("estado", "F")
                    }
                    firma2 {
                        eq("estado", "F")
                    }
                }
            }
            order("fecha", "desc")
        }
        return [ajustes: ajustes, params: params]
    }

    def ajustesPendientes() {
        def usu = Persona.get(session.usuario.id)
        return [usu: usu]
    }

    def firmarAjuste() {
        def firma = Firma.findByKey(params.key)
        if (!firma)
            response.sendError(403)
        else {
            def ajuste = ModificacionAsignacion.findByFirma1OrFirma2(firma, firma)

            if (ajuste.firma1.estado == "F" && ajuste.firma2.estado == "F") {
                //ya firmaron las 2 personas: se hace el cambio en las asignaciones
                def msg = ""
                def origen = ajuste.desde
                def destino = ajuste.recibe

                origen.priorizado = origen.priorizado - ajuste.valor
                destino.priorizado = destino.priorizado + ajuste.valor

                if (origen.save(flush: true)) {
                    msg += "<li>Asignación de origen modificada exitosamente</li>"
                } else {
                    println "error origen: " + origen.errors
                    flash.message = "Ocurrió un error al procesar la asignación de origen de la modificación."
                    redirect(controller: "modificacionesPoa", action: "ajustesPendientes")
                    return
                }

                if (destino.save(flush: true)) {
                    msg += "<li>Asignación de destino modificada exitosamente</li>"
                } else {
                    println "error destino: " + destino.errors
                    flash.message = "Ocurrió un error al procesar la asignación destino de la modificación."
                    redirect(controller: "modificacionesPoa", action: "ajustesPendientes")
                    return
                }
            }

            def url = g.createLink(controller: "pdf", action: "pdfLink", params: [url: g.createLink(controller: firma.controladorVer, action: firma.accionVer, id: firma.idAccionVer)])
            render "${url}"
        }
    }

    def negarAjuste() {

    }

    def firmarAjuste_ajax() {
        def ajuste = ModificacionAsignacion.get(params.id.toLong())
        def auth = params.pass.toString().trim()

        def usu = Persona.get(session.usuario.id)
        def firma = null
        if (ajuste.firma1Id == usu.id) {
            firma = ajuste.firma1
        } else if (ajuste.firma2Id == usu.id) {
            firma = ajuste.firma2
        }
        if (firma != null) {
            def baseUri = request.scheme + "://" + request.serverName + ":" + request.serverPort

            firmasService.firmarDocumento(usu, auth, firma, baseUri)

            if (ajuste.firma1.key && ajuste.firma2.key) {
                //Aqui se hace el cambio de verdad y se crea la modificacion en la otra tabla
                def mod = new ModificacionAsignacion()
                def origen = ajuste.desde
                def destino = ajuste.recibe
                mod.desde = ajuste.desde
                mod.recibe = ajuste.recibe
                mod.valor = ajuste.valor
                mod.fecha = new Date()
                mod.unidad = ajuste.unidad
                origen.priorizado = origen.priorizado - ajuste.valor
                destino.priorizado = destino.priorizado + ajuste.valor


                if (origen.save(flush: true)) {

                } else {
                    println "error origen: " + origen.errors
                    flash.message = "Ocurrió un error al procesar la asignación de origen de la modificación."
                    redirect(controller: "modificacionesPoa", action: "ajustesPendientes")
                    return
                }

                if (destino.save(flush: true)) {

                } else {
                    println "error destino: " + destino.errors
                    flash.message = "Ocurrió un error al procesar la asignación destino de la modificación."
                    redirect(controller: "modificacionesPoa", action: "ajustesPendientes")
                    return
                }

                if (mod.save(flush: true)) {

                } else {
                    println "error mod: " + mod.errors
                    flash.message = "Ocurrió un error al procesar la modificación."
                    redirect(controller: "modificacion", action: "poaInversionesMod", id: params.proyecto)
                    return
                }

            }

        } else {
            render "ERROR*No puede firmar el ajuste seleccionado"
        }
    }

    def guardarSolicitudReasignacion = {
//        println "params "+params

        def solicitud = new SolicitudModPoa()
        if (params.id) {
            solicitud = SolicitudModPoa.get(params.id)
            if (!solicitud) {
                solicitud = new SolicitudModPoa()
            }
        }
        solicitud.concepto = params.concepto
        solicitud.usuario = session.usuario
        solicitud.tipo = "R"
        solicitud.estado = 4
        solicitud.origen = Asignacion.get(params.origen)
        solicitud.destino = Asignacion.get(params.destino)
        solicitud.valorOrigenSolicitado = solicitud.origen.priorizado
        solicitud.valorDestinoSolicitado = solicitud.destino.priorizado
        solicitud.valor = params.monto?.toDouble()
        if (!solicitud.save(flush: true)) {
            println "error save sol mod poa " + solicitud.errors
        } else {
            def firma = new Firma()
            firma.usuario = Persona.get(params.firma)
            firma.accionVer = "solicitudReformaPdf"
            firma.controladorVer = "reporteSolicitud"
            firma.accion = "firmarSolicitud"
            firma.idAccion = solicitud.id
            firma.idAccionVer = solicitud.id
            firma.controlador = "modificacionesPoa"
            firma.documento = "SolicitudDeModificacionPoa_" + solicitud.id
            firma.concepto = "Solicitud de modificación del P.O.A. "
            if (!firma.save(flush: true))
                println "error firma save " + firma.errors
            else {
                solicitud.firmaSol = firma
                solicitud.save(flush: true)
            }

        }
        flash.message = "Solicitud enviada"
        render "ok"
    }
    def firmarSolicitud = {
        def firma = Firma.findByKey(params.key)
        if (!firma)
            response.sendError(403)
        else {
            def sol = SolicitudModPoa.findByFirmaSol(firma)
            sol.estado = 0
            sol.save(flush: true)
//            redirect(controller: "pdf",action: "pdfLink",params: [url:g.createLink(controller: firma.controladorVer,action: firma.accionVer,id: firma.idAccionVer)])
            def url = g.createLink(controller: "pdf", action: "pdfLink", params: [url: g.createLink(controller: firma.controladorVer, action: firma.accionVer, id: firma.idAccionVer)])
            render "${url}"
        }
    }

    def guardarSolicitudNueva = {
//        println "params nueva"+params
        def inicio = new Date().parse("dd-MM-yyyy", params.inicio)
        def fin = new Date().parse("dd-MM-yyyy", params.fin)
        def solicitud = new SolicitudModPoa()
        if (params.id) {
            solicitud = SolicitudModPoa.get(params.id)
            if (!solicitud) {
                solicitud = new SolicitudModPoa()
            }
        }
        solicitud.anio = Anio.get(params.anio.toLong())
        solicitud.concepto = params.concepto
        solicitud.usuario = session.usuario
        solicitud.tipo = "N"
        solicitud.inicio = inicio
        solicitud.fin = fin
        solicitud.origen = Asignacion.get(params.origen)
        solicitud.fuente = Fuente.get(params.fuente)
        solicitud.actividad = params.actividad
        solicitud.valorOrigenSolicitado = solicitud.origen.priorizado
        solicitud.valorDestinoSolicitado = 0
        solicitud.estado = 4
//        solicitud.marcoLogico = MarcoLogico.get(params.actividad)
        solicitud.presupuesto = Presupuesto.get(params.presupuesto)
        solicitud.valor = params.monto?.toDouble()
        if (!solicitud.save(flush: true)) {
            println "error save sol mod poa " + solicitud.errors
        } else {
            def firma = new Firma()
            firma.usuario = Persona.get(params.firma)
            firma.accionVer = "solicitudReformaPdf"
            firma.controladorVer = "reporteSolicitud"
            firma.accion = "firmarSolicitud"
            firma.controlador = "modificacionesPoa"
            firma.idAccion = solicitud.id
            firma.idAccionVer = solicitud.id
            firma.documento = "SolicitudDeModificacionPoa_" + solicitud.id
            firma.concepto = "Solicitud de modificación del P.O.A. "
            firma.save(flush: true)
            solicitud.firmaSol = firma
            solicitud.save(flush: true)
        }
        flash.message = "Solicitud enviada"
        render "ok"
    }

    def guardarSolicitudDerivada = {
//        println "params derivada "+params

        def solicitud = new SolicitudModPoa()
        if (params.id) {
            solicitud = SolicitudModPoa.get(params.id)
            if (!solicitud) {
                solicitud = new SolicitudModPoa()
            }
        }
        solicitud.concepto = params.concepto
        solicitud.usuario = session.usuario
        solicitud.tipo = "D"
        solicitud.origen = Asignacion.get(params.origen)
        solicitud.valor = params.monto?.toDouble()
        solicitud.estado = 4
        solicitud.valorOrigenSolicitado = solicitud.origen.priorizado
        solicitud.valorDestinoSolicitado = 0
        if (!solicitud.save(flush: true)) {
            println "error save sol mod poa " + solicitud.errors
        } else {
            def firma = new Firma()
            firma.usuario = Persona.get(params.firma)
            firma.accionVer = "solicitudReformaPdf"
            firma.controladorVer = "reporteSolicitud"
            firma.accion = "firmarSolicitud"
            firma.controlador = "modificacionesPoa"
            firma.idAccion = solicitud.id
            firma.idAccionVer = solicitud.id
            firma.documento = "SolicitudDeModificacionPoa_" + solicitud.id
            firma.concepto = "Solicitud de modificación del P.O.A. "
            firma.save(flush: true)
            solicitud.firmaSol = firma
            solicitud.save(flush: true)
        }
        flash.message = "Solicitud enviada"
        render "ok"
    }

    def guardarSolicitudAumentar = {
        def solicitud = new SolicitudModPoa()
        if (params.id) {
            solicitud = SolicitudModPoa.get(params.id)
            if (!solicitud) {
                solicitud = new SolicitudModPoa()
            }
        }
        solicitud.concepto = params.concepto
        solicitud.usuario = session.usuario
        solicitud.tipo = "A"
        solicitud.origen = Asignacion.get(params.origen)
        solicitud.valor = params.monto?.toDouble()
        solicitud.valorOrigenSolicitado = solicitud.origen.priorizado
        solicitud.valorDestinoSolicitado = 0
        solicitud.estado = 4
        if (!solicitud.save(flush: true)) {
            println "error save sol mod poa " + solicitud.errors
        } else {
            def firma = new Firma()
            firma.usuario = Persona.get(params.firma)
            firma.accionVer = "solicitudReformaPdf"
            firma.controladorVer = "reporteSolicitud"
            firma.accion = "firmarSolicitud"
            firma.controlador = "modificacionesPoa"
            firma.idAccion = solicitud.id
            firma.idAccionVer = solicitud.id
            firma.documento = "SolicitudDeModificacionPoa_" + solicitud.id
            firma.concepto = "Solicitud de Reforma del P.O.A. "
            firma.save(flush: true)
            solicitud.firmaSol = firma
            solicitud.save(flush: true)
        }
        flash.message = "Solicitud enviada"
        render "ok"
    }

    def guardarSolicitudEliminar = {
//        println "params eliminar "+params

        def solicitud = new SolicitudModPoa()
        solicitud.concepto = params.concepto
        solicitud.usuario = session.usuario
        solicitud.tipo = "E"
        solicitud.origen = Asignacion.get(params.origen)
        if (!solicitud.save(flush: true)) {
            println "error save sol mod poa " + solicitud.errors
        }
        flash.message = "Solicitud enviada"
        render "ok"
    }

    def listaPendientes = {
        def sols = SolicitudModPoa.findAllByEstado(0)
        def historial = SolicitudModPoa.findAllByEstadoNotInList([0, 4], [sort: "fechaRevision", order: "desc"])
        [solicitudes: sols, historial: historial]
    }

    def cargarAsignaciones = {
        def act = MarcoLogico.get(params.id)
        def anio = Anio.get(params.anio)
//        println "asgs "+ Asignacion.findAllByMarcoLogicoAndAnio(act, anio)
        [asgs: Asignacion.findAllByMarcoLogicoAndAnio(act, anio), div: params.div]
    }

    def verSolicitud = {
        def sol = SolicitudModPoa.get(params.id)

        def unidadGerencia = UnidadEjecutora.findByCodigo("GPE") // GERENCIA DE PLANIFICACIÓN ESTRATÉGICA
        def personasGerencia = Persona.findAllByUnidad(unidadGerencia)

        def unidad = UnidadEjecutora.findByCodigo("DPI") // DIRECCIÓN DE PLANIFICACIÓN E INVERSIÓN
        def personasFirmas = Persona.findAllByUnidad(unidad)


        unidad = UnidadEjecutora.findByCodigo("DRPL")
        def perGerencia = Persona.findAllByUnidad(unidad)

        return [sol: sol, personas: personasGerencia + personasFirmas, perGerencia: personasGerencia]
    }


    def negar = {
        def sol = SolicitudModPoa.get(params.id)
        sol.estado = 2
        sol.fechaRevision = new Date()
        sol.observaciones = params.obs
        sol.revisor = session.usuario
        sol.save(flush: true)
        flash.message = "Solicitud negada"

        render "ok"
    }
    def aprobar = {
        println("params " + params)
        def sol = SolicitudModPoa.get(params.id)
        sol.estado = 5
        sol.fechaRevision = new Date()
        sol.observaciones = params.obs
        sol.revisor = session.usuario

        def firma1 = new Firma()
        firma1.usuario = Persona.get(params.firma1)
        firma1.accionVer = "reformaPoa"
        firma1.controladorVer = "reporteReformaPoa"
        firma1.idAccionVer = sol.id
        firma1.accion = "firmarModificacion"
        firma1.controlador = "modificacionesPoa"
        firma1.documento = "reformaPoa_" + sol.id
        firma1.concepto = "Aprobación de la reforma del P.O.A. No${sol.id}"
        firma1.esPdf = "S"
        if (!firma1.save(flush: true))
            println "error firma1 " + firma1.errors
        def firma2 = new Firma()
        firma2.usuario = Persona.get(params.firma2)
        firma2.accionVer = "reformaPoa"
        firma2.controladorVer = "reporteReformaPoa"
        firma2.idAccionVer = sol.id
        firma2.accion = "firmarModificacion"
        firma2.controlador = "modificacionesPoa"
        firma2.documento = "reformaPoa_" + sol.id
        firma2.concepto = "Aprobación de la reforma del P.O.A. No${sol.id}"
        firma2.esPdf = "S"
        if (!firma2.save(flush: true))
            println "error firma2 " + firma2.errors
        sol.firma1 = firma1
        sol.firma2 = firma2

//        println("firmas " + sol.firma1.id + sol.firma2.id)

        sol.save(flush: true)
//        ejecutarSolicitud(sol)
        /*Aqui guardar firmas*/
        flash.message = "Solicitud aprobada"
        render "ok"
    }

    /**
     * Acción que permite firmar electrónicamente un Aval
     * @params id es el identificador del aval
     */
    def firmarModificacion = {
        def firma = Firma.findByKey(params.key)
        if (!firma)
            response.sendError(403)
        else {
            def sol = SolicitudModPoa.findByFirma1OrFirma2(firma, firma)
            if (sol.firma1.key != null && sol.firma2.key != null) {
                sol.estado = 1
                sol.save(flush: true)
                ejecutarSolicitud(sol)
//            redirect(controller: "pdf",action: "pdfLink",params: [url:g.createLink(controller: firma.controladorVer,action: firma.accionVer,id: firma.idAccionVer)])

            }
            def url = g.createLink(controller: "pdf", action: "pdfLink", params: [url: g.createLink(controller: firma.controladorVer, action: firma.accionVer, id: firma.idAccionVer)])
            render "${url}"

        }
    }

    def historialUnidad = {
        def sols = []
        def unidad = session.usuario.unidad
        SolicitudModPoa.list().each {
            if (it.usuario.unidad?.id == unidad.id) {
                sols.add(it)
            }
        }
        [sols: sols, unidad: unidad]

    }

    def ejecutarSolicitud(SolicitudModPoa solicitud) {
        def msg = ""
        def origen = solicitud.origen

        if (origen.priorizado == 0) {
            msg = "No tiene valor priorizado"
            return [false, msg]
        }
        solicitud.valorOrigen = solicitud.origen.priorizado
        println "tipo " + solicitud.tipo
        switch (solicitud.tipo) {
            case "R":
                def destino = solicitud.destino
                solicitud.valorDestino = solicitud.destino.priorizado
                if (destino) {
                    ProgramacionAsignacion.findAllByAsignacion(origen).each {
                        it.delete()
                    }
                    origen.priorizado -= solicitud.valor
                    origen.save(flush: true)
                    guardarPrasPrio(origen)
                    ProgramacionAsignacion.findAllByAsignacion(destino).each {
                        it.delete()
                    }
                    destino.priorizado += solicitud.valor
                    destino.save(flush: true)
                    guardarPrasPrio(destino)
                    solicitud.estado = 3
                    solicitud.save(flush: true)
                    return [true, ""]

                } else {
                    msg = "No hay asignación de destino"
                    return [false, msg]
                }
                break;
            case "N":
                def nueva = new MarcoLogico()
                solicitud.valorDestino = 0
                nueva.marcoLogico = origen.marcoLogico.marcoLogico
                nueva.tipoElemento = origen.marcoLogico.tipoElemento
                nueva.monto = solicitud.valor
                nueva.objeto = solicitud.actividad
                nueva.responsable = solicitud.usuario.unidad
                nueva.fechaInicio = solicitud.inicio
                nueva.fechaFin = solicitud.fin
                nueva.proyecto = origen.marcoLogico.proyecto
                nueva.categoria = origen.marcoLogico.categoria
                def maxNum = MarcoLogico.list([sort: "numero", order: "desc", max: 1])?.pop()?.numero
                if (maxNum)
                    maxNum = maxNum + 1
                else
                    maxNum = 1
                nueva.numero = maxNum
                if (!nueva.save(flush: true)) {
                    println "error save actividad " + nueva.errors
                    msg = "Error al crear la actividad"
                    return [false, msg]
                } else {
                    println "grabo " + nueva.id
                    nueva.marcoLogico.monto += solicitud.valor
                    nueva.marcoLogico.save(flush: true)
                    def asg = new Asignacion()
                    asg.marcoLogico = nueva
                    asg.planificado = solicitud.valor
                    asg.priorizado = solicitud.valor
                    asg.anio = origen.anio
                    asg.fuente = solicitud.fuente
                    asg.unidad = nueva.responsable
                    asg.presupuesto = solicitud.presupuesto
                    if (!asg.save(flush: true)) {
                        println "error save asg " + asg.errors
                        nueva.delete()
                        msg = "Error al crear la asignación"
                        return [false, msg]
                    } else {
//                        origen.priorizado-=solicitud.valor
//                        origen.save(flush: true)
                        ProgramacionAsignacion.findAllByAsignacion(origen).each {
                            it.delete()
                        }
                        guardarPrasPrio(asg)
                        origen.priorizado -= solicitud.valor
                        origen.save(flush: true)
                        guardarPrasPrio(origen)
                        solicitud.estado = 3
                        solicitud.save(flush: true)
                        return [true, ""]
                    }

                }

                break;
            case "D":
                def nueva = new Asignacion()
                def valor = solicitud.valor
                solicitud.valorDestino = 0
//                def asgn = origen
                def fnte = origen.fuente
                def prsp = origen.presupuesto
                def resultado = 0
                // debe borrar el registro actual de pras y crear uno nuevo con los nuevos valores

                nueva.marcoLogico = origen.marcoLogico
                nueva.programa = origen.programa
                nueva.actividad = origen.actividad
                nueva.anio = origen.anio
                nueva.indicador = origen.indicador
                nueva.meta = origen.meta
                nueva.componente = origen.componente
                nueva.padre = origen
                nueva.fuente = fnte
                nueva.presupuesto = prsp
                nueva.planificado = valor
                nueva.priorizado = valor
                nueva.unidad = origen.unidad
                /*me quede aqui... falta probar*/
//            println "pone padre: ${nueva.padre}  ${nueva.unidad}"
                nueva.save(flush: true)
                if (nueva.errors.getErrorCount() == 0) {
                    println "crea la progrmaación de " + nueva.id
                    guardarPrasPrio(nueva)
                    ProgramacionAsignacion.findAllByAsignacion(origen).each {
                        it.delete()
                    }
                    origen.priorizado -= valor
                    origen.save(flush: true)
                    guardarPrasPrio(origen)
                    solicitud.estado = 3
                    solicitud.save(flush: true)
                    return [true, ""]
                } else {
                    println "error save asg nueva " + nueva.errors
                    msg = "Error al crear la asignación derivada"
                    return [false, msg]
                }

                break;
            case "A":
                solicitud.estado = 3
                solicitud.save(flush: true)
                return [true, ""]
                break
            default:
                println "wtf tipo--> " + solicitud.tipo + "  " + solicitud.id + " " + new Date()
                msg = "Error interno"
                return [false, msg]
                break;
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
            println "total " + total + " valor " + valor + " res " + residuo
//            println "calc "+ (valor.toDouble()*12)
//            println "calc 2 "+ (total-valor*12).toFloat().round(2)

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

}
