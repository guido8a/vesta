package vesta.proyectos

/*Para cada elemento del marco lógico se define uno o varios supuestos.
Nótese que la relación del supuesto es al elemento del marco lógico, no a los indicadores ni a los medios de comprobación de los indicadores.*/
/**
 * Clase para conectar con la tabla 'spst' de la base de datos<br/>
 * Para cada elemento del marco lógico se define uno o varios supuestos.<br/>
 * Nótese que la relación del supuesto es al elemento del marco lógico,
 * no a los indicadores ni a los medios de comprobación de los indicadores.
 */
class Supuesto   {
    /**
     * Marco lógico del supuesto
     */
    MarcoLogico marcoLogico
    /**
     * Descripción del supuesto
     */
    String descripcion
    /**
     * Modificación del supuesto
     */
    ModificacionProyecto modificacion
    /**
     * Estado del supuesto (0: activo, 1: modificado)
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
        table 'spst'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'spst__id'
        id generator: 'identity'
        version false
        columns {
            id column: 'spst__id'
            marcoLogico column: 'mrlg__id'
            descripcion column: 'spstdscr'
            modificacion column: 'mdfc__id'
            estado column: 'spstetdo'
        }
    }

    /**
     * Define las restricciones de cada uno de los campos
     */
    static constraints = {
        marcoLogico(blank: true, nullable: true, attributes: [mensaje: 'Elemento del marco lógico al que se aplica el supuesto'])
        descripcion(blank: false, nullable: false, attributes: [mensaje: 'Descripción'])
        modificacion(blank: true, nullable: true)
        estado(blank: false, nullable: false)
    }

    /**
     * Genera un string para mostrar
     * @return
     */
    String toString() {
        if (this?.descripcion?.size() > 20) {
            def partes = this?.descripcion?.split(" ")
            def cont = 0
            def des = ""
            partes.each {
                cont += it.size()
                if (cont < 22)
                    des += " " + it
            }
            return des + "... "

        } else {
            return "${this?.descripcion}"
        }

    }
    /**
     * Genera un string para mostrar
     * @return
     */
    String toStringCompleto() {
        return this.descripcion
    }
}