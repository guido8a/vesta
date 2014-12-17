package vesta.proyectos
/**
 * Clase para conectar con la tabla 'pltc' de la base de datos
 */
class PoliticaAplicaProyecto implements Serializable {
    /**
     * Descripción de la política que aplica al proyecto
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
        table 'pltc'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'pltc__id'
        id generator: 'identity'
        version false
        columns {
            id column: 'pltc__id'
            descripcion column: 'pltcdscr'
        }
    }

    /**
     * Define las restricciones de cada uno de los campos
     */
    static constraints = {
        descripcion(size: 1..1023, blank: false, attributes: [mensaje: 'descripcion'])
    }
}