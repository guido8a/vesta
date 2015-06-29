package vesta.avales

import vesta.alertas.Alerta
import vesta.modificaciones.DetalleReforma
import vesta.parametros.UnidadEjecutora
import vesta.parametros.poaPac.Anio
import vesta.poa.Asignacion
import vesta.poaCorrientes.ActividadCorriente
import vesta.poaCorrientes.ObjetivoGastoCorriente
import vesta.seguridad.Firma
import vesta.seguridad.Persona
import vesta.seguridad.Prfl
import vesta.seguridad.Sesn
import vesta.seguridad.Shield

class AvalCorrienteController extends Shield {

    def firmasService
    def mailService

    /**
     * Acción que muestra la lista de solicitudes dependiendo del perfil
     */
    def listaProcesos() {
        def perfil = session.perfil.codigo.toString()
        def unidades = UnidadEjecutora.get(session.unidad.id).getUnidadesPorPerfil(perfil)

        def filtroDirector = null,
            filtroPersona = null

        switch (perfil) {
            case "RQ":
                filtroPersona = Persona.get(session.usuario.id)
                break;
            case "DRRQ":
                filtroDirector = Persona.get(session.usuario.id)
                break;
            case "ASAF":
                break;
        }

        def procesos = AvalCorriente.withCriteria {
            if (unidades.size() > 0) {
                usuario {
                    inList("unidad", unidades)
                }
            }
            if (filtroPersona) {
                eq("usuario", filtroPersona)
            }
            if (filtroDirector) {
                eq("director", filtroDirector)
            }
        }
        return [procesos: procesos]
    }

    /**
     * Acción que muestra la lista de solicitudes pendientes dependiendo del perfil y del estado de la solicitud
     */
    def pendientes() {
        def estadoPendiente = EstadoAval.findByCodigo("P01")
        def estadoDevueltoReq = EstadoAval.findByCodigo("D01")
        def estadoPorRevisar = EstadoAval.findByCodigo("R01")
        def estadoSolicitado = EstadoAval.findByCodigo("E01")
        def estadoDevueltoDirReq = EstadoAval.findByCodigo("D02")
        def estadoDevueltoAnPlan = EstadoAval.findByCodigo("D03")

        def perfil = session.perfil.codigo.toString()

        def estados = []
        def unidades = UnidadEjecutora.get(session.unidad.id).getUnidadesPorPerfil(perfil)

        def filtroDirector = null,
            filtroPersona = null

        switch (perfil) {
            case "RQ":
                estados = [estadoPendiente, estadoDevueltoReq]
                filtroPersona = Persona.get(session.usuario.id)
                break;
            case "DRRQ":
                estados = [estadoPorRevisar, estadoDevueltoDirReq]
                filtroDirector = Persona.get(session.usuario.id)
                break;
            case "ASAF":
                estados = [estadoSolicitado, estadoDevueltoAnPlan]
                unidades = []
                break;
        }

        def procesos = AvalCorriente.withCriteria {
            if (estados.size() > 0) {
                inList("estado", estados)
            }
            if (unidades.size() > 0) {
                usuario {
                    inList("unidad", unidades)
                }
            }
            if (filtroPersona) {
                eq("usuario", filtroPersona)
            }
            if (filtroDirector) {
                eq("director", filtroDirector)
            }
        }

        return [procesos: procesos]
    }

    /**
     * Acción llamada con ajax que muestra un historial de avales corrientes solicitados
     */
    def historial_ajax() {
        def perfil = session.perfil.codigo.toString()
        def unidades = UnidadEjecutora.get(session.unidad.id).getUnidadesPorPerfil(perfil)
        def procesos = AvalCorriente.withCriteria {
            usuario {
                inList("unidad", unidades)
            }
            order("fechaSolicitud", "desc")
        }
        return [procesos: procesos]
    }

    /**
     * Acción que muestra la pantalla de creación de solicitud de aval
     */
    def nuevaSolicitud() {
        AvalCorriente proceso = null
        if (params.id) {
            proceso = AvalCorriente.get(params.id)
        }
        def readOnly = false
        def unidad = UnidadEjecutora.get(session.unidad.id)
        def personasFirma = firmasService.listaDirectoresUnidad(unidad)

        return [proceso: proceso, readOnly: readOnly, personas: personasFirma]
    }

    /**
     * Acción que guarda el proceso y redirecciona a la acción solicitudAsignaciones una vez completado.
     */
    def saveProcesoWizard() {
        println "save proceso " + params

        def proceso
        if (params.id) {
            proceso = AvalCorriente.get(params.id)
        } else {
            proceso = new AvalCorriente()
        }
        proceso.properties = params
        proceso.estado = EstadoAval.findByCodigo("P01") //pendiente
        proceso.usuario = Persona.get(session.usuario.id)
        proceso.fechaSolicitud = new Date()
        if (!proceso.save(flush: true)) {
            flash.message = "Ha ocurrido un error al guardar el proceso: " + renderErrors(bean: proceso)
            flash.tipo = "error"
            redirect(action: 'nuevaSolicitud')
            return
        } else {

            def path = servletContext.getRealPath("/") + "pdf/solicitudAvalCorriente/"
            new File(path).mkdirs()
            def f = request.getFile('file')
            def okContents = [
                    'application/pdf'     : 'pdf',
                    'application/download': 'pdf'
            ]
            def nombre, pathFile
            def fileName = ""
            if (f && !f.empty) {
                fileName = f.getOriginalFilename() //nombre original del archivo
                def ext

//            println okContents.containsKey(f.getContentType())
                if (!okContents.containsKey(f.getContentType())) {
                    redirect(action: 'solicitudProceso', params: [id: params.id, error: "Error: Seleccione un archivo de tipo PDF"])
                    return
                }

                def parts = fileName.split("\\.")
                fileName = ""
                parts.eachWithIndex { obj, i ->
                    if (i < parts.size() - 1) {
                        fileName += obj
                    }
                }
                if (fileName.size() > 0) {
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
                        if (fileName.size() > 0) {
                            f.transferTo(new File(pathFile))  // guarda el archivo subido al nuevo path
                        }
                    } catch (e) {
                        println "????????\n" + e + "\n???????????"
                        e.printStackTrace()
                    }
                }
            }

            if (nombre) {
                proceso.path = nombre
                if (!proceso.save(flush: true)) {
                    println "Error al guardar el path del archivo............ " + proceso.errors
                }
            }

            def texto
            if (params.id) {
                texto = "Actualización"
            } else {
                texto = "Creación"
            }
            texto += "  de proceso exitosa. Por favor ingrese las asignaciones"
            flash.message = texto
            flash.tipo = "success"
            redirect(action: 'solicitudAsignaciones', id: proceso.id)
            return
        }
    }

    /**
     * Acción que muestra la pantalla de selección de asignaciones para el proceso de creación de solicitud de aval
     */
    def solicitudAsignaciones() {
        if (params.id) {
            def proceso = AvalCorriente.get(params.id)
            def unidad = session.usuario.unidad

            def band = true

            if (proceso.estado?.codigo == "E01" || proceso.estado?.codigo == "E02" || proceso.estado.codigo == "E05" ||
                    proceso.estado.codigo == "E06" || proceso.estado.codigo == "EF1" || proceso.estado.codigo == "EF4") {
                band = false
            }

            def readOnly = false

            def actual
            if (params.anio) {
                actual = Anio.get(params.anio)
            } else {
                actual = Anio.findByAnio(new Date().format("yyyy"))
            }
            def estadoDevuelto = EstadoAval.findByCodigo("D01")
            def estadoSolicitadoSinFirma = EstadoAval.findByCodigo("EF4")
            def estadoPendiente = EstadoAval.findByCodigo("P01")
            def estados = [estadoDevuelto, estadoSolicitadoSinFirma, estadoPendiente]

            def maxAnio = proceso.fechaFinProceso.format("yyyy")
            def actualAnio = actual.anio
            def anios = Anio.withCriteria {
                ge("anio", actualAnio)
                le("anio", maxAnio)
                order("anio", "asc")
            }

            def total = 0
            def detalles = ProcesoAsignacion.findAllByAvalCorriente(proceso)
            if (detalles.size() > 0) {
                total = detalles.sum { it.monto }
            }

            return [proceso: proceso, unidad: unidad, band: band, readOnly: readOnly, actual: actual, anios: anios, total: total]
        } else {
            redirect(action: "nuevaSolicitud")
        }
    }

    /**
     * Acción que guarda una solicitud de aval corriente
     */
    def guardarSolicitud() {
        println "solicitud aval corriente " + params

        def strSolicitud = "solicitud"

        def proceso = AvalCorriente.get(params.id)

        println "Hace alerta y marca para revision"
        proceso.estado = EstadoAval.findByCodigo("R01")
        if (!proceso.save(flush: true)) {
            println "ERROR: " + proceso.errors
        }

        def alerta = new Alerta()
        alerta.from = session.usuario
        alerta.persona = proceso.director
        alerta.fechaEnvio = new Date()
        alerta.mensaje = "Nueva ${strSolicitud} de aval: " + proceso.nombreProceso
        alerta.controlador = "avalCorriente"
        alerta.accion = "pendientes"
        alerta.id_remoto = 0
        if (!alerta.save(flush: true)) {
            println "error alerta: " + alerta.errors
        }
        try {
            def mail = proceso.director.mail
            if (mail) {
                mailService.sendMail {
                    to mail
                    subject "Nueva ${strSolicitud} de aval corriente"
                    body "Tiene una ${strSolicitud} de aval corriente pendiente que requiere su revisión para aprobación "
                }
            } else {
                println "El usuario ${proceso.director} no tiene email"
            }
        } catch (e) {
            println "error email " + e.printStackTrace()
        }

        flash.message = "${strSolicitud.capitalize()} enviada"
        redirect(action: 'listaProcesos')
    }

    /**
     * Acción llamada con ajax que calcula el monto máximo que se le puede dar a una asignación
     * @param id el id de la asignación
     * @Renders el monto priorizado menos el monto utilizado
     */
    def getMaximoAsg() {
        println "get Maximo asg " + params
        def asg = Asignacion.get(params.id)
        def monto = asg.priorizado
        def usado = 0;

        def estadoNegado = EstadoAval.findByCodigo("E03")
        def estadoAnulado = EstadoAval.findByCodigo("E04")
        def estados = [estadoNegado, estadoAnulado]

        def locked = 0
        def detalles = ProcesoAsignacion.withCriteria {
//            inList("estado", estados)
            avalCorriente {
                not {
                    inList("estado", estados)
                }
            }
            eq("asignacion", asg)
        }
        if (detalles.size() > 0) {
            locked = detalles.sum { it.monto }
        }
        def disponible = monto - usado - locked
//        println "get Maximo asg " + params + " :  monto: " + monto + "   usado: " + usado + "    locked: " + locked + "     disponible: " + disponible
        render "" + (disponible)
    }

    /**
     * Acción llamada con ajax que carga y muestra las asignaciones de un aval corriente
     * @return
     */
    def getDetalle_ajax() {
        def proceso = AvalCorriente.get(params.id)
        def detalles = ProcesoAsignacion.findAllByAvalCorriente(proceso)
        return [detalles: detalles]
    }

    /**
     * Acción llamada con ajax que agrega una asignación a un aval corriente
     */
    def agregarAsignacion_ajax() {
        def proceso = AvalCorriente.get(params.id)

        def asignacion = Asignacion.get(params.asg)
        def monto = params.monto.toDouble()

        def detalle = new ProcesoAsignacion()
        detalle.proceso = null
        detalle.avalCorriente = proceso
        detalle.asignacion = asignacion
        detalle.monto = monto
        detalle.devengado = 0
        if (!detalle.save(flush: true)) {
            println "error al guardar detalle: " + detalle.errors
            render "ERROR*" + renderErrors(bean: detalle)
        } else {
            recalcularTotal(proceso)
            render "SUCCESS*Asignación agregada exitosamente"
        }
    }

    /**
     * Acción llamada con ajax que borra una asignacion de la solicitud de aval corriente
     * @return
     */
    def deleteDetalle_ajax() {
        def detalle = ProcesoAsignacion.get(params.id)
        def proceso = detalle.avalCorriente
        detalle.delete(flush: true)
        recalcularTotal(proceso)
        render "SUCCESS*Asignación eliminada de la solicitud"
    }

    /**
     * Acción que muestra la pantalla para que el director requirente revise la solicitud y pida la firma del gerente requirente
     */
    def revisarSolicitud() {
        def proceso = AvalCorriente.get(params.id)
        def gerentes = firmasService.listaGerentesUnidad(proceso.usuario.unidad)
        return [proceso: proceso, detalles: arreglarDetalles(proceso), gerentes: gerentes]
    }

    /**
     * Acción que permite al analista admin. solicitar las firmas de aprobación de un aval corriente
     */
    def solicitarFirmas() {
        def proceso = AvalCorriente.get(params.id)
        def firmas = firmasService.listaFirmasCombos()
        return [proceso: proceso, detalles: arreglarDetalles(proceso), personas: firmas.directores, personasGerente: firmas.gerentes]
    }

    /**
     * Acción que permite al director requirente devolver una solicitud al requirente
     */
    def devolverARequirente_ajax() {
        def solicitud = AvalCorriente.get(params.id)

        def strSolicitud = "solicitud"

        def usu = Persona.get(session.usuario.id)
        if (params.auth.toString().trim().encodeAsMD5() == usu.autorizacion) {
            def msg = "<strong>Devuelto por ${usu.nombre} ${usu.apellido}:</strong> " + params.obs.trim()
            def estadoDevueltoReq = EstadoAval.findByCodigo("D01")
            solicitud.estado = estadoDevueltoReq
            if (solicitud.observaciones && solicitud.observaciones != "") {
                solicitud.observaciones = msg + "; " + solicitud.observaciones
            } else {
                solicitud.observaciones = msg
            }
            if (solicitud.save(flush: true)) {

                def alerta1 = new Alerta()
                alerta1.from = usu
                alerta1.persona = solicitud.usuario
                alerta1.fechaEnvio = new Date()
                alerta1.mensaje = "Devolución de ${strSolicitud} de aval corriente: " + solicitud.nombreProceso
                alerta1.controlador = "avalCorriente"
                alerta1.accion = "pendientes"
                if (!alerta1.save(flush: true)) {
                    println "error alerta1: " + alerta1.errors
                }

                def mail = solicitud.usuario.mail
                if (mail) {
                    try {
                        mailService.sendMail {
                            to mail
                            subject "Devolución de ${strSolicitud} de aval corriente"
                            body "Su ${solicitud} de aval corriente: " + solicitud.nombreProceso + " ha sido devuelta por " + usu
                        }
                    } catch (e) {
                        println "error al mandar mail"
                        e.printStackTrace()
                    }
                } else {
                    println "no tiene mail..."
                }

                render "SUCCESS*Devolución exitosa"
            } else {
                render "ERROR*" + renderErrors(bean: solicitud)
            }
        } else {
            render("ERROR*Clave de autorización incorrecta")
        }
    }

    /**
     * Acción que envía la solicutud del director req. al gerente req. para ser firmada
     */
    def enviarAGerente_ajax() {
        def solicitud = AvalCorriente.get(params.id)

        def strSolicitud = "solicitud"

        def usu = Persona.get(session.usuario.id)
        if (params.auth.toString().trim().encodeAsMD5() == usu.autorizacion) {
            def estadoSolicitadoSinFirma = EstadoAval.findByCodigo("EF4")
            def personaFirma, firma = null
            if (solicitud.estado.codigo == 'D02') {
                firma = solicitud.firmaGerente
                personaFirma = firma.usuario
            } else {
                personaFirma = Persona.get(params.firma.toLong())
            }

            if (personaFirma) {
                def mail = personaFirma.mail
                solicitud.estado = estadoSolicitadoSinFirma

                if (!firma) {
                    firma = new Firma()
                    firma.usuario = personaFirma

                    firma.controlador = "avalCorriente"
                    firma.accion = "firmarSolicitud"
                    firma.idAccion = solicitud.id

                    firma.controladorNegar = "avalCorriente"
                    firma.accionNegar = "devolverADirectorRequirente"
                    firma.idAccionNegar = solicitud.id

                    firma.controladorVer = "reporteSolicitud"
                    firma.accionVer = "solicitudAvalCorriente"
                    firma.idAccionVer = solicitud.id

                    firma.tipoFirma = "AVCR"
                    firma.concepto = "${strSolicitud.capitalize()} de aval corriente: " + solicitud.nombreProceso
                    if (!firma.save(flush: true)) {
                        println "error al guardar firma: " + firma.errors
                    } else {
                        solicitud.firmaGerente = firma
                    }
                } else {
                    firma.estado = "S"
                    firma.concepto = "Solicitud de aval corriente: " + solicitud.nombreProceso
                    if (!firma.save(flush: true)) {
                        println "error al guardar firma: " + firma.errors
                    }
                }
                solicitud.save(flush: true)

                def alerta1 = new Alerta()
                alerta1.from = usu
                alerta1.persona = personaFirma
                alerta1.fechaEnvio = new Date()
                alerta1.mensaje = "${strSolicitud.capitalize()} de aval corriente: " + solicitud.nombreProceso
                alerta1.controlador = "firma"
                alerta1.accion = "firmasPendientes"
                alerta1.parametros = "tab=AVCR"
                println alerta1
                if (!alerta1.save(flush: true)) {
                    println "error alerta1: " + alerta1.errors
                }
                if (mail) {
                    try {
                        mailService.sendMail {
                            to mail
                            subject "Una nueva ${strSolicitud} de aval corriente requiere aprobación"
                            body "Tiene una ${strSolicitud} de aval corriente pendiente que requiere su firma para aprobación "
                        }
                    } catch (e) {
                        println "error al mandar mail"
                        e.printStackTrace()
                    }
                } else {
                    println "no tiene mail..."
                }
                render "SUCCESS*Firma solicitada exitosamente"
            } else {
                render("ERROR*No se encontró la persona a la cual desea enviar la solicitud")
            }
        } else {
            render("ERROR*Clave de autorización incorrecta")
        }
    }

    /**
     * Acción que le permite al ger. req. devolver una solicitud de aval corriente al dir. req
     */
    def devolverADirectorRequirente() {
        def solicitud = AvalCorriente.get(params.id)

        def strSolicitud = "solicitud"

        def usu = Persona.get(session.usuario.id)
        def estadoDevueltoDirReq = EstadoAval.findByCodigo("D02")
        solicitud.estado = estadoDevueltoDirReq

        if (solicitud.save(flush: true)) {
            def alerta1 = new Alerta()
            alerta1.from = usu
            alerta1.persona = solicitud.director
            alerta1.fechaEnvio = new Date()
            alerta1.mensaje = "Devolución de ${strSolicitud} de aval corriente: " + solicitud.nombreProceso
            alerta1.controlador = "avalCorriente"
            alerta1.accion = "pendientes"
            if (!alerta1.save(flush: true)) {
                println "error alerta1: " + alerta1.errors
            }
            def mail = solicitud.director.mail
            if (mail) {
                try {
                    mailService.sendMail {
                        to mail
                        subject "Devolución de ${strSolicitud} de aval corriente"
//                        body "Su solicitud de aval: " + solicitud.concepto + " ha sido devuelta por " + usu
                        body "Su solicitud de ${strSolicitud} de aval corriente: " + solicitud.nombreProceso + " ha sido devuelta por " + usu
                    }
                } catch (e) {
                    println "error al mandar mail"
                    e.printStackTrace()
                }
            } else {
                println "no tiene mail..."
            }
            render "SUCCESS*Devolución exitosa"
        } else {
            render "ERROR*" + renderErrors(bean: solicitud)
        }
    }

    /**
     * Acción que permite firmar electronicamente la solicitud
     * @param key de la firma
     */
    def firmarSolicitud() {
        def firma = Firma.findByKey(params.key)
        if (!firma) {
            response.sendError(403)
        } else {
            def sol = AvalCorriente.findByFirmaGerente(firma)
            sol.estado = EstadoAval.findByCodigo("E01")

            def strSolicitud = "solicitud"

            def numero
            def usuarios = Persona.findAllByUnidad(session.usuario.unidad)
            numero = AvalCorriente.findAllByUsuarioInList(usuarios, [sort: "numeroSolicitud", order: "desc", max: 1])
            if (numero.size() > 0) {
                numero = numero?.pop()?.numeroSolicitud
            }
            if (!numero) {
                numero = 1
            } else {
                numero = numero + 1
            }
            sol.numeroSolicitud = numero
            sol.save(flush: true)
            def perfilDireccionPlanificacion = Prfl.findByCodigo("ASAF") //analista administracion
            def perfiles = [perfilDireccionPlanificacion]
            def sesiones = Sesn.findAllByPerfilInList(perfiles)

            if (sesiones.size() > 0) {
                def persona = Persona.get(session.usuario.id)
                def now = new Date()

//                    println "Se enviaran ${sesiones.size()} mails"
                sesiones.each { sesn ->
                    Persona usro = sesn.usuario
                    def mail = usro.mail

                    def alerta = new Alerta()
                    alerta.from = persona
                    alerta.persona = usro
                    alerta.fechaEnvio = now
                    alerta.mensaje = "${strSolicitud.capitalize()} de aval corriente: " + sol.nombreProceso
                    alerta.controlador = "avalCorriente"
                    alerta.accion = "pendientes"
                    alerta.id_remoto = 0
                    if (!alerta.save(flush: true)) {
                        println "error alerta: " + alerta.errors
                    }
                    if (mail) {
                        try {
                            mailService.sendMail {
                                to mail
                                subject "Nueva ${strSolicitud} de aval corriente"
                                body "Ha recibido una nueva ${strSolicitud} de aval corriente de la unidad " + sol.usuario.unidad + ": " + sol.nombreProceso
                            }
                        } catch (e) {
                            println "Error al enviar mail: ${e.printStackTrace()}"
                        }
                    } else {
                        println "El usuario ${usro.login} no tiene email"
                    }
                }
            } else {
                println "No hay nadie registrado con perfil de analista de administracion: no se mandan mails"
            }

//            redirect(controller: "pdf",action: "pdfLink",params: [url:g.createLink(controller: firma.controladorVer,action: firma.accionVer,id: firma.idAccionVer)])
            def url = g.createLink(controller: "pdf", action: "pdfLink", params: [url: g.createLink(controller: firma.controladorVer, action: firma.accionVer, id: firma.idAccionVer)])
            render "${url}"
        }
    }

    /**
     * Acción que permite al analista solicitar las firmas de aprobación de un aval corriente
     */
    def solicitarFirmas_ajax() {
        def msg = ""
        def errores = ""
//        println "guardar datos doc " + params
        def sol = AvalCorriente.get(params.id)

        def strSolicitud = "solicitud"

        def obs = params.obs
        def usuario = Persona.get(session.usuario.id)
        if (obs) {
            obs = obs.replaceAll("&nbsp", " ")
            obs = obs.replaceAll("&Oacute;", "Ó")
            obs = obs.replaceAll("&oacute;", "ó")
            obs = obs.replaceAll("&Aacute;", "Á")
            obs = obs.replaceAll("&aacute;", "á")
            obs = obs.replaceAll("&Eacute;", "É")
            obs = obs.replaceAll("&eacute;", "é")
            obs = obs.replaceAll("&Iacute;", "Í")
            obs = obs.replaceAll("&iacute;", "í")
            obs = obs.replaceAll("&Uacute;", "Ú")
            obs = obs.replaceAll("&uacute;", "ú")
            obs = obs.replaceAll("&ntilde;", "ñ")
            obs = obs.replaceAll("&Ntilde;", "Ñ")
            obs = obs.replaceAll("&ldquo;", '"')
            obs = obs.replaceAll("&rdquo;", '"')
            obs = obs.replaceAll("&lquo;", "'")
            obs = obs.replaceAll("&rquo;", "'")

        }
        sol.observacionesPdf = obs
        sol.analista = Persona.get(session.usuario.id)
        if (!sol.save(flush: true)) {
            errores += renderErrors(bean: sol)
        }
        if (params.enviar) {
            println "si env"
            if (params.enviar == "true") {
//                def ok = params.auth.toString().trim().encodeAsMD5() == usuario.autorizacion
                def ok = true
                if (ok) {
                    println "enviar =true"
                    def band = false
                    /*Todo aqui validar quien puede*/
                    band = true
                    if (band) {
                        def firma1, firma2
                        if (!sol.firma1) {
                            firma1 = new Firma()
                            firma1.usuario = Persona.get(params.firma2)

                            firma1.controladorVer = "reporteSolicitud"
                            firma1.accionVer = "avalCorriente"
                            firma1.idAccionVer = sol.id

                            firma1.controlador = "avalCorriente"
                            firma1.accion = "firmarAval"
                            firma1.idAccion = sol.id

                            firma1.controladorNegar = "avalCorriente"
                            firma1.accionNegar = "devolverAvalAPlanificacion"
                            firma1.idAccionNegar = sol.id

                            firma1.tipoFirma = "AVCR"

                            firma1.concepto = "Aprobación del aval corriente ${sol.concepto}"
                            firma1.esPdf = "S"
                            if (!firma1.save(flush: true)) {
                                println "error firma1 " + firma1.errors
                                errores += renderErrors(bean: firma1)
                            }
                            firma2 = new Firma()
                            firma2.usuario = Persona.get(params.firma3)

                            firma2.controladorVer = firma1.controladorVer
                            firma2.accionVer = firma1.accionVer
                            firma2.idAccionVer = firma1.idAccionVer

                            firma2.controlador = firma1.controlador
                            firma2.accion = firma1.accion
                            firma2.idAccion = firma1.idAccion

                            firma2.controladorNegar = firma1.controladorNegar
                            firma2.accionNegar = firma1.accionNegar
                            firma2.idAccionNegar = firma1.idAccionNegar

                            firma2.tipoFirma = firma1.tipoFirma

                            firma2.concepto = firma1.concepto
                            firma2.esPdf = firma1.esPdf
                            if (!firma2.save(flush: true)) {
                                println "error firma2 " + firma2.errors
                                errores += renderErrors(bean: firma2)
                            }
                            sol.firma1 = firma1
                            sol.firma2 = firma2
                        } else {
                            firma1 = sol.firma1
                            firma2 = sol.firma2

                            firma1.estado = "S"
                            firma2.estado = "S"

                            if (!firma1.save(flush: true)) {
                                println "error firma1 " + firma1.errors
                                errores += renderErrors(bean: firma1)
                            }

                            if (!firma2.save(flush: true)) {
                                println "error firma2 " + firma2.errors
                                errores += renderErrors(bean: firma2)
                            }
                        }

                        sol.estado = EstadoAval.findByCodigo("EF1") //aprobado sin firma
                        if (!sol.save(flush: true)) {
                            println "error save aval 2"
                        }

                        def alerta1 = new Alerta()
                        alerta1.from = usuario
                        alerta1.persona = firma1.usuario
                        alerta1.fechaEnvio = new Date()
                        alerta1.mensaje = "Aval corriente pendiente de firma para aprobación: " + sol.concepto
                        alerta1.controlador = "firma"
                        alerta1.accion = "firmasPendientes"
                        alerta1.parametros = "tab=AVCR"
                        if (!alerta1.save(flush: true)) {
                            println "error alerta1: " + alerta1.errors
                        }
                        def alerta2 = new Alerta()
                        alerta2.from = usuario
                        alerta2.persona = firma2.usuario
                        alerta2.fechaEnvio = alerta1.fechaEnvio
                        alerta2.mensaje = alerta1.mensaje
                        alerta2.controlador = alerta1.controlador
                        alerta2.accion = alerta1.accion
                        alerta2.parametros = alerta1.parametros
                        if (!alerta2.save(flush: true)) {
                            println "error alerta2: " + alerta2.errors
                        }

                        try {
                            def mail = sol.firma1.usuario.mail
                            if (mail) {
                                mailService.sendMail {
                                    to mail
                                    subject "Un nuevo aval corriente requiere aprobación"
                                    body "Tiene un aval corriente pendiente que requiere su firma para aprobación: " + sol.concepto
                                }
                            } else {
                                println "El usuario ${sol.firma1.usuario.login} no tiene email"
                                msg += "<li>El usuario ${sol.firma1.usuario.login} no tiene email</li>"
                            }
                            mail = sol.firma2.usuario.mail
                            if (mail) {
                                mailService.sendMail {
                                    to mail
                                    subject "Un nuevo aval corriente requiere aprobación"
                                    body "Tiene un aval corriente pendiente que requiere su firma para aprobación: " + sol.concepto
                                }
                            } else {
                                println "El usuario ${sol.firma2.usuario.login} no tiene email"
                                msg += "<li>El usuario ${sol.firma2.usuario.login} no tiene email</li>"
                            }
                        } catch (e) {
                            println "error email " + e.printStackTrace()
                            msg += "Ha ocurrido un error al enviar los emails."
                        }
                        //flash.message = "Solciitud de firmas enviada para aprobación"
                    } else {
                        def msn = "Usted no tiene permisos para aprobar esta solicitud"
                        if (params.tipo) {
                            println "CER????"
//                            redirect(action: "listaCertificados", params: [cer: cer, id: cer.asignacion.unidad.id])
                        } else {
                            redirect(action: 'listaProcesos', params: [msn: msn])
                        }
                    }
                } else {
                    render("ERROR*Clave de autorización incorrecta")
                    return
                }
            }
        }
        if (errores != "") {
            def rend = errores
            if (msg != "") {
                rend += "<ul>" + msg + "</ul>"
            }
            render "ERROR*" + rend
        } else {
            def rend = ""
            if (msg != "") {
                rend += "<ul>" + msg + "</ul>"
            }
            if (params.enviar == "true") {
                rend = "Datos guardados. Solicitud de firmas enviada para aprobación. " + rend
            } else {
                rend = "Datos guardados. " + rend
            }
            render "SUCCESS*" + rend
        }
    }

    /**
     * Acción que permite al analista negar definativamente un aval
     */
    def negarAval_ajax() {

    }

    /**
     * Acción llamada con ajax que valida la existencia del archivo de solicitud solicitado para descarga
     */
    def validarSolicitud_ajax() {
        def sol = AvalCorriente.get(params.id)
        def path = servletContext.getRealPath("/") + "pdf/solicitudAvalCorriente/" + sol.path

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
        def sol = AvalCorriente.get(params.id)
        def path = servletContext.getRealPath("/") + "pdf/solicitudAvalCorriente/" + sol.path

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
     * Acción llamada con ajax que carga los objetivos de gasto corriente de un año
     * @return
     */
    def cargaObjetivosAnio_ajax() {
        def anio = Anio.get(params.anio)
        List<ObjetivoGastoCorriente> objetivos = []
        ActividadCorriente.findAllByAnio(anio).each { ac ->
            def ob = ac.macroActividad.objetivoGastoCorriente
            if (!objetivos.contains(ob)) {
                objetivos += ob
            }
        }
        objetivos = objetivos.unique().sort { it.descripcion }
        return [objetivos: objetivos]
    }

    /**
     * Función que calcula el total del monto de solicitud despues de efectuar cambios en sus asignaciones
     * @param AvalCorriente proceso
     */
    private static void recalcularTotal(AvalCorriente proceso) {
        def detalles = ProcesoAsignacion.findAllByAvalCorriente(proceso)
        def total = 0
        if (detalles.size() > 0) {
            total = detalles.sum { it.monto }
        }
        proceso.monto = total
        proceso.save(flush: true)
    }

    /**
     * Función que recibe un aval corriente y retorna un mapa con los detalles del aval agrupados por tarea
     * @param AvalCorriente proceso
     * @return map
     */
    public static Map arreglarDetalles(AvalCorriente proceso) {
        def ret = [:]

        def detalles = ProcesoAsignacion.findAllByAvalCorriente(proceso)
        detalles.each { det ->
            def tarea = det.asignacion.tarea
            def tareaId = tarea.id
            if (!ret[tareaId]) {
                ret[tareaId] = [
                        tarea       : tarea,
                        asignaciones: []
                ]
            }
            ret[tareaId].asignaciones += [asg: det.asignacion, monto: det.monto]
        }
        return ret
    }

}