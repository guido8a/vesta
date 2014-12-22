package vesta.parametros

/**
 * Clase para conectar con la tabla 'itct' de la base de datos
 */
class ItemCatalogo   {
    /**
     * Descipción de la tabla items del catálogo
     */
    Catalogo catalogo
    String nombre
    String codigo
    String descripcion
    Integer estado
    Integer orden
    Integer original

    /**
     * Define los campos que se van a ignorar al momento de hacer logs
     */
    static auditable = [ignore: []]

    /**
     * Define el mapeo entre los campos del dominio y las columnas de la base de datos
     */
    static mapping = {
        table 'itct'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'itct__id'
        id generator: 'identity'
        version false
        columns {
            id column: 'itct__id'
            catalogo column: 'ctlg__id'
            nombre column: 'itctnmbr'
            descripcion column: 'itctdscr'
            codigo column: 'itctcdgo'
            estado column: 'itctetdo'
            orden column: 'itctordn'
            original column: 'itctorgn'
        }
    }

    /**
     * Define las restricciones de cada uno de los campos
     */
    static constraints = {
        nombre(size: 1..255, blank: true, nullable: true, attributes: [mensaje: 'Nombre del item'])
        nombre(size: 1..15, blank: true, nullable: true, attributes: [mensaje: 'Código del item'])
        nombre(size: 1..255, blank: false, nullable: false, attributes: [mensaje: 'Descripción del item'])
    }

    /**
     * Genera un string para mostrar
     * @return el id y el mensaje concatenados
     */
//    String toString() {
//        "${this.nombre}"
//    }


}