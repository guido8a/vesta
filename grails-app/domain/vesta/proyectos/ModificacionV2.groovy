package vesta.proyectos

import vesta.seguridad.Persona

/**
 * Clase para conectar con la tabla 'mdv2' de la base de datos
 */
class ModificacionV2 {
    /**
     * Dominio
     */
    String dominio
    /**
     * Campo
     */
    String campo
    /**
     * Id remoto
     */
    int id_remoto
    /**
     * Valor anterior
     */
    String oldValue
    /**
     * Valor nuevo
     */
    String newValue
    /**
     * Fecha de la modificación
     */
    Date fecha = new Date()
    /**
     * Usuario que efectuó la modificación
     */
    Persona usuario
    /**
     * Tipo de modificación
     */
    String tipo

    /**
     * Define el mapeo entre los campos del dominio y las columnas de la base de datos
     */
    static mapping = {
        table 'mdv2'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'mdv2__id'
        id generator: 'identity'
        version false
        columns {
            id column: 'mdv2__id'
            dominio column: 'mdv2dmno'
            id_remoto column: 'mdv2idrm'
            oldValue column: 'mdv2olva'
            newValue column: 'mdv2nwva'
            usuario column: 'prsn__id'
            fecha column: 'mdv2fcha'
            tipo column: 'mdv2tipo'
        }
    }

    /**
     * Define las restricciones de cada uno de los campos
     */
    static constraints = {
        dominio(nullable: false, blank: false)
        oldValue(size: 1..500, nullable: true, blank: true)
        newValue(size: 1..500, nullable: true, blank: true)
        dominio(size: 1..120, nullable: false, blank: false)
        campo(size: 1..100, nullable: true, blank: true)
        tipo(size: 1..100, nullable: true, blank: true)
    }
}
