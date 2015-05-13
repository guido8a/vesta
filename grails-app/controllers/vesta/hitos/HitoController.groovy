package vesta.hitos

import jxl.Sheet
import jxl.Workbook
import jxl.WorkbookSettings
import vesta.avales.Aval
import vesta.avales.ProcesoAval
import vesta.parametros.TipoElemento
import vesta.proyectos.MarcoLogico
//import vesta.proyectos.Proceso
import vesta.proyectos.Proyecto

class HitoController {

    def crearHito = {

        def hito = null
        if(params.id)
            hito = Hito.get(params.id)

        def proys = Proyecto.list([sort: "nombre"])
        def tipos = ["I":"Inicio","N":"Ejecución"]
        [hito:hito,proyectos:proys,tipos:tipos]

    }

    def verHito = {
        def hito = Hito.get(params.id)
        [hito:hito]
    }

    def saveHito = {
        println "params "+params
        def hito
        if(params.id)
            hito = Hito.get(params.id)
        else
            hito = new Hito()
        def fin = new Date().parse("dd-MM-yyyy",params.fin_input)
        def inicio = new Date().parse("dd-MM-yyyy",params.inicio_input)
        hito.descripcion = params.descripcion
        //hito.fechaPlanificada = fechaP
        hito.inicio = inicio
        hito.fechaPlanificada = fin
        if(!hito.fecha)
            hito.fecha=new Date()
        hito.tipo=params.tipo
        if(!hito.save(flush: true)){
            println "error save hito "+hito
        }
        def componente = MarcoLogico.get(params.comp)
        def comp = ComposicionHito.findByHito(hito)
        if(!comp)
            comp = new ComposicionHito()
        comp.hito=hito
        comp.marcoLogico=componente
        comp.save(flush: true)
        flash.message="Datos guardados"
        redirect(action: "lista")
    }

    def agregarComp = {
        println "agregar comp "+params
        def hito = Hito.get(params.id)
        switch (params.tipo){
            case "proy":
                def comp = new ComposicionHito()
                comp.hito=hito
                comp.proyecto = Proyecto.get(params.componente)
                comp.save(flush: true)
                break;
            case "ml":
                def comp = new ComposicionHito()
                comp.hito=hito
                comp.marcoLogico = MarcoLogico.get(params.componente)
                comp.save(flush: true)
                break;
            case "proc":
                def comp = new ComposicionHito()
                comp.hito=hito
                comp.proceso = ProcesoAval.get(params.componente)
                if(!comp.save(flush: true))
                    println "errores save "+comp.errors
                break;
            default:
                println "wtf"
                break
        }
        redirect(action: "composicion",id: hito.id)

    }

    def composicion = {
        def hito = Hito.get(params.id)
        return [comp:ComposicionHito.findAllByHito(hito,[sort: "id"]),ver:params.ver,hito:hito]
    }

    def componentesProyecto = {
        def proyecto = Proyecto.get(params.id)
        def comps = vesta.proyectos.MarcoLogico.findAllByProyectoAndTipoElemento(proyecto, TipoElemento.get(2))
        [comps:comps]
    }
    def cargarActividades = {
        def comp = MarcoLogico.get(params.id)
        def acts = MarcoLogico.findAllByMarcoLogico(comp)
        [acts:acts]
    }

    def borrarDetalle = {
        def ch = ComposicionHito.get(params.id)
        ch.delete()
        render "ok"
    }

    def lista = {
        def hitos = Hito.list([sort: "fecha"])
        [hitos:hitos]
    }

    def cargarExcelHitos ={
        if(params.msg)
            return [msg: params.msg]
    }
    /*Función para cargar un archivo excel de hitos financiero*/
    /**
     * Acción
     */

    def subirExcelHitos ={

        println("entro excel hitos")

//        def path = servletContext.getRealPath("/") + "excel/"
//        new File(path).mkdirs()
        def f = request.getFile('file')


        WorkbookSettings ws = new WorkbookSettings();
        ws.setEncoding("ISO-8859-1");


        Workbook workbook = Workbook.getWorkbook(f.inputStream, ws)
        Sheet sheet = workbook.getSheet(0)


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
                redirect(action: 'cargarExcelHitos',params: [msg:msg])
                return

            }else{
                flash.message = 'El archivo a cargar debe ser del tipo EXCEL con extensión XLS.'
                flash.estado = "error"
                flash.icon = "alert"
                redirect(action: 'cargarExcelHitos')
                return
            }


        }else{
            flash.message = 'No se ha seleccionado ningun archivo para cargar'
            flash.estado = "error"
            flash.icon = "alert"
            redirect(action: 'cargarExcelHitos')
            return
        }



    }

    def avancesFinancieros = {
        println "params "+params
        def proceso = ProcesoAval.get(params.id)
        def aval = Aval.findByProceso(proceso)
        def avances=[]
        if(aval)
            avances  = AvanceFinanciero.findAllByAval(aval)
        [avances:avances,proceso:proceso,aval:aval]
    }


    def cargarExcel_ajax() {

    }


}
