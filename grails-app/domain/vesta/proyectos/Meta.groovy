package vesta.proyectos

import vesta.parametros.Unidad
import vesta.parametros.geografia.Parroquia
import vesta.parametros.poaPac.Anio
import vesta.parametros.proyectos.TipoMeta
import vesta.poa.Asignacion

/*Para cada componente se determinan las metas desagregadas conforme al marco lógico. */
/**
 * Clase para conectar con la tabla 'meta' de la base de datos<br/>
 * Para cada componente se determinan las metas desagregadas conforme al marco lógico.
 */
class Meta implements Serializable {
    /**
     * Tipo de meta
     */
    TipoMeta tipoMeta
    /**
     * Parroquia a la cual pertenece la meta
     */
    Parroquia parroquia
    /**
     * Marco lón de la meta
     */
    MarcoLogico marcoLogico
    /**
     * Asignación de la meta
     */
    Asignacion asignacion
    /**
     * Unidad de la meta
     */
    Unidad unidad
    /**
     * Año de la meta
     */
    Anio anio
    /**
     * Descripción de la meta
     */
    String descripcion
    /**
     * Indicador de la meta
     */
    double indicador
    /**
     * Inversión de la meta
     */
    double inversion = 0
    /**
     * Coordenada en x de la meta
     */
    int cord_x = 0
    /**
     * Coordenada en y de la meta
     */
    int cord_y = 0
    /**
     * Latitudo de la meta (para ubicarla en el mapa)
     */
    double latitud
    /**
     * Longitud de la meta (para ubicarla en el mapa)
     */
    double longitud
    /**
     * Zoom del mapa al mostrar la meta
     */
    double zoom
    /**
     * Modificación proyecto de la meta
     */
    ModificacionProyecto modificacion
    /**
     * Estado de la meta (0: activo, 1: modificado)
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
        table 'meta'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'meta__id'
        id generator: 'identity'
        version false
        columns {
            id column: 'meta__id'
            tipoMeta column: 'tpmt__id'
            parroquia column: 'parr__id'
            marcoLogico column: 'mrlg__id'
            unidad column: 'undd__id'
            descripcion column: 'mcacdscr'
            indicador column: 'metaindi'
            cord_x column: 'metacrdx'
            cord_y column: 'metacrdy'
            modificacion column: 'mdfc__id'
            estado column: 'metaetdo'
            inversion column: 'metainvs'
            anio column: 'anio__id'
            asignacion column: "asgn__id"

            latitud column: 'metalatt'
            longitud column: 'metalong'
            zoom column: 'metazoom'
        }
    }

    /**
     * Define las restricciones de cada uno de los campos
     */
    static constraints = {
        tipoMeta(blank: true, nullable: true, attributes: [mensaje: 'Tipo de Meta'])
        parroquia(blank: false, nullable: false, attributes: [mensaje: 'Parroquia en la cual se verificará la meta'])
        marcoLogico(blank: true, nullable: true, attributes: [mensaje: 'Componente del marco lógico'])
        unidad(blank: true, nullable: true, attributes: [mensaje: 'Unidad de medida'])
        descripcion(size: 1..1024, blank: true, nullable: true, attributes: [mensaje: 'Descripción de la meta a alcanzar'])
        indicador(blank: true, nullable: true, attributes: [mensaje: 'Indicador numérico de la meta'])
        modificacion(blank: true, nullable: true)
        estado(nullable: false, blank: false)
        asignacion(nullable: true, blank: true)
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
}