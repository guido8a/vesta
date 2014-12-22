package vesta.parametros

/**
 * Clase para conectar con la tabla 'tpin' de la base de datos
 */
class TipoInstitucion   {
    /**
     * Código del tipo de institución
     */
    String codigo
    /**
     * Descripción del tipo de institución
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
        table 'tpin'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'tpin__id'
        id generator: 'identity'
        version false
        columns {
            id column: 'tpin__id'
            codigo column: 'tpincdgo'
            descripcion column: 'tpindscr'
        }
    }

    /**
     * Define las restricciones de cada uno de los campos
     */
    static constraints = {
        codigo(size: 1..2, blank: false, nullable: false, attributes: [mensaje: 'Código del área de gestión'])
        descripcion(size: 1..31, blank: true, nullable: true, attributes: [mensaje: 'Descripción del área de gestión'])
    }

    /**
     * Genera un string para mostrar
     * @return la descripción
     */
    String toString() {
        return this.descripcion
    }
}