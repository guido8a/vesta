package vesta.parametros
/*Etapa del proyecto: PERFIL, PRIORIZADO, INVERSION.*/

/**
 * Clase para conectar con la tabla 'etpa' de la base de datos<br/>
 * Guarda un catálogo de posibles etapas del proyecto, como PERFIL, PRIORIZADO, INVERSION
 */
class Etapa   {
    /**
     * Descipción de la etapa
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
        table 'etpa'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'etpa__id'
        id generator: 'identity'
        version false
        columns {
            id column: 'etpa__id'
            descripcion column: 'etpadscr'
        }
    }

    /**
     * Define las restricciones de cada uno de los campos
     */
    static constraints = {
        descripcion(size: 1..31, blank: false, attributes: [mensaje: 'Descripción de la etapa del proyecto'])
    }

    /**
     * Genera un string para mostrar
     * @return la descripción
     */
    String toString() {
        return this.descripcion
    }
}