package vesta.parametros

/**
 * Clase para conectar con la tabla 'tpmd' de la base de datos
 */
class TipoModificacion   {
    /**
     * Descripción del tipo de modificación
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
        table 'tpmd'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'tpmd__id'
        id generator: 'identity'
        version false
        columns {
            id column: 'tpmd__id'
            descripcion column: 'tpmddscr'
        }
    }

    /**
     * Define las restricciones de cada uno de los campos
     */
    static constraints = {
        descripcion(size: 1..63, blank: true, nullable: true, attributes: [mensaje: 'Descripción del tipo de modificación'])
    }
}