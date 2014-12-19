package vesta.poa
/*
  Actividades de gasto corriente
 */

/**
 * Clase para conectar con la tabla 'actv' de la base de datos<br/>
 * Actividades de gasto corriente
 */
class Actividad   {
    /**
     * Código de la actividad
     */
    String codigo
    /**
     * Descripción de la actividad
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
        table 'actv'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'actv__id'
        id generator: 'identity'
        version false
        columns {
            id column: 'actv__id'
            codigo column: 'actvcdgo'
            descripcion column: 'actvdscr'
        }
    }

    /**
     * Define las restricciones de cada uno de los campos
     */
    static constraints = {
        codigo(size: 1..20, blank: true, nullable: true, attributes: [mensaje: 'Código de la actividad'])
        descripcion(size: 1..255, blank: true, nullable: true, attributes: [mensaje: 'Descripción corta de la actividad'])
    }

    /**
     * Genera un string para mostrar
     * @return la descripción
     */
    String toString() {
        "${this.descripcion}"
    }
}