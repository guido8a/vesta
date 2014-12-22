package vesta.parametros.poaPac

/**
 * Clase para conectar con la tabla 'pgps' de la base de datos
 */
class ProgramaPresupuestario   {
    /**
     * Código del programa presupuestario
     */
    String codigo
    /**
     * Descripción del programa presupuestario
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
        table 'pgps'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'pgps__id'
        id generator: 'identity'
        version false
        columns {
            id column: 'pgps__id'
            codigo column: 'pgpscdgo'
            descripcion column: 'pgpsdscr'
        }
    }

    /**
     * Define las restricciones de cada uno de los campos
     */
    static constraints = {
        codigo(size: 1..20, blank: true, nullable: true, attributes: [mensaje: 'Código del programa presupuestario'])
        descripcion(size: 1..255, blank: true, nullable: true, attributes: [mensaje: 'Descripción corta del programa presupuestario'])
    }

    /**
     * Genera un string para mostrar
     * @return el código y la descripción concatenados
     */
    String toString() {
        "${this.codigo}:${this.descripcion}"
    }
}