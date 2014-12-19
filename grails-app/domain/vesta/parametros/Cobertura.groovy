package vesta.parametros

/**
 * Clase para conectar con la tabla 'cbrt' de la base de datos
 */
class Cobertura   {
    /**
     * Descipción de la cobertura
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
        table 'cbrt'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'cbrt__id'
        id generator: 'identity'
        version false
        columns {
            id column: 'cbrt__id'
            descripcion column: 'cbrtdscr'
        }
    }

    /**
     * Define las restricciones de cada uno de los campos
     */
    static constraints = {
        descripcion(size: 1..31, blank: false, attributes: [mensaje: 'Descripción de la cobertura'])
    }

    /**
     * Genera un string para mostrar
     * @return la descripcion
     */
    String toString() {
        "${this.descripcion}"
    }
}