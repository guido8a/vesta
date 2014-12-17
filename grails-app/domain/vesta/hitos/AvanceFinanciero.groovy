package vesta.hitos

import yachay.avales.Aval
import yachay.avales.ProcesoAval

class AvanceFinanciero {

    /*
    * Proceso al que pertenece
    */
    ProcesoAval proceso
    /*
    * aval al que pertenece
    */
    Aval aval
    /*
    * Número de contrato
    */
    String contrato
    /*
    * Certificado presupuestario
    */
    String certificado
    /*
    * Monto del contrato
    */
    Double monto = 0
    /*
    * valor Devengado
    */
    Double valor = 0
    /*
    * Fecha de registro
    */
    Date fecha
    /*
    * Observaciones
    */
    String observaciones

    /**
     * Define el mapeo entre los campos del dominio y las columnas de la base de datos
     */
    static mapping = {
        table 'avfi'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'avfi__id'
        id generator: 'identity'
        version false
        columns {
            id column: 'avfi__id'
            fecha column: 'avfifcha'
            proceso column: 'prco__id'
            contrato column: 'avficnto'
            monto column: 'avfimnto'
            valor column: 'avfivlor'
            observaciones column: 'avfiobsr'
            certificado column: 'avficrtf'
            aval column: 'aval__id'
        }
    }
/**
 * Define las restricciones de cada uno de los campos
 */
    static constraints = {
        proceso(nullable: true,blank:true)
        observaciones(blank: true,nullable: true,size: 1..1024)
        contrato(blank: false,nullable: false,size: 1..30)
        certificado(blank: true,nullable: true,size: 1..30)
        aval(nullable: true,blank:true)
    }

    String toString(){
        return "${this.fecha.format('dd/MM/yyyy')}, Devengado: ${this.valor.round(2)}"
    }
}
