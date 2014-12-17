package vesta.hitos

import vesta.avales.ProcesoAval

class AvanceFisico {

    /*
    * Proceso
    */
    ProcesoAval proceso
    /*
    * Fecha de registro
    */
    Date fecha = new Date()
    /*
    * Avance
    */
    Double avance = 0
    /*
   * Observaciones
   */
    String observaciones
    /*
    * Fecha en la que se completo la actividad
    */
    Date completado
    /*
    * Fecha de inicio planificada
    */
    Date inicio
    /*
    * Fecha de fin planificada
    */
    Date fin

    /**
     * Define el mapeo entre los campos del dominio y las columnas de la base de datos
     */
    static mapping = {
        table 'avfs'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'avfs__id'
        id generator: 'identity'
        version false
        columns {
            id column: 'avfs__id'
            fecha column: 'avfsfcha'
            proceso column: 'prco__id'
            avance column: 'avfsavnc'
            observaciones column: 'avfsobsv'
            completado column: 'avfsfccm'
            inicio column: 'avfsfcin'
            fin column: 'avfsfcfn'
        }
    }
/**
 * Define las restricciones de cada uno de los campos
 */
    static constraints = {
        proceso(nullable: false, blank: false)
        observaciones(blank: true, nullable: true, size: 1..1024)
        completado(blank: true, nullable: true)
        inicio(blank: true, nullable: true)
        fin(blank: true, nullable: true)
    }

    def getAvanceFisico() {
        def completado = 0
        def avances = AvanceAvance.findAllByAvanceFisico(this, [sort: "id"])
        if (avances.size() > 0) {
            return avances.pop().avance
        } else {
            return 0
        }
    }

    def getColorSemaforo() {
        def dias = fin - inicio
        println "dias " + dias
        def esperado = 0
        def now = new Date()
        if (now > fin) {
            if (this.getAvanceFisico() < 100) {
                return [100, this.getAvanceFisico(), "red"]
            } else {
                return [100, this.getAvanceFisico(), "green"]
            }
        } else {
            if (now < inicio)
                return [0, this.getAvanceFisico(), "green"]
            else {
                esperado = 100 * (now - inicio) / dias
                def verde = esperado * 0.8
                def amarillo = esperado * 0.5
                def avance = this.getAvanceFisico()
                if (avance >= verde)
                    return [esperado, this.getAvanceFisico(), "green"]
                if (avance >= amarillo)
                    return [esperado, this.getAvanceFisico(), "yellow"]
                else
                    return [esperado, this.getAvanceFisico(), "red"]
            }
        }
    }

    def getAvanceFisicoAl(Date fecha) {
        def completado = 0
//        def avances = AvanceAvance.findAllByAvanceFisico(this, [sort: "id"])
        def avances = AvanceAvance.withCriteria {
            eq("avanceFisico", this)
            le("fecha", fecha)
        }
        if (avances.size() > 0) {
            return avances.pop().avance
        } else {
            return 0
        }
    }

    def getColorSemaforoAl(Date fecha) {
        def dias = fin - inicio
        println "dias " + dias
        def esperado = 0
        def now = fecha
        if (now > fin) {
            if (this.getAvanceFisicoAl(fecha) < 100) {
                return [100, this.getAvanceFisicoAl(fecha), "red"]
            } else {
                return [100, this.getAvanceFisicoAl(fecha), "green"]
            }
        } else {
            if (now < inicio)
                return [0, this.getAvanceFisicoAl(fecha), "green"]
            else {
                esperado = 100 * (now - inicio) / dias
                def verde = esperado * 0.8
                def amarillo = esperado * 0.5
                def avance = this.getAvanceFisicoAl(fecha)
                if (avance >= verde)
                    return [esperado, this.getAvanceFisicoAl(fecha), "green"]
                if (avance >= amarillo)
                    return [esperado, this.getAvanceFisicoAl(fecha), "yellow"]
                else
                    return [esperado, this.getAvanceFisicoAl(fecha), "red"]
            }
        }
    }
}
