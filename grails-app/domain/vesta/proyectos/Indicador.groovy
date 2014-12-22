package vesta.proyectos

import vesta.poa.Asignacion

/*Para cada elemento del marco lógico se define uno o varios indicadores*/
/**
 * Clase para conectar con la tabla '' de la base de datos<br/>
 * Para cada elemento del marco lógico se define uno o varios indicadores
 */
class Indicador   {
    /**
     * Marco lógico del indicador
     */
    MarcoLogico marcoLogico
    /**
     * Asignación del indicador
     */
    Asignacion asignacion
    /**
     * Descripción del indicador
     */
    String descripcion
    /**
     * Cantidad del indicador
     */
    double cantidad = 0
    /**
     * Modificación del indicador
     */
    ModificacionProyecto modificacion
    /**
     * Estado del indicador: 0: activo, 1: modificado
     */
    int estado = 0 /* 0 -> activo por facilidad en la base de datos  1-> modificado*/

    /**
     * Define los campos que se van a ignorar al momento de hacer logs
     */
    static auditable = [ignore: []]

    /**
     * Define el mapeo entre los campos del dominio y las columnas de la base de datos
     */
    static mapping = {
        table 'indi'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'indi__id'
        id generator: 'identity'
        version false
        columns {
            id column: 'indi__id'
            marcoLogico column: 'mrlg__id'
            descripcion column: 'indidscr'
            cantidad column: 'indicntd'
            modificacion column: 'mdfc__id'
            estado column: 'indietdo'
            asignacion column: "asgn__id"
        }
    }

    /**
     * Define las restricciones de cada uno de los campos
     */
    static constraints = {
        marcoLogico(blank: true, nullable: true, attributes: [mensaje: 'Elemento del marco lógico al que se aplica el indicador'])
        descripcion(size: 1..1023, blank: true, nullable: true, attributes: [mensaje: 'Descripción del indicador'])
        cantidad(blank: true, nullable: true, attributes: [mensaje: 'Cantidad para indicadores cuantitativos'])
        modificacion(blank: true, nullable: true)
        estado(nullable: false, blank: false)
        asignacion(nullable: true, blank: true)
    }

    /**
     * Genera un string para mostrar
     * @return la descripción
     */
    String toString() {
        "${this.descripcion}"
    }

}