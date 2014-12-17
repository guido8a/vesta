package vesta.parametros.geografia
/**
 * Clase para conectar con la tabla 'prdt' de la base de datos<br/>
 * Tabla intermedia para unir distritos con parroquias
 */
class ParroquiasDistrito implements Serializable {
    /**
     * Id del distrito
     */
    int dstt__id
    /**
     * Id de la parroquia
     */
    int parr__id

    /**
     * Define los campos que se van a ignorar al momento de hacer logs
     */
    static auditable = [ignore: []]

    /**
     * Define el mapeo entre los campos del dominio y las columnas de la base de datos
     */
    static mapping = {
        table 'prdt'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'prdt__id'
        id generator: 'identity'
        version false
        columns {
            id column: 'prdt__id'
            dstt__id column: 'dstt__id'
            parr__id column: 'parr__id'
        }
    }

    /**
     * Define las restricciones de cada uno de los campos
     */
    static constraints = {
        dstt__id(blank: true, nullable: true, attributes: [mensaje: 'Distrito'])
        parr__id(blank: true, nullable: true, attributes: [mensaje: 'Parroquia'])
    }
}