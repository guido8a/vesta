package vesta.proyectos

import vesta.parametros.TipoInforme

/**
 * Clase para conectar con la tabla 'info' de la base de datos
 */
class Informe   {
    /**
     * Responsable del informe
     */
    ResponsableProyecto responsableProyecto
    /**
     * Tipo de informe
     */
    TipoInforme tipo
    /**
     * Fecha del informe
     */
    Date fecha
    /**
     * Avance del informe
     */
    String avance
    /**
     * Dificultades
     */
    String dificultades
    /**
     * Porcentaje
     */
    Integer porcentaje = 0
    /**
     * Link
     */
    String link

    /**
     * Define los campos que se van a ignorar al momento de hacer logs
     */
    static auditable = [ignore: []]

    /**
     * Define el mapeo entre los campos del dominio y las columnas de la base de datos
     */
    static mapping = {
        table 'info'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'info__id'
        id generator: 'identity'
        version false
        columns {
            id column: 'info__id'
            responsableProyecto column: 'rspy__id'
            tipo column: 'tpif__id'
            fecha column: 'infofcha'
            avance column: 'infoavnc'
            avance type: 'text'
            dificultades column: 'infodifc'
            dificultades type: 'text'
            porcentaje column: 'infopcnt'
            link column: 'infolink'
        }
    }

    /**
     * Define las restricciones de cada uno de los campos
     */
    static constraints = {
        responsableProyecto(blank: true, nullable: true, attributes: [mensaje: 'Responsable del proyecto'])
        tipo(blank: true, nullable: true, attributes: [mensaje: 'Tipo de informe'])
        fecha(blank: true, nullable: true, attributes: [mensaje: 'Fecha'])
        avance(blank: true, nullable: true, attributes: [mensaje: 'Resumen del avance'])
        dificultades(blank: true, nullable: true, attributes: [mensaje: 'Dificultades'])
        porcentaje(blank: true, nullable: true, attributes: [mensaje: 'Porcentaje acumulado de avance'])
        link(size: 1..127, blank: true, nullable: true, attributes: [mensaje: 'Link o enlace al documento real (sistema de trámite)'])
    }
}