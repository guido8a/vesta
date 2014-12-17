package vesta.avales

import yachay.hitos.AvanceAvance
import yachay.hitos.AvanceFisico
import yachay.proyectos.Proyecto

/**
 * Clase para conectar con la tabla 'alertas' de la base de datos
 */
class ProcesoAval {
    /**
     * Proyecto del proceso
     */
    Proyecto proyecto
    /**
     * Nombre del proceso
     */
    String nombre
    /**
     * Fecha de inicio del proceso
     */
    Date fechaInicio
    /**
     * Fecha fin del proceso
     */
    Date fechaFin
    /*
    * Número de dias cada cuanto se debe informar
    */
    int informar = 0

    /**
     * Define el mapeo entre los campos del dominio y las columnas de la base de datos
     */
    static mapping = {
        table 'prco'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'prco__id'
        id generator: 'identity'
        version false
        columns {
            id column: 'prco__id'
            proyecto column: 'proy__id'
            nombre column: 'prconmbr'
            fechaInicio column: 'prcofcin'
            fechaFin column: 'prcofcfn'
            informar column: 'prcoinfm'
        }
    }

    /**
     * Define las restricciones de cada uno de los campos
     */
    static constraints = {
        nombre(size: 1..255, blank: false, nullable: false)
    }

    /**
     * Calcula el monto total del proceso sumando todas las asignaciones
     * @return el monto calculado
     */
    def getMonto() {
        def detalles = ProcesoAsignacion.findAllByProceso(this)
        def monto = 0
        detalles.each {
            monto += it.monto
        }
        return monto
    }

    def getAvanceFisico() {
        def avance = 0
        AvanceFisico.findAllByProceso(this).each { avf ->
            def avs = AvanceAvance.findAllByAvanceFisico(avf, [sort: "id"])
            if (avs.size() > 0) {
                avance += avf.avance * avs.pop().avance / 100
            }

        }
        return avance
    }

    def getUltimoAvance() {
        def av = AvanceFisico.findAllByProceso(this)
        if (!av) {
            return null
        }
        def avances = AvanceAvance.findAllByAvanceFisicoInList(av, [sort: "id"])
        if (avances.size() > 0) {
            return avances.pop()
        } else {
            return null
        }
    }

    def getColorSemaforo() {
        def dias = fechaFin - fechaInicio
        println "dias " + dias
        def esperado = 0
        def now = new Date()
        if (now > fechaFin) {
            if (this.getAvanceFisico() < 100) {
                return [100, this.getAvanceFisico(), "red", this.getUltimoAvance()]
            } else {
                return [100, this.getAvanceFisico(), "green", this.getUltimoAvance()]
            }
        } else {
            if (now < fechaInicio)
                return [0, this.getAvanceFisico(), "green", this.getUltimoAvance()]
            else {
                esperado = 100 * (now - fechaInicio) / dias
                def verde = esperado * 0.8
                def amarillo = esperado * 0.5
                def avance = this.getAvanceFisico()
                if (avance >= verde)
                    return [esperado, this.getAvanceFisico(), "green", this.getUltimoAvance()]
                if (avance >= amarillo)
                    return [esperado, this.getAvanceFisico(), "yellow", this.getUltimoAvance()]
                else
                    return [esperado, this.getAvanceFisico(), "red", this.getUltimoAvance()]
            }
        }
    }

    def getAvanceFisicoAl(Date fecha) {
        def avance = 0
        def av = AvanceFisico.withCriteria {
            eq("proceso", this)
            le("fecha", fecha)
        }
        av.each { avf ->
            def avs = AvanceAvance.findAllByAvanceFisico(avf, [sort: "id"])
            if (avs.size() > 0) {
                avance += avf.avance * avs.pop().avance / 100
            }

        }
        return avance
    }

    def getAvanceAl(Date fecha) {
        def av = AvanceFisico.findAllByProceso(this)
        if (!av) {
            return null
        }
//        def avances = AvanceAvance.findAllByAvanceFisicoInList(av, [sort: "id"])
        def avances = AvanceAvance.withCriteria {
            inList("avanceFisico", av)
            le("fecha", fecha)
        }
        if (avances.size() > 0) {
            return avances.pop()
        } else {
            return null
        }
    }

    def getColorSemaforoAl(Date fecha) {
        def dias = fechaFin - fechaInicio
        println "dias " + dias
        def esperado = 0
        def now = fecha
        if (now > fechaFin) {
            if (this.getAvanceFisicoAl(fecha) < 100) {
                return [100, this.getAvanceFisicoAl(fecha), "red", this.getAvanceAl(fecha)]
            } else {
                return [100, this.getAvanceFisicoAl(fecha), "green", this.getAvanceAl(fecha)]
            }
        } else {
            if (now < fechaInicio)
                return [0, this.getAvanceFisicoAl(fecha), "green", this.getAvanceAl(fecha)]
            else {
                esperado = 100 * (now - fechaInicio) / dias
                def verde = esperado * 0.8
                def amarillo = esperado * 0.5
                def avance = this.getAvanceFisicoAl(fecha)
                if (avance >= verde)
                    return [esperado, this.getAvanceFisicoAl(fecha), "green", this.getAvanceAl(fecha)]
                if (avance >= amarillo)
                    return [esperado, this.getAvanceFisicoAl(fecha), "yellow", this.getAvanceAl(fecha)]
                else
                    return [esperado, this.getAvanceFisicoAl(fecha), "red", this.getAvanceAl(fecha)]
            }
        }
    }
}
