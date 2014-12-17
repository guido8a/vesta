package vesta.proyectos

import yachay.poa.Asignacion

/*Ejecución de la asignación presupuestaria.*/
/**
 * Clase para conectar con la tabla 'ejec' de la base de datos
 */
class Ejecucion implements Serializable {
    /**
     * Asignación de la ejecución
     */
    Asignacion asignacion
    /**
     * SIGEF
     */
    Sigef sigef
    /**
     * Valor vigente de la ejecución
     */
    double vigente = 0
    /**
     * Valor de compromiso de la ejecución
     */
    double compromiso = 0
    /**
     * Valor devengado de la ejecución
     */
    double devengado = 0
    /**
     * Valor pagado de la ejecución
     */
    double pagado = 0
    /**
     * Saldo de presupuesto de la ejecución
     */
    double saldoPresupuesto = 0
    /**
     * Saldo disponible de la ejecución
     */
    double saldoDisponible = 0

    /**
     * Define los campos que se van a ignorar al momento de hacer logs
     */
    static auditable = [ignore: []]

    /**
     * Define el mapeo entre los campos del dominio y las columnas de la base de datos
     */
    static mapping = {
        table 'ejec'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'ejec__id'
        id generator: 'identity'
        version false
        columns {
            asignacion column: 'asgn__id'
            sigef column: 'sigf__id'
            vigente column: 'ejecvgnt'
            compromiso column: 'ejeccmps'
            devengado column: 'ejecdvng'
            pagado column: 'ejecpgdo'
            saldoPresupuesto column: 'ejecslps'
            saldoDisponible column: 'ejecslds'
        }
    }

    /**
     * Define las restricciones de cada uno de los campos
     */
    static constraints = {
//        fecha(blank: true, nullable: true, attributes: [mensaje: 'Fecha de ingreso'])
//        mes(nullable: false, blank: false)
//        anio(nullable: false, blank: false)
        asignacion(nullable: false, blank: false)

    }
}