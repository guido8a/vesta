package vesta.avales

import vesta.alertas.Alerta
import vesta.parametros.UnidadEjecutora
import vesta.parametros.poaPac.Anio
import vesta.seguridad.*

/**
 * Controlador que muestra las pantallas de manejo de revisiones de avales
 */
class RevisionAvalController extends Shield {

    def mailService
    def firmasService
    def proyectosService

    /**
     * Acción que muestra la lista de solicitudes de aval pendientes (estadoAval código E01)
     * @param anio el año para el cual se van a mostrar las solicitudes. Si no recibe este parámetro muestra del año actual.
     */
    def pendientes = {
        def solicitudes = SolicitudAval.findAllByEstado(EstadoAval.findByCodigo("E01"))
        def actual
        if (params.anio) {
            actual = Anio.get(params.anio)
        } else {
            actual = Anio.findByAnio(new Date().format("yyyy"))
        }
        [solicitudes: solicitudes, actual: actual]
    }

    /**
     * Acción llamada con ajax que permite negar un aval.
     * @Returns "ok" si se puede negar el aval, "no" en caso de que el usuario no pueda negar avales
     */
    def negarAval = {

        def band = false
        def usuario = Persona.get(session.usuario.id)
        def sol = SolicitudAval.get(params.id)
        /*todo aqui validar quien puede*/
        band = true
        if (band) {
            sol.estado = EstadoAval.findByCodigo("E03")
            sol.observaciones = params.obs
            sol.fechaRevision = new Date()
            sol.save(flush: true)
            render "ok"
        } else {
            render("no")
        }
    }

    /**
     * Acción que muestra la lista de avales de un año
     * @param anio el año para el cual se van a mostrar las solicitudes. Si no recibe este parámetro muestra del año actual.
     */
    def listaAvales = {
        def actual
        if (params.anio) {
            actual = Anio.get(params.anio)
        } else {
            actual = Anio.findByAnio(new Date().format("yyyy"))
        }
        [actual: actual]
    }

    def liberarAvales() {
        redirect(action: "listaAvales")
    }

    /**
     * Acción que muestra la pantalla que permite liberar un aval
     * @param id el id del aval a liberar
     */
    def liberarAval = {
        def aval = Aval.get(params.id)
        def detalle = ProcesoAsignacion.findAllByProceso(aval.proceso)
        [aval: aval, detalle: detalle]
    }

    /**
     * Acción que muestra la pantalla con el historial de avales de un año
     * @param anio el año para el cual se van a mostrar los avales
     * @param proceso
     * @param numero
     * @param sort
     * @param order
     */
    def historialAvales = {
        println "historial aval " + params
        def now = new Date()
        def anio = Anio.get(params.anio).anio
        def numero = ""
        def proceso = params.proceso
        def estado = EstadoAval.findByCodigo("E02")
        def datos = []
        def fechaInicio
        def fechaFin
        def orderBy = ""
        def externos = ["usuario", "proceso", "proyecto"]
        def band = true

        def unidades = proyectosService.getUnidadesUnidad(UnidadEjecutora.get(session.unidad.id))
        def personasLista = Persona.findAllByUnidadInList(unidades)

        println("-->" + unidades)







        if (params.numero && params.numero != "") {
            numero = " and numero like ('%${numero}%')"
        }
        if (params.sort && params.sort != "") {
            if (!externos.contains(params.sort)) {
                orderBy = " order by ${params.sort} ${params.order}"
            } else {
                band = false
            }
        }
        if (anio && anio != "") {
            fechaInicio = new Date().parse("dd-MM-yyyy HH:mm:ss", "01-01-" + anio + " 00:01:01")
            fechaFin = new Date().parse("dd-MM-yyyy HH:mm:ss", "31-12-" + anio + " 23:59:59")

            def avales = Aval.withCriteria {
                or {
                    and {
                        gt("fechaAprobacion", fechaInicio)
                        lt("fechaAprobacion", fechaFin)
                    }
                    and {
                        gt("fechaAnulacion", fechaInicio)
                        lt("fechaAnulacion", fechaFin)
                    }
                    and {
                        gt("fechaLiberacion", fechaInicio)
                        lt("fechaLiberacion", fechaFin)
                    }
                }
                if (params.numero && params.numero != "") {
                    eq("numero", "" + params.numero.toInteger())
                }
                if (params.sort && params.sort != "") {
                    if (!externos.contains(params.sort)) {
                        order(params.sort, params.order)
                    }
                }
            }
            datos = avales
        }

        if (proceso && proceso != "") {
            def datosTemp = []
            datos.each { av ->
                if (av.proceso.nombre.toLowerCase() =~ proceso.toLowerCase()) {
                    datosTemp.add(av)
                }
            }
            datos = datosTemp
//            println "datos proceso "+datos
        }
//        def datosTemp2 = []
//        datos.each { d->
//             SolicitudAval.findAllByAval(d).each { s->
//                 if(!datosTemp2.contains(d ) && unidades.contains(s.unidad)) {
//                     datosTemp2 += d
//                 }
//             }
//
//
//        }
//        datos = datosTemp2
//        if (params.requirente) {
//            def req = UnidadEjecutora.get(params.requirente.toLong())
            def datosTemp = []
            datos.each { av ->
//                def solicitud = SolicitudAval.countByAvalAndUnidad(av, req)
                def solicitud = SolicitudAval.countByAvalAndUnidadInList(av, unidades)
                if (solicitud > 0) {
                    datosTemp.add(av)
                }
            }
            datos = datosTemp
//        }
        if (!band) {
            switch (params.sort) {
                case "proceso":
                    println "sort proceso"
                    datos = datos.sort { it.proceso.nombre }

                    break;
                case "proyecto":
                    datos = datos.sort { it.proceso.proyecto.nombre }
                    break;
            }
            if (params.order == "desc") {
                datos = datos.reverse()
            }

        }
        [datos: datos, estado: estado, sort: params.sort, order: params.order, now: now]
    }

    /**
     * Acción que muestra la pantalla con el historial de solicitudes de avales
     * @param anio el año para el cual se van a mostrar los avales
     * @param proceso
     * @param numero
     */
    def historial = {
//        println "historial " + params
        def anio = Anio.get(params.anio).anio
        def numero = params.numero ? params.numero.toInteger() : ""
        def proc = params.proceso
        def requirente
        if (params.requirente) {
            requirente = UnidadEjecutora.get(params.requirente.toLong())
        }
        def datos = []
        def fechaInicio
        def fechaFin
        def unidades = proyectosService.getUnidadesUnidad(UnidadEjecutora.get(session.unidad.id))
        if (anio && anio != "") {
            fechaInicio = new Date().parse("dd-MM-yyyy hh:mm:ss", "01-01-" + anio + " 00:01:01")
            fechaFin = new Date().parse("dd-MM-yyyy hh:mm:ss", "31-12-" + anio + " 23:59:59")
//            println "inicio "+fechaInicio+"  fin  "+fechaFin
            def estadoSinFirma = EstadoAval.findByCodigo("EF4")
//            datos += SolicitudAval.findAllByEstadoNotEqualAndFechaBetween(estadoSinFirma, fechaInicio, fechaFin)
            datos = SolicitudAval.withCriteria {
                ne("estado", estadoSinFirma)
                between("fecha", fechaInicio, fechaFin)
//                if (requirente) {
//                    eq("unidad", requirente)
//                }
                inList("unidad", unidades)
                if (numero && numero != "") {
                    aval {
                        ilike("numero", "%" + numero + "%")
                    }
                }
                if (proc && proc != "") {
                    proceso {
                        ilike("nombre", "%" + proc + "%")
                    }
                }
            }
//            println "datos fecha "+datos
        }
//        if (numero && numero != "") {
////            println "buscando por numero ==> "+numero
//            def datosTemp = []
//            datos.each { sol ->
//                println "tiene aval? " + sol.aval
//                if (sol.aval?.numero =~ numero) {
//                    println "encontro "
//                    datosTemp.add(sol)
//                }
//            }
//            datos = datosTemp
////            println "datos numero "+datos
//        }
//        if (proceso && proceso != "") {
//            def datosTemp = []
//            datos.each { sol ->
//                if (sol.proceso.nombre =~ proceso) {
//                    println "encontro "
//                    datosTemp.add(sol)
//                }
//            }
//            datos = datosTemp
////            println "datos proceso "+datos
//        }
        datos = datos.sort { it.fecha }
        datos = datos.reverse()
        return [datos: datos]
    }

    /**
     * Acción que muestra la pantalla que permite aprobar una solicitud de aval
     * @param id el id de la solicitud de aval a aprobar
     */
    def aprobarAval = {
//        def unidad = UnidadEjecutora.findByCodigo("DPI") // DIRECCIÓN DE PLANIFICACIÓN E INVERSIÓN
//        def personasFirmas = Persona.findAllByUnidad(unidad)
//        def gerentes = Persona.findAllByUnidad(unidad.padre)
        def firmas = firmasService.listaFirmasCombos()
        def numero = 0
        def max = Aval.list([sort: "numero", order: "desc", max: 1])
//        println "max " + max.numero
        if (max.size() > 0) {
            numero = max[0].numero + 1
        }
        def solicitud = SolicitudAval.get(params.id)
        def band = false
        def usuario = Persona.get(session.usuario.id)
        /*todo validar quien puede*/
        band = true
        if (!band) {
            response.sendError(403)
        }
        return [solicitud: solicitud, personas: firmas.directores, personasGerente: firmas.gerentes, numero: numero]
    }

    /**
     * Acción que muestra la pantalla que permite aprobar la solicitud de anulación
     * @param id el id de la solicitud de aval
     */
    def aprobarAnulacion = {
        def solicitud = SolicitudAval.get(params.id)
        def band = false
        def usuario = Persona.get(session.usuario.id)
        /*todo validar quien puede*/
        band = true
        if (!band) {
            response.sendError(403)
        }
        [solicitud: solicitud]
    }

    /**
     * Acción llamada con ajax que guarda los datos de una solicitud de aval
     * @param id el id de la solicitud de aval
     * @param obs las observaciones de la solicitud
     * @param aval el número de la solicitud
     * @param firma2 la segunda firma de la solicitud
     * @param firma3 la tercera firma de la solicitud
     * @Renders "ok"
     */
    def guarDatosDoc = {
        def msg = ""
        def errores = ""
//        println "guardar datos doc " + params
        def sol = SolicitudAval.get(params.id)
        def obs = params.obs
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
        sol.observaciones = obs
//        sol.firma2 = Usro.get(params.firma2)
//        sol.firma3 = Usro.get(params.firma3)
        if (!sol.save(flush: true)) {
            errores += renderErrors(bean: sol)
        }
        if (params.enviar) {
            println "si env"
            if (params.enviar == "true") {
                println "enviar =true"
                def band = false
                def usuario = Persona.get(session.usuario.id)
                /*Todo aqui validar quien puede*/
                band = true
                if (band) {
                    def firma1, firma2, aval
                    if (!sol.aval) {
                        aval = new Aval()
                        aval.proceso = sol.proceso
                        aval.concepto = sol.concepto
                        aval.path = " "
                        aval.memo = sol.memo
//                    aval.numero = sol.numero
                        aval.numero = 0
                        aval.estado = EstadoAval.findByCodigo("EF1")
                        aval.monto = sol.monto
                        if (!aval.save(flush: true)) {
                            println "error save aval 1 " + aval.errors
                        }
                        firma1 = new Firma()
                        firma1.usuario = Persona.get(params.firma2)
                        firma1.accionVer = "certificacion"
                        firma1.controladorVer = "reportes"
                        firma1.idAccionVer = sol.id
                        firma1.accion = "firmarAval"
                        firma1.controlador = "revisionAval"

                        firma1.controladorNegar = "revisionAval"
                        firma1.accionNegar = "devolverAval"
                        firma1.idAccionNegar = sol.id
                        firma1.tipoFirma = "AVAL"

                        firma1.documento = "aval_" + aval.numero + "_" + sol.proceso.nombre
//                        firma1.concepto = "Aprobación del aval ${aval.numero}"
                        firma1.concepto = "Aprobación del aval ${aval.concepto}"
                        firma1.esPdf = "S"
                        if (!firma1.save(flush: true)) {
                            println "error firma1 " + firma1.errors
                            errores += renderErrors(bean: firma1)
                        }
                        firma2 = new Firma()
                        firma2.usuario = Persona.get(params.firma3)
                        firma2.accionVer = "certificacion"
                        firma2.controladorVer = "reportes"
                        firma2.idAccionVer = sol.id
                        firma2.accion = "firmarAval"
                        firma2.controlador = "revisionAval"

                        firma2.controladorNegar = "revisionAval"
                        firma2.accionNegar = "devolverAval"
                        firma2.idAccionNegar = sol.id
                        firma2.tipoFirma = "AVAL"

                        firma2.documento = "aval_" + aval.numero + "_" + sol.proceso.nombre
//                        firma2.concepto = "Aprobación del aval ${aval.numero}"
                        firma2.concepto = "Aprobación del aval ${aval.concepto}"
                        firma2.esPdf = "S"
                        if (!firma2.save(flush: true)) {
                            println "error firma2 " + firma2.errors
                            errores += renderErrors(bean: firma2)
                        }
                        aval.firma1 = firma1
                        aval.firma2 = firma2
                    } else {
                        aval = sol.aval
                        firma1 = aval.firma1
                        firma2 = aval.firma2

                        firma1.estado = "S"
                        firma2.estado = "S"
                    }
                    if (!aval.save(flush: true)) {
                        println "error save aval 2"
                    }
                    firma1.idAccion = aval.id
                    firma2.idAccion = aval.id
                    firma1.save()
                    firma2.save()
                    sol.aval = aval;
                    sol.estado = aval.estado
                    if (!aval.save(flush: true)) {
                        println "ERROR AVAL!!!!! " + aval.errors
                    }
                    sol.save(flush: true)

                    def alerta1 = new Alerta()
                    alerta1.from = usuario
                    alerta1.persona = firma1.usuario
                    alerta1.fechaEnvio = new Date()
                    alerta1.mensaje = "Aval pendiente de firma para aprobación: " + sol.concepto
                    alerta1.controlador = "firma"
                    alerta1.accion = "firmasPendientes"
                    if (!alerta1.save(flush: true)) {
                        println "error alerta1: " + alerta1.errors
                    }
                    def alerta2 = new Alerta()
                    alerta2.from = usuario
                    alerta2.persona = firma1.usuario
                    alerta2.fechaEnvio = new Date()
                    alerta2.mensaje = "Aval pendiente de firma para aprobación: " + sol.concepto
                    alerta2.controlador = "firma"
                    alerta2.accion = "firmasPendientes"
                    if (!alerta2.save(flush: true)) {
                        println "error alerta2: " + alerta2.errors
                    }

                    try {
                        def mail = aval.firma1.usuario.mail
                        if (mail) {

                            mailService.sendMail {
                                to mail
                                subject "Un nuevo aval requiere aprobación"
                                body "Tiene un aval pendiente que requiere su firma para aprobación "
                            }

                        } else {
                            println "El usuario ${aval.firma1.usuario.login} no tiene email"
                            msg += "<li>El usuario ${aval.firma1.usuario.login} no tiene email</li>"
                        }
                        mail = aval.firma2.usuario.mail
                        if (mail) {

                            mailService.sendMail {
                                to mail
                                subject "Un nuevo aval requiere aprobación"
                                body "Tiene un aval pendiente que requiere su firma para aprobación "
                            }

                        } else {
                            println "El usuario ${aval.firma2.usuario.login} no tiene email"
                            msg += "<li>El usuario ${aval.firma2.usuario.login} no tiene email</li>"
                        }
                    } catch (e) {
                        println "error email " + e.printStackTrace()
                        msg += "Ha ocurrido un error al enviar los emails."
                    }
                    //flash.message = "Solciitud de firmas enviada para aprobación"
                } else {
                    def msn = "Usted no tiene permisos para aprobar esta solicitud"
                    if (params.tipo) {
                        redirect(action: "listaCertificados", params: [cer: cer, id: cer.asignacion.unidad.id])
                    } else {
                        redirect(action: 'listaSolicitudes', params: [msn: msn])
                    }
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
                rend = "Datos guardados. " + rend
            } else {
                rend = "Datos guardados. Solicitud de firmas enviada para aprobación. " + rend
            }
            render "SUCCESS*" + rend
        }
    }

    /**
     * Acción que permite devolver un aval al analista de planificacion
     */
    def devolverAval() {
        def sol = SolicitudAval.get(params.id)
        sol.estado = EstadoAval.findByCodigo("D02") //devuelto al analista

        def now = new Date()
        def usu = Persona.get(session.usuario.id)

        def perfilAnalistaPlan = Prfl.findByCodigo("ASPL")
        def analistas = Sesn.findAllByPerfil(perfilAnalistaPlan).usuario

        analistas.each { a ->
            def alerta = new Alerta()
            alerta.from = usu
            alerta.persona = a
            alerta.fechaEnvio = now
            alerta.mensaje = "Devolución de aval: " + sol.concepto
            alerta.controlador = "revisionAval"
            alerta.accion = "pendientes"
            if (!alerta.save(flush: true)) {
                println "error alerta: " + alerta.errors
            }
        }
        render "OK"
    }

    /**
     * Acción que permite firmar electrónicamente un Aval
     * @params id es el identificador del aval
     */
    def firmarAval = {
        def firma = Firma.findByKey(params.key)
        def numero = 0
        if (!firma) {
            response.sendError(403)
        } else {
            def aval = Aval.findByFirma1OrFirma2(firma, firma)
            if (aval.firma1.key != null && aval.firma2.key != null) {
                aval.fechaAprobacion = new Date()
                numero = Aval.list([sort: "numero", order: "desc", max: 1])
                if (numero.size() > 0) {
                    numero = numero?.pop()?.numero
                }
                if (!numero) {
                    numero = 1
                } else {
                    numero = numero + 1
                }

                aval.numero = numero

                aval.estado = EstadoAval.findByCodigo("E02")
                aval.save(flush: true)
                def sol = SolicitudAval.findByAval(aval)
                sol.estado = aval.estado
                sol.save(flush: true)
                try {
                    def perDir = Prfl.findByCodigo("DRRQ")
                    def sesiones = []
                    /*drrq*/
                    Persona.findAllByUnidad(sol.unidad).each {
                        def ses = Sesn.findAllByPerfilAndUsuario(perDir, it)
                        if (ses.size() > 0) {
                            sesiones += ses
                        }
                    }
                    if (sesiones.size() > 0) {
                        println "Se enviaran ${sesiones.size()} mails"
                        sesiones.each { sesn ->
                            Persona usro = sesn.usuario
                            def mail = usro.mail
                            if (mail) {
                                mailService.sendMail {
                                    to mail
                                    subject "Nuevo aval emitido"
                                    body "Se ha emitido el aval #" + aval.numero
                                }
                            } else {
                                println "El usuario ${usro.usroLogin} no tiene email"
                            }
                        }
                    } else {
                        println "No hay nadie registrado con perfil de direccion de planificacion: no se mandan mails"
                    }
                } catch (e) {
                    println "Error al enviar mail: ${e.printStackTrace()}"
                }
//            redirect(controller: "pdf",action: "pdfLink",params: [url:g.createLink(controller: firma.controladorVer,action: firma.accionVer,id: firma.idAccionVer)])
            }
            def url = g.createLink(controller: "pdf", action: "pdfLink", params: [url: g.createLink(controller: firma.controladorVer, action: firma.accionVer, id: firma.idAccionVer)])
            render "${url}"
        }
    }

    /**
     * Acción que permite guardar la liberación de un aval
     * @params los parámetros enviados por el submit del formulario
     */
    def guardarLiberacion = {
        println "liberacion " + params

        if (params.monto) {
            params.monto = params.monto.replaceAll("\\.", "")
            params.monto = params.monto.replaceAll(",", ".")
        }

        def path = servletContext.getRealPath("/") + "avales/"
        new File(path).mkdirs()
        def f = request.getFile('archivo')
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

                    "" : "[\\!@\\\$%\\^&*()='\"\\/<>:;\\.,\\?]",

                    "_": "[\\s]"
            ]

            reps.each { k, v ->
                fileName = (fileName.trim()).replaceAll(v, k)
            }

            fileName = fileName + "_" + new Date().format("mm_ss") + "." + "pdf"

            def pathFile = path + File.separatorChar + fileName
            def src = new File(pathFile)
            def msn

            if (src.exists()) {

                flash.message = "Ya existe un archivo con ese nombre. Por favor cámbielo."
                redirect(action: 'listaAvales')


            } else {
                def band = false
                def usuario = Usro.get(session.usuario.id)
                def aval = Aval.get(params.id)
                /*Todo aqui validar quien puede*/
                band = true
                def datos = params.datos.split("&")
                datos.each {
                    if (it != "") {
                        def data = it.split(";")
                        println "data " + data
                        if (data.size() == 2) {
                            def det = ProcesoAsignacion.get(data[0])
                            det.monto = data[1].toDouble()
                            det.save(flush: true)
                        }
                    }


                }
                if (band) {
                    f.transferTo(new File(pathFile))
                    aval.pathLiberacion = fileName
                    aval.liberacion = aval.monto
                    aval.monto = params.monto.toDouble()
                    aval.estado = EstadoAval.findByCodigo("E05")
                    aval.contrato = params.contrato
                    aval.certificacion = params.certificacion
                    aval.save(flush: true)
                    flash.message = "Aval " + aval.fechaAprobacion.format("yyyy") + "-GP No." + aval.numero + " Liberado"
                    redirect(action: 'listaAvales', controller: 'revisionAval')
                } else {
                    flash.message = "Usted no tiene permisos para liberar avales"
                    redirect(controller: 'listaAvales', action: 'revisionAval')
                }
            }
        }
    }

    /**
     * Acción que permite caducar un aval
     */
    def caducarAval = {
        def aval = Aval.get(params.id)
        aval.estado = EstadoAval.findByCodigo("E06")
        aval.save(flush: true)
        redirect(action: "listaAvales")
    }

    /**
     * Acción que permite guardar la anulación de una solicitud de aval
     */
    def guardarAnulacion = {
        println "aprobar anulacion " + params
        def path = servletContext.getRealPath("/") + "avales/"
        new File(path).mkdirs()
        def f = request.getFile('archivo')
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

                    "" : "[\\!@\\\$%\\^&*()='\"\\/<>:;\\.,\\?]",

                    "_": "[\\s]"
            ]

            reps.each { k, v ->
                fileName = (fileName.trim()).replaceAll(v, k)
            }

            fileName = fileName + "_" + new Date().format("mm_ss") + "." + "pdf"

            def pathFile = path + File.separatorChar + fileName
            def src = new File(pathFile)
            def msn

            if (src.exists()) {
                def sol = SolicitudAval.get(params.id)
                flash.message = "Ya existe un archivo con ese nombre. Por favor cámbielo."
                redirect(action: 'aprobarAnulacion', params: [id: sol.id])
            } else {
                def band = false
                def usuario = Persona.get(session.usuario.id)
                def sol = SolicitudAval.get(params.id)
                /*Todo aqui validar quien puede*/
                band = true

                if (band) {
                    f.transferTo(new File(pathFile))
                    def aval = sol.aval
                    aval.pathAnulacion = fileName
//                    aval.memo=sol.memo
                    aval.estado = EstadoAval.findByCodigo("E04")
                    aval.fechaAnulacion = new Date()
//                    aval.monto=sol.monto
                    aval.save(flush: true)
                    sol.estado = EstadoAval.findByCodigo("E02")
                    sol.save(flush: true)
                    flash.message = "Solciitud de anulación aprobada - Aval " + aval.fechaAprobacion.format("yyyy") + "-GP No." + elm.imprimeNumero(aval: "${aval.id}") + " anulado"
                    redirect(action: 'pendientes', controller: 'revisionAval')
                } else {
                    flash.message = "Usted no tiene permisos para aprobar esta solicitud"
                    redirect(controller: 'avales', action: 'listaProcesos')
                }
            }
        }
    }

    /**
     * Acción que permite guardar la aprobación de una solicitud de aval
     */
    def guardarAprobacion = {
        /*TODO enviar alertas*/
        println "aprobar " + params
        def path = servletContext.getRealPath("/") + "avales/"
        new File(path).mkdirs()
        def f = request.getFile('archivo')
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

                    "" : "[\\!@\\\$%\\^&*()='\"\\/<>:;\\.,\\?]",

                    "_": "[\\s]"
            ]

            reps.each { k, v ->
                fileName = (fileName.trim()).replaceAll(v, k)
            }

            fileName = fileName + "_" + new Date().format("mm_ss") + "." + "pdf"

            def pathFile = path + File.separatorChar + fileName
            def src = new File(pathFile)
            def msn

            if (src.exists()) {
                def sol = SolicitudAval.get(params.id)
                flash.message = "Ya existe un archivo con ese nombre. Por favor cámbielo."
                redirect(action: 'aprobarAval', params: [id: sol.id])


            } else {
                def band = false
                def usuario = Usro.get(session.usuario.id)
                def sol = SolicitudAval.get(params.id)
                /*Todo aqui validar quien puede*/
                band = true

                if (band) {
                    f.transferTo(new File(pathFile))
                    def aval = new Aval()
                    aval.proceso = sol.proceso
                    aval.concepto = sol.concepto
                    aval.path = fileName
                    aval.memo = sol.memo
                    aval.numero = sol.numero
                    aval.fechaAprobacion = new Date()
                    aval.estado = EstadoAval.findByCodigo("E02")
                    aval.monto = sol.monto
                    aval.save(flush: true)
                    sol.aval = aval;
                    sol.estado = aval.estado
                    sol.save(flush: true)
                    flash.message = "Solciitud aprobada"
                    redirect(action: 'pendientes', controller: 'revisionAval')
                } else {
                    msn = "Usted no tiene permisos para aprobar esta solicitud"
                    if (params.tipo) {
                        redirect(action: "listaCertificados", params: [cer: cer, id: cer.asignacion.unidad.id])
                    } else {
                        redirect(action: 'listaSolicitudes', params: [msn: msn])
                    }
                }
            }
        }
    }

    /**
     * Acción que muestra la lista de solicitudes de aval pendientes (estadoAval código E01)
     * @param anio el año para el cual se van a mostrar las solicitudes. Si no recibe este parámetro muestra del año actual.
     */
    def pendientes() {
        def estados = [EstadoAval.findByCodigo("E01"), EstadoAval.findByCodigo("D02")]
        def unidades = proyectosService.getUnidadesUnidad(UnidadEjecutora.get(session.unidad.id))
        def personas = Persona.findAllByUnidadInList(unidades)
        def solicitudes = SolicitudAval.findAllByEstadoInListAndUnidadInList(estados, unidades)
        def actual
        if (params.anio) {
            actual = Anio.get(params.anio)
        } else {
            actual = Anio.findByAnio(new Date().format("yyyy"))
        }
        return [solicitudes: solicitudes, actual: actual]
    }

}

