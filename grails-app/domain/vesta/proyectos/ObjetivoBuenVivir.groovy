package vesta.proyectos

/**
 * Clase para conectar con la tabla 'obbv' de la base de datos
 */
class ObjetivoBuenVivir   {
    /**
     * Código del objetivo de buen vivir
     */
    Integer codigo
    /**
     * Descripción del objetivo de buen vivir
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
        table 'obbv'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'obbv__id'
        id generator: 'identity'
        version false
        columns {
            id column: 'obbv__id'
            codigo column: 'obbvcdgo'
            descripcion column: 'obbvdscr'
        }
    }

    /**
     * Define las restricciones de cada uno de los campos
     */
    static constraints = {
        codigo(blank: false, nullable: false, attributes: [mensaje: 'Código del objetivo'])
        descripcion(size: 1..127, blank: true, nullable: true, attributes: [mensaje: 'Descripción del objetivo'])
    }

    /**
     * Genera un string para mostrar
     * @return el c&oaute;digo y la descripción concatenados
     */
    String toString() {
        return this.codigo + " - " + this.descripcion
    }
}
