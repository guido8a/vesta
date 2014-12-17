package vesta.proyectos

/**
 * Clase para conectar con la tabla 'estc' de la base de datos
 */
class EstudiosTecnicos implements Serializable {
    /**
     * Proyecto del estudio técnico
     */
    Proyecto proyecto
    /**
     * Resumen del estudio técnico
     */
    String resumen
    /**
     * Path del archivo del documento del estudio técnico
     */
    String documento
    /**
     * Fecha del estudio técnico
     */
    Date fecha

    /**
     * Define los campos que se van a ignorar al momento de hacer logs
     */
    static auditable = [ignore: []]

    /**
     * Define el mapeo entre los campos del dominio y las columnas de la base de datos
     */
    static mapping = {
        table 'estc'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'estc__id'
        id generator: 'identity'
        version false
        columns {
            id column: 'estc__id'
            proyecto column: 'proy__id'
            resumen column: 'estcrsmn'
            documento column: 'estcdcmt'
            fecha column: 'estcfcha'
        }
    }

    /**
     * Define las restricciones de cada uno de los campos
     */
    static constraints = {
        proyecto(blank: true, nullable: true, attributes: [mensaje: 'Proyecto'])
        resumen(size: 1..1023, blank: true, nullable: true, attributes: [mensaje: 'Resumen del estudio'])
        documento(size: 1..255, blank: true, nullable: true, attributes: [mensaje: 'Documento (path de acceso al pdf)'])
        fecha(blank: true, nullable: true, attributes: [mensaje: 'Fecha de creación del estudio'])
    }
}