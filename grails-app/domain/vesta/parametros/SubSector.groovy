package vesta.parametros

/**
 * Clase para conectar con la tabla 'sbst' de la base de datos
 */
class SubSector   {
    /**
     * Descripción del subsector
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
        table 'sbst'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'sbst__id'
        id generator: 'identity'
        version false
        columns {
            id column: 'sbst__id'
            descripcion column: 'sbstdscr'
        }
    }

    /**
     * Define las restricciones de cada uno de los campos
     */
    static constraints = {
        descripcion(size: 1..31, blank: false, attributes: [mensaje: 'Descripción del subsector'])
    }

    /**
     * Genera un string para mostrar
     * @return la descripción
     */
    String toString() {
        return this.descripcion
    }
}