package vesta.contratacion

import vesta.parametros.TipoAprobacion
import vesta.parametros.TipoBien
import vesta.parametros.TipoContrato
import vesta.parametros.UnidadEjecutora
import vesta.proyectos.MarcoLogico
import vesta.seguridad.Persona

/**
 * Clase para conectar con la tabla 'slct' de la base de datos
 */
class Solicitud {
    /**
     * Usuario que genera la solicitud
     */
    Persona usuario
    /**
     * Unidad ejecutora que genera la solicitud
     */
    UnidadEjecutora unidadEjecutora
    /**
     * Actividad para la cual es la solicitud
     */
    MarcoLogico actividad
    /**
     * Fecha de solicitud
     */
    Date fecha
    /**
     * Observaciones de la solicitud
     */
    String observaciones
    /**
     * Fecha de revisión por parte del asistente de la gerencia Administrativa Financiera
     */
    Date revisadoAdministrativaFinanciera       //asistente
    /**
     * Fecha de revisión por parte del asistente de la gerencia Jurídica
     */
    Date revisadoJuridica                       //asistente
    /**
     * Fecha de revisión por parte del asistente de la gerencia de Dirección de proyectos
     * @deprecated se pidió la eliminación de este campo
     */
    @Deprecated
    Date revisadoDireccionProyectos             //ya no vale
    /**
     * Fecha de validación por parte de la gerencia Administrativa Financiera
     */
    Date validadoAdministrativaFinanciera       //gerente
    /**
     * Fecha de validación por parte de la gerencia Jurídica
     */
    Date validadoJuridica                       //gerente
    /**
     * Observaciones por parte del asistente de la gerencia Administrativa Financiera
     */
    String observacionesAdministrativaFinanciera
    /**
     * Observaciones por parte del asistente de la gerencia Jurídica
     */
    String observacionesJuridica
    /**
     * Observaciones por parte del asistente de la gerencia de Dirección de proyectos
     * @deprecated se pidió la eliminación de este campo
     */
    @Deprecated
    String observacionesDireccionProyectos
    /**
     * Path del archivo de los términos de referencia
     */
    String pathPdfTdr

    /**
     * Monto solicitado
     */
    Double montoSolicitado
    /**
     * Tipo de contrato
     */
    TipoContrato tipoContrato
    /**
     * Tipo de bien
     */
    TipoBien tipoBien
    /**
     * Nombre de proceso
     */
    String nombreProceso
    /**
     * Objeto del contrato
     */
    String objetoContrato
    /**
     * Forma de pago
     */
    String formaPago
    /**
     * Plazo de ejecución en dís
     */
    Integer plazoEjecucion

    /**
     * Estado de la solicitud:<br/>
     * &nbsp;&nbsp;&nbsp;&nbsp;P: pendiente, se puede modificar y revisar
     * &nbsp;&nbsp;&nbsp;&nbsp;A: ya se realizó la reunión de aprobación, ya no se pueden modificar los datos ni las fechas/observaciones de revisión
     */
    String estado = "P" // P->pendiente, se puede modificar y revisar
    // A->ya se hizo la reunion de aprobacion, ya no se pueden modificar los datos ni las fechas/observaciones de revision

    /**
     * Path del documento de la oferta 1
     */
    String pathOferta1
    /**
     * Path del documento de la oferta 2
     */
    String pathOferta2
    /**
     * Path del documento de la oferta 3
     */
    String pathOferta3

    /**
     * Path del documento del cuadro comparativo
     */
    String pathCuadroComparativo
    /**
     * Path del documento del ánalisis de costos
     */
    String pathAnalisisCostos

    /**
     * Indica si se incluirá o no en la reunión de aprovación<br/>
     * &nbsp;&nbsp;&nbsp;&nbsp;S: sí
     */
    String incluirReunion

    /**
     * Path del documento de revisión por parte del asistente de gerencia Administrativa Financiera
     */
    String pathRevisionGAF
    /**
     * Path del documento de revisión por parte del asistente de gerencia Jurídica
     */
    String pathRevisionGJ
    /**
     * Path del documento de revisión por parte del asistente de gerencia de Dirección de proyectos
     * @deprecated se pidió la eliminación de este campo
     */
    @Deprecated
    String pathRevisionGDP

    /**
     * Fecha en la que se solicitó la inclusión en la reunión de aprovación
     */
    Date fechaPeticionReunion

    /**
     * El objeto aprobación ligado a la solicitud
     */
    Aprobacion aprobacion
    /**
     * Tipo de aprobacion (aprobada, negada, ...)
     */
    TipoAprobacion tipoAprobacion
    /**
     * Observaciones de la aprobación
     */
    String observacionesAprobacion
    /**
     * Path del documento de aprobación
     */
    String pathAprobacion

    /**
     * Comentarios al momento de agendar la reunión de aprobación
     */
    String revisionDireccionPlanificacionInversion
    /**
     * Asistentes a la reunión de aprobación
     */
    String asistentesAprobacion
    /**
     * Fecha en la cual el director requirente aprueba la solicitud para revision
     */
    Date fechaParaRevision

    /**
     * Define las relaciones uno a varios
     */
    static hasMany = [detallesMonto: DetalleMontoSolicitud]

    /**
     * Define los campos que se van a ignorar al momento de hacer logs
     */
    static auditable = [ignore: []]

    /**
     * Define el mapeo entre los campos del dominio y las columnas de la base de datos
     */
    static mapping = {
        table 'slct'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'slct__id'
        id generator: 'identity'
        version false
        columns {
            id column: 'slct__id'
            usuario column: 'prsn__id'
            unidadEjecutora column: 'unej__id'
            actividad column: 'mrlg__id'
            fecha column: 'slctfcha'
            observaciones column: 'slctobsr'
            revisadoAdministrativaFinanciera column: 'slctrvaf'
            revisadoJuridica column: 'slctrvgj'
            revisadoDireccionProyectos column: 'slctrvdp'
            observacionesAdministrativaFinanciera column: 'slctobaf'
            observacionesJuridica column: 'slctobgj'
            observacionesDireccionProyectos column: 'slctobdp'
            pathPdfTdr column: 'slct_tdr'

            montoSolicitado column: 'slctmnsl'
            tipoContrato column: 'tpcn__id'
            tipoBien column: 'tpbn__id'
            nombreProceso column: 'slctnmpr'
            objetoContrato column: 'slctobcn'
            objetoContrato type: 'text'
            formaPago column: 'slctfrpg'
            plazoEjecucion column: 'slctplej'

            estado column: 'slctetdo'

            pathOferta1 column: 'slctpto1'
            pathOferta2 column: 'slctpto2'
            pathOferta3 column: 'slctpto3'

            pathCuadroComparativo column: 'slctptcc'
            pathAnalisisCostos column: 'slctptac'

            incluirReunion column: 'slctinrn'

            pathRevisionGAF column: 'slctptr1'
            pathRevisionGJ column: 'slctptr2'
            pathRevisionGDP column: 'slctptr3'

            validadoAdministrativaFinanciera column: 'slctvlaf'
            validadoJuridica column: 'slctvljr'

            fechaPeticionReunion column: 'slctfcrn'

            aprobacion column: 'aprb__id'
            tipoAprobacion column: 'tpap__id'
            observacionesAprobacion column: 'slctobap'
            pathAprobacion column: 'slctptap'

            revisionDireccionPlanificacionInversion column: 'slctrdpi'
            revisionDireccionPlanificacionInversion type: "text"
            asistentesAprobacion column: "slctasap"

            fechaParaRevision column: 'slctfcpr'
        }
    }

    /**
     * Define las restricciones de cada uno de los campos
     */
    static constraints = {
        observaciones(blank: true, nullable: true, maxSize: 1023)
        revisadoAdministrativaFinanciera(blank: true, nullable: true)
        revisadoJuridica(blank: true, nullable: true)
        revisadoDireccionProyectos(blank: true, nullable: true)
        observacionesAdministrativaFinanciera(blank: true, nullable: true, maxSize: 1023)
        observacionesJuridica(blank: true, nullable: true, maxSize: 1023)
        observacionesDireccionProyectos(blank: true, nullable: true, maxSize: 1023)
        pathPdfTdr(blank: true, nullable: true, maxSize: 255)

        estado(blank: true, nullable: true, inList: ["P", "A"])

        pathOferta1(blank: true, nullable: true)
        pathOferta2(blank: true, nullable: true)
        pathOferta3(blank: true, nullable: true)

        pathCuadroComparativo(blank: true, nullable: true)
        pathAnalisisCostos(blank: true, nullable: true)

        incluirReunion(blank: true, nullable: true)

        pathRevisionGAF(blank: true, nullable: true)
        pathRevisionGJ(blank: true, nullable: true)
        pathRevisionGDP(blank: true, nullable: true)

        validadoAdministrativaFinanciera(blank: true, nullable: true)
        validadoJuridica(blank: true, nullable: true)

        fechaPeticionReunion(blank: true, nullable: true)

        aprobacion(blank: true, nullable: true)
        tipoAprobacion(blank: true, nullable: true)
        observacionesAprobacion(blank: true, nullable: true)
        pathAprobacion(blank: true, nullable: true)

        revisionDireccionPlanificacionInversion(blank: true, nullable: true)
        asistentesAprobacion(blank: true, nullable: true, maxSize: 1023)

        fechaParaRevision(blank: true, nullable: true)
    }
}
