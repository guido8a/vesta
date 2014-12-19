package vesta.proyectos

/**
 * Clase para conectar con la tabla 'obet' de la base de datos
 */
class ObjetivoEstrategico   {
    /**
     * Proyecto del objetivo estratégico
     */
    Proyecto proyecto
    /**
     * Institución del objetivo estratégico
     */
    String institucion
    /**
     * Objetivo
     */
    String objetivo
    /**
     * Política del objetivo estratégico
     */
    String politica
    /**
     * Meta del objetivo estratégico
     */
    String meta

    /**
     * Define los campos que se van a ignorar al momento de hacer logs
     */
    static auditable = [ignore: []]

    /**
     * Define el mapeo entre los campos del dominio y las columnas de la base de datos
     */
    static mapping = {
        table 'obet'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'obet__id'
        id generator: 'identity'
        version false
        columns {
            id column: 'obet__id'
            proyecto column: 'proy__id'
            institucion column: 'obetinst'
            objetivo column: 'obetobjt'
            politica column: 'obetpltc'
            meta column: 'obetmeta'
        }
    }

    /**
     * Define las restricciones de cada uno de los campos
     */
    static constraints = {
        proyecto(blank: true, nullable: true, attributes: [mensaje: 'Proyecto'])
        institucion(size: 1..255, blank: true, nullable: true, attributes: [mensaje: 'Objetivo estratégico institucional'])
        objetivo(size: 1..255, blank: true, nullable: true, attributes: [mensaje: 'Objetivo'])
        politica(size: 1..255, blank: true, nullable: true, attributes: [mensaje: 'Política'])
        meta(size: 1..255, blank: true, nullable: true, attributes: [mensaje: 'Meta'])
    }
}