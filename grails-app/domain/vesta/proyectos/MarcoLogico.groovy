package vesta.proyectos

import vesta.parametros.TipoElemento
import vesta.parametros.UnidadEjecutora
import vesta.poa.Asignacion

/*Marco lógico con cada uno de sus componentes */

/**
 * Clase para conectar con la tabla 'mrlg' de la base de datos<br/>
 * Marco lógico con cada uno de sus componentes
 */
class MarcoLogico {
    /**
     * Proyecto del marco lógico
     */
    Proyecto proyecto
    /**
     * Tipo de elemento del marco lógico
     */
    TipoElemento tipoElemento
    /**
     * Marco lógico padre del marco lógico actual
     */
    MarcoLogico marcoLogico
    /**
     * Modificación del marco lógico
     */
    ModificacionProyecto modificacionProyecto
    /**
     * Objeto del marco lógico
     */
    String objeto
    /**
     * Monto del marco lógico
     */
    double monto
    /**
     * Padre de la modificación del marco lógico
     */
    MarcoLogico padreMod
    /**
     * Estado del marco lógico (0: activo, 1: modificado)
     */
    int estado = 0 /* 0 -> activo por facilidad en la base de datos  1-> modificado*/
    /**
     * Categoría del marco lógico
     */
    Categoria categoria;
    /**
     * Fecha de inicio del marco lógico
     */
    Date fechaInicio
    /**
     * Fecha de fin del marco lógico
     */
    Date fechaFin
    /**
     * Unidad ejecutora responsable del marco lógico
     */
    UnidadEjecutora responsable

    /**
     * Indica si tiene o no asignación en el POA (S: sí, N: no)
     */
    String tieneAsignacion = "S" //'S' - > esta en el POA (asignacion), 'N' -> no esta
    /**
     * Número del marco lógico
     */
    int numero = 0;
    /**
     * Número de componente del marco lógico
     */
    String numeroComp;

    /**
     * Define los campos que se van a ignorar al momento de hacer logs
     */
    static auditable = [ignore: []]

    /**
     * Define el mapeo entre los campos del dominio y las columnas de la base de datos
     */
    static mapping = {
        table 'mrlg'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'mrlg__id'
        id generator: 'identity'
        version false
        columns {
            id column: 'mrlg__id'
            proyecto column: 'proy__id'
            tipoElemento column: 'tpel__id'
            marcoLogico column: 'mrlgpdre'
            modificacionProyecto column: 'mdfc__id'
            objeto column: 'mrlgobjt'
            monto column: 'mrlgmnto'
            estado column: 'mrlgetdo'
            padreMod column: 'mrlgpdmd'
            categoria column: 'ctgr__id'
            fechaInicio column: 'mrlgfcin'
            fechaFin column: 'mrlgfcfn'
            responsable column: 'unej__id'
            tieneAsignacion column: 'mrlgtnas'
            numero column: 'mrlgnmro'
            numeroComp column: 'mrlgnmcm'
        }
    }

    /**
     * Define las restricciones de cada uno de los campos
     */
    static constraints = {
        proyecto(blank: true, nullable: true, attributes: [mensaje: 'Proyecto'])
        tipoElemento(blank: true, nullable: true, attributes: [mensaje: 'Tipo de Elemento'])
        marcoLogico(blank: true, nullable: true, attributes: [mensaje: 'Marco lógico original (elemento) en caso de haber modificaciones'])
        modificacionProyecto(blank: true, nullable: true, attributes: [mensaje: 'Modificación'])
        objeto(size: 1..1023, blank: true, nullable: true, attributes: [mensaje: 'Objetivo, objeto o descripción del elemento'])
        monto(blank: true, nullable: true, attributes: [mensaje: 'Monto o valor planificado, se aplica sólo en actividades'])
        estado(nullable: false, blank: false)
        padreMod(nullable: true, blank: true)
        categoria(nullable: true, blank: true)
        responsable(nullable: true, blank: true)
        fechaFin(nullable: true, blank: true)
        fechaInicio(nullable: true, blank: true)
        tieneAsignacion(nullable: true, blank: true)
        numeroComp(nullable: true, blank: true)
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

    def getTotalPriorizado() {
        def total = 0
        if (this.tipoElemento.id == 3) {
            Asignacion.findAllByMarcoLogico(this).each {
                total += it.priorizado
            }
            return total
        } else {
            def marcos = MarcoLogico.findAllByMarcoLogico(this)
            if (marcos.size() > 0) {
                Asignacion.findAllByMarcoLogicoInList(marcos).each { a ->
                    total += a.priorizado
                }
                return total
            } else {
                return 0
            }
        }
    }

    def getTotalPlanificado() {
        def total = 0
        if (this.tipoElemento.id == 3) {
            Asignacion.findAllByMarcoLogico(this).each {
                total += it.planificado
            }
            return total
        } else {
            def marcos = MarcoLogico.findAllByMarcoLogico(this)
            if (marcos.size() > 0) {
                Asignacion.findAllByMarcoLogicoInList(marcos).each { a ->
                    total += a.planificado
                }
                return total
            } else {
                return 0
            }
        }
    }

    def getAvanceFisico() {
        if (this.tipoElemento.id == 3) {
            /*actividad*/
            println "-->actividad!!! "
            def avance = 0
            def totalP = this.getTotalPriorizado()
            println "total marco " + totalP
            def asgs = Asignacion.findAllByMarcoLogicoAndPriorizadoGreaterThan(this, 0)
            def representacion = 0
            asgs.each { a ->
                representacion = a.priorizado * 100 / totalP
                def avanceAsig = a.getAvanceFisico()
                println "Asignacion " + a.marcoLogico + "representacion " + representacion + " avance " + avanceAsig
                avance += representacion * avanceAsig / 100
            }
            println "return " + avance
            return avance
        } else {
            return 0
        }
    }

    def getTotalCronograma() {
        def cronos = Cronograma.findAllByMarcoLogico(this)
        def total = 0
        cronos.each { c ->
            total += c.valor + c.valor2
        }
        return total
    }

}