package vesta.proyectos

import groovy.json.JsonBuilder
import org.springframework.dao.DataIntegrityViolationException
import vesta.parametros.UnidadEjecutora
import vesta.seguridad.Shield

import javax.imageio.ImageIO
import java.awt.image.BufferedImage

import static java.awt.RenderingHints.KEY_INTERPOLATION
import static java.awt.RenderingHints.VALUE_INTERPOLATION_BICUBIC


/**
 * Controlador que muestra las pantallas de manejo de Documento
 */
class DocumentoController extends Shield {

    static allowedMethods = [save_ajax: "POST", delete_ajax: "POST"]

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
        def lista
        if (params.search) {
//            def c = Documento.createCriteria()
//            lista = c.lista(params) {
//                or {
////                    proyecto {
////                        or {
////                            ilike("nombre", "%" + params.search + "%")
////                            ilike("codigoProyecto", "%" + params.search + "%")
////                        }
////                    }
////                    grupoProcesos {
////                        ilike("descripcion", "%" + params.search + "%")
////                    }
//                    or {
//                        ilike("descripcion", "%" + params.search + "%")
//                        ilike("clave", "%" + params.search + "%")
//                        ilike("resumen", "%" + params.search + "%")
//                    }
//                }
//            }
            def res = []
            def c = Documento.createCriteria()
            lista = c.list(params) {
                proyecto {
                    or {
                        ilike("nombre", "%" + params.search + "%")
                        ilike("codigoProyecto", "%" + params.search + "%")
                    }
                }
            }
            res += lista
            c = Documento.createCriteria()
            lista = c.list(params) {
                grupoProcesos {
                    ilike("descripcion", "%" + params.search + "%")
                }
            }
            res += lista

            c = Documento.createCriteria()
            lista = c.list(params) {
                or {
                    ilike("descripcion", "%" + params.search + "%")
                    ilike("clave", "%" + params.search + "%")
                    ilike("resumen", "%" + params.search + "%")
                }
            }
            res += lista

            lista = res
        } else {
            lista = Documento.list(params)
        }
        if (!all && params.offset.toInteger() > 0 && lista.size() == 0) {
            params.offset = params.offset.toInteger() - 1
            lista = getList(params, all)
        }
        return lista
    }

    /**
     * Acción que muestra una lista de todos los documentos de todos los proyectos
     */
    def list() {
        def documentoInstanceList = getList(params, false)
        def documentoInstanceCount = getList(params, true).size()
        return [documentoInstanceList: documentoInstanceList, documentoInstanceCount: documentoInstanceCount]
    }

    /**
     * Acción llamada con ajax que muestra y permite modificar los documentos de una unidad ejecutora
     */
    def listUnidad_ajax() {
        def unidad = UnidadEjecutora.get(params.id)
        return [unidad: unidad]
    }

    /**
     * Acción llamada con ajax que llena la tabla de los documentos de una unidad
     */
    def tablaDocumentosUnidad_ajax() {
        def unidad = UnidadEjecutora.get(params.id)
        def documentos = Documento.withCriteria {
            eq("unidadEjecutora", unidad)
            if (params.search && params.search != "") {
                or {
                    ilike("descripcion", "%" + params.search + "%")
                    ilike("clave", "%" + params.search + "%")
                    ilike("resumen", "%" + params.search + "%")
                }
            }
            order("descripcion", "asc")
        }
        return [unidad: unidad, documentos: documentos]
    }

    /**
     * Acción llamada con ajax que muestra un formulario para crear o modificar un elemento
     * @return documentoInstance el objeto a modificar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def formUnidad_ajax() {
        def unidad = UnidadEjecutora.get(params.unidad.toLong())
        def documentoInstance = new Documento()
        if (params.id) {
            documentoInstance = Documento.get(params.id)
            if (!documentoInstance) {
//                render "ERROR*No se encontró Documento."
//                return
                documentoInstance = new Documento()
            }
        }
        documentoInstance.properties = params
        documentoInstance.unidadEjecutora = unidad
        return [documentoInstance: documentoInstance]
    } //form para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que muestra y permite modificar los documentos de un proyecto
     */
    def listProyecto_ajax() {
        def proyecto = Proyecto.get(params.id)
        return [proyecto: proyecto]
    }

    /**
     * Acción llamada con ajax que llena la tabla de los documentos de un proyecto
     */
    def tablaDocumentosProyecto_ajax() {
        def proyecto = Proyecto.get(params.id)
        def documentos = Documento.withCriteria {
            eq("proyecto", proyecto)
            if (params.search && params.search != "") {
                or {
                    ilike("descripcion", "%" + params.search + "%")
                    ilike("clave", "%" + params.search + "%")
                    ilike("resumen", "%" + params.search + "%")
                }
            }
            order("descripcion", "asc")
        }
        return [proyecto: proyecto, documentos: documentos]
    }

    /**
     * Acción llamada con ajax que muestra la información de un elemento particular
     * @return documentoInstance el objeto a mostrar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def show_ajax() {
        if (params.id) {
            def documentoInstance = Documento.get(params.id)
            if (!documentoInstance) {
                render "ERROR*No se encontró Documento."
                return
            }
//            println ".... show_ajax ${documentoInstance?.proyecto.nombre}"
            return [documentoInstance: documentoInstance]
        } else {
            render "ERROR*No se encontró Documento."
        }
    } //show para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que muestra un formulario para crear o modificar un elemento
     * @return documentoInstance el objeto a modificar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def formProyecto_ajax() {
        def proyecto = Proyecto.get(params.proyecto.toLong())
        def documentoInstance = new Documento()
        if (params.id) {
            documentoInstance = Documento.get(params.id)
            if (!documentoInstance) {
//                render "ERROR*No se encontró Documento."
//                return
                documentoInstance = new Documento()
            }
        }
        documentoInstance.properties = params
        documentoInstance.proyecto = proyecto
        return [documentoInstance: documentoInstance]
    } //form para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que guarda la información de un elemento
     * @render ERROR*[mensaje] cuando no se pudo grabar correctamente, SUCCESS*[mensaje] cuando se grabó correctamente
     */
    def save_ajax() {
        def proyecto, unidad, proyName, uniName
        if (params.proyecto && params.proyecto.id) {
            proyecto = Proyecto.get(params.proyecto.id.toLong())
            proyName = proyecto.nombre.tr(/áéíóúñÑÜüÁÉÍÓÚàèìòùÀÈÌÒÙÇç .!¡¿?&#°"'/, "aeiounNUuAEIOUaeiouAEIOUCc_")
        }
        if (params.unidad && params.unidad.id) {
            unidad = UnidadEjecutora.get(params.unidad.id.toLong())
            uniName = (unidad.nombre + "_" + unidad.codigo).tr(/áéíóúñÑÜüÁÉÍÓÚàèìòùÀÈÌÒÙÇç .!¡¿?&#°"'/, "aeiounNUuAEIOUaeiouAEIOUCc_")
        }

        def anio = new Date().format("yyyy")
        def pathSave = ""
        if (proyName) {
            pathSave = "${session.unidad.codigo}/" + anio + "/" + proyName + "/"
        } else if (uniName) {
            pathSave = uniName + "/" + anio + "/"
        }
        def path = servletContext.getRealPath("/") //+ "documentosProyecto/" + pathSave
        if (proyName) {
            path += "documentosProyecto/" + pathSave
        } else if (uniName) {
            path += "documentosUnidad/" + pathSave
        }
        //web-app/archivos
        new File(path).mkdirs()
        def f = request.getFile('documento')  //archivo = name del input type file
        def imageContent = ['image/png': "png", 'image/jpeg': "jpeg", 'image/jpg': "jpg"]
        def okContents = [
                'image/png'                                                                : "png",
                'image/jpeg'                                                               : "jpeg",
                'image/jpg'                                                                : "jpg",

                'application/pdf'                                                          : 'pdf',
                'application/download'                                                     : 'pdf',
                'application/vnd.ms-pdf'                                                   : 'pdf',

                'application/excel'                                                        : 'xls',
                'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'        : 'xlsx',

                'application/mspowerpoint'                                                 : 'pps',
                'application/vnd.ms-powerpoint'                                            : 'pps',
                'application/powerpoint'                                                   : 'ppt',
                'application/x-mspowerpoint'                                               : 'ppt',
                'application/vnd.openxmlformats-officedocument.presentationml.slideshow'   : 'ppsx',
                'application/vnd.openxmlformats-officedocument.presentationml.presentation': 'pptx',

                'application/msword'                                                       : 'doc',
                'application/vnd.openxmlformats-officedocument.wordprocessingml.document'  : 'docx',

                'application/vnd.oasis.opendocument.text'                                  : 'odt',

                'application/vnd.oasis.opendocument.presentation'                          : 'odp',

                'application/vnd.oasis.opendocument.spreadsheet'                           : 'ods'
        ]

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

            if (okContents.containsKey(f.getContentType())) {
                ext = okContents[f.getContentType()]
                fileName = fileName.size() < 40 ? fileName : fileName[0..39]
                fileName = fileName.tr(/áéíóúñÑÜüÁÉÍÓÚàèìòùÀÈÌÒÙÇç .!¡¿?&#°"'/, "aeiounNUuAEIOUaeiouAEIOUCc_")

                def nombre = fileName + "." + ext
                def pathFile = path + nombre
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
                    f.transferTo(new File(pathFile)) // guarda el archivo subido al nuevo path
                } catch (e) {
                    println "????????\n" + e + "\n???????????"
                }

                if (imageContent.containsKey(f.getContentType())) {
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
//                println "llego hasta aca"

                //aqui guarda el obj en la base
                def documentoInstance = new Documento()
                if (params.id) {
                    documentoInstance = Documento.get(params.id)
                    if (!documentoInstance) {
                        documentoInstance = new Documento()
                        println "ERROR*No se encontró Documento."
                    }
                }
                params.remove("documento")
                documentoInstance.properties = params
                documentoInstance.documento = pathSave + nombre
                if (unidad) {
                    documentoInstance.unidadEjecutora = unidad
                }
//                documentoInstance.unidadEjecutora = session.unidad
                if (!documentoInstance.save(flush: true)) {
                    render "ERROR*Ha ocurrido un error al guardar Documento: " + renderErrors(bean: documentoInstance)
                    def file = new File(pathFile)
                    file.delete()
                    return
                }
                render "SUCCESS*${params.id ? 'Actualización' : 'Creación'} de Documento exitosa."
                return
            } //ok contents
            else {
                println "llego else no se acepta"
                render "ERROR*Extensión no permitida."
                return
            }
        } //f && !f.empty
        else {
            if (params.id) {
//                def documentoInstance = new Documento()
                def documentoInstance = Documento.get(params.id)
                if (!documentoInstance) {
                    documentoInstance = new Documento()
                    println "ERROR*No se encontró Documento."
                }
                params.remove("documento")
                documentoInstance.properties = params
                if (params.unidad && params.unidad.id) {
                    documentoInstance.unidadEjecutora = UnidadEjecutora.get(params.unidad.id.toLong())
                } else {
                    documentoInstance.unidadEjecutora = session.unidad
                }
                if (!documentoInstance.save(flush: true)) {
                    render "ERROR*Ha ocurrido un error al guardar Documento: " + renderErrors(bean: documentoInstance)
                    return
                }
                render "SUCCESS*${params.id ? 'Actualización' : 'Creación'} de Documento exitosa."
                return
            } else {
                render "ERROR*No se encontró un Documento que modificar"
                return
            }
        }
    } //save para grabar desde ajax

    /**
     * Acción llamada con ajax que permite eliminar un elemento
     * @render ERROR*[mensaje] cuando no se pudo eliminar correctamente, SUCCESS*[mensaje] cuando se eliminó correctamente
     */
    def delete_ajax() {
        if (params.id) {
            def documentoInstance = Documento.get(params.id)
            if (!documentoInstance) {
                render "ERROR*No se encontró Documento."
                return
            }
            try {
                def path = servletContext.getRealPath("/") + "documentosProyecto/" + documentoInstance.documento
                documentoInstance.delete(flush: true)
                println path
                def f = new File(path)
                println f.delete()
                render "SUCCESS*Eliminación de Documento exitosa."
                return
            } catch (DataIntegrityViolationException e) {
                render "ERROR*Ha ocurrido un error al eliminar Documento"
                return
            }
        } else {
            render "ERROR*No se encontró Documento."
            return
        }
    } //delete para eliminar via ajax

    /**
     * Acción llamada con ajax que verifica la existencia de un documento antes de ser descargado
     */
    def existeDoc_ajax() {
        def doc = Documento.get(params.id)
        def path
        if (doc.proyecto) {
            path = servletContext.getRealPath("/") + "documentosProyecto/" + doc.documento
        } else {
            path = servletContext.getRealPath("/") + "documentosUnidad/" + doc.documento
        }
        def file = new File(path)
        if (file.exists()) {
            render "OK"
        } else {
            render "NO"
        }
    }

    /**
     * Acción que permite descargar un documento del proyecto
     */
    def downloadDoc() {
        def doc = Documento.get(params.id)
        def path
        if (doc.proyecto) {
            path = servletContext.getRealPath("/") + "documentosProyecto/" + doc.documento
        } else {
            path = servletContext.getRealPath("/") + "documentosUnidad/" + doc.documento
        }
        def nombre = doc.documento.split("/").last()
        def parts = nombre.split("\\.")
        def tipo = parts[1]
        switch (tipo) {
            case "jpeg":
            case "gif":
            case "jpg":
            case "bmp":
            case "png":
                tipo = "application/image"
                break;
            case "pdf":
                tipo = "application/pdf"
                break;
            case "doc":
            case "docx":
            case "odt":
                tipo = "application/msword"
                break;
            case "xls":
            case "xlsx":
                tipo = "application/vnd.ms-excel"
                break;
            default:
                tipo = "application/pdf"
                break;
        }
        try {
            def file = new File(path)
            def b = file.getBytes()
            response.setContentType(tipo)
            response.setHeader("Content-disposition", "attachment; filename=" + (nombre))
            response.setContentLength(b.length)
            response.getOutputStream().write(b)
        } catch (e) {
            response.sendError(404)
        }
    }

}
