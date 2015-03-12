package vesta.proyectos

class Respaldo {

    String descripcion
    Date fecha = new Date()
    Proyecto proyecto

    /**
     * Define los campos que se van a ignorar al momento de hacer logs
     */
    static auditable = [ignore: []]

    /**
     * Define el mapeo entre los campos del dominio y las columnas de la base de datos
     */
    static mapping = {
        table 'rspl'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'rspl__id'
        id generator: 'identity'
        version false
        columns {
            id column: 'rspl__id'
            descripcion column: 'rspldscr'
            fecha column: 'rsplfcha'
            proyecto column: 'proy__id'
        }
    }

    /**
     * Define las restricciones de cada uno de los campos
     */
    static constraints = {
        descripcion(size: 1..120)

    }
}
