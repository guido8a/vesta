package vesta.poaCorrientes

import vesta.parametros.poaPac.Anio

class ActividadCorriente {

    MacroActividad macroActividad
    Anio anio
    String descripcion
    String meta

    static mapping = {
        table 'accr'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'accr__id'
        id generator: 'identity'
        version false
        columns {
            macroActividad column: 'mcac__id'
            anio column: "anio__id"
            descripcion column: 'accrdscr'
            meta column: "accrmeta"
        }
    }

    static constraints = {
        descripcion maxSize: 255
        meta maxSize: 255
    }

    String toString() {
        return this.descripcion
    }
}
