package vesta.parametros
/*Estado del proyecto*/

/**
 * Clase para conectar con la tabla 'edpy' de la base de datos<br/>
 * Guarda un catálogo de posibles estados del proyecto
 */
class EstadoProyecto implements Serializable {
    /**
     * Descripción del estado del proyecto
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
        table 'edpy'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'edpy__id'
        id generator: 'identity'
        version false
        columns {
            id column: 'edpy__id'
            descripcion column: 'edpydscr'
        }
    }

    /**
     * Define las restricciones de cada uno de los campos
     */
    static constraints = {
        descripcion(size: 1..31, blank: false, attributes: [mensaje: 'Descripción del Estado del proyecto'])
    }

    /**
     * Genera un string para mostrar
     * @return la descripción
     */
    String toString() {
        return this.descripcion
    }
}