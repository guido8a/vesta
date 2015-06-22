package vesta.poaCorrientes

class Tarea {

    Actividad Actividad
    String descripcion

    static mapping = {
        table 'trea'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'actv__id'
        id generator: 'identity'
        version false
        columns {
            actividad column: 'actv__id'
            descripcion column: 'treadscr'
        }
    }

    static constraints = {
        descripcion maxSize: 511
    }

    String toString() {
        return this.descripcion
    }
}
