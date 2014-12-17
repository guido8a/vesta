package vesta.parametros.poaPac
/*Meses para el registro del cronograma valorado*/
/**
 * Clase para conectar con la tabla 'mess' de la base de datos<br/>
 * Meses para el registro del cronograma valorado
 */
class Mes implements Serializable {
    /**
     * Número del mes
     */
    int numero
    /**
     * Descripción del mes (nombre)
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
//        table 'mess'
        table 'c_mess'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'mess__id'
        id generator: 'identity'
        version false
        columns {
            id column: 'mess__id'
            numero column: 'messnmro'
            descripcion column: 'messdscr'
        }
    }

    /**
     * Define las restricciones de cada uno de los campos
     */
    static constraints = {
        numero(blank: true, nullable: true, attributes: [mensaje: 'Número del mes (1 para enero, 12 para diciembre)'])
        descripcion(size: 1..15, blank: true, nullable: true, attributes: [mensaje: 'Nombre del mes'])
    }

    /**
     * Genera un string para mostrar
     * @return el nombre
     */
    String toString() {
        "${this.descripcion}"
    }

}