package vesta.proyectos

/**
 * Clase para conectar con la tabla 'estr' de la base de datos
 */
class Estrategia {

    /**
     * Orden para mostrar
     */
    Integer orden
    /**
     * Descripción
     */
    String descripcion
    /**
     * Objetivo estratégico
     */
    ObjetivoEstrategicoProyecto objetivoEstrategico

    /**
     * Define los campos que se van a ignorar al momento de hacer logs
     */
    static auditable = [ignore: []]

    /**
     * Define el mapeo entre los campos del dominio y las columnas de la base de datos
     */
    static mapping = {
        table 'estr'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'estr__id'
        id generator: 'identity'
        version false
        columns {
            orden column: "estrordn"
            descripcion column: 'estrdscr'
            objetivoEstrategico column: "obes__id"
        }
    }

    /**
     * Define las restricciones de cada uno de los campos
     */
    static constraints = {
        orden(blank: false, nullable: false)
        descripcion(blank: false, nullable: false, maxSize: 511)
        objetivoEstrategico(blank: false, nullable: false)
    }
}
