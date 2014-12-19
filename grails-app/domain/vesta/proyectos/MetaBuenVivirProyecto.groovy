package vesta.proyectos

/**
 * Clase para conectar con la tabla 'mtpy' de la base de datos<br/>
 * Tabla intermedia que conecta proyectos con metas del buen vivir
 */
class MetaBuenVivirProyecto   {
    /**
     * Proyecto
     */
    Proyecto proyecto
    /**
     * Meta del buen vivir
     */
    MetaBuenVivir metaBuenVivir

    /**
     * Define los campos que se van a ignorar al momento de hacer logs
     */
    static auditable = [ignore: []]

    /**
     * Define el mapeo entre los campos del dominio y las columnas de la base de datos
     */
    static mapping = {
        table 'mtpy'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'mtpy__id'
        id generator: 'identity'
        version false
        columns {
            id column: 'mtpy__id'
            proyecto column: 'proy__id'
            metaBuenVivir column: 'mtbv__id'
        }
    }

    /**
     * Define las restricciones de cada uno de los campos
     */
    static constraints = {
        proyecto(blank: false, nullable: false, attributes: [mensaje: 'Proyecto'])
        metaBuenVivir(blank: false, nullable: false, attributes: [mensaje: 'Meta de buen vivir'])
    }

    /**
     * Genera un string para mostrar
     * @return el nombre del proyecto y la descripcion de la meta del buen vivir concatenados
     */
    String toString() {
        return this.proyecto.nombre + " - " + this.metaBuenVivir.descripcion
    }
}
