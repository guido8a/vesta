package vesta.alertas

import vesta.seguridad.Persona

/**
 * Clase para conectar con la tabla 'alertas' de la base de datos
 */
class Alerta {

    /**
     * Usuario que envía la alerta
     */
    Persona from
    /**
     * Usuario que recibe la alerta
     */
    Persona persona
    /**
     * Fecha de envío de la alerta
     */
    Date fechaEnvio
    /**
     * Fecha de recepción de la alerta
     */
    Date fechaRecibido
    /**
     * Mensaje a enviar con la alerta
     */
    String mensaje
    /**
     * Controlador al cual se va a redireccionar al hacer clic en la alerta
     */
    String controlador
    /**
     * Acción a la cual se va a redireccionar al hacer clic en la alerta
     */
    String accion
    /**
     * Id necesario para el redireccionamiento
     */
    int id_remoto
    /**
     * Parámetros extra para el redireccionamiento
     */
    String parametros

    /**
     * tipo de alerta
     */
    String tipo


    /**
     * Define los campos que se van a ignorar al momento de hacer logs
     */
    static auditable = [ignore: ['fechaEnvio', 'fechaRecibido']]

    /**
     * Define el mapeo entre los campos del dominio y las columnas de la base de datos
     */
    static mapping = {
        table: 'alertas'
        cache usage: 'read-write', include: 'non-lazy'
        version false
        id generator: 'identity'

        columns {
            id column: 'aler__id'
            from column: 'alerfrom'
            persona column: 'aler__to'
            fechaEnvio column: 'alerfcen'
            fechaRecibido column: 'alerfcrc'
            mensaje column: 'alermesn'
            controlador column: 'alerctrl'
            accion column: 'aleraccn'
            id_remoto column: 'aleridrm'
            parametros column: 'alerprmt'
            tipo column: 'alertipo'
        }
    }

    /**
     * Define las restricciones de cada uno de los campos
     */
    static constraints = {
        from(blank: false)
        persona(blank: false)
        fechaEnvio(blank: false)
        fechaRecibido(nullable: true, blank: true)
        mensaje(size: 5..200, blank: false)
        controlador(nullable: true, blank: true)
        accion(nullable: true, blank: true)
        id_remoto(nullable: true, blank: true)
        parametros(nullable: true, blank: true)
        tipo(nullable: true, blank: true)
    }

    /**
     * Genera un string para mostrar
     * @return el id y el mensaje concatenados
     */
    String toString() {
        return "${this.id} ${this.mensaje}"
    }
}
