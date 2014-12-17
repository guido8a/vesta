package vesta.avales

/**
 * Clase para conectar con la tabla 'edav' de la base de datos
 */
class EstadoAval {
    /**
     * Descripción del estado del aval
     */
    String descripcion
    /**
     * Código del estado del aval
     */
    String codigo

    /**
     * Define el mapeo entre los campos del dominio y las columnas de la base de datos
     */
    static mapping = {
//        table 'edav'
        table 'c_edav'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'edav__id'
        id generator: 'identity'
        version false
        columns {
            id column: 'edav__id'
            descripcion column: 'edavdscr'
            codigo column: 'edavcdgo'
        }
    }

    /**
     * Define las restricciones de cada uno de los campos
     */
    static constraints = {
        descripcion(size: 1..50, blank: false, nullable: false)
        codigo(size: 1..3, blank: false, nullable: false)
    }
}
