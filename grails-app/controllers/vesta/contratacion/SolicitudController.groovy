package vesta.contratacion

import org.springframework.dao.DataIntegrityViolationException
import vesta.alertas.Alerta
import vesta.parametros.TipoElemento
import vesta.parametros.UnidadEjecutora
import vesta.parametros.poaPac.Anio
import vesta.poa.Asignacion
import vesta.poa.Componente
import vesta.proyectos.Categoria
import vesta.proyectos.MarcoLogico
import vesta.proyectos.Proyecto
import vesta.seguridad.Persona
import vesta.seguridad.Prfl
import vesta.seguridad.Sesn
import vesta.seguridad.Shield

import javax.imageio.ImageIO
import java.awt.image.BufferedImage

import static java.awt.RenderingHints.KEY_INTERPOLATION
import static java.awt.RenderingHints.VALUE_INTERPOLATION_BICUBIC


/**
 * Controlador que muestra las pantallas de manejo de Solicitud
 */
class SolicitudController extends Shield {

    static allowedMethods = [save_ajax: "POST", delete_ajax: "POST"]

    /**
     * Acción que redirecciona a la lista (acción "list")
     */
    def index() {
        redirect(action: "list", params: params)
    }

    /**
     * Retorna el path para subir los archivos
     * @return el path para subir los archivos
     */
    def getPathBase() {
        return servletContext.getRealPath("/") + "solicitudes/"
    }

    /**
     * Redimensiona una imagen a un maximo de 800x800 manteniendo el aspec ratio
     * @param f el archivo a ser redimensionado
     * @param pathFile el path del nuevo archivo
     */
    def resizeImage(f, pathFile) {
        def imageContent = ['image/png': "png", 'image/jpeg': "jpeg", 'image/jpg': "jpg"]
        def ext = ""
        if (imageContent.containsKey(f.getContentType())) {
            ext = imageContent[f.getContentType()]
            /* RESIZE */
            def img = ImageIO.read(new File(pathFile))

            def scale = 0.5

            def minW = 200
            def minH = 200

            def maxW = minW * 4
            def maxH = minH * 4

            def w = img.width
            def h = img.height

            if (w > maxW || h > maxH) {
                int newW = w * scale
                int newH = h * scale
                int r = 1
                if (w > h) {
                    r = w / maxW
                    newW = maxW
                    newH = h / r
                } else {
                    r = h / maxH
                    newH = maxH
                    newW = w / r
                }

                new BufferedImage(newW, newH, img.type).with { j ->
                    createGraphics().with {
                        setRenderingHint(KEY_INTERPOLATION, VALUE_INTERPOLATION_BICUBIC)
                        drawImage(img, 0, 0, newW, newH, null)
                        dispose()
                    }
                    ImageIO.write(j, ext, new File(pathFile))
                }
            }
            /* fin resize */
        } //si es imagen hace resize para que no exceda 800x800
    }


    /**
     * Valida si un archivo es válido
     * @param f el archivo a validar
     * @return true si el archivo es de un tipo válido
     */
    def validateContent(f) {
        return true
    }

    /**
     * Sube un archivo
     * @param tipo el tipo de archivo (tdr, oferta1, oferta2, oferta3, comparativo, analisis, revisiongaf, revisiongj, acta)
     * @param f el archivo a subir
     * @param objeto el objeto en el cual se va a guardar el path del archivo subido
     */
    def uploadFile(tipo, f, objeto) {
        String pathBaseArchivos = getPathBase()
        String archivoTdr = "tdr"
        String archivoTdrGaf = "tdr_gaf"
        String archivoTdrGj = "tdr_gj"
        String archivoTdrGdp = "tdr_gdp"
        String archivoOferta = "oferta"
        String archivoComparativo = "cuadroComparativo"
        String archivoAnalisis = "analisisCostos"
        String archivoActa = "actaAprobacion"

        def path = ""
        def pathArchivo = ""
        def nuevoArchivo = ""

        switch (tipo) {
            case "tdr":
                path = pathBaseArchivos + "${objeto.id}/"
                pathArchivo = objeto.pathPdfTdr
                nuevoArchivo = archivoTdr
                break;
            case "oferta1":
                path = pathBaseArchivos + "${objeto.id}/"
                pathArchivo = objeto.pathOferta1
                nuevoArchivo = archivoOferta + "1"
                break;
            case "oferta2":
                path = pathBaseArchivos + "${objeto.id}/"
                pathArchivo = objeto.pathOferta2
                nuevoArchivo = archivoOferta + "2"
                break;
            case "oferta3":
                path = pathBaseArchivos + "${objeto.id}/"
                pathArchivo = objeto.pathOferta3
                nuevoArchivo = archivoOferta + "3"
                break;
            case "comparativo":
                path = pathBaseArchivos + "${objeto.id}/"
                pathArchivo = objeto.pathCuadroComparativo
                nuevoArchivo = archivoComparativo
                break;
            case "analisis":
                path = pathBaseArchivos + "${objeto.id}/"
                pathArchivo = objeto.pathAnalisisCostos
                nuevoArchivo = archivoAnalisis
                break;
            case "revisiongaf":
                path = pathBaseArchivos + "${objeto.id}/"
                pathArchivo = objeto.pathRevisionGAF
                nuevoArchivo = archivoTdrGaf
                break;
            case "revisiongj":
                path = pathBaseArchivos + "${objeto.id}/"
                pathArchivo = objeto.pathRevisionGJ
                nuevoArchivo = archivoTdrGj
                break;
            case "revisiongdp":
                path = pathBaseArchivos + "${objeto.id}/"
                pathArchivo = objeto.pathRevisionGDP
                nuevoArchivo = archivoTdrGdp
                break;
            case "acta":
                path = pathBaseArchivos + "${objeto.id}/"
                pathArchivo = objeto.pathPdf
                nuevoArchivo = archivoActa
                break;
        }

        /* upload */
        new File(path).mkdirs()
        if (f && !f.empty) {
            if (validateContent(f)) {
                if (pathArchivo) {
                    //si ya existe un archivo lo elimino
                    def oldFile = new File(path + pathArchivo)
                    if (oldFile.exists()) {
                        oldFile.delete()
                    }
                }
                def fileName = f.getOriginalFilename() //nombre original del archivo
                def ext = ""

                def parts = fileName.split("\\.")
                fileName = ""
                parts.eachWithIndex { obj, i ->
                    if (i < parts.size() - 1) {
                        fileName += obj
                    } else {
                        ext = obj
                    }
                }
                def pathFile = path + nuevoArchivo + "." + ext
                try {
                    f.transferTo(new File(pathFile)) // guarda el archivo subido al nuevo path
                } catch (e) {
                    println "????????\n" + e + "\n???????????"
                }

                switch (tipo) {
                    case "tdr":
                        objeto.pathPdfTdr = nuevoArchivo + "." + ext
                        break;
                    case "oferta1":
                        objeto.pathOferta1 = nuevoArchivo + "." + ext
                        break;
                    case "oferta2":
                        objeto.pathOferta2 = nuevoArchivo + "." + ext
                        break;
                    case "oferta3":
                        objeto.pathOferta3 = nuevoArchivo + "." + ext
                        break;
                    case "comparativo":
                        objeto.pathCuadroComparativo = nuevoArchivo + "." + ext
                        break;
                    case "analisis":
                        objeto.pathAnalisisCostos = nuevoArchivo + "." + ext
                        break;
                    case "revisiongaf":
                        objeto.pathRevisionGAF = nuevoArchivo + "." + ext
                        break;
                    case "revisiongj":
                        objeto.pathRevisionGJ = nuevoArchivo + "." + ext
                        break;
                    case "revisiongdp":
                        objeto.pathRevisionGDP = nuevoArchivo + "." + ext
                        break;
                    case "acta":
                        objeto.pathPdf = nuevoArchivo + "." + ext
                        break;
                }
                if (!objeto.save(flush: true)) {
                    println "error al guardar objeto (${tipo}): " + objeto.errors
                }
            }
        }
        /* fin del upload */
    }

    /**
     * Permite descargar un archivo
     * @param tipo el tipo de archivo (tdr, oferta1, oferta2, oferta3, comparativo, analisis, revisiongaf, revisiongj, acta)
     * @param objeto el objeto en el cual está guardado el path del archivo
     */
    def downloadFile(tipo, objeto) {
        def filename = ""
        String pathBaseArchivos = getPathBase()
        switch (tipo) {
            case "tdr":
                filename = objeto.pathPdfTdr
                break;
            case "oferta1":
                filename = objeto.pathOferta1
                break;
            case "oferta2":
                filename = objeto.pathOferta2
                break;
            case "oferta3":
                filename = objeto.pathOferta3
                break;
            case "comparativo":
                filename = objeto.pathCuadroComparativo
                break;
            case "analisis":
                filename = objeto.pathAnalisisCostos
                break;
            case "revisiongaf":
                filename = objeto.pathRevisionGAF
                break;
            case "revisiongj":
                filename = objeto.pathRevisionGJ
                break;
            case "revisiongdp":
                filename = objeto.pathRevisionGDP
                break;
            case "acta":
                filename = objeto.pathPdf
                break;
        }
        def path = pathBaseArchivos + "${objeto.id}/" + filename
        def tipoArchivo = filename.split("\\.")
        switch (tipoArchivo) {
            case "jpeg":
            case "gif":
            case "jpg":
            case "bmp":
            case "png":
                tipoArchivo = "application/image"
                break;
            case "pdf":
                tipoArchivo = "application/pdf"
                break;
            case "doc":
            case "docx":
            case "odt":
                tipoArchivo = "application/msword"
                break;
            case "xls":
            case "xlsx":
                tipoArchivo = "application/vnd.ms-excel"
                break;
            default:
                tipoArchivo = "application/pdf"
                break;
        }
        try {
            def file = new File(path)
            def b = file.getBytes()
            response.setContentType(tipoArchivo)
            response.setHeader("Content-disposition", "attachment; filename=" + (filename))
            response.setContentLength(b.length)
            response.getOutputStream().write(b)
        } catch (e) {
            println "error en download"
            response.sendError(404)
        }
    }


    /**
     * Acción que muestra el listado de solicitudes de contratación. El listado cambia según el perfil:<br/>
     */
    def list () {
        def perfil = session.perfil
        def usuario = Persona.get(session.usuario.id)
        def unidad = usuario.unidad
        params.max = Math.min(params.max ? params.int('max') : 25, 100)
        def todos = ["GP"]
        def c = Solicitud.createCriteria()
        def lista = c.list(params) {
            eq("estado", "P")
            if (!todos.contains(perfil.codigo)) {
                eq("unidadEjecutora", unidad)
            }
            if (params.search) {
                ilike("nombreProceso", "%" + params.search + "%")
            }
        }
        def title = g.message(code: "default.list.label", args: ["Solicitud"], default: "Solicitud List")

        def solicitudInstanceCount = lista.size()
        [solicitudInstanceList: lista, title: title, params: params, solicitudInstanceCount: solicitudInstanceCount]
    }

    /**
     * Acción que muestra el listado de solicitudes de contratación listas para ser incluidas en la reunión de aprobación
     */
    def listAprobacion = {
        def title = g.message(code: "default.list.label", args: ["Solicitud"], default: "Solicitud List")
        params.max = Math.min(params.max ? params.int('max') : 25, 100)
        def list = Solicitud.findAllByAprobacionIsNullAndIncluirReunion("S", params)
        def count = Solicitud.countByAprobacionIsNullAndIncluirReunion("S")
        def solicitudInstanceCount = list.size()
        [solicitudInstanceList: list, solicitudInstanceTotal: count, title: title, params: params, solicitudInstanceCount: solicitudInstanceCount]
    }



    /*Permite ver los datos de la solicitud*/
    /**
     * Acción que muestra una pantalla que permite ver los datos de la solicitud
     */
    def show (){

        println("params " + params)
        def solicitud = Solicitud.get(params.id)
        if (!solicitud) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'solicitud.label', default: 'Solicitud'), params.id])}"
            redirect(action: "list")
        } else {
            def title = g.message(code: "default.show.label", args: ["Solicitud"], default: "Show Solicitud")
            [solicitud: solicitud, title: title, idSolicitud: params.id]
        }
    }

    /*Función para guardar una nueva solicitud*/
    /**
     * Acción que guarda una nueva solicitud
     */
    def save = {

        println("entro save")
        println(params)
        def usuario = Persona.get(session.usuario.id)
        def unidadEjecutora = usuario.unidad

//        println "UNEJ:::: " + unidadEjecutora

        def solicitud = new Solicitud()
        if (params.id) {
            solicitud = Solicitud.get(params.id.toLong())
        } else {
            solicitud.unidadEjecutora = unidadEjecutora
        }
        if (!solicitud.usuario) {
            solicitud.usuario = usuario
        }
        params.fecha = new Date().parse("dd-MM-yyyy", params.fecha_input)
        solicitud.properties = params
        if (!solicitud.save(flush: true)) {
            println "error save1 solicitud " + solicitud.errors
        }

        uploadFile("tdr", request.getFile('tdr'), solicitud)
        uploadFile("oferta1", request.getFile('oferta1'), solicitud)
        uploadFile("oferta2", request.getFile('oferta2'), solicitud)
        uploadFile("oferta3", request.getFile('oferta3'), solicitud)
        uploadFile("comparativo", request.getFile('comparativo'), solicitud)
        uploadFile("analisis", request.getFile('analisis'), solicitud)

        if (!solicitud.save(flush: true)) {
            flash.message = "<h5>Ha ocurrido un error al crear la solicitud</h5>" + renderErrors(bean: solicitud)
        } else {
            println solicitud.formaPago
            def perfilGAF = Prfl.findByCodigo("GAF")
            def perfilGJ = Prfl.findByCodigo("GJ")
            def usuariosGAF = Sesn.findAllByPerfil(perfilGAF).usuario
            def usuariosGJ = Sesn.findAllByPerfil(perfilGJ).usuario
            def from = Persona.get(session.usuario.id)
            def envio = new Date()
            def mensaje = from.nombre + " " + from.apellido + " ha ${params.id ? 'modificado' : 'creado'} una solicitud"
            def controlador = "solicitud"
            def action = "revision"
            def idRemoto = solicitud.id

            (usuariosGAF + usuariosGJ /*+ usuariosGDP*/).each { usu ->
                def alerta = new Alerta()
                alerta.from = from
                alerta.persona = usu
                alerta.fechaEnvio = envio
                alerta.mensaje = mensaje
                alerta.controlador = controlador
                alerta.accion = action
                alerta.id_remoto = idRemoto
                if (!alerta.save(flush: true)) {
                    println "error alerta: " + alerta.errors
                }
            }
        }
        redirect(action: 'show', id: solicitud.id)
    }


    /**
     * Acción que permite incluir o excluir una solicitud de la reunión de aprobación
     */
    def incluirReunion = {
        def solicitud = Solicitud.get(params.id)
        if (solicitud.incluirReunion != "S") {
            solicitud.incluirReunion = "S"
        } else {
            solicitud.incluirReunion = "N"
        }
        solicitud.fechaPeticionReunion = new Date()
        if (!solicitud.save(flush: true)) {
            println "error al incluir/excluir reunion " + solicitud.errors
        }
        /* TODO:
                 enviar mail
         */

        def perfilDireccionPlanificacion = Prfl.findByCodigo("DP")
        def sesiones = Sesn.findAllByPerfil(perfilDireccionPlanificacion)

        if (sesiones.size() > 0) {
            def persona = Persona.get(session.usuario.personaId)
            def msg = "El usuario ${persona.nombre} ${persona.apellido} ha ${solicitud.incluirReunion == 'S' ? 'añadido' : 'removido'}"
            msg += " una solicitud de contratación para que sea tratada en reunión de aprobación."

            println "Se enviaran ${sesiones.size()} mails"
            sesiones.each { sesn ->
                Persona usro = sesn.usuario
                def mail = usro.mail
                println "ENVIAR MAIL A " + mail
            }
        } else {
            println "No hay nadie registrado con perfil de direccion de planificacion: no se mandan mails"
        }

        redirect(action: "show", id: solicitud.id)
    }


    /**
     * Acción llamada con ajax que genera un combo box con los componentes de un proyecto
     * @Renders el combo box y el código ajax para cargar las actividades
     */
    def getComponentesByProyecto = {
        def tipoComponente = TipoElemento.get(2)

        def proyecto = Proyecto.get(params.id?.toLong())
        def componentes = MarcoLogico.findAllByProyectoAndTipoElemento(proyecto, tipoComponente)

        def parms = [from     : componentes, name: "componente.id", id: "selComponente", class: "form-control input-sm",
                     optionKey: "id", optionValue: "objeto"]
        if (params.val) {
            parms.value = params.val
        }

        def sel = g.select(parms)
        def js = "<script type=\"text/javascript\">" +
                "\$(\"#selComponente\").change(function() {" +
                "   loadActividades();" +
                "});" +
                "</script>"
        render sel + js
    }


    /**
     * Crea un combo box de actividades
     * @param compId el componente padre
     * @param selected el valor seleccionado
     * @param width el ancho del combo box
     * @return
     */
    def comboActividades(compId, selected, width) {
        def tipoActividad = TipoElemento.get(3)

        def componente = MarcoLogico.get(compId)
        def actividades = []

        def anio = Anio.findByAnio(new Date().format("yyyy"))

        MarcoLogico.findAllByMarcoLogicoAndTipoElemento(componente, tipoActividad).each { act ->
            def tieneAsignacion = Asignacion.countByMarcoLogicoAndAnio(act, anio) > 0
            def id = act.id
            def str = act.objeto
            if (!tieneAsignacion) {
                str += " (*)"
                act.tieneAsignacion = 'N'
                act.save(flush: true)
            }
            actividades.add([id: id, objeto: str])
        }
        def parms = [from     : actividades, name: "actividad.id", id: "selActividad", class: "form-control input-sm",
                     optionKey: "id", optionValue: "objeto"]
        if (selected) {
            parms.value = selected
        }
        def sel = g.select(parms)
//        def btn = "<div class='col-md-2'><a href='#' id='btnAddActividad' class='button btn btn-success btn-sm' style='margin-left: 3px;'><i class='fa fa-plus'></i></a></div>"
        def js = "<script type=\"text/javascript\">" +
                "\$(\"#selActividad\").change(function() {" +
                "   loadDatosActividad();" +
                "});" +
//                "\$('#btnAddActividad').button({text:false,icons:{primary:'ui-icon-plusthick'}}).click(function() {" +
//                "crearActividad();" +
//                "});" +
                "</script>"
        return sel + /*btn + */js
    }


    /**
     * Acción llamada con ajax que muestra un combo box de actividades para un cierto componente
     * @param id el id del componente
     * @param val el valor que debe ser seleccionado
     * @param width el ancho del combo box
     * @Returns el combo de actividades
     */
    def getActividadesByComponente = {
        render comboActividades(params.id, params.val, params.width)
    }

    /**
     * Acción llamada con ajax que busca los datos de una actividad
     * @param id el id de la actividad
     * @Renders el objeto de la actividad, el monto, las asignaciones y la duración en días
     */
    def getDatosActividad = {
        def actividad = MarcoLogico.get(params.id.toLong())
        def anio = Anio.findByAnio(new Date().format("yyyy"))
        def asignaciones = Asignacion.countByMarcoLogicoAndAnio(actividad, anio)
        def days = 0
        use(groovy.time.TimeCategory) {
            def duration = actividad.fechaFin - actividad.fechaInicio
            days = duration.days
        }

        render actividad.objeto + "||" + actividad.monto + "||" + asignaciones + "||" + days
    }


    /**
     * Acción llamada con ajax que crea una nueva actividad
     * @params los parámetros enviados por el formulario de cración de actividad
     * @Renders el combo de actividades con la nueva actividad seleccionada
     */
    def newActividad_ajax = {
        println("entro save " + params)
        def usuario = Persona.get(session.usuario.id)
        def unidadEjecutora = usuario.unidad
        def tipoActividad = TipoElemento.get(3)
        def actividad = new MarcoLogico()

        def proyecto = Proyecto.get(params."proyecto.id".toLong())
        def componente = MarcoLogico.get(params."componente.id".toLong())
        def categoria = null
//        if (params.cat.trim() != "") {
            categoria = Categoria.get(params.nuevaCategoria.toLong())
//        }

        def fechaInicio
        def fechaFin

        if(params.fechaInicio_input){
            fechaInicio = new Date().parse("dd-MM-yyyy", params.fechaInicio_input)
        }

        if(params.fechaFin_input){
            fechaFin = new Date().parse("dd-MM-yyyy", params.fechaFin_input)
        }

//        params.monto = params.monto.replaceAll("\\.", "")
        params.nuevoMonto = params.nuevoMonto.replaceAll(",", "")

        actividad.proyecto = proyecto
        actividad.tipoElemento = tipoActividad
        actividad.marcoLogico = componente
        actividad.objeto = params.nuevaActividad
        actividad.monto = params.nuevoMonto.toDouble()
        actividad.estado = 0
        actividad.categoria = categoria
        actividad.fechaInicio = fechaInicio
        actividad.fechaFin = fechaFin
        actividad.responsable = unidadEjecutora
        actividad.tieneAsignacion = "N"

        if (!actividad.save(flush: true)) {
//            println "Error al guardar actividad: " + actividad.errors
            render "ERROR*Ha ocurrido un error al guardar la actividad: " + renderErrors(bean: actividad)
            return
        }

        render "SUCCESS*Creación de Actividad exitosa."
        return


//        render comboActividades(componente.id, actividad.id, params.width)
    }

    /**
     * Acción llamada con ajax que permite modificar el monto de una solicitud
     * @param id el de la solicitud
     * @param monto el nuevo monto de la solicitud
     * @Renders "OK_"+mensaje en caso de guardar correctamente, "NO_"+mensaje de error en caso contrario
     */
    def cambiarMax = {
        def solicitud = Solicitud.get(params.id)
        def nuevoVal = params.monto.toDouble()

        def msg = ""

        if (nuevoVal > solicitud.actividad.monto) {
            nuevoVal = solicitud.actividad.monto
            msg += "_No puede asignar más de " + formatNumber(number: solicitud.actividad.monto, type: "currency")
        }

        solicitud.montoSolicitado = nuevoVal
        if (solicitud.save(flush: true)) {
            if (msg == "") {
                msg += "_Valor máximo actualizado a " + formatNumber(number: nuevoVal, type: "currency")
            } else {
                msg += ", se ha actualizado al máximo permitido"
            }
            render "OK" + msg
        } else {
            render "NO_" + renderErrors(bean: solicitud)
        }
    }


    /**
     * Acción llamada con ajax que permite actualizar el monto de un detalle de la solicitud
     * @param id el id de la solicitud
     * @param valores los valores separados por ;
     * @Renders "OK_"+montoSolicitado+"_"+montoTotal en caso de guardar correctamente, una lista de los errores en caso contrario
     */
    def updateDetalleMonto_ajax = {
        def solicitud = Solicitud.get(params.id)
        def valores = params.valores
        def errores = ""

        def anios = []
        def total = 0

        (valores.split(";")).each { val ->
            def parts = val.split("_")
            if (parts.size() == 2) {
                def a = parts[0]
                def anio = Anio.findByAnio(a)
                anios += a
                def monto = parts[1].toDouble()
                def detalle = DetalleMontoSolicitud.findByAnioAndSolicitud(anio, solicitud)
                if (!detalle) {
                    detalle = new DetalleMontoSolicitud()
                    detalle.anio = anio
                    detalle.solicitud = solicitud
                }
                detalle.monto = monto
                total += monto
                if (!detalle.save(flush: true)) {
                    errores += "<li>" + renderErrors(bean: detalle) + "</li>"
                }
            }
        }

        def porEliminar = []
        //verifico si la asignacion para algun anio fue eliminada
        DetalleMontoSolicitud.findAllBySolicitud(solicitud).each { d ->
            if (!anios.contains(d.anio.anio)) {
                porEliminar += d.id
            }
        }
        porEliminar.each { id ->
            def det = DetalleMontoSolicitud.get(id)
            det.delete(flush: true)
        }
        if (errores == "") {
            render "OK_" + formatNumber(number: solicitud.montoSolicitado, maxFractionDigits: 2, minFractionDigits: 2) + "_" +
                    formatNumber(number: total, type: "currency")
        } else {
            render "<ul>" + errores + "</ul>"
        }
    }


    /**
     * Acción que muestra los detalles de planificación del monto de una solicitud por año
     * @param id el id de la solicitud
     */
    def detalleMonto = {
        def solicitud = Solicitud.get(params.id)
        def anio = new Date().format("yyyy").toInteger()
//        def anios = Anio.findAllByAnioGreaterThanEquals(anio, [sort: "anio"])
        def anios = []
        Anio.list([sort: "anio"]).each { a ->
            if (a.anio.toInteger() >= anio) {
                anios += a
            }
        }

        return [solicitud: solicitud, anios: anios]
    }


    /**
     * Acción llamada con ajax que agregar un detalle de monto de la solicitud
     * @param id el id de la solicitud
     * @param anio el id del año
     * @param monto el monto
     * @deprecated ahora se utiliza la acción updateDetalleMonto_ajax
     */
    @Deprecated
    def addDetalleMonto = {
        def solicitud = Solicitud.get(params.id)
        def anio = Anio.get(params.anio)
        def monto = params.monto/*.replaceAll("\\.", "")
        monto = monto.replaceAll(",", ".")*/
        monto = monto.toDouble()
        def detalle = DetalleMontoSolicitud.findAllByAnioAndSolicitud(anio, solicitud)
        if (detalle.size() == 1) {
            detalle = detalle.first()
        } else if (detalle.size() > 1) {
            println "hay ${detalle.size()} detalles anio: ${anio.anio} solicitud: ${solicitud.id}: " + detalle.id
            detalle = detalle.first()
        } else {
            detalle = new DetalleMontoSolicitud()
            detalle.solicitud = solicitud
            detalle.anio = anio
        }
        detalle.monto = monto
        if (detalle.save(flush: true)) {
            render "OK"
        } else {
            println "Error al guardar detalle monto solicitud: " + detalle.errors
            render "NO_" + renderErrors(bean: detalle)
        }
    }


    /**
     * Acción que muestra el formulario de creación o edición de una solicitud de contratación<br/>
     * Verifica según el perfil si puede o no ver el formulario. Si no puede, redirecciona a la acción Show o a List
     * dependiendo de si se envía o no el parámetro id
     * @param id el id de la solicitud en caso de que sea edición
     */
    def ingreso = {
        if (session.perfil.codigo == "RQ" || session.perfil.codigo == "DRRQ") {
            def usuario = Persona.get(session.usuario.id)
            def unidadEjecutora = usuario.unidad
            def solicitud = new Solicitud()
            def title = "Nueva"
            def asignado = 0
            if (params.id) {
                solicitud = solicitud.get(params.id)
/*
                println session.unidad.id
                println solicitud.unidadEjecutora.id
                println session.unidad.id != solicitud.unidadEjecutora.id
*/

                if (session.unidad.id != solicitud.unidadEjecutora.id) {
//                    println "se fue a list"
                    redirect(action: "list")
                    return
                }
                if (solicitud.estado == 'A') {
                    redirect(action: "show", id: solicitud.id)
                    return
                }
                title = "Modificar"
                if (!solicitud) {
                    flash.message = "No se encontró la solicitud"
                    solicitud = new Solicitud()
                }

                DetalleMontoSolicitud.findAllBySolicitud(solicitud).each { d ->
                    asignado += d.monto
                }
            }
            title += " solicitud"

            def proys = MarcoLogico.withCriteria {
                eq("responsable", session.unidad)
                projections {
                    distinct("proyecto")
                }
            }

            return [unidadRequirente: unidadEjecutora, solicitud: solicitud, title: title, proyectos: proys,
                    asignado        : formatNumber(number: asignado, type: "currency"), perfil: session.perfil]
        } else {
            if (params.id) {
                redirect(action: "show", id: params.id)
            } else {
                redirect(action: "list")
            }
        }
    }

    /**
     * Acción que muestra la pantalla de aprobación de solicitud<br/>
     * Según el perfil del usuario permite o no editar
     * @param id el id de la solicitud
     */
    def aprobacion = {
        def solicitud = Solicitud.get(params.id.toLong())
        def perfil = Prfl.get(session.perfil.id)
        def title = "Aprobar solicitud"
        if (!(solicitud.revisadoJuridica && solicitud.revisadoAdministrativaFinanciera/* && solicitud.revisadoDireccionProyectos*/)) {
            redirect(action: "show", id: solicitud.id)
            return
        }
        Aprobacion aprobacion = new Aprobacion()
//        if (solicitud) {
//            aprobacion = Aprobacion.findBySolicitud(solicitud)
//            if (!aprobacion) {
//                aprobacion = new Aprobacion()
//            }
//        }

        def unidadGerenciaPlan = UnidadEjecutora.findByCodigo("DRPL") // GERENCIA DE PLANIFICACIÓN
        def unidadDireccionPlan = UnidadEjecutora.findByCodigo("DPI") // DIRECCIÓN DE PLANIFICACIÓN E INVERSIÓN
        def unidadGerenciaTec = UnidadEjecutora.findByCodigo("GT") // GERENCIA TÉCNICA
        def unidadRequirente = solicitud.unidadEjecutora

        def firmaGerenciaPlanif = Persona.findAllByUnidad(unidadGerenciaPlan)
        def firmaDireccionPlanif = Persona.findAllByUnidad(unidadDireccionPlan)
        def firmaGerenciaTec = Persona.findAllByUnidad(unidadGerenciaTec)
        def firmaRequirente = Persona.findAllByUnidad(unidadRequirente)

        return [solicitud           : solicitud, perfil: perfil, title: title, aprobacion: aprobacion, firmaGerenciaPlanif: firmaGerenciaPlanif,
                firmaDireccionPlanif: firmaDireccionPlanif, firmaGerenciaTec: firmaGerenciaTec, firmaRequirente: firmaRequirente]
    }



    /**
     * Acción que guarda la aprobación realizada y redirecciona a la acción Show
     * @params los parámetros enviados por el formulario
     */
    def saveAprobacion = {
        def aprobacion = new Aprobacion()
        if (params.id) {
            aprobacion = Aprobacion.get(params.id.toLong())
        }
        if (params.fecha) {
            params.fecha = new Date().parse(params.fecha, "dd-MM-yyyy")
        } else {
            params.fecha = new Date()
        }
        aprobacion.properties = params
        if (aprobacion.save(flush: true)) {
            aprobacion.solicitud.estado = "A"
            if (!aprobacion.solicitud.save(flush: true)) {
                println "error al cambiar de estado la solicitud: " + aprobacion.solicitud.errors
            }
        } else {
            println "error al guardar aprobacion: " + aprobacion.errors
        }
        redirect(action: "show", id: aprobacion.solicitudId)
    }



    /**
     * Acción que permite cargar el acta firmada y redirecciona a la acción Show
     * @param id el id de la aprobación
     * @param pdf el request del archivo enviado
     */
    def uploadActa = {
        def aprobacion = Aprobacion.get(params.id.toLong())
        uploadFile("acta", request.getFile('pdf'), aprobacion)
        redirect(controller: 'aprobacion', action: "listaActas")
    }

    /**
     * Acción que permite descargar la solicitud
     * @param id el id de la solicitud
     * @param tipo el tipo de archivo a descargar
     */
    def downloadSolicitud = {
        def solicitud = Solicitud.get(params.id.toLong())
        downloadFile(params.tipo, solicitud)
    }

    /**
     * Acción que permite descargar el acta
     * @param id el id de la solicitud
     * @param tipo el tipo de archivo a descargar
     */
    def downloadActa = {
        def aprobacion = Aprobacion.get(params.id.toLong())
        downloadFile("acta", aprobacion)
    }







    //nuevo

    /**
     * Función que saca la lista de elementos según los parámetros recibidos
     * @param params objeto que contiene los parámetros para la búsqueda:: max: el máximo de respuestas, offset: índice del primer elemento (para la paginación), search: para efectuar búsquedas
     * @param all boolean que indica si saca todos los resultados, ignorando el parámetro max (true) o no (false)
     * @return lista de los elementos encontrados
     */
    def getList(params, all) {
        params = params.clone()
        params.max = params.max ? Math.min(params.max.toInteger(), 100) : 10
        params.offset = params.offset ?: 0
        if (all) {
            params.remove("max")
            params.remove("offset")
        }
        def list
        if (params.search) {
            def c = Solicitud.createCriteria()
            list = c.list(params) {
                or {
                    /* TODO: cambiar aqui segun sea necesario */

                    ilike("asistentesAprobacion", "%" + params.search + "%")
                    ilike("estado", "%" + params.search + "%")
                    ilike("formaPago", "%" + params.search + "%")
                    ilike("incluirReunion", "%" + params.search + "%")
                    ilike("nombreProceso", "%" + params.search + "%")
                    ilike("objetoContrato", "%" + params.search + "%")
                    ilike("observaciones", "%" + params.search + "%")
                    ilike("observacionesAdministrativaFinanciera", "%" + params.search + "%")
                    ilike("observacionesAprobacion", "%" + params.search + "%")
                    ilike("observacionesDireccionProyectos", "%" + params.search + "%")
                    ilike("observacionesJuridica", "%" + params.search + "%")
                    ilike("pathAnalisisCostos", "%" + params.search + "%")
                    ilike("pathAprobacion", "%" + params.search + "%")
                    ilike("pathCuadroComparativo", "%" + params.search + "%")
                    ilike("pathOferta1", "%" + params.search + "%")
                    ilike("pathOferta2", "%" + params.search + "%")
                    ilike("pathOferta3", "%" + params.search + "%")
                    ilike("pathPdfTdr", "%" + params.search + "%")
                    ilike("pathRevisionGAF", "%" + params.search + "%")
                    ilike("pathRevisionGDP", "%" + params.search + "%")
                    ilike("pathRevisionGJ", "%" + params.search + "%")
                    ilike("revisionDireccionPlanificacionInversion", "%" + params.search + "%")
                }
            }
        } else {
            list = Solicitud.list(params)
        }
        if (!all && params.offset.toInteger() > 0 && list.size() == 0) {
            params.offset = params.offset.toInteger() - 1
            list = getList(params, all)
        }
        return list
    }

    /**
     * Acción que muestra la lista de elementos
     * @return solicitudInstanceList: la lista de elementos filtrados, solicitudInstanceCount: la cantidad total de elementos (sin máximo)
     */
//    def list() {
//        def solicitudInstanceList = getList(params, false)
//        def solicitudInstanceCount = getList(params, true).size()
//        return [solicitudInstanceList: solicitudInstanceList, solicitudInstanceCount: solicitudInstanceCount]
//    }

    /**
     * Acción llamada con ajax que muestra la información de un elemento particular
     * @return solicitudInstance el objeto a mostrar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
//    def show_ajax() {
//        if (params.id) {
//            def solicitudInstance = Solicitud.get(params.id)
//            if (!solicitudInstance) {
//                render "ERROR*No se encontró Solicitud."
//                return
//            }
//            return [solicitudInstance: solicitudInstance]
//        } else {
//            render "ERROR*No se encontró Solicitud."
//        }
//    } //show para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que muestra un formulario para crear o modificar un elemento
     * @return solicitudInstance el objeto a modificar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def form_ajax() {
        def solicitudInstance = new Solicitud()
        if (params.id) {
            solicitudInstance = Solicitud.get(params.id)
            if (!solicitudInstance) {
                render "ERROR*No se encontró Solicitud."
                return
            }
        }
        solicitudInstance.properties = params
        return [solicitudInstance: solicitudInstance]
    } //form para cargar con ajax en un dialog



//    /**
//     * Acción llamada con ajax que muestra un formulario para crear o modificar un elemento
//     * @return solicitudInstance el objeto a modificar cuando se encontró el elemento
//     * @render ERROR*[mensaje] cuando no se encontró el elemento
//     */
//    def ingreso() {
//        def solicitudInstance = new Solicitud()
//        if (params.id) {
//            solicitudInstance = Solicitud.get(params.id)
//            if (!solicitudInstance) {
//                render "ERROR*No se encontró Solicitud."
//                return
//            }
//        }
//        solicitudInstance.properties = params
//        return [solicitudInstance: solicitudInstance]
//    } //form para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que guarda la información de un elemento
     * @render ERROR*[mensaje] cuando no se pudo grabar correctamente, SUCCESS*[mensaje] cuando se grabó correctamente
     */
    def save_ajax() {
        def solicitudInstance = new Solicitud()
        if (params.id) {
            solicitudInstance = Solicitud.get(params.id)
            if (!solicitudInstance) {
                render "ERROR*No se encontró Solicitud."
                return
            }
        }
        solicitudInstance.properties = params
        if (!solicitudInstance.save(flush: true)) {
            render "ERROR*Ha ocurrido un error al guardar Solicitud: " + renderErrors(bean: solicitudInstance)
            return
        }
        render "SUCCESS*${params.id ? 'Actualización' : 'Creación'} de Solicitud exitosa."
        return
    } //save para grabar desde ajax

    /**
     * Acción llamada con ajax que permite eliminar un elemento
     * @render ERROR*[mensaje] cuando no se pudo eliminar correctamente, SUCCESS*[mensaje] cuando se eliminó correctamente
     */
    def delete_ajax() {
        if (params.id) {
            def solicitudInstance = Solicitud.get(params.id)
            if (!solicitudInstance) {
                render "ERROR*No se encontró Solicitud."
                return
            }
            try {
                solicitudInstance.delete(flush: true)
                render "SUCCESS*Eliminación de Solicitud exitosa."
                return
            } catch (DataIntegrityViolationException e) {
                render "ERROR*Ha ocurrido un error al eliminar Solicitud"
                return
            }
        } else {
            render "ERROR*No se encontró Solicitud."
            return
        }
    } //delete para eliminar via ajax


    def nuevaActividad () {

        println("params " + params)

        def actividad = new MarcoLogico()
        def proyecto = Proyecto.get(params.proy)
        def componente = MarcoLogico.get(params.comp)


        println("proy " + proyecto)

        return [actividadInstance : actividad, proyecto: proyecto, componente: componente]

    }

}
