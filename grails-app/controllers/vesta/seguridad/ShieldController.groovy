package vesta.seguridad

class ShieldController {

    def unauthorized = {

    }

    def forbidden = {
        def msn = "Forbidden"
        return [msn: msn]
    }

    def notFound = {
        println ""
        def msn = "Esta tratando de ingresar a una accion no registrada en el sistema. Por favor use las opciones del menu para navegar por el sistema."
        return [msn: msn]
    }

    def internalServerError = {
        def msn = "Ha ocurrido un error interno."
        try {
            println " \n<===Error Aqui===> " + request["javax.servlet.forward.request_uri"]
            println " \n<===Que eres pal burro?????? ===> " + request["exception"].message?.encodeAsHTML()
            println " \n<===Causa===> " + request["exception"].cause?.message?.encodeAsHTML()

        } catch (e) {
            println "error en error " + e
        }
        return [msn: msn, error: true]
    }
}
