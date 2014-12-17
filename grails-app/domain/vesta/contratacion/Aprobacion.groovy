package vesta.contratacion

import vesta.seguridad.Usro

/**
 * Clase para conectar con la tabla 'aprb' de la base de datos<br/>
 * Reunión de aprobación: puede tener una o varias solicitudes ligadas
 */
class Aprobacion {

    /**
     * Fecha planificada para la reunion
     */
    Date fecha
    /**
     * Fecha de realizacion de la reunion
     */
    Date fechaRealizacion
    /**
     * Observaciones de la aprobación
     */
    String observaciones
    /**
     * Path del documento de aprobación
     */
    String pathPdf
    /**
     * Asistentes a la reunión de aprobación
     */
    String asistentes
    /**
     * Número de reunión de aprobación (secuencial generado al empezar una reunión y no al agendar)
     */
    String numero

    /**
     * Indica si ya se aprobó la reunión de aprobación. Una vez este estado esté en A ya no se podrán modificar los datos
     */
    String aprobada

    /**
     * El usuario logueado al momento de la creación de la aprobación
     */
    Usro creadoPor
    /**
     * La firma de gerencia de planif
     */
    Usro firmaGerenciaPlanificacion
    /**
     * La firma de direccion de planif
     */
    Usro firmaDireccionPlanificacion
    /**
     * La firma de gerencia técnica
     */
    Usro firmaGerenciaTecnica

    /**
     * Define las relaciones uno a varios
     */
    static hasMany = [solicitudes: Solicitud]

    /**
     * Define los campos que se van a ignorar al momento de hacer logs
     */
    static auditable = [ignore: []]

    /**
     * Define el mapeo entre los campos del dominio y las columnas de la base de datos
     */
    static mapping = {
        table 'aprb'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'aprb__id'
        id generator: 'identity'
        version false
        columns {
            id column: 'aprb__id'
            fecha column: 'aprbfcha'
            fechaRealizacion column: 'aprbfcrl'
            observaciones column: 'aprbobsr'
            pathPdf column: 'aprb_pdf'
            asistentes column: 'aprbasst'
            numero column: 'aprbnmro'
            aprobada column: 'aprbaprb'
            creadoPor column: 'user__id'
            firmaDireccionPlanificacion column: 'userfrdp'
            firmaGerenciaPlanificacion column: 'userfrgp'
            firmaGerenciaTecnica column: 'userfrgt'
        }
    }

    /**
     * Define las restricciones de cada uno de los campos
     */
    static constraints = {
        fecha(blank: true, nullable: true)
        fechaRealizacion(blank: true, nullable: true)
        observaciones(blank: true, nullable: true, maxSize: 1023)
        asistentes(blank: true, nullable: true, maxSize: 1023)
        pathPdf(blank: true, nullable: true, maxSize: 255)
        numero(blank: true, nullable: true)
        aprobada(blank: true, nullable: true)
        creadoPor(blank: true, nullable: true)
        firmaDireccionPlanificacion(blank: true, nullable: true)
        firmaGerenciaTecnica(blank: true, nullable: true)
        firmaGerenciaPlanificacion(blank: true, nullable: true)
    }
}
