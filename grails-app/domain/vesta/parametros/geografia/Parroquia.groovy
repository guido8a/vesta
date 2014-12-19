package vesta.parametros.geografia

/**
 * Clase para conectar con la tabla 'parr' de la base de datos<br/>
 * Guarda la lista de parroquias por cantón
 */
class Parroquia   {
    /**
     * Cantón al cual pertenece la parroquia
     */
    Canton canton
    /**
     * Número de parroquia
     */
    Integer numero
    /**
     * Nombre de la parroquia
     */
    String nombre
    /**
     * Código de la parroquia
     */
    String codigo

    /**
     * Posición geográfica de la parroquia (longitud para ubicar en un mapa)
     */
    double longitud
    /**
     * Posición geográfica de la parroquia (latitud para ubicar en un mapa)
     */
    double latitud

    /**
     * Diff
     */
    double diff

    /**
     * Zoom del mapa al mostrar la parroquia
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
        table 'parr'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'parr__id'
        id generator: 'identity'
        version false
        columns {
            id column: 'parr__id'
            canton column: 'cntn__id'
            numero column: 'parrnmro'
            nombre column: 'parrnmbr'
            codigo column: 'parrcdgo'

            longitud column: 'parrlong'
            latitud column: 'parrlatt'
            diff column: 'parrdiff'
            zoom column: 'parrzoom'
        }
    }

    /**
     * Define las restricciones de cada uno de los campos
     */
    static constraints = {
        canton(blank: true, nullable: true, attributes: [mensaje: 'Cantón al que pertenece la parroquia'])
        numero(blank: true, nullable: true, attributes: [mensaje: 'Número de la parroquia'])
        nombre(size: 1..63, blank: true, nullable: true, attributes: [mensaje: 'Nombre de la parroquia'])
        codigo(size: 1..6, blank: true, nullable: true, attributes: [mensaje: 'Código de la parroquia'])
    }

    /**
     * Genera un string para mostrar
     * @return el nombre
     */
    String toString() {
        return this.nombre
    }
}