package vesta.parametros

/**
 * Clase para conectar con la tabla 'calf' de la base de datos
 */
class Calificacion implements Serializable {
    /**
     * Descipción de la calificación
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
        table 'calf'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'calf__id'
        id generator: 'identity'
        version false
        columns {
            id column: 'calf__id'
            descripcion column: 'calfdscr'
        }
    }

    /**
     * Define las restricciones de cada uno de los campos
     */
    static constraints = {
        descripcion(size: 1..15, blank: false, attributes: [mensaje: 'Descripción de la calificación'])
    }

    /**
     * Genera un string para mostrar
     * @return el id y el mensaje concatenados
     */
    String toString() {
        "${this.descripcion}"
    }
}