package vesta.proyectos

/**
 * Clase para conectar con la tabla 'mdcb' de la base de datos
 */
class Modificables {
    /**
     * Modificación proyecto
     */
    ModificacionProyecto modificacion
    /**
     * Tipo (1: fin, 2: propósito, 3: indicador, 4: meta, 5: supuesto, 6: actividad, 7: medio de verificación, 8: componentes)
     */
    int tipo
    /* 1 fin    2 proposito     3 indicador     4 meta     5 supuesto      6 actividad     7 medio de verificacion    8 componentes  */
    /**
     * Id remoto
     */
    int id_remoto
    /**
     * Fecha
     */
    Date fecha

    /**
     * Define los campos que se van a ignorar al momento de hacer logs
     */
    static auditable = [ignore: []]

    /**
     * Define el mapeo entre los campos del dominio y las columnas de la base de datos
     */
    static mapping = {
        table 'mdcb'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'mdcb__id'
        id generator: 'identity'
        version false
        columns {
            id column: 'mdcb__id'
            modificacion column: 'mdfc__id'
            tipo column: 'mdcbtipo'
            id_remoto column: 'mdcbidrm'
            fecha column: 'mdcbfcha'
        }
    }

    /**
     * Define las restricciones de cada uno de los campos
     */
    static constraints = {
        modificacion(blank: false, nullable: false)
        tipo(blank: false, nullable: false)
        id_remoto(blank: false, nullable: false)
        fecha(blank: true, nullable: true)
    }

    /**
     * Genera un string para mostrar
     * @return el tipo y el id remoto concatenados
     */
    String toString() {
        "${this.tipo}:${id_remoto}"
    }
}
