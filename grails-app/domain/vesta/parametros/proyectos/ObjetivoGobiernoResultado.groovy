package vesta.parametros.proyectos
/*Objetivos establecidos en el sistema de GPR*/
/**
 * Clase para conectar con la tabla 'obgr' de la base de datos<br/>
 * Objetivos establecidos en el sistema de GPR
 */
class ObjetivoGobiernoResultado implements Serializable {
    /**
     * Descripción del objetivo gobierno resultado
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
        table 'obgr'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'obgr__id'
        id generator: 'identity'
        version false
        columns {
            id column: 'obgr__id'
            descripcion column: 'obgrdscr'
        }
    }

    /**
     * Define las restricciones de cada uno de los campos
     */
    static constraints = {
        descripcion(blank: false, nullable: false, attributes: [mensaje: 'Descripción'])
    }
}