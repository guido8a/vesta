package vesta.poaCorrientes

class Tarea {

    ActividadCorriente actividad
    String descripcion

    static mapping = {
        table 'trea'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'trea__id'
        id generator: 'identity'
        version false
        columns {
            actividad column: 'accr__id'
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
