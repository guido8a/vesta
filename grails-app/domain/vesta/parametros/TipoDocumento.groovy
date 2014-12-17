package vesta.parametros

/**
 * Clase para conectar con la tabla 'tpdc' de la base de datos
 */
class TipoDocumento {
    /**
     * Descripción del tipo de documento
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
        table 'tpdc'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'tpdc__id'
        id generator: 'identity'
        version false
        columns {
            id column: 'tpdc__id'
            descripcion column: 'tpdcdscr'
        }
    }

    /**
     * Define las restricciones de cada uno de los campos
     */
    static constraints = {
        descripcion(size: 1..50, blank: false, attributes: [mensaje: 'Descripción'])

    }

    /**
     * Genera un string para mostrar
     * @return la descripción
     */
    String toString() {
        "${this.descripcion}"
    }
}
