package vesta.proyectos

import yachay.parametros.TipoAdquisicion
import yachay.parametros.TipoProcedencia

/**
 * Clase para conectar con la tabla 'adqc' de la base de datos
 */
class Adquisiciones implements Serializable {
    /**
     * Tipo de adquisición
     */
    TipoAdquisicion tipoAdquisicion
    /**
     * Proyecto de la adquisición
     */
    Proyecto proyecto
    /**
     * Tipo de procedencia de la adquisición
     */
    TipoProcedencia tipoProcedencia
    /**
     * Descripción de la adquisición
     */
    String descripcion
    /**
     * Valor de la adquisición
     */
    double valor
    /**
     * Porcentaje de la adquisición
     */
    double porcentaje

    /**
     * Define los campos que se van a ignorar al momento de hacer logs
     */
    static auditable = [ignore: []]

    /**
     * Define el mapeo entre los campos del dominio y las columnas de la base de datos
     */
    static mapping = {
        table 'adqc'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'adqc__id'
        id generator: 'identity'
        version false
        columns {
            id column: 'adqc__id'
            tipoAdquisicion column: 'tpaq__id'
            proyecto column: 'proy__id'
            tipoProcedencia column: 'tppc__id'
            descripcion column: 'adqcdscr'
            valor column: 'adqcvlor'
            porcentaje column: 'adqcpcnt'
        }
    }

    /**
     * Define las restricciones de cada uno de los campos
     */
    static constraints = {
        tipoAdquisicion(blank: true, nullable: true, attributes: [mensaje: 'Tipo de Adquisición'])
        proyecto(blank: true, nullable: true, attributes: [mensaje: 'Proyecto'])
        tipoProcedencia(blank: true, nullable: true, attributes: [mensaje: 'Tipo de Procedencia'])
        descripcion(size: 1..255, blank: false, attributes: [mensaje: 'Descripción de la adquisición o de lo que se adquiere'])
        valor(blank: true, nullable: true, attributes: [mensaje: 'Valor de lo adquirido'])
        porcentaje(blank: true, nullable: true, attributes: [mensaje: 'Porcentaje de procedencia nacional de lo adquirido'])
    }
}