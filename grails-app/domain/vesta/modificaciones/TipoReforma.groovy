package vesta.modificaciones

/*Tipo de reforma al POA de inversiones y de gasto permanente.*/
/**
 *  discrimina que pantalla mostrar al registro de reformas: asignación, actividad, partida, incremento_techo.
 */
class TipoReforma   {
    /**
     * Código del tipo de reforma
     */
    String codigo
    /**
     * Descripción del tipo de reforma
     */
    String descripcion

    /**
     * Define los campos que se van a ignorar al momento de hacer logs
     */
    static auditable = [ignore: []]

    /**
     * Define el mapeo entre los campos del dominio y las columnas de la base de datos
     */
    static mapping = {
//        table 'tpel'
        table 'tprf'
        version false
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'tprf__id'
        id generator: 'identity'
        columns {
            id column: 'tprf__id'
            codigo column: 'tprfcdgo'
            descripcion column: 'tprfdscr'
        }
    }

    /**
     * Define las restricciones de cada uno de los campos
     */
    static constraints = {
        codigo(size: 1..1, attributes: [mensaje: 'Código del tipo de reforma'])
        descripcion(size: 1..63, attributes: [mensaje: 'Descripción del tipo de reforma'])
    }
}