package vesta.avales

import vesta.parametros.poaPac.Anio
import vesta.parametros.UnidadEjecutora
import vesta.seguridad.Firma
import vesta.seguridad.Persona

/**
 * Controlador que muestra las pantallas de manejo de revisiones de avales
 */
class RevisionAvalController {

    /**
     * Acción que muestra la lista de solicitudes de aval pendientes (estadoAval código E01)
     * @param anio el año para el cual se van a mostrar las solicitudes. Si no recibe este parámetro muestra del año actual.
     */
    def pendientes = {
        def solicitudes = SolicitudAval.findAllByEstado(EstadoAval.findByCodigo("E01"))
        def actual
        if (params.anio)
            actual = Anio.get(params.anio)
        else
            actual = Anio.findByAnio(new Date().format("yyyy"))
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
        if (params.anio)
            actual = Anio.get(params.anio)
        else
            actual = Anio.findByAnio(new Date().format("yyyy"))
        [actual: actual]
    }

    /**
     * Acción que muestra la pantalla que permite liberar un aval
     * @param id el id del aval a liberar
     */
    def liberarAval = {
        println("params " + params)
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
        if (params.numero && params.numero != "") {
            numero = " and numero like ('%${numero}%')"
        }
        if (params.sort && params.sort != "") {
            if (!externos.contains(params.sort))
                orderBy = " order by ${params.sort} ${params.order}"
            else
                band = false
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
                    eq("numero", params.numero.toInteger())
                }
                if (params.sort && params.sort != "") {
                    if (!externos.contains(params.sort)) {
                        order(params.sort, params.order)
                    }
                }
            }
            datos += avales
        }

        if (proceso && proceso != "") {
            def datosTemp = []
            datos.each { av ->

                if (av.proceso.nombre =~ proceso) {

                    datosTemp.add(av)
                }
            }
            datos = datosTemp
//            println "datos proceso "+datos
        }
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
            if (params.order == "desc")
                datos = datos.reverse()

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
//        println "historial "+params
        def anio = Anio.get(params.anio).anio
        def numero = params.numero
        def proceso = params.proceso
        def datos = []
        def fechaInicio
        def fechaFin
        if (anio && anio != "") {
            fechaInicio = new Date().parse("dd-MM-yyyy hh:mm:ss", "01-01-" + anio + " 00:01:01")
            fechaFin = new Date().parse("dd-MM-yyyy hh:mm:ss", "31-12-" + anio + " 23:59:59")
            datos += SolicitudAval.findAllByFechaBetween(fechaInicio, fechaFin)
//            println "datos fecha "+datos
        }
        if (numero && numero != "") {
//            println "buscando por numero ==> "+numero
            def datosTemp = []
            datos.each { sol ->
                println "tiene aval? " + sol.aval
                if (sol.aval?.numero =~ numero) {
                    println "encontro "
                    datosTemp.add(sol)
                }
            }
            datos = datosTemp
//            println "datos numero "+datos
        }
        if (proceso && proceso != "") {
            def datosTemp = []
            datos.each { sol ->

                if (sol.proceso.nombre =~ proceso) {
                    println "encontro "
                    datosTemp.add(sol)
                }
            }
            datos = datosTemp
//            println "datos proceso "+datos
        }
        datos = datos.sort { it.fecha }
        datos = datos.reverse()
        [datos: datos]
    }

    /**
     * Acción que muestra la pantalla que permite aprobar una solicitud de aval
     * @param id el id de la solicitud de aval a aprobar
     */
    def aprobarAval = {
        def unidad = UnidadEjecutora.findByCodigo("DPI") // DIRECCIÓN DE PLANIFICACIÓN E INVERSIÓN
        def personasFirmas = Persona.findAllByUnidad(unidad)
        def numero = 0
        def max = Aval.list([sort: "numero", order: "desc", max: 1])
//        println "max " + max.numero
        if (max.size() > 0)
            numero = max[0].numero + 1
        def solicitud = SolicitudAval.get(params.id)
        def band = false
        def usuario = Persona.get(session.usuario.id)
        /*todo validar quien puede*/
        band = true
        if (!band)
            response.sendError(403)
        [solicitud: solicitud, personas: personasFirmas, numero: numero]
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
        if (!band)
            response.sendError(403)
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
        println "guardar datos doc " + params
        def sol = SolicitudAval.get(params.id)
        def obs = params.obs
        if(obs) {
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
        sol.save(flush: true)
        if(params.enviar){
            println "si env"
            if(params.enviar=="true"){
                println "enviar =true"
                def band = false
                def usuario = Persona.get(session.usuario.id)
                /*Todo aqui validar quien puede*/
                band = true
                if (band) {
                    def aval = new Aval()
                    aval.proceso = sol.proceso
                    aval.concepto = sol.concepto
                    aval.path = " "
                    aval.memo = sol.memo
                    aval.numero = sol.numero
                    aval.estado = EstadoAval.findByCodigo("EF1")
                    aval.monto = sol.monto
                    def firma1 = new Firma()
                    firma1.usuario=Usro.get(params.firma2)
                    firma1.accionVer="certificacion"
                    firma1.controladorVer="reportes"
                    firma1.idAccionVer=sol.id
                    firma1.accion="firmarAval"
                    firma1.controlador="revisionAval"
                    firma1.documento="aval_"+ aval.numero
                    firma1.concepto="Aprobación del aval ${aval.numero}"
                    firma1.esPdf="S"
                    if(!firma1.save(flush: true))
                        println "error firma1 "+firma1.errors
                    def firma2 = new Firma()
                    firma2.usuario=Usro.get(params.firma3)
                    firma2.accionVer="certificacion"
                    firma2.controladorVer="reportes"
                    firma2.idAccionVer=sol.id
                    firma2.accion="firmarAval"
                    firma2.controlador="revisionAval"
                    firma2.documento="aval_"+ aval.numero
                    firma2.concepto="Aprobación del aval ${aval.numero}"
                    firma2.esPdf="S"
                    if(!firma2.save(flush: true))
                        println "error firma1 "+firma2.errors
                    aval.firma1=firma1
                    aval.firma2=firma2
                    if(!aval.save(flush: true))
                        println "error save aval"
                    firma1.idAccion=aval.id
                    firma2.idAccion=aval.id
                    firma1.save()
                    firma2.save()
                    sol.aval = aval;
                    sol.estado = aval.estado
                    sol.save(flush: true)
                    //flash.message = "Solciitud de firmas enviada para aprobación"
                } else {
                    def msn = "Usted no tiene permisos para aprobar esta solicitud"
                    if (params.tipo)
                        redirect(action: "listaCertificados", params: [cer: cer, id: cer.asignacion.unidad.id])
                    else
                        redirect(action: 'listaSolicitudes', params: [msn: msn])
                }
            }
        }

        render "ok"


    }


    /**
     * Acción que permite firmar electrónicamente un Aval
     * @params id es el identificador del aval
     */
    def firmarAval = {
        def firma = Firma.findByKey(params.key)
        if(!firma)
            response.sendError(403)
        else{
            def aval = Aval.findByFirma1OrFirma2(firma,firma)
            if(aval.firma1.key!=null && aval.firma2.key!=null){
                aval.fechaAprobacion=new Date()
                aval.estado=EstadoAval.findByCodigo("E02")
                aval.save(flush: true)
                def sol = SolicitudAval.findByAval(aval)
                sol.estado=aval.estado
                sol.save(flush: true)
//            redirect(controller: "pdf",action: "pdfLink",params: [url:g.createLink(controller: firma.controladorVer,action: firma.accionVer,id: firma.idAccionVer)])

            }
            def url =g.createLink(controller: "pdf",action: "pdfLink",params: [url:g.createLink(controller: firma.controladorVer,action: firma.accionVer,id: firma.idAccionVer)])
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
//            params.monto = params.monto.replaceAll("\\.", "")
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

//                flash.message = "Ya existe un archivo con ese nombre. Por favor cámbielo."
//                redirect(action: 'listaAvales')
                render "ERROR*Ya existe un archivo con ese nombre. Por favor cámbielo."
                return


            } else {
                def band = false
                def usuario = Persona.get(session.usuario.id)
                def aval = Aval.get(params.id)
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
                    render "SUCCESS*Aval " +  aval.fechaAprobacion.format("yyyy") + "-GP No." + aval.numero + " Liberado"
                    return

                } else {
                    render "ERROR*Usted no tiene permisos para liberar avales"
                    return
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
                redirect(action: 'aprobarAval', params: [id: sol.id])


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
                    aval.fechaAnulacion=new Date()
//                    aval.monto=sol.monto
                    aval.save(flush: true)
                    sol.estado = EstadoAval.findByCodigo("E02")
                    sol.save(flush: true)
                    flash.message = "Solciitud de anulación aprobada - Aval " + aval.fechaAprobacion.format("yyyy") + "-GP No." + tdn.imprimeNumero(aval: "${aval.id}") + " anulado"
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
                def usuario = Persona.get(session.usuario.id)
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
                    if (params.tipo)
                        redirect(action: "listaCertificados", params: [cer: cer, id: cer.asignacion.unidad.id])
                    else
                        redirect(action: 'listaSolicitudes', params: [msn: msn])
                }
            }
        }
    }


}

