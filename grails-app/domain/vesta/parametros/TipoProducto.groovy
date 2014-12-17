package vesta.parametros

/**
 * Clase para conectar con la tabla 'tppd' de la base de datos
 */
class TipoProducto implements Serializable {
    /**
     * Descripción del tipo de producto
     */
    String tipoProducto

    /**
     * Define los campos que se van a ignorar al momento de hacer logs
     */
    static auditable = [ignore: []]

    /**
     * Define el mapeo entre los campos del dominio y las columnas de la base de datos
     */
    static mapping = {
        table 'tppd'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'tppd__id'
        id generator: 'identity'
        version false
        columns {
            id column: 'tppd__id'
            tipoProducto column: 'tppddscr'
        }
    }

    /**
     * Define las restricciones de cada uno de los campos
     */
    static constraints = {
        tipoProducto(size: 1..31, blank: false, attributes: [mensaje: 'Descripción del tipo de producto'])
    }

    /**
     * Genera un string para mostrar
     * @return el tipo de producto
     */
    String toString() {
        return this.tipoProducto
    }
}