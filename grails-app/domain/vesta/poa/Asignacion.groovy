package vesta.poa

import vesta.avales.DistribucionAsignacion
import vesta.avales.ProcesoAsignacion
import vesta.parametros.TipoGasto
import vesta.parametros.UnidadEjecutora
import vesta.parametros.poaPac.Anio
import vesta.parametros.poaPac.Fuente
import vesta.parametros.poaPac.Presupuesto
import vesta.parametros.poaPac.ProgramaPresupuestario
import vesta.poaCorrientes.Tarea
import vesta.proyectos.MarcoLogico
import vesta.proyectos.ModificacionAsignacion

/**
 * Clase para conectar con la tabla 'asgn' de la base de datos
 */
class Asignacion {
    /**
     * Año de la asignación
     */
    Anio anio
    /**
     * Fuente de la asignación
     */
    Fuente fuente
    /**
     * Marco lógico de la asignación
     */
    MarcoLogico marcoLogico
    /**
     * Actividad de la asignación
     */
    String actividad
    /**
     * Presupuesto de la asignación
     */
    Presupuesto presupuesto
    /**
     * Tipo de gasto de la asignación
     */
    TipoGasto tipoGasto
    /**
     * Componente de la asignación
     */
    Componente componente
    /**
     * Valor planificado de la asignación
     */
    double planificado
    /**
     * Valor de la redistribución de la asignación
     */
    double redistribucion = 0
    /**
     * Valor priorizado de la asignación
     */
    double priorizado = 0
    /**
     * Unidad ejecutora de la asignación
     */
    UnidadEjecutora unidad
    /**
     * Indica si está o no reubicada (S o N respectivamente)
     */
    String reubicada = "N"
    /**
     * Programa presupuestario de la asignación
     */
    ProgramaPresupuestario programa
    /**
     * Asignación padre de la asignación actual
     */
    Asignacion padre
    /**
     * Meta de la asignación
     */
    String meta
    /**
     * Indicador de la asignación
     */
    String indicador
    /**
     * Valor priorizado original
     */
    Double priorizadoOriginal = 0

    /**
     * Tarea para el poa corrientes
     */
    Tarea tarea

    /**
     * Define los campos que se van a ignorar al momento de hacer logs
     */
    static auditable = [ignore: []]

    /**
     * Define el mapeo entre los campos del dominio y las columnas de la base de datos
     */
    static mapping = {
        table 'asgn'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'asgn__id'
        id generator: 'identity'
        version false
        columns {
            id column: 'asgn__id'
            anio column: 'anio__id'
            fuente column: 'fnte__id'
            marcoLogico column: 'mrlg__id'
            actividad column: 'asgnactv'
            presupuesto column: 'prsp__id'
            tipoGasto column: 'tpgs__id'
            componente column: 'comp__id'
            planificado column: 'asgnplan'
            redistribucion column: 'asgnrdst'
            unidad column: 'unej__id'
            reubicada column: 'asgnrubi'
            programa column: 'pgps__id'
            padre column: 'asgnpdre'
            meta column: 'asgnmeta'
            indicador column: 'asgnindi'
            priorizado column: 'asgnprio'
            priorizadoOriginal column: 'asgnpror'

            tarea column: 'trea__id'
        }
    }

    /**
     * Define las restricciones de cada uno de los campos
     */
    static constraints = {
        anio(blank: true, nullable: true, attributes: [mensaje: 'Año o “ejercicio”'])
        fuente(blank: true, nullable: true, attributes: [mensaje: 'Fuente de financiamiento'])
        marcoLogico(blank: true, nullable: true, attributes: [mensaje: 'Actividad del marco lógico'])
        actividad(blank: true, nullable: true, size: 1..1024, attributes: [mensaje: 'Actividad de gasto corriente'])
        presupuesto(blank: true, nullable: true, attributes: [mensaje: 'Partida presupuestaria'])
        tipoGasto(blank: true, nullable: true, attributes: [mensaje: 'Tipo de gasto o grupo de gasto'])
        componente(nullable: true, blank: true)
        planificado(blank: true, nullable: true, attributes: [mensaje: 'Planificado'])
        redistribucion(blank: true, nullable: true, attributes: [mensaje: 'redistribuido (en + o en – según aumente o disminuya la asignación), lo asignado_real = valor_asignado + redistribuido.'])
        unidad(blank: true, nullable: true)
        reubicada(blank: true, nullable: true, size: 1..2)
        programa(nullable: true, blank: true)
        meta(nullable: true, blank: true, size: 1..255)
        indicador(nullable: true, blank: true, size: 1..255)

        tarea(nullable: true, blank: true)
    }

    /**
     * Genera un string para mostrar
     * @return si la asignación tiene marco lógico: el responsable, el monto, el presupuesto, el año concatenados<br/>
     * caso contrario, el monto, el presupuesto, el año concatenados
     */
    String toString() {
        if (this.marcoLogico) {
//            "<b>Responsable:</b> ${this.unidad}<b>  Priorizado: </b>${this.planificado}  <b> Partida Presupuestaria: </b>${this.presupuesto}<b> Año</b>: ${this.anio}"
            "<b>Priorizado: </b>${this.planificado}  <b> Partida Presupuestaria: </b>${this.presupuesto}"
        } else {
            "<b> Priorizado:</b> ${this.planificado}  <b> Partida Presupuestaria: </b>${this.presupuesto}<b> Año</b>: ${this.anio}"
        }
    }

    String getString() {
        if (this.marcoLogico) {
//            "<b>Responsable:</b> ${this.unidad}<b>  Priorizado: </b>${this.planificado}  <b> Partida Presupuestaria: </b>${this.presupuesto}<b> Año</b>: ${this.anio}"
            "<b>Priorizado: </b>${this.priorizado}  <b> Partida Presupuestaria: </b>${this.presupuesto}"
        } else {
            "<b> Priorizado:</b> ${this.priorizado}  <b> Partida Presupuestaria: </b>${this.presupuesto}<b> Año</b>: ${this.anio}"
        }
    }

    /**
     * Calcula el valor real de la asignación teniendo en cuenta la reubicación
     * @return el valor real calculado
     */
    def getValorReal() {
        if (this.reubicada == "S") {
            if (this.planificado == 0) {
                return this.planificado
            }
//            println "ASIGNACION this --> "+this.id+" val "+this.planificado
            def dist = DistribucionAsignacion.findAllByAsignacion(this)

//            def valor = getValorSinModificacion(this)
            def valor = this.planificado
//            println "valor inicial "+valor
            Asignacion.findAllByPadreAndUnidadNotEqual(this, this.marcoLogico.proyecto.unidadEjecutora, [sort: "id"]).each { hd ->
//                println "hijo directo ------------------>  "+hd.id+" sumando "+hd.planificado
                valor += getValorHijo(hd)
            }
//            println "valor hijos "+valor
//            def vs = getValorSinModificacion(this)
            def vs = 0
            def mas = ModificacionAsignacion.findAllByDesde(this)
            def menos = ModificacionAsignacion.findAllByRecibe(this)

            mas.each {
//                println "asignacion ${this.id} tienen modificaciones 1 ${it.id}"


                if (it.recibe?.padre?.id == it.desde.id) {
//                    println "sumo"
                    vs += it.valor
                }
//                else
//                    println "no sumo"


            }
//            menos.each {
//                println "asignacion ${this.id} tienen modificaciones 2 ${it.id}"
//
//                    vs-=it.valor
//                    println "resto"
//
//
//            }
//            println "valor de la original sin mods "+vs
//
//            println "valor total "+(valor+vs)
            valor += vs
            dist.each {
//                println "restando distribucion "+it.id+" -->  "+it.valor
                valor = valor - it.valor
            }
//            println "valor "+valor
//            println "-------------------------------"

            if (valor > this.planificado) {
                valor = this.planificado
            }
            if (valor < 0) {
                valor = 0
            }

            return valor
        } else {
            return this.planificado
        }

    }

    /**
     * Calcula el valor real de la asignación teniendo en cuenta la reubicación
     * @return el valor real calculado
     */
    def getValorPriorizado() {
        if (this.reubicada == "S") {
            if (this.priorizado == 0) {
                return this.priorizado
            }
            def dist = DistribucionAsignacion.findAllByAsignacion(this)
            def valor = this.priorizado
            Asignacion.findAllByPadreAndUnidadNotEqual(this, this.marcoLogico.proyecto.unidadEjecutora, [sort: "id"]).each { hd ->
                valor += getValorHijo(hd)
            }
            def vs = 0
            def mas = ModificacionAsignacion.findAllByDesde(this)
            def menos = ModificacionAsignacion.findAllByRecibe(this)

            mas.each {
                if (it.recibe?.padre?.id == it.desde.id) {
                    vs += it.valor
                }
            }
            valor += vs
            dist.each {
                valor = valor - it.valor
            }
            if (valor > this.priorizado) {
                valor = this.priorizado
            }
            if (valor < 0) {
                valor = 0
            }
            return valor
        } else {
            return this.priorizado
        }
    }

    /**
     * Calcula el valor de los hijos de la asignación
     * @param asg asignación
     * @return el valor de los hijos
     */
    def getValorHijo(asg) {
        // println "get valor hijo "+asg.id
        def hijos = Asignacion.findAllByPadre(asg)
        //println "hijos "+hijos
        def val = 0
        hijos.each {
            val += getValorHijo(it)
        }
        // println "return "+(val+asg.planificado)
        val = val + getValorSinModificacion(asg)
//        println "valor hijo "+asg.id+"  --> "+val
//        println ""
        return val
    }

    /**
     * Calcula el valor de la asignación sin modificaciones
     * @param asg la asignación
     * @return el valor calculado sin modificaciones
     */
    def getValorSinModificacion(asg) {

        def valor = asg.planificado
        def mas = ModificacionAsignacion.findAllByDesde(asg)
        def menos = ModificacionAsignacion.findAllByRecibe(asg)

        mas.each {
//            println "asignacion ${asg.id} tienen modificaciones 1 ${it.id}"


            if (it.recibe?.padre?.id != it.desde.id) {
//                println "sumo"
                valor += it.valor
            }
//
//            }else
//                println "no sumo"


        }
        menos.each {
//            println "asignacion ${asg.id} tienen modificaciones 2 ${it.id}"

            if (it.recibe?.padre?.id != it.desde.id && it.desde?.padre?.id != it.recibe.id) {
                valor -= it.valor
            }
//                println "resto"
//            }else
//                println "no sumo"


        }

//        println "valor mods  "+asg.id+"  --> "+valor

        return valor
    }

    def getAvanceFisico() {
        println "-->Asignacion!!!"
        def avance = 0
        if (this.priorizado == 0) {
            return 0
        }
        ProcesoAsignacion.findAllByAsignacion(this).each { pa ->
            def representacion = pa.monto * 100 / this.priorizado
            println "a " + this.id + " priorizado  " + this.priorizado + " representacion " + representacion
            def avp = pa.proceso.getAvanceFisico()
            println "avance proceso " + pa.proceso.nombre + "  " + avp
            avance += representacion * avp / 100
        }
        println "return " + avance
        return avance
    }
}