package vesta.hitos

import jxl.Sheet
import jxl.Workbook
import jxl.WorkbookSettings
import org.springframework.dao.DataIntegrityViolationException
import vesta.avales.Aval
import vesta.avales.ProcesoAval
import vesta.seguridad.Shield


/**
 * Controlador que muestra las pantallas de manejo de Hito
 */
class HitoController extends Shield {

    static allowedMethods = [save_ajax: "POST", delete_ajax: "POST"]



    def avancesFinancieros = {
        println "params "+params
        def proceso = ProcesoAval.get(params.id)
        def aval = Aval.findByProceso(proceso)
        def avances=[]
        if(aval)
            avances  = AvanceFinanciero.findAllByAval(aval)
        [avances:avances,proceso:proceso,aval:aval]
    }

    /*Función para cargar un archivo excel de hitos financiero*/

    def cargarExcelHitos ={
        println(params)
            return [ idAval: params.id]
    }

    /*Función para cargar un archivo excel de hitos financiero*/
    /**
     * Acción
     */

    def subirExcelHitos () {

//        println("entro excel hitos" + params)
        def f = request.getFile('file')
        WorkbookSettings ws = new WorkbookSettings();
        ws.setEncoding("ISO-8859-1");

        def n = []
        def m = []
        byte b
        def ext
        def msg = ""

        if(f && !f.empty){
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

            if(ext == 'xls'){

                Workbook workbook = Workbook.getWorkbook(f.inputStream, ws)
                Sheet sheet = workbook.getSheet(0)

                println("entro!")
                for(int r =1; r < sheet.rows; r++){

                    def aval = sheet.getCell(0,r).contents
                    def contrato = sheet.getCell(1,r).contents
                    def  monto = sheet.getCell(2,r).contents
                    def anticipo = sheet.getCell(3,r).contents
                    def devengado = sheet.getCell(3,r).contents
                    println "------------------------------ "
                    println " aval "+aval
                    println " conrato "+contrato
                    println " monto "+monto
                    println " anticipo "+anticipo
                    println " devengado "+devengado
                    def av = Aval.findByNumero(aval)
                    if(av){
                        println "aval "+av.id+"  "+av.numero+"  "+av.estado.descripcion+"  "+av.estado.id+"  "+av.estado.codigo+"  "+av.fechaAnulacion
                        if(av.estado.codigo!="E04"){
                            def avance = new AvanceFinanciero()
                            avance.aval=av
                            avance.monto=monto.toDouble()
                            avance.contrato=contrato
                            avance.fecha = new Date()
                            avance.valor = devengado.toDouble()
                            if(!avance.save(flush: true)){
                                println "error save avance "+avance.errors
                            }else{
                                msg +="<br>Se registro un avance para el aval número ${aval}"
                            }
                        }else{
                            msg +="<br>El aval número ${aval} está anulado, no se registro su avance"
                        }
                    }else{
                        msg +="<br>No se econtro el aval número ${aval}"
                    }
                }
                flash.message = 'Archivo cargado existosamente.'
                flash.estado = "error"
                flash.icon = "alert"
                redirect(action: 'avancesFinancieros', id: params.id)
                return

            }else{
                flash.message = 'El archivo a cargar debe ser del tipo EXCEL con extensión XLS.'
                flash.estado = "error"
                flash.icon = "alert"
                redirect(action: 'avancesFinancieros', id: params.id)
                return
            }
        }else{
            flash.message = 'No se ha seleccionado ningun archivo para cargar'
            flash.estado = "error"
            flash.icon = "alert"
            redirect(action: 'avancesFinancieros', id: params.id)
            return
        }
    }


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
            def c = Hito.createCriteria()
            list = c.list(params) {
                or {
                    /* TODO: cambiar aqui segun sea necesario */
                    
                    ilike("descripcion", "%" + params.search + "%")  
                    ilike("tipo", "%" + params.search + "%")  
                }
            }
        } else {
            list = Hito.list(params)
        }
        if (!all && params.offset.toInteger() > 0 && list.size() == 0) {
            params.offset = params.offset.toInteger() - 1
            list = getList(params, all)
        }
        return list
    }

    /**
     * Acción que muestra la lista de elementos
     * @return hitoInstanceList: la lista de elementos filtrados, hitoInstanceCount: la cantidad total de elementos (sin máximo)
     */
    def list() {
        def hitoInstanceList = getList(params, false)
        def hitoInstanceCount = getList(params, true).size()
        return [hitoInstanceList: hitoInstanceList, hitoInstanceCount: hitoInstanceCount]
    }

    /**
     * Acción llamada con ajax que muestra la información de un elemento particular
     * @return hitoInstance el objeto a mostrar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def show_ajax() {
        if(params.id) {
            def hitoInstance = Hito.get(params.id)
            if(!hitoInstance) {
                render "ERROR*No se encontró Hito."
                return
            }
            return [hitoInstance: hitoInstance]
        } else {
            render "ERROR*No se encontró Hito."
        }
    } //show para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que muestra un formulario para crear o modificar un elemento
     * @return hitoInstance el objeto a modificar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def form_ajax() {
        def hitoInstance = new Hito()
        if(params.id) {
            hitoInstance = Hito.get(params.id)
            if(!hitoInstance) {
                render "ERROR*No se encontró Hito."
                return
            }
        }
        hitoInstance.properties = params
        return [hitoInstance: hitoInstance]
    } //form para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que guarda la información de un elemento
     * @render ERROR*[mensaje] cuando no se pudo grabar correctamente, SUCCESS*[mensaje] cuando se grabó correctamente
     */
    def save_ajax() {
        def hitoInstance = new Hito()
        if(params.id) {
            hitoInstance = Hito.get(params.id)
            if(!hitoInstance) {
                render "ERROR*No se encontró Hito."
                return
            }
        }
        hitoInstance.properties = params
        if(!hitoInstance.save(flush: true)) {
            render "ERROR*Ha ocurrido un error al guardar Hito: " + renderErrors(bean: hitoInstance)
            return
        }
        render "SUCCESS*${params.id ? 'Actualización' : 'Creación'} de Hito exitosa."
        return
    } //save para grabar desde ajax

    /**
     * Acción llamada con ajax que permite eliminar un elemento
     * @render ERROR*[mensaje] cuando no se pudo eliminar correctamente, SUCCESS*[mensaje] cuando se eliminó correctamente
     */
    def delete_ajax() {
        if(params.id) {
            def hitoInstance = Hito.get(params.id)
            if (!hitoInstance) {
                render "ERROR*No se encontró Hito."
                return
            }
            try {
                hitoInstance.delete(flush: true)
                render "SUCCESS*Eliminación de Hito exitosa."
                return
            } catch (DataIntegrityViolationException e) {
                render "ERROR*Ha ocurrido un error al eliminar Hito"
                return
            }
        } else {
            render "ERROR*No se encontró Hito."
            return
        }
    } //delete para eliminar via ajax
    
}
