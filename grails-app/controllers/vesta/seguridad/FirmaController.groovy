package vesta.seguridad

import vesta.avales.EstadoAval
import vesta.avales.SolicitudAval
import vesta.parametros.poaPac.Anio

class FirmaController extends Shield {

    def QRCodeService

    def firmasService
    /**
     * Acción que muestra una lista de las solicitudes de firma pendientes
     * @param anio es el anio para mostrar el historial de firmas
     */
    def firmasPendientes = {

        def firmas = Firma.findAllByUsuarioAndEstado(session.usuario, "S", [sort: "id"])
        def actual
        if (params.anio) {
            actual = Anio.get(params.anio)
        } else {
            actual = Anio.findByAnio(new Date().format("yyyy"))
        }
        [firmas: firmas, actual: actual]

    }
/**
 * Acción que muestra una lista con el hisotrial del firmas
 * @param anio es el anio para mostrar el historial de firmas
 */
    def historial = {
//        println "historial "+params
        def anio = Anio.get(params.anio).anio

        def datos = []
        def fechaInicio
        def fechaFin
        if (anio && anio != "") {
            fechaInicio = new Date().parse("dd-MM-yyyy hh:mm:ss", "01-01-" + anio + " 00:01:01")
            fechaFin = new Date().parse("dd-MM-yyyy hh:mm:ss", "31-12-" + anio + " 23:59:59")
//            println "inicio "+fechaInicio+"  fin  "+fechaFin
            datos += Firma.findAllByFechaBetweenAndUsuario(fechaInicio, fechaFin, session.usuario)

//            println "datos fecha "+datos
        }

        [datos: datos.sort { it.fecha }]
    }
/**
 * Acción que muestra una el documento firmado
 * @param id es el identificador de la firma
 */
    def ver = {
        def firma = Firma.get(params.id)
        if (firma) {
            if (firma.esPdf == "S") {
                redirect(controller: "pdf", action: "pdfLink", params: [url: g.createLink(controller: firma.controladorVer, action: firma.accionVer, id: firma.idAccionVer)])
            }
        } else {
            render "No se encontro ninguna firma"
        }
    }
    /**
     * Acción niega la firma
     * @param id es el identificador de la firma
     */
    def negar = {
//        println "negar "+params
        def firma = Firma.get(params.id)
        firma.fecha = new Date()
        firma.estado = "N"
        if (!firma.save(flush: true)) {
            println "error save firma " + firma.errors
        }
        render "ok"
    }
    /**
     * Acción de firmar electronicamente
     * @param id es el identificador de la firma
     * @params pass es la constraseña de autorización
     */
    def firmar = {
        if (params.pass.toString().encodeAsMD5() == session.usuario.autorizacion) {
            def firma = Firma.get(params.id)
            //  def baseUri = request.scheme + "://" + "10.0.0.3" + ":" + request.serverPort
            def baseUri = request.scheme + "://" + request.serverName + ":" + request.serverPort
            firma = firmasService.firmarDocumento(session.usuario.id, params.pass, firma, baseUri)
            println "firma " + firma + "  " + baseUri
            if (firma.class == Firma) {
                println "redirect " + firma.controlador + "  " + firma.accion + "  " + firma.idAccion + "  " + firma.key
                redirect(controller: firma.controlador, action: firma.accion, params: [id: firma.idAccion, key: firma.key])
            } else {
                render "error"
            }
        } else {
            println "error"
            render "error"
        }

    }
    /**
     * Acción de devolver documento (accionNegar)
     * @param id es el identificador de la firma
     * @params pass es la constraseña de autorización
     */
    def devolverFirma = {
        println "devolver " + params

        /** TODO: si se trata de solicitud de aval, se debe invocar a devolver */
        if (params.pass.toString().encodeAsMD5() == session.usuario.autorizacion) {
            def firma = Firma.get(params.id)
            firma.estado = 'N'
            firma.observaciones = params.obs.trim()
            firma.save(flush: true)
            println "redirect " + firma.controladorNegar + "  " + firma.accionNegar + "  " + firma.idAccionNegar
            redirect(controller: firma.controladorNegar, action: firma.accionNegar, id: firma.idAccionNegar)
        } else {
            println "error"
            render "error"
        }
    }

    /**
     * Acción de devolver un trámite
     * @param id es el identificador de la firma
     * @params obsr es la observación o razón por la que se devuelve
     */
    def devolver = {
        println "devolver " + params

        if (params.obsr) {
            def firma = Firma.get(params.id)
            //  def baseUri = request.scheme + "://" + "10.0.0.3" + ":" + request.serverPort
            println "devolver " + firma
            println "controlador: $firma.controlador  accion: $firma.accion id de accion: $firma.idAccion key: $firma.key"
            if ((firma.class == Firma) && (firma.accion == 'firmarSolicitud') && (firma.controlador == 'avales')) {
                println "redirect " + firma.controlador + "  " + firma.accion + "  " + firma.idAccion + "  " + firma.key
                firma.estado = 'N'
                def slav = SolicitudAval.get(firma.idAccionVer)
                slav.estado = EstadoAval.findByCodigo("D01")
                slav.observaciones = params.obsr
                firma.save(flush: true)
                slav.save(flush: true)
                render "ok"
                //redirect(controller: firma.controlador, action: firma.accion, params: [id: firma.idAccion, key: firma.key])
            } else {
                render "error"
            }
        } else {
            println "error"
            render "error"
        }

    }

/**
 * Acción verificar un documento firmado a través de la llave
 * @param ky es la llave de la firma
 */
    def verDocumento = {
//        println "ver doc "+params
        def firma = Firma.findByKey(params.ky)

        if (firma) {
            //println "firma "+firma+" "+firma.esPdf+" "+firma.controladorVer+"/"+firma.accionVer+"/"+firma.idAccion
            if (firma.esPdf == "S") {
                redirect(controller: "pdf", action: "pdfLink", params: [url: g.createLink(controller: firma.controladorVer, action: firma.accionVer, id: firma.idAccionVer)])
            } else {
                redirect(controller: firma.controladorVer, action: firma.accionVer, id: firma.idAccionVer)
            }
        } else {
            render "No se encontro ninguna firma"
        }
    }


}
