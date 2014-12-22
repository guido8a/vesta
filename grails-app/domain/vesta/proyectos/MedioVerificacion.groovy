package vesta.proyectos
/* Para cada indicador del marco lógico se define uno o varios medios de verificación.*/
/**
 * Clase para conectar con la tabla 'mdvf' de la base de datos<br/>
 * Para cada indicador del marco lógico se define uno o varios medios de verificación.
 */
class MedioVerificacion   {
    /**
     * Indicador del medio de verificación
     */
    Indicador indicador
    /**
     * Descripción del medio de verificación
     */
    String descripcion
    /**
     * Modificación proyecto del medio de verificación
     */
    ModificacionProyecto modificacion
    /**
     * Estado del medio de verificación (0: activo, 1: modificado)
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
        table 'mdvf'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'mdvf__id'
        id generator: 'identity'
        version false
        columns {
            id column: 'mdvf__id'
            indicador column: 'indi__id'
            descripcion column: 'indidscr'
            modificacion column: 'mdfc__id'
            estado column: 'mdvfetdo'
        }
    }

    /**
     * Define las restricciones de cada uno de los campos
     */
    static constraints = {
        indicador(blank: false, nullable: false, attributes: [mensaje: 'Elemento del marco lógico al que se aplica el indicador'])
        descripcion(size: 1..1023, blank: false, nullable: false, attributes: [mensaje: 'Descripción del medio de verificación'])
        modificacion(blank: true, nullable: true)
        estado(blank: false, nullable: false)
    }

    /**
     * Genera un string para mostrar
     * @return la descripción limitada a 20 caracteres
     */
    String toString() {
        if (descripcion.size() > 20) {
            def partes = descripcion.split(" ")
            def cont = 0
            def des = ""
            partes.each {
                cont += it.size()
                if (cont < 22)
                    des += " " + it
            }
            return des + "... "
        } else {
            return "${this.descripcion}"
        }

    }
    /**
     * Genera un string para mostrar
     * @return la descripción completa
     */
    String toStringCompleto() {
        return this.descripcion
    }

}