package vesta.poa

/**
 * Clase para conectar con la tabla 'comp' de la base de datos
 */
class Componente {
    /**
     * Descripción del componente
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
        table 'comp'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'comp__id'
        id generator: 'identity'
        version false
        columns {
            id column: 'comp__id'
            descripcion column: 'compdscr'
        }
    }
    /**
     * Define las restricciones de cada uno de los campos
     */
    static constraints = {
        descripcion(nullable: false, blank: false, size: 1..1024)
    }

    /**
     * Genera un string para mostrar
     * @return la descripción
     */
    String toString() {
        "${this.descripcion}"
    }
}
