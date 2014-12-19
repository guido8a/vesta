package vesta.proyectos
/*Objetivo estratégico con el que puede estar alineado el proyecto.*/
/**
 * Clase para conectar con la tabla 'obes' de la base de datos<br/>
 * Objetivo estratégico con el que puede estar alineado el proyecto
 */
class ObjetivoEstrategicoProyecto   {
    /**
     * Orden del objetivo estratégico de proyecto
     */
    Integer orden
    /**
     * Descripción del objetivo estratégico de proyecto
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
//        table 'obes'
        table 'c_obes'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'obes__id'
        id generator: 'identity'
        version false
        columns {
            id column: 'obes__id'
            orden column: 'obesordn'
            descripcion column: 'obesdscr'
        }
    }

    /**
     * Define las restricciones de cada uno de los campos
     */
    static constraints = {
        orden(blank: false, nullable: false, attributes: [mensaje: 'Orden'])
        descripcion(blank: false, nullable: false, attributes: [mensaje: 'Descripción del objetivo'])
    }

    /**
     * Genera un string para mostrar
     * @return la descripción
     */
    String toString() {
        return this.descripcion
    }
}