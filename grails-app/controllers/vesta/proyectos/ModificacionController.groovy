package vesta.proyectos


import vesta.parametros.PresupuestoUnidad
import vesta.parametros.UnidadEjecutora
import vesta.parametros.poaPac.Anio
import vesta.parametros.TipoElemento
import vesta.parametros.TipoResponsable
import vesta.parametros.poaPac.Fuente
import vesta.parametros.poaPac.Mes
import vesta.parametros.poaPac.Presupuesto
import vesta.parametros.poaPac.ProgramaPresupuestario
import vesta.poa.Asignacion
import vesta.poa.Componente
import vesta.poa.ProgramacionAsignacion
import vesta.seguridad.Persona

/**
 * Controlador
 */
class ModificacionController  {

    def kerberosService, modificacionesService


    /**
     * Acción
     */
    def modificacion = {
        /*
        tipos:
        1 --> fin
        2 --> proposito
        3 --> indicador
        4 --> meta
        5 --> supuesto
        6 --> actividad
        7 --> medio de verificacion
        8 --> componente
         */
        if (session.modificacion && session?.modificacion?.estado == 2) {
            def mod = session.modificacion
            def datos = Modificables.findAllByModificacionAndFechaIsNull(mod)

            println "datos " + datos


            def objs = []

            datos.each { dato ->
                def tipo = dato.tipo
                def id = dato.id_remoto

                def obj
                def m = [:]

                switch (tipo) {
                    case 3: //indicador
                        obj = Indicador.get(id)
                        break;
                    case 4: //meta
                        obj = Meta.get(id)
                        break;
                    case 5: //supuesto
                        obj = Supuesto.get(id)
                        break;
                    case 7:
                        obj = MedioVerificacion.get(id)
                        break;
                    default:
                        obj = MarcoLogico.get(id)

                        break;
                }
                m.obj = obj
                m.tipo = tipo
                objs.add(m)
            }
            return [objs: objs]
        } else {
            redirect(controller: "modificacionProyecto", action: "listaAprobadas")
        }
    }


    /**
     * Acción
     */
    def modTechos = {
        println "mod techos "+params
        def unidad = UnidadEjecutora.get(params.id)
        def actual
        if (params.anio) {
            actual = Anio.get(params.anio)
        } else {
            actual = Anio.findByAnio(new Date().format("yyyy"))
        }
        def techo = PresupuestoUnidad.findByUnidadAndAnio(unidad,actual)
        [unidad:unidad,techo:techo,actual: actual]
    }


    /**
     * Acción
     */
    def modTechoCorreintes = {
        println "mod corr "+params
        def techo = PresupuestoUnidad.get(params.id)
        if (techo.maxCorrientes!=params.valor.toDouble()){
            def mod =  new ModificacionTechos()
            mod.desde=techo
            mod.fecha = new Date()
            mod.tipo = 3
            mod.usuario=session.usuario
            mod.valor=params.valor.toDouble()
            if(mod.save(flush: true)){
                techo.maxCorrientes=params.valor.toDouble()
                techo.save(flush: true)
            }else{
                println "error mod "+mod.errors
            }
        }
        render "ok"

    }

    /**
     * Acción
     */
    def modTechoInversiones = {
        println "mod inv "+params
        def techo = PresupuestoUnidad.get(params.id)
        if (techo.maxInversion!=params.valor.toDouble()){
            def mod =  new ModificacionTechos()
            mod.desde=techo
            mod.fecha = new Date()
            mod.tipo = 4
            mod.usuario=session.usuario
            mod.valor=params.valor.toDouble()-techo.maxInversion
            if(mod.save(flush: true)){
                techo.maxInversion=params.valor.toDouble()
                techo.save(flush: true)
            }else{
                println "error mod "+mod.errors
            }
        }
        render "ok"
    }

    /**
     * Acción
     */
    def guardarModificacion = {
        if (request.method == 'POST') {
            //println "Guardar modificaciones "+session.modificacion
            if (session.modificacion && session?.modificacion?.estado == 2) {
                def errores = []
                def band = false
                def datos = params.datos.trim().split("ZXY")
                datos.each {
                    //println "dato "+it
                    def partes = it.trim().split("XYZ")
                    def dato = ""
                    try {
                        dato = partes[2]
                    } catch (e) {
                        dato = ""
                    }
                    //println "partes "+partes
                    def obj
                    switch (partes[0]) {
                        case "3": //indicador
                            obj = Indicador.get(partes[1].toInteger())
                            def nuevo = new Indicador([marcoLogico: obj.marcoLogico, cantidad: obj.cantidad, descripcion: dato, modificacion: session.modificacion])
                            obj.estado = 1
                            obj = kerberosService.saveObject(obj, Indicador, session.perfil, session.usuario, "guardarModificacion", "modificacion", session)
                            nuevo = kerberosService.saveObject(nuevo, Indicador, session.perfil, session.usuario, "guardarModificacion", "modificacion", session)
                            if (obj.errors.getErrorCount() != 0 && nuevo.errors.getErrorCount() != 0) {
                                errores.add(obj.errors)
                                errores.add(nuevo.errors)
                                band = false
                            } else {
                                band = true
                                MedioVerificacion.findAllByIndicador(obj, 0).each {
                                    println "cambiando hijos indi " + it.id
                                    it.indicador = nuevo
                                    def md = kerberosService.saveObject(it, MedioVerificacion, session.perfil, session.usuario, "guardarModificacion", "modificacion", session)
                                    if (md.errors.getErrorCount() != 0)
                                        band = false
                                }

                            }
                            break;
                        case "4": //meta
                            obj = Meta.get(partes[1])
                            break;
                        case "5": //supuesto
                            obj = Supuesto.get(partes[1].toInteger())
                            def nuevo = new Supuesto([marcoLogico: obj.marcoLogico, descripcion: dato, modificacion: session.modificacion])
                            obj.estado = 1
                            obj = kerberosService.saveObject(obj, Supuesto, session.perfil, session.usuario, "guardarModificacion", "modificacion", session)
                            nuevo = kerberosService.saveObject(nuevo, Supuesto, session.perfil, session.usuario, "guardarModificacion", "modificacion", session)
                            if (obj.errors.getErrorCount() != 0 && nuevo.errors.getErrorCount() != 0) {
                                band = false
                                errores.add(obj.errors)
                                errores.add(nuevo.errors)
                            } else {
                                band = true
                            }
                            break;
                        case "7":
                            obj = MedioVerificacion.get(partes[1].toInteger())
                            def nuevo = new MedioVerificacion([indicador: obj.indicador, descripcion: dato, modificacion: session.modificacion])
                            obj.estado = 1
                            obj = kerberosService.saveObject(obj, MedioVerificacion, session.perfil, session.usuario, "guardarModificacion", "modificacion", session)
                            nuevo = kerberosService.saveObject(nuevo, MedioVerificacion, session.perfil, session.usuario, "guardarModificacion", "modificacion", session)
                            if (obj.errors.getErrorCount() != 0 && nuevo.errors.getErrorCount() != 0) {
                                band = false
                                errores.add(obj.errors)
                                errores.add(nuevo.errors)
                            } else {
                                band = true
                            }
                            break;
                        default:
                            obj = MarcoLogico.get(partes[1].toInteger())
                            obj.estado = 1
                            obj = kerberosService.saveObject(obj, MarcoLogico, session.perfil, session.usuario, "guardarModificacion", "modificacion", session)
                            def nuevo = new MarcoLogico([proyecto: obj.proyecto, objeto: dato, tipoElemento: obj.tipoElemento, marcoLogico: obj.marcoLogico, modificacionProyecto: session.modificacion])
                            nuevo.padreMod = obj
                            nuevo = kerberosService.saveObject(nuevo, MarcoLogico, session.perfil, session.usuario, "guardarModificacion", "modificacion", session)


                            if (obj.errors.getErrorCount() != 0 && nuevo.errors.getErrorCount() != 0) {
                                errores.add(obj.errors)
                                errores.add(nuevo.errors)
                                band = false

                            } else {
                                band = true
                                Indicador.findAllByMarcoLogicoAndEstado(obj, 0).each {
                                    println "cambiando hijos indi " + it.id
                                    it.marcoLogico = nuevo
                                    def indi = kerberosService.saveObject(it, Indicador, session.perfil, session.usuario, "guardarModificacion", "modificacion", session)
                                    if (indi.errors.getErrorCount() != 0)
                                        band = false
                                }

                                Supuesto.findAllByMarcoLogicoAndEstado(obj, 0).each {
                                    println "cambiando hijos sup" + it.id
                                    it.marcoLogico = nuevo
                                    def sup = kerberosService.saveObject(it, Supuesto, session.perfil, session.usuario, "guardarModificacion", "modificacion", session)
                                    if (sup.errors.getErrorCount() != 0)
                                        band = false
                                }
                                if (nuevo.tipoElemento.id.toInteger() == 2) {

                                    MarcoLogico.findAllByMarcoLogicoAndEstado(obj, 0).each {
                                        println "cambiando hijos ml" + it.id
                                        it.marcoLogico = nuevo
                                        def act = kerberosService.saveObject(it, MarcoLogico, session.perfil, session.usuario, "guardarModificacion", "modificacion", session)
                                        if (act.errors.getErrorCount() != 0)
                                            band = false
                                    }
                                }

                                if (nuevo.tipoElemento.id.toInteger() == 3) {

                                    Asignacion.findAllByMarcoLogico(obj) {
                                        println "cambiando hijos asg" + it.id
                                        it.marcoLogico = nuevo
                                        def asg = kerberosService.saveObject(it, Asignacion, session.perfil, session.usuario, "guardarModificacion", "modificacion", session)
                                        if (asg.errors.getErrorCount() != 0)
                                            band = false
                                    }
                                }
                            }
                            break;
                    }
                }
                println "errores " + errores
                if (band && errores.size() == 0) {
                    session.modificacion.estado = 3
                    kerberosService.saveObject(session.modificacion, ModificacionProyecto, session.perfil, session.usuario, "guardarDatosMarco", "modificacionProyecto", session)
                    session.modificacion = null
                    render "ok"
                } else {
                    render "Error al procesar la modificación. Revice los datos ingresados"
                }


            } else {
                render "noSession"
            }
        } else {
            redirect(controller: "shield", action: "ataques")
        }
    }

    /**
     * Acción
     */
    def modificarCronograma = {
        if (session.modificacion && session?.modificacion?.estado == 2) {
            println "nuevo cronograma " + params
            def colores = ["#DD7B42", "#FFAB48", "#FFE7AD", "#A7C9AE", "#888A63"]
            def proyecto = Proyecto.get(params.id)
            def componentes = MarcoLogico.findAll("from MarcoLogico where proyecto=${proyecto.id} and tipoElemento=2 and estado=0 order by id")
            def fuentes = Financiamiento.findAllByProyecto(proyecto).fuente
            def anio
            if (!params.anio)
                anio = Anio.findByAnio(new Date().format("yyyy").toString())
            else
                anio = Anio.get(params.anio)
            if (!anio)
                anio = Anio.findAll("from Anio order by anio").pop()
            println "anio " + anio
            [proyecto: proyecto, componentes: componentes, anio: anio, fuentes: fuentes, colores: colores]
        } else {
            redirect(controller: "modificacionProyecto", action: "listaAprobadas")
        }
    }






    /**
     * Acción
     */
    def guardarModificacionCronograma = {
        if (session.modificacion && session?.modificacion?.estado == 2) {
            params.modificacion = session.modificacion.id
            params.session = session
            println params
            modificacionesService.agregarModificacionCronograma(params)
            render(params.id)
        } else {
            redirect(controller: "modificacionProyecto", action: "listaAprobadas")
        }
    }

    /**
     * Acción
     */
    def terminarModificacionCronograma = {
        def err = modificacionesService.saveModificacion()
        if (err[0] < 1 && err[1] == 0) {
            session.modificacion.estado = 3
            kerberosService.saveObject(session.modificacion, ModificacionProyecto, session.perfil, session.usuario, "terminarModificacionCronograma", "modificacion", session)
            session.modificacion = null
            flash.message = "Modificaciones guardadas exitosamente"
            flash.clase = "message"
            modificacionesService.reset()
        } else {
            flash.message = "Ha ocurrido un error al guardar sus modificaciones."
            flash.clase = "error"
        }
        redirect(controller: "modificacionProyecto", action: "listaAprobadas")
    }


    /**
     * Acción
     */
    def modificarPresupuesto = {
        println "modificar presupuesto"
        if (session.modificacion && session?.modificacion?.estado == 2) {


        } else {
            redirect(controller: "shield", action: "ataques")
        }
    }

    /**
     * Acción
     */
    def nuevaAsignacionCorrienteMod = {
        def band = true

        if (!session.unidad) {
            redirect(controller: 'login', action: 'logout')
        }

        if (!band) {
            response.sendError(404)
        } else {

            def unidad = UnidadEjecutora.get(params.id)
            def fuentes = Fuente.list([sort: 'descripcion'])
            def programas = ProgramaPresupuestario.list()
            programas = programas.sort { it.codigo.toInteger()}
            def actual, programa
            def componentes = Componente.list([sort: 'descripcion'])
//            def componente
            if (params.anio) {
                actual = Anio.get(params.anio)
            } else {
                actual = Anio.findByAnio(new Date().format("yyyy"))
            }


            if (params.programa) {
                programa = ProgramaPresupuestario.get(params.programa)
            }
            if (params.componente)
                componente = Componente.get(params.componente)

            if (!actual) {
                actual = Anio.list([sort: 'anio', order: 'desc']).pop()
            }
            if (!programa) {
                programa = programas[0]
            }
//        def asignaciones = Asignacion.findAll("from Asignacion where anio=${actual.id} and unidad=${unidad.id} and marcoLogico is null and actividad is not null order by id")

            def c = Asignacion.createCriteria()

            def asignaciones = c.list {
                and {
                    eq("anio", actual)
                    eq("unidad", unidad)
                    eq("programa", programa)
                    isNull("marcoLogico")
                }
                order("id", "asc")
            }

            c = Asignacion.createCriteria()
            def asgs = c.list {
                and {
                    eq("anio", actual)
                    eq("unidad", unidad)
                    isNull("marcoLogico")
                }
            }

            if (params.todo == "1") {
                asignaciones = asgs
            }

            def total = 0
            asgs.each { asg ->
                total += ((asg.redistribucion == 0) ? asg.planificado.toDouble() : asg.redistribucion.toDouble())
            }

            def maxUnidad
            def max
            if (PresupuestoUnidad.findByUnidadAndAnio(unidad, actual)) {
                max = PresupuestoUnidad.findByUnidadAndAnio(unidad, actual)
                maxUnidad = max.maxCorrientes
            } else {
                maxUnidad = 0
            }

            [unidad: unidad, actual: actual, asignaciones: asignaciones, fuentes: fuentes, programas: programas, programa: programa, totalUnidad: total, maxUnidad: maxUnidad, componentes: componentes, max: max]
        }
    }

    /**
     * Acción
     */
    def guardarAsignacionMod = {
        println "params guadr asignacion " + params

        params.planificado = params.planificado.replaceAll("\\.", "")
        params.planificado = params.planificado.replaceAll(",", "\\.")
        params.planificado = params.planificado.toDouble()
        def band = true
        if (params.componente.id == "-1") {
            params.remove("componente.id")
            band = false
        }

        def asg
        if (params.id) {
            asg = Asignacion.get(params.id)
            asg.properties = params
            if (!band) {
                asg.componente = null
            }
        } else {
            asg = new Asignacion(params)

        }
//        def asignaciones = Asignacion.findAllByMarcoLogicoAndAnio(asg.marcoLogico,asg.anio)
        //        println "asignaciones "+asignaciones

        asg = kerberosService.saveObject(asg, Asignacion, session.perfil, session.usuario, "guardarAsignacionMod", "modificacion", session)
        if (asg.errors.getErrorCount() == 0) {
            def mod = new ModificacionAsignacion()
            mod.desde = asg
            mod.recibe = null
            mod.valor = asg.planificado
            mod.fecha = new Date()
            mod = kerberosService.saveObject(mod, ModificacionAsignacion, session.perfil, session.usuario, "guardarAsignacionMod", "modificacion", session)
            render guardarPras(asg)
        } else {
            render 0
        }

    }

    /**
     * Acción
     */
    def guardarReasignacion = {
        println "reasignacion " + params
        def f = request.getFile('archivo')
        def path = servletContext.getRealPath("/") + "modificacionesPoa/"
        new File(path).mkdirs()

        if (f && !f.empty) {
            def fileName = f.getOriginalFilename()
            def ext

            def parts = fileName.split("\\.")
            fileName = ""
            parts.eachWithIndex { obj, i ->
                if (i < parts.size() - 1) {
                    fileName += obj
                } else {
                    ext = obj
                }
            }
            def reps = [
                    "a": "[àáâãäåæ]",
                    "e": "[èéêë]",
                    "i": "[ìíîï]",
                    "o": "[òóôõöø]",
                    "u": "[ùúûü]",

                    "A": "[ÀÁÂÃÄÅÆ]",
                    "E": "[ÈÉÊË]",
                    "I": "[ÌÍÎÏ]",
                    "O": "[ÒÓÔÕÖØ]",
                    "U": "[ÙÚÛÜ]",

                    "n": "[ñ]",
                    "c": "[ç]",

                    "N": "[Ñ]",
                    "C": "[Ç]",

                    "": "[\\!@\\\$%\\^&*()='\"\\/<>:;\\.,\\?]",

                    "_": "[\\s]"
            ]

            reps.each { k, v ->
                fileName = (fileName.trim()).replaceAll(v, k)
            }

            fileName = fileName + "_" + new Date().format("hh_mm_ss") + "." + "pdf"

            def pathFile = path + File.separatorChar + fileName
            def src = new File(pathFile)
            def msn

            if (src.exists()) {
                msn = "Ya existe un archivo con ese nombre. Por favor cámbielo."
                if (params.tipoPag)
                    redirect(action: 'poaInversionesMod', params: [msn: msn, id: params.unidad])
                else
                    redirect(action: 'poaCorrientesMod', params: [msn: msn, id: params.unidad])


            } else {

                if (params.destino != "") {
                    println "si destino " + params.destino
                    def origen = Asignacion.get(params.origen)
                    def destino = Asignacion.get(params.destino)
                    def mod = new ModificacionAsignacion()
                    mod.desde = origen
                    mod.recibe = destino
                    mod.valor = params.monto.toDouble()
                    mod.fecha = new Date()
                    f.transferTo(new File(pathFile))
                    mod.pdf = fileName
                    origen.planificado = origen.planificado - params.monto.toDouble()
                    destino.planificado = destino.planificado + params.monto.toDouble()

                    origen = kerberosService.saveObject(origen, Asignacion, session.perfil, session.usuario, "guardarReasignacion", "modificacion", session)
                    destino = kerberosService.saveObject(destino, Asignacion, session.perfil, session.usuario, "guardarReasignacion", "modificacion", session)
                    //guardarPras(origen)
                    //guardarPras(destino)
                    mod = kerberosService.saveObject(mod, Asignacion, session.perfil, session.usuario, "guardarReasignacion", "modificacion", session)
                    def unidad = origen.unidad
                    def unidadDestino = destino.unidad
                    if (unidad.id.toInteger() != unidadDestino.id.toInteger()) {
                        def maxOrigen = PresupuestoUnidad.findByAnioAndUnidad(origen.anio, unidad)
                        maxOrigen.maxCorrientes = maxOrigen.maxCorrientes - params.monto.toDouble()
                        def maxDestino = PresupuestoUnidad.findByAnioAndUnidad(origen.anio, unidadDestino)
                        maxDestino.maxCorrientes = maxDestino.maxCorrientes + params.monto.toDouble()
                        def modT = new ModificacionTechos()
                        modT.tipo = 1
                        modT.usuario = session.usuario
                        modT.desde = maxOrigen
                        modT.recibe = maxDestino
                        modT.valor = params.monto.toDouble()
                        modT.fecha = new Date()
                        maxOrigen = kerberosService.saveObject(maxOrigen, PresupuestoUnidad, session.perfil, session.usuario, "guardarReasignacion", "modificacion", session)
                        maxDestino = kerberosService.saveObject(maxDestino, PresupuestoUnidad, session.perfil, session.usuario, "guardarReasignacion", "modificacion", session)
                        modT = kerberosService.saveObject(modT, ModificacionTechos, session.perfil, session.usuario, "guardarReasignacion", "modificacion", session)
                    }
                    msn = "Modificación procesada"
                    if (params.tipoPag)
                        redirect(action: 'poaInversionesMod', params: [msn: msn, id: params.unidad])
                    else
                        redirect(action: 'poaCorrientesMod', params: [msn: msn, id: params.unidad])


                } else {
                    println "no destino"
                    def origen = Asignacion.get(params.origen)
                    def mod = new ModificacionAsignacion()
                    mod.desde = origen
                    mod.recibe = null
                    mod.valor = params.monto.toDouble()
                    mod.fecha = new Date()
                    f.transferTo(new File(pathFile))
                    mod.pdf = fileName
                    mod.unidad = UnidadEjecutora.get(params.unidadInv)
                    origen.planificado = origen.planificado - params.monto.toDouble()
                    origen = kerberosService.saveObject(origen, Asignacion, session.perfil, session.usuario, "guardarReasignacion", "modificacion", session)
                    //guardarPras(origen)
                    mod = kerberosService.saveObject(mod, Asignacion, session.perfil, session.usuario, "guardarReasignacion", "modificacion", session)
                    def unidad = origen.unidad
                    def maxOrigen = PresupuestoUnidad.findByAnioAndUnidad(origen.anio, unidad)
                    maxOrigen.maxCorrientes = maxOrigen.maxCorrientes - params.monto.toDouble()
                    def maxDestino = PresupuestoUnidad.findByAnioAndUnidad(origen.anio, mod.unidad)
                    if (maxDestino)
                        maxDestino.maxInversion = maxDestino.maxInversion + params.monto.toDouble()
                    else {
                        maxDestino = new PresupuestoUnidad()
                        maxDestino.maxInversion = params.monto.toDouble()
                        maxDestino.anio = origen.anio
                        maxDestino.unidad = mod.unidad
                        maxDestino.maxCorrientes = 0

                    }
                    def modT = new ModificacionTechos()
                    modT.tipo = 2
                    modT.usuario = session.usuario
                    modT.desde = maxOrigen
                    modT.recibe = maxDestino
                    modT.valor = params.monto.toDouble()
                    modT.fecha = new Date()
                    maxOrigen = kerberosService.saveObject(maxOrigen, PresupuestoUnidad, session.perfil, session.usuario, "guardarReasignacion", "modificacion", session)
                    maxDestino = kerberosService.saveObject(maxDestino, PresupuestoUnidad, session.perfil, session.usuario, "guardarReasignacion", "modificacion", session)
                    modT = kerberosService.saveObject(modT, ModificacionTechos, session.perfil, session.usuario, "guardarReasignacion", "modificacion", session)

                    msn = "Modificación procesada"
                    if (params.tipoPag)
                        redirect(action: 'poaInversionesMod', params: [msn: msn, id: params.unidad])
                    else
                        redirect(action: 'poaCorrientesMod', params: [msn: msn, id: params.unidad])
                }


            }
        }


    }
    /**
     * Acción
     */
    def guardarReasignacionYachay = {
        println "reasignacion " + params
        def f = request.getFile('archivo')
        def path = servletContext.getRealPath("/") + "modificacionesPoa/"
        new File(path).mkdirs()

        if (f && !f.empty) {
            def fileName = f.getOriginalFilename()
            def ext

            def parts = fileName.split("\\.")
            fileName = ""
            parts.eachWithIndex { obj, i ->
                if (i < parts.size() - 1) {
                    fileName += obj
                } else {
                    ext = obj
                }
            }
            def reps = [
                    "a": "[àáâãäåæ]",
                    "e": "[èéêë]",
                    "i": "[ìíîï]",
                    "o": "[òóôõöø]",
                    "u": "[ùúûü]",

                    "A": "[ÀÁÂÃÄÅÆ]",
                    "E": "[ÈÉÊË]",
                    "I": "[ÌÍÎÏ]",
                    "O": "[ÒÓÔÕÖØ]",
                    "U": "[ÙÚÛÜ]",

                    "n": "[ñ]",
                    "c": "[ç]",

                    "N": "[Ñ]",
                    "C": "[Ç]",

                    "": "[\\!@\\\$%\\^&*()='\"\\/<>:;\\.,\\?]",

                    "_": "[\\s]"
            ]

            reps.each { k, v ->
                fileName = (fileName.trim()).replaceAll(v, k)
            }

            fileName = fileName + "_" + new Date().format("hh_mm_ss") + "." + "pdf"

            def pathFile = path + File.separatorChar + fileName
            def src = new File(pathFile)
            def msn

            if (src.exists()) {
                msn = "Ya existe un archivo con ese nombre. Por favor cámbielo."
                if (params.tipoPag)
                    redirect(action: 'poaInversionesMod', params: [msn: msn, id: params.unidad])
                else
                    redirect(action: 'poaCorrientesMod', params: [msn: msn, id: params.unidad])


            } else {

                if (params.destino != "") {
                    println "si destino " + params.destino
                    def origen = Asignacion.get(params.origen)
                    def destino = Asignacion.get(params.destino)
                    def mod = new ModificacionAsignacion()
                    mod.desde = origen
                    mod.recibe = destino
                    mod.valor = params.monto.toDouble()
                    mod.fecha = new Date()
                    f.transferTo(new File(pathFile))
                    mod.pdf = fileName
                    origen.priorizado = origen.priorizado - params.monto.toDouble()
                    destino.priorizado = destino.priorizado + params.monto.toDouble()

                    origen = kerberosService.saveObject(origen, Asignacion, session.perfil, session.usuario, "guardarReasignacion", "modificacion", session)
                    destino = kerberosService.saveObject(destino, Asignacion, session.perfil, session.usuario, "guardarReasignacion", "modificacion", session)
                    //guardarPras(origen)
                    //guardarPras(destino)
                    mod = kerberosService.saveObject(mod, Asignacion, session.perfil, session.usuario, "guardarReasignacion", "modificacion", session)

                    msn = "Modificación procesada"

                    redirect(action: 'poaInversionesMod', params: [msn: msn, id: params.proyecto])



                }


            }
        }


    }


    /**
     * Acción
     */
    def poaInversionesMod = {

        def band = false
        def unidad = UnidadEjecutora.findByPadreIsNull()
        def proyecto = Proyecto.get(params.id)
        def marcos = MarcoLogico.findAllByProyectoAndTipoElemento(proyecto,TipoElemento.get(3))
        //println "marcos "+marcos
        band = true


        if (!band) {
            response.sendError(403)
        } else {

            def fuentes = Fuente.list([sort: 'descripcion'])

            def actual, programa
            def componentes = Componente.list([sort: 'descripcion'])
//            def componente
            if (params.anio) {
                actual = Anio.get(params.anio)
            } else {
                actual = Anio.findByAnio(new Date().format("yyyy"))
            }


            if (!actual) {
                actual = Anio.list([sort: 'anio', order: 'desc']).pop()
            }

//        def asignaciones = Asignacion.findAll("from Asignacion where anio=${actual.id} and unidad=${unidad.id} and marcoLogico is null and actividad is not null order by id")

            def c = Asignacion.createCriteria()
            def asignaciones = c.list {
                and {
                    eq("anio", actual)
                    inList("marcoLogico",marcos)
                }
                order("id", "asc")
            }

            c = Asignacion.createCriteria()

            def total = 0
            asignaciones.each { asg ->
                total += asg.priorizado
            }
            def maxUnidad
            def max
            if (PresupuestoUnidad.findByUnidadAndAnio(unidad, actual)) {
                max = PresupuestoUnidad.findByUnidadAndAnio(unidad, actual)
                maxUnidad = max.maxInversion
            } else {
                maxUnidad = 0
            }

            [unidad: unidad, actual: actual, asignaciones: asignaciones, fuentes: fuentes,  totalUnidad: total, maxUnidad: maxUnidad, max: max, msn: params.msn,proyecto: proyecto]
        }


    }

    /**
     * Acción
     */
    def poaCorrientesMod = {

        def band = false
        def unidad = UnidadEjecutora.get(params.id)
        def usuario = Usro.get(session.usuario.id)

        if (usuario.id.toInteger() == 3 || usuario.unidad.id == 85) {
            band = true
        } else {

            def resp = ResponsableProyecto.findAllByUnidadAndTipo(unidad, TipoResponsable.findByCodigo("I"))
            // println "resp "+resp
            def r = []
            def ahora = new Date()
            resp.each {
                if (it.desde.before(ahora) && it.hasta.after(ahora))
                    r.add(it)
            }
            r.each {rp ->
                //println "r -> "+rp
                if (rp.responsable.id.toInteger() == session.usuario.id.toInteger())
                    band = true

            }
        }

        if (!band) {
            response.sendError(403)
        } else {

            def fuentes = Fuente.list([sort: 'descripcion'])
            def programas = ProgramaPresupuestario.list()
            programas = programas.sort { it.codigo.toInteger()}
            def actual, programa
            def componentes = Componente.list([sort: 'descripcion'])
//            def componente
            if (params.anio) {
                actual = Anio.get(params.anio)
            } else {
                actual = Anio.findByAnio(new Date().format("yyyy"))
            }
            if (params.programa) {
                programa = ProgramaPresupuestario.get(params.programa)
            }
            if (params.componente)
                componente = Componente.get(params.componente)
            if (!actual) {
                actual = Anio.list([sort: 'anio', order: 'desc']).pop()
            }
            if (!programa) {
                programa = programas[0]
            }
//        def asignaciones = Asignacion.findAll("from Asignacion where anio=${actual.id} and unidad=${unidad.id} and marcoLogico is null and actividad is not null order by id")

            def c = Asignacion.createCriteria()
            def asignaciones = c.list {
                and {
                    eq("anio", actual)
                    eq("unidad", unidad)
                    eq("programa", programa)
                    isNull("marcoLogico")
                }
                order("id", "asc")
            }

            c = Asignacion.createCriteria()
            def asgs = c.list {
                and {
                    eq("anio", actual)
                    eq("unidad", unidad)
                    isNull("marcoLogico")
                }
            }
            if (params.todo == "1") {
                asignaciones = asgs
                asignaciones = asignaciones.sort {it.id}
            }
            def total = 0
            asgs.each { asg ->
                total += ((asg.redistribucion == 0) ? asg.planificado.toDouble() : asg.redistribucion.toDouble())
            }
            def maxUnidad
            def max
            if (PresupuestoUnidad.findByUnidadAndAnio(unidad, actual)) {
                max = PresupuestoUnidad.findByUnidadAndAnio(unidad, actual)
                maxUnidad = max.maxCorrientes
            } else {
                maxUnidad = 0
            }

            [unidad: unidad, actual: actual, asignaciones: asignaciones, fuentes: fuentes, programas: programas, programa: programa, totalUnidad: total, maxUnidad: maxUnidad, componentes: componentes, max: max, msn: params.msn]
        }


    }

    def guardarPras(asg) {
        if (asg) {
            def total = (asg.redistribucion == 0) ? (asg.planificado) : (asg.redistribucion)
            def valor = (total / 12).toFloat().round(2)
            def residuo = 0
            if (valor * 12 != total) {
                residuo = (total.toDouble() - valor.toDouble() * 12).toFloat().round(2)
            }
            println "total " + total + " valor " + valor + " res " + residuo
//            println "calc "+ (valor.toDouble()*12)
//            println "calc 2 "+ (total-valor*12).toFloat().round(2)

            12.times {
                def mes = Mes.get(it + 1)
                ProgramacionAsignacion.findByAsignacionAndMes(asg, mes)?.delete(flush: true)
                def programacion = new ProgramacionAsignacion()
                programacion.asignacion = asg
                programacion.mes = mes
                if (it < 11) {
                    programacion.valor = valor
                } else {
                    programacion.valor = valor + residuo
                }
                programacion = kerberosService.saveObject(programacion, ProgramacionAsignacion, session.perfil, session.usuario, "guardarAsignacion", "asignacion", session)
            }
            return asg.id
        } else {
            return 0
        }
    }

    /**
     * Acción
     */
    def buscarAsignacion = {
        println "buscar asignacion " + params
        def unidad
        def prsp
        def anio = Anio.get(params.anio)
        def res = []
        if (params.unidad == "-1") {
            if (params.partida != "") {
                println "no unidad anio y partida"
                prsp = Presupuesto.get(params.partida)
                def temp = Asignacion.findAllWhere(presupuesto: prsp, anio: anio, marcoLogico: null)
                if (temp)
                    res += temp
            } else {
                println "no unidad solo anio"
                def temp = Asignacion.findAllByAnioAndMarcoLogicoIsNull(anio, [sort: "id", max: 30])
                if (temp)
                    res += temp
            }
        } else {
            unidad = UnidadEjecutora.get(params.unidad)
            if (params.partida != "") {
                println "anio partida y unidad"
                prsp = Presupuesto.get(params.partida)
                def temp = Asignacion.findAllWhere(anio: anio, presupuesto: prsp, unidad: unidad, marcoLogico: null)
                if (temp)
                    res += temp
            } else {
                println "anio y unidad " + anio + " " + unidad
                def temp = Asignacion.findAllWhere(anio: anio, unidad: unidad, marcoLogico: null)
                if (temp)
                    res += temp
            }
        }
        println "res " + res
        [res: res]

    }


    /**
     * Acción
     */
    def buscarAsignacionInversion = {
        println "buscar asignacion " + params
        def unidad
        def prsp
        def anio = Anio.get(params.anio)
        def res = []
        if (params.unidad == "-1") {
            if (params.partida != "") {
                println "no unidad anio y partida"
                prsp = Presupuesto.get(params.partida)
                def temp = Asignacion.findAll("from Asignacion where presupuesto = ${prsp.id} and  anio= ${anio.id}and  marcoLogico is not null ")
                if (temp)
                    res += temp
            } else {
                println "no unidad solo anio"
                def temp = Asignacion.findAllByAnioAndMarcoLogicoIsNotNull(anio, [sort: "id", max: 30])
                if (temp)
                    res += temp
            }
        } else {
            unidad = UnidadEjecutora.get(params.unidad)
            if (params.partida != "") {
                println "anio partida y unidad"
                prsp = Presupuesto.get(params.partida)
                def temp = Asignacion.findAll("from Asignacion where presupuesto = ${prsp.id} and  anio= ${anio.id} and unidad=${unidad.id} and  marcoLogico is not null ")
                if (temp)
                    res += temp
            } else {
                println "anio y unidad " + anio + " " + unidad
                def temp = Asignacion.findAll("from Asignacion where   anio= ${anio.id} and unidad=${unidad.id} and  marcoLogico is not null ")
                if (temp)
                    res += temp
            }
        }
//        println "res " + res
        [res: res]

    }





    /**
     * Acción
     */
    def programacionAsignacionesMod = {
        def unidad = UnidadEjecutora.get(params.id)
        def band = false
        def usuario = Usro.get(session.usuario.id)

        if (usuario.id.toInteger() == 3 || usuario.unidad.id == 85) {
            band = true
        } else {

            def resp = ResponsableProyecto.findAllByUnidadAndTipo(unidad, TipoResponsable.findByCodigo("I"))
            // println "resp "+resp
            def r = []
            def ahora = new Date()
            resp.each {
                if (it.desde.before(ahora) && it.hasta.after(ahora))
                    r.add(it)
            }
            r.each {rp ->
                //println "r -> "+rp
                if (rp.responsable.id.toInteger() == session.usuario.id.toInteger())
                    band = true

            }
        }
        if (!band) {
            response.sendError(403)
        } else {
            def actual
            if (params.anio)
                actual = Anio.get(params.anio)
            else
                actual = Anio.findByAnio(new Date().format("yyyy"))
            if (!actual)
                actual = Anio.list([sort: 'anio', order: 'desc']).pop()

            def asgProy = Asignacion.findAll("from Asignacion where unidad=${unidad.id} and marcoLogico is not null and anio=${actual.id} and reubicada!='S' order by id")
            def asgCor = Asignacion.findAll("from Asignacion where unidad=${unidad.id} and actividad is not null and anio=${actual.id} and marcoLogico is null order by id")
            def max = PresupuestoUnidad.findByUnidadAndAnio(unidad, actual)
            def meses = []
            12.times {meses.add(it + 1)}
            [unidad: unidad, corrientes: asgCor, inversiones: asgProy, actual: actual, meses: meses, max: max]
        }
    }



    /**
     * Acción
     */
    def guardarProgramacionMod = {

        def asig = Asignacion.get(params.asignacion)
        def datos = params.datos.split(";")
        datos.each {
            def partes = it.split(":")

            def prog = ProgramacionAsignacion.findByAsignacionAndMes(asig, Mes.get(partes[0]))
            if (!prog) {
                prog = new ProgramacionAsignacion()
                prog.asignacion = asig
                prog.mes = Mes.get(partes[0])
            }
            prog.valor = partes[1].toDouble()
            prog = kerberosService.saveModificacion(prog, ProgramacionAsignacion, session.usuario, session)
            println "errores" + prog.errors


        }
        render "ok"
    }



    /**
     * Acción
     */
    def verModificacionesPoa = {
        def unidad = UnidadEjecutora.get(params.id)
        def actual
        if (params.anio)
            actual = Anio.get(params.anio)
        else
            actual = Anio.findByAnio(new Date().format("yyyy"))
        if (!actual)
            actual = Anio.list([sort: 'anio', order: 'desc']).pop()


        def res = []

        Asignacion.findAllWhere(unidad: unidad, anio: actual).each {asg ->
            ModificacionAsignacion.findAllByDesdeOrRecibe(asg, asg, [sort: "id"]).each {mod ->
                res.add(mod)
            }
        }

        res.sort{it.id}

        return [res: res, unidad: unidad, actual: actual]

    }

    /**
     * Acción
     */
    def descargaDocumento = {
        def mod = ModificacionAsignacion.get(params.id)
        def path = servletContext.getRealPath("/") + "modificacionesPoa/" + mod.pdf

        def src = new File(path)
        if (src.exists()) {
            response.setContentType("application/octet-stream")
            response.setHeader("Content-disposition", "attachment;filename=${src.getName()}")

            response.outputStream << src.newInputStream()
        } else {
            render "archivo no encontrado"
        }
    }

    /**
     * Acción
     */
    def reversar = {
        def ids = params.asgn
        def resultado = new ArrayList()
        def asgn = ModificacionAsignacion.findAll("from ModificacionAsignacion where id in ($ids)").sort {it.id}
        return [resultado: asgn]
    }

    /**
     * Acción
     */
    def reversaAsignacion = {
        println "reversaAsignacion parametros:" + params
        def dsde = 0
        def rcbe = 0
        def ids = params.ids.split(',').toList()
        ids.each {
            def md = ModificacionAsignacion.get(it)
            def valor = md.valor;
            if (md.desde.unidad?.id && md.recibe?.unidad?.id) {  //no hay recibe si se trata de pasar recursos a inversiones
                println "modificacion de corrientes a corrientes"
                dsde = md.desde.planificado + valor
                rcbe = md.recibe.planificado - valor
                md.desde.planificado = dsde
                md.save()
                md.recibe.planificado = rcbe
                md.save()
                md.valor = 0
                md.save()
                println " los valores a grabar son: asignacion desde: $dsde, asignación que recibe: $rcbe"
                if (md.desde.unidad?.id != md.recibe.unidad?.id) { //pasa de una unidad  a otra => modifican techos
                    def pruedsde = PresupuestoUnidad.findByUnidadAndAnio(md.desde.unidad, md.desde.anio)
                    def pruercbe = PresupuestoUnidad.findByUnidadAndAnio(md.recibe.unidad, md.recibe.anio)
                    def mdtc = ModificacionTechos.findWhere(desde: pruedsde, recibe: pruercbe, valor: valor)
                    mdtc.delete()
                    println " se borrara la modificacion de techo: $mdtc.id con $mdtc.valor de $pruedsde.unidad recibe: $pruercbe.unidad"
                    println "valor: ${pruedsde?.maxCorrientes} se suma ${valor}"
                    println "valor: ${pruercbe?.maxCorrientes} se resta ${valor}"
                    pruedsde.maxCorrientes += valor
                    pruercbe.maxCorrientes -= valor
                    pruedsde.save()
                    pruercbe.save()
                } // ELSE: misma unidad, no hay modificación de techos

            } else { // inversiones
                println "modificacion de corrientes a inversión"
                // se debe restaurar el valor planificado de la asgnDSDE
                // 1. asgnplan += mdasvlor
                // 2. poner cero registro de MDTC
                // 2. Diminuir valor de techo de inversiones
                println " los valores a grabar son: asignacion desde: $md.desde, recibe unidad: $md.unidad"
                println " desde Unidad: ${md.desde.unidad?.id}, recibe: ${md.unidad?.id}"
                def pruedsde = PresupuestoUnidad.findByUnidadAndAnio(md.desde.unidad, md.desde.anio)
                def pruercbe = PresupuestoUnidad.findByUnidadAndAnio(md.unidad, md.desde.anio)
                def mdtc = ModificacionTechos.findWhere(desde: pruedsde, recibe: pruercbe, valor: valor)
                if (mdtc) mdtc.delete()
                println " se borrara la modificacion de techo: $mdtc?.id con $mdtc?.valor desde $pruedsde?.unidad, con $pruedsde?.maxCorrientes recibe: $pruercbe?.unidad"
                println "valor: ${pruedsde?.maxCorrientes} se suma ${valor}"
                println "valor: ${pruercbe?.maxCorrientes} se resta ${valor}"

                dsde = md.desde.planificado + valor
                md.desde.planificado = dsde
                md.valor = 0
                md.save()   // ojo: si no se hace save, igual se graba en la base de datos


                pruedsde.maxCorrientes += valor
                pruercbe.maxInversion -= valor
                pruedsde.save()
                pruercbe.save()
            }

        }
        render "ok, vuelva a cargar esta página para no cometes errores de Repetir reversados"
    }

    /**
     * Acción
     */
    def reversarTechos = {
        def resultado = new ArrayList()
        def mdtc = ModificacionTechos.findAllByIdBetween(68, 71).sort {it.id}
        return [resultado: mdtc]
    }


    /**
     * Acción
     */
    def reversaTechosCorr = {

        /** solo sirve para modificacion de techos de corrientes **/

        println "reversaAsignacion parametros:" + params
        def dsde = 0
        def rcbe = 0
        def ids = params.ids.split(',').toList()
        ids.each {
            def md = ModificacionTechos.get(it)
            dsde = md.desde.maxCorrientes + md.valor
            rcbe = md.recibe.maxCorrientes - md.valor

            md.desde.maxCorrientes = dsde
            md.save()
            md.recibe.maxCorrientes = rcbe
            md.save()
            md.valor = 0
            md.save()

            println "valor: ${md.desde?.maxCorrientes} se reversa a: ${dsde}"
            println "valor: ${md.recibe?.maxCorrientes} se reversa a: ${rcbe}"
        }
        render "ok"


    }

    /**
     * Acción
     */

    def modificar_ajax () {
        def proyecto = Proyecto.get(params.id)
        return [proyecto: proyecto]

    }

    /**
     * Acción
     */

    def buscarAsg_ajax () {

    }

    /**
     * Acción
     */

    def buscarPartida_ajax (){

    }





}

