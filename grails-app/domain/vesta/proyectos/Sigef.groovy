package vesta.proyectos

import vesta.parametros.poaPac.Anio
import vesta.parametros.poaPac.Mes

/**
 * Clase para conectar con la tabla 'sigf' de la base de datos
 */
class Sigef {
    /**
     * Año
     */
    Anio anio
    /**
     * Mes
     */
    Mes mes
    /**
     * Fecha
     */
    Date fecha
    /**
     * Archivo
     */
    String archivo

    /**
     * Define los campos que se van a ignorar al momento de hacer logs
     */
    static auditable = [ignore: []]

    /**
     * Define el mapeo entre los campos del dominio y las columnas de la base de datos
     */
    static mapping = {
        table 'sigf'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'sigf__id'
        id generator: 'identity'
        version false
        columns {
            anio column: 'anio__id'
            mes column: 'mess__id'
            fecha column: 'sigffcha'
            archivo column: 'sigfarch'
        }
    }

    /**
     * Define las restricciones de cada uno de los campos
     */
    static constraints = {
        anio(nullable: false, blank: false)
        mes(nullable: false, blank: false)
        fecha(blank: true, nullable: true, attributes: [mensaje: 'Fecha de carga de datos'])
    }
}
