package vesta.seguridad
/**
 * Servicio para el firmar electronicamente documentos
 */
class FirmasService {

    /*
    *Ubicación de la carpeta de firmas
    */
    String path = "firmas/"
//    def qrCodeService
    def QRCodeService

    def servletContext
    static transactional = true
    def g = new org.codehaus.groovy.grails.plugins.web.taglib.ApplicationTagLib()

    /**
     * Firma digitalmente un documento
     * @param usuario es el usuario que firma
     * @param accion es el nombre de la accion
     * @param controlador es el nombre del controlador
     * @param idAccion es el identificador pasado a la accion
     * @param documento es el nombre del documento
     * @param password es la contraseña de autorizacion del usuario
     * @return un objeto de tipo firma con la información de la firma electrónica
     */
    def firmarDocumento(usuario, password, firma, baseUri) {
        def user = Persona.get(usuario)
        if (firma.usuario != user)
            return "ERROR*El usuario no concuerda con la firma"
        if (user.autorizacion == password.encodeAsMD5()) {
            try {
                def now = new Date()
                def key = ""
                def texto = baseUri + g.createLink(controller: "firma", action: "verDocumento") + "?ky="
                def pathQr = servletContext.getRealPath("/") + path
                def nombre = "" + user.login + "_" + now.format("dd_MM_yyyy_MM_ss") + ".png"
                new File(pathQr).mkdirs()
                // println " "+now.format("ddMMyyyyhhmmss.SSS")+" "+" nombre "+nombre+"  "+user.usroLogin.encodeAsMD5()+"   "+(user.autorizacion.substring(10,20))
                key = now.format("ddMMyyyyhhmmss.SSS").encodeAsMD5() + (user.login.encodeAsMD5().substring(0, 10)) + (user.autorizacion.substring(10, 20))
                // println "key "+key
                texto += key
                //plugin antiguo de QR
//                def fos = new FileOutputStream(pathQr + nombre)
//                qrCodeService.renderPng(texto, 100, fos)
//                fos.close()

                //plugin nuevo de QR
//                def texto = request.scheme + "://" + "10.0.0.3" + ":" + request.serverPort + g.createLink(controller: "firma", action: "verDocumento") + "?ky="
//                def pathQr = servletContext.getRealPath("/") + "firmas/"
//                def nombre = "" + session.usuario.login + "_" + new Date().format("dd_MM_yyyy_MM_ss") + ".png"
                def logo = servletContext.getRealPath("/") + "images/logo_yachay_qr.png"
                Map information = [chl: texto]
                information.chs = "200x200"
                QRCodeService.createQRCode(information, logo, pathQr, nombre)

                firma.fecha = now
                firma.key = key
                firma.path = nombre
                firma.estado = "F"
                firma.save(flush: true)
                return firma
            } catch (e) {
                println "error al generar la firma \n " + e.printStackTrace()
                return "ERROR*No se pudo generar la firma"
            }
        } else {
            return "ERROR*La clave de autorización es incorrecta"
        }

    }
}
