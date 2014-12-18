package vesta.seguridad

/**
 * Clase para conectar con la tabla 'audt' de la base de datos
 */
class Audt implements Serializable {
    /**
     * Usuario para la auditoría
     */
    Persona usuario
    /**
     * Perfil para la auditoría
     */
    Prfl perfil
    /**
     * Acción para la auditoría
     */
    String accion
    /**
     * Controlador para la auditoría
     */
    String controlador
    /**
     * Id del registro para la auditoría
     */
    int registro
    /**
     * Dominio para la auditor&iacute;a
     */
    String dominio
    /**
     * Campo para la auditor&iacute;a
     */
    String campo
    /**
     * Valor anterior del campo
     */
    String old_value
    /**
     * Valor nuevo del campo
     */
    String new_value
    /**
     * Fecha
     */
    Date fecha
    /**
     * Operación realizada
     */
    String operacion

    /**
     * Define el mapeo entre los campos del dominio y las columnas de la base de datos
     */
    static mapping = {
        table: 'audt'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'audt__id'
        id generator: 'identity'
        version false
        columns {
            id column: 'audt__id'
            usuario column: 'prsn__id'
            perfil column: 'prfl__id'
            accion column: 'audtaccn'
            controlador column: 'audtctrl'
            registro column: 'reg_id'
            dominio column: 'audttbla'
            campo column: 'audtcmpo'
            old_value column: 'audtoldv'
            new_value column: 'audtnewv'
            fecha column: 'audtfcha'
            operacion column: 'audtoprc'
        }
    }

    /**
     * Define las restricciones de cada uno de los campos
     */
    static constraints = {
        usuario(blank: false, nullable: false)
        fecha(blank: true, nullable: true)
        accion(blank: false, nullable: false)
        perfil(blank: false, nullable: false)
        controlador(blank: false, nullable: false)
        registro(blank: false, nullable: false)
        dominio(blank: false, nullable: false)
        campo(blank: true, nullable: true)
        old_value(blank: true, nullable: true)
        new_value(blank: true, nullable: true)
        operacion(blank: false, nullable: false)
    }

    /**
     * Genera un string para mostrar
     * @return el usuario, el dominio y la operación concatenados
     */
    String toString() {
        return "${this.usuario} ${this.dominio} ${this.operacion}"
    }

}
