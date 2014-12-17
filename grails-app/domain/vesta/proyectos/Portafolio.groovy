package vesta.proyectos

/**
 * Clase para conectar con la tabla 'prtf' de la base de datos
 */
class Portafolio {

    String descripcion

    /**
     * Define los campos que se van a ignorar al momento de hacer logs
     */
    static auditable = [ignore: []]

    /**
     * Define el mapeo entre los campos del dominio y las columnas de la base de datos
     */
    static mapping = {
//        table 'prtf'
        table 'c_prtf'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'prtf__id'
        id generator: 'identity'
        version false
        columns {
            descripcion column: 'prtfdscr'
        }
    }

    /**
     * Define las restricciones de cada uno de los campos
     */
    static constraints = {
        descripcion(blank: false, nullable: false, maxSize: 511)
    }
}
