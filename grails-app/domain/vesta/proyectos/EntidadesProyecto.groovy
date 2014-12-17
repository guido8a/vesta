package vesta.proyectos

import yachay.parametros.TipoParticipacion
import yachay.parametros.UnidadEjecutora

/**
 * Clase para conectar con la tabla 'etpy' de la base de datos
 */
class EntidadesProyecto implements Serializable {
    /**
     * Unidad ejecutora de la entidad del proyecto
     */
    UnidadEjecutora unidad
    /**
     * Tipo de participación de la entidad del proyecto
     */
    TipoParticipacion tipoPartisipacion
    /**
     * Proyecto de la entidad del proyecto
     */
    Proyecto proyecto
    /**
     * Monto de la entidad del proyecto
     */
    double monto
    /**
     * Rol de la entidad del proyecto
     */
    String rol

    /**
     * Define los campos que se van a ignorar al momento de hacer logs
     */
    static auditable = [ignore: []]

    /**
     * Define el mapeo entre los campos del dominio y las columnas de la base de datos
     */
    static mapping = {
        table 'etpy'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'etpy__id'
        id generator: 'identity'
        version false
        columns {
            id column: 'etpy__id'
            unidad column: 'unej__id'
            tipoPartisipacion column: 'tppt__id'
            proyecto column: 'proy__id'
            monto column: 'etpymnto'
            rol column: 'etpy_rol'
            tipoPartisipacion column: 'tppt__id'
        }
    }

    /**
     * Define las restricciones de cada uno de los campos
     */
    static constraints = {
        unidad(blank: true, nullable: true, attributes: [mensaje: 'Unidad ejecutora'])
        tipoPartisipacion(blank: true, nullable: true, attributes: [mensaje: 'Tipo de Participación'])
        proyecto(blank: true, nullable: true, attributes: [mensaje: 'Proyecto'])
        monto(blank: true, nullable: true, attributes: [mensaje: 'Monto que aportan'])
        rol(size: 1..1023, blank: true, nullable: true, attributes: [mensaje: 'Rol que desempeñan'])
    }

//    /**
//     * Genera un string para mostrar
//     * @return la descripción
//     */
//    String toString() {
//        "${this.descripcion}"
//    }
}