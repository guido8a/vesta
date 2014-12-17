package vesta.seguridad

/**
 * Clase para conectar con la tabla 'accn' de la base de datos
 */
class Accn {
    /**
     * Nombre de la acción
     */
    String accnNombre
    /**
     * Descripción de la acción
     */
    String accnDescripcion
    /**
     * Indica si la acción es o no auditable
     */
    int accnAuditable
    /**
     * Controlador al cual pertenece la acción
     */
    Ctrl control
    /**
     * Módulo al cual pertenece la acción
     */
    Modulo modulo
    /**
     * Tipo de acción
     */
    Tpac tipo

    /**
     * Define las relaciones uno a varios
     */
    static hasMany = [permisos: Prms]
    static searchable = true

    /**
     * Define el mapeo entre los campos del dominio y las columnas de la base de datos
     */
    static mapping = {
        table 'accn'
        cache usage: 'read-write', include: 'non-lazy'
        version false
        id generator: 'identity'
        control sort: ['ctrlNombre': 'asc']
        columns {
            id column: 'accn__id'
            accnNombre column: 'accnnmbr'
            accnDescripcion column: 'accndscr'
            accnAuditable column: 'accnaudt'
            control column: 'ctrl__id'
            modulo column: 'mdlo__id'
            tipo column: 'tpac__id'
        }
    }

    /**
     * Define las restricciones de cada uno de los campos
     */
    static constraints = {
        accnNombre(blank: false, size: 0..50)
        accnAuditable(blank: true, nullable: true)
    }

    /**
     * Genera un string para mostrar
     * @return el nombre de controlador y el nombre de la acción concatenados
     */
    String toString() {
        "${this.control.ctrlNombre} : ${this.accnNombre} "
    }
}
