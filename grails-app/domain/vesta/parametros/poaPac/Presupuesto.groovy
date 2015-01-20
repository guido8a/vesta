package vesta.parametros.poaPac
/*Presupuesto techo para elaborar la proforma presupuestaria.*/
/**
 * Clase para conectar con la tabla 'prsp' de la base de datos<br/>
 * Presupuesto techo para elaborar la proforma presupuestaria
 */
class Presupuesto   {
    /**
     * Presupuesto padre del presupuesto actual
     */
    Presupuesto presupuesto
    /**
     * Número del presupuesto
     */
    String numero
    /**
     * Descripción del presupuesto
     */
    String descripcion
    /**
     * Nivel del presupuesto
     */
    int nivel
    /**
     * Indica si es de movimiento o no (1: sí, 0: no)
     */
    int movimiento = 0

    /**
     * Define los campos que se van a ignorar al momento de hacer logs
     */
    static auditable = [ignore: []]

    /**
     * Define el mapeo entre los campos del dominio y las columnas de la base de datos
     */
    static mapping = {
        table 'prsp'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'prsp__id'
        id generator: 'identity'
        version false
        columns {
            id column: 'prsp__id'
            presupuesto column: 'prsppdre'
            numero column: 'prspnmro'
            descripcion column: 'prspdscr'
            nivel column: 'prspnvel'
            movimiento column: 'prspmvnt'
        }
    }

    /**
     * Define las restricciones de cada uno de los campos
     */
    static constraints = {
        presupuesto(blank: true, nullable: true, attributes: [mensaje: 'Partida padre'])
        numero(size: 1..15, blank: true, nullable: true, attributes: [mensaje: 'Número de la partida'])
        descripcion(size: 1..255, blank: true, nullable: true, attributes: [mensaje: 'Descripción de la aprtida'])
        nivel(blank: true, nullable: true, attributes: [mensaje: 'Nivel de la partida'])
        movimiento(blank: true, nullable: true)
    }

    /**
     * Genera un string para mostrar
     @return el número y la descripción concatenados
     */
    String toString() {
        "${this.numero} (${this.descripcion})"
    }
}