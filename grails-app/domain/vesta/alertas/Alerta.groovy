package vesta.alertas

import vesta.seguridad.Usro

/**
 * Clase para conectar con la tabla 'alertas' de la base de datos
 */
class Alerta implements Serializable {

    /**
     * Usuario que envía la alerta
     */
    Usro from
    /**
     * Usuario que recibe la alerta
     */
    Usro usro
    /**
     * Fecha de envío de la alerta
     */
    Date fec_envio
    /**
     * Fecha de recepción de la alerta
     */
    Date fec_recibido
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
     * Define los campos que se van a ignorar al momento de hacer logs
     */
    static auditable = [ignore: ['fec_envio', 'fec_recibido']]

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
            usro column: 'aler__to'
            fec_envio column: 'alerfcen'
            fec_recibido column: 'alerfcrc'
            mensaje column: 'alermesn'
            controlador column: 'alerctrl'
            accion column: 'aleraccn'
            id_remoto column: 'aleridrm'
        }
    }

    /**
     * Define las restricciones de cada uno de los campos
     */
    static constraints = {
        from(blank: false)
        usro(blank: false)
        fec_envio(blank: false)
        fec_recibido(nullable: true, blank: true)
        mensaje(size: 5..200, blank: false)
        controlador(nullable: true, blank: true)
        accion(nullable: true, blank: true)
        id_remoto(nullable: true, blank: true)
    }

    /**
     * Genera un string para mostrar
     * @return el id y el mensaje concatenados
     */
    String toString() {
        return "${this.id} ${this.mensaje}"
    }
}
