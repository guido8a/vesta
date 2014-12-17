package vesta.parametros

/**
 * Clase para conectar con la tabla 'lnea' de la base de datos
 */
class Linea implements Serializable {
    /**
     * Descipción de la línea
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
        table 'lnea'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'lnea__id'
        id generator: 'identity'
        version false
        columns {
            id column: 'lnea__id'
            descripcion column: 'lneadscr'
        }
    }

    /**
     * Define las restricciones de cada uno de los campos
     */
    static constraints = {
        descripcion(size: 1..127, blank: false, attributes: [mensaje: 'Descripción del lineamiento de inversión'])
    }

    /**
     * Genera un string para mostrar
     * @return la descripción
     */
    String toString() {
        "${this.descripcion}"
    }
}