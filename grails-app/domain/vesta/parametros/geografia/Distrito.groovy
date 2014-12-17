package vesta.parametros.geografia

/**
 * Clase para conectar con la tabla 'dstt' de la base de datos<br/>
 * Guarda la lista de distritos
 */
class Distrito implements Serializable {
    /**
     * Código del distrito
     */
    String codigo
    /**
     * Nombre del distrito
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
        table 'dstt'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'dstt__id'
        id generator: 'identity'
        version false
        columns {
            id column: 'dstt__id'
            codigo column: 'dsttcdgo'
            nombre column: 'dsttnmbr'
        }
    }

    /**
     * Define las restricciones de cada uno de los campos
     */
    static constraints = {
        codigo(size: 1..5, blank: true, nullable: true, attributes: [mensaje: 'Código del distrito'])
        nombre(size: 1..63, blank: true, nullable: true, attributes: [mensaje: 'Nombre del distrito'])
    }

    /**
     * Genera un string para mostrar
     * @return el nombre
     */
    String toString() {
        return this.nombre
    }
}