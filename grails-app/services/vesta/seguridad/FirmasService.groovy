package vesta.seguridad
/**
 * Servicio para el firmar electronicamente documentos
 */
class FirmasService {

    /*
    *Ubicación de la carpeta de firmas
    */
    String path ="firmas/"
    def qrCodeService
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
    def firmarDocumento(usuario,password,firma,baseUri){
        def user = Persona.get(usuario)
        if(firma.usuario!=user)
            return null
        if(user.autorizacion==password.encodeAsMD5() ){
            try{

                def now = new Date()
                def key =""
                def texto=baseUri+g.createLink(controller: "firma",action: "verDocumento")+"?ky="
                def pathQr = servletContext.getRealPath("/") + path
                def nombre = ""+user.login+"_"+now.format("dd_MM_yyyy_MM_ss")+".png"
                new File(pathQr).mkdirs()
                // println " "+now.format("ddMMyyyyhhmmss.SSS")+" "+" nombre "+nombre+"  "+user.usroLogin.encodeAsMD5()+"   "+(user.autorizacion.substring(10,20))
                key=now.format("ddMMyyyyhhmmss.SSS").encodeAsMD5()+(user.login.encodeAsMD5().substring(0,10))+(user.autorizacion.substring(10,20))
                // println "key "+key
                texto+=key
                def fos= new FileOutputStream(pathQr+nombre)
                qrCodeService.renderPng(texto, 100, fos)
                fos.close()
                firma.fecha=now
                firma.key=key
                firma.path=nombre
                firma.estado="F"
                firma.save(flush: true)
                return firma
            }catch (e){
                println "error al generar la firma \n "+e.printStackTrace()
                return null
            }

        }else{
            return null
        }

    }
}
