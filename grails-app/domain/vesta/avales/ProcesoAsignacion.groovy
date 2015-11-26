package vesta.avales

import vesta.poa.Asignacion

/**
 * Clase para conectar con la tabla 'poas' de la base de datos
 */
class ProcesoAsignacion {
    /**
     * Proceso
     */
    ProcesoAval proceso
    /**
     * Proceso aval corriente
     */
    AvalCorriente avalCorriente
    /**
     * Asignación
     */
    Asignacion asignacion
    /**
     * Monto
     */
    double monto
    /**
     * Devengado
     */
    double devengado
    /**
     * Liberado
     */
    double liberado

    /**
     * Define el mapeo entre los campos del dominio y las columnas de la base de datos
     */
    static mapping = {
        table 'poas'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'poas__id'
        id generator: 'identity'
        version false
        columns {
            id column: 'poas__id'
            proceso column: 'prco__id'
            avalCorriente column: 'avcr__id'
            asignacion column: 'asgn__id'
            monto column: 'poasmnto'
            devengado column: 'poasdvgd'
            liberado column: 'poaslbrd'
        }
    }

    /**
     * Define las restricciones de cada uno de los campos
     */
    static constraints = {
        proceso nullable: true
        avalCorriente nullable: true
        liberado nullable: true
    }
}
