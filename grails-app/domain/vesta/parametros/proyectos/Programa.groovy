package vesta.parametros.proyectos
/* Programa del cual es parte el proyecto.*/
/**
 * Clase para conectar con la tabla 'prgr' de la base de datos<br/>
 * Programa del cual es parte el proyecto.
 */
class Programa implements Serializable {
    /**
     * Código del programa
     */
    String codigo
    /**
     * Descripción del programa
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
//        table 'prgr'
        table 'c_prgr'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'prgr__id'
        id generator: 'identity'
        version false
        columns {
            id column: 'prgr__id'
            codigo column: 'prgrcdgo'
            descripcion column: 'prgrdscr'
        }
    }

    /**
     * Define las restricciones de cada uno de los campos
     */
    static constraints = {
        codigo(size: 1..2, blank: true, nullable: true, attributes: [mensaje: 'Código según el ESIGEF'])
        descripcion(size: 1..1023, blank: false, attributes: [mensaje: 'Descripción del programa'])
    }

    /**
     * Genera un string para mostrar
     * @return la descripción
     */
    String toString() {
        "${this.descripcion}"
    }
}