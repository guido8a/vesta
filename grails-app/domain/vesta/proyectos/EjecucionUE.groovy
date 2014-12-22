package vesta.proyectos

import vesta.parametros.UnidadEjecutora
import vesta.parametros.poaPac.Fuente
import vesta.parametros.poaPac.Presupuesto
import vesta.parametros.poaPac.ProgramaPresupuestario

/**
 * Clase para conectar con la tabla 'ejun' de la base de datos
 */
class EjecucionUE   {
    /**
     * SIGEF
     */
    Sigef sigef
    /**
     * Presupuesto de la ejecución
     */
    Presupuesto presupuesto
    /**
     * Programa presupuestario de la ejecución
     */
    ProgramaPresupuestario programa
    /**
     * Fuente de la ejecución
     */
    Fuente fuente
    /**
     * Proyecto de la ejecución
     */
    Proyecto proyecto
    /**
     * Unidad ejecutora de la ejecución
     */
    UnidadEjecutora unidadEjecutora
    /**
     * Valor vigente de la ejecución
     */
    double vigente = 0
    /**
     * Valor comprometido de la ejecución
     */
    double comprometido = 0

    /**
     * Define los campos que se van a ignorar al momento de hacer logs
     */
    static auditable = [ignore: []]

    /**
     * Define el mapeo entre los campos del dominio y las columnas de la base de datos
     */
    static mapping = {
        table 'ejun'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'ejun__id'
        id generator: 'identity'
        version false
        columns {
            sigef column: 'sigf__id'
            presupuesto column: 'prsp__id'
            programa column: 'pgps__id'
            fuente column: 'fnte__id'
            proyecto column: 'proy__id'
            unidadEjecutora column: 'unej__id'
            vigente column: 'ejunvgnt'
            comprometido column: 'ejuncmps'
        }
    }

    /**
     * Define las restricciones de cada uno de los campos
     */
    static constraints = {
        vigente(nullable: false, blank: false)
        comprometido(nullable: false, blank: false)
    }
}