package vesta.proyectos

import vesta.parametros.TipoGrupo

/**
 * Clase para conectar con la tabla 'grat' de la base de datos
 */
class GrupoDeAtencion implements Serializable {
    /**
     * Tipo de grupo del grupo de atención
     */
    TipoGrupo tipoGrupo
    /**
     * Proyecto del grupo de atención
     */
    Proyecto proyecto
    /**
     * Cantidad de hombres en el grupo de atención
     */
    int hombre
    /**
     * Cantidad de mujeres en el grupo de atención
     */
    int mujer

    /**
     * Define los campos que se van a ignorar al momento de hacer logs
     */
    static auditable = [ignore: []]

    /**
     * Define el mapeo entre los campos del dominio y las columnas de la base de datos
     */
    static mapping = {
        table 'grat'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'grat__id'
        id generator: 'identity'
        version false
        columns {
            id column: 'grat__id'
            tipoGrupo column: 'tpgr__id'
            proyecto column: 'proy__id'
            hombre column: 'grathmbr'
            mujer column: 'gratmujr'
        }
    }

    /**
     * Define las restricciones de cada uno de los campos
     */
    static constraints = {
        tipoGrupo(blank: true, nullable: true, attributes: [mensaje: 'Tipo de Grupo'])
        proyecto(blank: true, nullable: true, attributes: [mensaje: 'Proyecto'])
        hombre(blank: true, nullable: true, attributes: [mensaje: 'Número de hombres atendidos'])
        mujer(blank: true, nullable: true, attributes: [mensaje: 'Número de mujeres atendidas'])
    }
}