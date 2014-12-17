package vesta.parametros.proyectos

/**
 * Clase para conectar con la tabla 'plas' de la base de datos
 */
class PoliticaAgendaSocial implements Serializable {
    /**
     * Descripción de la política de agenda social
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
        table 'plas'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'plas__id'
        id generator: 'identity'
        version false
        columns {
            id column: 'plas__id'
            descripcion column: 'plasdscr'
        }
    }

    /**
     * Define las restricciones de cada uno de los campos
     */
    static constraints = {
        descripcion(blank: false, nullable: false, attributes: [mensaje: 'Descripción'])
    }
}
