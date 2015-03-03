package vesta.reportes

import vesta.modificaciones.SolicitudModPoa
import vesta.parametros.poaPac.Anio
import vesta.seguridad.Prfl
import vesta.seguridad.Sesn

/**
 * Controlador para generar reportes de reformas del POA
 */
class ReporteReformaPoaController {





    /**
     * Genera el reporte PDF de solicitud de reforma al POA
     */
    def solicitudReformaPoa = {
//        http://localhost:8090/yachay/pdf/pdfLink?url=/yachay/reporteReformaPoa/solicitudReformaPoa/?id=1&filename=Solicitud.pdf
        def sol = SolicitudModPoa.get(params.id)
        def anio = Anio.findByAnio(new Date().format("yyyy"))
        [sol:sol, anio: anio]
    }






    /**
     * Genera el reporte PDF de la reforma al POA
     */
    def reformaPoa = {
//        println "llego "+params
        def sol = SolicitudModPoa.get(params.id)
        def anio = Anio.findByAnio(new Date().format("yyyy"))
        if(sol.estado!=3 && sol.estado!=5)
            response.sendError(403)
        def director = Sesn.findByPerfil(Prfl.findByCodigo("DP"))
        if(director){
            director=director.usuario
        }
        def gerente = Sesn.findByPerfil(Prfl.findByCodigo("GP"))
        if(gerente){
            gerente=gerente.usuario
        }
        [sol:sol,gerente:gerente,director:director, anio: anio]

    }
}
