package vesta.modificaciones

import vesta.parametros.TipoElemento
import vesta.parametros.UnidadEjecutora
import vesta.parametros.poaPac.Anio
import vesta.parametros.poaPac.Fuente
import vesta.parametros.poaPac.Mes
import vesta.parametros.poaPac.Presupuesto
import vesta.poa.Asignacion
import vesta.poa.ProgramacionAsignacion
import vesta.proyectos.MarcoLogico
import vesta.proyectos.Proyecto
import vesta.seguridad.Firma
import vesta.seguridad.Persona

class ModificacionesPoaController {

    def index = {}

    def solicitar ={
        def proyectos = []
        def unidad = session.usuario.unidad
        def actual
        Asignacion.findAllByUnidad(unidad).each {
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

        def campos = ["numero": ["Número", "string"],"descripcion": ["Descripción", "string"]]
//        println "pro "+proyectos
        [proyectos:proyectos,actual:actual,campos:campos]
    }


    def componentesProyecto = {
//        println "comp "+params
        def proyecto = Proyecto.get(params.id)
        def comps = vesta.proyectos.MarcoLogico.findAllByProyectoAndTipoElemento(proyecto, TipoElemento.get(2))
        [comps:comps,idCombo:params.idCombo,div:params.div]
    }

    def getValor = {
        def asg = Asignacion.get(params.id)
        def valor = asg.priorizado
        if(!valor)
            valor=0
        render ""+valor
    }

    def cargarActividades = {
        def comp = MarcoLogico.get(params.id)
        def unidad = session.usuario.unidad
        [acts: MarcoLogico.findAllByMarcoLogicoAndResponsable(comp, unidad, [sort: "numero"]),div:params.div,comboId:params.comboId]
    }

    def guardarSolicitudReasignacion = {
//        println "params "+params

        def solicitud = new SolicitudModPoa()
        solicitud.concepto=params.concepto
        solicitud.usuario=session.usuario
        solicitud.tipo="R"
        solicitud.estado=4
        solicitud.origen=Asignacion.get(params.origen)
        solicitud.destino=Asignacion.get(params.destino)
        solicitud.valorOrigenSolicitado=solicitud.origen.priorizado
        solicitud.valorDestinoSolicitado=solicitud.destino.priorizado
        solicitud.valor=params.monto?.toDouble()
        if(!solicitud.save(flush: true)){
            println "error save sol mod poa "+solicitud.errors
        }else{
            def firma = new Firma()
            firma.usuario=Persona.get(params.firma)
            firma.accionVer="solicitudReformaPdf"
            firma.controladorVer="reporteSolicitud"
            firma.accion="firmarSolicitud"
            firma.idAccion=solicitud.id
            firma.idAccionVer=solicitud.id
            firma.controlador="modificacionesPoa"
            firma.documento="SolicitudDeModificacionPoa_"+ solicitud.id
            firma.concepto="Solicitud de modificación del P.O.A. "
            if(!firma.save(flush: true))
                println "error firma save "+firma.errors
            else{
                solicitud.firmaSol = firma
                solicitud.save(flush: true)
            }

        }
        flash.message="Solicitud enviada"
        render "ok"
    }
    def firmarSolicitud = {
        def firma = Firma.findByKey(params.key)
        if(!firma)
            response.sendError(403)
        else{
            def sol = SolicitudModPoa.findByFirmaSol(firma)
            sol.estado=0
            sol.save(flush: true)
//            redirect(controller: "pdf",action: "pdfLink",params: [url:g.createLink(controller: firma.controladorVer,action: firma.accionVer,id: firma.idAccionVer)])
            def url =g.createLink(controller: "pdf",action: "pdfLink",params: [url:g.createLink(controller: firma.controladorVer,action: firma.accionVer,id: firma.idAccionVer)])
            render "${url}"
        }
    }

    def guardarSolicitudNueva = {
//        println "params nueva"+params
        def inicio = new Date().parse("dd-MM-yyyy", params.inicio)
        def fin = new Date().parse("dd-MM-yyyy", params.fin)
        def solicitud = new SolicitudModPoa()
        solicitud.concepto=params.concepto
        solicitud.usuario=session.usuario
        solicitud.tipo="N"
        solicitud.inicio = inicio
        solicitud.fin = fin
        solicitud.origen=Asignacion.get(params.origen)
        solicitud.fuente=Fuente.get(params.fuente)
        solicitud.actividad=params.actividad
        solicitud.valorOrigenSolicitado=solicitud.origen.priorizado
        solicitud.valorDestinoSolicitado=0
        solicitud.estado=4
//        solicitud.marcoLogico = MarcoLogico.get(params.actividad)
        solicitud.presupuesto = Presupuesto.get(params.presupuesto)
        solicitud.valor=params.monto?.toDouble()
        if(!solicitud.save(flush: true)){
            println "error save sol mod poa "+solicitud.errors
        }else{
            def firma = new Firma()
            firma.usuario=Persona.get(params.firma)
            firma.accionVer="solicitudReformaPdf"
            firma.controladorVer="reporteSolicitud"
            firma.accion="firmarSolicitud"
            firma.controlador="modificacionesPoa"
            firma.idAccion=solicitud.id
            firma.idAccionVer=solicitud.id
            firma.documento="SolicitudDeModificacionPoa_"+ solicitud.id
            firma.concepto="Solicitud de modificación del P.O.A. "
            firma.save(flush: true)
            solicitud.firmaSol = firma
            solicitud.save(flush: true)
        }
        flash.message="Solicitud enviada"
        render "ok"
    }

    def guardarSolicitudDerivada = {
//        println "params derivada "+params

        def solicitud = new SolicitudModPoa()
        solicitud.concepto=params.concepto
        solicitud.usuario=session.usuario
        solicitud.tipo="D"
        solicitud.origen=Asignacion.get(params.origen)
        solicitud.valor=params.monto?.toDouble()
        solicitud.estado=4
        solicitud.valorOrigenSolicitado=solicitud.origen.priorizado
        solicitud.valorDestinoSolicitado=0
        if(!solicitud.save(flush: true)){
            println "error save sol mod poa "+solicitud.errors
        }else{
            def firma = new Firma()
            firma.usuario=Persona.get(params.firma)
            firma.accionVer="solicitudReformaPdf"
            firma.controladorVer="reporteSolicitud"
            firma.accion="firmarSolicitud"
            firma.controlador="modificacionesPoa"
            firma.idAccion=solicitud.id
            firma.idAccionVer=solicitud.id
            firma.documento="SolicitudDeModificacionPoa_"+ solicitud.id
            firma.concepto="Solicitud de modificación del P.O.A. "
            firma.save(flush: true)
            solicitud.firmaSol = firma
            solicitud.save(flush: true)
        }
        flash.message="Solicitud enviada"
        render "ok"
    }

    def guardarSolicitudAumentar = {
        def solicitud = new SolicitudModPoa()
        solicitud.concepto=params.concepto
        solicitud.usuario=session.usuario
        solicitud.tipo="A"
        solicitud.origen=Asignacion.get(params.origen)
        solicitud.valor=params.monto?.toDouble()
        solicitud.valorOrigenSolicitado=solicitud.origen.priorizado
        solicitud.valorDestinoSolicitado=0
        solicitud.estado=4
        if(!solicitud.save(flush: true)){
            println "error save sol mod poa "+solicitud.errors
        }else{
            def firma = new Firma()
            firma.usuario=Persona.get(params.firma)
            firma.accionVer="solicitudReformaPdf"
            firma.controladorVer="reporteSolicitud"
            firma.accion="firmarSolicitud"
            firma.controlador="modificacionesPoa"
            firma.idAccion=solicitud.id
            firma.idAccionVer=solicitud.id
            firma.documento="SolicitudDeModificacionPoa_"+ solicitud.id
            firma.concepto="Solicitud de Reforma del P.O.A. "
            firma.save(flush: true)
            solicitud.firmaSol = firma
            solicitud.save(flush: true)
        }
        flash.message="Solicitud enviada"
        render "ok"
    }

    def guardarSolicitudEliminar = {
//        println "params eliminar "+params

        def solicitud = new SolicitudModPoa()
        solicitud.concepto=params.concepto
        solicitud.usuario=session.usuario
        solicitud.tipo="E"
        solicitud.origen=Asignacion.get(params.origen)
        if(!solicitud.save(flush: true)){
            println "error save sol mod poa "+solicitud.errors
        }
        flash.message="Solicitud enviada"
        render "ok"
    }

    def listaPendientes = {
        def sols = SolicitudModPoa.findAllByEstado(0)
        def historial = SolicitudModPoa.findAllByEstadoNotEqual(0,[sort: "fechaRevision",order: "desc"])
        [solicitudes:sols,historial:historial]
    }

    def cargarAsignaciones = {
        def act = MarcoLogico.get(params.id)
        def anio = Anio.get(params.anio)
//        println "asgs "+ Asignacion.findAllByMarcoLogicoAndAnio(act, anio)
        [asgs: Asignacion.findAllByMarcoLogicoAndAnio(act, anio),div:params.div]
    }

    def verSolicitud = {
        def sol = SolicitudModPoa.get(params.id)
        def unidad = UnidadEjecutora.findByCodigo("DPI") // DIRECCIÓN DE PLANIFICACIÓN E INVERSIÓN
        def personasFirmas = Persona.findAllByUnidad(unidad)
        unidad = UnidadEjecutora.findByCodigo("DRPL")
        def perGerencia = Persona.findAllByUnidad(unidad)
        [sol:sol,personas:personasFirmas,perGerencia:perGerencia]
    }


    def negar = {
        def sol = SolicitudModPoa.get(params.id)
        sol.estado=2
        sol.fechaRevision=new Date()
        sol.observaciones=params.obs
        sol.revisor=session.usuario
        sol.save(flush: true)
        flash.message="Solicitud negada"

        render "ok"
    }
    def aprobar = {
        def sol = SolicitudModPoa.get(params.id)
        sol.estado=5
        sol.fechaRevision=new Date()
        sol.observaciones=params.obs
        sol.revisor=session.usuario

        def firma1 = new Firma()
        firma1.usuario=Persona.get(params.firma1)
        firma1.accionVer="reformaPoa"
        firma1.controladorVer="reporteReformaPoa"
        firma1.idAccionVer=sol.id
        firma1.accion="firmarModificacion"
        firma1.controlador="modificacionesPoa"
        firma1.documento="reformaPoa_"+ sol.id
        firma1.concepto="Aprobación de la reforma del P.O.A. No${sol.id}"
        firma1.esPdf="S"
        if(!firma1.save(flush: true))
            println "error firma1 "+firma1.errors
        def firma2 = new Firma()
        firma2.usuario=Persona.get(params.firma2)
        firma2.accionVer="reformaPoa"
        firma2.controladorVer="reporteReformaPoa"
        firma2.idAccionVer=sol.id
        firma2.accion="firmarModificacion"
        firma2.controlador="modificacionesPoa"
        firma2.documento="reformaPoa_"+ sol.id
        firma2.concepto="Aprobación de la reforma del P.O.A. No${sol.id}"
        firma2.esPdf="S"
        if(!firma2.save(flush: true))
            println "error firma2 "+firma2.errors
        sol.firma1=firma1
        sol.firma2=firma2

        sol.save(flush: true)
//        ejecutarSolicitud(sol)
        /*Aqui guardar firmas*/
        flash.message="Solicitud aprobada"
        render "ok"
    }

    /**
     * Acción que permite firmar electrónicamente un Aval
     * @params id es el identificador del aval
     */
    def firmarModificacion = {
        def firma = Firma.findByKey(params.key)
        if(!firma)
            response.sendError(403)
        else{
            def sol = SolicitudModPoa.findByFirma1OrFirma2(firma,firma)
            if(sol.firma1.key!=null && sol.firma2.key!=null){
                sol.estado=1
                sol.save(flush: true)
                ejecutarSolicitud(sol)
//            redirect(controller: "pdf",action: "pdfLink",params: [url:g.createLink(controller: firma.controladorVer,action: firma.accionVer,id: firma.idAccionVer)])

            }
            def url =g.createLink(controller: "pdf",action: "pdfLink",params: [url:g.createLink(controller: firma.controladorVer,action: firma.accionVer,id: firma.idAccionVer)])
            render "${url}"

        }
    }

    def historialUnidad = {
        def sols = []
        def unidad = session.usuario.unidad
       SolicitudModPoa.list().each {
           if(it.usuario.unidad.id==unidad.id){
               sols.add(it)
           }
       }
        [sols:sols,unidad:unidad]

    }

    def ejecutarSolicitud(SolicitudModPoa solicitud){
        def msg =""
        def origen = solicitud.origen

        if(origen.priorizado==0){
            msg = "No tiene valor priorizado"
            return [false,msg]
        }
        solicitud.valorOrigen = solicitud.origen.priorizado
        println "tipo "+solicitud.tipo
        switch (solicitud.tipo){
            case "R":
                def destino = solicitud.destino
                solicitud.valorDestino=solicitud.destino.priorizado
                if(destino){
                    ProgramacionAsignacion.findAllByAsignacion(origen).each {
                        it.delete()
                    }
                    origen.priorizado -= solicitud.valor
                    origen.save(flush: true)
                    guardarPrasPrio(origen)
                    ProgramacionAsignacion.findAllByAsignacion(destino).each {
                        it.delete()
                    }
                    destino.priorizado+=solicitud.valor
                    destino.save(flush: true)
                    guardarPrasPrio(destino)
                    solicitud.estado=3
                    solicitud.save(flush: true)
                    return [true,""]

                }else{
                    msg = "No hay asignación de destino"
                    return [false,msg]
                }
                break;
            case "N":
                def nueva = new MarcoLogico()
                solicitud.valorDestino=0
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
                if(!nueva.save(flush: true)){
                    println "error save actividad "+nueva.errors
                    msg = "Error al crear la actividad"
                    return [false,msg]
                }else{
                    println "grabo "+nueva.id
                    nueva.marcoLogico.monto+=solicitud.valor
                    nueva.marcoLogico.save(flush: true)
                    def asg = new Asignacion()
                    asg.marcoLogico=nueva
                    asg.planificado=solicitud.valor
                    asg.priorizado=solicitud.valor
                    asg.anio = origen.anio
                    asg.fuente = solicitud.fuente
                    asg.unidad = nueva.responsable
                    asg.presupuesto = solicitud.presupuesto
                    if(!asg.save(flush: true)){
                        println "error save asg "+asg.errors
                        nueva.delete()
                        msg = "Error al crear la asignación"
                        return [false,msg]
                    }else{
//                        origen.priorizado-=solicitud.valor
//                        origen.save(flush: true)
                        ProgramacionAsignacion.findAllByAsignacion(origen).each {
                            it.delete()
                        }
                        guardarPrasPrio(asg)
                        origen.priorizado -= solicitud.valor
                        origen.save(flush: true)
                        guardarPrasPrio(origen)
                        solicitud.estado=3
                        solicitud.save(flush: true)
                        return [true,""]
                    }

                }

                break;
            case "D":
                def nueva = new Asignacion()
                def valor = solicitud.valor
                solicitud.valorDestino=0
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
                    solicitud.estado=3
                    solicitud.save(flush: true)
                    return [true,""]
                } else {
                    println "error save asg nueva "+nueva.errors
                    msg = "Error al crear la asignación derivada"
                    return [false,msg]
                }

                break;
            case "A":
                solicitud.estado=3
                solicitud.save(flush: true)
                return [true,""]
                break
            default:
                println "wtf tipo--> "+ solicitud.tipo+"  "+solicitud.id+" "+new Date()
                msg="Error interno"
                return [false,msg]
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
