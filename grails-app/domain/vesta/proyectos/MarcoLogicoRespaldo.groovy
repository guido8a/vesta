package vesta.proyectos

import vesta.parametros.TipoElemento
import vesta.parametros.UnidadEjecutora

/**
 * Clase para conectar con la tabla 'mlrs' de la base de datos
 */
class MarcoLogicoRespaldo implements Serializable {
    /**
     * Marco lógico original (del que se hizo el respaldo)
     */
    MarcoLogico marcoLogicoOriginal     //el que se hizo repaldo
    /**
     * Proyecto del marco lógico de respaldo
     */
    Proyecto proyecto
    /**
     * Tipo de elemento del marco lógico de respaldo
     */
    TipoElemento tipoElemento
    /**
     * Marco lógico padre del marco lógico actual
     */
    MarcoLogico marcoLogico //padre
    /**
     * Objeto del marco lógico de respaldo
     */
    String objeto
    /**
     * Valor del monto del marco lógico de respaldo
     */
    double monto
    /**
     * Estado del marco lógico de respaldo (0: activo, 1: modificado)
     */
    int estado = 0 /* 0 -> activo por facilidad en la base de datos  1-> modificado*/
    /**
     * Categoría del marco lógico de respaldo
     */
    Categoria categoria;
    /**
     * Fecha de inicio del marco lógico de respaldo
     */
    Date fechaInicio
    /**
     * Fecha de fin del marco lógico de respaldo
     */
    Date fechaFin
    /**
     * Unidad ejecutora responsable del marco lógico de respaldo
     */
    UnidadEjecutora responsable
    /**
     * Valor del aporte del marco lógico de respaldo
     */
    double aporte = 0;
    /**
     * Indica si tiene o no asignación en el POA (S: sí, N: no)
     */
    String tieneAsignacion = "S" //'S' - > esta en el POA (asignacion), 'N' -> no esta
    /**
     * Número del marco lógico de respaldo
     */
    int numero = 0;

    /**
     * Define los campos que se van a ignorar al momento de hacer logs
     */
    static auditable = [ignore: []]

    /**
     * Define el mapeo entre los campos del dominio y las columnas de la base de datos
     */
    static mapping = {
        table 'mlrs'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'mlrs__id'
        id generator: 'identity'
        version false
        columns {
            id column: 'mlrs__id'
            marcoLogicoOriginal column: 'mrlg__id'
            proyecto column: 'proy__id'
            tipoElemento column: 'tpel__id'
            marcoLogico column: 'mlrspdre'
            objeto column: 'mlrsobjt'
            monto column: 'mlrsmnto'
            estado column: 'mlrsetdo'
            categoria column: 'ctgr__id'
            fechaInicio column: 'mlrsfcin'
            fechaFin column: 'mlrsfcfn'
            responsable column: 'unej__id'
            aporte column: 'mlrsaprt'
            tieneAsignacion column: 'mlrstnas'
            numero column: 'mlrsnmro'
        }
    }

    /**
     * Define las restricciones de cada uno de los campos
     */
    static constraints = {
        proyecto(blank: true, nullable: true, attributes: [mensaje: 'Proyecto'])
        tipoElemento(blank: true, nullable: true, attributes: [mensaje: 'Tipo de Elemento'])
        marcoLogico(blank: true, nullable: true, attributes: [mensaje: 'Marco lógico original (elemento) en caso de haber modificaciones'])
        objeto(size: 1..1023, blank: true, nullable: true, attributes: [mensaje: 'Objetivo, objeto o descripción del elemento'])
        monto(blank: true, nullable: true, attributes: [mensaje: 'Monto o valor planificado, se aplica sólo en actividades'])
        estado(nullable: false, blank: false)
        categoria(nullable: true, blank: true)
        responsable(nullable: true, blank: true)
        fechaFin(nullable: true, blank: true)
        fechaInicio(nullable: true, blank: true)
        tieneAsignacion(nullable: true, blank: true)
    }

    /**
     * Genera un string para mostrar
     * @return el objeto limitado a 40 caracteres
     */
    String toString() {
        if (this.objeto.length() < 40)
            return this.objeto
        else
            return this.objeto.substring(0, 40) + "..."
    }

    /**
     * Genera un string para mostrar
     * @return el objeto completo
     */
    String toStringCompleto() {
        return this.objeto
    }

    /**
     * Calcula el total de inversión de las metas del marco lógico para un año dado
     * @param anio el año para el cual se quiere calcular el total de las metas
     * @return el total de inversión de las metas del marco lógico para el año dado
     */
    double totalMetasAnio(anio) {
        def metas = Meta.findAllByMarcoLogicoAndAnio(this, anio)
        def total = 0
        metas.each { m ->
            total += m.inversion
        }
        return total
    }
}