package vesta.parametros

/**
 * Clase para conectar con la tabla 'sctr' de la base de datos
 */
class Sector implements Serializable {
    /**
     * Descipción del sector
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
        table 'sctr'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'sctr__id'
        id generator: 'identity'
        version false
        columns {
            id column: 'sctr__id'
            descripcion column: 'sctrdscr'
        }
    }

    /**
     * Define las restricciones de cada uno de los campos
     */
    static constraints = {
        descripcion(size: 1..63, blank: false, attributes: [mensaje: 'Descripción del sector'])
    }
}