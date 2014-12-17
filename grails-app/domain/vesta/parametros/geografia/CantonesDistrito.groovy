package vesta.parametros.geografia

/**
 * Clase para conectar con la tabla 'cndt' de la base de datos<br/>
 * Tabla intermedia para unir distritos con cantones
 */
class CantonesDistrito implements Serializable {
    /**
     * Id del distrito
     */
    int dstt__id
    /**
     * Id del cantón
     */
    int cntn__id

    /**
     * Define los campos que se van a ignorar al momento de hacer logs
     */
    static auditable = [ignore: []]

    /**
     * Define el mapeo entre los campos del dominio y las columnas de la base de datos
     */
    static mapping = {
        table 'cndt'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'cndt__id'
        id generator: 'identity'
        version false
        columns {
            id column: 'cndt__id'
            dstt__id column: 'dstt__id'
            cntn__id column: 'cntn__id'
        }
    }

    /**
     * Define las restricciones de cada uno de los campos
     */
    static constraints = {
        dstt__id(blank: true, nullable: true, attributes: [mensaje: 'Distrito'])
        cntn__id(blank: true, nullable: true, attributes: [mensaje: 'Cantón'])
    }
}