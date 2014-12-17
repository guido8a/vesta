package vesta.proyectos

import yachay.parametros.proyectos.Politica

/*Políticas que se aplican en el proyecto*/
/**
 * Clase para conectar con la tabla 'plpy' de la base de datos<br/>
 * Políticas que se aplican en el proyecto
 */
class PoliticasProyecto implements Serializable {
    /**
     * Política
     */
    Politica politica
    /**
     * Proyecto
     */
    Proyecto proyecto

    /**
     * Define los campos que se van a ignorar al momento de hacer logs
     */
    static auditable = [ignore: []]

    /**
     * Define el mapeo entre los campos del dominio y las columnas de la base de datos
     */
    static mapping = {
        table 'plpy'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'plpy__id'
        id generator: 'identity'
        version false
        columns {
            id column: 'plpy__id'
            politica column: 'pltc__id'
            proyecto column: 'proy__id'
        }
    }

    /**
     * Define las restricciones de cada uno de los campos
     */
    static constraints = {
        politica(blank: true, nullable: true, attributes: [mensaje: 'Política'])
        proyecto(blank: true, nullable: true, attributes: [mensaje: 'Proyecto'])
    }
}