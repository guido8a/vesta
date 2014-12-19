package vesta.parametros.poaPac
/*Tipo de compra para el PAC, distingue entre bienes, servicios, etc.*/
/**
 * Clase para conectar con la tabla 'tpcp' de la base de datos<br/>
 * Tipo de compra para el PAC, distingue entre bienes, servicios, etc.
 */
class TipoCompra   {
    /**
     * Descripción del tipo de compra
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
//        table 'tpcp'
        table 'c_tpcp'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'tpcp__id'
        id generator: 'identity'
        version false
        columns {
            id column: 'tpcp__id'
            descripcion column: 'tpcpdscr'
        }
    }

    /**
     * Define las restricciones de cada uno de los campos
     */
    static constraints = {
        descripcion(size: 1..63, blank: true, nullable: true, attributes: [mensaje: 'Descripción del tipo de compra'])
    }

    /**
     * Genera un string para mostrar
     * @return la descripción
     */
    String toString() {
        "${this.descripcion}"
    }
}