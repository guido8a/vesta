package vesta.proyectos

import jxl.DateCell
import jxl.Sheet
import jxl.Workbook
import jxl.WorkbookSettings
import org.springframework.dao.DataIntegrityViolationException
import vesta.parametros.TipoResponsable
import vesta.parametros.UnidadEjecutora
import vesta.parametros.poaPac.Anio
import vesta.parametros.poaPac.Fuente
import vesta.parametros.proyectos.GrupoProcesos
import vesta.poa.Asignacion
import vesta.poa.ProgramacionAsignacion
import vesta.seguridad.Persona
import vesta.seguridad.Shield

import java.text.SimpleDateFormat


/**
 * Controlador que muestra las pantallas de manejo de Proyecto
 */
class ProyectoController extends Shield {

    static allowedMethods = [save_ajax: "POST", delete_ajax: "POST"]
    def dbConnectionService

    /**
     * Acción que redirecciona a la lista (acción "list")
     */
    def index() {
        redirect(action:"list", params: params)
    }

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
        if(all) {
            params.remove("max")
            params.remove("offset")
        }
        def list
        if(params.search) {
            def c = Proyecto.createCriteria()
            list = c.list(params) {
                or {
                    /* TODO: cambiar aqui segun sea necesario */

                    ilike("aprobado", "%" + params.search + "%")
                    ilike("aprobadoPoa", "%" + params.search + "%")
                    ilike("codigo", "%" + params.search + "%")
                    ilike("codigoEsigef", "%" + params.search + "%")
                    ilike("codigoProyecto", "%" + params.search + "%")
                    ilike("descripcion", "%" + params.search + "%")
                    ilike("lineaBase", "%" + params.search + "%")
                    ilike("nombre", "%" + params.search + "%")
                    ilike("poblacionObjetivo", "%" + params.search + "%")
                    ilike("problema", "%" + params.search + "%")
                    ilike("producto", "%" + params.search + "%")
                    ilike("subPrograma", "%" + params.search + "%")
                }
            }
        } else {
            list = Proyecto.list(params)
        }
        if (!all && params.offset.toInteger() > 0 && list.size() == 0) {
            params.offset = params.offset.toInteger() - 1
            list = getList(params, all)
        }
        return list
    }

    /**
     * Acción que muestra la lista de elementos
     * @return proyectoInstanceList: la lista de elementos filtrados, proyectoInstanceCount: la cantidad total de elementos (sin máximo)
     */
    def list() {
        def proyectoInstanceList = getList(params, false)
        def proyectoInstanceCount = getList(params, true).size()
        return [proyectoInstanceList: proyectoInstanceList, proyectoInstanceCount: proyectoInstanceCount]
    }

    /**
     * Acción llamada con ajax que muestra la información de un elemento particular
     * @return proyectoInstance el objeto a mostrar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def show_ajax() {
        if(params.id) {
            def proyectoInstance = Proyecto.get(params.id)
            if(!proyectoInstance) {
                render "ERROR*No se encontró Proyecto."
                return
            }
            return [proyectoInstance: proyectoInstance]
        } else {
            render "ERROR*No se encontró Proyecto."
        }
    } //show para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que muestra un formaulario para crear o modificar un elemento
     * @return proyectoInstance el objeto a modificar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def form_ajax() {
        def proyectoInstance = new Proyecto()
        if(params.id) {
            proyectoInstance = Proyecto.get(params.id)
            if(!proyectoInstance) {
                render "ERROR*No se encontró Proyecto."
                return
            }
        }
        proyectoInstance.properties = params
        return [proyectoInstance: proyectoInstance]
    } //form para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que guarda la información de un elemento
     * @render ERROR*[mensaje] cuando no se pudo grabar correctamente, SUCCESS*[mensaje] cuando se grabó correctamente
     */
    def save_ajax() {
        def proyectoInstance = new Proyecto()
        if(params.id) {
            proyectoInstance = Proyecto.get(params.id)
            if(!proyectoInstance) {
                render "ERROR*No se encontró Proyecto."
                return
            }
        }
        proyectoInstance.properties = params
        if(!proyectoInstance.save(flush: true)) {
            render "ERROR*Ha ocurrido un error al guardar Proyecto: " + renderErrors(bean: proyectoInstance)
            return
        }
        render "SUCCESS*${params.id ? 'Actualización' : 'Creación'} de Proyecto exitosa."
        return
    } //save para grabar desde ajax

    /**
     * Acción llamada con ajax que permite eliminar un elemento
     * @render ERROR*[mensaje] cuando no se pudo eliminar correctamente, SUCCESS*[mensaje] cuando se eliminó correctamente
     */
    def delete_ajax() {
        if(params.id) {
            def proyectoInstance = Proyecto.get(params.id)
            if (!proyectoInstance) {
                render "ERROR*No se encontró Proyecto."
                return
            }
            try {
                proyectoInstance.delete(flush: true)
                render "SUCCESS*Eliminación de Proyecto exitosa."
                return
            } catch (DataIntegrityViolationException e) {
                render "ERROR*Ha ocurrido un error al eliminar Proyecto"
                return
            }
        } else {
            render "ERROR*No se encontró Proyecto."
            return
        }
    } //delete para eliminar via ajax

    /**
     * Acción llamada con ajax que valida que no se duplique la propiedad codigo
     * @render boolean que indica si se puede o no utilizar el valor recibido
     */
    def validar_unique_codigo_ajax() {
        params.codigo = params.codigo.toString().trim()
        if (params.id) {
            def obj = Proyecto.get(params.id)
            if (obj.codigo.toLowerCase() == params.codigo.toLowerCase()) {
                render true
                return
            } else {
                render Proyecto.countByCodigoIlike(params.codigo) == 0
                return
            }
        } else {
            render Proyecto.countByCodigoIlike(params.codigo) == 0
            return
        }
    }

    /**
     * Acción llamada con ajax que valida que no se duplique la propiedad codigoEsigef
     * @render boolean que indica si se puede o no utilizar el valor recibido
     */
    def validar_unique_codigoEsigef_ajax() {
        params.codigoEsigef = params.codigoEsigef.toString().trim()
        if (params.id) {
            def obj = Proyecto.get(params.id)
            if (obj.codigoEsigef.toLowerCase() == params.codigoEsigef.toLowerCase()) {
                render true
                return
            } else {
                render Proyecto.countByCodigoEsigefIlike(params.codigoEsigef) == 0
                return
            }
        } else {
            render Proyecto.countByCodigoEsigefIlike(params.codigoEsigef) == 0
            return
        }
    }

    /**
     * Acción llamada con ajax que valida que no se duplique la propiedad codigoProyecto
     * @render boolean que indica si se puede o no utilizar el valor recibido
     */
    def validar_unique_codigoProyecto_ajax() {
        params.codigoProyecto = params.codigoProyecto.toString().trim()
        if (params.id) {
            def obj = Proyecto.get(params.id)
            if (obj.codigoProyecto.toLowerCase() == params.codigoProyecto.toLowerCase()) {
                render true
                return
            } else {
                render Proyecto.countByCodigoProyectoIlike(params.codigoProyecto) == 0
                return
            }
        } else {
            render Proyecto.countByCodigoProyectoIlike(params.codigoProyecto) == 0
            return
        }
    }

    /*Funciones copiadas de yachay*/

    /**
     * Acción que muestra el formulario para crear/editar proyecto
     */
    def formProyecto (){
        def proyecto = new Proyecto()
        params.links = false
        params.type = "create"

        if (params.id) {
            params.type = "edit"
            proyecto = Proyecto.get(params.id)
            params.links = true
        }//if params.id

        def items = []
        items[0] = [:]
        items[0].link = ["controller": "proyecto", "action": "formProyecto",
                         "params"    : ["id": proyecto.id]]
        items[0].text = "Proyecto"
        items[0].evento = "proyecto"

        items[1] = [:]
        items[1].link = ["controller": "proyecto", "action": "objetivosBuenVivir",
                         "params"    : ["id": proyecto.id]]
        items[1].text = "Plan Nacional de Desarrollo"
        items[1].evento = "buenVivir"
        return [items: items, proyecto: proyecto, params: params]
    }

    /**
     * Acción que guarda los datos ingresados en el formulario de proyecto
     */
    def saveProyecto () {
//        println "save proyecto " + params
        if (params.mes) {
            params.mes = (params.mes).toInteger()
        }
        def proyecto = new Proyecto()
        if (params.id) {
            proyecto = Proyecto.get(params.id)
            println ">>> " + proyecto
        }
        proyecto.properties = params
        proyecto.unidadEjecutora = UnidadEjecutora.findByCodigo("343") //YACHAY EP
        if (proyecto.save(flush: true)) {
            redirect(action: "objetivosBuenVivir", id: proyecto.id)
        } else {
            flash.message = renderErrors(bean: proyecto)
            redirect(action: "formProyecto", id: proyecto.id)
        }

    }
    /**
     * Acción
     */
    def listaAprobarProyecto(){

        params.max = Math.min(params.max ? params.int('max') : 25, 100)
        def proyectos = []


        if (params.parametro && params.parametro.trim().size() > 0) {

            proyectos += Proyecto.findAllByNombreIlike("%${params.parametro}%")
            proyectos += Proyecto.findAllByCodigoProyectoIlike("%${params.parametro}%")
        } else {
            proyectos = Proyecto.list(params)
        }


        [proyectos: proyectos, total: proyectos.count(), parametro: params.parametro]
    }

    /**
     * Acción
     */
    def aprobarProyecto (){
        if (request.method == 'POST') {
            println "params " + params
            if (session.usuario.autorizacion == params.ssap.encodeAsMD5()) {
                def proy = Proyecto.get(params.proy)
                proy.aprobado = "a"
                kerberosService.saveObject(proy, Proyecto, session.perfil, session.usuario, "aprobarProyecto", "proyecto", session)
                render "ok"
            } else {
                render "no"
            }
        } else {
            redirect(controller: "shield", action: "ataques")
        }
    }

    /**
     * Acción
     */
    def estadoProyecto(){
        def proyectoInstance = Proyecto.get(params.id)

        /*
        TODO: ESTA UTILIZANDO EL PROCESO 1 SIEMPRE!!!!
        */
        def proceso = Proceso.get(1)
        def pasos = Paso.findAllByProceso(proceso, [sort: "orden"])

        def c2 = ResponsableProyecto.createCriteria()
        def resp = c2.list {
            eq("proyecto", proyectoInstance)
            tipo {
                eq("codigo", "I")
            }
            and {
                le("desde", new Date())
                ge("hasta", new Date())
            }
        }
        def responsable = "No se ha asignado"
        if (resp.size() > 0) {
            responsable = resp[0].responsable.persona.nombre + " " + resp[0].responsable.persona.apellido
        }

        def tabla = "<table class='ui-widget-content ui-corner-all' style='margin-top:15px;' cellpadding='10'>"
        tabla += "<thead class='ui-widget-header ui-corner-top'>"

        tabla += "<tr>"
        tabla += "<th colspan='3'>"
        tabla += "Estado del proyecto<br/>"
        tabla += "Responsable: " + responsable
        tabla += "</th>"
        tabla += "</tr>"

        tabla += "<tr>"

        tabla += "<th>"
        tabla += "Paso"
        tabla += "</th>"

        tabla += "<th colspan='2'>"
        tabla += "Estado (por tabla)"
        tabla += "</th>"

        tabla += "</tr>"

        tabla += "</thead>"
        tabla += "<tbody>"

        pasos.eachWithIndex { paso, j ->
            def tablas = (paso.tabla).split(",")
            def tablasEsp = (paso.tablaEsp).split(",")
            tabla += "<tr class='even'>"

            tabla += "<td class='" + (j % 2 == 0 ? "even" : "odd") + "' rowspan='" + (tablas.size()) + "'>"
            tabla += paso.orden + ".- " + paso.nombre
            tabla += "</td>"

            tablas.eachWithIndex { tbl, i ->
                if (i > 0) {
                    tabla += "<tr class='" + (i % 2 == 0 ? 'even' : 'odd') + "'>"
                }
                tabla += "<td>"
                tabla += tablasEsp[i]
                tabla += "</td>"

                def domain = grailsApplication.domainClasses.find { it.name == tbl }
                def clazz = domain.clazz
                def loader = clazz.getClassLoader()
                def nomb = clazz.getName()
                def sname = clazz.getSimpleName()
                def clase = loader.loadClass(nomb)
                def lista

                if (sname != "Proyecto") {
                    lista = clase.findAllByProyecto(proyectoInstance)
                } else {
                    lista = clase.findAllById(proyectoInstance.id)
                }

                def n = "5"

                tabla += "<td>"
                if (lista.size() > 0) {
                    tabla += "<img src='" + resource(dir: 'images', file: "ok" + n + ".png") + "' alt='OK' />"
                } else {
                    tabla += "<img src='" + resource(dir: 'images', file: "cancel" + n + ".png") + "' alt='NO' />"
                }
                tabla += "</td>"
                if (i == 0) {
                    tabla += "</tr>"
                }
            }
        }
        tabla += "</tbody>"
        tabla += "</table>"

        return [tabla: tabla]
    }

    def eliminarTodo(elems, clase) {
//        println "eliminando " + clase.name
        def cont = 0
        def b = true
        elems.each {
            if (it.delete(flush:true)) {
                b = false
            } else {
                cont++
            }
        }
//        println "eliminados " + cont + " de " + elems.size() + " " + clase
        return b
    }

    def eliminarTodoProyecto(proyecto, clase) {
        def elems = clase.findAllByProyecto(proyecto)
        return eliminarTodo(elems, clase)
    }

    /**
     * Acción
     */
    def deleteProyecto = {
        def proyecto = Proyecto.get(params.id)
        def b = true

        try {
            MarcoLogico.findAllByProyecto(proyecto).each { ml ->
//                println ml.id
                def metas = Meta.findAllByMarcoLogico(ml)
                def asignaciones = Asignacion.findAllByMarcoLogico(ml)
                def cronograma = Cronograma.findAllByMarcoLogico(ml)
//                println cronograma
                def indicadores = Indicador.findAllByMarcoLogico(ml)
                def supuestos = Supuesto.findAllByMarcoLogico(ml)
                asignaciones.each { asg ->
                    def programacionAsignacion = ProgramacionAsignacion.findAllByAsignacion(asg)
                    b = eliminarTodo(programacionAsignacion, ProgramacionAsignacion)
//                    def ejecuciones = Ejecucion.findAllByAsignacion(asg)
//                    b = eliminarTodo(ejecuciones, "Ejecucion")
                    def obras = Obra.findAllByAsignacion(asg)
                    b = eliminarTodo(obras, Obra)
                }
                metas.each { mt ->
                    def avances = Avance.findAllByMeta(mt)
                    b = eliminarTodo(avances, Avance)
                }
                indicadores.each { id ->
                    def medioVerificacion = MedioVerificacion.findAllByIndicador(id)
                    b = eliminarTodo(medioVerificacion, MedioVerificacion)
                }
                b = eliminarTodo(metas, Meta)
                b = eliminarTodo(asignaciones, Asignacion)
                b = eliminarTodo(cronograma, Cronograma)
                b = eliminarTodo(indicadores, Indicador)
                b = eliminarTodo(supuestos, Supuesto)
            }
            ModificacionProyecto.findAllByProyecto(proyecto).each { mp ->
                def modificables = Modificables.findAllByModificacion(mp)
                def modificacionAsignacion = ModificacionAsignacion.findAllByModificacionProyecto(mp)
                b = eliminarTodo(modificables, Modificables)
                b = eliminarTodo(modificacionAsignacion, ModificacionAsignacion)

                b = eliminarTodo([mp], ModificacionProyecto)
            }
            ResponsableProyecto.findAllByProyecto(proyecto).each { rp ->
                def informes = Informe.findAllByResponsableProyecto(rp)
                b = eliminarTodo(informes, Informe)

                b = eliminarTodo([rp], ResponsableProyecto)
            }

//            def ml2 = MarcoLogico.findAllByProyectoAndPadreModIsNotNull(proyecto)
//            b = eliminarTodo(ml2, MarcoLogico)
//            def ml1 = MarcoLogico.findAllByProyectoAndMarcoLogicoIsNotNull(proyecto)
//            b = eliminarTodo(ml1, MarcoLogico)
//            def ml3 = MarcoLogico.findAllByProyecto(proyecto)
//            b = eliminarTodo(ml3, MarcoLogico)

//            println "eliminando marco logico"
            def cn = dbConnectionService.getConnection()
            def sql = "update mrlg set mrlgpdre = null where proy__id =" + proyecto.id
            cn.execute(sql)
            sql = "update mrlg set mrlgpdmd = null where proy__id =" + proyecto.id
            cn.execute(sql)
            sql = "update mrlg set mrlghijo = null where proy__id =" + proyecto.id
            cn.execute(sql)
            sql = "delete from mrlg where proy__id =" + proyecto.id
            cn.execute(sql)
            cn.close()
//            println "eliminados marcos logicos (?)"

            b = eliminarTodoProyecto(proyecto, Adquisiciones)
//            b = eliminarTodoProyecto(proyecto, BeneficioSenplades)
            b = eliminarTodoProyecto(proyecto, Documento)
            b = eliminarTodoProyecto(proyecto, EntidadesProyecto)
//            b = eliminarTodoProyecto(proyecto, EstudiosTecnicos)
            b = eliminarTodoProyecto(proyecto, Financiamiento)
//            b = eliminarTodoProyecto(proyecto, GrupoDeAtencion)
            b = eliminarTodoProyecto(proyecto, IndicadoresSenplades)
//            b = eliminarTodoProyecto(proyecto, Intervencion)
//        b = eliminarTodoProyecto(proyecto, MarcoLogico)
            b = eliminarTodoProyecto(proyecto, MetaBuenVivirProyecto)
//        b = eliminarTodoProyecto(proyecto, ModificacionProyecto)
//            b = eliminarTodoProyecto(proyecto, ObjetivoEstrategico)
            b = eliminarTodoProyecto(proyecto, PoliticasAgendaProyecto)
            b = eliminarTodoProyecto(proyecto, PoliticasProyecto)
//        b = eliminarTodoProyecto(proyecto, ResponsableProyecto)

            b = eliminarTodo([proyecto], Proyecto)

            if (b) {
                flash.message = "Proyecto y datos asociados eliminados exitosamente"
                redirect(action: 'list')
            } else {
//                render "ERROR EN ALGUN LADO!!!"
                flash.message = "Ha ocurrido un error grave"
                redirect(action: 'show', id: proyecto.id)
            }
        } catch (Exception e) {
//            println "ERROR!!!! " + e.printStackTrace()
//            render("ERROR!!!!!" + e.printStackTrace())
            flash.message = "Ha ocurrido un error grave"
            redirect(action: 'show', id: proyecto.id)
        }
//        render "????"
        flash.message = "Ha ocurrido un error grave"
        redirect(action: 'show', id: proyecto.id)
    }

    /**
     * Acción
     */
    def validarAutorizacion = {
        if (session.usuario.id.toLong() == Persona.findByLogin("admin")?.id?.toLong()) {
            if (session.usuario.autorizacion == params.auth.encodeAsMD5()) {
//                println "ok"
                render "OK"
            } else {
//                println "no2"
                render "NO_2"
            }
        } else {
//            println "no1"
            render "NO_1"
        }
    }

    /**
     * Acción
     */
    def loadCombo = {
        def str = ""
        switch (params.tipo) {
            case "politica":

                if (params.padre != null && params.padre != "null") {
                    def objetivo = ObjetivoBuenVivir.get(params.padre)
                    def politicas = PoliticaBuenVivir.findAllByObjetivo(objetivo)

                    str += "<strong>Pol&iacute;tica:</strong>"
                    str += g.select(from: politicas, name: "politica", id: "politica", optionKey: "id", style: "width: 250px;", noSelection: ['null': '..-- Seleccione una política --..'])

                    str += '<script type="text/javascript">'
                    str += '$("#politica").selectmenu({'
                    str += 'width: 250'
                    str += '}).change(function() {'
                    str += 'var pol = $(this).val();'

                    str += '$.ajax({'
                    str += 'type: "POST",'
                    str += 'url: "' + g.createLink(action: ' loadCombo ') + '",'
                    str += 'data: {'
                    str += 'tipo: "meta",'
                    str += 'padre: pol'
                    str += '},'
                    str += 'success: function(msg) {'
                    str += '$("#mets").html(msg).show();'
                    str += '$("#btnAdd").show();'
                    str += '}'
                    str += '});'

                    str += '});'
                    str += '</script>'
                }
                break;
            case "meta":
                if (params.padre != null && params.padre != "null") {
                    def politica = PoliticaBuenVivir.get(params.padre)
                    def metas = MetaBuenVivir.findAllByPolitica(politica)

                    str += "<strong>Meta:</strong>"
                    str += g.select(from: metas, name: "meta", id: "meta", optionKey: "id", style: "width: 250px;", noSelection: ['null': '..-- Seleccione una meta --..'])

                    str += '<script type="text/javascript">'
                    str += '$("#meta").selectmenu({'
                    str += 'width: 250'
                    str += '});'
                    str += '</script>'
                }
                break;
        }

        render(str)
    }

    /**
     * Acción llamada con ajax que carga un combo box de estrategias de un objetivo estratégico en particular
     */
    def estrategiaPorObjetivo_ajax = {
//        println "params...: " + params
        def estrategias = []
        def estr = new Estrategia()
        if (params.proy__id) {
            if (Proyecto.get(params.proy__id).estrategia?.id)
                estr = Estrategia.get(Proyecto.get(params.proy__id).estrategia.id)
        }
        if (params.id != "null") {
//            println params
            def obj = ObjetivoEstrategicoProyecto.get(params.id.toLong())
//            println "OBJ: " + obj
            estrategias = Estrategia.findAllByObjetivoEstrategico(obj)
        }
        def select = g.select(from: estrategias, optionKey: "id", optionValue: "descripcion", name: "estrategia.id", class: "estrategia", value: estr?.id)
        def js = "<script type='text/javascript'>"
        js += "\$(\".estrategia\").selectmenu({width : 900});"
        js += "</script>"
        render select.toString() + js
    }


    /**
     * Acción
     */
    def verDoc = {
        def documentoInstance = Documento.get(params.id)
        if (!documentoInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'documento.label', default: 'Documento'), params.id])}"
            redirect(action: "list")
        } else {

            def title = g.message(code: "documento.show", default: "Show Documento")

            [documentoInstance: documentoInstance, title: title, proyecto: documentoInstance.proyecto]
        }
    }
/*Muestra los documentos asociados del proyecto*/
    /**
     * Acción
     */
    def documentos = {
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        if (!params.sort) {
            params.sort = "id"
        }
        if (!params.order) {
            params.order = "asc"
        }
        def offset = params.offset?.toInteger() ?: 0
        def proyecto = Proyecto.get(params.id)
        def busca = params.busca?.trim()
        def c = Documento.createCriteria()
        def documentoInstanceList = c.list {
            eq("proyecto", proyecto)
            if (params.busca && busca != "") {
                or {
                    ilike("descripcion", "%" + busca + "%")
                    ilike("clave", "%" + busca + "%")
                    ilike("resumen", "%" + busca + "%")
                    ilike("documento", "%" + busca + "%")
                }
            }
            maxResults(params.max)
            firstResult offset
            order(params.sort, params.order)
        }

        c = Documento.createCriteria()
        def lista = c.list {
            eq("proyecto", proyecto)
            if (params.busca && busca != "") {
                or {
                    ilike("descripcion", "%" + busca + "%")
                    ilike("clave", "%" + busca + "%")
                    ilike("resumen", "%" + busca + "%")
                    ilike("documento", "%" + busca + "%")
                }
            }
        }

        def documentoInstanceTotal = lista.size()

        return [proyecto: proyecto, documentoInstanceList: documentoInstanceList, documentoInstanceTotal: documentoInstanceTotal, params: params]
    }

    /*Función para subir un documento asociado con el proyecto*/
    /**
     * Acción
     */
    def uploadDoc = {

//        println "UPLOADING"
//        println params
//        println "\n\n\n"

        def proyecto = Proyecto.get(params.id)

        def entidad
        if (proyecto.unidadEjecutora) {
            entidad = proyecto.unidadEjecutora.nombre
        } else {
            entidad = "ND"
        }

        def path = servletContext.getRealPath("/") + "archivos/" + entidad
        new File(path).mkdirs()

        def f = request.getFile('fileUpload')
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

                    "" : "[\\!@#\\\$%\\^&*()-='\"\\/<>:;\\.,\\?]",

                    "_": "[\\s]"
            ]

            reps.each { k, v ->
                fileName = (fileName.trim()).replaceAll(v, k)
            }

            fileName = fileName + "_proyecto_" + proyecto.id + "." + ext

            def pathFile = path + File.separatorChar + fileName
            def src = new File(pathFile)

            if (src.exists()) {
                flash.message = 'Ya existe un archivo con ese nombre. Por favor cambielo o elimine el otro archivo primero.'
                flash.estado = "error"
                flash.icon = "alert"
            } else {
                def doc = new Documento()
                doc.proyecto = proyecto
                doc.grupoProcesos = GrupoProcesos.get(params.grupoProcesos.id)
                doc.descripcion = params.descripcion
                doc.clave = params.clave
                doc.resumen = params.resumen
                doc.documento = fileName
                doc = kerberosService.saveObject(doc, Documento, session.perfil, session.usuario, actionName, controllerName, session)
                if (doc.errors.getErrorCount() != 0) {
                    flash.message = 'Ha ocurrido un error al guardar su archivo.'
                    flash.estado = "error"
                    flash.icon = "alert"
                } else {
                    f.transferTo(new File(pathFile))
                    flash.message = 'Se ha agregado su archivo exitosamente.'
                    flash.estado = "highlight"
                    flash.icon = "info"
                }
            }
        } else {
            if (params.doc) {
                def doc = Documento.get(params.doc)
                doc.proyecto = proyecto
                doc.grupoProcesos = GrupoProcesos.get(params.grupoProcesos.id)
                doc.descripcion = params.descripcion
                doc.clave = params.clave
                doc.resumen = params.resumen
                doc = doc.save(flush: true)
                if (doc.errors.getErrorCount() != 0) {
                    flash.message = 'Ha ocurrido un error al guardar su archivo.'
                    flash.estado = "error"
                    flash.icon = "alert"
                } else {
                    flash.message = 'Se ha actualizado su archivo exitosamente.'
                    flash.estado = "highlight"
                    flash.icon = "info"
                }
            } else {
                flash.message = 'Seleccione un archivo.'
                flash.estado = "error"
                flash.icon = "alert"
            }
        }
        redirect(action: "documentos", params: [id: proyecto.id])
    }
    /**
     * Acción
     */
    def deleteDoc = {
//        println "DELETE DOC"
//        println params
        def proyecto = Proyecto.get(params.proyecto)

        def entidad
        if (proyecto.unidadEjecutora) {
            entidad = proyecto.unidadEjecutora.nombre
        } else {
            entidad = "ND"
        }
        def path = servletContext.getRealPath("/") + "archivos/" + entidad

        if (params.id.class == java.lang.String) {
            params.id = [params.id]
        }

        (params.id).each { id ->
            def doc = Documento.get(id)
            def archivo = doc.documento
            def pathFile = path + File.separatorChar + archivo
            def src = new File(pathFile)
            if (src.exists()) {
                src.delete()
            }

            doc.delete(flush: true)
        }

        redirect(action: "documentos", params: [id: proyecto.id])
    }
    /**
     * Acción
     */
    def downloadDoc = {
        def doc = Documento.get(params.id)
        def archivo = doc.documento
        def proyecto = Proyecto.get(params.proyecto)
        def entidad
        if (proyecto.unidadEjecutora) {
            entidad = proyecto.unidadEjecutora.nombre
        } else {
            entidad = "ND"
        }
        def path = servletContext.getRealPath("/") + "archivos/" + entidad

        def pathFile = path + File.separatorChar + archivo
        def src = new File(pathFile)
        if (src.exists()) {
            response.setContentType("application/octet-stream")
            response.setHeader("Content-disposition", "attachment;filename=${src.getName()}")

            response.outputStream << src.newInputStream()
        } else {
            redirect(action: "fileNotFound", params: ['archivo': archivo, 'id': proyecto.id])
        }
/*
def file = new File(params.fileDir)
response.setContentType("application/octet-stream")
response.setHeader("Content-disposition", "attachment;filename=${file.getName()}")

response.outputStream << file.newInputStream()
 */
    }

    /**
     * Acción
     */
    def fileNotFound = {
        return [archivo: params.archivo, id: params.id]
    }

    /**
     * Acción
     */
    def responsable = {
        def proyecto = Proyecto.get(params.id)

        def unidadProyecto = proyecto.unidadEjecutora
        def plantaCentral = UnidadEjecutora.findByCodigo("9999")

        def responsablesEjecucion = Usro.findAllByUnidad(unidadProyecto)
        def responsablesIngreso = Usro.findAllByUnidad(unidadProyecto)
        def responsablesSeguimiento = Usro.findAllByUnidad(plantaCentral)

        def c = ResponsableProyecto.createCriteria()
        def results = c.list {
            eq("proyecto", proyecto)
            tipo {
                eq("codigo", "E")
            }
            and {
                le("desde", new Date())
                ge("hasta", new Date())
            }
        }

        def c2 = ResponsableProyecto.createCriteria()
        def results2 = c2.list {
            eq("proyecto", proyecto)
            tipo {
                eq("codigo", "I")
            }
            and {
                le("desde", new Date())
                ge("hasta", new Date())
            }
        }

        def c3 = ResponsableProyecto.createCriteria()
        def results3 = c3.list {
            eq("proyecto", proyecto)
            tipo {
                eq("codigo", "S")
            }
            and {
                le("desde", new Date())
                ge("hasta", new Date())
            }
        }

        return [proyecto: proyecto, responsableEjecucion: results[0], responsableIngreso: results2[0], responsableSeguimiento: results3[0], responsablesEjecucion: responsablesEjecucion, responsablesIngreso: responsablesIngreso, responsablesSeguimiento: responsablesSeguimiento]
    } //responsable

    /**
     * Acción
     */
    def responsables = {
        def proyecto = Proyecto.get(params.id)

        def c = ResponsableProyecto.createCriteria()
        def results = c.list {
            eq("proyecto", proyecto)
            tipo {
                eq("codigo", "E")
            }
            and {
                le("desde", new Date())
                ge("hasta", new Date())
            }
        }

        def c2 = ResponsableProyecto.createCriteria()
        def results2 = c2.list {
            eq("proyecto", proyecto)
            tipo {
                eq("codigo", "I")
            }
            and {
                le("desde", new Date())
                ge("hasta", new Date())
            }
        }

        return [proyecto: proyecto, responsableEjecucion: results[0], responsableIngreso: results2[0]]
    } //responsable

    /**
     * Acción
     */
    def saveResponsable = {
//        println "SAVE RESPONSABLE"
//        params.each {
//            println it
//        }
        def err = false
        if (params.ingreso) {
            def proyecto = Proyecto.get(params.ingreso.proyecto.id)

            def desde = params.ingreso.desde
            def hasta = params.ingreso.hasta

            def c = ResponsableProyecto.createCriteria()
            def results = c.list {
                eq("proyecto", proyecto)
                tipo {
                    eq("codigo", "I")
                }
                and {
                    ge("desde", Date.parse("dd-MM-yyyy", desde))
                    le("hasta", Date.parse("dd-MM-yyyy", hasta))
                }
            }

            if (results.size() > 0) {
                println results
                render("!!")
            } else {
                if (params.ingreso.tipo == "update") {
                    def ant = ResponsableProyecto.get(params.ingreso.id)
                    ant.hasta = Date.parse("dd-MM-yyyy", desde)
                    ant.save(flush: true)
                    err = ant.errors.getErrorCount() != 0
                }
                params.ingreso.id = null
                params.ingreso.tipo = TipoResponsable.findByCodigo("I")
                def rp = new ResponsableProyecto(params.ingreso)
                rp.save(flush: true)
                if (rp.errors.getErrorCount() != 0 || err) {
                    render("NO")
                } else {
                    render("OK")
                }
            }
        }
        if (params.ejecucion) {
            def proyecto = Proyecto.get(params.ejecucion.proyecto.id)

            def desde = params.ejecucion.desde
            def hasta = params.ejecucion.hasta

            def c = ResponsableProyecto.createCriteria()
            def results = c.list {
                eq("proyecto", proyecto)
                tipo {
                    eq("codigo", "E")
                }
                and {
                    ge("desde", Date.parse("dd-MM-yyyy", desde))
                    le("hasta", Date.parse("dd-MM-yyyy", hasta))
                }
            }

            if (results.size() > 0) {
                println results
                render("!!")
            } else {
                if (params.ejecucion.tipo == "update") {
                    def ant = ResponsableProyecto.get(params.ejecucion.id)
                    ant.hasta = Date.parse("dd-MM-yyyy", desde)
                    ant.save(flush: true)
                    err = ant.errors.getErrorCount() != 0
                }
                params.ejecucion.id = null
                params.ejecucion.tipo = TipoResponsable.findByCodigo("E")
//                def obj = kerberosService.save(params.ejecucion, ResponsableProyecto, session.perfil, session.usuario)
                def obj = new ResponsableProyecto(params.ejecucion)
                obj.save(flush: true)
                if (obj.errors.getErrorCount() != 0 || err) {
                    render("NO")
                } else {
                    render("OK")
                }
            }
        }
        if (params.seguimiento) {
            def proyecto = Proyecto.get(params.seguimiento.proyecto.id)

            def desde = params.seguimiento.desde
            def hasta = params.seguimiento.hasta

            def c = ResponsableProyecto.createCriteria()
            def results = c.list {
                eq("proyecto", proyecto)
                tipo {
                    eq("codigo", "S")
                }
                and {
                    ge("desde", Date.parse("dd-MM-yyyy", desde))
                    le("hasta", Date.parse("dd-MM-yyyy", hasta))
                }
            }

            if (results.size() > 0) {
                println results
                render("!!")
            } else {
                if (params.seguimiento.tipo == "update") {
                    def ant = ResponsableProyecto.get(params.seguimiento.id)
                    ant.hasta = Date.parse("dd-MM-yyyy", desde)
                    ant.save(flush: true)
                    err = ant.errors.getErrorCount() != 0
                }
                params.seguimiento.id = null
                params.seguimiento.tipo = TipoResponsable.findByCodigo("S")
//                def obj = kerberosService.save(params.seguimiento, ResponsableProyecto, session.perfil, session.usuario)
                def obj = new ResponsableProyecto(params.seguimiento)
                obj.save(flush: true)
                if (obj.errors.getErrorCount() != 0 || err) {
                    render("NO")
                } else {
                    render("OK")
                }
            }
        }

    }

    /**
     * Acción
     */
    def historialResponsables = {
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        def proyecto = Proyecto.get(params.id)
        def c = ResponsableProyecto.createCriteria()
        def responsableProyectoInstanceList = []

        def ls = c.list {
            eq("proyecto", proyecto)
//            maxResults(params.max)
            and {
                order("desde", "asc")
                order("hasta", "asc")
                order("tipo", "asc")
            }
        }

        ls.each {
            def m = [:]
            m.obj = it
            if (it) {
                if (it?.desde <= new Date() && it?.hasta >= new Date()) {
                    m.clase = "activo"
                } else {
                    if (it?.desde < new Date()) {
                        m.clase = "pasado"
                    } else {
                        if (it?.hasta > new Date()) {
                            m.clase = "futuro"
                        }
                    }
                }
                m.clase += " " + (it?.tipo.descripcion).toLowerCase()
                responsableProyectoInstanceList.add(m)
            }
        }

        c = ResponsableProyecto.createCriteria()
        def lista = c.list {
            eq("proyecto", proyecto)
        }

        def responsableProyectoInstanceTotal = lista.size()

        return [proyecto: proyecto, responsableProyectoInstanceList: responsableProyectoInstanceList, responsableProyectoInstanceTotal: responsableProyectoInstanceTotal]
    }

    /**
     * Acción
     */
    def getDatos = {
        def proyecto = Proyecto.get(params.id)
        def headers, lista, tipo

        switch (params.tipo) {
            case "estudiosTecnicos":
                tipo = "Estudios t&eacute;cnicos"
                lista = EstudiosTecnicos.findAllByProyecto(proyecto)
                headers = [
                        [text: "Documento", name: "documento", align: "left"],
                        [text: "Fecha", name: "fecha", align: "center"],
                        [text: "Resumen", name: "resumen", align: "left"]
                ]
                break;
            case "objetivosEstrategicos":
                tipo = "Objetivos Estrat&eacute;gicos"
                lista = ObjetivoEstrategico.findAllByProyecto(proyecto)
                headers = [
                        [text: "Instituci&oacute;n", name: "institucion", align: "left"],
                        [text: "Objetivo", name: "objetivo", align: "left"],
                        [text: "Pol&iacute;tica", name: "politica", align: "left"],
                        [text: "Meta", name: "meta", align: "left"]
                ]
                break;
            case "gruposDeAtencion":
                tipo = "Grupos de Atención"
                lista = GrupoDeAtencion.findAllByProyecto(proyecto)
                headers = [
                        [text: "Tipo de grupo", name: "tipoGrupo", align: "left", property: "descripcion"],
                        [text: "Hombre", name: "hombre", align: "left"],
                        [text: "Mujer", name: "mujer", align: "left"]
                ]
                break;
            case "entidadesProyecto":
                tipo = "Entidades del Proyecto"
                lista = EntidadesProyecto.findAllByProyecto(proyecto)
                headers = [
                        [text: "Unidad Ejecutora", name: "unidad", align: "left", property: "nombre"],
                        [text: "Tipo Participación", name: "tipoPartisipacion", align: "left"],
                        [text: "Monto", name: "monto", align: "right"],
                        [text: "Rol", name: "rol", align: "left"],
                ]
                break;
            case "intervencion":
                tipo = "Intervenciones"
                lista = Intervencion.findAllByProyecto(proyecto)
                headers = [
                        [text: "Subsector", name: "subSector", align: "left"]
                ]
                break;
            case "adquisicion":
                tipo = "Adquisiciones"
                lista = Adquisiciones.findAllByProyecto(proyecto)
                headers = [
                        [text: "Tipo adquisición", name: "tipoAdquisicion", align: "left", property: "descripcion"],
                        [text: "Tipo procedencia", name: "tipoProcedencia", align: "left", property: "descripcion"],
                        [text: "Descripción", name: "descripcion", align: "left"],
                        [text: "Valor", name: "valor", align: "right"],
                        [text: "Porcentaje", name: "porcentaje", align: "right"]
                ]
                break;
        }

        return [lista: lista, headers: headers, tipo: tipo]
    }

    /**
     * Acción
     */
    def saveEstudiosTecnicos = {
        def obj = new EstudiosTecnicos(params)

        obj.save(flush: true)
        if (obj.errors.getErrorCount() != 0) {
            render("NO")
        } else {
            render("OK")
        }
    }
    /**
     * Acción
     */
    def deleteEstudiosTecnicos = {
        if (params.id.class != java.lang.String) {
            (params.id).each { id ->
                def et = EstudiosTecnicos.get(id)
                et.delete(flush: true)
//                kerberosService.delete(p, EstudiosTecnicos, session.perfil, session.usuario)
            }
        } else {
            params.controllerName = controllerName
            params.actionName = actionName
            def et = EstudiosTecnicos.get(params.id)
            et.delete(flush: true)
        }
        render("OK")
    }

    /**
     * Acción
     */
    def saveObjetivosEstrategicos = {
        def obj = new ObjetivoEstrategico(params)
        obj.save(flush: true)
        if (obj.errors.getErrorCount() != 0) {
            render("NO")
        } else {
            render("OK")
        }
    }
    /**
     * Acción
     */
    def deleteObjetivosEstrategicos = {
        if (params.id.class != java.lang.String) {
            (params.id).each { id ->
                def oe = ObjetivoEstrategico.get(id)
                oe.delete(flush: true)
//                kerberosService.delete(p, ObjetivoEstrategico, session.perfil, session.usuario)
            }
        } else {
            def oe = ObjetivoEstrategico.get(params.id)
            oe.delete(flush: true)
        }
        render("OK")
    }

    /**
     * Acción
     */
    def saveGruposDeAtencion = {
        def obj = new GrupoDeAtencion(params)

        obj.save(flush: true)
        if (obj.errors.getErrorCount() != 0) {
            render("NO")
        } else {
            render("OK")
        }
    }
    /**
     * Acción
     */
    def deleteGruposDeAtencion = {
        if (params.id.class != java.lang.String) {
            (params.id).each { id ->
                def ga = GrupoDeAtencion.get(id)
                ga.delete(flush: true)
            }
        } else {
            def ga = GrupoDeAtencion.get(params.id)
            ga.delete(flush: true)
        }
        render("OK")
    }

    /**
     * Acción
     */
    def saveEntidadesProyecto = {
        def obj = new EntidadesProyecto(params)
        obj.save(flush: true)
        if (obj.errors.getErrorCount() != 0) {
            render("NO")
        } else {
            render("OK")
        }
    }
    /**
     * Acción
     */
    def deleteEntidadesProyecto = {
        if (params.id.class != java.lang.String) {
            (params.id).each { id ->
               def ep = EntidadesProyecto.get(id)
                ep.delete(flush: true)
            }
        } else {
            def ep = EntidadesProyecto.get(params.id)
            ep.delete(flush: true)
        }
        render("OK")
    }

    /**
     * Acción
     */
    def saveIntervencion = {
        def obj = new Intervencion(params)
        obj.save(flush: true)
        if (obj.errors.getErrorCount() != 0) {
            render("NO")
        } else {
            render("OK")
        }
    }
    /**
     * Acción
     */
    def deleteIntervencion = {
        if (params.id.class != java.lang.String) {
            (params.id).each { id ->
            def inv = Intervencion.get(id)
                inv.delete(flush: true)
            }
        } else {
            def inv = Intervencion.get(params.id)
            inv.delete(flush: true)
        }
        render("OK")
    }

    /**
     * Acción
     */
    def saveAdquisicion = {
        def obj = new Adquisiciones(params)

        obj.save(flush: true)
        if (obj.errors.getErrorCount() != 0) {
            render("NO")
        } else {
            render("OK")
        }
    }
    /**
     * Acción
     */
    def deleteAdquisicion = {
        if (params.id.class != java.lang.String) {
            (params.id).each { id ->
                def aq = Adquisiciones.get(id)
                aq.delete(flush: true)
            }
        } else {
            def aq = Adquisiciones.get(params.id)
            aq.delete(flush: true)
        }
        render("OK")
    }

    /**
     * Acción
     */
    def verIndicadoresSenplades = {
        def proyecto = Proyecto.get(params.id)
        def indicadores = [:]
        indicadores.indicadoresSempladesInstance = IndicadoresSenplades.findByProyecto(proyecto)
        return [proyecto: proyecto, indicadores: indicadores]
    }

    /**
     * Acción
     */
    def editarIndicadoresSenplades = {
        def proyecto = Proyecto.get(params.id)
        def indicadores = [:]
        indicadores.indicadoresSempladesInstance = IndicadoresSenplades.findByProyecto(proyecto)
        return [proyecto: proyecto, indicadores: indicadores]
    }

    /**
     * Acción
     */
    def saveIndicadoresSenplades = {
        println params
        def proyecto = Proyecto.get(params.id)

        def indicador = IndicadoresSenplades.findByProyecto(proyecto)

        if (!indicador) {
            indicador = new IndicadoresSenplades()
            indicador.proyecto = proyecto
        }

        indicador.tasaAnalisisFinanciero = params.tan.toDouble()
        indicador.tasaInternaDeRetorno = params.tir.toDouble()
        indicador.costoBeneficio = params.cob.toDouble()
        indicador.valorActualNeto = params.van.toDouble()
        indicador.metodologia = params.met
        indicador.impactos = params.imp

        indicador.save(flush: true)

        if (indicador.errors.getErrorCount() != 0) {
            redirect(action: "editarIndicadoresSenplades", id: params.id)
        } else {
            redirect(action: "verIndicadoresSenplades", id: params.id)
        }
    }

    /**
     * Acción
     */
    def verEntidades = {
        def proyecto = Proyecto.get(params.id)
        def indicadores = [:]
        def headers = [:]
        indicadores.entidadesProyectoInstance = EntidadesProyecto.findAllByProyecto(proyecto)
        headers.entidadesProyecto = [
                [text: "Unidad Ejecutora", name: "unidad", align: "left", property: "nombre"],
                [text: "Tipo Participación", name: "tipoPartisipacion", align: "left"],
                [text: "Monto", name: "monto", align: "right"],
                [text: "Rol", name: "rol", align: "left"],
        ]
        return [proyecto: proyecto, indicadores: indicadores, headers: headers]
    }

    /**
     * Acción
     */
    def editarEntidades = {
        def proyecto = Proyecto.get(params.id)
        def entidadesProyectoInstance = EntidadesProyecto.findAllByProyecto(proyecto)

        return [entidadesProyectoInstance: entidadesProyectoInstance, proyecto: proyecto]
    }

    /*Muestra el financiamiento de un proyecto específico*/
    /**
     * Acción
     */
    def verFinanciamiento = {
        def proyecto = Proyecto.get(params.id)
        def financiamientos = Financiamiento.findAllByProyecto(proyecto, [sort: "anio"])
        [proyecto: proyecto, financiamientos: financiamientos]
    }
    /*Permite editar o borrar un financiamiento*/
    /**
     * Acción
     */
    def editarFinanciamiento = {
        def proyecto = Proyecto.get(params.id)
        def financiamientos = Financiamiento.findAllByProyecto(proyecto, [sort: "anio"])
        [proyecto: proyecto, financiamientos: financiamientos]
    }

    /*Función para guardar un nuevo financiamiento*/
    /**
     * Acción
     */
    def saveFinanciamiento = {


        def proyecto = Proyecto.get(params.id)

        def financiamientos = Financiamiento.findAllByProyecto(proyecto)

        def ok = true

        params.each {
            if (it.key.contains("mnt")) {
                def parts = (it.key).split("_")
                def id = parts[1]
                def anio = parts[2]
                def monto = it.value

                def financiamiento

                if ((!financiamientos || financiamientos.size() == 0) || (financiamientos.size() > 0 && !financiamientos.fuente.id.contains(id))) {
                    financiamiento = new Financiamiento()
                    financiamiento.proyecto = proyecto
                    financiamiento.fuente = Fuente.get(id)
                    financiamiento.monto = monto.toDouble()
                    financiamiento.anio = Anio.get(anio)

                    financiamiento.save(flush: true)

                    if (financiamiento.errors.getErrorCount() != 0) {
                        ok = false
                    }
                }
            } else {
                if (it.key == "deleted" && it.value) {
                    def parts = it.value.split(",")
                    if (parts.size() > 0) {
                        parts.each { pa ->
                            def fin = Financiamiento.get(pa)
                            fin.delete(flush: true)

                        }
                    }
                } //deleted
            }
        }

        if (ok) {
            flash.message = "Financiamientos guardados exitosamente"
            redirect(action: 'show', id: params.id)
        } else {
            flash.message = "Ha ocurrido un error, por favor comuníquese con el administrador del sistema<br/>[controller:proyecto, action:saveFinanciamiento]"
            redirect(action: 'editarFinanciamiento', id: params.id)
        }
    }

    /**
     * Acción
     */
    def verDatosSenplades = {
        def proyecto = Proyecto.get(params.id)

        def indicadores = [:]
        def headers = [:]

        indicadores.indicadoresSempladesInstance = IndicadoresSenplades.findByProyecto(proyecto)
        indicadores.estudioTecnicoInstance = EstudiosTecnicos.findAllByProyecto(proyecto)
        indicadores.objetivoEstrategicoInstance = ObjetivoEstrategico.findAllByProyecto(proyecto)
        indicadores.grupoDeAtencionInstance = GrupoDeAtencion.findAllByProyecto(proyecto)
        indicadores.beneficioSempladesInstance = BeneficioSenplades.findByProyecto(proyecto)
        indicadores.entidadesProyectoInstance = EntidadesProyecto.findAllByProyecto(proyecto)
        indicadores.intervenciones = Intervencion.findAllByProyecto(proyecto)
        indicadores.adquisiciones = Adquisiciones.findAllByProyecto(proyecto)

        headers.estudiosTecnicos = [
                [text: "Documento", name: "documento", align: "left"],
                [text: "Fecha", name: "fecha", align: "center"],
                [text: "Resumen", name: "resumen", align: "left"]
        ]

        headers.objetivosEstrategicos = [
                [text: "Instituci&oacute;n", name: "institucion", align: "left"],
                [text: "Objetivo", name: "objetivo", align: "left"],
                [text: "Pol&iacute;tica", name: "politica", align: "left"],
                [text: "Meta", name: "meta", align: "left"]
        ]

        headers.gruposDeAtencion = [
                [text: "Tipo de grupo", name: "tipoGrupo", align: "left", property: "descripcion"],
                [text: "Hombre", name: "hombre", align: "left"],
                [text: "Mujer", name: "mujer", align: "left"]
        ]

        headers.entidadesProyecto = [
                [text: "Entidad", name: "entidad", align: "left", property: "nombre"],
                [text: "Tipo Participación", name: "tipoPartisipacion", align: "left"],
                [text: "Monto", name: "monto", align: "right"],
                [text: "Rol", name: "rol", align: "left"],
        ]

        headers.intervenciones = [
                [text: "Subsector", name: "subSector", align: "left"]
        ]

        headers.adquisiciones = [
                [text: "Tipo adquisición", name: "tipoAdquisicion", align: "left", property: "descripcion"],
                [text: "Tipo procedencia", name: "tipoProcedencia", align: "left", property: "descripcion"],
                [text: "Descripción", name: "descripcion", align: "left"],
                [text: "Valor", name: "valor", align: "right"],
                [text: "Porcentaje", name: "porcentaje", align: "right"]
        ]
        return [proyecto: proyecto, indicadores: indicadores, headers: headers]
    }

    def cargarExcel = {

    }




    /*Función para cargar un archivo excel con componentes y actividades*/
    /**
     * Acción
     */
    def subirExcel = {


        def path = servletContext.getRealPath("/") + "excel/"
        new File(path).mkdirs()
        def f = request.getFile('file')


        WorkbookSettings ws = new WorkbookSettings();
        ws.setEncoding("ISO-8859-1");


        Workbook workbook = Workbook.getWorkbook(f.inputStream, ws)
        Sheet sheet = workbook.getSheet(0)

//        println("columnas: " + sheet.getColumns())
//        println("3 " + sheet.getColumn(3))

        //izq=columnas  der=filas
        def comp = []
        def act = []
        def fechasInicio = []
        def fechasFin = []
        def totales = []
        def ids = []
        def numero = []

        def n = []
        def m = []

        byte b




        def ext

        if (f && !f.empty) {
            def nombre = f.getOriginalFilename()
            def parts = nombre.split("\\.")
            nombre = ""
            parts.eachWithIndex { obj, i ->
                if (i < parts.size() - 1) {
                    nombre += obj
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

                    "" : "[\\!@#\\\$%\\^&*()-='\"\\/<>:;\\.,\\?]",

                    "_": "[\\s]"
            ]
            reps.each { k, v ->
                nombre = (nombre.trim()).replaceAll(v, k)
            }

            nombre = nombre + "." + ext

            def pathFile = path + File.separatorChar + nombre
            def src = new File(pathFile)

            def arreglo = []
            def varios = []

            def proyecto
            def componentes = []
            def actividades = []
            def tipoEl = TipoElemento.findByDescripcion("Componente")
            def tipoUno = TipoElemento.findByDescripcion("Actividad")
            def fechaI
            def fechaF
            def codigo
            def fechaIni
            def fechaFi
            def mto = 0

//            println("path " + pathFile )

            if (ext == 'xls') {
                if (src.exists()) {
                    flash.message = 'Ya existe un archivo con ese nombre. Por favor cambielo o elimine el otro archivo primero.'
                    flash.estado = "error"
                    flash.icon = "alert"
                    redirect(action: 'cargarExcel')
                    return
                } else {

                    for (int r = 2; r < sheet.rows; r++) {
                        DateCell dCell = null;
                        DateCell dCellF = null;
//                        ids += sheet.getCell(4, r).contents
//                        comp += sheet.getCell(2, r).contents
//                        act += sheet.getCell(10, r).contents
//                        fechasInicio += sheet.getCell(12, r).contents
//                        fechasFin += sheet.getCell(13, r).contents
//                        totales += sheet.getCell(16, r).contents
//                        numero += sheet.getCell(7, r).contents

                        if (sheet.getCell(19, r).type == CellType.DATE)
                            dCell = (DateCell) sheet.getCell(19, r);
                        TimeZone gmtZone = TimeZone.getTimeZone("GMT");
                        java.text.DateFormat destFormat = new SimpleDateFormat("dd-MM-yyyy")
                        destFormat.setTimeZone(gmtZone)


                        if (dCell) {
                            println("fechaInicio " + destFormat.format(dCell.getDate()))
                            fechaI = destFormat.format(dCell.getDate())
                            fechaIni = new Date().parse("dd-MM-yyyy", fechaI)
                        }

                        if (sheet.getCell(20, r).type == CellType.DATE)
                            dCellF = (DateCell) sheet.getCell(20, r);
                        TimeZone gmtZone1 = TimeZone.getTimeZone("GMT");
                        java.text.DateFormat destFormat1 = new SimpleDateFormat("dd-MM-yyyy")
                        destFormat1.setTimeZone(gmtZone1)

                        if (dCellF) {
                            println("fechaFin " + destFormat1.format(dCellF.getDate()))
                            fechaF = destFormat1.format(dCellF.getDate())
                            fechaFi = new Date().parse("dd-MM-yyyy", fechaF)
                        }

//ejemplo de correción de fecha al salir del excel

//                        Cell valueCell = this.workingSheet.getCell(i, this.rowIndex);

//                        if (valueCell.getType() == CellType.DATE) {
//                            DateCell dCell = (DateCell) valueCell;

//                            TimeZone gmtZone = TimeZone.getTimeZone("GMT");
//                            DateFormat destFormat = new SimpleDateFormat("yyyyMMdd");
//                            destFormat.setTimeZone(gmtZone);
//                            value = destFormat.format(dCell.getDate());
//                        }

                        def i = sheet.getCell(4, r).contents // columna E: identificador de proyecto
                        def c = sheet.getCell(2, r).contents // columna C: componentes
                        def a = sheet.getCell(10, r).contents // columna K: actividades
                        def t = sheet.getCell(24, r).contents // columna W: totales
                        def nmro = sheet.getCell(9, r).contents // columna J: numero de la actividad


                        if (nmro) {
                            arreglo = nmro.split('-')
                            println("numero: " + arreglo[1])
                            codigo = arreglo[1].toInteger()
                        } else {
                            codigo = 0
                        }

                        mto = t.replace(',', '.')



                        if (i != '') {
                            proyecto = Proyecto.findByCodigoEsigef(i)
                            println("i: " + i + " Proyecto: " + proyecto)
                            println("comp-->> " + c)
                            println("act-->> " + a)
                            println("monto-->> " + mto)

                            if (proyecto) {
                                componentes = MarcoLogico.findAllByProyectoAndTipoElemento(proyecto, tipoEl)
                                actividades = MarcoLogico.findAllByProyectoAndTipoElemento(proyecto, tipoUno)

                                println("componentes " + componentes)
                                println("actividades " + actividades)

                                if (componentes) {
                                    if (componentes.objeto.contains(c)) {
                                        println("Ya existe componente!")

                                        if (actividades.numero.contains(codigo)) {
                                            println("ya existe actividad!")
                                        } else {
                                            println("Nueva actividad!")
                                            println("padre " + MarcoLogico.findByObjeto(c))
                                            def nuevaAct = new MarcoLogico()
                                            nuevaAct.proyecto = proyecto
                                            nuevaAct.objeto = a
                                            nuevaAct.tipoElemento = tipoUno
                                            nuevaAct.numero = codigo
                                            nuevaAct.fechaInicio = fechaIni
                                            nuevaAct.fechaFin = fechaFi
                                            nuevaAct.monto = mto.toDouble()
                                            nuevaAct.marcoLogico = MarcoLogico.findByObjeto(c)
                                            if (nuevaAct.save(flush: true)) {



                                            } else {
                                                flash.message = 'Error al generar actividades' + errors
                                                flash.estado = "error"
                                                flash.icon = "alert"
                                                redirect(action: 'cargarExcel')
                                                return
                                            }
                                        }
                                    } else {
                                        println("Nuevo componente")
                                        def nuevoCom = new MarcoLogico()
                                        nuevoCom.proyecto = proyecto
                                        nuevoCom.objeto = c
                                        nuevoCom.tipoElemento = tipoEl
                                        if (nuevoCom.save(flush: true)) {

                                        } else {
                                            flash.message = 'Error al generar componentes!' + errors
                                            flash.estado = "error"
                                            flash.icon = "alert"
                                            redirect(action: 'cargarExcel')
                                            return
                                        }


                                        if (actividades.numero.contains(codigo)) {
                                            println("ya existe actividad!")
                                        } else {
                                            println("Nueva actividad!")
                                            println("Padre " + nuevoCom)
                                            def nuevaAct = new MarcoLogico()
                                            nuevaAct.proyecto = proyecto
                                            nuevaAct.objeto = a
                                            nuevaAct.tipoElemento = tipoUno
                                            nuevaAct.numero = codigo
                                            nuevaAct.fechaInicio = fechaIni
                                            nuevaAct.fechaFin = fechaFi
                                            nuevaAct.monto = mto.toDouble()
                                            nuevaAct.marcoLogico = nuevoCom
                                            if (nuevaAct.save(flush: true)) {

                                            } else {
                                                flash.message = 'Error al generar actividades' + errors
                                                flash.estado = "error"
                                                flash.icon = "alert"
                                                redirect(action: 'cargarExcel')
                                                return
                                            }
                                        }

                                    }
                                    println("-----------------------------")
                                } else {
                                    println("NINGUN componente! -  creando nuevo componente")
                                    def nuevoCom = new MarcoLogico()
                                    nuevoCom.proyecto = proyecto
                                    nuevoCom.objeto = c
                                    nuevoCom.tipoElemento = tipoEl
                                    if (nuevoCom.save(flush: true)) {


                                    } else {
                                        flash.message = 'Error al generar componentes!' + errors
                                        flash.estado = "error"
                                        flash.icon = "alert"
                                        redirect(action: 'cargarExcel')
                                        return
                                    }



                                    if (actividades) {

                                    } else {
                                        println("NINGUNA actividad! - creando nueva actividad")
                                        println("padre " + nuevoCom)
                                        def nuevaAct = new MarcoLogico()
                                        nuevaAct.proyecto = proyecto
                                        nuevaAct.objeto = a
                                        nuevaAct.tipoElemento = tipoUno
                                        nuevaAct.numero = codigo
                                        nuevaAct.fechaInicio = fechaIni
                                        nuevaAct.fechaFin = fechaFi
                                        nuevaAct.monto = mto.toDouble()
                                        nuevaAct.marcoLogico = nuevoCom
                                        println("padre " + nuevaAct.marcoLogico)
                                        if (nuevaAct.save(flush: true)) {
                                            println("-->")
//                                                        flash.message = 'Datos Cargados'
//                                                        flash.estado = "error"
//                                                        flash.icon = "alert"
//                                                        redirect(action: 'cargarExcel')
//                                                        return
                                        } else {
                                            println("error " + nuevaAct.errors)
                                            flash.message = 'Error al generar actividades' + errors
                                            flash.estado = "error"
                                            flash.icon = "alert"
                                            redirect(action: 'cargarExcel')
                                            return
                                        }

                                    }
//                                    println("-----------------------------")
                                }
                            }
                        } else {
//                            println("---------ERROR--------")
                        }
                    }

                    f.transferTo(new File(pathFile))
//                    println("Guardado!!")



                    flash.message = 'Archivo cargado existosamente.'
                    flash.estado = "error"
                    flash.icon = "alert"
//                    redirect(action: 'cargarExcel')
                    redirect(controller: 'proyecto', action: 'list')
                    return
                }
            } else {
                flash.message = 'El archivo a cargar debe ser del tipo EXCEL con extensión XLS.'
                flash.estado = "error"
                flash.icon = "alert"
                redirect(action: 'cargarExcel')
                return
            }


        } else {
            flash.message = 'No se ha seleccionado ningun archivo para cargar'
            flash.estado = "error"
            flash.icon = "alert"
            redirect(action: 'cargarExcel')
            return
        }

    }


}
