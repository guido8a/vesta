package vesta.proyectos

import vesta.parametros.UnidadEjecutora
import vesta.parametros.poaPac.Fuente
import vesta.parametros.poaPac.Presupuesto
import vesta.parametros.poaPac.ProgramaPresupuestario

/**
 * Clase para conectar con la tabla 'dtes' de la base de datos
 */
class DatosEsigef {
    /**
     * Programa presupuestario de los datos Esigef
     */
    ProgramaPresupuestario programa
    /**
     * Fuente de los datos Esigef
     */
    Fuente fuente
    /**
     * Presupuesto de los datos Esigef
     */
    Presupuesto presupuesto
    /**
     * Valor vigente
     */
    double vigente
    /**
     * Valor comprometido
     */
    double comprometido
    /**
     * Unidad ejecutora de los datos Esigef
     */
    UnidadEjecutora unidad
    /**
     * Fecha
     */
    Date fecha
    /**
     * Errores
     */
    String errores

    /**
     * Define los campos que se van a ignorar al momento de hacer logs
     */
    static auditable = [ignore: []]

    /**
     * Define el mapeo entre los campos del dominio y las columnas de la base de datos
     */
    static mapping = {
        table 'dtes'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'dtes__id'
        id generator: 'identity'
        version false
        columns {
            id column: 'dtes__id'
            programa column: 'pgps__id'
            fuente column: 'fnte__id'
            presupuesto column: 'prsp__id'
            vigente column: 'dtesvgnt'
            comprometido column: 'dtescomp'
            unidad column: 'unej__id'
            errores column: 'dteserror'
            fecha column: 'dtesfcha'
        }
    }

    /**
     * Define las restricciones de cada uno de los campos
     */
    static constraints = {
        errores(size: 1..255, blank: true, nullable: true)
        fuente(nullable: true, blank: true)
        programa(nullable: true, blank: true)
        presupuesto(nullable: true, blank: true)
    }

    /**
     * Genera un string para mostrar
     * @return el programa, la fuente, el presupuesto, el valor vigente, el valor comprometido, la fecha concatenados
     */
    String toString() {
        return "" + this.programa + " " + this.fuente + " " + this.presupuesto + " " + this.vigente + " " + this.comprometido + " " + this.fecha
    }

}
