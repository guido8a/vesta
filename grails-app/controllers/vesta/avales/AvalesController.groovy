package vesta.avales

import vesta.parametros.Auxiliar
import vesta.parametros.Unidad
import vesta.parametros.poaPac.Anio
import vesta.poa.Asignacion
import vesta.proyectos.MarcoLogico
import vesta.proyectos.Proyecto
import vesta.parametros.UnidadEjecutora
import vesta.alertas.Alerta
import vesta.seguridad.Firma
import vesta.seguridad.Persona
import vesta.seguridad.Prfl
import vesta.seguridad.Sesn
import vesta.seguridad.Persona

/**
 * Controlador que muestra las pantallas de manejo de avales
 */
class AvalesController extends vesta.seguridad.Shield {

    def mailService

    /**
     * Acción que muestra la pantalla de lista de procesos por proyecto
     * @param proyecto el id del proyecto. Si no existe el proyecto muestra la lista de todos los procesos
     */
    def procesos = {
//        println "procesos " + params
        def proyecto = null
        if (params.proyecto)
            proyecto = Proyecto.get(params.proyecto)
        def procesos = []
        if (proyecto) {
            procesos = ProcesoAval.findAllByProyecto(proyecto)
        } else {
            procesos = ProcesoAval.list([sort: "nombre"])
        }
        [proyecto: proyecto, procesos: procesos]
    }

    /**
     * Acción que muestra la pantalla que permite crear un nuevo proceso o modificar uno existente
     * @param id el id del proceso en caso de que se quiera modificar uno existente
     * @param anio el id del año. Si no existe el año tomará el actual
     */
    def crearProceso_ajax = {
        def proceso
        def actual
        def band = true
        def proyectos = []
        def unidad = session.usuario.unidad
        Asignacion.findAllByUnidad(unidad).each {
            def p = it.marcoLogico.proyecto
            if (!proyectos.contains(p)) {
                proyectos.add(p)
            }
        }
        proyectos.sort { it.nombre }
        if (params.anio)
            actual = Anio.get(params.anio)
        else
            actual = Anio.findByAnio(new Date().format("yyyy"))
        if (params.id) {
            proceso = ProcesoAval.get(params.id)
            def aval = Aval.findAllByProceso(proceso)

            aval.each {
                //println "aval "+it.estado.descripcion+"  "+it.estado.codigo
                if (it.estado?.codigo == "E01" || it.estado?.codigo == "E02" || it.estado.codigo == "E05" || it.estado.codigo == "E06" || it.estado.codigo == "EF1" || it.estado.codigo == "EF4") {
                    band = false
                }
            }
        }

        [proyectos: proyectos, proceso: proceso, actual: actual, band: band, unidad: unidad]
    }

    /**
     * Acción que muestra la pantalla que permite crear modificar una asignacion
     */

    def editarAsignacion() {
        def band = params.band
        def asg = ProcesoAsignacion.get(params.id)
        [band: band, asg: asg, max: params.max]

    }

    /**
     * Acción llamada con ajax que muestra las asignaciones de un proceso
     * @param id el id del proceso
     */
    def getDetalle = {
        def proceso
        def detalle = []
        proceso = ProcesoAval.get(params.id)
        detalle = ProcesoAsignacion.findAllByProceso(proceso, [sort: "id"])
        def aval = Aval.findAllByProceso(proceso)
        def band = true
        aval.each {
            //println "aval "+it.estado.descripcion+"  "+it.estado.codigo
            if (it.estado?.codigo == "E01" || it.estado?.codigo == "E02" || it.estado.codigo == "E05" || it.estado.codigo == "E06") {
                band = false
            }
        }
        [proceso: proceso, detalle: detalle, band: band]
    }

    /**
     * Acción que guarda el proceso y redirecciona a la acción crearProceso una vez completado.
     */
    def saveProceso = {
        println "save proceso " + params
        params.fechaInicio = new Date().parse("dd-MM-yyyy", params.fechaInicio_input)
        params.fechaFin = new Date().parse("dd-MM-yyyy", params.fechaFin_input)
        def proceso
        if (params.id)
            proceso = ProcesoAval.get(params.id)
        else
            proceso = new ProcesoAval()
        proceso.properties = params
        if (!proceso.save(flush: true)) {
            render "ERROR*Ha ocurrido un error al guardar el proceso: " + renderErrors(bean: proceso)
            return
        } else {
            def texto
            if (params.id) {
                texto = "Actualización de proceso exitosa"
            } else {
                texto = "Creación de proceso exitosa"
            }
            render "SUCCESS*" + texto
            return
        }
    }

    /**
     * Acción llamada con ajax que permite agregar una asignación (ProcesoAsignacion) a un proceso
     * @param proceso el id del ProcesoAval
     * @param monto el monto de la asignación
     * @param id el id del ProcesoAsignacion en caso de que sea edición
     * @Renders "ok"
     */
    def agregarAsignacion = {
        println "agregar asg " + params
        def proceso = ProcesoAval.get(params.proceso)
        def asg = Asignacion.get(params.asg)
        def monto = params.monto.toDouble()
        def detalle = new ProcesoAsignacion()
        if (params.id && params.id != "")
            detalle = ProcesoAsignacion.get(params.id)
        detalle.asignacion = asg
        detalle.proceso = proceso
        detalle.monto = monto
        detalle.save(flush: true)
        render "ok"
    }

    /**
     * Acción llamada con ajax que permite eliminar una asignación (ProcesoAsignacion) de un proceso
     * @param id el id del ProcesoAsignacion a ser eliminado
     * @Renders "ok" si la eliminación se efectuó, false sino. No se permite eliminar si el proceso tiene un aval o una solicitud pendiente
     */
    def borrarDetalle = {
        println "borrar " + params
        def detalle = ProcesoAsignacion.get(params.id)
        def aval = Aval.findAllByProceso(detalle.proceso)
        def band = true
        aval.each {
            if (it.estado?.codigo == "E01" || it.estado?.codigo == "E02") {
                band = false
            }
        }
        if (band) {
            detalle.delete()
            render "ok"
        } else
            render "no"
    }

    /**
     * Acción llamada con ajax que permite modificar una asignación (ProcesoAsignacion) de un proceso
     * @param id el id del ProcesoAsignacion a ser modificado
     * @param monto el monto nuevo
     * @Renders "ok"
     */
    def editarDetalle = {
        println "edtar " + params

        def detalle = ProcesoAsignacion.get(params.id)
        detalle.monto = params.monto.toDouble()
        detalle.save(flush: true)
        render "ok"
    }

    /**
     * Acción llamada con ajax que carga las actividades (MarcoLogico) de un cierto componente y una cierta unidad
     * @param id el componente padre de las actividades
     * @param unidad el id de la unidad
     */
    def cargarActividades = {
        def comp = MarcoLogico.get(params.id)
        def unidad = UnidadEjecutora.get(params.unidad)
        [acts: MarcoLogico.findAllByMarcoLogicoAndResponsable(comp, unidad, [sort: "numero"])]
    }
    /**
     * Acción llamada con ajax que carga las asignaciones de una cierta actividad (MarcoLogico) de un cierto año
     * @param id el id de la actividad
     * @param anio el id del año
     */
    def cargarAsignaciones = {
//        println "cargar asg " + params
        def act = MarcoLogico.get(params.id)
        def anio = Anio.get(params.anio)
//        println "asgs "+ Asignacion.findAllByMarcoLogicoAndAnio(act, anio)
        [asgs: Asignacion.findAllByMarcoLogicoAndAnio(act, anio)]
    }

    /**
     * Acción llamada con ajax que calcula el monto máximo que se le puede dar a una asignación
     * @param id el id de la asignación
     * @Renders el monto priorizado meno el monto utilizado
     */
    def getMaximoAsg = {
        println "get Maximo asg " + params
        def asg = Asignacion.get(params.id)
        def monto = asg.priorizado
        def usado = 0;
        ProcesoAsignacion.findAllByAsignacion(asg).each {
            usado += it.monto
        }

        render "" + (monto - usado)
    }

    /**
     * Acción que muestra una pantalla con la lista de procesos
     */
    def listaProcesos = {
        def procesos = ProcesoAval.list([sort: "id"])
        [procesos: procesos]
    }
    /**
     * Acción que muestra una pantalla con la lista de procesos por unidad
     */
    def listaProcesosUnidad = {
        def user = Persona.get(session.usuario.id)
        def proyectos = []
        def unidad = user.unidad
        Asignacion.findAllByUnidad(unidad).each {
            def p = it.marcoLogico.proyecto
            if (!proyectos.contains(p)) {
                proyectos.add(p)
            }
        }
        proyectos.sort { it.nombre }
        def procesos = ProcesoAval.findAllByProyectoInList(proyectos, [sort: "id"])
        [procesos: procesos]
    }

    /**
     * Acción que muestra una pantalla con la lista de avales de un proceso
     * @param id el id del proceso
     */
    def avalesProceso = {
        def proceso = ProcesoAval.get(params.id)
        def avales = Aval.findAllByProceso(proceso)
        def solicitudes = SolicitudAval.findAllByProceso(proceso, [sort: "fecha"])
        [avales: avales, proceso: proceso, solicitudes: solicitudes]
    }
    /**
     * Acción que muestra una pantalla que permite crear una solicitud de aval<br/>
     * Si el proceso ya tiene un aval vigente o tiene una solicitud pendiente, no puede solicitar otro y redirecciona a la acción avalesProceso
     * @param id el id del proceso
     */
    def solicitarAval = {
        //println "solicictar aval"
        def unidad = UnidadEjecutora.get(session.unidad.id)
        def personasFirma = Persona.findAllByUnidad(unidad)
        def aux = Auxiliar.list()
        def referencial = 7000
        if (aux.size() > 0) {
            aux = aux.pop()
            referencial = aux.presupuesto * (2 * Math.pow(10, -7))
            referencial = referencial.round(2)
            println "referencial " + referencial
        }
        def numero = null
        def band = true
        numero = SolicitudAval.findAllByUnidad(session.usuario.unidad, [sort: "numero", order: "desc", max: 1])
        if (numero.size() > 0) {
            numero = numero?.pop()?.numero
        }
        if (!numero) {
            numero = 1
        } else {
            numero = numero + 1
        }
        def proceso = ProcesoAval.get(params.id)
        def now = new Date()
        if (proceso.fechaInicio < now) {
            flash.message = "Error: El proceso ${proceso.nombre}  (${proceso.fechaInicio.format('dd-MM-yyyy')} - ${proceso.fechaFin.format('dd-MM-yyyy')}) esta en ejecución, si desea solicitar un aval modifique las fechas de inicio y fin"
            redirect(action: "avalesProceso", id: proceso.id)
            return
        }

        def avales = Aval.findAllByProcesoAndEstadoInList(proceso, [EstadoAval.findByCodigo("E02"), EstadoAval.findByCodigo("E05"), EstadoAval.findByCodigo("EF1")])
        def solicitudes = SolicitudAval.findAllByProcesoAndEstadoInList(proceso, [EstadoAval.findByCodigo("E01"), EstadoAval.findByCodigo("EF4")])
        def disponible = proceso.getMonto()
//        println "aval " + avales
//        println "sols " + solicitudes
        avales.each {
            band = false
            disponible -= it.monto
        }
        solicitudes.each {
            band = false
            disponible -= it.monto
        }
//        println "band " + band
        if (!band) {
            flash.message = "Este proceso ya tiene un aval vigente o tiene una solicitud pendiente, no puede solicitar otro."
            redirect(controller: "avales", action: "avalesProceso", id: proceso?.id)
            return
        } else {
            [proceso: proceso, disponible: disponible, personas: personasFirma, numero: numero, refencial: referencial]
        }
    }

    /**
     * Acción que muestra una pantalla que permite solicitar la anulación de un aval
     */
    def solicitarAnulacion = {
        def aval = Aval.get(params.id)
        def numero = null
        def band = true
        numero = SolicitudAval.findAllByUnidad(session.usuario.unidad, [sort: "numero", order: "desc", max: 1])
        if (numero.size() > 0) {
            numero = numero?.pop()?.numero
        }
        if (!numero) {
            numero = 1
        } else {
            numero = numero + 1
        }
        def unidad = UnidadEjecutora.get(session.unidad.id)
        def personasFirma = Persona.findAllByUnidad(unidad)
        return [aval: aval, numero: numero, personas: personasFirma]
    }

    /**
     * Acción que guarda la solicitud de aval.<br/>
     * Si la solicitud se guarda correctamente redirecciona a la acción avalesProceso, caso contrario redirecciona a la acción solicitarAval
     * @param params los parámetros enviados por el submit del formulario
     */
    def guardarSolicitud = {
        println "solicitud aval " + params
        /*TODO enviar alertas*/

//        if (params.monto) {
//            params.monto = params.monto.replaceAll("\\.", "")
//            params.monto = params.monto.replaceAll(",", ".")
//        }
        def referencial = params.referencial?.toDouble()
        def montoProceso = params.monto?.toDouble()
//        println "ref "+referencial+" monto "+montoProceso
        if (montoProceso > referencial) {
            def path = servletContext.getRealPath("/") + "pdf/solicitudAval/"
            new File(path).mkdirs()
            def f = request.getFile('file')
            def okContents = [
                    'application/pdf'     : 'pdf',
                    'application/download': 'pdf'
            ]
            def nombre = ""
            def pathFile
            if (f && !f.empty) {
                def fileName = f.getOriginalFilename() //nombre original del archivo
                def ext

                def parts = fileName.split("\\.")
                fileName = ""
                parts.eachWithIndex { obj, i ->
                    if (i < parts.size() - 1) {
                        fileName += obj
                    }
                }

                ext = okContents[f.getContentType()]
                fileName = fileName.size() < 40 ? fileName : fileName[0..39]
                fileName = fileName.tr(/áéíóúñÑÜüÁÉÍÓÚàèìòùÀÈÌÒÙÇç .!¡¿?&#°"'/, "aeiounNUuAEIOUaeiouAEIOUCc_")
                if (!ext) {
                    ext = "pdf"
                }
                nombre = fileName + "." + ext
                pathFile = path + nombre
                def fn = fileName
                def src = new File(pathFile)
                def i = 1
                while (src.exists()) {
                    nombre = fn + "_" + i + "." + ext
                    pathFile = path + nombre
                    src = new File(pathFile)
                    i++
                }
                try {

                    println ">>>> " + params

                    f.transferTo(new File(pathFile)) // guarda el archivo subido al nuevo path
                    def proceso = ProcesoAval.get(params.proceso)
                    def usuFirma = Persona.get(params.firma1)

                    def monto = params.monto
                    monto = monto.toDouble()
                    def concepto = params.concepto
                    def momorando = params.memorando
                    def sol = new SolicitudAval()
                    sol.proceso = proceso
                    if (params.aval)
                        sol.aval = Aval.get(params.aval)
                    sol.usuario = session.usuario
                    sol.numero = params.numero?.toInteger()
                    sol.monto = monto
                    sol.concepto = concepto
                    sol.memo = momorando
                    sol.path = nombre
                    def firma = new Firma()
                    firma.usuario = usuFirma
                    firma.accion = "firmarSolicitud"
                    firma.controlador = "avales"

                    if (params.tipo == "A") {
                        firma.accionVer = "imprimirSolicitudAnulacionAval"
                        firma.controladorVer = "reporteSolicitud"

                        firma.documento = "SolicitudDeAnulacionDeAval_" + sol.numero
                        firma.concepto = "Solicitud de Anulación de aval del proceso: " + proceso.nombre
                    } else {
                        firma.accionVer = "imprimirSolicitudAval"
                        firma.controladorVer = "reporteSolicitud"

                        firma.documento = "SolicitudDeAval_" + sol.numero
                        firma.concepto = "Solicitud de aval del proceso: " + proceso.nombre
                    }
                    if (!firma.save(flush: true)) {
                        println "Error en firma: " + firma.errors
                    }
                    sol.firma = firma
                    sol.unidad = session.usuario.unidad
                    if (params.tipo)
                        sol.tipo = params.tipo
                    sol.fecha = new Date();
                    sol.estado = EstadoAval.findByCodigo("EF4")
                    if (!sol.save(flush: true)) {
                        println "eror save " + sol.errors
                    } else {
                        firma.idAccion = sol.id
                        firma.idAccionVer = sol.id
                        firma.save(flush: true)
                    }
                    def usuarios = Persona.findAllByUnidad(UnidadEjecutora.findByCodigo("DPI"))
                    usuarios.each { usu ->
                        def alerta = new Alerta()
                        alerta.from = session.usuario
                        alerta.persona = usu
                        alerta.fechaEnvio = new Date()
                        alerta.mensaje = "Nueva solicitud de aval"
                        alerta.controlador = "revisionAval"
                        alerta.accion = "pendientes"
                        alerta.id_remoto = sol.id
                        if (!alerta.save(flush: true)) {
                            println "error alerta: " + alerta.errors
                        }
                    }
                    try {
                        def mail = sol.firma.usuario.mail
                        if (mail) {

                            mailService.sendMail {
                                to mail
                                subject "Nueva solicitud de aval"
                                body "Tiene una solicitud de aval pendiente que requiere su firma para aprobación "
                            }

                        } else {
                            println "El usuario ${sol.firma.usuario.login} no tiene email"
                        }
                    } catch (e) {
                        println "eror email " + e.printStackTrace()
                    }
                    flash.message = "Solicitud enviada"
                    redirect(action: 'avalesProceso', params: [id: params.proceso])
                    //println pathFile
                } catch (e) {
                    println "????????\n" + e + "\n???????????"
                    e.printStackTrace()
                }


            } else {
                flash.message = "Error: Seleccione un archivo valido"
                redirect(action: 'solicitarAval', params: [asg: params.asgn])
            }
            /* fin del upload */
        } else {
            def proceso = ProcesoAval.get(params.proceso)
            def usuFirma = Persona.get(params.firma1)
            def monto = params.monto
            monto = monto.toDouble()
            def concepto = params.concepto
            def momorando = params.memorando
            def sol = new SolicitudAval()
            sol.proceso = proceso
            if (params.aval)
                sol.aval = Aval.get(params.aval)
            sol.usuario = session.usuario
            sol.numero = params.numero?.toInteger()
            sol.monto = monto
            sol.concepto = concepto
            sol.memo = momorando
            def firma = new Firma()
            firma.usuario = usuFirma
            firma.accionVer = "imprimirSolicitudAval"
            firma.controladorVer = "reporteSolicitud"
            firma.accion = "firmarSolicitud"
            firma.controlador = "avales"
            firma.documento = "SolicitudDeAval_" + sol.numero
            firma.concepto = "Solicitud de aval del proceso: " + proceso.nombre
            firma.save(flush: true)
            sol.firma = firma
            sol.unidad = session.usuario.unidad
            if (params.tipo)
                sol.tipo = params.tipo
            sol.fecha = new Date();
            sol.estado = EstadoAval.findByCodigo("EF4")
            if (!sol.save(flush: true)) {
                println "eror save " + sol.errors
            } else {
                firma.idAccion = sol.id
                firma.idAccionVer = sol.id
                firma.save(flush: true)
            }
            def usuarios = Persona.findAllByUnidad(UnidadEjecutora.findByCodigo("DPI"))
            usuarios.each { usu ->
                def alerta = new Alerta()
                alerta.from = session.usuario
                alerta.persona = usu
                alerta.fechaEnvio = new Date()
                alerta.mensaje = "Nueva solicitud de aval"
                alerta.controlador = "revisionAval"
                alerta.accion = "pendientes"
                alerta.id_remoto = sol.id
                if (!alerta.save(flush: true)) {
                    println "error alerta: " + alerta.errors
                }
            }
            try {
                def mail = sol.firma.usuario.mail
                if (mail) {

                    mailService.sendMail {
                        to mail
                        subject "Nueve solicitud de aval"
                        body "Tiene una solicitud de aval pendiente que requiere su firma para aprobación "
                    }

                } else {
                    println "El usuario ${sol.firma.usuario.login} no tiene email"
                }
            } catch (e) {
                println "eror email " + e.printStackTrace()
            }

            flash.message = "Solicitud enviada"
            redirect(action: 'avalesProceso', params: [id: params.proceso])
        }
    }

    /**
     * Acción que permite firmar electronicamente la solicitud
     * @param key de la firma
     */
    def firmarSolicitud = {
        def firma = Firma.findByKey(params.key)
        if (!firma)
            response.sendError(403)
        else {
            def sol = SolicitudAval.findByFirma(firma)
            sol.estado = EstadoAval.findByCodigo("E01")
            sol.save(flush: true)
            try {
                def perfilDireccionPlanificacion = Prfl.findByCodigo("DP")
//            def perfilDireccionComprasPublicas = Prfl.findByCodigo("GJ")
                def perfiles = [perfilDireccionPlanificacion]
                def sesiones = Sesn.findAllByPerfilInList(perfiles)

                if (sesiones.size() > 0) {
                    def persona = Persona.get(session.usuario.personaId)

//                    println "Se enviaran ${sesiones.size()} mails"
                    sesiones.each { sesn ->
                        Persona usro = sesn.usuario
                        def mail = usro.mail
                        if (mail) {

                            mailService.sendMail {
                                to mail
                                subject "Nueve solicitud de aval"
                                body "Ha recibido una nueva solicitud de aval de la unidad " + sol.unidad
                            }

                        } else {
                            println "El usuario ${usro.login} no tiene email"
                        }
                    }
                } else {
                    println "No hay nadie registrado con perfil de direccion de planificacion: no se mandan mails"
                }
            } catch (e) {
                println "Error al enviar mail: ${e.printStackTrace()}"
            }
//            redirect(controller: "pdf",action: "pdfLink",params: [url:g.createLink(controller: firma.controladorVer,action: firma.accionVer,id: firma.idAccionVer)])
            def url = g.createLink(controller: "pdf", action: "pdfLink", params: [url: g.createLink(controller: firma.controladorVer, action: firma.accionVer, id: firma.idAccionVer)])
            render "${url}"
        }
    }

    /**
     * Acción llamada con ajax que valida la existencia del archivo de solicitud solicitado para descarga
     */
    def validarSolicitud_ajax() {
        def sol = SolicitudAval.get(params.id)
//        println "path solicitud "+cer.pathSolicitud
        def path = servletContext.getRealPath("/") + "pdf/solicitudAval/" + sol.path

        def src = new File(path)
        if (src.exists()) {
            render "SUCCESS"
        } else {
            render "ERROR*No se encontró el archivo solicitado"
        }
    }

    /**
     * Acción que permite descargar el archivo de la solicitud
     * @param id el id de la solicitud
     */
    def descargaSolicitud = {
        def sol = SolicitudAval.get(params.id)
//        println "path solicitud "+cer.pathSolicitud
        def path = servletContext.getRealPath("/") + "pdf/solicitudAval/" + sol.path

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
     * Acción que permite descargar el archivo del aval
     * @param id el id del aval
     */
    def descargaAval = {
//        println "descar aval "+params
        def aval = Aval.get(params.id)
//        println "path "+aval.path
        def path = servletContext.getRealPath("/") + "avales/" + aval.path

        def src = new File(path)
        if (src.exists()) {
            response.setContentType("application/octet-stream")
            response.setHeader("Content-disposition", "attachment;filename=${src.getName()}")

            response.outputStream << src.newInputStream()
        } else {
            render "archivo no encontrado"
        }
    }


}

