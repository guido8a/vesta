package vesta.parametros

/**
 * Clase para conectar con la tabla 'tpaq' de la base de datos
 */
class TipoAdquisicion implements Serializable {
    /**
     * Descripción del tipo de adquisición
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
        table 'tpaq'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'tpaq__id'
        id generator: 'identity'
        version false
        columns {
            id column: 'tpaq__id'
            descripcion column: 'tpaqdscr'
        }
    }
    
    /**
     * Define las restricciones de cada uno de los campos
     */
    static constraints = {
        descripcion(size: 1..31, blank: false, attributes: [mensaje: 'Descripción del tipo de adquisición'])
    }
}