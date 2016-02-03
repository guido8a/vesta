package vesta.avales

import vesta.parametros.UnidadEjecutora
import vesta.seguridad.Firma
import vesta.seguridad.Persona

class AvalCorriente {

    /**
     * Nombre del proceso
     */
    String nombreProceso
    /**
     * Fecha de inicio del proceso
     */
    Date fechaInicioProceso
    /**
     * Fecha fin del proceso
     */
    Date fechaFinProceso
    /**
     * Usuario que generó la solicitud
     */
    Persona usuario
    /**
     * Estado de la solicitud
     */
    EstadoAval estado
    /**
     * Path del documento de solicitud
     */
    String path
    /**
     * Path del documento de respaldo de liberación del aval
     */
    String pathLiberacion
    /**
     * Path del documento de respaldo de anulación del aval
     */
    String pathAnulacion
    /**
     * Concepto de la solicitud
     */
    String concepto
    /**
     * Contrato de solicitud de aval
     */
    String contrato
    /**
     * Número de contrato para la liberación
     */
    String contratoLiberacion
    /**
     * Número de memo de solicitud de aval
     */
    String memo
    /**
     * Fecha de solicitud
     */
    Date fechaSolicitud
    /**
     * Fecha de revisión de la solicitud
     */
    Date fechaRevision
    /**
     * Monto de la solicitud
     */
    double monto = 0;
    /**
     * Monto de liberación del aval
     */
    double liberacion = 0
    /**
     * Observaciones de la solicitud
     */
    String observaciones
    /**
     * Observaciones de la solicitud para el pdf
     */
    String observacionesPdf
    /**
     * Número de la solicitud
     */
    int numeroSolicitud = 0
    /**
     * Número del aval
     */
    int numeroAval = 0
    /**
     * Firma de la solicitud (gerente)
     */
    Firma firmaGerente
    /**
     * Director que va a revisar la solicitud
     */
    Persona director
    /**
     * Analista de planificación que solicita las firmas
     */
    Persona analista
    /**
     * Nota Técnica de la solicitud
     */
    String notaTecnica
    /**
     * Fecha de aprobación del aval
     */
    Date fechaAprobacion
    /**
     * Fecha de liberación del aval
     */
    Date fechaLiberacion
    /**
     * Fecha de anulación del aval
     */
    Date fechaAnulacion
    /**
     * Número de la certificación para el aval
     */
    String certificacion
    /**
     * Firma del director
     */
    Firma firma1
    /**
     * Firma del gerente
     */
    Firma firma2
    /**
     * Firma del director para la anulacion
     */
    Firma firmaAnulacion1
    /**
     * Firma del gerente para la anulacion
     */
    Firma firmaAnulacion2

    /**
     * Define el mapeo entre los campos del dominio y las columnas de la base de datos
     */
    static mapping = {
        table 'avcr'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'avcr__id'
        id generator: 'identity'
        version false
        columns {
            nombreProceso column: "avcrnmpr"
            fechaInicioProceso column: "avcrfcin"
            fechaFinProceso column: "avcrfcfn"
            usuario column: "prsn__id"
            estado column: "edav__id"
            path column: "avcrpath"
            pathLiberacion column: "avcrptlb"
            pathAnulacion column: "avcrptan"
            concepto column: "avcrcncp"
            contrato column: "avcrcntr"
            contratoLiberacion column: "avcrcnlb"
            memo column: "avcrmemo"
            fechaSolicitud column: "avcrfcsl"
            fechaRevision column: "avcrfcrv"
            monto column: "avcrmnto"
            liberacion column: "avcrlbrc"
            observaciones column: "avcrobsv"
            observaciones type: "text"
            observacionesPdf column: "avcropdf"
            observacionesPdf type: "text"
            numeroSolicitud column: "avcrnmsl"
            numeroAval column: "avcrnmav"
            firmaGerente column: "frmagrnt"
            director column: "prsndrct"
            analista column: "prsnanls"
            notaTecnica column: "avcrnttc"
            fechaAprobacion column: "avcrfcap"
            fechaLiberacion column: "avcrfclb"
            fechaAnulacion column: "avcrfcan"
            certificacion column: "avcrcrtf"
            firma1 column: "frmafrm1"
            firma2 column: "frmafrm2"
            firmaAnulacion1 column: "frmafra1"
            firmaAnulacion2 column: "frmafra2"
        }
    }

    /**
     * Define las restricciones de cada uno de los campos
     */
    static constraints = {
        path nullable: true, maxSize: 350
        pathLiberacion nullable: true, maxSize: 350
        pathAnulacion nullable: true, maxSize: 350
        concepto nullable: true, maxSize: 500
        contrato nullable: true, maxSize: 30
        contratoLiberacion nullable: true, maxSize: 30
        memo nullable: true, maxSize: 63
        fechaRevision nullable: true
        observaciones nullable: true
        observacionesPdf nullable: true
        firmaGerente nullable: true
        director nullable: true
        analista nullable: true
        notaTecnica nullable: true, maxSize: 350
        fechaAprobacion nullable: true
        fechaAnulacion nullable: true
        certificacion nullable: true, maxSize: 50
        firma1 nullable: true
        firma2 nullable: true
        firmaAnulacion1 nullable: true
        firmaAnulacion2 nullable: true
        fechaLiberacion nullable: true
    }

    String toString() {
        "Solicitud de Aval para ${this.concepto}"
    }
}
