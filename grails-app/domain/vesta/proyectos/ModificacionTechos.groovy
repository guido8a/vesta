package vesta.proyectos

import vesta.parametros.PresupuestoUnidad
import vesta.seguridad.Usro

/**
 * Clase para conectar con la tabla 'mdtc' de la base de datos
 */
class ModificacionTechos {
    /**
     * Presupuesto que envía
     */
    PresupuestoUnidad desde
    /**
     * Presupuesto que recibe
     */
    PresupuestoUnidad recibe
    /**
     * Tipo de modificación (1: corriente a corriente, 2: corriente a inversi&oacuet;n, 3: eliminar asignación)
     */
    int tipo /*  1-> corriente a corriente    2-> corriente a inversion  3-> eliminar asignacion */
    /**
     * Valor de la modificación
     */
    double valor
    /**
     * Fecha de la modificación
     */
    Date fecha
    /**
     * Usuario que efectuó la modificación
     */
    Usro usuario

    /**
     * Define los campos que se van a ignorar al momento de hacer logs
     */
    static auditable = [ignore: []]

    /**
     * Define el mapeo entre los campos del dominio y las columnas de la base de datos
     */
    static mapping = {
        table 'mdtc'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'mdtc__id'
        id generator: 'identity'
        version false
        columns {
            id column: 'mdtc__id'
            desde column: 'pruedsde'
            recibe column: 'pruercbe'
            fecha column: 'mdasfcha'
            valor column: 'mdasvlor'
            usuario column: 'usro__id'
            tipo column: 'mdtctipo'
        }
    }

    /**
     * Define las restricciones de cada uno de los campos
     */
    static constraints = {
        desde(blank: true, nullable: true, attributes: [mensaje: 'Asignación desde donde sale dinero'])
        recibe(blank: true, nullable: true, attributes: [mensaje: 'Asignación que recibe el dinero'])
        fecha(blank: true, nullable: true, attributes: [mensaje: 'Fecha'])
        valor(blank: true, nullable: true, attributes: [mensaje: 'Valor redistribuido, siempre en positivo'])
        usuario(blank: false, nullable: false)
    }
}
