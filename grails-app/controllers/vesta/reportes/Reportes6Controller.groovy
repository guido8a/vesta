package vesta.reportes

import org.apache.poi.ss.usermodel.CellStyle
import org.apache.poi.ss.util.CellRangeAddress
import org.apache.poi.xssf.usermodel.XSSFCell as Cell
import org.apache.poi.xssf.usermodel.XSSFRow as Row
import org.apache.poi.xssf.usermodel.XSSFSheet as Sheet
import org.apache.poi.xssf.usermodel.XSSFWorkbook as Workbook
import vesta.avales.Aval
import vesta.avales.AvalCorriente
import vesta.avales.EstadoAval
import vesta.avales.ProcesoAsignacion
import vesta.parametros.PresupuestoUnidad
import vesta.parametros.UnidadEjecutora
import vesta.parametros.poaPac.Anio
import vesta.parametros.poaPac.Fuente
import vesta.parametros.poaPac.Mes
import vesta.parametros.poaPac.Presupuesto
import vesta.poa.Asignacion
import vesta.poa.ProgramacionAsignacion
import vesta.poaCorrientes.ActividadCorriente
import vesta.poaCorrientes.MacroActividad
import vesta.poaCorrientes.ObjetivoGastoCorriente
import vesta.poaCorrientes.Tarea
import vesta.proyectos.MarcoLogico
import vesta.proyectos.MetaBuenVivirProyecto
import vesta.proyectos.Proyecto
import vesta.seguridad.Persona
import vesta.seguridad.Sesn

class Reportes6Controller {
    def dbConnectionService
    def firmasService

    def disponibilidadFuenteXlsx() {
        def fuente = Fuente.get(params.fnt.toLong())
        def datos = disponibilidadFuente_funcion(fuente)

        def anio = new Date().format("yyyy")

        def data = datos.data
        def totales = datos.totales

        def iniRow = 0
        def iniCol = 1

        def curRow = iniRow
        def curCol = iniCol

        try {
            Workbook wb = new Workbook()
            Sheet sheet = wb.createSheet("Disponibilidad de recursos")
            // Create a new font and alter it.
            def estilos = ReportesNuevosExcelController.getEstilos(wb)
            CellStyle styleHeader = estilos.styleHeader
            CellStyle styleTabla = estilos.styleTabla
            CellStyle styleNumber = estilos.styleNumber
            CellStyle styleFooter = estilos.styleFooter
            CellStyle styleFooterCenter = estilos.styleFooterCenter

            // Create a row and put some cells in it. Rows are 0 based.
            def titulo = "DISPONIBILIDAD DE RECURSOS AÑO " + anio
            def subtitulo = "${fuente ? 'FUENTE ' + fuente.descripcion : 'TODAS LAS FUENTES'} - EN DÓLARES"
            curRow = ReportesNuevosExcelController.setTitulos(sheet, estilos, iniRow, iniCol, titulo, subtitulo)

            Row rowHeader = sheet.createRow((short) curRow)
            Cell cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("GG")
            sheet.setColumnWidth(curCol, 2000)
            cellHeader.setCellStyle(styleHeader)
            curCol++

            cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("#")
            sheet.setColumnWidth(curCol, 2000)
            cellHeader.setCellStyle(styleHeader)
            curCol++

            cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("ACTIVIDAD")
            sheet.setColumnWidth(curCol, 6000)
            cellHeader.setCellStyle(styleHeader)
            curCol++

            cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("RESPONSABLE")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 6000)
            curCol++

            cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("PRESUPUESTO CODIFICADO")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 3000)
            curCol++

            cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("MONTO AVALADO")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 3000)
            curCol++

            cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("RECURSOS DISPONIBLES")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 3000)
            curCol++

            ReportesNuevosExcelController.joinTitulos(sheet, iniRow, iniCol, curCol)

            curRow++

            data.each { k, v ->
                curCol = iniCol

                Row tableRow = sheet.createRow((short) curRow)
                def tableCell = tableRow.createCell(curCol)
                tableCell.setCellValue(v?.partida?.numero[0..1])
                tableCell.setCellStyle(styleTabla)
                curCol++

                tableCell = tableRow.createCell(curCol)
                tableCell.setCellValue(v?.actividad?.numero)
                tableCell.setCellStyle(styleTabla)
                curCol++

                tableCell = tableRow.createCell(curCol)
                tableCell.setCellValue(v?.actividad?.toStringCompleto())
                tableCell.setCellStyle(styleTabla)
                curCol++

                tableCell = tableRow.createCell(curCol)
                tableCell.setCellValue(v?.actividad?.responsable?.nombre)
                tableCell.setCellStyle(styleTabla)
                curCol++

                tableCell = tableRow.createCell(curCol)
                tableCell.setCellValue(v?.valores?.priorizado)
                tableCell.setCellStyle(styleNumber)
                curCol++

                tableCell = tableRow.createCell(curCol)
                tableCell.setCellValue(v?.valores?.avales)
                tableCell.setCellStyle(styleNumber)
                curCol++

                tableCell = tableRow.createCell(curCol)
                tableCell.setCellValue(v?.valores?.disponible)
                tableCell.setCellStyle(styleNumber)
                curCol++

                curRow++
            }

            sheet.addMergedRegion(new CellRangeAddress(
                    curRow, //first row (0-based)
                    curRow, //last row  (0-based)
                    iniCol, //first column (0-based)
                    iniCol + 3 //last column  (0-based)
            ))

            curCol = iniCol
            Row totalRow = sheet.createRow((short) curRow)

            Cell cellFooter = totalRow.createCell((short) curCol)
            curCol++
            cellFooter.setCellValue("TOTAL")
            cellFooter.setCellStyle(styleFooterCenter)

            (1..3).each {
                cellFooter = totalRow.createCell((short) curCol)
                curCol++
                cellFooter.setCellValue("")
                cellFooter.setCellStyle(styleFooterCenter)
            }

            cellFooter = totalRow.createCell((short) curCol)
            curCol++
            cellFooter.setCellValue(totales.priorizado)
            cellFooter.setCellStyle(styleFooter)

            cellFooter = totalRow.createCell((short) curCol)
            curCol++
            cellFooter.setCellValue(totales.avales)
            cellFooter.setCellStyle(styleFooter)

            cellFooter = totalRow.createCell((short) curCol)
            curCol++
            cellFooter.setCellValue(totales.disponible)
            cellFooter.setCellStyle(styleFooter)

            def output = response.getOutputStream()
            def header = "attachment; filename=" + "disponibilidad_recursos.xlsx"
            response.setContentType("application/application/vnd.openxmlformats-officedocument.spreadsheetml.sheet")
            response.setHeader("Content-Disposition", header)
            wb.write(output)
            output.flush()
        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }

    def disponibilidadFuentePdf() {
        def fuente = Fuente.get(params.fnt.toLong())
        def datos = disponibilidadFuente_funcion(fuente)

        def data = datos.data
        def totales = datos.totales

        def anio = new Date().format("yyyy")

        def titulo = "DISPONIBILIDAD DE RECURSOS AÑO " + anio
        def subtitulo = "${fuente ? 'FUENTE ' + fuente.descripcion : 'TODAS LAS FUENTES'} - EN DÓLARES"

        return [data: data, totales: totales, titulo: titulo, subtitulo: subtitulo, anios: datos.anios]
    }

    def aprobarProyectoXlsx() {
        def anioId = params.id
        def anio
        if (anioId) {
            anio = Anio.get(anioId.toLong())
        } else {
            anio = Anio.findByAnio(new Date().format("yyyy"))
        }
        def datos = aprobarProyecto_funcion(anio)
        def data = datos.data
        def anios = datos.anios
        def meses = datos.meses
        def totales = datos.totales

        def iniRow = 0
        def iniCol = 1

        def curRow = iniRow
        def curCol = iniCol

        try {
            Workbook wb = new Workbook()
            Sheet sheet = wb.createSheet("Asignaciones por proyecto")
            // Create a new font and alter it.
            def estilos = ReportesNuevosExcelController.getEstilos(wb)
            CellStyle styleHeader = estilos.styleHeader
            CellStyle styleTabla = estilos.styleTabla
            CellStyle styleDate = estilos.styleDate
            CellStyle styleNumber = estilos.styleNumber
            CellStyle styleSubtotal = estilos.styleSubtotal
            CellStyle styleSubtotalNumber = estilos.styleSubtotalNumber
            CellStyle styleFooter = estilos.styleFooter
            CellStyle styleFooterCenter = estilos.styleFooterCenter

            // Create a row and put some cells in it. Rows are 0 based.
            def titulo = "ASIGNACIONES POR PROYECTO"
            def subtitulo = "AÑO ${anio.anio} - EN DÓLARES"
            curRow = ReportesNuevosExcelController.setTitulos(sheet, estilos, iniRow, iniCol, titulo, subtitulo)

            Row rowHeader = sheet.createRow((short) curRow)
            Cell cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("COD.")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 2000)
            curCol++

            cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("PROYECTO")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 10000)
            curCol++

            cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("COMPONENTE")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 6000)
            curCol++

            cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("GG")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 2000)
            curCol++

            cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("P")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 2000)
            curCol++

            cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("C")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 2000)
            curCol++

            cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("PARTIDA PRESUPUESTARIA")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 4000)
            curCol++

            cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("#")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 1500)
            curCol++

            cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("ACTIVIDAD")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 6000)
            curCol++

            cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("RESPONSABLE")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 5000)
            curCol++

            cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("FECHA DE INICIO")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 2500)
            curCol++

            cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("FECHA DE FIN")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 2500)
            curCol++

            cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("PRESUPUESTO")
            cellHeader.setCellStyle(styleHeader)
            curCol++

            cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("")
            cellHeader.setCellStyle(styleHeader)
            curCol++

            cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("")
            cellHeader.setCellStyle(styleHeader)
            curCol++

            cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("")
            cellHeader.setCellStyle(styleHeader)
            curCol++

            cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("PROGRAMACIÓN MENSUAL AÑO " + anio.anio)
            cellHeader.setCellStyle(styleHeader)
            curCol++

            def colMes = curCol
            def colFinMes = colMes + meses.size() - 1
            meses.eachWithIndex { m, i ->
                if (i > 0) {
                    cellHeader = rowHeader.createCell((short) curCol)
                    cellHeader.setCellValue("")
                    cellHeader.setCellStyle(styleHeader)
                    sheet.setColumnWidth(curCol, 3000)
                    curCol++
                }
            }

            anios.each { a ->
                def str = "AÑO ${a}"
                if (a == anio.anio) {
                    str = "TOTAL"
                }
                cellHeader = rowHeader.createCell((short) curCol)
                cellHeader.setCellValue(str)
                cellHeader.setCellStyle(styleHeader)
                sheet.setColumnWidth(curCol, 3000)
                curCol++
            }

            def totalCols = curCol
            cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("TOTAL PLURIANUAL")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 3000)

            def rowHeader1o = curRow
            curRow++
            def rowHeader2o = curRow

            curCol = iniCol

            Row rowHeader2 = sheet.createRow((short) curRow)

            curCol = colMes - 5
            cellHeader = rowHeader2.createCell((short) curCol)
            cellHeader.setCellValue("ARRASTRE")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 3000)
            curCol++

            cellHeader = rowHeader2.createCell((short) curCol)
            cellHeader.setCellValue("FUENTE")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 4000)
            curCol++

            cellHeader = rowHeader2.createCell((short) curCol)
            cellHeader.setCellValue("NUEVO")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 3000)
            curCol++

            cellHeader = rowHeader2.createCell((short) curCol)
            cellHeader.setCellValue("PRESUPUESTO CODIFICADO")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 3000)
            curCol++

            meses.eachWithIndex { m, i ->
                cellHeader = rowHeader2.createCell((short) curCol)
                cellHeader.setCellValue(m.descripcion)
                cellHeader.setCellStyle(styleHeader)
                sheet.setColumnWidth(curCol, 3000)
                curCol++
            }

            ReportesNuevosExcelController.joinTitulos(sheet, iniRow, iniCol, totalCols)

            (0..11).each { n ->
                sheet.addMergedRegion(new CellRangeAddress(
                        rowHeader1o, //first row (0-based)
                        rowHeader2o, //last row  (0-based)
                        iniCol + n, //first column (0-based)
                        iniCol + n  //last column  (0-based)
                ))
            }
            sheet.addMergedRegion(new CellRangeAddress(
                    rowHeader1o, //first row (0-based)
                    rowHeader1o, //last row  (0-based)
                    colMes - 5, //first column (0-based)
                    colMes - 2  //last column  (0-based)
            ))
            sheet.addMergedRegion(new CellRangeAddress(
                    rowHeader1o, //first row (0-based)
                    rowHeader1o, //last row  (0-based)
                    colMes - 1, //first column (0-based)
                    colFinMes - 1  //last column  (0-based)
            ))
            (1..4).each { n ->
                sheet.addMergedRegion(new CellRangeAddress(
                        rowHeader1o, //first row (0-based)
                        rowHeader2o, //last row  (0-based)
                        colFinMes - 1 + n, //first column (0-based)
                        colFinMes - 1 + n  //last column  (0-based)
                ))
            }

            curRow++

            def strAnio = anio.anio
            def keyArrastre = "" + (strAnio.toInteger() - 1)        //ARRASTRE
            def keyNuevo = "N" + strAnio                            //NUEVO
            def keyTotalActual = "T" + strAnio                      //PRESUPUESTO CODIFICADO

            data.each { v ->
                curCol = iniCol

                Proyecto proyecto = v.proyecto
                Asignacion asignacion = v.asignacion

                def esSubtotal = v.asignacion == null

                Row tableRow = sheet.createRow((short) curRow)
                def tableCell = tableRow.createCell(curCol)

                if (esSubtotal) {

                    tableCell.setCellValue("SUBTOTAL PROYECTO: " + proyecto.nombre)
                    tableCell.setCellStyle(styleSubtotal)
                    curCol += 12

                    sheet.addMergedRegion(new CellRangeAddress(
                            curRow, //first row (0-based)
                            curRow, //last row  (0-based)
                            iniCol, //first column (0-based)
                            iniCol + 11 //last column  (0-based)
                    ))

                    tableCell = tableRow.createCell((short) curCol)
                    tableCell.setCellValue(v.valores[keyArrastre] ?: 0)
                    tableCell.setCellStyle(styleSubtotalNumber)
                    curCol++

                    tableCell = tableRow.createCell((short) curCol)
                    tableCell.setCellValue("")
                    tableCell.setCellStyle(styleSubtotalNumber)
                    curCol++

                    tableCell = tableRow.createCell((short) curCol)
                    tableCell.setCellValue(v.valores[keyNuevo] ?: 0)
                    tableCell.setCellStyle(styleSubtotalNumber)
                    curCol++

                    tableCell = tableRow.createCell((short) curCol)
                    tableCell.setCellValue(v.valores[keyTotalActual] ?: 0)
                    tableCell.setCellStyle(styleSubtotalNumber)
                    curCol++

                    meses.each { mes ->
                        def keyMes = mes.numero + "_" + anio.anio
                        tableCell = tableRow.createCell((short) curCol)
                        tableCell.setCellValue(v.valores[keyMes] ?: 0)
                        tableCell.setCellStyle(styleSubtotalNumber)
                        curCol++
                    }

                    anios.each { a ->
                        tableCell = tableRow.createCell((short) curCol)
                        tableCell.setCellValue(v.valores[a] ?: 0)
                        tableCell.setCellStyle(styleSubtotalNumber)
                        curCol++
                    }

                    tableCell = tableRow.createCell((short) curCol)
                    tableCell.setCellValue(v.valores["T"] ?: 0)
                    tableCell.setCellStyle(styleSubtotalNumber)
                    curCol++
                } else {
                    tableCell.setCellValue(proyecto.codigo)
                    tableCell.setCellStyle(styleTabla)
                    curCol++

                    tableCell = tableRow.createCell(curCol)
                    tableCell.setCellValue(proyecto.nombre)
                    tableCell.setCellStyle(styleTabla)
                    curCol++

                    tableCell = tableRow.createCell(curCol)
                    tableCell.setCellValue(asignacion.marcoLogico.marcoLogico.toStringCompleto())
                    tableCell.setCellStyle(styleTabla)
                    curCol++

                    tableCell = tableRow.createCell(curCol)
                    tableCell.setCellValue(asignacion.presupuesto.numero[0..1])
                    tableCell.setCellStyle(styleTabla)
                    curCol++

                    tableCell = tableRow.createCell(curCol)
                    tableCell.setCellValue(proyecto.codigoEsigef)
                    tableCell.setCellStyle(styleTabla)
                    curCol++

                    tableCell = tableRow.createCell(curCol)
                    tableCell.setCellValue(asignacion.marcoLogico.marcoLogico.numeroComp)
                    tableCell.setCellStyle(styleTabla)
                    curCol++

                    tableCell = tableRow.createCell(curCol)
                    tableCell.setCellValue(asignacion.presupuesto.numero)
                    tableCell.setCellStyle(styleTabla)
                    curCol++

                    tableCell = tableRow.createCell(curCol)
                    tableCell.setCellValue(asignacion.marcoLogico.numero)
                    tableCell.setCellStyle(styleTabla)
                    curCol++

                    tableCell = tableRow.createCell(curCol)
                    tableCell.setCellValue(asignacion.marcoLogico.toStringCompleto())
                    tableCell.setCellStyle(styleTabla)
                    curCol++

                    tableCell = tableRow.createCell(curCol)
                    tableCell.setCellValue(asignacion.marcoLogico.responsable.nombre)
                    tableCell.setCellStyle(styleTabla)
                    curCol++

                    tableCell = tableRow.createCell(curCol)
                    tableCell.setCellValue(asignacion.marcoLogico.fechaInicio)
                    tableCell.setCellStyle(styleDate)
                    curCol++

                    tableCell = tableRow.createCell(curCol)
                    tableCell.setCellValue(asignacion.marcoLogico.fechaFin)
                    tableCell.setCellStyle(styleDate)
                    curCol++

                    tableCell = tableRow.createCell(curCol)
                    tableCell.setCellValue(v.valores[keyArrastre] ?: 0)
                    tableCell.setCellStyle(styleNumber)
                    curCol++

                    tableCell = tableRow.createCell(curCol)
                    tableCell.setCellValue(asignacion.fuente.descripcion)
                    tableCell.setCellStyle(styleTabla)
                    curCol++

                    tableCell = tableRow.createCell(curCol)
                    tableCell.setCellValue(v.valores[keyNuevo] ?: 0)
                    tableCell.setCellStyle(styleNumber)
                    curCol++

                    tableCell = tableRow.createCell(curCol)
                    tableCell.setCellValue(v.valores[keyTotalActual] ?: 0)
                    tableCell.setCellStyle(styleNumber)
                    curCol++

                    meses.each { mes ->
                        def keyMes = mes.numero + "_" + anio.anio

                        tableCell = tableRow.createCell(curCol)
                        tableCell.setCellValue(v.valores[keyMes] ?: 0)
                        tableCell.setCellStyle(styleNumber)
                        curCol++
                    }
                    anios.each { a ->
                        tableCell = tableRow.createCell(curCol)
                        tableCell.setCellValue(v.valores[a] ?: 0)
                        tableCell.setCellStyle(styleNumber)
                        curCol++
                    }

                    tableCell = tableRow.createCell(curCol)
                    tableCell.setCellValue(v.valores["T"] ?: 0)
                    tableCell.setCellStyle(styleNumber)
                    curCol++
                }

                curRow++
            }

            sheet.addMergedRegion(new CellRangeAddress(
                    curRow, //first row (0-based)
                    curRow, //last row  (0-based)
                    iniCol, //first column (0-based)
                    iniCol + 11 //last column  (0-based)
            ))

            curCol = iniCol
            Row totalRow = sheet.createRow((short) curRow)

            Cell cellFooter = totalRow.createCell((short) curCol)
            curCol++
            cellFooter.setCellValue("TOTAL")
            cellFooter.setCellStyle(styleFooterCenter)

            (1..11).each {
                cellFooter = totalRow.createCell((short) curCol)
                curCol++
                cellFooter.setCellValue("")
                cellFooter.setCellStyle(styleFooterCenter)
            }

            cellFooter = totalRow.createCell((short) curCol)
            curCol++
            cellFooter.setCellValue(totales[keyArrastre] ?: 0)
            cellFooter.setCellStyle(styleFooter)

            cellFooter = totalRow.createCell((short) curCol)
            curCol++
            cellFooter.setCellValue("")
            cellFooter.setCellStyle(styleFooterCenter)

            cellFooter = totalRow.createCell((short) curCol)
            curCol++
            cellFooter.setCellValue(totales[keyNuevo] ?: 0)
            cellFooter.setCellStyle(styleFooter)

            cellFooter = totalRow.createCell((short) curCol)
            curCol++
            cellFooter.setCellValue(totales[keyTotalActual] ?: 0)
            cellFooter.setCellStyle(styleFooter)

            meses.each { mes ->
                def keyMes = mes.numero + "_" + anio.anio
                cellFooter = totalRow.createCell((short) curCol)
                curCol++
                cellFooter.setCellValue(totales[keyMes] ?: 0)
                cellFooter.setCellStyle(styleFooter)
            }

            anios.each { a ->
                cellFooter = totalRow.createCell((short) curCol)
                curCol++
                cellFooter.setCellValue(totales[a] ?: 0)
                cellFooter.setCellStyle(styleFooter)
            }

            cellFooter = totalRow.createCell((short) curCol)
            curCol++
            cellFooter.setCellValue(totales["T"] ?: 0)
            cellFooter.setCellStyle(styleFooter)

            def output = response.getOutputStream()
            def header = "attachment; filename=" + "asignaciones_proyecto_${anio.anio}.xlsx"
            response.setContentType("application/application/vnd.openxmlformats-officedocument.spreadsheetml.sheet")
            response.setHeader("Content-Disposition", header)
            wb.write(output)
            output.flush()
        } catch (Exception ex) {
            ex.printStackTrace();
        }

    }

    /**
     * todo: para hacer un reporte con columnas dinámicas por año se debe usar un mapa con "nombre columna": valor
     * de esta forma se puede tener la clumna "2016" y el valor priorizado correspondiente, pero
     * para cada año se debería tener: "priorizado 2016", "avalado 2016" y "disponible 2016",
     * !!!!!!! mejor tener un reporte para cada año !!!!!!!!!
     */
    def disponibilidadFuente_funcion(Fuente fuente) {
        def cn = dbConnectionService.getConnection()
        def cn1 = dbConnectionService.getConnection()
        def sql = "select distinct anio.anio__id, anioanio from anio, asgn where anio.anio__id = asgn.anio__id " +
              "order by anioanio"
        def txto = ""
        def tx = ""
        def anios = []
        def datos = []
        def asignado = 0.0
        def avalado = 0.0
        def liberado = 0.0
        def totalDisp = 0.0
        def sumaPrio = 0.0
        def sumaAval = 0.0
        def sumaDisp = 0.0

        cn.eachRow(sql.toString()){
            anios.add(id: it.anio__id, anio: it.anioanio)
        }
        def todosLosAnios = anios.clone()
        println "anios: $anios"
        def actual = anios.remove(0)
        sql = "select asgn__id, asgn.prsp__id, asgn.mrlg__id, substr(prspnmro,1,2) prsp, mrlgnmro, mrlgobjt, unejnmbr, asgnprio " +
                "from asgn, prsp, mrlg, unej " +
                "where prsp.prsp__id = asgn.prsp__id and mrlg.mrlg__id = asgn.mrlg__id and " +
                "unej.unej__id = asgn.unej__id and anio__id = ${actual.id} and fnte__id = ${fuente.id} " + //and asgn.prsp__id between 338 and 339 " //and asgn.mrlg__id between 502 and 550 " +
                "order by prspnmro"
//        println "------- $sql"
        cn.eachRow(sql.toString()) {
            /** calculo de lo avalado y recursos disponibles */
//            tx = "select sum(poasmnto) suma from poas, aval where aval.prco__id = poas.prco__id and " +
//                    "asgn__id = ${it.asgn__id} and edav__id = 89"
//            println "....... $tx"
            avalado = cn1.rows("select sum(poasmnto) suma from poas, aval where aval.prco__id = poas.prco__id and " +
                    "asgn__id = ${it.asgn__id} and edav__id = 89".toString())[0].suma ?: 0
            liberado = cn1.rows("select sum(poaslbrd) suma from poas, aval where aval.prco__id = poas.prco__id and " +
                    "asgn__id = ${it.asgn__id} and edav__id = 92".toString())[0].suma ?: 0

            datos.add(id: it.asgn__id, prsp__id: it.prsp__id, mrlg__id: it.mrlg__id, prsp: it.prsp, nmro: it.mrlgnmro,
                    actv: it.mrlgobjt, unej: it.unejnmbr,
                    anios: [[anio: actual.anio, prio:it.asgnprio, avalado: avalado + liberado]])
            totalDisp += it.asgnprio - avalado - liberado
            sumaPrio += it.asgnprio
            sumaAval += avalado + liberado
            sumaDisp += it.asgnprio - avalado + liberado
        }

//        println "datos: $datos"

        todosLosAnios.find { it.id == actual.id}["prio"] = sumaPrio
        todosLosAnios.find { it.id == actual.id}["aval"] = sumaAval
        todosLosAnios.find { it.id == actual.id}["disp"] = sumaDisp

        println "con sumatorias: $todosLosAnios"

        /** para los años restantes obtiene priorizado y valores de aval y leberado  --> añade a datos**/
        sumaPrio = 0.0
        sumaAval = 0.0
        sumaDisp = 0.0
        if(anios.size() > 0) {
            anios.each {anio ->
//                println "porcesa año: ${anio.id}"
                datos.each { d ->
                    asignado = 0
                    avalado = 0
                    liberado = 0
                    def cont = 0
                    txto = "select asgn__id, asgnprio from asgn where prsp__id = ${d.prsp__id} and " +
                            "mrlg__id = ${d.mrlg__id} and anio__id = ${anio.id} and fnte__id = ${fuente.id}"

                    cn1.eachRow(txto.toString()) { a ->
                        asignado = a?.asgnprio?:0
                        cont++
                        if(asignado > 0) {
//                            println "asgn: ${d.id} .. $txto"
                            avalado = cn1.rows("select sum(poasmnto) suma from poas, aval where aval.prco__id = poas.prco__id and " +
                                    "asgn__id = ${a.asgn__id} and edav__id = 89".toString())[0].suma ?: 0
                            liberado = cn1.rows("select sum(poaslbrd) suma from poas, aval where aval.prco__id = poas.prco__id and " +
                                    "asgn__id = ${a.asgn__id} and edav__id = 92".toString())[0].suma ?: 0
                        }
                        if(cont > 1) println "procesa varios: ${d.prsp__id} con ${d.mrlg__id}"
                    }

                    d.anios.add([anio: anio.anio, prio: asignado, avalado: avalado + liberado])    //añade a datos

                    totalDisp += asignado - avalado - liberado
                    sumaPrio += asignado
                    sumaAval += avalado + liberado
                    sumaDisp += asignado - avalado + liberado
                }
                todosLosAnios.find { it.id == anio.id}["prio"] = sumaPrio
                todosLosAnios.find { it.id == anio.id}["aval"] = sumaAval
                todosLosAnios.find { it.id == anio.id}["disp"] = sumaDisp
            }
        }

        println "--datos: ${todosLosAnios}"
        println "--TOtal: ${totalDisp}"


//        println "todos los anios: $todosLosAnios"
//        return [data: data, totales: totales]
        return [data: datos, totales: totalDisp, anios: todosLosAnios]
    }


    def disponibilidadPermanente(Fuente fuente) {
        def data = [:]
        def totales = [:]
        totales.priorizado = 0
        totales.avales = 0
        totales.disponible = 0
        def partidas = Presupuesto.findAllByNumeroLike('%0000', [sort: 'numero'])

        def estadoAprobado = EstadoAval.findByCodigo("E02")

        partidas.each { partida ->
            def numero = partida.numero?.replaceAll("0", "")
            def asignaciones = Asignacion.withCriteria {
                presupuesto {
                    like("numero", numero + "%")
                }
                if (fuente) {
                    eq("fuente", fuente)
                }
                eq("marcoLogico", null)
            }
            asignaciones.each { asg ->
                def actividad = asg.marcoLogico

                def key = numero + "_" + actividad?.id

                if (!data[key]) {
                    data[key] = [:]
                    data[key].partida = partida
                    data[key].actividad = actividad
                    data[key].valores = [:]
                    data[key].valores.priorizado = 0
                    data[key].valores.avales = 0
                    data[key].valores.disponible = 0
                }
                data[key].valores.priorizado += asg.priorizado
                totales.priorizado += asg.priorizado

                def procs = ProcesoAsignacion.findAllByAsignacion(asg).proceso
                def avales = []
                def av = 0
                if (procs.size() > 0) {
                    avales = Aval.withCriteria {
                        inList("proceso", procs)
                        eq("estado", estadoAprobado)
                    }
                    if (avales.size() > 0) {
                        av = avales.sum { it.monto }
                    }
                }
                data[key].valores.avales += av
                totales.avales += av

                def dis = asg.priorizado - av

                data[key].valores.disponible += dis
                totales.disponible += dis
            }
        }
        return [data: data, totales: totales]
    }







    def aprobarProyecto_funcion(Anio anio) {

        def strAnio = anio.anio

        def keyArrastre = "" + (strAnio.toInteger() - 1)        //ARRASTRE
        def keyNuevo = "N" + strAnio                            //NUEVO
        def keyTotalActual = "T" + strAnio                      //PRESUPUESTO CODIFICADO
        def keyActual = strAnio                                 //TOTAL
        def keyTotal = "T"

        def data = []
        def anios = []
        anios += keyActual
        def meses = Mes.list([sort: "numero"])
        def proyectos = Proyecto.list([sort: "codigo"])

        def totales = [:]
        totales[keyArrastre] = 0
        totales[keyNuevo] = 0
        totales[keyTotalActual] = 0
        totales[keyActual] = 0
        totales[keyTotal] = 0

        proyectos.each { proy ->
            def totalesProyecto = [:]
            totalesProyecto[keyArrastre] = 0
            totalesProyecto[keyNuevo] = 0
            totalesProyecto[keyTotalActual] = 0
            totalesProyecto[keyActual] = 0
            totalesProyecto[keyTotal] = 0

            def actividades = MarcoLogico.findAllByProyecto(proy)
            def asignaciones = []
            if (actividades.size() > 0) {
                asignaciones = Asignacion.withCriteria {
                    inList("marcoLogico", actividades)
                }
            }
            asignaciones.each { asg ->
                def m = [:]
                m.proyecto = proy
                m.asignacion = asg
                m.valores = [:]
                m.valores[keyArrastre] = 0
                m.valores[keyNuevo] = 0
                m.valores[keyTotalActual] = 0
                m.valores[keyActual] = 0
                m.valores[keyTotal] = 0
                def anioAsg = asg.anio
                if (anioAsg.id == anio.id) {
                    meses.each { mes ->
                        def keyMes = mes.numero + "_" + anio.anio
                        def programacion = ProgramacionAsignacion.findAllByAsignacionAndMes(asg, mes)
                        if (!m.valores[keyMes]) {
                            m.valores[keyMes] = 0
                        }
                        if (!totales[keyMes]) {
                            totales[keyMes] = 0
                        }
                        if (!totalesProyecto[keyMes]) {
                            totalesProyecto[keyMes] = 0
                        }
                        def v = 0
                        if (programacion.size() == 1) {
                            v = programacion.first().valor
                        } else if (programacion.size() > 1) {
                            v = programacion.first().valor
                            println "existe ${programacion.size()} programaciones para asignacion ${asg.id} mes ${mes.id} (${mes.descripcion}):" +
                                    " ${programacion.id}, se utilizo ${programacion.first().id}"
                        }
                        m.valores[keyMes] += v
                        m.valores[keyActual] += v

                        totales[keyMes] += v
                        totalesProyecto[keyMes] += v

                        totales[keyActual] += v
                        totalesProyecto[keyActual] += v
                    }

                    m.valores[keyTotal] += asg.planificado

                    totales[keyTotal] += asg.planificado
                    totalesProyecto[keyTotal] += asg.planificado

                    if (asg.fuente.codigo == "998") {
                        m.valores[keyArrastre] += asg.planificado
                        totales[keyArrastre] += asg.planificado
                        totalesProyecto[keyArrastre] += asg.planificado

                        m.valores[keyTotalActual] += asg.planificado
                        totales[keyTotalActual] += asg.planificado
                        totalesProyecto[keyTotalActual] += asg.planificado
                    } else {
                        m.valores[keyNuevo] += asg.planificado
                        totales[keyNuevo] += asg.planificado
                        totalesProyecto[keyNuevo] += asg.planificado

                        m.valores[keyTotalActual] += asg.planificado
                        totales[keyTotalActual] += asg.planificado
                        totalesProyecto[keyTotalActual] += asg.planificado
                    }
                } else {
                    m.valores[keyTotal] += asg.planificado
                    totales[keyTotal] += asg.planificado
                    totalesProyecto[keyTotal] += asg.planificado
                    if (!m.valores[anioAsg.anio]) {
                        m.valores[anioAsg.anio] = 0
                        if (!anios.contains(anioAsg.anio)) {
                            anios += anioAsg.anio
                            totales[anioAsg.anio] = 0
                        }
                        if (!totalesProyecto[anioAsg.anio]) {
                            totalesProyecto[anioAsg.anio] = 0
                        }
                    }

                    m.valores[anioAsg.anio] += asg.planificado
                    totales[anioAsg.anio] += asg.planificado
                    totalesProyecto[anioAsg.anio] += asg.planificado
                }
                if (m.valores[keyTotal] > 0) {
                    data += m
                }
            }
            /* ****** subtotal proyecto ****** */
            def m = [:]
            m.proyecto = proy
            m.asignacion = null
            m.valores = [:]
            m.valores[keyArrastre] = totalesProyecto[keyArrastre]
            m.valores[keyNuevo] = totalesProyecto[keyNuevo]
            m.valores[keyTotalActual] = totalesProyecto[keyTotalActual]
            m.valores[keyActual] = totalesProyecto[keyActual]
            m.valores[keyTotal] = totalesProyecto[keyTotal]

            meses.each { mes ->
                def keyMes = mes.numero + "_" + anio.anio
                m.valores[keyMes] = totalesProyecto[keyMes]
            }

            anios.each { a ->
                m.valores[a] = totalesProyecto[a]
            }
            if (m.valores[keyTotal] > 0) {
                data += m
            }
        }
        anios = anios.sort()
        return [anio: anio, data: data, anios: anios, meses: meses, totales: totales]
    }


    def reporteAvalesPermanentesExcel() {

        println("params excel: " + params)


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


        def iniRow = 0
        def iniCol = 1

        def curRow = iniRow
        def curCol = iniCol

        try {

            Workbook wb = new Workbook()
            Sheet sheet = wb.createSheet("Reporte de Avales Permanentes")

            def estilos = ReportesNuevosExcelController.getEstilos(wb)
            CellStyle styleHeader = estilos.styleHeader
            CellStyle styleTabla = estilos.styleTabla
            CellStyle styleFooter = estilos.styleFooter
            CellStyle styleFooterCenter = estilos.styleFooterCenter
            CellStyle styleNumber = estilos.styleNumber
            CellStyle styleDate = estilos.styleDate


            def titulo = "REPORTE DE AVALES PERMANENTES"
            def subtitulo = ""
            curRow = ReportesNuevosExcelController.setTitulos(sheet, estilos, iniRow, iniCol, titulo, subtitulo)

            Row rowHeader = sheet.createRow((short) curRow)
            curRow++
            Cell cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("RESPONSABLE")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 10000)
            curCol++

            cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("OBJETIVO")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 12000)
            curCol++

            cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("MACRO ACTIVIDAD")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 8000)
            curCol++

            cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("ACTIVIDAD")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 10000)
            curCol++

            cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("TAREA")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 8000)
            curCol++

            cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("#")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 3000)
            curCol++

            cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("PARTIDA")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 8000)
            curCol++

            cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("FUENTE")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 2000)
            curCol++

            cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("PRESUPUESTO")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 5000)
            curCol++

            def totalCols = curCol
            ReportesNuevosExcelController.joinTitulos(sheet, iniRow, iniCol, totalCols, false)
            def totalPriorizado = 0

            asignaciones.each{ d ->

                curCol = iniCol
                Row tableRow = sheet.createRow((short) curRow)
                Cell cellTabla = tableRow.createCell((short) curCol)

                cellTabla = tableRow.createCell((short) curCol)
                cellTabla.setCellValue(d?.unidad?.nombre)
                cellTabla.setCellStyle(styleTabla)
                curCol++
                cellTabla = tableRow.createCell((short) curCol)
                cellTabla.setCellValue(d?.tarea?.actividad?.macroActividad?.objetivoGastoCorriente?.descripcion)
                cellTabla.setCellStyle(styleTabla)
                curCol++
                cellTabla = tableRow.createCell((short) curCol)
                cellTabla.setCellValue(d?.tarea?.actividad?.macroActividad?.descripcion)
                cellTabla.setCellStyle(styleDate)
                curCol++
                cellTabla = tableRow.createCell((short) curCol)
                cellTabla.setCellValue(d?.tarea?.actividad?.descripcion)
                cellTabla.setCellStyle(styleTabla)
                curCol++
                cellTabla = tableRow.createCell((short) curCol)
                cellTabla.setCellValue(d?.tarea?.descripcion)
                cellTabla.setCellStyle(styleTabla)
                curCol++
                cellTabla = tableRow.createCell((short) curCol)
                cellTabla.setCellValue(d?.presupuesto?.numero)
                cellTabla.setCellStyle(styleNumber)
                curCol++
                cellTabla = tableRow.createCell((short) curCol)
                cellTabla.setCellValue(d?.presupuesto?.descripcion)
                cellTabla.setCellStyle(styleTabla)
                curCol++
                cellTabla = tableRow.createCell((short) curCol)
                cellTabla.setCellValue(d?.fuente?.codigo)
                cellTabla.setCellStyle(styleTabla)
                curCol++
                cellTabla = tableRow.createCell((short) curCol)
                cellTabla.setCellValue(d?.planificado)
                cellTabla.setCellStyle(styleNumber)
                curCol++

                curRow++

            }

            sheet.addMergedRegion(new CellRangeAddress(
                    curRow, //first row (0-based)
                    curRow, //last row  (0-based)
                    iniCol, //first column (0-based)
                    iniCol + 3 //last column  (0-based)
            ))

            def output = response.getOutputStream()
            def header = "attachment; filename=" + "reporte_avales_perma.xlsx"
            response.setContentType("application/application/vnd.openxmlformats-officedocument.spreadsheetml.sheet")
            response.setHeader("Content-Disposition", header)
            wb.write(output)
            output.flush()

        } catch (Exception ex) {
            ex.printStackTrace();
        }

    }

    def reportePriorizacion() {

//        println("params prio: " + params)

        def proyecto = Proyecto.get(params.id)

        def cn = dbConnectionService.getConnection()

        def sql = "select cm.mrlgnmcm, cm.mrlgobjt componente, ac.mrlgnmro num, ac.mrlgobjt actividad,prspnmro, asgnplan, fnte.fntecdgo, fntedscr " +
                "from mrlg cm, mrlg ac, asgn, c_fnte fnte, prsp " +
                "where cm.proy__id = ${proyecto.id} and ac.mrlgpdre = cm.mrlg__id and " +
                "cm.tpel__id = 2 and ac.tpel__id = 3 and" +
                " asgn.mrlg__id = ac.mrlg__id and" +
                " fnte.fnte__id = asgn.fnte__id and prsp.prsp__id = asgn.prsp__id" +
                " order by cm.mrlgnmcm, ac.mrlgnmro"
//        println("sql " + sql)

        def iniRow = 0
        def iniCol = 1

        def curRow = iniRow
        def curRow2 = iniRow + 1
        def curCol = iniCol

        try {

            Workbook wb = new Workbook()
            Sheet sheet = wb.createSheet("asignaciones")

            def estilos = ReportesNuevosExcelController.getEstilos(wb)
            CellStyle styleHeader = estilos.styleHeader
            CellStyle styleTabla = estilos.styleTabla
            CellStyle styleFooter = estilos.styleFooter
            CellStyle styleFooterCenter = estilos.styleFooterCenter
            CellStyle styleNumber = estilos.styleNumber
            CellStyle styleDate = estilos.styleDate


            def titulo = "REPORTE DE ASIGNACIONES POR ACTIVIDADES Y FUENTE DE FINANCIAMIENTO"
            def subtitulo = "PROYECTO: " + proyecto.nombre.toUpperCase()

            curRow = ReportesNuevosExcelController.setTitulos(sheet, estilos, iniRow, iniCol, titulo, subtitulo)
            Row rowHeader = sheet.createRow((short) curRow)
            curRow++

            Cell cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("COMPONENTE")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 6000)
            curCol++

            cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("#")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 2000)
            curCol++

            cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("ACTIVIDAD")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 16000)
            curCol++

            cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("PARTIDA")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 2500)
            curCol++

            cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("PLANIFICADO")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 5000)
            curCol++

            cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("001 RECURSOS FISCALES")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 5000)
            curCol++

            cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("998 ANTICIPO DE EJERCICIOS ANTERIORES")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 5000)
            curCol++

            cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("701 CANJE DE DEUDA")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 5000)
            curCol++

            cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("002 AUTOGESTIÓN")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 5000)
            curCol++


            def totalCols = curCol
            ReportesNuevosExcelController.joinTitulos(sheet, iniRow, iniCol, totalCols, true)
            def totalPriorizado = 0
            def total1 = 0
            def total2 = 0
            def total3 = 0
            def total4 = 0


            cn.eachRow(sql.toString()) { d ->

                curCol = iniCol
                Row tableRow = sheet.createRow((short) curRow)
                Cell cellTabla = tableRow.createCell((short) curCol)

                cellTabla = tableRow.createCell((short) curCol)
                cellTabla.setCellValue(d?.componente)
                cellTabla.setCellStyle(styleTabla)
                curCol++
                cellTabla = tableRow.createCell((short) curCol)
                cellTabla.setCellValue(d?.num)
                cellTabla.setCellStyle(styleTabla)
                curCol++
                cellTabla = tableRow.createCell((short) curCol)
                cellTabla.setCellValue(d?.actividad)
                cellTabla.setCellStyle(styleTabla)
                curCol++
                cellTabla = tableRow.createCell((short) curCol)
                cellTabla.setCellValue(d?.prspnmro)
                cellTabla.setCellStyle(styleTabla)
                curCol++
                cellTabla = tableRow.createCell((short) curCol)
                cellTabla.setCellValue(d?.asgnplan)
                cellTabla.setCellStyle(styleNumber)
                totalPriorizado += d?.asgnplan
                curCol++

                if(d?.fntecdgo == '001'){
                    cellTabla = tableRow.createCell((short) curCol)
                    cellTabla.setCellValue(d?.asgnplan)
                    cellTabla.setCellStyle(styleNumber)
                    total1 += d?.asgnplan
                    curCol++
                    cellTabla = tableRow.createCell((short) curCol)
                    cellTabla.setCellValue("")
                    cellTabla.setCellStyle(styleNumber)
                    curCol++
                    cellTabla = tableRow.createCell((short) curCol)
                    cellTabla.setCellValue("")
                    cellTabla.setCellStyle(styleNumber)
                    curCol++
                    cellTabla = tableRow.createCell((short) curCol)
                    cellTabla.setCellValue("")
                    cellTabla.setCellStyle(styleNumber)
                    curCol++
                }else{
                    if(d?.fntecdgo == '998'){
                        cellTabla = tableRow.createCell((short) curCol)
                        cellTabla.setCellValue("")
                        cellTabla.setCellStyle(styleNumber)
                        curCol++
                        cellTabla = tableRow.createCell((short) curCol)
                        cellTabla.setCellValue(d?.asgnplan)
                        cellTabla.setCellStyle(styleNumber)
                        total2 += d?.asgnplan
                        curCol++
                        cellTabla = tableRow.createCell((short) curCol)
                        cellTabla.setCellValue("")
                        cellTabla.setCellStyle(styleNumber)
                        curCol++
                        cellTabla = tableRow.createCell((short) curCol)
                        cellTabla.setCellValue("")
                        cellTabla.setCellStyle(styleNumber)
                        curCol++
                    }else{
                        if(d?.fntecdgo == '701'){
                            cellTabla = tableRow.createCell((short) curCol)
                            cellTabla.setCellValue("")
                            cellTabla.setCellStyle(styleNumber)
                            curCol++
                            cellTabla = tableRow.createCell((short) curCol)
                            cellTabla.setCellValue("")
                            cellTabla.setCellStyle(styleNumber)
                            curCol++
                            cellTabla = tableRow.createCell((short) curCol)
                            cellTabla.setCellValue(d?.asgnplan)
                            cellTabla.setCellStyle(styleNumber)
                            total3 += d?.asgnplan
                            curCol++
                            cellTabla = tableRow.createCell((short) curCol)
                            cellTabla.setCellValue("")
                            cellTabla.setCellStyle(styleNumber)
                            curCol++
                        }else{
                            if(d?.fntecdgo == '002'){
                                cellTabla = tableRow.createCell((short) curCol)
                                cellTabla.setCellValue("")
                                cellTabla.setCellStyle(styleNumber)
                                curCol++
                                cellTabla = tableRow.createCell((short) curCol)
                                cellTabla.setCellValue("")
                                cellTabla.setCellStyle(styleNumber)
                                curCol++
                                cellTabla = tableRow.createCell((short) curCol)
                                cellTabla.setCellValue("")
                                cellTabla.setCellStyle(styleNumber)
                                curCol++
                                cellTabla = tableRow.createCell((short) curCol)
                                cellTabla.setCellValue(d?.asgnplan)
                                cellTabla.setCellStyle(styleNumber)
                                total4 += d?.asgnplan
                                curCol++
                            }
                        }
                    }
                }

                curRow++

            }

            cn.close()

            curCol = iniCol
            Row totalRow = sheet.createRow((short) curRow)
            Cell cellFooter = totalRow.createCell((short) curCol)
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
            cellFooter.setCellValue("")
            cellFooter.setCellStyle(styleFooterCenter)

            cellFooter = totalRow.createCell((short) curCol)
            curCol++
            cellFooter.setCellValue(totalPriorizado)
            cellFooter.setCellStyle(styleFooter)

            cellFooter = totalRow.createCell((short) curCol)
            curCol++
            cellFooter.setCellValue(total1)
            cellFooter.setCellStyle(styleFooter)

            cellFooter = totalRow.createCell((short) curCol)
            curCol++
            cellFooter.setCellValue(total2)
            cellFooter.setCellStyle(styleFooter)


            cellFooter = totalRow.createCell((short) curCol)
            curCol++
            cellFooter.setCellValue(total3)
            cellFooter.setCellStyle(styleFooter)


            cellFooter = totalRow.createCell((short) curCol)
            curCol++
            cellFooter.setCellValue(total4)
            cellFooter.setCellStyle(styleFooter)


            sheet.addMergedRegion(new CellRangeAddress(
                    curRow, //first row (0-based)
                    curRow, //last row  (0-based)
                    iniCol, //first column (0-based)
                    iniCol + 3 //last column  (0-based)
            ))

            def output = response.getOutputStream()
            def header = "attachment; filename=" + "reporte_avales_perma.xlsx"
            response.setContentType("application/application/vnd.openxmlformats-officedocument.spreadsheetml.sheet")
            response.setHeader("Content-Disposition", header)
            wb.write(output)
            output.flush()

        } catch (Exception ex) {
            ex.printStackTrace();
        }

    }


    def reporteUsuariosPerfiles () {

        def unidades = UnidadEjecutora.findAllByPadreIsNotNull([sort:"nombre",order:"desc"])

        def usuarios = Persona.findAllByUnidadInList(unidades)

        def sesiones = Sesn.findAllByUsuarioInList(usuarios, [sort: "usuario.unidad.nombre",order: "asc"])

//        return [sesiones: sesiones]

        //        println("params prio: " + params)


        def iniRow = 0
        def iniCol = 1

        def curRow = iniRow
        def curCol = iniCol

        try {

            Workbook wb = new Workbook()
            Sheet sheet = wb.createSheet("usuarios")

            def estilos = ReportesNuevosExcelController.getEstilos(wb)
            CellStyle styleHeader = estilos.styleHeader
            CellStyle styleTabla = estilos.styleTabla
            CellStyle styleFooter = estilos.styleFooter
            CellStyle styleFooterCenter = estilos.styleFooterCenter
            CellStyle styleNumber = estilos.styleNumber
            CellStyle styleDate = estilos.styleDate


            def titulo = "REPORTE DE USUARIOS Y PERFILES"
            def subtitulo = ""

            curRow = ReportesNuevosExcelController.setTitulos(sheet, estilos, iniRow, iniCol, titulo, subtitulo)
            Row rowHeader = sheet.createRow((short) curRow)
            curRow++

            Cell cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("N°")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 2000)
            curCol++

            cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("NOMBRE")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 10000)
            curCol++

            cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("USUARIO")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 3000)
            curCol++

            cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("ÁREA DE GESTIÓN")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 16000)
            curCol++

            cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("CARGO")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 10000)
            curCol++

            cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("PERFIL")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 8000)
            curCol++

            cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("ACTIVO")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 4000)
            curCol++


            def totalCols = curCol
            ReportesNuevosExcelController.joinTitulos(sheet, iniRow, iniCol, totalCols, false)
            def totalPriorizado = 0
            def total1 = 0
            def total2 = 0
            def total3 = 0
            def total4 = 0
            def ordinal = 1


           sesiones.each { d ->

                curCol = iniCol
                Row tableRow = sheet.createRow((short) curRow)
                Cell cellTabla = tableRow.createCell((short) curCol)

                cellTabla = tableRow.createCell((short) curCol)
                cellTabla.setCellValue(ordinal++)
                cellTabla.setCellStyle(styleTabla)
                curCol++
                cellTabla = tableRow.createCell((short) curCol)
                cellTabla.setCellValue(d?.usuario?.nombre + " " + d?.usuario?.apellido)
                cellTabla.setCellStyle(styleTabla)
                curCol++
               cellTabla = tableRow.createCell((short) curCol)
               cellTabla.setCellValue(d?.usuario?.login)
               cellTabla.setCellStyle(styleTabla)
               curCol++
                cellTabla = tableRow.createCell((short) curCol)
                cellTabla.setCellValue(d?.usuario?.unidad?.nombre)
                cellTabla.setCellStyle(styleTabla)
                curCol++
                cellTabla = tableRow.createCell((short) curCol)
                cellTabla.setCellValue(d?.usuario?.cargo)
                cellTabla.setCellStyle(styleTabla)
                curCol++
                cellTabla = tableRow.createCell((short) curCol)
                cellTabla.setCellValue(d?.perfil?.nombre)
                cellTabla.setCellStyle(styleTabla)
                curCol++
               if(d?.usuario?.estaActivo == 1){
                   cellTabla = tableRow.createCell((short) curCol)
                   cellTabla.setCellValue("SI")
                   cellTabla.setCellStyle(styleTabla)
                   curCol++
               }else{
                   cellTabla = tableRow.createCell((short) curCol)
                   cellTabla.setCellValue("NO")
                   cellTabla.setCellStyle(styleTabla)
                   curCol++
               }
                curRow++
            }

            sheet.addMergedRegion(new CellRangeAddress(
                    curRow, //first row (0-based)
                    curRow, //last row  (0-based)
                    iniCol, //first column (0-based)
                    iniCol + 3 //last column  (0-based)
            ))

            def output = response.getOutputStream()
            def header = "attachment; filename=" + "reporte_usuarios_perfiles.xlsx"
            response.setContentType("application/application/vnd.openxmlformats-officedocument.spreadsheetml.sheet")
            response.setHeader("Content-Disposition", header)
            wb.write(output)
            output.flush()

        } catch (Exception ex) {
            ex.printStackTrace();
        }

    }


    def reporteCompletoPermanente () {

//        println("params excel: " + params)

        def anio = Anio.get(params.anio)
        def asignaciones = []
        def unidad = UnidadEjecutora.get(params.unidad)

        def objetivo = ObjetivoGastoCorriente.get(params.objetivo)
        def macros = MacroActividad.findAllByObjetivoGastoCorriente(objetivo)
        def actividades = ActividadCorriente.findAllByMacroActividadInList(macros)
        def tareas = Tarea.findAllByActividadInList(actividades)

        asignaciones = Asignacion.findAllByAnioAndTareaIsNotNull(anio, [sort: 'unidad', order: 'unidad'])

        //programacion

        def actual
        if (params.anio) {
            actual = Anio.get(params.anio)
        } else {
            actual = Anio.findByAnio(new Date().format("yyyy"))
        }
        if (!actual) {
            actual = Anio.list([sort: 'anio', order: 'desc']).pop()
        }

        def asgProy = Asignacion.findAll("from Asignacion where unidad=${unidad.id} and marcoLogico is not null and anio=${actual.id} order by id")
        def asgCor = Asignacion.findAll("from Asignacion where actividad is not null and anio=${actual.id} and marcoLogico is null order by id")
        def max = PresupuestoUnidad.findByUnidadAndAnio(unidad,actual)

        def meses = Mes.list([sort: 'numero', order: 'asc'])

        def iniRow = 0
        def iniCol = 1

        def curRow = iniRow
        def curCol = iniCol

        try {

            Workbook wb = new Workbook()
            Sheet sheet = wb.createSheet("Planificación Operativa Anual")

            def estilos = ReportesNuevosExcelController.getEstilos(wb)
            CellStyle styleHeader = estilos.styleHeader
            CellStyle styleTabla = estilos.styleTabla
            CellStyle styleFooter = estilos.styleFooter
            CellStyle styleFooterCenter = estilos.styleFooterCenter
            CellStyle styleNumber = estilos.styleNumber
            CellStyle styleDate = estilos.styleDate

            def titulo = "PLANIFICACIÓN OPERATIVA ANUAL - ${anio?.anio}"
            def subtitulo = ""
            curRow = ReportesNuevosExcelController.setTitulos(sheet, estilos, iniRow, iniCol, titulo, subtitulo)

            Row rowHeader = sheet.createRow((short) curRow)
            curRow++
            Cell cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("RESPONSABLE")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 10000)
            curCol++

            cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("OBJETIVO")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 12000)
            curCol++

            cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("MACRO ACTIVIDAD")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 8000)
            curCol++

            cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("ACTIVIDAD")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 10000)
            curCol++

            cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("TAREA")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 8000)
            curCol++

            cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("#")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 3000)
            curCol++

            cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("PARTIDA")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 8000)
            curCol++

            cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("FUENTE")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 2000)
            curCol++

            cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("PRESUPUESTO")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 5000)
            curCol++

            cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("ENERO")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 4000)
            curCol++

            cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("FEBRERO")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 4000)
            curCol++

            cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("MARZO")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 4000)
            curCol++

            cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("ABRIL")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 4000)
            curCol++

            cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("MAYO")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 4000)
            curCol++

            cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("JUNIO")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 4000)
            curCol++

            cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("JULIO")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 4000)
            curCol++

            cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("AGOSTO")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 4000)
            curCol++

            cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("SEPTIEMBRE")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 4000)
            curCol++

            cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("OCTUBRE")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 4000)
            curCol++

            cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("NOVIEMBRE")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 4000)
            curCol++

            cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("DICIEMBRE")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 4000)
            curCol++


            def totalCols = curCol
            ReportesNuevosExcelController.joinTitulos(sheet, iniRow, iniCol, totalCols, false)
            def totalPriorizado = 0

            asignaciones.each{ d ->

                curCol = iniCol
                Row tableRow = sheet.createRow((short) curRow)
                Cell cellTabla = tableRow.createCell((short) curCol)

                cellTabla = tableRow.createCell((short) curCol)
                cellTabla.setCellValue(d?.unidad?.nombre)
                cellTabla.setCellStyle(styleTabla)
                curCol++
                cellTabla = tableRow.createCell((short) curCol)
                cellTabla.setCellValue(d?.tarea?.actividad?.macroActividad?.objetivoGastoCorriente?.descripcion)
                cellTabla.setCellStyle(styleTabla)
                curCol++
                cellTabla = tableRow.createCell((short) curCol)
                cellTabla.setCellValue(d?.tarea?.actividad?.macroActividad?.descripcion)
                cellTabla.setCellStyle(styleDate)
                curCol++
                cellTabla = tableRow.createCell((short) curCol)
                cellTabla.setCellValue(d?.tarea?.actividad?.descripcion)
                cellTabla.setCellStyle(styleTabla)
                curCol++
                cellTabla = tableRow.createCell((short) curCol)
                cellTabla.setCellValue(d?.tarea?.descripcion)
                cellTabla.setCellStyle(styleTabla)
                curCol++
                cellTabla = tableRow.createCell((short) curCol)
                cellTabla.setCellValue(d?.presupuesto?.numero)
                cellTabla.setCellStyle(styleNumber)
                curCol++
                cellTabla = tableRow.createCell((short) curCol)
                cellTabla.setCellValue(d?.presupuesto?.descripcion)
                cellTabla.setCellStyle(styleTabla)
                curCol++
                cellTabla = tableRow.createCell((short) curCol)
                cellTabla.setCellValue(d?.fuente?.codigo)
                cellTabla.setCellStyle(styleTabla)
                curCol++
                cellTabla = tableRow.createCell((short) curCol)
                cellTabla.setCellValue(d?.planificado)
                cellTabla.setCellStyle(styleNumber)
                curCol++

                meses.each {
                    cellTabla = tableRow.createCell((short) curCol)
                    cellTabla.setCellValue(ProgramacionAsignacion.findAll("from ProgramacionAsignacion where asignacion = ${d?.id} and mes = ${it.id} and padre is null")?.valor?.pop())
                    cellTabla.setCellStyle(styleNumber)
                    curCol++
                }
                curRow++
            }

            sheet.addMergedRegion(new CellRangeAddress(
                    curRow, //first row (0-based)
                    curRow, //last row  (0-based)
                    iniCol, //first column (0-based)
                    iniCol + 3 //last column  (0-based)
            ))

            def output = response.getOutputStream()
            def header = "attachment; filename=" + "reporte_poa_completo.xlsx"
            response.setContentType("application/application/vnd.openxmlformats-officedocument.spreadsheetml.sheet")
            response.setHeader("Content-Disposition", header)
            wb.write(output)
            output.flush()

        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }


    def reporteDisponibilidadPermanente () {


        def anio = Anio.findByAnio(new Date().format("yyyy"))
        def macro = MacroActividad.list()
        def actividades = ActividadCorriente.findAllByAnioAndMacroActividadInList(anio, macro)
        def tareas = Tarea.findAllByActividadInList(actividades)
        def asignaciones = Asignacion.findAllByTareaInList(tareas)

//        println("asignaciones " + asignaciones)


        def iniRow = 0
        def iniCol = 1

        def curRow = iniRow
        def curCol = iniCol

        try {
            Workbook wb = new Workbook()
            Sheet sheet = wb.createSheet("Disponibilidad de recursos permanentes")
            // Create a new font and alter it.
            def estilos = ReportesNuevosExcelController.getEstilos(wb)
            CellStyle styleHeader = estilos.styleHeader
            CellStyle styleTabla = estilos.styleTabla
            CellStyle styleNumber = estilos.styleNumber
            CellStyle styleFooter = estilos.styleFooter
            CellStyle styleFooterCenter = estilos.styleFooterCenter

            // Create a row and put some cells in it. Rows are 0 based.
            def titulo = "DISPONIBILIDAD DE RECURSOS PERMANENTES - AÑO " + anio
            def subtitulo = "TODAS LAS FUENTES - EN DÓLARES"
            curRow = ReportesNuevosExcelController.setTitulos(sheet, estilos, iniRow, iniCol, titulo, subtitulo)

            Row rowHeader = sheet.createRow((short) curRow)
            Cell cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("RESPONSABLE")
            sheet.setColumnWidth(curCol, 6000)
            cellHeader.setCellStyle(styleHeader)
            curCol++

            cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("ACTIVIDAD")
            sheet.setColumnWidth(curCol, 6000)
            cellHeader.setCellStyle(styleHeader)
            curCol++

            cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("TAREA")
            sheet.setColumnWidth(curCol, 6000)
            cellHeader.setCellStyle(styleHeader)
            curCol++

            cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("CODIFICADO")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 3000)
            curCol++

            cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("AVALADO")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 3000)
            curCol++

            cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("SALDO")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 3000)
            curCol++

            ReportesNuevosExcelController.joinTitulos(sheet, iniRow, iniCol, curCol)

            curRow++

            def estadoAprobado = EstadoAval.findByCodigo("E02")

            asignaciones.each { a->


                def procs = ProcesoAsignacion.findAllByAsignacion(a).proceso

                def avales = []
                def av = 0
                if (procs.size() > 0) {
                    avales = Aval.withCriteria {
                        inList("proceso", procs)
                        eq("estado", estadoAprobado)
                    }
                    if (avales.size() > 0) {
                        av = avales.sum { it.monto }
                    }
                }

//                println("ava " + av)

                curCol = iniCol

                Row tableRow = sheet.createRow((short) curRow)
                def tableCell = tableRow.createCell(curCol)
                tableCell.setCellValue(firmasService.requirentes(a?.unidad)?.toString())
                tableCell.setCellStyle(styleTabla)
                curCol++

                tableCell = tableRow.createCell(curCol)
                tableCell.setCellValue(a?.tarea?.actividad?.descripcion)
                tableCell.setCellStyle(styleTabla)
                curCol++

                tableCell = tableRow.createCell(curCol)
                tableCell.setCellValue(a?.tarea?.descripcion)
                tableCell.setCellStyle(styleTabla)
                curCol++

                tableCell = tableRow.createCell(curCol)
                tableCell.setCellValue(a?.priorizadoOriginal)
                tableCell.setCellStyle(styleNumber)
                curCol++

                tableCell = tableRow.createCell(curCol)
                tableCell.setCellValue(av)
                tableCell.setCellStyle(styleNumber)
                curCol++

                tableCell = tableRow.createCell(curCol)
                tableCell.setCellValue((a?.priorizado - av))
                tableCell.setCellStyle(styleNumber)
                curCol++

                curRow++

            }

            sheet.addMergedRegion(new CellRangeAddress(
                    curRow, //first row (0-based)
                    curRow, //last row  (0-based)
                    iniCol, //first column (0-based)
                    iniCol + 3 //last column  (0-based)
            ))

            curCol = iniCol
//            Row totalRow = sheet.createRow((short) curRow)
//
//            Cell cellFooter = totalRow.createCell((short) curCol)
//            curCol++
//            cellFooter.setCellValue("TOTAL")
//            cellFooter.setCellStyle(styleFooterCenter)
//
//            (1..3).each {
//                cellFooter = totalRow.createCell((short) curCol)
//                curCol++
//                cellFooter.setCellValue("")
//                cellFooter.setCellStyle(styleFooterCenter)
//            }
//
//            cellFooter = totalRow.createCell((short) curCol)
//            curCol++
//            cellFooter.setCellValue('')
//            cellFooter.setCellStyle(styleFooter)
//
//            cellFooter = totalRow.createCell((short) curCol)
//            curCol++
//            cellFooter.setCellValue('')
//            cellFooter.setCellStyle(styleFooter)
//
//            cellFooter = totalRow.createCell((short) curCol)
//            curCol++
//            cellFooter.setCellValue('')
//            cellFooter.setCellStyle(styleFooter)

            def output = response.getOutputStream()
            def header = "attachment; filename=" + "disponibilidad_recursos_permanentes.xlsx"
            response.setContentType("application/application/vnd.openxmlformats-officedocument.spreadsheetml.sheet")
            response.setHeader("Content-Disposition", header)
            wb.write(output)
            output.flush()
        } catch (Exception ex) {
            ex.printStackTrace();
        }


    }



    def reportesAvalesPermanentes () {

//        println("params per excel " + params)

        def fechaInicio =  new Date().parse("dd-MM-yyyy", params.ini)
        def fechaFin = new Date().parse("dd-MM-yyyy", params.fin)

        def corrientes = AvalCorriente.withCriteria {

            gt("fechaInicioProceso", fechaInicio)
            lt("fechaFinProceso", fechaFin)
        }

//        println("corrientes " + corrientes)

        def iniRow = 0
        def iniCol = 1

        def curRow = iniRow
        def curCol = iniCol

        try {

            Workbook wb = new Workbook()
            Sheet sheet = wb.createSheet("Reporte de Avales Permanentes")

            def estilos = ReportesNuevosExcelController.getEstilos(wb)
            CellStyle styleHeader = estilos.styleHeader
            CellStyle styleTabla = estilos.styleTabla
            CellStyle styleFooter = estilos.styleFooter
            CellStyle styleFooterCenter = estilos.styleFooterCenter
            CellStyle styleNumber = estilos.styleNumber
            CellStyle styleDate = estilos.styleDate


            def titulo = "REPORTE DE AVALES PERMANENTES"
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
            cellHeader.setCellValue("FECHA SOLICITUD")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 4500)
            curCol++

            cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("N° AVAL")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 2000)
            curCol++

            cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("FECHA DE AVAL")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 4500)
            curCol++

            cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("MONTO")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 4000)
            curCol++

            cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("FUENTE")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 9000)
            curCol++

            cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("AVALADO")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 4000)
            curCol++

            cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("SALDO")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 4000)
            curCol++

            def totalCols = curCol
            ReportesNuevosExcelController.joinTitulos(sheet, iniRow, iniCol, totalCols, false)
            def totalSaldo = 0

//            cn.eachRow(tx.toString()) { d ->
            corrientes.each { d->

                curCol = iniCol
                Row tableRow = sheet.createRow((short) curRow)
                Cell cellTabla = tableRow.createCell((short) curCol)

                cellTabla = tableRow.createCell((short) curCol)
                cellTabla.setCellValue(d?.numeroSolicitud)
                cellTabla.setCellStyle(styleTabla)
                curCol++
                cellTabla = tableRow.createCell((short) curCol)
                cellTabla.setCellValue(d?.fechaSolicitud?.format("dd-MM-yyyy"))
                cellTabla.setCellStyle(styleTabla)
                curCol++
                cellTabla = tableRow.createCell((short) curCol)
                cellTabla.setCellValue(d?.numeroAval)
                cellTabla.setCellStyle(styleTabla)
                curCol++
                cellTabla = tableRow.createCell((short) curCol)
                cellTabla.setCellValue(d?.fechaAprobacion?.format("dd-MM-yyyy"))
                cellTabla.setCellStyle(styleDate)
                curCol++
                cellTabla = tableRow.createCell((short) curCol)
                cellTabla.setCellValue(ProcesoAsignacion.findByAvalCorriente(d)?.asignacion?.priorizado)
                cellTabla.setCellStyle(styleNumber)
                curCol++
                cellTabla = tableRow.createCell((short) curCol)
                cellTabla.setCellValue(ProcesoAsignacion.findByAvalCorriente(d)?.asignacion?.fuente?.descripcion)
                cellTabla.setCellStyle(styleTabla)
                curCol++
                cellTabla = tableRow.createCell((short) curCol)
                cellTabla.setCellValue(d?.monto)
                cellTabla.setCellStyle(styleNumber)
                curCol++
                cellTabla = tableRow.createCell((short) curCol)
                cellTabla.setCellValue(ProcesoAsignacion.findByAvalCorriente(d)?.asignacion?.priorizado - d?.monto)
                cellTabla.setCellStyle(styleNumber)
                totalSaldo += (ProcesoAsignacion.findByAvalCorriente(d)?.asignacion?.priorizado - d?.monto)

                curCol++
                curRow++

            }
//            cn.close()

            curCol = iniCol
            Row totalRow = sheet.createRow((short) curRow)
            Cell cellFooter = totalRow.createCell((short) curCol)
            curCol++
            cellFooter.setCellValue("")
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
            cellFooter.setCellValue("")
            cellFooter.setCellStyle(styleFooterCenter)

            cellFooter = totalRow.createCell((short) curCol)
            curCol++
            cellFooter.setCellValue("")
            cellFooter.setCellStyle(styleFooterCenter)

            cellFooter = totalRow.createCell((short) curCol)
            curCol++
            cellFooter.setCellValue('')
            cellFooter.setCellStyle(styleFooter)

            cellFooter = totalRow.createCell((short) curCol)
            curCol++
            cellFooter.setCellValue("TOTAL")
            cellFooter.setCellStyle(styleFooter)

            cellFooter = totalRow.createCell((short) curCol)
            curCol++
            cellFooter.setCellValue(totalSaldo)
            cellFooter.setCellStyle(styleFooter)

            sheet.addMergedRegion(new CellRangeAddress(
                    curRow, //first row (0-based)
                    curRow, //last row  (0-based)
                    iniCol, //first column (0-based)
                    iniCol + 3 //last column  (0-based)
            ))

            def output = response.getOutputStream()
            def header = "attachment; filename=" + "reporte_avales_permanentes.xlsx"
            response.setContentType("application/application/vnd.openxmlformats-officedocument.spreadsheetml.sheet")
            response.setHeader("Content-Disposition", header)
            wb.write(output)
            output.flush()

        } catch (Exception ex) {
            ex.printStackTrace();
        }

    }


    def avalesPermanentesUI () {

    }

    def fechasAvales_ajax() {

    }

}
