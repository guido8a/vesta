package vesta.parametros

/**
 * Clase para conectar con la tabla 'tpbn' de la base de datos
 */
class TipoBien {
    /**
     * Descripción del tipo de bien
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
        table 'tpbn'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'tpbn__id'
        id generator: 'identity'
        version false
        columns {
            id column: 'tpbn__id'
            descripcion column: 'tpbndscr'
        }
    }

    /**
     * Define las restricciones de cada uno de los campos
     */
    static constraints = {
        descripcion(maxSize: 63)
    }
}
