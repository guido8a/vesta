package vesta.poaCorrientes

class Actividad {

    MacroActividad macroActividad
    String descripcion

    static mapping = {
        table 'actv'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'actv__id'
        id generator: 'identity'
        version false
        columns {
            macroActividad column: 'mcac__id'
            descripcion column: 'actvdscr'
        }
    }

    static constraints = {
        descripcion maxSize: 511
    }

    String toString() {
        return this.descripcion
    }
}
