package vesta.parametros.geografia
/**
 * Clase para conectar con la tabla 'zona' de la base de datos<br/>
 * Guarda la lista de zonas
 */
class Zona   {
    /**
     * Número de la zona
     */
    Integer numero
    /**
     * Nombre de la zona
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
        table 'zona'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'zona__id'
        id generator: 'identity'
        version false
        columns {
            id column: 'zona__id'
            numero column: 'zonanmro'
            nombre column: 'zonanmbr'
        }
    }

    /**
     * Define las restricciones de cada uno de los campos
     */
    static constraints = {
        numero(blank: true, nullable: true, attributes: [mensaje: 'Número de la zona'])
        nombre(size: 1..63, blank: true, nullable: true, attributes: [mensaje: 'Nombre de la zona'])
    }

    /**
     * Genera un string para mostrar
     * @return el nombre
     */
    String toString() {
        return this.nombre
    }
}