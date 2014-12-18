package vesta.seguridad

/**
 * Clase para conectar con la tabla 'logf' de la base de datos
 */
class ErrorLog {
    /**
     * Fecha del log de error
     */
    Date fecha
    /**
     * Error registrado
     */
    String error
    /**
     * Causa del error
     */
    String causa
    /**
     * URL que generó el error
     */
    String url
    /**
     * Usuario logueado al momento del error
     */
    Persona usuario

    /**
     * Define el mapeo entre los campos del dominio y las columnas de la base de datos
     */
    static mapping = {
        table 'logf'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'logf__id'
        id generator: 'identity'
        version false
        columns {
            id column: 'logf__id'
            fecha column: 'logffcha'
            error column: 'logferro'
            causa column: 'logfcaus'
            url column: 'logf_url'
            usuario column: 'logfprsn'
        }
    }
    /**
     * Define las restricciones de cada uno de los campos
     */
    static constraints = {
    }

    /**
     * Genera un string para mostrar
     * @return el error
     */
    String toString() {
        "${this.error}"
    }
}
