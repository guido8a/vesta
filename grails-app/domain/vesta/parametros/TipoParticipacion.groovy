package vesta.parametros

/**
 * Clase para conectar con la tabla 'tppt' de la base de datos
 */
class TipoParticipacion   {
    /**
     * Descripción del tipo de participación
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
        table 'tppt'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'tppt__id'
        id generator: 'identity'
        version false
        columns {
            id column: 'tppt__id'
            descripcion column: 'tpptdscr'
        }
    }

    /**
     * Define las restricciones de cada uno de los campos
     */
    static constraints = {
        descripcion(size: 1..31, blank: false, attributes: [mensaje: 'Descripción del tipo de participación'])
    }

    /**
     * Genera un string para mostrar
     * @return la descripción
     */
    String toString() {
        "${this.descripcion}"
    }
}