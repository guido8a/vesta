package vesta.modificaciones

import yachay.parametros.poaPac.Anio
import yachay.parametros.poaPac.Fuente
import yachay.parametros.poaPac.Presupuesto
import yachay.poa.Asignacion
import yachay.proyectos.MarcoLogico
import yachay.seguridad.Firma
import yachay.seguridad.Usro

/**
 * Clase para conectar con la tabla 'slma' de la base de datos
 */
class SolicitudModPoa {

    /**
     * Fecha de solicitud
     */
    Date fecha = new Date()
    /**
     * Fecha de revision
     */
    Date fechaRevision

    /**
     * Asignación de origen
     */
    Asignacion origen

    /**
     * Asignación destino
     */
    Asignacion destino

    /**
     * Año de la asignación nueva
     */
    Anio anio
    /**
     * Fuente de la asignación nueva
     */
    Fuente fuente
    /**
     * Marco lógico de la asignación nueva
     */
    MarcoLogico marcoLogico

    /**
     * Presupuesto de la asignación nueva
     */
    Presupuesto presupuesto

    /**
     * Valor planificado de la asignación
     */
    double valor=0
    /**
     * concepto de la solicitud
     */
    String concepto

    /*
    * Estado de la solicitud 0--> solicitado, 1--> aprobado, 2--> negado 3--> ejecutado 4-->solicitado sin firma 5-->Aprobado sin firma
    * */
    int estado = 0
    /*
    * Usuario que crea la solicitud
     */
    Usro usuario
    /*
   * usuario que revisa la solicitud
    */
    Usro revisor
    /*
    * Tipo de la solicitud R-> reasignacion, N-> nueva asignacion, D-> derivada, E-> Eliminar
     */
    String tipo
    /*
    * Observaciones
     */
    String observaciones
    /*
    * Nombre de la actividad en caso de crear una nueva
    */
    String actividad
    /*
    * Fecha de inicio
     */
    Date inicio
    /*
    * Fecha de fin
     */
    Date fin
    /*
    * Valor de la asignación de origen al momento de ejecutar la modificación
     */
    double valorOrigen = 0
    /*
    * Valor de la asignación de destino al momento de ejecutar la modificación
     */
    double valorDestino = 0
    /*
   * Valor de la asignación de origen al momento de ejecutar la modificación
    */
    double valorOrigenSolicitado = 0
    /*
    * Valor de la asignación de destino al momento de ejecutar la modificación
     */
    double valorDestinoSolicitado = 0
    /*
    * Firma de revision de la solicitud
    */
    Firma firmaSol
    /*
    * Firnma de aprobacion 1
    */
    Firma firma1
    /*
  * Firnma de aprobacion 2
  */
    Firma firma2

    static mapping = {
        table 'slma'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'slma__id'
        id generator: 'identity'
        version false
        columns {
            id column: 'slma__id'
            fecha column: 'slmafcha'
            fechaRevision column: 'slmafcrv'
            origen column: 'asgnorgn'
            destino column: 'asgndstn'
            anio column: 'anio__id'
            fuente column: 'fnte__id'
            marcoLogico column: 'mrlg__id'
            presupuesto column: 'prsp__id'
            valor column: 'slmavlor'
            concepto column: 'slmacpto'
            estado column: 'slmaetdo'
            usuario column: 'usro__id'
            revisor column: 'usrorvid'
            tipo column: 'slmatipo'
            observaciones column: 'slmaobsr'
            actividad column: 'slmaactv'
            inicio column: 'slmafcin'
            fin column: 'slmafcfn'
            valorOrigen column: 'slmavlog'
            valorDestino column: 'slmavlds'
            valorOrigenSolicitado column: 'slmavogs'
            valorDestinoSolicitado column: 'slmavdss'
            firmaSol column: 'frmaslid'
            firma1 column: 'frma1_id'
            firma2 column: 'frma2_id'
        }
    }

        static constraints = {
            fechaRevision(blank:true,nullable: true)
            origen(blank:false,nullable: false)
            destino(blank:true,nullable: true)
            anio(blank:true,nullable: true)
            fuente(blank:true,nullable: true)
            marcoLogico(blank:true,nullable: true)
            presupuesto(blank:true,nullable: true)
            valor(blank:false,nullable: false)
            concepto(blank:false,nullable: false,size:1..1024)
            estado(blank:false,nullable: false)
            usuario(blank:false,nullable: false)
            revisor(blank:true,nullable: true)
            tipo(blank: false,nullable: false,size: 1..1)
            observaciones(blank: true,nullable: true,size: 1..1024)
            actividad(blank: true,nullable: true,size: 1..1024)
            inicio(blank:true,nullable: true)
            fin(blank:true,nullable: true)
            firmaSol(blank:true,nullable: true)
            firma1(blank:true,nullable: true)
            firma2(blank:true,nullable: true)
        }
    }
