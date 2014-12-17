package vesta.parametros.proyectos
/*El grupo de procesos del proyecto se refiere a los distintos momentos del proyecto como son: INICIO, PLANIFICACIÓN, EJECUCIÓN y CIERRE*/
/**
 * Clase para conectar con la tabla 'grpr' de la base de datos<br/>
 * El grupo de procesos del proyecto se refiere a los distintos momentos del proyecto como son:
 * INICIO, PLANIFICACIÓN, EJECUCIÓN y CIERRE
 */
class GrupoProcesos implements Serializable {
    /**
     * Descripción del grupo de procesos
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
//        table 'grpr'
        table 'c_grpr'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'grpr__id'
        id generator: 'identity'
        version false
        columns {
            id column: 'grpr__id'
            descripcion column: 'grprdscr'
        }
    }

    /**
     * Define las restricciones de cada uno de los campos
     */
    static constraints = {
        descripcion(size: 1..31, blank: false, attributes: [mensaje: 'Descripción del grupo de procesos'])
    }

    /**
     * Genera un string para mostrar
     * @return la descripción
     */
    String toString() {
        return this.descripcion
    }
}