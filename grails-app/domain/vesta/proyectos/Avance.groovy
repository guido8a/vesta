package vesta.proyectos

/*Cada período de días fijado en el proyecto se debe registrar el detalle de avance de actividades.*/
/**
 * Clase para conectar con la tabla 'avnc' de la base de datos<br/>
 * Cada período de días fijado en el proyecto se debe registrar el detalle de avance de actividades.
 */
class Avance implements Serializable {
    /**
     * Informe del avance
     */
    Informe informe
    /**
     * Meta del avance
     */
    Meta meta
    /**
     * Descripción del avance
     */
    String descripcion
    /**
     * Valor del avance
     */
    double valor

    /**
     * Define los campos que se van a ignorar al momento de hacer logs
     */
    static auditable = [ignore: []]

    /**
     * Define el mapeo entre los campos del dominio y las columnas de la base de datos
     */
    static mapping = {
        table 'avnc'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'avnc__id'
        id generator: 'identity'
        version false
        columns {
            id column: 'avnc__id'
            informe column: 'info__id'
            meta column: 'meta__id'
            descripcion column: 'inditasa'
            valor column: 'avncvlor'
        }
    }

    /**
     * Define las restricciones de cada uno de los campos
     */
    static constraints = {
        informe(blank: true, nullable: true, attributes: [mensaje: 'Informe'])
        meta(blank: true, nullable: true, attributes: [mensaje: 'Meta'])
        descripcion(size: 1..1023, blank: true, nullable: true, attributes: [mensaje: 'Descripción del avance realizado'])
        valor(blank: true, nullable: true, attributes: [mensaje: 'Valor avanzado respecto del indicador fijado para la meta'])
    }
}