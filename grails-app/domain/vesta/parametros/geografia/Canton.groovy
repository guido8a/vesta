package vesta.parametros.geografia

/**
 * Clase para conectar con la tabla 'cntn' de la base de datos<br/>
 * Guarda la lista de cantones por provincia y por zona
 */
class Canton implements Serializable {
    /**
     * Provincia a la cual pertenece el cantón
     */
    Provincia provincia
    /**
     * Zona a la cual pertenece el cantón
     */
    Zona zona
    /**
     * Número de cantón
     */
    Integer numero
    /**
     * Nombre del cantón
     */
    String nombre

    /**
     * Posición geográfica del cantón (longitud para ubicar en un mapa)
     */
    double longitud
    /**
     * Posición geográfica del cantón (latitud para ubicar en un mapa)
     */
    double latitud

    /**
     * Diff
     */
    double diff

    /**
     * Zoom del mapa al mostrar el cantón
     */
    double zoom

    /**
     * Define los campos que se van a ignorar al momento de hacer logs
     */
    static auditable = [ignore: []]

    /**
     * Define el mapeo entre los campos del dominio y las columnas de la base de datos
     */
    static mapping = {
        table 'cntn'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'cntn__id'
        id generator: 'identity'
        version false
        columns {
            id column: 'cntn__id'
            zona column: 'zona__id'
            provincia column: 'prov__id'
            numero column: 'cntnnmro'
            nombre column: 'cntnnmbr'

            longitud column: 'cntnlong'
            latitud column: 'cntnlatt'

            diff column: 'cntndiff'
            zoom column: 'cntnzoom'

        }
    }

    /**
     * Define las restricciones de cada uno de los campos
     */
    static constraints = {
        zona(blank: true, nullable: true, attributes: [mensaje: 'Zona a la que pertenece el cantón'])
        provincia(blank: true, nullable: true, attributes: [mensaje: 'Provincia a la que pertenece el cantón'])
        numero(blank: true, nullable: true, attributes: [mensaje: 'Número del cantón'])
        nombre(size: 1..63, blank: true, nullable: true, attributes: [mensaje: 'Nombre del cantón'])
    }

    /**
     * Genera un string para mostrar
     * @return el nombre
     */
    String toString() {
        return this.nombre
    }
}