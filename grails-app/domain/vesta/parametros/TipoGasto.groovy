package vesta.parametros

/**
 * Clase para conectar con la tabla 'tpgs' de la base de datos
 */
class TipoGasto implements Serializable {
    /**
     * Descripción del tipo de gasto
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
        table 'tpgs'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'tpgs__id'
        id generator: 'identity'
        version false
        columns {
            id column: 'tpgs__id'
            descripcion column: 'tpgsdscr'
        }
    }

    /**
     * Define las restricciones de cada uno de los campos
     */
    static constraints = {
        descripcion(size: 1..15, blank: false, attributes: [mensaje: 'Descripción del tipo de gasto'])
    }

    /**
     * Genera un string para mostrar
     * @return la descripción
     */
    String toString() {
        "${this.descripcion}"
    }
}