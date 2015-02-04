package vesta.seguridad

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
        if (params.anio)
            actual = Anio.get(params.anio)
        else
            actual = Anio.findByAnio(new Date().format("yyyy"))
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
            datos += Firma.findAllByFechaBetween(fechaInicio, fechaFin)
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
        println "firmar " + params

        if (params.pass.toString().encodeAsMD5() == session.usuario.autorizacion) {
            def firma = Firma.get(params.id)
            def baseUri = request.scheme + "://" + "10.0.0.3" + ":" + request.serverPort
//        def baseUri = request.scheme + "://" + request.serverName + ":" + request.serverPort
            firma = firmasService.firmarDocumento(session.usuario.id, params.pass, firma, baseUri)
            if (firma.class == Firma) {
                redirect(controller: firma.controlador, action: firma.accion, params: [id: firma.idAccion, key: firma.key])
            } else {
                render firma
            }
        } else {
            render "ERROR*La clave de autorización es incorrecta"
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
