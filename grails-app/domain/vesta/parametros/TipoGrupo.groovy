package vesta.parametros

/**
 * Clase para conectar con la tabla 'tpgr' de la base de datos
 */
class TipoGrupo   {
    /**
     * Descripción del tipo de grupo
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
        table 'tpgr'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'tpgr__id'
        id generator: 'identity'
        version false
        columns {
            id column: 'tpgr__id'
            descripcion column: 'tpgrdscr'
        }
    }

    /**
     * Define las restricciones de cada uno de los campos
     */
    static constraints = {
        descripcion(size: 1..127, blank: true, nullable: true, attributes: [mensaje: 'Descripción del tipo de grupo de atención del SENPLADES'])
    }

    /**
     * Genera un string para mostrar
     * @return la descripción
     */
    String toString() {
        return this.descripcion
    }
}