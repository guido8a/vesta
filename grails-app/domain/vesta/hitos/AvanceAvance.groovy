package vesta.hitos

class AvanceAvance {
    /*
    * Avance
    */
    double avance
    /*
    * Fecha de registro
    */
    Date fecha = new Date()
    /*
    * Avance físico
    */
    AvanceFisico avanceFisico

    /**
     * Define el mapeo entre los campos del dominio y las columnas de la base de datos
     */
    static mapping = {
        table 'avav'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'avav__id'
        id generator: 'identity'
        version false
        columns {
            id column: 'avav__id'
            avance column: 'avavavcn'
            fecha column: 'avavfcrg'
            avanceFisico column: 'avfs__id'
        }
    }

    String toString(){
        return "${this.avanceFisico.observaciones} - ${this.fecha.format('dd/MM/yyyy')}, ${avance.round(2)}%"
    }

}
