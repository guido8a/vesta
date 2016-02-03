package vesta.avales

import vesta.hitos.AvanceFinanciero
import vesta.seguridad.Firma

/**
 * Clase para conectar con la tabla 'aval' de la base de datos
 */
class Aval {

    /**
     * Proceso del aval
     */
    ProcesoAval proceso
    /**
     * Concepto del aval
     */
    String concepto
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
     * Monto del aval
     */
    double monto
    /**
     * Monto de liberación del aval
     */
    double liberacion = 0
    /**
     * Estado del aval
     */
    EstadoAval estado
    /**
     * Número de memo de la petición del aval
     */
    String memo
    /**
     * Path del documento del aval
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
     * Número de contrato para la liberación
     */
    String contrato
//    int numero=0
    /**
     * Número del aval
     */
    String numero
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
        table 'aval'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'aval__id'
        id generator: 'identity'
        version false
        columns {
            id column: 'aval__id'
            proceso column: 'prco__id'
            fechaAprobacion column: 'avalfcap'
            fechaLiberacion column: 'avalfclb'
            fechaAnulacion column: 'avalfcan'
            monto column: 'avalmnto'
            liberacion column: 'avallbrc'
            estado column: 'edav__id'
            memo column: 'avalmemo'
            path column: 'avalpath'
            pathLiberacion column: 'avalphlb'
            pathAnulacion column: 'avalphan'
            contrato column: 'avalcntr'
            numero column: 'avalnmro'
            concepto column: 'avalcpto'
            certificacion column: 'avalcert'
            firma1 column: 'frmadire'
            firma2 column: 'frmagert'
            firmaAnulacion1 column: 'frmaanl1'
            firmaAnulacion2 column: 'frmaanl2'
        }
    }
    /**
     * Define las restricciones de cada uno de los campos
     */
    static constraints = {
        proceso(blank: false, nullable: false)
        fechaAprobacion(blank: true, nullable: true)
        fechaLiberacion(blank: true, nullable: true)
        fechaAnulacion(blank: true, nullable: true)
        estado(blank: false, nullable: false)
        memo(blank: true, nullable: true, size: 1..63)
        path(blank: true, nullable: true, size: 1..350)
        pathLiberacion(blank: true, nullable: true, size: 1..350)
        pathAnulacion(blank: true, nullable: true, size: 1..350)
        contrato(blank: true, nullable: true, size: 1..50)
        numero(blank: true, nullable: true, size: 1..10)
        concepto(blank: true, nullable: true, size: 1..500)
        certificacion(blank: true, nullable: true, size: 1..50)
        firma1(blank: true, nullable: true)
        firma2(blank: true, nullable: true)
        firmaAnulacion1(blank: true, nullable: true)
        firmaAnulacion2(blank: true, nullable: true)
    }

    def getColorSemaforo() {
        def dias = proceso.fechaFin - proceso.fechaInicio
        def fechaInicio = proceso.fechaInicio
        def fechaFin = proceso.fechaFin
//        println "dias "+dias
        def esperado = 0
        def now = new Date()
        if (now > fechaFin) {
            if (this.getAvanceFinanciero() < this.monto) {
                return [this.monto, this.getAvanceFinanciero(), "red", this.getUltimoAvance()]
            } else {
                return [this.monto, this.getAvanceFinanciero(), "green", this.getUltimoAvance()]
            }
        } else {
            if (now < fechaInicio) {
                return [0, this.getAvanceFinanciero(), "green", this.getUltimoAvance()]
            } else {
                esperado = this.monto * (now - fechaInicio) / dias
//                esperado=esperado*this.monto
                def verde = esperado * 0.75
                def naranja = esperado * 0.25
                def amarillo = esperado * 0.50
                def avance = this.getAvanceFinanciero()
                if (avance >= verde) {
                    return [esperado, this.getAvanceFinanciero(), "green", this.getUltimoAvance()]
                }
                if (avance >= amarillo) {
                    return [esperado, this.getAvanceFinanciero(), "yellow", this.getUltimoAvance()]
                }
                if (avance >= naranja) {
                    return [esperado, this.getAvanceFinanciero(), "orange", this.getUltimoAvance()]
                } else {
                    return [esperado, this.getAvanceFinanciero(), "red", this.getUltimoAvance()]
                }
            }
        }

    }

    def getAvanceFinanciero() {
        def avances = AvanceFinanciero.findAllByAval(this, [sort: "id"])
        if (avances.size() == 0) {
            return 0
        } else {
            return avances.pop().valor
        }
    }

    def getUltimoAvance() {
        def avances = AvanceFinanciero.findAllByAval(this, [sort: "id"])
        if (avances.size() == 0) {
            return null
        } else {
            return avances.pop()
        }
    }

    def getNumeroAval() {
        def n = this.numero ? this.numero.padLeft(3, '0') : '000'
        if (this.proceso.proyecto.codigo == "P.19") {
            return n + "A"
        } else {
            return n
        }
    }

    String toString() {
        "Solicitud de Aval para ${this.concepto}"
    }

}
