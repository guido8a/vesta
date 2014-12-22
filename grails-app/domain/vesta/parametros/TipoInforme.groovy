package vesta.parametros

/**
 * Clase para conectar con la tabla 'tpif' de la base de datos
 */
class TipoInforme   {
    /**
     * Descripción del tipo de informe
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
        table 'tpif'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'tpif__id'
        id generator: 'identity'
        version false
        columns {
            id column: 'tpif__id'
            descripcion column: 'tpifdscr'
        }
    }

    /**
     * Define las restricciones de cada uno de los campos
     */
    static constraints = {
        descripcion(size: 1..63, blank: true, nullable: true, attributes: [mensaje: 'Descripción del tipo de informe'])
    }

    /**
     * Genera un string para mostrar
     * @return la descripción
     */
    String toString() {
        return this.descripcion
    }
}