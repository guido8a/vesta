package vesta.avales

import vesta.parametros.UnidadEjecutora
import vesta.seguridad.Firma
import vesta.seguridad.Persona

/**
 * Clase para conectar con la tabla 'slav' de la base de datos
 */
class SolicitudAval {
    /**
     * Proceso de la solicitud de aval
     */
    ProcesoAval proceso
    /**
     * Unidad ejecutora que solicita el aval
     */
    UnidadEjecutora unidad
    /**
     * Usuario que generó la solicitud
     */
    Persona usuario
    /**
     * Aval de la solicitud
     */
    Aval aval
    /**
     * Estado de la solicitud
     */
    EstadoAval estado
    /**
     * Path del documento de solicitud
     */
    String path
    /**
     * Concepto de la solicitud
     */
    String concepto
    /**
     * Contrato de solicitud de aval
     */
    String contrato
    /**
     * Número de memo de solicitud de aval
     */
    String memo
    /**
     * Fecha de solicitud
     */
    Date fecha
    /**
     * Fecha de revisión de la solicitud
     */
    Date fechaRevision
    /**
     * Monto de la solicitud
     */
    double monto = 0;
    /**
     * Observaciones de la solicitud
     */
    String observaciones
    /**
     * Número de la solicitud
     */
    int numero
    /**
     * Tipo de solicitud: <br/>
     * &nbsp;&nbsp;&nbsp;&nbsp; : aprobación
     * &nbsp;&nbsp;&nbsp;&nbsp;A: anulación
     */
    String tipo /*A--> anulacion*/

    /**
     * Firma de la solicitud
     */
    Firma firma

    /**
     * Nota Técnica de la solicitud
     */
    String notaTecnica


    /**
     * Define el mapeo entre los campos del dominio y las columnas de la base de datos
     */
    static mapping = {
        table 'slav'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'slav__id'
        id generator: 'identity'
        version false
        columns {
            id column: 'slav__id'
            proceso column: 'prco__id'
            aval column: 'aval__id'
            fechaRevision column: 'slavfcrv'
            fecha column: 'slavfcha'
            monto column: 'slavmnto'
            path column: 'slavpath'
            contrato column: 'slavcntr'
            memo column: 'slavmemo'
            concepto column: 'slavcpto'
            estado column: 'edav__id'
            usuario column: 'prsn__id'
            observaciones column: 'slavobsr'
            observaciones type: 'text'
            numero column: 'slavnmro'
            tipo column: 'slavtipo'
            firma column: 'frma__id'
            unidad column: 'unej__id'
            notaTecnica column: 'slavnttc'
        }
    }

    /**
     * Define las restricciones de cada uno de los campos
     */
    static constraints = {
        concepto(blank: true, nullable: true, size: 1..500)
        proceso(blank: false, nullable: false)
        aval(blank: true, nullable: true)
        fechaRevision(blank: true, nullable: true)
        estado(blank: false, nullable: false)
        path(blank: true, nullable: true, size: 1..350)
        contrato(blank: true, nullable: true, size: 1..30)
        memo(blank: true, nullable: true, size: 1..63)
        observaciones(blank: true, nullable: true)
        numero(blank: true, nullable: true)
        tipo(blank: true, nullable: true, size: 1..1)
        firma(blank: true, nullable: true)
        unidad(nullable: true, blank: true)
        notaTecnica (nullable: true, blank: true, size: 1..350)
    }
}
