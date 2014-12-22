package vesta.seguridad

/**
 * Clase para conectar con la tabla 'prfl' de la base de datos
 */
class Prfl   {
    /**
     * Nombre del perfil
     */
    String nombre
    /**
     * Descripción del perfil
     */
    String descripcion
    /**
     * Perfil padre del perfil actual
     */
    Prfl padre
    /**
     * Observaciones
     */
    String observaciones
    /**
     * Código del perfil
     */
    String codigo

    /**
     * Define los campos que se van a ignorar al momento de hacer logs
     */
    static auditable = [ignore: []]

    /**
     * Define las relaciones uno a varios
     */
    static hasMany = [permisos: Prms, perfiles: Prfl]

    /**
     * Define el mapeo entre los campos del dominio y las columnas de la base de datos
     */
    static mapping = {
        table 'prfl'
        cache usage: 'read-write'
        version false
        id generator: 'identity'
        sort nombre: "asc"
        columns {
            id column: 'prfl__id'
            nombre column: 'prflnmbr'
            descripcion column: 'prfldscr'
            padre column: 'prflpdre'
            observaciones column: 'prflobsr'
            codigo column: 'prflcdgo'
        }
    }

    /**
     * Define las restricciones de cada uno de los campos
     */
    static constraints = {
        codigo(blank: true, nullable: true)
    }

    /**
     * Genera un string para mostrar
     * @return el nombre
     */
    String toString() {
        return "${this.nombre}"
    }
}
