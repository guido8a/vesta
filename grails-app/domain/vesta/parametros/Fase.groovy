package vesta.parametros

/**
 * Clase para conectar con la tabla 'fase' de la base de datos
 */
class Fase implements Serializable {
    /**
     * Descipción de la fase
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
        table 'fase'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'fase__id'
        id generator: 'identity'
        version false
        columns {
            id column: 'fase__id'
            descripcion column: 'fasedscr'
        }
    }

    /**
     * Define las restricciones de cada uno de los campos
     */
    static constraints = {
        descripcion(size: 1..31, blank: false, attributes: [mensaje: 'Descripción de la fase del proyecto'])
    }

    /**
     * Genera un string para mostrar
     * @return la descripción
     */
    String toString() {
        return this.descripcion
    }
}