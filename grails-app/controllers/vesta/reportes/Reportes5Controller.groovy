package vesta.reportes

import org.apache.poi.ss.usermodel.CellStyle
import org.apache.poi.ss.usermodel.Font
import org.apache.poi.ss.usermodel.IndexedColors
import org.apache.poi.ss.util.CellRangeAddress
import org.apache.poi.xssf.usermodel.XSSFCell
import org.apache.poi.xssf.usermodel.XSSFColor
import org.apache.poi.xssf.usermodel.XSSFRow
import org.apache.poi.xssf.usermodel.XSSFSheet
import org.apache.poi.xssf.usermodel.XSSFWorkbook
import vesta.parametros.UnidadEjecutora
import vesta.parametros.poaPac.Anio
import vesta.parametros.poaPac.Fuente
import vesta.parametros.poaPac.Presupuesto
import vesta.poa.Asignacion
import vesta.poaCorrientes.ActividadCorriente
import vesta.poaCorrientes.MacroActividad
import vesta.poaCorrientes.ObjetivoGastoCorriente
import vesta.poaCorrientes.Tarea
import vesta.proyectos.MarcoLogico
import vesta.proyectos.ModificacionAsignacion
import vesta.proyectos.Proyecto
import vesta.utilitarios.BuscadorService

class Reportes5Controller {

//    def index() {}

    def dbConnectionService
    def buscadorService


    def reporteRecursosPdf() {

        def data = recursosNoPermanentes_funcion()
        return [anio: data.anio, data: data.data, anios: data.anios, totales: data.totales]
    }


    def recursosNoPermanentes_funcion() {
        def strAnio = new Date().format('yyyy')
        def anio = Anio.findByAnio(strAnio)

        def data = []
        def anios = []
        def partidas = Presupuesto.findAllByNumeroLike('%0000', [sort: 'numero'])
        def fuentes = Fuente.list([sort: 'codigo'])

        def totales = [:]
        totales.resta = 0

        partidas.each { partida ->
            fuentes.each { fuente ->
                def m = [:]
                m.fuente = fuente
                def numero = partida.numero?.replaceAll("0", "")
                m.partida = partida
                m.valores = [:]
                def asignaciones = Asignacion.withCriteria {
                    presupuesto {
                        like("numero", numero + "%")
                    }
                    eq("fuente", fuente)
                }
                asignaciones.each { asg ->
//                m.asignacion = asg
                    def anioAsg = asg.anio
                    def fuenteAsg = asg.fuente
                    if (anioAsg.anio.toInteger() <= anio.anio.toInteger()) {
                        if (!m.valores[anioAsg.anio]) {
                            m.valores[anioAsg.anio] = 0
                            if (!anios.contains(anioAsg.anio)) {
                                anios += anioAsg.anio
                                totales[anioAsg.anio] = 0
                            }
                        }
                        m.valores[anioAsg.anio] += asg.priorizado
                        totales[anioAsg.anio] += asg.priorizado
                        totales.resta += asg.priorizado
                    }
                }
                data += m
            }
        }
//        println("data " + data)
//        println("totales " + totales)
//        totales.each {
//            println("g " + it.key + " "+ g.formatNumber(number: it.value, maxFractionDigits: 2, minFractionDigits: 2))
//        }
        anios = anios.sort()
        return [anio: anio, data: data, anios: anios, totales: totales]
    }

    def recursosNoPermanentesSubroyectos_funcion (){
        def strAnio = new Date().format('yyyy')
        def anio = Anio.findByAnio(strAnio)

        def data = []
        def anios = []
        def partidas = Presupuesto.findAllByNumeroLike('%0000', [sort: 'numero'])
        def fuentes = Fuente.list([sort: 'codigo'])

        def proyectos = Proyecto.list([sort: "codigo"])


        def totales = [:]
        totales.resta = 0


        proyectos.each {proy->

            def m = [:]
            m.proyecto = proy
            m.valores = [:]

            def actividades = MarcoLogico.findAllByProyecto(proy)
            def asignaciones = []
            if(actividades.size() > 0 ){
                asignaciones = Asignacion.withCriteria {
                    inList("marcoLogico", actividades)
                }
            }

            asignaciones.each { asg ->
//                m.asignacion = asg
                def anioAsg = asg.anio
                def fuenteAsg = asg.fuente
                if (anioAsg.anio.toInteger() <= anio.anio.toInteger()) {
                    if (!m.valores[anioAsg.anio]) {
                        m.valores[anioAsg.anio] = 0
                        if (!anios.contains(anioAsg.anio)) {
                            anios += anioAsg.anio
                            totales[anioAsg.anio] = 0
                        }
                    }
                    m.valores[anioAsg.anio] += asg.priorizado
                    totales[anioAsg.anio] += asg.priorizado
                    totales.resta += asg.priorizado
                }
            }
            data += m
        }

        anios = anios.sort()
        return [anio: anio, data: data, anios: anios, totales: totales]
    }

    def reporteRecursosExcel() {
        def data = recursosNoPermanentes_funcion()
        def anio = data.anio
        def totales = data.totales

        def iniRow = 1
        def iniCol = 1

        def curRow = iniRow
        def curCol = iniCol

        try {

            XSSFWorkbook wb = new XSSFWorkbook()
            XSSFSheet sheet = wb.createSheet("Reporte de recursos no permanentes")

            def estilos = ReportesNuevosExcelController.getEstilos(wb)
            CellStyle styleHeader = estilos.styleHeader
            CellStyle styleNumber = estilos.styleNumber
            CellStyle styleTabla = estilos.styleTabla
            CellStyle styleFooter = estilos.styleFooter
            CellStyle styleFooterCenter = estilos.styleFooterCenter

            def titulo = "PROFORMA PRESUPUESTARIA DE RECURSOS NO PERMANENTES"
            def subtitulo = "GRUPO DE GASTO - EN DÓLARES"
            curRow = ReportesNuevosExcelController.setTitulos(sheet, estilos, iniRow, iniCol, titulo, subtitulo)

            def nrowHeader1 = curRow
            def nrowHeader2 = curRow + 1
            XSSFRow rowHeader = sheet.createRow((short) curRow)
            curRow++
            XSSFCell cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("GRUPO PRESUPUESTARIO")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 6000)


            XSSFRow rowHeader2 = sheet.createRow((short) curRow)
            curRow++
            XSSFCell cellHeader2 = rowHeader2.createCell((short) curCol)
            cellHeader2.setCellValue("")
            cellHeader2.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 6000)
            curCol++

            cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("GRUPO DE GASTO")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 9000)

            cellHeader2 = rowHeader2.createCell((short) curCol)
            cellHeader2.setCellValue("")
            cellHeader2.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 9000)

            curCol++

            cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("FUENTE")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 7000)

            cellHeader2 = rowHeader2.createCell((short) curCol)
            cellHeader2.setCellValue("")
            cellHeader2.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 7000)
            curCol++

            cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("PRESUPUESTO CODIFICADO AÑO ${anio.anio.toInteger() - 1}")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 8000)

            cellHeader2 = rowHeader2.createCell((short) curCol)
            cellHeader2.setCellValue("")
            cellHeader2.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 8000)
            curCol++

            cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("PROFORMA AÑO ${anio.anio}")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 6000)

            cellHeader2 = rowHeader2.createCell((short) curCol)
            cellHeader2.setCellValue("")
            cellHeader2.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 6000)
            curCol++

            cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("PARTICIPACIÓN % ")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 4000)

            cellHeader2 = rowHeader2.createCell((short) curCol)
            cellHeader2.setCellValue("")
            cellHeader2.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 4000)
            curCol++

            cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("VARIACIÓN")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 4000)

            cellHeader2 = rowHeader2.createCell((short) curCol)
            cellHeader2.setCellValue("ABSOLUTA")
            cellHeader2.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 4000)
            curCol++

            cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 4000)

            cellHeader2 = rowHeader2.createCell((short) curCol)
            cellHeader2.setCellValue("%")
            cellHeader2.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 4000)
            curCol++
//            curRow++

            def totalCols = curCol
            ReportesNuevosExcelController.joinTitulos(sheet, iniRow, iniCol, totalCols)

            (0..5).each { n ->
                sheet.addMergedRegion(new CellRangeAddress(
                        nrowHeader1, //first row (0-based)
                        nrowHeader2, //last row  (0-based)
                        iniCol + n, //first column (0-based)
                        iniCol + n   //last column  (0-based)
                ))
            }
            sheet.addMergedRegion(new CellRangeAddress(
                    nrowHeader1, //first row (0-based)
                    nrowHeader1, //last row  (0-based)
                    iniCol + 6, //first column (0-based)
                    iniCol + 7   //last column  (0-based)
            ))

            def total = 0
//            println("data " + data)

            data.data.each { v ->

                def anterior = v.valores["" + (anio.anio.toInteger() - 1)] ?: 0
                def actual = v.valores[anio.anio] ?: 0

                def totalActual = totales[anio.anio] ?: 0
                def totalResta = totales.resta

                def porcentaje1 = (actual * 100) / totalActual
                def resta = actual - anterior
                def porcentaje2 = (resta * 100) / totalResta


                curCol = iniCol
                XSSFRow tableRow = sheet.createRow((short) curRow)

                def tableCell = tableRow.createCell(curCol)
                tableCell.setCellValue(v.partida.numero.replaceAll("0", ""))
                tableCell.setCellStyle(styleTabla)
                curCol++
                tableCell = tableRow.createCell(curCol)
                tableCell.setCellValue(v.partida.descripcion)
                tableCell.setCellStyle(styleTabla)
                curCol++
                tableCell = tableRow.createCell(curCol)
                tableCell.setCellValue(v.fuente.descripcion)
                tableCell.setCellStyle(styleTabla)
                curCol++
                tableCell = tableRow.createCell(curCol)
                tableCell.setCellValue(anterior)
                tableCell.setCellStyle(styleNumber)
                curCol++
                tableCell = tableRow.createCell(curCol)
                tableCell.setCellValue(actual)
                tableCell.setCellStyle(styleNumber)
                curCol++
                tableCell = tableRow.createCell(curCol)
                tableCell.setCellValue(porcentaje1)
                tableCell.setCellStyle(styleNumber)
                curCol++
                tableCell = tableRow.createCell(curCol)
                tableCell.setCellValue(resta)
                tableCell.setCellStyle(styleNumber)
                curCol++
                tableCell = tableRow.createCell(curCol)
                tableCell.setCellValue(porcentaje2)
                tableCell.setCellStyle(styleNumber)
                curCol++

                curRow++
            }


            curCol = iniCol
            XSSFRow totalRow = sheet.createRow((short) curRow)
            XSSFCell cellFooter = totalRow.createCell((short) curCol)
            curCol++
            cellFooter.setCellValue("TOTAL")
            cellFooter.setCellStyle(styleFooterCenter)

            cellFooter = totalRow.createCell((short) curCol)
            curCol++
            cellFooter.setCellValue("")
            cellFooter.setCellStyle(styleFooterCenter)

            cellFooter = totalRow.createCell((short) curCol)
            curCol++
            cellFooter.setCellValue("")
            cellFooter.setCellStyle(styleFooterCenter)

            cellFooter = totalRow.createCell((short) curCol)
            curCol++
            cellFooter.setCellValue(totales["" + (anio.anio.toInteger() - 1)] ?: 0)
            cellFooter.setCellStyle(styleFooter)

            cellFooter = totalRow.createCell((short) curCol)
            curCol++
            cellFooter.setCellValue(totales[anio.anio])
            cellFooter.setCellStyle(styleFooter)

            cellFooter = totalRow.createCell((short) curCol)
            curCol++
            cellFooter.setCellValue(100)
            cellFooter.setCellStyle(styleFooter)

            cellFooter = totalRow.createCell((short) curCol)
            curCol++
            cellFooter.setCellValue(totales.resta)
            cellFooter.setCellStyle(styleFooter)

            cellFooter = totalRow.createCell((short) curCol)
            curCol++
            cellFooter.setCellValue(100)
            cellFooter.setCellStyle(styleFooter)

            sheet.addMergedRegion(new CellRangeAddress(
                    curRow, //first row (0-based)
                    curRow, //last row  (0-based)
                    iniCol, //first column (0-based)
                    iniCol + 2 //last column  (0-based)
            ))

            def output = response.getOutputStream()
            def header = "attachment; filename=" + "reporte_recursos_noPermanentes.xlsx"
            response.setContentType("application/application/vnd.openxmlformats-officedocument.spreadsheetml.sheet")
            response.setHeader("Content-Disposition", header)
            wb.write(output)
            output.flush()

        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }

    def reporteRecursosSubproyectosExcel () {

        def data = recursosNoPermanentesSubroyectos_funcion()
        def anio = data.anio
        def totales = data.totales

        def iniRow = 1
        def iniCol = 1

        def curRow = iniRow
        def curCol = iniCol

        try {

            XSSFWorkbook wb = new XSSFWorkbook()
            XSSFSheet sheet = wb.createSheet("Reporte de recursos no permanentes subproyectos")

            def estilos = ReportesNuevosExcelController.getEstilos(wb)
            CellStyle styleHeader = estilos.styleHeader
            CellStyle styleNumber = estilos.styleNumber
            CellStyle styleTabla = estilos.styleTabla
            CellStyle styleFooter = estilos.styleFooter
            CellStyle styleFooterCenter = estilos.styleFooterCenter

            def titulo = "PROFORMA PRESUPUESTARIA DE RECURSOS NO PERMANENTES"
            def subtitulo = " SUBPROYECTOS - EN DÓLARES"
            curRow = ReportesNuevosExcelController.setTitulos(sheet, estilos, iniRow, iniCol, titulo, subtitulo)

            def nrowHeader1 = curRow
            def nrowHeader2 = curRow + 1
            XSSFRow rowHeader = sheet.createRow((short) curRow)
            curRow++
            XSSFCell cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("PROYECTOS")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 6000)

            XSSFRow rowHeader2 = sheet.createRow((short) curRow)
            curRow++
            XSSFCell cellHeader2 = rowHeader2.createCell((short) curCol)
            cellHeader2.setCellValue("NÚMERO")
            cellHeader2.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 3000)
            curCol++

            cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 9000)

            cellHeader2 = rowHeader2.createCell((short) curCol)
            cellHeader2.setCellValue("DETALLE")
            cellHeader2.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 12000)
            curCol++

            cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("PRESUPUESTO CODIFICADO AÑO ${anio.anio.toInteger() - 1}")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 8000)

            cellHeader2 = rowHeader2.createCell((short) curCol)
            cellHeader2.setCellValue("")
            cellHeader2.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 8000)
            curCol++

            cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("PROFORMA AÑO ${anio.anio}")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 6000)

            cellHeader2 = rowHeader2.createCell((short) curCol)
            cellHeader2.setCellValue("")
            cellHeader2.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 6000)
            curCol++

            cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("PARTICIPACIÓN % ")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 4000)

            cellHeader2 = rowHeader2.createCell((short) curCol)
            cellHeader2.setCellValue("")
            cellHeader2.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 4000)
            curCol++

            cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("VARIACIÓN")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 4000)

            cellHeader2 = rowHeader2.createCell((short) curCol)
            cellHeader2.setCellValue("ABSOLUTA")
            cellHeader2.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 4000)
            curCol++

            cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 4000)

            cellHeader2 = rowHeader2.createCell((short) curCol)
            cellHeader2.setCellValue("%")
            cellHeader2.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 3000)
            curCol++
//            curRow++

            def totalCols = curCol
            ReportesNuevosExcelController.joinTitulos(sheet, iniRow, iniCol, totalCols)

            (2..4).each { n ->
                sheet.addMergedRegion(new CellRangeAddress(
                        nrowHeader1, //first row (0-based)
                        nrowHeader2, //last row  (0-based)
                        iniCol + n, //first column (0-based)
                        iniCol + n   //last column  (0-based)
                ))
            }
            sheet.addMergedRegion(new CellRangeAddress(
                    nrowHeader1, //first row (0-based)
                    nrowHeader1, //last row  (0-based)
                    iniCol + 5, //first column (0-based)
                    iniCol + 6   //last column  (0-based)
            ))
            sheet.addMergedRegion(new CellRangeAddress(
                    nrowHeader1, //first row (0-based)
                    nrowHeader1, //last row  (0-based)
                    iniCol + 0, //first column (0-based)
                    iniCol + 1   //last column  (0-based)
            ))

            def total = 0
//            println("data " + data)

            data.data.each { v ->

                def anterior = v.valores["" + (anio.anio.toInteger() - 1)] ?: 0
                def actual = v.valores[anio.anio] ?: 0

                def totalActual = totales[anio.anio] ?: 0
                def totalResta = totales.resta

                def porcentaje1 = (actual * 100) / totalActual
                def resta = actual - anterior
                def porcentaje2 = (resta * 100) / totalResta

                curCol = iniCol
                XSSFRow tableRow = sheet.createRow((short) curRow)

                def tableCell = tableRow.createCell(curCol)
                tableCell.setCellValue(v.proyecto.codigo)
                tableCell.setCellStyle(styleTabla)
                curCol++
                tableCell = tableRow.createCell(curCol)
                tableCell.setCellValue(v.proyecto.nombre)
                tableCell.setCellStyle(styleTabla)
                curCol++
                tableCell = tableRow.createCell(curCol)
                tableCell.setCellValue(anterior)
                tableCell.setCellStyle(styleNumber)
                curCol++
                tableCell = tableRow.createCell(curCol)
                tableCell.setCellValue(actual)
                tableCell.setCellStyle(styleNumber)
                curCol++
                tableCell = tableRow.createCell(curCol)
                tableCell.setCellValue(porcentaje1)
                tableCell.setCellStyle(styleNumber)
                curCol++
                tableCell = tableRow.createCell(curCol)
                tableCell.setCellValue(resta)
                tableCell.setCellStyle(styleNumber)
                curCol++
                tableCell = tableRow.createCell(curCol)
                tableCell.setCellValue(porcentaje2)
                tableCell.setCellStyle(styleNumber)
                curCol++
                curRow++
            }


            curCol = iniCol
            XSSFRow totalRow = sheet.createRow((short) curRow)
            XSSFCell cellFooter = totalRow.createCell((short) curCol)
            curCol++
            cellFooter.setCellValue("TOTAL")
            cellFooter.setCellStyle(styleFooterCenter)

            cellFooter = totalRow.createCell((short) curCol)
            curCol++
            cellFooter.setCellValue("")
            cellFooter.setCellStyle(styleFooterCenter)

            cellFooter = totalRow.createCell((short) curCol)
            curCol++
            cellFooter.setCellValue(totales["" + (anio.anio.toInteger() - 1)] ?: 0)
            cellFooter.setCellStyle(styleFooter)

            cellFooter = totalRow.createCell((short) curCol)
            curCol++
            cellFooter.setCellValue(totales[anio.anio])
            cellFooter.setCellStyle(styleFooter)

            cellFooter = totalRow.createCell((short) curCol)
            curCol++
            cellFooter.setCellValue(100)
            cellFooter.setCellStyle(styleFooter)

            cellFooter = totalRow.createCell((short) curCol)
            curCol++
            cellFooter.setCellValue(totales.resta)
            cellFooter.setCellStyle(styleFooter)

            cellFooter = totalRow.createCell((short) curCol)
            curCol++
            cellFooter.setCellValue(100)
            cellFooter.setCellStyle(styleFooter)

            sheet.addMergedRegion(new CellRangeAddress(
                    curRow, //first row (0-based)
                    curRow, //last row  (0-based)
                    iniCol, //first column (0-based)
                    iniCol + 1 //last column  (0-based)
            ))

            def output = response.getOutputStream()
            def header = "attachment; filename=" + "reporte_recursos_subproyectos.xlsx"
            response.setContentType("application/application/vnd.openxmlformats-officedocument.spreadsheetml.sheet")
            response.setHeader("Content-Disposition", header)
            wb.write(output)
            output.flush()

        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }

    def reporteRecursosSubproyectosPdf() {

        def data = recursosNoPermanentesSubroyectos_funcion()
        return [anio: data.anio, data: data.data, anios: data.anios, totales: data.totales]
    }

    def reporteReformasPdf () {
        println "reporteReformasPdf params: $params"
        def fuente = Fuente.get(params.fnt.toLong())
        def cn = dbConnectionService.getConnection()
        def sql = "select nmro, prsp, anio, actv, vlin, incr, decr, rfrm, ajst, fcha, mdasorgn, prcl " +
                "from reforma('1-feb-2016', '14-apr-2016', ${fuente.id}) order by proy, comp, nmro, prsp, mdas__id"

        def totalInicial = 0
        def totalFinal = 0

        def modificacion = cn.rows(sql.toString())

        modificacion.each{mod->

            totalInicial += (mod?.incr)
            totalFinal += (mod?.decr)

        }

        return [modificacion : modificacion, totalInicial: totalInicial, totalFinal: totalFinal]

    }

    def reporteGastoPermanentePdf () {

//        println("params reportes gasto " + params)

        def anio = Anio.get(params.anio)
        def asignaciones = []

        if (params.objetivo != '-1') {
//            println("entro if")
            def objetivo = ObjetivoGastoCorriente.get(params.objetivo)
            def unidad = UnidadEjecutora.get(params.unidad)
            def macros = MacroActividad.findAllByObjetivoGastoCorriente(objetivo)
            def actividades = ActividadCorriente.findAllByMacroActividadInList(macros)
            def tareas = Tarea.findAllByActividadInList(actividades)
            asignaciones = Asignacion.findAllByTareaInListAndAnioAndUnidad(tareas, anio, unidad, [sort: 'unidad', order: 'unidad'])

        }else{
//            println("entro else")
            asignaciones = Asignacion.findAllByAnioAndTareaIsNotNull(anio, [sort: 'unidad', order: 'unidad'])
        }
//       if (params.objetivo == 'T' || params.objetivo == -1) {
//            asignaciones = Asignacion.findAllByAnioAndTareaIsNotNull(anio, [sort: 'unidad', order: 'unidad'])
//        }

        return [asignaciones: asignaciones]


    }


    def reporteGastoPermanenteUnidad () {

        def unidad = UnidadEjecutora.get(params.unidad)
        def anio = Anio.get(params.anio)



        def unidades = UnidadEjecutora.list()
        def asignacionesxunidad = []
        def mapa = [:]

        unidades.each {uni->

            def totalUnidad = 0
            asignacionesxunidad = Asignacion.findAllByUnidadAndAnioAndMarcoLogicoIsNull(uni, anio).each {
                totalUnidad += it?.planificado
            }

            if(totalUnidad != 0){
                mapa[uni.id] = [
                        unidad : uni,
                        total : totalUnidad
                ]
            }

        }

        return [mapa: mapa, unidad: unidad]

    }

    def reporteCorrientesPorAreas () {
        def now = new Date()
        params.anio = now.format("yyyy")
        def urlPdf = "${createLink(controller: 'reportes5', action: 'reporteGastoPermanenteUnidad')}?Wanio=9";
        def pdfFileName = "reportePoaxArea";
        params.url = urlPdf
        params.filename = pdfFileName
        redirect(controller:'pdf',action:'pdfLink', params: params)
    }

    def reportePOAExcel() {  // poner etiqueta: Planificación operativa anual - POA
        def urlExcel = "${createLink(controller: 'reportes4', action: 'poaXlsx')}";
        redirect(controller:'reportes4',action:'poaXlsx', params: params)
    }

    def reportePOAExcelCorr() {  // poner etiqueta: Planificación operativa anual - POA
        def now = new Date()
        params.anio = Anio.findByAnio(now.format("yyyy")).id
        params.objetivo = '-1'
        def urlExcel = "${createLink(controller: 'reportes6', action: 'reporteAvalesPermanentesExcel')}";
        redirect(controller:'reportes6',action:'reporteAvalesPermanentesExcel', params: params)
    }


    def reportePoaCorrientes() {
        def now = new Date()
        params.anio = now.format("yyyy")
        def urlPdf = "${createLink(controller: 'reportes5', action: 'reporteGastoPermanentePdf')}?Wanio=9&Wobjetivo=-1";
        def pdfFileName = "ReporteGastoPermanente";
        params.url = urlPdf
        params.filename = pdfFileName
        redirect(controller:'pdf',action:'pdfLink', params: params)
    }


    def pruebaBuscador () {
        def cn = dbConnectionService.getConnection()

        params.old = params.criterio
        params.criterio = buscadorService.limpiaCriterio(params.criterio)

        def sql = armaSql(params)
        def res = cn.rows(sql)
//        println "registro retornados del sql: ${res.size()}"
//        println ("sql :  " + sql)
        params.criterio = params.old
//        println("res " + res)
        return [res: res, params: params]
    }

    def armaSql(params){
        def campos = buscadorService.parametros()
        def operador = buscadorService.operadores()


        def sqlSelect = "select prsnnmbr,prsnapll, prsncdla, prsndire " +
                        "from prsn "
        def sqlWhere = "where prsn__id is not null "

        println "llega params: $params"
        params.nombre = "Código"
        if(campos.find {it.campo == params.buscador}?.size() > 0) {
            def op = operador.find {it.valor == params.operador}
//            println "op: $op"
            sqlWhere += " and ${params.buscador} ${op.operador} ${op.strInicio}${params.criterio}${op.strFin}";
        }
//        println "txWhere: $sqlWhere"
//        println "sql armado: sqlSelect: ${sqlSelect} \n sqlWhere: ${sqlWhere} \n sqlOrder: ${sqlOrder}"
        //retorna sql armado:
//        "$sqlSelect $sqlWhere $sqlOrder".toString()
        "$sqlSelect $sqlWhere ".toString()
    }

    def prueba () {

    }


}
