package vesta.modificaciones

import vesta.parametros.poaPac.Presupuesto
import vesta.poa.Asignacion
import vesta.proyectos.Categoria
import vesta.proyectos.MarcoLogico

class DetalleReforma {

    /**
     * Reforma a la que pertenece el detalle
     */
    Reforma reforma
    /**
     * Asignación de origen
     */
    Asignacion asignacionOrigen
    /**
     * Asignación de destino
     */
    Asignacion asignacionDestino
    /**
     * Presupuesto de la nueva asignación que genera la actividad
     */
    Presupuesto presupuesto
    /**
     * Nueva actividad componente
     */
    MarcoLogico componente
    /**
     * Valor
     */
    Double valor
    /**
     * Descripción de la nueva actividad --la fuente es la misma de la asignación de origen
     */
    String descripcionNuevaActividad
    /**
     * Nueva actividad fecha de inicio
     */
    Date fechaInicioNuevaActividad
    /**
     * Nueva actividad fecha de fin
     */
    Date fechaFinNuevaActividad
    /**
     * Categoría para la nueva actividad
     */
    Categoria categoria
    /**
     * Saldo para usarse en incrementos
     */
    Double saldo = 0

    /**
     * Define los campos que se van a ignorar al momento de hacer logs
     */
    static auditable = [ignore: []]

    /**
     * Define el mapeo entre los campos del dominio y las columnas de la base de datos
     */
    static mapping = {
        table 'dtrf'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'dtrf__id'
        id generator: 'identity'
        version false
        columns {
            reforma column: 'rfrm__id'
            asignacionOrigen column: 'asgn__id'
            asignacionDestino column: 'asgndstn'
            presupuesto column: 'prsp__id'
            componente column: 'mrlg__id'
            valor column: 'dtrfvlor'
            descripcionNuevaActividad column: 'dtrfactv'
            fechaInicioNuevaActividad column: 'dtrfacfi'
            fechaFinNuevaActividad column: 'dtrfacff'
            categoria column: 'ctgr__id'
            saldo column: 'dtrfsldo'
        }
    }

    /**
     * Define las restricciones de cada uno de los campos
     */
    static constraints = {
        asignacionOrigen nullable: true
        asignacionDestino nullable: true
        presupuesto nullable: true
        componente nullable: true
        descripcionNuevaActividad nullable: true
        fechaInicioNuevaActividad nullable: true
        fechaFinNuevaActividad nullable: true
        categoria nullable: true
    }
}
