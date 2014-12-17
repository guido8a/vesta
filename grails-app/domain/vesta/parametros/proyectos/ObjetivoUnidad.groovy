package vesta.parametros.proyectos

/**
 * Clase para conectar con la tabla 'obun' de la base de datos
 */
class ObjetivoUnidad {
    /**
     * Descripción del objetivo de la unidad
     */
    String descripcion
    /**
     * Orden del objetivo de la unidad (para mostrar)
     */
    Integer orden

    /**
     * Define los campos que se van a ignorar al momento de hacer logs
     */
    static auditable = [ignore: []]

    /**
     * Define el mapeo entre los campos del dominio y las columnas de la base de datos
     */
    static mapping = {
//        table 'obun'
        table 'c_obun'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'obun__id'
        id generator: 'identity'
        version false
        columns {
            id column: 'obun__id'
            descripcion column: 'obundscr'
            orden column: 'obunordn'
        }
    }

    /**
     * Define las restricciones de cada uno de los campos
     */
    static constraints = {
        descripcion(size: 3..511)
    }
}
