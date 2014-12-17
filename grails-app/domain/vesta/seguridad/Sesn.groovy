package vesta.seguridad

/**
 * Clase para conectar con la tabla 'sesn' de la base de datos
 */
class Sesn implements Serializable {
    /**
     * Usuario de la sesión
     */
    Usro usuario
    /**
     * Perfil de la sesión
     */
    Prfl perfil

    /**
     * Define los campos que se van a ignorar al momento de hacer logs
     */
    static auditable = [ignore: []]

    /**
     * Define el mapeo entre los campos del dominio y las columnas de la base de datos
     */
    static mapping = {
        table 'sesn'
        cache usage: 'read-write', include: 'non-lazy'
        version false
        id generator: 'identity'
        sort "perfil"
        columns {
            id column: 'sesn__id'
            perfil column: 'prfl__id'
            usuario column: 'usro__id'
        }
    }

    /**
     * Define las restricciones de cada uno de los campos
     */
    static constraints = {

    }

    /**
     * Genera un string para mostrar
     * @return el perfil
     */
    String toString() {
        return "${this.perfil}"
    }

}
