package vesta.parametros

/*Unidad de control o conteo de obras para el plan anual de adquisiciones (PAC) y para fijar las metas.*/

/**
 * Clase para conectar con la tabla 'undd' de la base de datos<br/>
 * Unidad de control o conteo de obras para el plan anual de adquisiciones (PAC) y para fijar las metas
 */
class Unidad implements Serializable {
    /**
     * Código de la unidad
     */
    String codigo
    /**
     * Descripción de la unidad
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
//        table 'undd'
        table 'c_undd'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'undd__id'
        id generator: 'identity'
        version false
        columns {
            id column: 'undd__id'
            codigo column: 'unddcdgo'
            descripcion column: 'undddscr'
        }
    }

    /**
     * Define las restricciones de cada uno de los campos
     */
    static constraints = {
        codigo(size: 1..7, blank: true, nullable: true, attributes: [mensaje: 'Código de la unidad'])
        descripcion(size: 1..63, blank: true, nullable: true, attributes: [mensaje: 'Descripción de la unidad'])
    }

    /**
     * Genera un string para mostrar
     * @return la descripción
     */
    String toString() {
        "${this.descripcion}"
    }
}