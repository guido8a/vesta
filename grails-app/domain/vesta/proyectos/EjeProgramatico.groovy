package vesta.proyectos

/**
 * Clase para conectar con la tabla 'ejpg' de la base de datos
 */
class EjeProgramatico implements Serializable {
    /**
     * Descripción del eje programático
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
        table 'ejpg'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'ejpg__id'
        id generator: 'identity'
        version false
        columns {
            id column: 'ejpg__id'
            descripcion column: 'ejpgdscr'
        }
    }

    /**
     * Define las restricciones de cada uno de los campos
     */
    static constraints = {
        descripcion(size: 1..127, blank: false, attributes: [mensaje: 'Descripción del eje programático'])
    }

    /**
     * Genera un string para mostrar
     * @return la descripción
     */
    String toString() {
        return this.descripcion
    }
}