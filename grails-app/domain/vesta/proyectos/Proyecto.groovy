package vesta.proyectos

import vesta.parametros.*
import vesta.parametros.poaPac.Anio
import vesta.parametros.poaPac.ProgramaPresupuestario
import vesta.parametros.proyectos.ObjetivoGobiernoResultado
import vesta.parametros.proyectos.Programa
import vesta.poa.Asignacion

/*Proyecto*/
/**
 * Clase para conectar con la tabla 'proy' de la base de datos
 */
class Proyecto {
    /**
     * Unidad ejecutora del proyecto
     */
    UnidadEjecutora unidadEjecutora
    /**
     * Etapa del proyecto
     */
    Etapa etapa
    /**
     * Fase del proyecto
     */
    Fase fase
    /**
     * Tipo de producto del proyecto
     */
    TipoProducto tipoProducto
    /**
     * Estado del proyecto
     */
    EstadoProyecto estadoProyecto
    /**
     * Línea del proyecto
     */
    Linea linea
    /**
     * Tipo de inverisón del proyecto
     */
    TipoInversion tipoInversion
    /**
     * Cobertura del proyecto
     */
    Cobertura cobertura
    /**
     * Calificación del proyecto
     */
    Calificacion calificacion
    /**
     * Programa del proyecto
     */
    Programa programa
    /**
     * Código del proyecto
     */
    String codigoProyecto
    /**
     * Fecha de registro del proyecto
     */
    Date fechaRegistro
    /**
     * Fecha de modificación del proyecto
     */
    Date fechaModificacion
    /**
     * Nombre del proyecto
     */
    String nombre
    /**
     * Monto del proyecto
     */
    Double monto
    /**
     * Producto del proyecto
     */
    String producto
    /**
     * Descripción del proyecto
     */
    String descripcion
    /**
     * Fecha de inicio planificada del proyecto
     */
    Date fechaInicioPlanificada
    /**
     * Fecha de inicio real del proyecto
     */
    Date fechaInicio
    /**
     * Fecha de fin planificada del proyecto
     */
    Date fechaFinPlanificada
    /**
     * Fecha de fin real del proyecto
     */
    Date fechaFin
    /**
     * Mes
     */
    Integer mes = 1
    /**
     * Problema del proyecto
     */
    String problema
    /**
     * Información días
     */
    Integer informacionDias = 0
    /**
     * Subprograma del proyecto
     */
    String subPrograma
    /**
     * Aprobado
     */
    String aprobado
    /**
     * Aprobado POA
     */
    String aprobadoPoa
    /**
     * Objetivo estratégico del proyecto
     */
    ObjetivoEstrategicoProyecto objetivoEstrategico
    /**
     * Eje programático del proyecto
     */
    EjeProgramatico ejeProgramatico
    /**
     * L&iacute;nea base del proyecto
     */
    String lineaBase
    /**
     * Población objetivo del proyecto
     */
    String poblacionObjetivo
    /**
     * Objetivo gobierno resultado del proyecto
     */
    ObjetivoGobiernoResultado objetivoGobiernoResultado
    /**
     * Programa presupuestario del proyecto
     */
    ProgramaPresupuestario programaPresupuestario
    /**
     * Código ESIGEF del proyecto
     */
    String codigoEsigef

    /**
     * Unidad administradora
     */
    UnidadEjecutora unidadAdministradora
    /**
     * Protafolio
     */
    Portafolio portafolio
    /**
     Código
     */
    String codigo
    /**
     * Estrategia
     */
    Estrategia estrategia
    /**
     * Justificación
     */
    String justificacion

    /**
     * Define los campos que se van a ignorar al momento de hacer logs
     */
    static auditable = [ignore: []]

    /**
     * Define el mapeo entre los campos del dominio y las columnas de la base de datos
     */
    static mapping = {
        table 'proy'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'proy__id'
        id generator: 'identity'
        version false
        columns {
            id column: 'proy__id'
            unidadEjecutora column: 'unej__id'
            etapa column: 'etpa__id'
            fase column: 'fase__id'
            tipoProducto column: 'tppd__id'
            estadoProyecto column: 'edpy__id'
            linea column: 'lnea__id'
            tipoInversion column: 'tpiv__id'
            cobertura column: 'cbrt__id'
            calificacion column: 'calf__id'
            programa column: 'prgr__id'
            codigoProyecto column: 'proy_cup'
            fechaRegistro column: 'proyfcrg'
            fechaModificacion column: 'proyfcmf'
            nombre column: 'proynmbr'
            monto column: 'proymnto'
            producto column: 'proyprdt'
            descripcion column: 'proydscr'
            fechaInicioPlanificada column: 'proyfipl'
            fechaInicio column: 'proyfcin'
            fechaFinPlanificada column: 'proyffpl'
            fechaFin column: 'proyfcfn'
            mes column: 'proymess'
            problema column: 'proyprbl'
            informacionDias column: 'proyifdd'
            subPrograma column: 'proysbpr'
            aprobado column: 'proyapbd'
            aprobadoPoa column: 'proyappa'

            objetivoEstrategico column: 'obes__id'
            ejeProgramatico column: 'ejpg__id'
            lineaBase column: 'proylnbs'
            poblacionObjetivo column: 'pbob'

            objetivoGobiernoResultado column: 'obgr__id'

            programaPresupuestario column: 'pgps__id'

            codigoEsigef column: 'proysigf'

            unidadAdministradora column: 'proyunad'
            portafolio column: 'prtf__id'
            codigo column: 'proycdgo'
            estrategia column: 'estr__id'
            justificacion column: 'proyjust'

        }
    }

    /**
     * Define las restricciones de cada uno de los campos
     */
    static constraints = {
        unidadEjecutora(blank: true, nullable: true, attributes: [mensaje: 'Unidad Ejecutora'])
        etapa(blank: true, nullable: true, attributes: [mensaje: 'Etapa'])
        fase(blank: true, nullable: true, attributes: [mensaje: 'Fase'])
        tipoProducto(blank: true, nullable: true, attributes: [mensaje: 'Tipo de Producto'])
        estadoProyecto(blank: true, nullable: true, attributes: [mensaje: 'Estado del Proyecto'])
        linea(blank: true, nullable: true, attributes: [mensaje: 'Lineamiento de inversión'])
        tipoInversion(blank: true, nullable: true, attributes: [mensaje: 'Tipo de Inversión'])
        cobertura(blank: true, nullable: true, attributes: [mensaje: 'Cobertura'])
        calificacion(blank: true, nullable: true, attributes: [mensaje: 'Calificación'])
        programa(blank: true, nullable: true, attributes: [mensaje: 'Programa al que pertenece'])
        codigoProyecto(unique: true, size: 1..24, blank: true, nullable: true, attributes: [mensaje: 'CUP (código único del proyecto según la Senplades)'])
        fechaRegistro(blank: true, nullable: true, attributes: [mensaje: 'Fecha de Registro en la SENPLADES'])
        fechaModificacion(blank: true, nullable: true, attributes: [mensaje: 'Fecha de Modificación del proyecto'])
        nombre(size: 1..255, blank: false, nullable: false, attributes: [mensaje: 'Nombre del proyecto'])
        monto(blank: true, nullable: true, attributes: [mensaje: 'Monto total del proyecto'])
        producto(size: 1..1023, blank: true, nullable: true, attributes: [mensaje: 'Producto principal del proyecto'])
        descripcion(size: 1..1024, blank: true, nullable: true, attributes: [mensaje: 'Descripción del proyecto'])
        fechaInicioPlanificada(blank: true, nullable: true, attributes: [mensaje: 'Fecha de inicio según el plan o programada'])
        fechaInicio(blank: true, nullable: true, attributes: [mensaje: 'Fecha de Inicio real'])
        fechaFinPlanificada(blank: true, nullable: true, attributes: [mensaje: 'Fecha de finalización según el plan o programada'])
        fechaFin(blank: true, nullable: true, attributes: [mensaje: 'Fecha de finalización real'])
        mes(blank: true, nullable: true, attributes: [mensaje: 'Duración del proyecto en meses'])
        problema(size: 1..1024, blank: true, nullable: true, attributes: [mensaje: 'Problema que ataca el proyecto'])
        informacionDias(blank: true, nullable: true, attributes: [mensaje: 'Periodo de información en días para control de informes que debe enviar el responsable'])
        subPrograma(size: 1..2, blank: true, nullable: true, attributes: [mensaje: 'Subprograma al que pertenece, según el ESIGEF'])
        aprobado(size: 0..1, blank: true, nullable: true, attributes: [mensaje: 'Aprobado o no'])
        aprobadoPoa(size: 0..1, blank: true, nullable: true, attributes: [mensaje: 'Aprobado poa'])

        objetivoEstrategico(blank: true, nullable: true, attributes: [mensaje: 'Objetivo Estratégico'])
        ejeProgramatico(size: 0..1023, blank: true, nullable: true, attributes: [mensaje: 'Eje Programático del proyecto'])
        lineaBase(size: 0..1023, blank: true, nullable: true, attributes: [mensaje: 'Línea Base del proyecto'])
        poblacionObjetivo(size: 0..1023, blank: true, nullable: true, attributes: [mensaje: 'Población objetivo del proyecto'])

        objetivoGobiernoResultado(blank: true, nullable: true, attributes: [mensaje: 'Objetivos de gobierno por resultados'])

        programaPresupuestario(blank: true, nullable: true, attributes: [mensaje: 'Programa presupuestario'])

        codigoEsigef(size: 0..3, blank: true, nullable: true, attributes: [mensaje: 'Número proyecto eSIGEF'])

        unidadAdministradora(blank: true, nullable: true, attributes: [mensaje: 'Unidad administradora'])
        portafolio(blank: true, nullable: true, attributes: [mensaje: 'Portafolio'])
        codigo(blank: true, nullable: true, attributes: [mensaje: 'Código'])
        estrategia(blank: true, nullable: true, attributes: [mensaje: 'Estrategia'])
        justificacion(size: 0..1023, blank: true, nullable: true, attributes: [mensaje: 'Justificación del Proyecto'])
    }

    /**
     * Genera un string para mostrar
     * @return el nombre limitado a 20 caracteres
     */
    String toString() {
        if (nombre.size() > 20) {
            def partes = nombre.split(" ")
            def cont = 0
            def des = ""
            partes.each {
                cont += it.size()
                if (cont < 22)
                    des += " " + it
            }
            return des + "... "

        } else {
            return "${this.nombre}"
        }

    }

    /**
     * Genera un string para mostrar
     * @return el nombre limitado a 40 caracteres
     */
    String toStringMedio() {
        if (nombre.size() > 40) {
            def partes = nombre.split(" ")
            def cont = 0
            def des = ""
            partes.each {
                cont += it.size()
                if (cont < 40)
                    des += " " + it
            }
            return des + "... "

        } else {
            return "${this.nombre}"
        }

    }

    /**
     * Genera un string para mostrar
     * @return el nombre limitado a 65 caracteres
     */
    String toStringLargo() {
        if (nombre.size() > 65) {
            def partes = nombre.split(" ")
            def cont = 0
            def des = ""
            partes.each {
                cont += it.size()
                if (cont < 65)
                    des += " " + it
            }
            return des + "... "

        } else {
            return "${this.nombre}"
        }

    }

    /**
     * Genera un string para mostrar
     * @return el nombre completo
     */
    String toStringCompleto() {
        return this.nombre
    }

    /**
     * Busca las metas de un proyecto
     * @return un mapa: [metasCoords: las coordenadas de las metas, metasTotal: las metas]
     */
    def getMetas() {
        def metas = [], metasCoords = []
        MarcoLogico.findAllByProyectoAndTipoElemento(this, TipoElemento.get(2)).each { ml ->
            metas += Meta.findAllByMarcoLogico(ml)
            metasCoords += Meta.withCriteria {
                eq('marcoLogico', ml)
                or {
                    ne('latitud', 0.toDouble())
                    ne('longitud', 0.toDouble())
                }
            }
        }
        return [metasCoords: metasCoords, metasTotal: metas]
    }

    def getValorPriorizado() {
        def total = 0
        def marcos = MarcoLogico.findAllByProyectoAndTipoElemento(this, TipoElemento.get(3))
        if (marcos.size() > 0) {
            marcos.each { m ->
                total += m.getTotalPriorizado()
            }
//            Asignacion.findAllByMarcoLogicoInList(marcos).each { a ->
//                total += a.priorizado
//            }
            return total
        } else {
            return 0
        }
    }

    def getValorPlanificado() {
        def total = 0
        def marcos = MarcoLogico.findAllByProyectoAndTipoElemento(this, TipoElemento.get(3))
        if (marcos.size() > 0) {
            marcos.each { m ->
                total += m.getTotalPlanificado()
            }
            return total
        } else {
            return 0
        }
    }

    def getValorPlanificadoAnio(Anio anio) {
//        println "PROYECTO " + this.nombre
        def total = 0
        def marcos = MarcoLogico.findAllByProyectoAndTipoElemento(this, TipoElemento.get(3))
        if (marcos.size() > 0) {
            marcos.each { m ->
                total += m.getTotalPlanificadoAnio(anio)
            }
//            println "TOTAL = " + total
            return total
        } else {
            return 0
        }
    }

}