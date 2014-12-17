package vesta.parametros.geografia

/**
 * Clase para conectar con la tabla 'regn' de la base de datos<br/>
 * Guarda la lista de regiones
 */
class Region implements Serializable {
    /**
     * Có de la región
     */
    String codigo
    /**
     * Nombre de la región
     */
    String nombre

    /**
     * Define los campos que se van a ignorar al momento de hacer logs
     */
    static auditable = [ignore: []]

    /**
     * Define el mapeo entre los campos del dominio y las columnas de la base de datos
     */
    static mapping = {
        table 'regn'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'regn__id'
        id generator: 'identity'
        version false
        columns {
            id column: 'regn__id'
            codigo column: 'regncdgo'
            nombre column: 'regnnmbr'
        }
    }

    /**
     * Define las restricciones de cada uno de los campos
     */
    static constraints = {
        codigo(size: 1..1, blank: true, nullable: true, attributes: [mensaje: 'Código de la región'])
        nombre(size: 1..15, blank: true, nullable: true, attributes: [mensaje: 'Nombre de la región'])
    }

    /**
     * Genera un string para mostrar
     */
    String toString() {
        return this.nombre
    }
}