package vesta.proyectos

import vesta.parametros.poaPac.Anio
import vesta.parametros.poaPac.Fuente

/*Financiamiento del proyecto por fuente y año*/
/**
 * Clase para conectar con la tabla 'fina' de la base de datos<br/>
 * Financiamiento del proyecto por fuente y año
 */
class Financiamiento   {
    /**
     * Año del financiamiento
     */
    Anio anio
    /**
     * Fuente del financiamiento
     */
    Fuente fuente
    /**
     * Proyecto del financiamiento
     */
    Proyecto proyecto
    /**
     * Monto del financiamiento
     */
    double monto

    /**
     * Define los campos que se van a ignorar al momento de hacer logs
     */
    static auditable = [ignore: []]

    /**
     * Define el mapeo entre los campos del dominio y las columnas de la base de datos
     */
    static mapping = {
        table 'fina'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'fina__id'
        id generator: 'identity'
        version false
        columns {
            id column: 'fina__id'
            anio column: 'anio__id'
            fuente column: 'fnte__id'
            proyecto column: 'proy__id'
            monto column: 'finamnto'
        }
    }

    /**
     * Define las restricciones de cada uno de los campos
     */
    static constraints = {
        anio(blank: true, nullable: true, attributes: [mensaje: 'Año'])
        fuente(blank: true, nullable: true, attributes: [mensaje: 'Fuente'])
        proyecto(blank: true, nullable: true, attributes: [mensaje: 'Proyecto'])
        monto(blank: false, attributes: [mensaje: 'Monto del financiamiento'])
    }
}