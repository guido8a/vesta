package vesta.seguridad

/**
 * Clase para conectar con la tabla 'accs' de la base de datos
 */
class Accs implements Serializable {
    /**
     * Fecha inicial del acceso
     */
    Date accsFechaInicial
    /**
     * Fecha final del acceso
     */
    Date accsFechaFinal
    /**
     * Observaciones
     */
    String accsObservaciones
    /**
     * Usuario para el acceso
     */
    Usro usuario

    /**
     * Define el mapeo entre los campos del dominio y las columnas de la base de datos
     */
    static mapping = {
        table 'accs'
        version false
        id generator: 'identity'

        columns {
            id column: 'accs__id'
            usuario column: 'usro__id'
            accsFechaInicial column: 'accsfcin'
            accsFechaFinal column: 'accsfcfn'
            accsObservaciones column: 'accsobsr'
        }
    }

    /**
     * Define las restricciones de cada uno de los campos
     */
    static constraints = {
        accsFechaInicial(blank: false, nullable: false)
        accsFechaFinal(blank: false, nullable: false)
        accsObservaciones(blank: true, nullable: true)
    }


}
