package vesta.reportes

import jxl.Workbook
import org.apache.poi.ss.usermodel.IndexedColors
import org.apache.poi.xssf.usermodel.XSSFCreationHelper
import org.apache.poi.xssf.usermodel.XSSFWorkbook
import vesta.avales.Aval
import vesta.avales.ProcesoAsignacion
import vesta.avales.ProcesoAval
import vesta.parametros.TipoElemento
import vesta.parametros.UnidadEjecutora
import vesta.parametros.poaPac.Anio
import vesta.parametros.poaPac.Fuente
import vesta.parametros.poaPac.Mes
import vesta.parametros.poaPac.Presupuesto
import vesta.poa.Asignacion
import vesta.proyectos.MarcoLogico
import vesta.proyectos.ModificacionAsignacion
import vesta.proyectos.Proyecto

import org.apache.poi.ss.usermodel.CellStyle
import org.apache.poi.ss.usermodel.Font
import org.apache.poi.ss.util.CellRangeAddress
import org.apache.poi.xssf.usermodel.XSSFCell as Cell
import org.apache.poi.xssf.usermodel.XSSFColor
import org.apache.poi.xssf.usermodel.XSSFRow as Row
import org.apache.poi.xssf.usermodel.XSSFSheet as Sheet
import org.apache.poi.xssf.usermodel.XSSFWorkbook as Workbook

class ReportesNuevosController {
    def dbConnectionService
    def firmasService

    def poaGrupoGastos_funcion(Fuente fuente) {
        def strAnio = new Date().format('yyyy')
        def anio = Anio.findByAnio(strAnio)

        def keyArrastre = "" + (strAnio.toInteger() - 1)
        def keyActual = strAnio
        def keyTotalActual = "T" + strAnio
        def keyTotal = "T"

        def data = []
        def anios = []
        def partidas = Presupuesto.findAllByNumeroLike('%0000', [sort: 'numero'])

        def totales = [:]
        totales[keyArrastre] = 0
        totales[keyActual] = 0
        totales[keyTotalActual] = 0
        totales[keyTotal] = 0

        partidas.each { partida ->
            def numero = partida.numero?.replaceAll("0", "")
            def m = [:]
            m.partida = partida
            m.valores = [:]
            m.valores[keyArrastre] = 0
            m.valores[keyActual] = 0
            m.valores[keyTotalActual] = 0
            m.valores[keyTotal] = 0

//            def presupuestos = getPresupuestosHijos(partida)
//            def asignaciones = Asignacion.findAllByPresupuestoInList(presupuestos)
            def asignaciones = Asignacion.withCriteria {
                presupuesto {
                    like("numero", numero + "%")
                }
                if (fuente) {
                    eq("fuente", fuente)
                }
            }
            asignaciones.each { asg ->
                def anioAsg = asg?.anio
                if (anioAsg?.id == anio?.id) {
                    m.valores[keyTotal] += asg.priorizado
                    totales[keyTotal] += asg.priorizado
                    m.valores[keyTotalActual] += asg.priorizado
                    totales[keyTotalActual] += asg.priorizado
                    if (asg.fuente.codigo == "998") {
                        m.valores[keyArrastre] += asg.priorizado
                        totales[keyArrastre] += asg.priorizado
                    } else {
                        m.valores[keyActual] += asg.priorizado
                        totales[keyActual] += asg.priorizado
                    }
                } else {
                    m.valores[keyTotal] += asg.planificado
                    totales[keyTotal] += asg.planificado
                    if (!m?.valores[anioAsg?.anio]) {
                        m?.valores[anioAsg?.anio] = 0
                        if (!anios?.contains(anioAsg?.anio)) {
                            anios += anioAsg?.anio
                            totales[anioAsg?.anio] = 0
                        }
                    }
                    m.valores[anioAsg?.anio] += asg?.planificado
                    totales[anioAsg?.anio] += asg?.planificado
                }
            }
            if (m.valores[keyTotal] > 0) {
                data += m
            }
        }
        anios = anios.sort()
        return [anio: anio, data: data, anios: anios, totales: totales]
    }

    //con planificado

    def poaGrupoGastosPlanificado_funcion() {
        def strAnio = new Date().format('yyyy')
        def anio = Anio.findByAnio(strAnio)

        def keyArrastre = "" + (strAnio.toInteger() - 1)
        def keyActual = strAnio
        def keyTotalActual = "T" + strAnio
        def keyTotal = "T"

        def data = []
        def anios = []
        def partidas = Presupuesto.findAllByNumeroLike('%0000', [sort: 'numero'])

        def totales = [:]
        totales[keyArrastre] = 0
        totales[keyActual] = 0
        totales[keyTotalActual] = 0
        totales[keyTotal] = 0

        partidas.each { partida ->
            def numero = partida.numero?.replaceAll("0", "")
            def m = [:]
            m.partida = partida
            m.valores = [:]
            m.valores[keyArrastre] = 0
            m.valores[keyActual] = 0
            m.valores[keyTotalActual] = 0
            m.valores[keyTotal] = 0

//            def presupuestos = getPresupuestosHijos(partida)
//            def asignaciones = Asignacion.findAllByPresupuestoInList(presupuestos)
            def asignaciones = Asignacion.withCriteria {
                presupuesto {
                    like("numero", numero + "%")
                }
            }
            asignaciones.each { asg ->
                def anioAsg = asg.anio
//                if (anioAsg.id == anio.id) {
//                    m.valores[keyTotal] += asg.priorizado
//                    totales[keyTotal] += asg.priorizado
//                    m.valores[keyTotalActual] += asg.priorizado
//                    totales[keyTotalActual] += asg.priorizado
//                    if (asg.fuente.codigo == "998") {
//                        m.valores[keyArrastre] += asg.priorizado
//                        totales[keyArrastre] += asg.priorizado
//                    } else {
//                        m.valores[keyActual] += asg.priorizado
//                        totales[keyActual] += asg.priorizado
//                    }
//                } else {
                m.valores[keyTotal] += asg.planificado
                totales[keyTotal] += asg.planificado
                if (!m.valores[anioAsg.anio]) {
                    m.valores[anioAsg.anio] = 0
                    if (!anios.contains(anioAsg.anio)) {
                        anios += anioAsg.anio
                        totales[anioAsg.anio] = 0
                    }
                }
                m.valores[anioAsg.anio] += asg.planificado
                totales[anioAsg.anio] += asg.planificado
//                }
            }
            if (m.valores[keyTotal] > 0) {
                data += m
            }
        }
        anios = anios.sort()
        return [anio: anio, data: data, anios: anios, totales: totales]
    }

    def poaProyecto_funcion() {
        def strAnio = new Date().format('yyyy')
        def anio = Anio.findByAnio(strAnio)

        def keyArrastre = "" + (strAnio.toInteger() - 1)
        def keyActual = strAnio
        def keyTotalActual = "T" + strAnio
        def keyTotal = "T"

        def data = []
        def anios = []

        def totales = [:]
        totales[keyArrastre] = 0
        totales[keyActual] = 0
        totales[keyTotalActual] = 0
        totales[keyTotal] = 0

        def proyectos = Proyecto.list()
        proyectos.each { proyecto ->
            def m = [:]
            m.proyecto = proyecto
            m.valores = [:]
            m.valores[keyArrastre] = 0
            m.valores[keyActual] = 0
            m.valores[keyTotalActual] = 0
            m.valores[keyTotal] = 0

            def actividades = MarcoLogico.withCriteria {
                eq("tipoElemento", TipoElemento.get(3))
                eq("proyecto", proyecto)
            }

            def asignaciones = Asignacion.findAllByMarcoLogicoInList(actividades)
            asignaciones.each { asg ->
                def anioAsg = asg.anio
                if (anioAsg.id == anio.id) {
                    m.valores[keyTotal] += asg.priorizado
                    totales[keyTotal] += asg.priorizado
                    m.valores[keyTotalActual] += asg.priorizado
                    totales[keyTotalActual] += asg.priorizado
                    if (asg.fuente.codigo == "998") {
                        m.valores[keyArrastre] += asg.priorizado
                        totales[keyArrastre] += asg.priorizado
                    } else {
                        m.valores[keyActual] += asg.priorizado
                        totales[keyActual] += asg.priorizado
                    }
                } else {
                    m.valores[keyTotal] += asg.planificado
                    totales[keyTotal] += asg.planificado
                    if (!m.valores[anioAsg.anio]) {
                        m.valores[anioAsg.anio] = 0
                        if (!anios.contains(anioAsg.anio)) {
                            anios += anioAsg.anio
                            totales[anioAsg.anio] = 0
                        }
                    }
                    m.valores[anioAsg.anio] += asg.planificado
                    totales[anioAsg.anio] += asg.planificado
                }
            }
            if (m.valores[keyTotal] > 0) {
                data += m
            }
        }
        anios = anios.sort()
        return [anio: anio, data: data, anios: anios, totales: totales]
    }

    def poaAreaGestion_funcion() {
        def strAnio = new Date().format('yyyy')
        def anio = Anio.findByAnio(strAnio)

        def keyArrastre = "" + (strAnio.toInteger() - 1)
        def keyActual = strAnio
        def keyTotalActual = "T" + strAnio
        def keyTotal = "T"

        def data = []
        def anios = []

        def totales = [:]
        totales[keyArrastre] = 0
        totales[keyActual] = 0
        totales[keyTotalActual] = 0
        totales[keyTotal] = 0

        def unidades = UnidadEjecutora.list()
        unidades.each { unidad ->
            def m = [:]
            m.unidad = unidad
            m.valores = [:]
            m.valores[keyArrastre] = 0
            m.valores[keyActual] = 0
            m.valores[keyTotalActual] = 0
            m.valores[keyTotal] = 0

            def actividades = MarcoLogico.withCriteria {
                eq("tipoElemento", TipoElemento.get(3))
                eq("responsable", unidad)
            }

            def asignaciones = Asignacion.findAllByMarcoLogicoInList(actividades)
            asignaciones.each { asg ->
                def anioAsg = asg.anio
                if (anioAsg.id == anio.id) {
                    m.valores[keyTotal] += asg.priorizado
                    totales[keyTotal] += asg.priorizado
                    m.valores[keyTotalActual] += asg.priorizado
                    totales[keyTotalActual] += asg.priorizado
                    if (asg.fuente.codigo == "998") {
                        m.valores[keyArrastre] += asg.priorizado
                        totales[keyArrastre] += asg.priorizado
                    } else {
                        m.valores[keyActual] += asg.priorizado
                        totales[keyActual] += asg.priorizado
                    }
                } else {
                    m.valores[keyTotal] += asg.planificado
                    totales[keyTotal] += asg.planificado
                    if (!m.valores[anioAsg.anio]) {
                        m.valores[anioAsg.anio] = 0
                        if (!anios.contains(anioAsg.anio)) {
                            anios += anioAsg.anio
                            totales[anioAsg.anio] = 0
                        }
                    }
                    m.valores[anioAsg.anio] += asg.planificado
                    totales[anioAsg.anio] += asg.planificado
                }
            }
            if (m.valores[keyTotal] > 0) {
                data += m
            }
        }
        data = data.sort { -it.valores[keyActual] }
        anios = anios.sort()
        return [anio: anio, data: data, anios: anios, totales: totales]
    }

    def poaFuente_funcion() {
        def strAnio = new Date().format('yyyy')
        def anio = Anio.findByAnio(strAnio)

        def keyArrastre = "" + (strAnio.toInteger() - 1)
        def keyActual = strAnio
        def keyTotalActual = "T" + strAnio
        def keyTotal = "T"

        def data = []
        def anios = []

        def totales = [:]
        totales[keyArrastre] = 0
        totales[keyActual] = 0
        totales[keyTotalActual] = 0
        totales[keyTotal] = 0

        def fuentes = Fuente.list()
        fuentes.each { fuente ->
            def m = [:]
            m.fuente = fuente
            m.valores = [:]
            m.valores[keyArrastre] = 0
            m.valores[keyActual] = 0
            m.valores[keyTotalActual] = 0
            m.valores[keyTotal] = 0

            def asignaciones = Asignacion.findAllByFuente(fuente)
            asignaciones.each { asg ->

                def anioAsg = asg?.anio
                if (anioAsg?.id == anio?.id) {
                    m.valores[keyTotal] += asg.priorizado
                    totales[keyTotal] += asg.priorizado
                    m.valores[keyTotalActual] += asg.priorizado
                    totales[keyTotalActual] += asg.priorizado
                    m.valores[keyActual] += asg.priorizado
                    totales[keyActual] += asg.priorizado
                } else {
                    m.valores[keyTotal] += asg.planificado
                    totales[keyTotal] += asg.planificado
                    if (!m.valores[anioAsg.anio]) {
                        m.valores[anioAsg.anio] = 0
                        if (!anios.contains(anioAsg.anio)) {
                            anios += anioAsg.anio
                            totales[anioAsg.anio] = 0
                        }
                    }
                    m.valores[anioAsg.anio] += asg.planificado
                    totales[anioAsg.anio] += asg.planificado
                }
            }
            if (m.valores[keyTotal] > 0) {
                data += m
            }
        }
        anios = anios.sort()
        return [anio: anio, data: data, anios: anios, totales: totales]
    }

    def poaAreaGestionGUI() {
        def data = poaAreaGestion_funcion()
        return [anio: data.anio, data: data.data, anios: data.anios, totales: data.totales]
    }

    def poaGrupoGastoGUI() {
        def fuente
        if(params.id){
            fuente = Fuente.get(params.id)
        }else{
            fuente = Fuente.get(9)
        }

        def data = poaGrupoGastos_funcion(fuente)
        return [anio: data.anio, data: data.data, anios: data.anios, totales: data.totales, fuente: fuente]
    }

    def poaProyectoGUI() {
        def data = poaProyecto_funcion()
        return [anio: data.anio, data: data.data, anios: data.anios, totales: data.totales]
    }

    def poaFuenteGUI() {
        def data = poaFuente_funcion()
        return [anio: data.anio, data: data.data, anios: data.anios, totales: data.totales]
    }

    def poaAreaGestionPdf() {
        def data = poaAreaGestion_funcion()
        return [anio: data.anio, data: data.data, anios: data.anios, totales: data.totales]
    }

    def poaGrupoGastoPdf() {
        println("---><<<>>>> " + params)
        def fuente = Fuente.get(params.fnt.toLong())
        def data = poaGrupoGastos_funcion(fuente)
        return [anio: data.anio, data: data.data, anios: data.anios, totales: data.totales, fuente: fuente]
    }

    def poaProyectoPdf() {
        def data = poaProyecto_funcion()
        return [anio: data.anio, data: data.data, anios: data.anios, totales: data.totales]
    }

    def poaFuentePdf() {
        def data = poaFuente_funcion()
        return [anio: data.anio, data: data.data, anios: data.anios, totales: data.totales]
    }




    // HACIA ABAJO REPORTES ANTIGUOS

    def poaAreaGestionWeb() {
        def anio = Anio.get(params.anio)
        def data = [:]
        def actividades = MarcoLogico.findAllByTipoElemento(TipoElemento.get(3))
        actividades.each { act ->
            def key = act.responsableId
            if (!data[key]) {
                data[key] = [
                        responsable: act.responsable,
                        total      : 0
                ]
            }
            def asignaciones = Asignacion.findAllByMarcoLogico(act)
            def tot = asignaciones.sum { it.priorizado }
            if (tot) {
                data[key].total += tot
            }
        }

        return [anio: anio, data: data]
    }

    def poaAreaGestionWebDetallado() {
        def anio = Anio.get(params.anio)
        def data = [:]
        def actividades = MarcoLogico.findAllByTipoElemento(TipoElemento.get(3))
        actividades.each { act ->
            def key = act.responsableId
            def key2 = "" + act.id
            if (!data[key]) {
                data[key] = [
                        responsable: act.responsable,
                        actividades: [:]
                ]
            }
            if (!data[key].actividades[key2]) {
                data[key].actividades[key2] = [act: act, total: 0]
            }

            def asignaciones = Asignacion.findAllByMarcoLogico(act)
            def tot = asignaciones.sum { it.priorizado }
            if (tot) {
                data[key].actividades[key2].total += tot
            }
        }
        return [anio: anio, data: data]
    }

    def poaAreaGestionPdfDetallado() {
    }

    def getPresupuestosHijos(Presupuesto padre) {
        def resultado = []
//        println "Entra Padre: " + padre + "   resultado: " + resultado
        def partidas = Presupuesto.findAllByPresupuesto(padre)
        partidas.each { p ->
            resultado += p
            resultado += getPresupuestosHijos(p)
        }
//        println "Sale Padre: " + padre + "   resultado: " + resultado
        return resultado
    }

    def poaGrupoGastoWeb_old() {
        def anio = Anio.get(params.anio)
        def data = []
        def partidas = Presupuesto.findAllByNumeroLike('%0000', [sort: 'numero'])
        partidas.each { partida ->
            def presupuestos = getPresupuestosHijos(partida)
            def asignaciones = Asignacion.findAllByPresupuestoInList(presupuestos)
            def total = 0
            if (asignaciones.size() > 0) {
                total = asignaciones.sum { it.priorizado }
            }
            if (total > 0) {
                data += [partida: partida, total: total]
            }
        }
        return [anio: anio, data: data]
    }

    def poaGrupoGastoWebDetallado() {
        def anio = Anio.get(params.anio)
        def data = [:]
        def partidas = Presupuesto.findAllByNumeroLike('%0000', [sort: 'numero'])
        partidas.each { partida ->
            def key = "" + partida.id
            data[key] = [:]
            data[key].padre = partida
            data[key].hijos = []
            def presupuestos = getPresupuestosHijos(partida)
            presupuestos.each { p ->
                def asignaciones = Asignacion.findAllByPresupuesto(p)
                def total = 0
                if (asignaciones.size() > 0) {
                    total = asignaciones.sum { it.priorizado }
                }
                if (total > 0) {
                    data[key].hijos += [partida: p, total: total]
                }
            }
        }
        return [anio: anio, data: data]
    }

    def poaGrupoGastoPdfDetallado() {
    }

    def poaProyectoGUI_old() {
    }

    def poaProyectoWeb() {
        def anio = Anio.get(params.anio.toLong())
        def proys = Proyecto.findAllByIdInList(params.id.split(",")*.toLong())
        return [proys: proys, anio: anio, params: params]
    }

    def poaProyectoWebProg() {
        def anio = Anio.get(params.anio.toLong())
        def proys = Proyecto.findAllByIdInList(params.id.split(",")*.toLong())
        def meses = Mes.list([sort: 'numero'])
        def totales = []
        for (int i = 0; i < 12; i++) {
            totales[i] = 0
        }
        return [proys: proys, meses: meses, anio: anio, params: params, totales: totales]
    }

    def poaProyectoPdf_old() {
        def anio = Anio.get(params.anio.toLong())
        def proys = Proyecto.findAllByIdInList(params.id.split(",")*.toLong())
        return [proys: proys, anio: anio, params: params]
    }

    def poaProyectoPdfProg() {
        def anio = Anio.get(params.anio.toLong())
        def proys = Proyecto.findAllByIdInList(params.id.split(",")*.toLong())
        def meses = Mes.list([sort: 'numero'])
        return [proys: proys, meses: meses, anio: anio, params: params]
    }

    def reporteProyectosGUI() {
    }

    def reporteProyectosWeb() {
        def fuentes = Fuente.findAllByIdInList(params.fuentes.split(",")*.toLong())
//        def anios = Anio.findAllByIdInList(params.anios.split(",")*.toLong(), [sort: "anio"])
        def anios = []
        return [fuentes: fuentes, anios: anios]
    }

    def reporteProyectosPdf() {
        println "\n\n\nAQUI ${params}\n\n\n"
        def fuentes = Fuente.findAllByIdInList(params.fuentes.split(",")*.toLong())
//        def anios = Anio.findAllByIdInList(params.anios.split(",")*.toLong(), [sort: "anio"])
        def anios = []
        def proyectos = Proyecto.list([sort: 'codigo'])
        return [fuentes: fuentes, anios: anios, proyectos: proyectos]
    }

    def reportesVarios() {

    }

    def form_avales_ajax() {

    }

    def fuente_y_fechas_ajax() {

    }


    //old
//    def reporteAvalesExcel() {
//
//        def cn = dbConnectionService.getConnection()
//
//
//        //nuevo query
//
//        def tx =  "select slavnmro, avalnmro, avalfcap, prconmbr, unejnmbr, unej.unej__id, sum(poasmnto), fnte__id " +
//        "from prco, slav, unej, aval, poas, asgn " +
//        "where slav.prco__id = prco.prco__id and unej.unej__Id = slav.unej__id and " +
//        "aval.prco__id = prco.prco__id and poas.prco__id = prco.prco__id and " +
//        "asgn.asgn__id = poas.asgn__id and slav.edav__id <> 90 " +
//        "group by slavnmro, avalnmro, avalfcap, prconmbr, unejnmbr, unej.unej__id, avalnmro, avalfcap, fnte__id " +
//        "order by cast(avalnmro as integer), prconmbr, fnte__id;"
//
//
//        def iniRow = 0
//        def iniCol = 1
//
//        def curRow = iniRow
//        def curCol = iniCol
//
//        try {
//
//            Workbook wb = new Workbook()
//            Sheet sheet = wb.createSheet("Reporte de Avales")
//
//            def estilos = ReportesNuevosExcelController.getEstilos(wb)
//            CellStyle styleHeader = estilos.styleHeader
//            CellStyle styleTabla = estilos.styleTabla
//            CellStyle styleFooter = estilos.styleFooter
//            CellStyle styleFooterCenter = estilos.styleFooterCenter
//            CellStyle styleNumber = estilos.styleNumber
//            CellStyle styleDate = estilos.styleDate
//
//
//            def titulo = "REPORTE DE AVALES"
//            def subtitulo = ""
//            curRow = ReportesNuevosExcelController.setTitulos(sheet, estilos, iniRow, iniCol, titulo, subtitulo)
//
//            Row rowHeader = sheet.createRow((short) curRow)
//            curRow++
//            Cell cellHeader = rowHeader.createCell((short) curCol)
//            cellHeader.setCellValue("N° SOLICITUD")
//            cellHeader.setCellStyle(styleHeader)
//            sheet.setColumnWidth(curCol, 3000)
//            curCol++
//
//            println("pp")
//
//
//            cellHeader = rowHeader.createCell((short) curCol)
//            cellHeader.setCellValue("N° AVAL")
//            cellHeader.setCellStyle(styleHeader)
//            sheet.setColumnWidth(curCol, 2000)
//            curCol++
//
//            cellHeader = rowHeader.createCell((short) curCol)
//            cellHeader.setCellValue("FUENTE")
//            cellHeader.setCellStyle(styleHeader)
//            sheet.setColumnWidth(curCol, 2000)
//            curCol++
//
//            cellHeader = rowHeader.createCell((short) curCol)
//            cellHeader.setCellValue("FECHA EMISIÓN AVAL")
//            cellHeader.setCellStyle(styleHeader)
//            sheet.setColumnWidth(curCol, 4500)
//            curCol++
//
//            cellHeader = rowHeader.createCell((short) curCol)
//            cellHeader.setCellValue("NOMBRE DEL PROCESO")
//            cellHeader.setCellStyle(styleHeader)
//            sheet.setColumnWidth(curCol, 20000)
//            curCol++
//
//            cellHeader = rowHeader.createCell((short) curCol)
//            cellHeader.setCellValue("VALOR")
//            cellHeader.setCellStyle(styleHeader)
//            sheet.setColumnWidth(curCol, 4000)
//            curCol++
//
//            cellHeader = rowHeader.createCell((short) curCol)
//            cellHeader.setCellValue("RESPONSABLE")
//            cellHeader.setCellStyle(styleHeader)
//            sheet.setColumnWidth(curCol, 10000)
//            curCol++
//
//            def totalCols = curCol
//            ReportesNuevosExcelController.joinTitulos(sheet, iniRow, iniCol, totalCols, false)
//            def totalPriorizado = 0
//
//            cn.eachRow(tx.toString()) { d ->
//
//                curCol = iniCol
//                Row tableRow = sheet.createRow((short) curRow)
//                Cell cellTabla = tableRow.createCell((short) curCol)
//
//                cellTabla = tableRow.createCell((short) curCol)
//                cellTabla.setCellValue(d.slavnmro)
//                cellTabla.setCellStyle(styleTabla)
//                curCol++
//                cellTabla = tableRow.createCell((short) curCol)
//                cellTabla.setCellValue(d.avalnmro)
//                cellTabla.setCellStyle(styleTabla)
//                curCol++
//                cellTabla = tableRow.createCell((short) curCol)
//                cellTabla.setCellValue(Fuente.get(d.fnte__id).codigo)
//                cellTabla.setCellStyle(styleTabla)
//                curCol++
//                cellTabla = tableRow.createCell((short) curCol)
//                cellTabla.setCellValue(d.avalfcap)
//                cellTabla.setCellStyle(styleDate)
//                curCol++
//                cellTabla = tableRow.createCell((short) curCol)
//                cellTabla.setCellValue(d.prconmbr)
//                cellTabla.setCellStyle(styleTabla)
//                curCol++
//                cellTabla = tableRow.createCell((short) curCol)
//                cellTabla.setCellValue(d.sum)
//                cellTabla.setCellStyle(styleNumber)
//                totalPriorizado += d.sum
//                curCol++
//                cellTabla = tableRow.createCell((short) curCol)
////                cellTabla.setCellValue(d.unejnmbr)
//                cellTabla.setCellValue(firmasService.requirentes(UnidadEjecutora.get(d.unej__id)).toString())
//                cellTabla.setCellStyle(styleTabla)
//                curCol++
//                curRow++
//
//            }
//            cn.close()
//
//            curCol = iniCol
//            Row totalRow = sheet.createRow((short) curRow)
//            Cell cellFooter = totalRow.createCell((short) curCol)
//            curCol++
//            cellFooter.setCellValue("TOTAL")
//            cellFooter.setCellStyle(styleFooterCenter)
//
//            cellFooter = totalRow.createCell((short) curCol)
//            curCol++
//            cellFooter.setCellValue("")
//            cellFooter.setCellStyle(styleFooterCenter)
//
//            cellFooter = totalRow.createCell((short) curCol)
//            curCol++
//            cellFooter.setCellValue("")
//            cellFooter.setCellStyle(styleFooterCenter)
//
//            cellFooter = totalRow.createCell((short) curCol)
//            curCol++
//            cellFooter.setCellValue("")
//            cellFooter.setCellStyle(styleFooterCenter)
//
//            cellFooter = totalRow.createCell((short) curCol)
//            curCol++
//            cellFooter.setCellValue(totalPriorizado)
//            cellFooter.setCellStyle(styleFooter)
//
//            cellFooter = totalRow.createCell((short) curCol)
//            curCol++
//            cellFooter.setCellValue("")
//            cellFooter.setCellStyle(styleFooter)
//
//            sheet.addMergedRegion(new CellRangeAddress(
//                    curRow, //first row (0-based)
//                    curRow, //last row  (0-based)
//                    iniCol, //first column (0-based)
//                    iniCol + 3 //last column  (0-based)
//            ))
//
//            def output = response.getOutputStream()
//            def header = "attachment; filename=" + "reporte_avales.xlsx"
//            response.setContentType("application/application/vnd.openxmlformats-officedocument.spreadsheetml.sheet")
//            response.setHeader("Content-Disposition", header)
//            wb.write(output)
//            output.flush()
//
//        } catch (Exception ex) {
//            ex.printStackTrace();
//        }
//
//    }



    def reporteAvalesExcel() {

//        println("params " + params)

        def fechaInicio = new Date().parse("dd-MM-yyyy",params?.ini)
        def fechaFin = new Date().parse("dd-MM-yyyy",params?.fin)
        def actual = new Date().format("yyyy")
        def siguiente = new Date().format("yyyy" + 1)

        def cn = dbConnectionService.getConnection()

        def tx =  "select slavnmro, avalnmro, fntedscr, avalfcha, prconmbr, avalmnto, vloractl, vlorsgnt, edavdscr, " +
                "lbrdactl, lbrdsgnt, unejnmbr from rp_avales('${fechaInicio.format("yyyy-MM-dd")}', " +
                "'${fechaFin.format("yyyy-MM-dd")}', ${params.fuente}) where avalmnto > 0;"

//        println("txt " + tx)

        def iniRow = 0
        def iniCol = 1

        def curRow = iniRow
        def curCol = iniCol

        try {

            Workbook wb = new Workbook()
            Sheet sheet = wb.createSheet("Reporte de Avales")

            def estilos = ReportesNuevosExcelController.getEstilos(wb)
            CellStyle styleHeader = estilos.styleHeader
            CellStyle styleTabla = estilos.styleTabla
            CellStyle styleFooter = estilos.styleFooter
            CellStyle styleFooterCenter = estilos.styleFooterCenter
            CellStyle styleNumber = estilos.styleNumber
            CellStyle styleDate = estilos.styleDate


            def titulo = "REPORTE DE AVALES"
            def subtitulo = ""
            curRow = ReportesNuevosExcelController.setTitulos(sheet, estilos, iniRow, iniCol, titulo, subtitulo)

            Row rowHeader = sheet.createRow((short) curRow)
            curRow++
            Cell cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("N° SOLICITUD")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 3000)
            curCol++

            cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("N° AVAL")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 2000)
            curCol++

            cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("FUENTE")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 2000)
            curCol++

            cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("FECHA EMISIÓN AVAL")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 4500)
            curCol++

            cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("NOMBRE DEL PROCESO")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 20000)
            curCol++

            cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("VALOR")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 4000)
            curCol++

            cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("${actual}")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 4000)
            curCol++

            cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("${actual.toInteger() + 1}")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 4000)
            curCol++

            cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("ESTADO")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 4000)
            curCol++

            cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("LIBERADO ${actual}")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 4000)
            curCol++

            cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("LIBERADO ${actual.toInteger() + 1}")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 4000)
            curCol++

            cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("RESPONSABLE")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 10000)
            curCol++

            def totalCols = curCol
            ReportesNuevosExcelController.joinTitulos(sheet, iniRow, iniCol, totalCols, false)

            cn.eachRow(tx.toString()) { d ->

                curCol = iniCol
                Row tableRow = sheet.createRow((short) curRow)
                Cell cellTabla = tableRow.createCell((short) curCol)

                cellTabla = tableRow.createCell((short) curCol)
                cellTabla.setCellValue(d.slavnmro)
                cellTabla.setCellStyle(styleTabla)
                curCol++
                cellTabla = tableRow.createCell((short) curCol)
                cellTabla.setCellValue(d.avalnmro)
                cellTabla.setCellStyle(styleTabla)
                curCol++
                cellTabla = tableRow.createCell((short) curCol)
                cellTabla.setCellValue(d.fntedscr)
                cellTabla.setCellStyle(styleTabla)
                curCol++
                cellTabla = tableRow.createCell((short) curCol)
                cellTabla.setCellValue(d.avalfcha.format("dd-MM-yyyy"))
                cellTabla.setCellStyle(styleDate)
                curCol++
                cellTabla = tableRow.createCell((short) curCol)
                cellTabla.setCellValue(d.prconmbr)
                cellTabla.setCellStyle(styleTabla)
                curCol++
                cellTabla = tableRow.createCell((short) curCol)
                cellTabla.setCellValue(d.avalmnto)
                cellTabla.setCellStyle(styleNumber)
                curCol++
                cellTabla = tableRow.createCell((short) curCol)
                cellTabla.setCellValue(d.vloractl)
                cellTabla.setCellStyle(styleNumber)
                curCol++
                cellTabla = tableRow.createCell((short) curCol)
                cellTabla.setCellValue(d.vlorsgnt)
                cellTabla.setCellStyle(styleNumber)
                curCol++
                cellTabla = tableRow.createCell((short) curCol)
                cellTabla.setCellValue(d.edavdscr)
                cellTabla.setCellStyle(styleTabla)
                curCol++
                cellTabla = tableRow.createCell((short) curCol)
                cellTabla.setCellValue(d.lbrdactl)
                cellTabla.setCellStyle(styleNumber)
                curCol++
                cellTabla = tableRow.createCell((short) curCol)
                cellTabla.setCellValue(d.lbrdsgnt)
                cellTabla.setCellStyle(styleNumber)
                curCol++
                cellTabla = tableRow.createCell((short) curCol)
                cellTabla.setCellValue(d.unejnmbr)
                cellTabla.setCellStyle(styleTabla)
                curCol++
                curRow++

            }
            cn.close()


            def output = response.getOutputStream()
            def header = "attachment; filename=" + "reporte_avales.xlsx"
            response.setContentType("application/application/vnd.openxmlformats-officedocument.spreadsheetml.sheet")
            response.setHeader("Content-Disposition", header)
            wb.write(output)
            output.flush()

        } catch (Exception ex) {
            ex.printStackTrace();
        }

    }







    def reporteReformasExcel() {

//        def fuente = Fuente.get(params.fnt.toLong())
//
//        def modificacion = ModificacionAsignacion.withCriteria {
//            desde {
//                eq("fuente", fuente)
//            }
//        }



        println "reporteReformasExcel params: $params"
        def fuente = Fuente.get(params.fnt.toLong())

        def fechaInicio = new Date().parse("dd-MM-yyyy",params?.ini)
        def fechaFin = new Date().parse("dd-MM-yyyy",params?.fin)


        def cn = dbConnectionService.getConnection()


        def sql = "select nmro, prsp, anio, actv, vlin, incr, decr, rfrm, ajst, fcha, mdasorgn, prcl " +
                "from reforma('${fechaInicio.format("yyyy-MM-dd")}', '${fechaFin.format("yyyy-MM-dd")}', ${fuente.id}) " +
                "order by nmro, anio, prsp, mdas__id"

        println "sql: $sql"

        def totalInicial = 0
        def totalFinal = 0

        def modificacion = cn.rows(sql.toString())

        modificacion.each{mod->

            totalInicial += (mod?.incr)
            totalFinal += (mod?.decr)

        }




        def iniRow = 2
        def iniCol = 1

        def curRow = iniRow
        def curCol = iniCol

        try {

            Workbook wb = new Workbook()
            Sheet sheet = wb.createSheet("Reporte de reformas")
            // Create a new font and alter it.
            def estilos = ReportesNuevosExcelController.getEstilos(wb)
            CellStyle styleHeader = estilos.styleHeader
            CellStyle styleTabla = estilos.styleTabla
            CellStyle styleNumber = estilos.styleNumber
            CellStyle styleFooter = estilos.styleFooter
            CellStyle styleFooterCenter = estilos.styleFooterCenter

            // Create a row and put some cells in it. Rows are 0 based.
            def titulo = "REPORTE DE REFORMAS Y AJUSTES - Desde: ${fechaInicio.format("dd-MM-yyyy")} hasta: ${fechaFin.format("dd-MM-yyy")}"
            def subtitulo = ""
            curRow = ReportesNuevosExcelController.setTitulos(sheet, estilos, iniRow, iniCol, titulo, subtitulo)

            Row rowHeader = sheet.createRow((short) curRow)
            curRow++
            Cell cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("AÑO")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 2000)
            curCol++

            cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("#")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 2000)
            curCol++

            cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("ACTIVIDAD")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 20000)
            curCol++

            cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("PARTIDA")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 4000)
            curCol++

            cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("REF.")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 4000)
            curCol++

            cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("AJS.")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 4000)
            curCol++

            cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("VALOR INICIAL")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 4000)
            curCol++

            cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("INCREMENTO")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 4000)
            curCol++

            cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("REDUCCIÓN")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 4000)
            curCol++

            cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("VALOR CÓDIFICADO")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 4000)
            curCol++

            def totalCols = curCol
            ReportesNuevosExcelController.joinTitulos(sheet, iniRow, iniCol, totalCols, false)


//            println("mod " + modificacion)

            modificacion.each {
                curCol = iniCol
                Row tableRow = sheet.createRow((short) curRow)
                Cell cellTabla = tableRow.createCell((short) curCol)

                Row tableRow2 = sheet.createRow((short) curRow + 1)
                Cell cellTabla2 = tableRow2.createCell((short) curCol)

                cellTabla.setCellValue(it?.anio)
                cellTabla.setCellStyle(styleTabla)
//                cellTabla2.setCellValue(it?.recibe?.programa?.descripcion)
//                cellTabla2.setCellStyle(styleTabla)
                curCol++
                cellTabla = tableRow.createCell((short) curCol)
                cellTabla.setCellValue(it?.nmro)
                cellTabla.setCellStyle(styleTabla)
//                cellTabla2 = tableRow2.createCell((short) curCol)
//                cellTabla2.setCellValue(it?.recibe?.componente?.descripcion)
//                cellTabla2.setCellStyle(styleTabla)
                curCol++
                cellTabla = tableRow.createCell((short) curCol)
                cellTabla.setCellValue(it?.actv)
                cellTabla.setCellStyle(styleTabla)
//                cellTabla2 = tableRow2.createCell((short) curCol)
//                cellTabla2.setCellValue(it?.recibe?.marcoLogico?.numero)
//                cellTabla2.setCellStyle(styleTabla)
                curCol++
                cellTabla = tableRow.createCell((short) curCol)
                cellTabla.setCellValue(it?.prsp)
                cellTabla.setCellStyle(styleNumber)
//                cellTabla2 = tableRow2.createCell((short) curCol)
//                cellTabla2.setCellValue(it?.recibe?.marcoLogico?.toStringCompleto())
//                cellTabla2.setCellStyle(styleTabla)
                curCol++
                cellTabla = tableRow.createCell((short) curCol)
                cellTabla.setCellValue(it?.rfrm)
                cellTabla.setCellStyle(styleTabla)
//                cellTabla2 = tableRow2.createCell((short) curCol)
//                cellTabla2.setCellValue(it.originalDestino)
//                cellTabla2.setCellStyle(styleTabla)
//                totalInicial += (it.originalOrigen + it.originalDestino)
                curCol++
                cellTabla = tableRow.createCell((short) curCol)
                cellTabla.setCellValue(it?.ajst)
                cellTabla.setCellStyle(styleTabla)
//                cellTabla2 = tableRow2.createCell((short) curCol)
//                cellTabla2.setCellValue('')
//                cellTabla2.setCellStyle(styleTabla)
                curCol++
                cellTabla = tableRow.createCell((short) curCol)
                cellTabla.setCellValue(it?.vlin)
                cellTabla.setCellStyle(styleNumber)
//                cellTabla2 = tableRow2.createCell((short) curCol)
//                cellTabla2.setCellValue(it.valor)
//                cellTabla2.setCellStyle(styleNumber)
                curCol++
                cellTabla = tableRow.createCell((short) curCol)
                cellTabla.setCellValue(it.incr)
                cellTabla.setCellStyle(styleNumber)
//                cellTabla2 = tableRow2.createCell((short) curCol)
//                cellTabla2.setCellValue(it.originalDestino - it.valor)
//                cellTabla2.setCellStyle(styleNumber)
//                totalFinal += ((it.originalOrigen + it.valor) + (it.originalDestino - it.valor))
                curCol++

                cellTabla = tableRow.createCell((short) curCol)
                cellTabla.setCellValue(it.decr)
                cellTabla.setCellStyle(styleNumber)
                curCol++

                cellTabla = tableRow.createCell((short) curCol)
                cellTabla.setCellValue(it.prcl)
                cellTabla.setCellStyle(styleNumber)
                curCol++

                curRow++
            }

            curRow++
            curCol = iniCol
            Row totalRow = sheet.createRow((short) curRow)
            Cell cellFooter = totalRow.createCell((short) curCol)
            curCol++
            cellFooter.setCellValue('TOTAL')
            cellFooter.setCellStyle(styleFooterCenter)

            cellFooter = totalRow.createCell((short) curCol)
            curCol++
            cellFooter.setCellValue("")
            cellFooter.setCellStyle(styleFooter)

            cellFooter = totalRow.createCell((short) curCol)
            curCol++
            cellFooter.setCellValue("")
            cellFooter.setCellStyle(styleFooter)

            cellFooter = totalRow.createCell((short) curCol)
            curCol++
            cellFooter.setCellValue("")
            cellFooter.setCellStyle(styleFooter)

            cellFooter = totalRow.createCell((short) curCol)
            curCol++
            cellFooter.setCellValue("")
            cellFooter.setCellStyle(styleFooter)


            cellFooter = totalRow.createCell((short) curCol)
            curCol++
            cellFooter.setCellValue("")
            cellFooter.setCellStyle(styleFooter)

            cellFooter = totalRow.createCell((short) curCol)
            curCol++
            cellFooter.setCellValue("")
            cellFooter.setCellStyle(styleFooter)

            cellFooter = totalRow.createCell((short) curCol)
            curCol++
            cellFooter.setCellValue(totalInicial)
            cellFooter.setCellStyle(styleFooter)

            cellFooter = totalRow.createCell((short) curCol)
            curCol++
            cellFooter.setCellValue(totalFinal)
            cellFooter.setCellStyle(styleFooter)

            cellFooter = totalRow.createCell((short) curCol)
            curCol++
            cellFooter.setCellValue("")
            cellFooter.setCellStyle(styleFooter)

            sheet.addMergedRegion(new CellRangeAddress(
                    curRow, //first row (0-based)
                    curRow, //last row  (0-based)
                    iniCol, //first column (0-based)
                    iniCol + 3  //last column  (0-based)
            ))

            def output = response.getOutputStream()
            def header = "attachment; filename=" + "reporte_reformas.xlsx"
            response.setContentType("application/application/vnd.openxmlformats-officedocument.spreadsheetml.sheet")
            response.setHeader("Content-Disposition", header)
            wb.write(output)
            output.flush()

        } catch (Exception ex) {
            ex.printStackTrace();
        }

    }

    def poaAvalesGUI() {

    }

    def poaReformasGUI() {

    }

    def disponibilidadGUI () {

    }

//    def reportePdfAvales() {
//
//        def total = 0
//
//        def cn = dbConnectionService.getConnection()
//        def tx = "select avalnmro, avalfcap, prconmbr, unejnmbr, unej.unej__id, sum(poasmnto), fnte__id " +
//                "from prco, slav, unej, aval, poas, asgn " +
//                "where slav.prco__id = prco.prco__id and unej.unej__id = slav.unej__id and " +
//                "aval.prco__id = prco.prco__id and poas.prco__id = prco.prco__id and " +
//                "asgn.asgn__id = poas.asgn__id and slav.edav__id <> 90 " +
//                "group by avalnmro, avalfcap, prconmbr, unejnmbr, unej.unej__id, avalnmro, avalfcap, fnte__id " +
//                "order by avalnmro, fnte__id;"
//        println "+++sql: $tx"
//        def res = cn.rows(tx.toString())
//        def unidades = []
//
//        cn.eachRow(tx.toString()) { d ->
//            total += d.sum
//            unidades += firmasService.requirentes(UnidadEjecutora.get(d.unej__id))
//        }
//
//        cn.close()
//        return [cn: res, total: total, unidades: unidades]
//
//    }


    def reportePdfAvales() {

//        println("params " + params)

        def actual = new Date().format("yyyy")

        def cn = dbConnectionService.getConnection()
        def fechaInicio = new Date().parse("dd-MM-yyyy",params?.ini)
        def fechaFin = new Date().parse("dd-MM-yyyy",params?.fin)

        def tx =  "select slavnmro, avalnmro, fntedscr, avalfcha, prconmbr, avalmnto, vloractl, vlorsgnt, " +
                "edavdscr, lbrdactl, lbrdsgnt, unejnmbr from rp_avales('${fechaInicio.format("yyyy-MM-dd")}', " +
                "'${fechaFin.format("yyyy-MM-dd")}', ${params.fnt}) where avalmnto > 0;"

        println("tx " + tx)


        def res = cn.rows(tx.toString())
        cn.close()
        return [cn: res, actual: actual]

    }


    def reporteEgresosGastosPdf() {

        def data = poaGrupoGastosPlanificado_funcion()
        return [anio: data.anio, data: data.data, anios: data.anios, totales: data.totales]


    }

    def reporteEgresosGastosExcel() {
        def data = poaGrupoGastosPlanificado_funcion()
        def anio = data.anio
        def totales = data.totales

        def iniRow = 0
        def iniCol = 1

        def curRow = iniRow
        def curCol = iniCol

        try {

            Workbook wb = new Workbook()
            Sheet sheet = wb.createSheet("Reporte de egresos no permanentes")

            def estilos = ReportesNuevosExcelController.getEstilos(wb)
            CellStyle styleHeader = estilos.styleHeader
            CellStyle styleTabla = estilos.styleTabla
            CellStyle styleNumber = estilos.styleNumber
            CellStyle styleFooter = estilos.styleFooter
            CellStyle styleFooterCenter = estilos.styleFooterCenter

            // Create a row and put some cells in it. Rows are 0 based.
            def titulo = "REPORTE DE EGRESOS NO PERMANENTES"
            def subtitulo = "GRUPO DE GASTO - EN DÓLARES"
            curRow = ReportesNuevosExcelController.setTitulos(sheet, estilos, iniRow, iniCol, titulo, subtitulo)

//
            Row rowHeader = sheet.createRow((short) curRow)
            curRow++
            Cell cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("GRUPO PRESUPUESTARIO")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 6000)
            curCol++

            cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("GRUPO DE GASTO")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 9000)
            curCol++

            data.anios.each { a ->
                cellHeader = rowHeader.createCell((short) curCol)
                cellHeader.setCellValue("AÑO ${a}")
                cellHeader.setCellStyle(styleHeader)
                sheet.setColumnWidth(curCol, 4000)
                curCol++
            }

            def totalCols = curCol
            ReportesNuevosExcelController.joinTitulos(sheet, iniRow, iniCol, totalCols)

            def total = 0

            data.data.each { v ->
                curCol = iniCol
                Row tableRow = sheet.createRow((short) curRow)

                def tableCell = tableRow.createCell(curCol)
                tableCell.setCellValue(v.partida.numero.replaceAll("0", ""))
                tableCell.setCellStyle(styleTabla)
                curCol++

                tableCell = tableRow.createCell(curCol)
                tableCell.setCellValue("" + v.partida.descripcion)
                tableCell.setCellStyle(styleTabla)
                curCol++
                def str = ""
                str = ""

                data.anios.each { a ->
                    str = v.valores[a] ?: 0
                    tableCell = tableRow.createCell(curCol)
                    tableCell.setCellValue(str)
                    tableCell.setCellStyle(styleNumber)
                    curCol++
                }
                curRow++
            }


            curCol = iniCol
            Row totalRow = sheet.createRow((short) curRow)

            Cell cellFooter = totalRow.createCell((short) curCol)
            curCol++
            cellFooter.setCellValue("TOTAL")
            cellFooter.setCellStyle(styleFooter)

            cellFooter = totalRow.createCell((short) curCol)
            curCol++
            cellFooter.setCellValue("")
            cellFooter.setCellStyle(styleFooterCenter)

            data.anios.each { b ->
                cellFooter = totalRow.createCell((short) curCol)
                curCol++
                cellFooter.setCellValue(totales[b] ?: 0)
                cellFooter.setCellStyle(styleFooter)
            }

            sheet.addMergedRegion(new CellRangeAddress(
                    curRow, //first row (0-based)
                    curRow, //last row  (0-based)
                    iniCol, //first column (0-based)
                    iniCol + 1 //last column  (0-based)
            ))

            def output = response.getOutputStream()
            def header = "attachment; filename=" + "reporte_egresos_gastos.xlsx"
            response.setContentType("application/application/vnd.openxmlformats-officedocument.spreadsheetml.sheet")
            response.setHeader("Content-Disposition", header)
            wb.write(output)
            output.flush()

        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }
}
