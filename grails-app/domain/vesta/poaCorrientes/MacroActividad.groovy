package vesta.poaCorrientes

class MacroActividad {

    ObjetivoGastoCorriente objetivoGastoCorriente
    String descripcion

    static mapping = {
        table 'mcac'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'mcac__id'
        id generator: 'identity'
        version false
        columns {
            objetivoGastoCorriente column: 'obgc__id'
            descripcion column: 'mcacdscr'
        }
    }

    static constraints = {
        descripcion maxSize: 511
    }

    String toString() {
        return this.descripcion
    }
}
