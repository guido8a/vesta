package vesta.modificaciones

import vesta.avales.EstadoAval
import vesta.parametros.poaPac.Anio
import vesta.seguridad.Firma
import vesta.seguridad.Persona

class Reforma {

    /**
     * El año del POA
     */
    Anio anio
    /**
     * Quien realiza la solicitud
     */
    Persona persona
    /**
     * Estado de la solicitud
     */
    EstadoAval estado
    /**
     * Quien firma la solicitud
     */
    Firma firmaSolicitud
    /**
     * Firma 1 de aprobación
     */
    Firma firma1
    /**
     * Firma 2 de aprobación
     */
    Firma firma2
    /**
     * Concepto, por qué la nueva actividad, objetivo o justificación
     */
    String concepto
    /**
     * Fecha de realización
     */
    Date fecha
    /**
     * Fecha de revisión
     */
    Date fechaRevision
    /**
     * Tipo de reforma: A:ajuste, R:reforma. No existe Ajuste por incremento
     */
    String tipo
    /**
     * Tipo de la solicitud E: existente, A: actividad, P: partida, I: incremento
     */
    String tipoSolicitud
    /**
     * Texto para párrafo inicial de la reforma o ajuste (PDF)
     */
    String textoPdf
    /**
     * Nota técnica u observaciones
     */
    String nota
    /**
     * Secuencial generado cuando se aprueba (2da firma de aprobacion)
     */
    Integer numero = 0
    /**
     * Analista de planificación que revisó la solicitud de reforma
     */
    Persona analista

    /**
     * Define los campos que se van a ignorar al momento de hacer logs
     */
    static auditable = [ignore: []]

    /**
     * Define el mapeo entre los campos del dominio y las columnas de la base de datos
     */
    static mapping = {
        table 'rfrm'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'rfrm__id'
        id generator: 'identity'
        version false
        columns {
            anio column: 'anio__id'
            persona column: 'prsn__id'
            estado column: 'edav__id'
            firmaSolicitud column: 'frmaslid'
            firma1 column: 'frma1_id'
            firma2 column: 'frma2_id'
            concepto column: 'rfrmcpto'
            fecha column: 'rfrmfcha'
            fechaRevision column: 'rfrmfcrv'
            tipo column: 'rfrmtipo'
            tipoSolicitud column: 'rfrmtprf'
            textoPdf column: 'rfrm_pdf'
            nota column: 'rfrmnota'
            numero column: 'rfrmnmro'
            analista column: 'rfrmpran'
        }
    }

    /**
     * Define las restricciones de cada uno de los campos
     */
    static constraints = {
        firmaSolicitud nullable: true
        firma1 nullable: true
        firma2 nullable: true
        fechaRevision nullable: true
        textoPdf blank: true, nullable: true
        nota blank: true, nullable: true
        analista nullable: true
    }
}
