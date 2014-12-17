package vesta.parametros

/**
 * Clase para conectar con la tabla 'tpcn' de la base de datos
 */
class TipoContrato {
    /**
     * Descripción del tipo de contrato
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
        table 'tpcn'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'tpcn__id'
        id generator: 'identity'
        version false
        columns {
            id column: 'tpcn__id'
            descripcion column: 'tpcndscr'
        }
    }

    /**
     * Define las restricciones de cada uno de los campos
     */
    static constraints = {
        descripcion(maxSize: 63)
    }
}
