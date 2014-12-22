package vesta.parametros

/**
 * Clase para conectar con la tabla 'ctlg' de la base de datos
 */
class Catalogo   {
    /**
     * Descipción de la catálogo
     */
    String nombre
    String codigo
    Integer estado

    /**
     * Define los campos que se van a ignorar al momento de hacer logs
     */
    static auditable = [ignore: []]

    /**
     * Define el mapeo entre los campos del dominio y las columnas de la base de datos
     */
    static mapping = {
        table 'ctlg'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'ctlg__id'
        id generator: 'identity'
        version false
        columns {
            id column: 'ctlg__id'
            nombre column: 'ctlgnmbr'
            codigo column: 'ctlgcdgo'
            estado column: 'ctlgetdo'
        }
    }

    /**
     * Define las restricciones de cada uno de los campos
     */
    static constraints = {
        nombre(size: 1..63, blank: false, attributes: [mensaje: 'Nombre del catálogo'])
        codigo(size: 1..8, blank: false, attributes: [mensaje: 'Código del catálogo'])
        estado(size: 1..8, blank: false, inList: [1,0], attributes: [mensaje: 'Estado del catálogo'])
    }

    /**
     * Genera un string para mostrar
     * @return el id y el mensaje concatenados
     */
    String toString() {
        "${this.nombre}"
    }
}