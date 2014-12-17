package vesta.proyectos

/**
 * Clase para conectar con la tabla 'mtbv' de la base de datos
 */
class MetaBuenVivir implements Serializable {
    /**
     * Política del buen vivir de la meta
     */
    PoliticaBuenVivir politica
    /**
     * Código de la meta del buen vivir
     */
    Integer codigo
    /**
     * Descripci&pacute;n de la meta del buen vivir
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
        table 'mtbv'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'mtbv__id'
        id generator: 'identity'
        version false
        columns {
            id column: 'mtbv__id'
            politica column: 'plbv__id'
            codigo column: 'mtbvcdgo'
            descripcion column: 'mtbvdscr'
        }
    }

    /**
     * Define las restricciones de cada uno de los campos
     */
    static constraints = {
        politica(blank: false, nullable: false, attributes: [mensaje: 'Meta del buen vivir'])
        codigo(blank: false, nullable: false, attributes: [mensaje: 'Código de la meta'])
        descripcion(size: 1..127, blank: true, nullable: true, attributes: [mensaje: 'Descripción de la meta'])
    }

    /**
     * Genera un string para mostrar
     * @return el código del objetivo de la política, el código de la política,
     * el código y la descripción concatenados
     */
    String toString() {
        return this.politica.objetivo.codigo + "." + this.politica.codigo + "." + this.codigo + " - " + this.descripcion
    }
}
