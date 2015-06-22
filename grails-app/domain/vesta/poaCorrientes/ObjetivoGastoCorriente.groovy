package vesta.poaCorrientes

class ObjetivoGastoCorriente {

    String descripcion

    static mapping = {
        table 'obgc'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'obgc__id'
        id generator: 'identity'
        version false
        columns {
            descripcion column: 'obgcdscr'
        }
    }

    static constraints = {
        descripcion maxSize: 511
    }

    String toString() {
        return this.descripcion
    }
}
