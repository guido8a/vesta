package vesta.seguridad

/**
 * Clase para conectar con la tabla 'sstm' de la base de datos
 */
class Sistema implements Serializable {
    /**
     * Nombre del sistema
     */
    String nombre
    /**
     * Descripción del sistema
     */
    String descripcion

    /**
     * Define los campos que se van a ignorar al momento de hacer logs
     */
    static auditable = [ignore: []]

    /**
     * Define el mapeo entre los campos del dominio y las columnas de la base de datos
     */
    static mapping = {
        table 'sstm'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'sstm__id'
        id generator: 'identity'
        version false
        columns {
            id column: 'sstm__id'
            nombre column: 'sstnmbr'
            descripcion column: 'sstmdscr'
        }
    }

    /**
     * Define las restricciones de cada uno de los campos
     */
    static constraints = {
        nombre(matches: /^[a-zA-Z0-9ñÑ .,áéíóúÁÉÍÚÓüÜ#_+-]+$/, size: 1..50, blank: false, nullable: false)
        descripcion(matches: /^[a-zA-Z0-9ñÑ .,áéíóúÁÉÍÚÓüÜ#_+-]+$/, size: 1..500, blank: true, nullable: true)
    }

    /**
     * Genera un string para mostrar
     * @return la descripción
     */
    String toString() {
        "${this.descripcion}"
    }
}