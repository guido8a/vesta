package vesta.parametros

/**
 * Clase para conectar con la tabla 'ctrm' de la base de datos
 */
class Cuatrimestre implements Serializable {
    /**
     * Número de cuatrimestre
     */
    Integer numero
    /**
     * Descripción del cuatrimestre
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
        table 'ctrm'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'ctrm__id'
        id generator: 'identity'
        version false
        columns {
            id column: 'ctrm__id'
            numero column: 'ctrmnmro'
            descripcion column: 'ctrmdscr'
        }
    }

    /**
     * Define las restricciones de cada uno de los campos
     */
    static constraints = {
        numero(blank: true, nullable: true, attributes: [mensaje: 'Número de cuatrimestre'])
        descripcion(size: 1..15, blank: true, nullable: true, attributes: [mensaje: 'Descripción del cuatrimestre'])
    }
}