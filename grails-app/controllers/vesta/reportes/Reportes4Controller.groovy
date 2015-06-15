package vesta.reportes

import vesta.parametros.poaPac.Anio
import vesta.parametros.poaPac.Fuente
import vesta.parametros.poaPac.Mes
import vesta.parametros.poaPac.Presupuesto
import vesta.poa.Asignacion
import vesta.poa.ProgramacionAsignacion

import org.apache.poi.ss.usermodel.CellStyle
import org.apache.poi.ss.util.CellRangeAddress
import org.apache.poi.xssf.usermodel.XSSFCell as Cell
import org.apache.poi.xssf.usermodel.XSSFRow as Row
import org.apache.poi.xssf.usermodel.XSSFSheet as Sheet
import org.apache.poi.xssf.usermodel.XSSFWorkbook as Workbook
import vesta.proyectos.MarcoLogico
import vesta.proyectos.MetaBuenVivirProyecto
import vesta.proyectos.Proyecto

class Reportes4Controller {
    def proformaEgresosNoPermanentesXlsx() {
        def fuente = Fuente.get(params.fnt.toLong())
        def datos = proformaEgresosNoPermanentes_funcion(fuente)

        def anio = datos.anio
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
            Sheet sheet = wb.createSheet("Proforma de egresos no permanentes")
            // Create a new font and alter it.
            def estilos = ReportesNuevosExcelController.getEstilos(wb)
            CellStyle styleHeader = estilos.styleHeader
            CellStyle styleTabla = estilos.styleTabla
            CellStyle styleFooter = estilos.styleFooter
            CellStyle styleFooterCenter = estilos.styleFooterCenter
            CellStyle styleNumber = estilos.styleNumber
//            CellStyle styleFooterNumber = estilos.styleFooterNumber

            // Create a row and put some cells in it. Rows are 0 based.
            def titulo = "PROFORMA DE EGRESOS NO PERMANENTES"
            def subtitulo = "AÑO ${anio.anio} - ${fuente ? 'FUENTE ' + fuente.descripcion : 'TODAS LAS FUENTES'} - EN DÓLARES"
            curRow = ReportesNuevosExcelController.setTitulos(sheet, estilos, iniRow, iniCol, titulo, subtitulo)

            Row rowHeader = sheet.createRow((short) curRow)
            Cell cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("GRUPO PRESUPUESTARIO")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 3500)
            curCol++

            cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("GRUPO DE GASTO")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 12500)
            curCol++

            cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("PROGRAMACIÓN AÑO " + anio.anio)
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 3000)
            curCol++

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
                cellHeader = rowHeader.createCell((short) curCol)
                cellHeader.setCellValue("AÑO ${a}")
                cellHeader.setCellStyle(styleHeader)
                sheet.setColumnWidth(curCol, 4000)
                curCol++
            }

            def totalCols = curCol
            cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("TOTAL PLURIANUAL")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 4000)

            def rowHeader1o = curRow
            curRow++
            def rowHeader2o = curRow

            Row rowHeader2 = sheet.createRow((short) curRow)
            def colMes = iniCol + 2
            def colFinMes = colMes + meses.size() - 1
            curCol = colMes
            meses.eachWithIndex { m, i ->
                cellHeader = rowHeader2.createCell((short) curCol)
                cellHeader.setCellValue(m.descripcion)
                cellHeader.setCellStyle(styleHeader)
                sheet.setColumnWidth(curCol, 3000)
                curCol++
            }

            ReportesNuevosExcelController.joinTitulos(sheet, iniRow, iniCol, totalCols)

            sheet.addMergedRegion(new CellRangeAddress(
                    rowHeader1o, //first row (0-based)
                    rowHeader2o, //last row  (0-based)
                    iniCol, //first column (0-based)
                    iniCol //last column  (0-based)
            ))
            sheet.addMergedRegion(new CellRangeAddress(
                    rowHeader1o, //first row (0-based)
                    rowHeader2o, //last row  (0-based)
                    iniCol + 1, //first column (0-based)
                    iniCol + 1 //last column  (0-based)
            ))
            sheet.addMergedRegion(new CellRangeAddress(
                    rowHeader1o, //first row (0-based)
                    rowHeader1o, //last row  (0-based)
                    colMes, //first column (0-based)
                    colFinMes //last column  (0-based)
            ))
            anios.eachWithIndex { a, i ->
                sheet.addMergedRegion(new CellRangeAddress(
                        rowHeader1o, //first row (0-based)
                        rowHeader2o, //last row  (0-based)
                        colFinMes + 1 + i, //first column (0-based)
                        colFinMes + 1 + i //last column  (0-based)
                ))
            }
            sheet.addMergedRegion(new CellRangeAddress(
                    rowHeader1o, //first row (0-based)
                    rowHeader2o, //last row  (0-based)
                    colFinMes + 1 + anios.size(), //first column (0-based)
                    colFinMes + 1 + anios.size() //last column  (0-based)
            ))

            curRow++
            data.each { v ->
                curCol = iniCol
                Row tableRow = sheet.createRow((short) curRow)
                def tableCell = tableRow.createCell(curCol)
                tableCell.setCellValue(v.partida.numero.replaceAll("0", ""))
                tableCell.setCellStyle(styleTabla)
                curCol++
                tableCell = tableRow.createCell(curCol)
                tableCell.setCellValue(v.partida.descripcion)
                tableCell.setCellStyle(styleTabla)
                curCol++
                meses.each { mes ->
                    tableCell = tableRow.createCell(curCol)
                    tableCell.setCellValue(v.valores[mes.numero + "_" + anio.anio] ?: 0)
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
                curRow++
            }

            sheet.addMergedRegion(new CellRangeAddress(
                    curRow, //first row (0-based)
                    curRow, //last row  (0-based)
                    iniCol, //first column (0-based)
                    iniCol + 1 //last column  (0-based)
            ))

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

            meses.each { m ->
                cellFooter = totalRow.createCell((short) curCol)
                curCol++
                cellFooter.setCellValue(totales[m.numero + "_" + anio.anio] ?: 0)
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
            def header = "attachment; filename=" + "proforma_egresos_no_permanentes.xlsx"
            response.setContentType("application/application/vnd.openxmlformats-officedocument.spreadsheetml.sheet")
            response.setHeader("Content-Disposition", header)
            wb.write(output)
            output.flush()
        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }

    def poaXlsx() {
        def datos = poa_funcion()

        def anio = datos.anio
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
            Sheet sheet = wb.createSheet("Planificación operativa anual")
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
            def titulo = "PLANIFICACIÓN OPERATIVA ANUAL"
            def subtitulo = "POA AÑO ${anio.anio} - EN DÓLARES"
            curRow = ReportesNuevosExcelController.setTitulos(sheet, estilos, iniRow, iniCol, titulo, subtitulo)

            Row rowHeader = sheet.createRow((short) curRow)
            Cell cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("PLAN NACIONAL DE DESARROLLO")
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
            cellHeader.setCellValue("OBJETIVO ESTRATÉGICO")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 12500)
            curCol++

            cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("ESTRATEGIA")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 6000)
            curCol++

            cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("PORTAFOLIO")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 6000)
            curCol++

            cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("PROGRAMA")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 6000)
            curCol++

            cellHeader = rowHeader.createCell((short) curCol)
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
            cellHeader = rowHeader2.createCell((short) curCol)
            cellHeader.setCellValue("OBJETIVO")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 6000)
            curCol++

            cellHeader = rowHeader2.createCell((short) curCol)
            cellHeader.setCellValue("POLÍTICA")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 6000)
            curCol++

            cellHeader = rowHeader2.createCell((short) curCol)
            cellHeader.setCellValue("META")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 6000)
            curCol++

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

            sheet.addMergedRegion(new CellRangeAddress(
                    rowHeader1o, //first row (0-based)
                    rowHeader1o, //last row  (0-based)
                    iniCol, //first column (0-based)
                    iniCol + 2  //last column  (0-based)
            ))
            (1..16).each { n ->
                sheet.addMergedRegion(new CellRangeAddress(
                        rowHeader1o, //first row (0-based)
                        rowHeader2o, //last row  (0-based)
                        iniCol + 2 + n, //first column (0-based)
                        iniCol + 2 + n  //last column  (0-based)
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
                    curCol += 19

                    sheet.addMergedRegion(new CellRangeAddress(
                            curRow, //first row (0-based)
                            curRow, //last row  (0-based)
                            iniCol, //first column (0-based)
                            iniCol + 18 //last column  (0-based)
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
                    def metas = MetaBuenVivirProyecto.withCriteria {
                        eq("proyecto", proyecto)
                        metaBuenVivir {
                            politica {
                                objetivo {
                                    order("codigo", "asc")
                                }
                                order("codigo", "asc")
                            }
                            order("codigo", "asc")
                        }
                    }
                    def meta = metas.size() > 0 ? metas.first() : null

                    tableCell.setCellValue(meta?.metaBuenVivir?.politica?.objetivo?.descripcion)
                    tableCell.setCellStyle(styleTabla)
                    curCol++

                    tableCell = tableRow.createCell(curCol)
                    tableCell.setCellValue(meta?.metaBuenVivir?.politica?.descripcion)
                    tableCell.setCellStyle(styleTabla)
                    curCol++

                    tableCell = tableRow.createCell(curCol)
                    tableCell.setCellValue(meta?.metaBuenVivir?.descripcion)
                    tableCell.setCellStyle(styleTabla)
                    curCol++

                    tableCell = tableRow.createCell(curCol)
                    tableCell.setCellValue(proyecto.objetivoEstrategico?.descripcion)
                    tableCell.setCellStyle(styleTabla)
                    curCol++

                    tableCell = tableRow.createCell(curCol)
                    tableCell.setCellValue(proyecto.estrategia?.descripcion)
                    tableCell.setCellStyle(styleTabla)
                    curCol++

                    tableCell = tableRow.createCell(curCol)
                    tableCell.setCellValue(proyecto.portafolio?.descripcion)
                    tableCell.setCellStyle(styleTabla)
                    curCol++

                    tableCell = tableRow.createCell(curCol)
                    tableCell.setCellValue(proyecto.programa?.descripcion)
                    tableCell.setCellStyle(styleTabla)
                    curCol++

                    tableCell = tableRow.createCell(curCol)
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
                    tableCell.setCellValue(asignacion.marcoLogico.responsable.gerencia.nombre)
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
                    iniCol + 18 //last column  (0-based)
            ))

            curCol = iniCol
            Row totalRow = sheet.createRow((short) curRow)

            Cell cellFooter = totalRow.createCell((short) curCol)
            curCol++
            cellFooter.setCellValue("TOTAL")
            cellFooter.setCellStyle(styleFooterCenter)

            (1..18).each {
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
            def header = "attachment; filename=" + "poa.xlsx"
            response.setContentType("application/application/vnd.openxmlformats-officedocument.spreadsheetml.sheet")
            response.setHeader("Content-Disposition", header)
            wb.write(output)
            output.flush()
        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }

    def programacionPlurianualXlsx() {
        def fuente = Fuente.get(params.fnt.toLong())
        def datos = programacionPlurianual_funcion(fuente)

        def anio = datos.anio
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
            Sheet sheet = wb.createSheet("Programación plurianual")
            // Create a new font and alter it.
            def estilos = ReportesNuevosExcelController.getEstilos(wb)
            CellStyle styleHeader = estilos.styleHeader
            CellStyle styleTabla = estilos.styleTabla
            CellStyle styleNumber = estilos.styleNumber
            CellStyle styleFooter = estilos.styleFooter
            CellStyle styleFooterCenter = estilos.styleFooterCenter

            // Create a row and put some cells in it. Rows are 0 based.
            def titulo = "PROGRAMACIÓN PLURIANUAL - ${fuente ? 'FUENTE ' + fuente.descripcion : 'TODAS LAS FUENTES'} - EN DÓLARES"
            def subtitulo = null
            curRow = ReportesNuevosExcelController.setTitulos(sheet, estilos, iniRow, iniCol, titulo, subtitulo)

            Row rowHeader = sheet.createRow((short) curRow)
            Cell cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("PLAN NACIONAL DE DESARROLLO")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 6000)
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
            cellHeader.setCellValue("OBJETIVO ESTRATÉGICO")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 6000)
            curCol++

            cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("ESTRATEGIA")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 6000)
            curCol++

            cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("PORTAFOLIO")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 6000)
            curCol++

            cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("PROGRAMA")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 6000)
            curCol++

            cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("COD.")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 2000)
            curCol++

            cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("PROYECTO")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 10000)
            curCol++

            def colProg = curCol
            cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("PROGRAMACIÓN")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 6000)
            curCol++

            (1..anios.size() - 1).each { a ->
                cellHeader = rowHeader.createCell((short) curCol)
                cellHeader.setCellValue("")
                cellHeader.setCellStyle(styleHeader)
                sheet.setColumnWidth(curCol, 4000)
                curCol++
            }

            def totalCols = curCol
            cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("TOTAL PLURIANUAL")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 4000)

            def rowHeader1o = curRow
            curRow++
            def rowHeader2o = curRow

            curCol = iniCol

            Row rowHeader2 = sheet.createRow((short) curRow)
            cellHeader = rowHeader2.createCell((short) curCol)
            cellHeader.setCellValue("OBJETIVO")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 6000)
            curCol++

            cellHeader = rowHeader2.createCell((short) curCol)
            cellHeader.setCellValue("POLÍTICA")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 6000)
            curCol++

            cellHeader = rowHeader2.createCell((short) curCol)
            cellHeader.setCellValue("META")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 6000)
            curCol++

            curCol = colProg
            anios.each { a ->
                cellHeader = rowHeader2.createCell((short) curCol)
                cellHeader.setCellValue(a)
                cellHeader.setCellStyle(styleHeader)
                sheet.setColumnWidth(curCol, 4000)
                curCol++
            }

            ReportesNuevosExcelController.joinTitulos(sheet, iniRow, iniCol, totalCols, false)

            sheet.addMergedRegion(new CellRangeAddress(
                    rowHeader1o, //first row (0-based)
                    rowHeader1o, //last row  (0-based)
                    iniCol, //first column (0-based)
                    iniCol + 2  //last column  (0-based)
            ))
            (1..6).each { n ->
                sheet.addMergedRegion(new CellRangeAddress(
                        rowHeader1o, //first row (0-based)
                        rowHeader2o, //last row  (0-based)
                        iniCol + 2 + n, //first column (0-based)
                        iniCol + 2 + n  //last column  (0-based)
                ))
            }
            sheet.addMergedRegion(new CellRangeAddress(
                    rowHeader1o, //first row (0-based)
                    rowHeader1o, //last row  (0-based)
                    colProg, //first column (0-based)
                    colProg + anios.size() - 1//last column  (0-based)
            ))
            sheet.addMergedRegion(new CellRangeAddress(
                    rowHeader1o, //first row (0-based)
                    rowHeader2o, //last row  (0-based)
                    colProg + anios.size(), //first column (0-based)
                    colProg + anios.size() //last column  (0-based)
            ))

            curRow++
            data.each { v ->
                curCol = iniCol

                Proyecto proyecto = v.proyecto
                def meta = MetaBuenVivirProyecto.withCriteria {
                    eq("proyecto", proyecto)
                    metaBuenVivir {
                        politica {
                            objetivo {
                                order("codigo", "asc")
                            }
                            order("codigo", "asc")
                        }
                        order("codigo", "asc")
                    }
                }
                meta = meta.size() > 0 ? meta.first() : null

                Row tableRow = sheet.createRow((short) curRow)
                def tableCell = tableRow.createCell(curCol)
                tableCell.setCellValue(meta?.metaBuenVivir?.politica?.objetivo?.descripcion)
                tableCell.setCellStyle(styleTabla)
                curCol++

                tableCell = tableRow.createCell(curCol)
                tableCell.setCellValue(meta?.metaBuenVivir?.politica?.descripcion)
                tableCell.setCellStyle(styleTabla)
                curCol++

                tableCell = tableRow.createCell(curCol)
                tableCell.setCellValue(meta?.metaBuenVivir?.descripcion)
                tableCell.setCellStyle(styleTabla)
                curCol++

                tableCell = tableRow.createCell(curCol)
                tableCell.setCellValue(proyecto.objetivoEstrategico?.descripcion)
                tableCell.setCellStyle(styleTabla)
                curCol++

                tableCell = tableRow.createCell(curCol)
                tableCell.setCellValue(proyecto.estrategia?.descripcion)
                tableCell.setCellStyle(styleTabla)
                curCol++

                tableCell = tableRow.createCell(curCol)
                tableCell.setCellValue(proyecto.portafolio?.descripcion)
                tableCell.setCellStyle(styleTabla)
                curCol++

                tableCell = tableRow.createCell(curCol)
                tableCell.setCellValue(proyecto.programa?.descripcion)
                tableCell.setCellStyle(styleTabla)
                curCol++

                tableCell = tableRow.createCell(curCol)
                tableCell.setCellValue(proyecto.codigo)
                tableCell.setCellStyle(styleTabla)
                curCol++

                tableCell = tableRow.createCell(curCol)
                tableCell.setCellValue(proyecto.nombre)
                tableCell.setCellStyle(styleTabla)
                curCol++

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

                curRow++
            }

            sheet.addMergedRegion(new CellRangeAddress(
                    curRow, //first row (0-based)
                    curRow, //last row  (0-based)
                    iniCol, //first column (0-based)
                    iniCol + 8 //last column  (0-based)
            ))

            curCol = iniCol
            Row totalRow = sheet.createRow((short) curRow)

            Cell cellFooter = totalRow.createCell((short) curCol)
            curCol++
            cellFooter.setCellValue("TOTAL")
            cellFooter.setCellStyle(styleFooterCenter)

            (1..8).each {
                cellFooter = totalRow.createCell((short) curCol)
                curCol++
                cellFooter.setCellValue("")
                cellFooter.setCellStyle(styleFooterCenter)
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
            def header = "attachment; filename=" + "programacion_plurianual.xlsx"
            response.setContentType("application/application/vnd.openxmlformats-officedocument.spreadsheetml.sheet")
            response.setHeader("Content-Disposition", header)
            wb.write(output)
            output.flush()
        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }

    def proformaEgresosNoPermanentes_funcion(Fuente fuente) {
        def strAnio = new Date().format('yyyy')
        def anio = Anio.findByAnio(strAnio)

        def keyTotalActual = strAnio
        def keyTotal = "T"

        def data = []
        def anios = []
        def meses = Mes.list([sort: "numero"])
        def partidas = Presupuesto.findAllByNumeroLike('%0000', [sort: 'numero'])

        def totales = [:]
        totales[keyTotalActual] = 0
        totales[keyTotal] = 0

        partidas.each { partida ->
            def numero = partida.numero?.replaceAll("0", "")
            def m = [:]
            m.partida = partida
            m.valores = [:]
            m.valores[keyTotalActual] = 0
            m.valores[keyTotal] = 0

            def asignaciones = Asignacion.withCriteria {
                presupuesto {
                    like("numero", numero + "%")
                }
                if (fuente) {
                    eq("fuente", fuente)
                }
            }
            asignaciones.each { asg ->
                def anioAsg = asg.anio

                if (!anios.contains(anioAsg.anio)) {
                    anios += anioAsg.anio
                    totales[anioAsg.anio] = 0
                }

                if (anioAsg.id == anio.id) {
                    //es el anio n: saca la programacion
                    meses.each { mes ->
                        def keyMes = mes.numero + "_" + anio.anio
                        def programacion = ProgramacionAsignacion.findAllByAsignacionAndMes(asg, mes)
                        if (!m.valores[keyMes]) {
                            m.valores[keyMes] = 0
                        }
                        if (!totales[keyMes]) {
                            totales[keyMes] = 0
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
                        m.valores[keyTotalActual] += v
                        totales[keyMes] += v
                        totales[anioAsg.anio] += v
                    }
                } else {
                    //es anio futuro: saca el total
                    m.valores[keyTotal] += asg.planificado
                    totales[keyTotal] += asg.planificado
                    if (!m.valores[anioAsg.anio]) {
                        m.valores[anioAsg.anio] = 0
                    }
                    m.valores[anioAsg.anio] += asg.planificado
                    totales[anioAsg.anio] += asg.planificado
                }
            }
//            if (m.valores[keyTotal] > 0) {
            data += m
//            }
        }
        anios = anios.sort()
        return [anio: anio, data: data, anios: anios, meses: meses, totales: totales]
    }

    def poa_funcion() {
        def strAnio = new Date().format('yyyy')
        def anio = Anio.findByAnio(strAnio)

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

                    m.valores[keyTotal] += asg.priorizado

                    totales[keyTotal] += asg.priorizado
                    totalesProyecto[keyTotal] += asg.priorizado

                    if (asg.fuente.codigo == "998") {
                        m.valores[keyArrastre] += asg.priorizado
                        totales[keyArrastre] += asg.priorizado
                        totalesProyecto[keyArrastre] += asg.priorizado

                        m.valores[keyTotalActual] += asg.priorizado
                        totales[keyTotalActual] += asg.priorizado
                        totalesProyecto[keyTotalActual] += asg.priorizado
                    } else {
                        m.valores[keyNuevo] += asg.priorizado
                        totales[keyNuevo] += asg.priorizado
                        totalesProyecto[keyNuevo] += asg.priorizado

                        m.valores[keyTotalActual] += asg.priorizado
                        totales[keyTotalActual] += asg.priorizado
                        totalesProyecto[keyTotalActual] += asg.priorizado
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

    def programacionPlurianual_funcion(Fuente fuente) {
        def strAnio = new Date().format('yyyy')
        def anio = Anio.findByAnio(strAnio)

        def keyArrastre = "" + (strAnio.toInteger() - 1)
        def keyActual = strAnio
        def keyTotal = "T"

        def data = []
        def anios = []
        anios += keyArrastre
        anios += keyActual
        def proyectos = Proyecto.list([sort: "codigo"])

        def totales = [:]
        totales[keyArrastre] = 0
        totales[keyActual] = 0
        totales[keyTotal] = 0

        proyectos.each { proy ->
            def m = [:]
            m.proyecto = proy
            m.valores = [:]
            m.valores[keyArrastre] = 0
            m.valores[keyActual] = 0
            m.valores[keyTotal] = 0

            def actividades = MarcoLogico.findAllByProyecto(proy)
            def asignaciones = []
            if (actividades.size() > 0) {
                asignaciones = Asignacion.withCriteria {
                    inList("marcoLogico", actividades)
                    if (fuente) {
                        eq("fuente", fuente)
                    }
                }
            }
            asignaciones.each { asg ->
                def anioAsg = asg.anio
                if (anioAsg.id == anio.id) {
                    m.valores[keyTotal] += asg.priorizado
                    totales[keyTotal] += asg.priorizado
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
}
