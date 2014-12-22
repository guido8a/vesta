package vesta.proyectos

/**
 * Clase para conectar con la tabla 'prcs' de la base de datos
 */
class Proceso   {
    /**
     * Nombre del proceso
     */
    String nombre
    /**
     * Descripción del proceso
     */
    String descripcion
    /**
     * Fecha del proceso
     */
    Date fecha
    /**
     * Fecha de fin del proceso
     */
    Date fechaFin
    /**
     * Estado del proceso
     */
    String estado
    /**
     * Observaciones
     */
    String observaciones

    /**
     * Define los campos que se van a ignorar al momento de hacer logs
     */
    static auditable = [ignore: []]

    /**
     * Define el mapeo entre los campos del dominio y las columnas de la base de datos
     */
    static mapping = {
        table 'prcs'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'prcs__id'
        id generator: 'identity'
        version false
        columns {
            id column: 'prcs__id'
            nombre column: 'sbscnmbr'
            descripcion column: 'prcsdscr'
            fecha column: 'prcsfcha'
            fechaFin column: 'prcsfcfn'
            estado column: 'prcsetdo'
            observaciones column: 'prcsobsr'
        }
    }

    /**
     * Define las restricciones de cada uno de los campos
     */
    static constraints = {
        id(attributes: [mensaje: 'Código secuencial del proceso'])
        nombre(size: 1..63, blank: false, attributes: [mensaje: 'Nombre del proceso'])
        descripcion(size: 1..255, blank: true, nullable: true, attributes: [mensaje: 'Descripción del proceso'])
        fecha(blank: true, nullable: true, attributes: [mensaje: 'Fecha de registro del proceso'])
        fechaFin(blank: true, nullable: true, attributes: [mensaje: 'Fecha en que se eliminó el proceso'])
        estado(size: 1..1, blank: true, nullable: true, attributes: [mensaje: 'Estado del proceso'])
        observaciones(size: 1..127, blank: true, nullable: true, attributes: [mensaje: 'Observaciones'])
    }

    /**
     * Genera un string para mostrar
     * @return el nombre
     */
    String toString() {
        return this.nombre
    }
}