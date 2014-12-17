package vesta.contratacion

import vesta.parametros.poaPac.Anio

/**
 * Clase para conectar con la tabla 'dtms' de la base de datos
 */
class DetalleMontoSolicitud {
    /**
     * Solicitud de la cual se detalla el monto
     */
    Solicitud solicitud
    /**
     * Año para el cual se está detallando
     */
    Anio anio
    /**
     * Monto para el año especificado
     */
    double monto

    /**
     * Define los campos que se van a ignorar al momento de hacer logs
     */
    static auditable = [ignore: []]

    /**
     * Define el mapeo entre los campos del dominio y las columnas de la base de datos
     */
    static mapping = {
        table 'dtms'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'dtms__id'
        id generator: 'identity'
        version false
        columns {
            solicitud column: 'slct__id'
            anio column: 'anio__id'
            monto column: 'dtmsmnto'
        }
    }

    /**
     * Define las restricciones de cada uno de los campos
     */
    static constraints = {
    }
}
