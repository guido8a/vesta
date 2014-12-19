package vesta.proyectos

import vesta.parametros.poaPac.Anio
import vesta.parametros.poaPac.Fuente
import vesta.parametros.poaPac.Mes
import vesta.parametros.poaPac.Presupuesto

/*El cronograma valorado se registra por actividades del marco lógico, por año, mes y fuente de financiamiento.*/
/**
 * Clase para conectar con la tabla 'crng' de la base de datos<br/>
 * El cronograma valorado se registra por actividades del marco lógico, por año, mes y fuente de financiamiento
 */
class Cronograma   {
    /**
     * Cronograma padre del cronograma actual
     */
    Cronograma cronograma
    /**
     * Mes del cronograma
     */
    Mes mes
    /**
     * Marco lógico del cronograma
     */
    MarcoLogico marcoLogico
    /**
     * Fuente del cronograma
     */
    Fuente fuente
    /**
     * Año del cronograma
     */
    Anio anio
    /**
     * Modificación del proyecto
     */
    ModificacionProyecto modificacionProyecto
    /**
     * Presupuesto del cronograma
     */
    Presupuesto presupuesto
    /**
     * Presupuesto 2 del cronograma
     */
    Presupuesto presupuesto2
    /**
     * Valor del cronograma
     */
    double valor
    /**
     * Valor 2 del cronograma
     */
    double valor2
    /**
     * Fecha de inicio
     */
    Date fechaInicio
    /**
     * Fecha de fin
     */
    Date fechaFin

    /**
     * Define los campos que se van a ignorar al momento de hacer logs
     */
    static auditable = [ignore: []]

    /**
     * Define el mapeo entre los campos del dominio y las columnas de la base de datos
     */
    static mapping = {
        table 'crng'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'crng__id'
        id generator: 'identity'
        version false
        columns {
            id column: 'crng__id'
            cronograma column: 'crngpdre'
            mes column: 'mess__id'
            marcoLogico column: 'mrlg__id'
            fuente column: 'fnte__id'
            anio column: 'anio__id'
            modificacionProyecto column: 'mdfc__id'
            presupuesto column: 'prsp__id'
            presupuesto2 column: 'prsp2_id'
            valor column: 'messvlor'
            valor2 column: 'mesvlor2'
            fechaInicio column: 'crngfcin'
            fechaFin column: 'crngfcfn'
        }
    }

    /**
     * Define las restricciones de cada uno de los campos
     */
    static constraints = {
        cronograma(blank: true, nullable: true, attributes: [mensaje: 'Cronograma original en el caso de haber modificaciones'])
        mes(blank: true, nullable: true, attributes: [mensaje: 'Mes'])
        marcoLogico(blank: true, nullable: true, attributes: [mensaje: 'Actividad del marco lógico'])
        fuente(blank: true, nullable: true, attributes: [mensaje: 'Fuente'])
        anio(blank: true, nullable: true, attributes: [mensaje: 'Año'])
        modificacionProyecto(blank: true, nullable: true, attributes: [mensaje: 'Modificación en base a la cual se crea el nuevo registro'])
        presupuesto(nullable: false, blank: false)
        presupuesto2(nullable: true, blank: true)
        valor(blank: true, nullable: true, attributes: [mensaje: 'Valor a ejecutarse en el mes'])
        valor2(blank: true, nullable: true, attributes: [mensaje: 'Valor a ejecutarse en el mes'])
        fechaInicio(blank: true, nullable: true, attributes: [mensaje: 'Fecha de inicio real de la actividad'])
        fechaFin(blank: true, nullable: true, attributes: [mensaje: 'Fecha de finalización real de la actividad'])
    }
}