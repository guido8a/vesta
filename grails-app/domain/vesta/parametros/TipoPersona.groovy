package vesta.parametros

/**
 * Clase para conectar con la tabla 'tpps' de la base de datos
 */
class TipoPersona {
    /**
     * Descripción del tipo de persona
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
        table 'tpps'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'tpps__id'
        id generator: 'identity'
        version false
        columns {
            id column: 'tpps__id'
            descripcion column: 'tppsdesc'
        }
    }

    /**
     * Define las restricciones de cada uno de los campos
     */
    static constraints = {
        descripcion(blank: true, nullable: true, attributes: [mensaje: 'Descripcion'])
    }

    /**
     * Genera un string para mostrar
     * @return la descripción
     */
    String toString() {
        return this.descripcion
    }
}
