package vesta.avales

import vesta.parametros.UnidadEjecutora
import vesta.poa.Asignacion

/**
 * Clase para conectar con la tabla 'dsas' de la base de datos
 */
class DistribucionAsignacion {

    /**
     * Asignación de la distribución
     */
    Asignacion asignacion
    /**
     * Valor de la distribución
     */
    double valor = 0
    /**
     * Unidad Ejecutora de la distribución
     */
    UnidadEjecutora unidadEjecutora

    /**
     * Define los campos que se van a ignorar al momento de hacer logs
     */
    static auditable = [ignore: []]

    /**
     * Define el mapeo entre los campos del dominio y las columnas de la base de datos
     */
    static mapping = {
        table 'dsas'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'dsas__id'
        id generator: 'identity'
        version false
        columns {
            id column: 'dsas__id'
            asignacion column: 'asgn__id'
            valor column: 'dsasvlor'
            unidadEjecutora column: 'unej__id'
        }
    }

    /**
     * Define las restricciones de cada uno de los campos
     */
    static constraints = {

    }

    /**
     * Genera un string para mostrar
     * @return la unidad ejecutora y el valor concatenados
     */
    String toString() {
        "${this.unidadEjecutora} ${this.valor}"
    }

    /**
     * Retorna el valor real de la asignación teniendo en cuenta la reubicación
     * @return el valor real
     */
    def getValorReal() {
        def hijos = Asignacion.findAllByPadreAndUnidad(this.asignacion, this.unidadEjecutora)
        // println " asgn  "+this.asignacion.id
        def val = 0
        hijos.each {
            val += getValorHijo(it)
        }
        return this.valor - val

    }

    /**
     * Retorna el valor de los hijos de la asignación
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
        return val + asg.planificado
    }
}
