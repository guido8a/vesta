package vesta.parametros

class Auxiliar {

    double presupuesto

    static mapping = {
        table 'auxl'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'auxl__id'
        id generator: 'identity'
        version false
        columns {
            id column: 'auxl__id'
            presupuesto column: 'auxlprsp'
        }
    }

    /**
     * Define las restricciones de cada uno de los campos
     */
    static constraints = {
        presupuesto(blank: false, attributes: [mensaje: 'Presupuesto general del estado'])
    }
}
