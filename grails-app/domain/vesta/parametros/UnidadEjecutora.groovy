package vesta.parametros

import vesta.parametros.geografia.Provincia
import vesta.parametros.poaPac.Anio
import vesta.parametros.proyectos.ObjetivoUnidad
import vesta.poa.Asignacion
import vesta.proyectos.MarcoLogico
import vesta.proyectos.Proyecto

/*Unidades ejecutoras de los proyectos, generalmente adscritas a los ministerios*/
/**
 * Clase para conectar con la tabla 'unej' de la base de datos<br/>
 * Unidades ejecutoras de los proyectos, generalmente adscritas a los ministerios
 */
class UnidadEjecutora {
    /**
     * Tipo de institución de la unidad ejecutora
     */
    TipoInstitucion tipoInstitucion
    /**
     * Provincia en la cual se encuentra la unidad ejecutora
     */
    Provincia provincia
    /**
     * Código de la unidad ejecutora
     */
    String codigo
    /**
     * Fecha de inicio
     */
    Date fechaInicio
    /**
     * Fecha de fin
     */
    Date fechaFin

    /**
     * Unidad ejecutora padre de la actual
     */
    UnidadEjecutora padre

    /**
     * Nombre de la unidad ejecutora
     */
    String nombre
    /**
     * Dirección de la unidad ejecutora
     */
    String direccion
    /**
     * Sigla de la unidad ejecutora
     */
    String sigla
    /**
     * Objetivo de la unidad ejecutora
     */
    String objetivo
    /**
     * Número de teléfono de la unidad ejecutora
     */
    String telefono
    /**
     * Número de fax de la unidad ejecutora
     */
    String fax
    /**
     * Dirección e-mail de la unidad ejecutora
     */
    String email
    /**
     * Observaciones
     */
    String observaciones

    /**
     * Orden para mostrar
     */
    int orden

    /**
     * Objetivo de la unidad
     */
    ObjetivoUnidad objetivoUnidad
    /**
     * Número de la última solicitud de reforma al poa
     */
    Integer numeroSolicitudReforma = 0
    /**
     * Número de la última solicitud de reforma al gasto permanente
     */
    Integer numeroSolicitudReformaGp = 0
    /**
     * Número de la última solicitud de aval poa
     */
    Integer numeroSolicitudAval = 0
    /**
     * Número de la última solicitud de aval poa gasto permanente
     */
    Integer numeroSolicitudAvalGp = 0
    /**
     * Número de Aval emitido
     */
    Integer numeroAval = 0
    /**
     * Número de Aval emitido gasto permanente
     */
//    Integer numeroAvalGp = 0

    /**
     * Define los campos que se van a ignorar al momento de hacer logs
     */
    static auditable = [ignore: []]

    /**
     * Define el mapeo entre los campos del dominio y las columnas de la base de datos
     */
    static mapping = {
        table 'unej'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'unej__id'
        id generator: 'identity'
        version false
        columns {
            id column: 'unej__id'
            tipoInstitucion column: 'tpin__id'
            provincia column: 'prov__id'
            codigo column: 'unejcdgo'
            fechaInicio column: 'unejfcin'
            fechaFin column: 'unejfcfn'
            padre column: 'unejpdre'

            nombre column: 'unejnmbr'
            direccion column: 'unejdire'
            sigla column: 'unejsgla'            /* no se usa */
            objetivo column: 'unejobjt'
            telefono column: 'unejtelf'
            fax column: 'unejfaxx'
            email column: 'unejmail'
            observaciones column: 'unejobsr'

            orden column: 'unejordn'

            objetivoUnidad column: 'obun__id'

            numeroSolicitudReforma column: 'unejnmsr'
            numeroSolicitudAval    column: 'unejnmsa'
            numeroAval    column: 'unejnmav'
            numeroSolicitudReformaGp column: 'unejgprf'
            numeroSolicitudAvalGp column: 'unejgpsa'
//            numeroAvalGp column: 'unejgpav'

        }
    }

    /**
     * Define las restricciones de cada uno de los campos
     */
    static constraints = {
        tipoInstitucion(blank: false, nullable: false, attributes: [mensaje: 'Tipo de institución'])
        provincia(blank: true, nullable: true, attributes: [mensaje: 'Provincia de la unidad ejecutora'])
        codigo(maxSize: 6, blank: true, nullable: true, attributes: [mensaje: 'Código interno en la Institución'])
        fechaInicio(blank: true, nullable: true, attributes: [mensaje: 'Fecha de creación'])
        fechaFin(blank: true, nullable: true, attributes: [mensaje: 'Fecha de cierre o final'])
        padre(blank: true, nullable: true, attributes: [mensaje: 'Unidad Ejecutora padre'])

        nombre(size: 1..127, blank: false, attributes: [mensaje: 'Nombre de la entidad o ministerio'])
        direccion(size: 1..127, blank: true, nullable: true, attributes: [mensaje: 'Dirección de la entidad o ministerio'])
        sigla(size: 1..7, blank: true, nullable: true, attributes: [mensaje: 'Sigla identificativa'])
        objetivo(size: 1..1023, blank: true, nullable: true, attributes: [mensaje: 'Objetivo institucional o de la entidad'])
        telefono(size: 1..63, blank: true, nullable: true, attributes: [mensaje: 'Teléfonos, se los separa con “;”'])
        fax(size: 1..63, blank: true, nullable: true, attributes: [mensaje: 'Números de fax, se los separa con “;”'])
        email(size: 1..63, blank: true, nullable: true, attributes: [mensaje: 'Dirección de correo electrónico institucional'])
        observaciones(size: 1..127, blank: true, nullable: true, attributes: [mensaje: 'Observaciones'])

        objetivoUnidad(blank: true, nullable: true, attributes: [mensaje: "Objetivo de la unidad"])
    }

    /**
     * Genera un string para mostrar
     * @return el nombre
     */
    String toString() {
        return this.nombre
    }

    def getSiguienteNumeroSolicitudReforma() {
        this.numeroSolicitudReforma = this.numeroSolicitudReforma + 1
        this.save(flush: true)
        return this.numeroSolicitudReforma
    }

    def getSiguienteNumeroSolicitudReformaGp() {
        this.numeroSolicitudReformaGp = this.numeroSolicitudReformaGp + 1
        this.save(flush: true)
        return this.numeroSolicitudReformaGp
    }

    UnidadEjecutora getGerencia() {
        def gerencia = this
        def padre = this.padre
//        def codigosNo = ['343', '9999'] // yachay, Gerencia general, Gerencia tecnica
        def codigosNo = ['343', 'GG'] // yachay, Gerencia general, Gerencia tecnica
        if (!codigosNo.contains(padre.codigo)) {
            gerencia = padre
        }
//        println "gerencia++: $gerencia"
        return gerencia
    }

    def getUnidadYGerencia() {
        def ret = [unidad: this, gerencia: this.gerencia]
        return ret
    }

    def getUnidades() {
        def padre = this.padre
//        println "getUnidades -- padre: ${padre.codigo}"
        def unidades = [this]
        def codigosNo = ['343', 'GG', 'GT'] // yachay, Gerencia general, Gerencia tecnica
        if (!codigosNo.contains(padre.codigo)) {
            unidades += padre
            unidades += UnidadEjecutora.findAllByPadre(padre)
        } else if(this.codigo != 'GG') {
            unidades += UnidadEjecutora.findAllByPadre(this)
        }
//        println "---------unidades: $unidades"
        return unidades.unique().sort { it.nombre }
    }

    def getUnidadesPorPerfil(String perfilCodigo) {
        def perfilesAll = ["GAF", "ASPL", "GP", "DP"]
        //gerencia administrativa financiera, Analista de Planificación, Gerencia de Planificación
        def unidades = []
        if (perfilesAll.contains(perfilCodigo)) {
            unidades = UnidadEjecutora.list()
        } else {
            def padre = this.padre
            unidades = [this]
            def codigosNo = ['343', 'GG', 'GT'] // yachay, Gerencia general, Gerencia tecnica
            if (!codigosNo.contains(padre.codigo)) {
                unidades += padre
                unidades += UnidadEjecutora.findAllByPadre(padre)
            } else {
                unidades += UnidadEjecutora.findAllByPadre(this)
            }
        }
        return unidades.unique().sort { it.nombre }
    }

    def getAsignacionesUnidad(Anio anio, String perfilCodigo) {
        def unidades = this.getUnidadesPorPerfil(perfilCodigo)
//        println "unidades: ${unidades.nombre} ${unidades.id}"
        def asignaciones = Asignacion.withCriteria {
            eq("anio", anio)
            inList("unidad", unidades)
            isNotNull("marcoLogico")
        }

        return asignaciones.unique()
    }

    List<Proyecto> getProyectosUnidad(Anio anio, String perfilCodigo) {
//        println "anio " + anio + " perf " + perfilCodigo
        def asignaciones = this.getAsignacionesUnidad(anio, perfilCodigo)
        def proyectos = []
        def proyectos2 = []
        def i

        asignaciones.each { e ->
            i = e.marcoLogico?.proyecto?.id
            if (!proyectos2.contains(i)) {
                proyectos2.add(i)
            }
        }
        proyectos2.each {
            proyectos += Proyecto.get(it)
        }
        return proyectos.unique().sort { it.nombre }
    }

    def getComponentesUnidadProyecto(Anio anio, Proyecto proyecto, String perfilCodigo) {
//        println "anio: $anio, proyecto: ${proyecto.id}, perfil: $perfilCodigo"
        def asignaciones = this.getAsignacionesUnidad(anio, perfilCodigo)
        def componentes = []
        def componentes2 = []

//        println "getComponentesUnidadProyecto asignaciones: ${asignaciones.marcoLogico.objeto}"
        asignaciones.each { f ->
            def p2 = f.marcoLogico.proyecto
            def c2 = f.marcoLogico.marcoLogico.id
            if (p2.id == proyecto.id && !componentes2.contains(c2)) {
                componentes2.add(c2)
            }

        }
        componentes2.each {
            componentes += MarcoLogico.get(it)
        }
        return componentes.unique().sort { it.objeto }
    }

    def getActividadesUnidadComponente(Anio anio, MarcoLogico componente, String perfilCodigo) {
        def asignaciones = this.getAsignacionesUnidad(anio, perfilCodigo)
        def actividades = []
        def actividades2 = []
//        println "asignaciones: ${asignaciones.id}"
        asignaciones.each { b ->
            def c3 = b.marcoLogico.marcoLogico
            def act2 = b.marcoLogico.id
            if (c3.id == componente.id && !actividades2.contains(act2)) {
                actividades2.add(act2)
            }
        }
        actividades2.each {
            actividades += MarcoLogico.get(it)
        }
        return actividades.unique().sort { it.numero }
    }

    def getAsignacionesUnidadActividad(Anio anio, MarcoLogico actividad, String perfilCodigo) {
        def asignaciones = this.getAsignacionesUnidad(anio, perfilCodigo)
        def asg = []
        asignaciones.each { a ->
            def act = a.marcoLogico
            if (act.id == actividad.id && !asg.contains(act)) {
                asg.add(a)
            }
        }
        return asg.unique()
    }
}