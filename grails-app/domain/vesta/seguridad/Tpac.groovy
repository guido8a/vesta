package vesta.seguridad

/**
 * Clase para conectar con la tabla 'tpac' de la base de datos
 */
class Tpac {
    /**
     * Tipo
     */
    String tipo

    /**
     * Define el mapeo entre los campos del dominio y las columnas de la base de datos
     */
    static mapping = {
        table 'tpac'
        cache usage: 'read-write', include: 'non-lazy'
        version false
        id generator: 'identity'
        columns {
            id column: 'tpac__id'
            tipo column: 'tpacdscr'
        }
    }

    /**
     * Define las restricciones de cada uno de los campos
     */
    static constraints = {
        tipo(blank: false, size: 0..31)
    }

    /**
     * Genera un string para mostrar
     * @return el tipo
     */
    String toString() {
        "${this.tipo}"
    }

}
