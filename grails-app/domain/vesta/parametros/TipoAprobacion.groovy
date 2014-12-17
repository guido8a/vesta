package vesta.parametros

/**
 * Clase para conectar con la tabla 'tpap' de la base de datos
 */
class TipoAprobacion {
    /**
     * Código del tipo de aprobación
     */
    String codigo
    /**
     * Descripción del tipo de aprobación
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
//        table 'tpap'
        table 'c_tpap'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'tpap__id'
        id generator: 'identity'
        version false
        columns {
            id column: 'tpap__id'
            codigo column: 'tpapcdgo'
            descripcion column: 'tpapdscr'
        }
    }

    /**
     * Define las restricciones de cada uno de los campos
     */
    static constraints = {
        codigo(maxSize: 2)
        descripcion(maxSize: 63)
    }
}
