package vesta.parametros
/*Tipo de elemento del marco lógico: distingue entre meta o FIN, OBJETIVO o PROPÓSITO, COMPONENTES y ACTIVIDADES.*/
/**
 * Clase para conectar con la tabla 'tpel' de la base de datos<br/>
 * Tipo de elemento del marco lógico: distingue entre meta o FIN, OBJETIVO o PROPÓSITO, COMPONENTES y ACTIVIDADES.
 */
class TipoElemento   {
    /**
     * Descripción del tipo de elemento
     */
    String descripcion

    /**
     * Define los campos que se van a ignorar al momento de hacer logs
     */
    static auditable = [ignore: []]

    /**
     * Define el mapeo entre los campos del dominio y las columnas de la base de datos
     */
    static mapping = {
//        table 'tpel'
        table 'c_tpel'
        version false
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'tpel__id'
        id generator: 'identity'
        columns {
            id column: 'tpel__id'
            descripcion column: 'tpeldscr'
        }
    }

    /**
     * Define las restricciones de cada uno de los campos
     */
    static constraints = {
        descripcion(size: 1..15, blank: true, nullable: true, attributes: [mensaje: 'Descripción del tipo de elemento'])
    }
}