package vesta.seguridad

/**
 * Clase para conectar con la tabla 'prms' de la base de datos
 */
class Prms implements Serializable {
    /**
     * Acción para el permiso
     */
    Accn accion
    /**
     * Perfil para el permiso
     */
    Prfl perfil

    /**
     * Define los campos que se van a ignorar al momento de hacer logs
     */
    static auditable = [ignore: []]

    /**
     * Define el mapeo entre los campos del dominio y las columnas de la base de datos
     */
    static mapping = {
        table 'prms'
        cache usage: 'read-write', include: 'non-lazy'
        version false
        id generator: 'identity'

        columns {
            id column: 'prms__id'
            accion column: 'accn__id'
            perfil column: 'prfl__id'
        }
    }

    /**
     * Define las restricciones de cada uno de los campos
     */
    static constraints = {
    }
}
