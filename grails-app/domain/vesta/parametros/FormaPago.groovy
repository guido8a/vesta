package vesta.parametros

/**
 * Clase para conectar con la tabla 'frpg' de la base de datos
 */
class FormaPago {
    /**
     * Descipción de la forma de pago
     */
    String descripcion

    /**
     * Define los campos que se van a ignorar al momento de hacer logs
     */
    static auditable = [ignore: []]

    /**
     * Define el mapeo entre los campos del dominio y las columnas de la base de datos
     */
    static mapping = {
        table 'frpg'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'frpg__id'
        id generator: 'identity'
        version false
        columns {
            id column: 'frpg__id'
            descripcion column: 'frpgdscr'
        }
    }

    /**
     * Define las restricciones de cada uno de los campos
     */
    static constraints = {
        descripcion(maxSize: 63)
    }
}
