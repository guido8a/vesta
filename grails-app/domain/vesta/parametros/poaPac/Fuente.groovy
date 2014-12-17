package vesta.parametros.poaPac
/*Fuente de financiamiento del proyecto, puede ser estado, préstamo a organismos internacionales, aporte propio, etc.*/
/**
 * Clase para conectar con la tabla 'fnte' de la base de datos<br/>
 * Fuente de financiamiento del proyecto, puede ser estado, préstamo a organismos internacionales, aporte propio, etc.
 */
class Fuente implements Serializable {
    /**
     * Descripción de la fuente
     */
    String descripcion
    /**
     * Código de la fuente
     */
    String codigo

    /**
     * Define los campos que se van a ignorar al momento de hacer logs
     */
    static auditable = [ignore: []]

    /**
     * Define el mapeo entre los campos del dominio y las columnas de la base de datos
     */
    static mapping = {
//        table 'fnte'
        table 'c_fnte'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'fnte__id'
        id generator: 'identity'
        version false
        columns {
            id column: 'fnte__id'
            codigo column: 'fntecdgo'
            descripcion column: 'fntedscr'
        }
    }

    /**
     * Define las restricciones de cada uno de los campos
     */
    static constraints = {
        codigo(size: 1..3, blank: true, nullable: true, attributes: [mensaje: 'Descripción de la fuente de financiamiento del proyecto'])
        descripcion(size: 1..63, blank: true, nullable: true, attributes: [mensaje: 'Descripción de la fuente de financiamiento del proyecto'])
    }

    /**
     * Genera un string para mostrar
     * @return la descripción
     */
    String toString() {
        "${this.descripcion}"
    }
}