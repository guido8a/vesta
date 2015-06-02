package vesta.reportes

import org.apache.poi.ss.usermodel.CellStyle
import org.apache.poi.ss.usermodel.Font
import org.apache.poi.ss.usermodel.IndexedColors
import org.apache.poi.ss.util.CellRangeAddress
import org.apache.poi.xssf.usermodel.XSSFCell as Cell
import org.apache.poi.xssf.usermodel.XSSFColor
import org.apache.poi.xssf.usermodel.XSSFRow as Row
import org.apache.poi.xssf.usermodel.XSSFSheet as Sheet
import org.apache.poi.xssf.usermodel.XSSFWorkbook as Workbook


class ReportesNuevosExcelController {

    def poaGrupoGastoXls() {
        def reportes = new ReportesNuevosController()
        def data = reportes.poaGrupoGastos_funcion()
        def anio = data.anio
        def totales = data.totales

        def iniRow = 0
        def iniCol = 0

        def curRow = iniRow
        def curCol = iniCol

        try {
            Workbook wb = new Workbook()
            Sheet sheet = wb.createSheet("POA por grupo de gastos")
            // Create a new font and alter it.
            Font fontTitulo = wb.createFont()
            fontTitulo.setFontHeightInPoints((short) 24)
            fontTitulo.setColor(new XSSFColor(new java.awt.Color(23, 54, 93)))
            fontTitulo.setBold(true)

            Font fontSubtitulo = wb.createFont()
            fontSubtitulo.setFontHeightInPoints((short) 18)
            fontSubtitulo.setColor(new XSSFColor(new java.awt.Color(23, 54, 93)))
            fontSubtitulo.setBold(true)

            Font fontHeader = wb.createFont()
            fontHeader.setFontHeightInPoints((short) 12)
            fontHeader.setColor(new XSSFColor(new java.awt.Color(255, 255, 255)))
            fontHeader.setBold(true)

            Font fontFooter = wb.createFont()
            fontFooter.setBold(true)

            // Create a row and put some cells in it. Rows are 0 based.
            Row row = sheet.createRow((short) curRow)
            curRow++
            row.setHeightInPoints(30)
            Row row2 = sheet.createRow((short) curRow)
            curRow += 2
            row2.setHeightInPoints(24)
            Row row3 = sheet.createRow((short) curRow)
            curRow++

            CellStyle styleTitulo = wb.createCellStyle()
            styleTitulo.setFont(fontTitulo)
            styleTitulo.setAlignment(CellStyle.ALIGN_CENTER)
            styleTitulo.setVerticalAlignment(CellStyle.VERTICAL_CENTER)

            CellStyle styleSubtitulo = wb.createCellStyle()
            styleSubtitulo.setFont(fontSubtitulo)
            styleSubtitulo.setAlignment(CellStyle.ALIGN_CENTER)
            styleSubtitulo.setVerticalAlignment(CellStyle.VERTICAL_CENTER)

            CellStyle styleHeader = wb.createCellStyle()
            styleHeader.setFont(fontHeader)
            styleHeader.setAlignment(CellStyle.ALIGN_CENTER)
            styleHeader.setVerticalAlignment(CellStyle.VERTICAL_CENTER)
            styleHeader.setFillForegroundColor(new XSSFColor(new java.awt.Color(50, 96, 144)));
            styleHeader.setFillPattern(CellStyle.SOLID_FOREGROUND)

            CellStyle styleFooter = wb.createCellStyle()
            styleFooter.setFont(fontFooter)

            Cell cellTitulo = row.createCell((short) iniCol)
            cellTitulo.setCellValue("PLAN OPERATIVO ANUAL POA " + anio.anio)
            cellTitulo.setCellStyle(styleTitulo)
            Cell cellSubtitulo = row2.createCell((short) iniCol)
            cellSubtitulo.setCellValue("RESUMEN POR GRUPO DE GASTO")
            cellSubtitulo.setCellStyle(styleSubtitulo)

            Cell cellHeader = row3.createCell((short) curCol)
            curCol++
            cellHeader.setCellValue("")
            cellHeader.setCellStyle(styleHeader)

            cellHeader = row3.createCell((short) curCol)
            curCol++
            cellHeader.setCellValue("")
            cellHeader.setCellStyle(styleHeader)

            cellHeader = row3.createCell((short) curCol)
            curCol++
            cellHeader.setCellValue("Arrastre ${anio.anio.toInteger() - 1}")
            cellHeader.setCellStyle(styleHeader)

            cellHeader = row3.createCell((short) curCol)
            curCol++
            cellHeader.setCellValue("Requerimientos ${anio.anio}")
            cellHeader.setCellStyle(styleHeader)

            cellHeader = row3.createCell((short) curCol)
            curCol++
            cellHeader.setCellValue("Total ${anio.anio}")
            cellHeader.setCellStyle(styleHeader)

            data.anios.each { a ->
                cellHeader = row3.createCell((short) curCol)
                cellHeader.setCellValue("${a}")
                cellHeader.setCellStyle(styleHeader)
                curCol++
            }
            def totalCols = curCol
            cellHeader = row3.createCell((short) curCol)
            cellHeader.setCellValue("Total Plurianual")
            cellHeader.setCellStyle(styleHeader)

            sheet.addMergedRegion(new CellRangeAddress(
                    iniRow, //first row (0-based)
                    iniRow, //last row  (0-based)
                    iniCol, //first column (0-based)
                    totalCols  //last column  (0-based)
            ))
            sheet.addMergedRegion(new CellRangeAddress(
                    iniRow + 1, //first row (0-based)
                    iniRow + 1, //last row  (0-based)
                    iniCol, //first column (0-based)
                    totalCols   //last column  (0-based)
            ))

            data.data.each { v ->
                curCol = iniCol
                Row tableRow = sheet.createRow((short) curRow)
                tableRow.createCell(curCol).setCellValue("" + v.partida.descripcion)
                curCol++
                tableRow.createCell(curCol).setCellValue(v.partida.numero.replaceAll("0", ""))
                curCol++
                def str = ""
                if (v.valores["" + (anio.anio.toInteger() - 1)] > 0) {
                    str = v.valores["" + (anio.anio.toInteger() - 1)]
                }
                tableRow.createCell(curCol).setCellValue(str)
                curCol++
                str = ""
                if (v.valores[anio.anio] > 0) {
                    str = v.valores[anio.anio]
                }
                tableRow.createCell(curCol).setCellValue(str)
                curCol++
                str = ""
                if (v.valores["T" + anio.anio] > 0) {
                    str = v.valores["T" + anio.anio]
                }
                tableRow.createCell(curCol).setCellValue(str)
                curCol++
                data.anios.each { a ->
                    str = ""
                    if (v.valores[a] > 0) {
                        str = v.valores[a]
                    }
                    tableRow.createCell(curCol).setCellValue(str)
                    curCol++
                }
                tableRow.createCell(curCol).setCellValue(v.valores["T"])
                curRow++
            }

            curCol = iniCol
            Row totalRow = sheet.createRow((short) curRow)
            Cell cellFooter = totalRow.createCell((short) curCol)
            curCol++
            cellFooter.setCellValue("")
            cellFooter.setCellStyle(styleFooter)

            cellFooter = totalRow.createCell((short) curCol)
            curCol++
            cellFooter.setCellValue("TOTAL")
            cellFooter.setCellStyle(styleFooter)

            cellFooter = totalRow.createCell((short) curCol)
            curCol++
            cellFooter.setCellValue(totales['' + (anio.anio.toInteger() - 1)])
            cellFooter.setCellStyle(styleFooter)

            cellFooter = totalRow.createCell((short) curCol)
            curCol++
            cellFooter.setCellValue(totales[anio.anio])
            cellFooter.setCellStyle(styleFooter)

            cellFooter = totalRow.createCell((short) curCol)
            curCol++
            cellFooter.setCellValue(totales["T" + anio.anio])
            cellFooter.setCellStyle(styleFooter)

            data.anios.each { a ->
                cellFooter = totalRow.createCell((short) curCol)
                curCol++
                cellFooter.setCellValue(totales[a])
                cellFooter.setCellStyle(styleFooter)
            }

            cellFooter = totalRow.createCell((short) curCol)
            cellFooter.setCellValue(totales["T"])
            cellFooter.setCellStyle(styleFooter)

            (iniCol..totalCols).each { i ->
                sheet.autoSizeColumn(i) //adjust width of the first column
            }
            def output = response.getOutputStream()
            def header = "attachment; filename=" + "poa_grupo_gastos.xlsx"
            response.setContentType("application/application/vnd.openxmlformats-officedocument.spreadsheetml.sheet")
            response.setHeader("Content-Disposition", header)
            wb.write(output)
            output.flush()
        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }

    def poaAreaGestionXls() {
        def reportes = new ReportesNuevosController()
        def data = reportes.poaAreaGestion_funcion()
        def anio = data.anio
        def totales = data.totales

        def iniRow = 0
        def iniCol = 1

        def curRow = iniRow
        def curCol = iniCol

        try {
            Workbook wb = new Workbook()
            Sheet sheet = wb.createSheet("POA por unidad ejecutora")
            // Create a new font and alter it.
            Font fontYachay = wb.createFont()
            fontYachay.setFontHeightInPoints((short) 14)
            fontYachay.setColor(new XSSFColor(new java.awt.Color(23, 54, 93)))
            fontYachay.setBold(true)

            Font fontTitulo = wb.createFont()
            fontTitulo.setFontHeightInPoints((short) 14)
            fontTitulo.setColor(new XSSFColor(new java.awt.Color(23, 54, 93)))
            fontTitulo.setBold(true)

            Font fontSubtitulo = wb.createFont()
            fontSubtitulo.setFontHeightInPoints((short) 14)
            fontSubtitulo.setColor(new XSSFColor(new java.awt.Color(23, 54, 93)))
            fontSubtitulo.setBold(true)

            Font fontHeader = wb.createFont()
            fontHeader.setFontHeightInPoints((short) 9)
            fontHeader.setColor(new XSSFColor(new java.awt.Color(255, 255, 255)))
            fontHeader.setBold(true)

            Font fontTabla = wb.createFont()
            fontTabla.setFontHeightInPoints((short) 9)

            Font fontFooter = wb.createFont()
            fontHeader.setFontHeightInPoints((short) 9)
            fontFooter.setBold(true)

            CellStyle styleYachay = wb.createCellStyle()
            styleYachay.setFont(fontYachay)
            styleYachay.setAlignment(CellStyle.ALIGN_CENTER)
            styleYachay.setVerticalAlignment(CellStyle.VERTICAL_CENTER)

            CellStyle styleTitulo = wb.createCellStyle()
            styleTitulo.setFont(fontTitulo)
            styleTitulo.setAlignment(CellStyle.ALIGN_CENTER)
            styleTitulo.setVerticalAlignment(CellStyle.VERTICAL_CENTER)

            CellStyle styleSubtitulo = wb.createCellStyle()
            styleSubtitulo.setFont(fontSubtitulo)
            styleSubtitulo.setAlignment(CellStyle.ALIGN_CENTER)
            styleSubtitulo.setVerticalAlignment(CellStyle.VERTICAL_CENTER)

            CellStyle styleHeader = wb.createCellStyle()
            styleHeader.setFont(fontHeader)
            styleHeader.setAlignment(CellStyle.ALIGN_CENTER)
            styleHeader.setVerticalAlignment(CellStyle.VERTICAL_CENTER)
            styleHeader.setFillForegroundColor(new XSSFColor(new java.awt.Color(50, 96, 144)));
            styleHeader.setFillPattern(CellStyle.SOLID_FOREGROUND)
            styleHeader.setWrapText(true);
            styleHeader.setBorderBottom(CellStyle.BORDER_THIN);
            styleHeader.setBottomBorderColor(IndexedColors.BLACK.getIndex());
            styleHeader.setBorderLeft(CellStyle.BORDER_THIN);
            styleHeader.setLeftBorderColor(IndexedColors.BLACK.getIndex());
            styleHeader.setBorderRight(CellStyle.BORDER_THIN);
            styleHeader.setRightBorderColor(IndexedColors.BLACK.getIndex());
            styleHeader.setBorderTop(CellStyle.BORDER_THIN);
            styleHeader.setTopBorderColor(IndexedColors.BLACK.getIndex());

            CellStyle styleTabla = wb.createCellStyle()
            styleTabla.setFont(fontTabla)
            styleTabla.setWrapText(true);
            styleTabla.setBorderBottom(CellStyle.BORDER_THIN);
            styleTabla.setBottomBorderColor(IndexedColors.BLACK.getIndex());
            styleTabla.setBorderLeft(CellStyle.BORDER_THIN);
            styleTabla.setLeftBorderColor(IndexedColors.BLACK.getIndex());
            styleTabla.setBorderRight(CellStyle.BORDER_THIN);
            styleTabla.setRightBorderColor(IndexedColors.BLACK.getIndex());
            styleTabla.setBorderTop(CellStyle.BORDER_MEDIUM_DASHED);
            styleTabla.setTopBorderColor(IndexedColors.BLACK.getIndex());

            CellStyle styleFooter = wb.createCellStyle()
            styleFooter.setFont(fontFooter)
            styleFooter.setFillForegroundColor(new XSSFColor(new java.awt.Color(200, 200, 200)));
            styleFooter.setFillPattern(CellStyle.SOLID_FOREGROUND)
            CellStyle styleFooterCenter = wb.createCellStyle()
            styleFooterCenter.setFont(fontFooter)
            styleFooterCenter.setAlignment(CellStyle.ALIGN_CENTER)
            styleFooterCenter.setVerticalAlignment(CellStyle.VERTICAL_CENTER)
            styleFooterCenter.setFillForegroundColor(new XSSFColor(new java.awt.Color(200, 200, 200)));
            styleFooterCenter.setFillPattern(CellStyle.SOLID_FOREGROUND)

            // Create a row and put some cells in it. Rows are 0 based.

            Row rowYachay = sheet.createRow((short) curRow)
//            rowYachay.setHeightInPoints(30)
            curRow++
            Cell cellYachay = rowYachay.createCell((short) iniCol)
            cellYachay.setCellValue("EMPRESA PÚBLICA YACHAY EP")
            cellYachay.setCellStyle(styleYachay)

            Row rowTitulo = sheet.createRow((short) curRow)
//            rowTitulo.setHeightInPoints(24)
            curRow++
            Cell cellTitulo = rowTitulo.createCell((short) iniCol)
            cellTitulo.setCellValue("PLAN OPERATIVO ANUAL POA " + anio.anio)
            cellTitulo.setCellStyle(styleTitulo)

            Row rowSubtitulo = sheet.createRow((short) curRow)
//            rowSubtitulo.setHeightInPoints(24)
            curRow++
            Cell cellSubtitulo = rowSubtitulo.createCell((short) iniCol)
            cellSubtitulo.setCellValue("RESUMEN POR ÁREA DE GESTIÓN")
            cellSubtitulo.setCellStyle(styleSubtitulo)

            Row rowFecha = sheet.createRow((short) curRow)
//            rowSubtitulo.setHeightInPoints(24)
            curRow++
            Cell cellFecha = rowFecha.createCell((short) iniCol + 1)
            cellFecha.setCellValue(new Date().format("dd-MM-yyyy HH:mm"))

            Row rowHeader = sheet.createRow((short) curRow)
            rowSubtitulo.setHeightInPoints(30)
            curRow++
            Cell cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("NÚMERO")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 2000)
            curCol++

            cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("DESCRIPCIÓN")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 12500)
            curCol++

            cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("SIGLAS")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 2500)
            curCol++

            cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("ARRASTRE AÑO ${anio.anio.toInteger() - 1}")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 4000)
            curCol++

            cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("REQUERIMIENTO AÑO ${anio.anio}")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 4000)
            curCol++

            cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("PRESUPUESTO CODIFICADO AÑO ${anio.anio}")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 4000)
            curCol++

            data.anios.each { a ->
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

            sheet.addMergedRegion(new CellRangeAddress(
                    iniRow, //first row (0-based)
                    iniRow, //last row  (0-based)
                    iniCol, //first column (0-based)
                    totalCols  //last column  (0-based)
            ))
            sheet.addMergedRegion(new CellRangeAddress(
                    iniRow + 1, //first row (0-based)
                    iniRow + 1, //last row  (0-based)
                    iniCol, //first column (0-based)
                    totalCols   //last column  (0-based)
            ))
            sheet.addMergedRegion(new CellRangeAddress(
                    iniRow + 2, //first row (0-based)
                    iniRow + 2, //last row  (0-based)
                    iniCol, //first column (0-based)
                    totalCols   //last column  (0-based)
            ))

            data.data.eachWithIndex { v, k ->
                curCol = iniCol
                Row tableRow = sheet.createRow((short) curRow)
                tableRow.createCell(curCol).setCellValue("" + (k + 1))
                curCol++
                tableRow.createCell(curCol).setCellValue("" + v.unidad.nombre)
                curCol++
                tableRow.createCell(curCol).setCellValue(v.unidad.codigo)
                curCol++
                def str = ""
                if (v.valores["" + (anio.anio.toInteger() - 1)] > 0) {
                    str = v.valores["" + (anio.anio.toInteger() - 1)]
                }
                tableRow.createCell(curCol).setCellValue(str)
                curCol++
                str = ""
                if (v.valores[anio.anio] > 0) {
                    str = v.valores[anio.anio]
                }
                tableRow.createCell(curCol).setCellValue(str)
                curCol++
                str = ""
                if (v.valores["T" + anio.anio] > 0) {
                    str = v.valores["T" + anio.anio]
                }
                tableRow.createCell(curCol).setCellValue(str)
                curCol++
                data.anios.each { a ->
                    str = ""
                    if (v.valores[a] > 0) {
                        str = v.valores[a]
                    }
                    tableRow.createCell(curCol).setCellValue(str)
                    curCol++
                }
                tableRow.createCell(curCol).setCellValue(v.valores["T"])
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
            cellFooter.setCellStyle(styleFooter)

            cellFooter = totalRow.createCell((short) curCol)
            curCol++
            cellFooter.setCellValue("")
            cellFooter.setCellStyle(styleFooter)

            cellFooter = totalRow.createCell((short) curCol)
            curCol++
            cellFooter.setCellValue(totales['' + (anio.anio.toInteger() - 1)])
            cellFooter.setCellStyle(styleFooter)

            cellFooter = totalRow.createCell((short) curCol)
            curCol++
            cellFooter.setCellValue(totales[anio.anio])
            cellFooter.setCellStyle(styleFooter)

            cellFooter = totalRow.createCell((short) curCol)
            curCol++
            cellFooter.setCellValue(totales["T" + anio.anio])
            cellFooter.setCellStyle(styleFooter)

            data.anios.each { a ->
                cellFooter = totalRow.createCell((short) curCol)
                curCol++
                cellFooter.setCellValue(totales[a])
                cellFooter.setCellStyle(styleFooter)
            }

            cellFooter = totalRow.createCell((short) curCol)
            cellFooter.setCellValue(totales["T"])
            cellFooter.setCellStyle(styleFooter)

//            (iniCol..totalCols).each { i ->
//                sheet.autoSizeColumn(i) //adjust width of the first column
//            }
            def output = response.getOutputStream()
            def header = "attachment; filename=" + "poa_area_gestion.xlsx"
            response.setContentType("application/application/vnd.openxmlformats-officedocument.spreadsheetml.sheet")
            response.setHeader("Content-Disposition", header)
            wb.write(output)
            output.flush()
        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }

    def poaProyectoXls() {
        def reportes = new ReportesNuevosController()
        def data = reportes.poaProyecto_funcion()
        def anio = data.anio
        def totales = data.totales

        def iniRow = 0
        def iniCol = 0

        def curRow = iniRow
        def curCol = iniCol

        try {
            Workbook wb = new Workbook()
            Sheet sheet = wb.createSheet("POA por proyecto")
            // Create a new font and alter it.
            Font fontTitulo = wb.createFont()
            fontTitulo.setFontHeightInPoints((short) 24)
            fontTitulo.setColor(new XSSFColor(new java.awt.Color(23, 54, 93)))
            fontTitulo.setBold(true)

            Font fontSubtitulo = wb.createFont()
            fontSubtitulo.setFontHeightInPoints((short) 18)
            fontSubtitulo.setColor(new XSSFColor(new java.awt.Color(23, 54, 93)))
            fontSubtitulo.setBold(true)

            Font fontHeader = wb.createFont()
            fontHeader.setFontHeightInPoints((short) 12)
            fontHeader.setColor(new XSSFColor(new java.awt.Color(255, 255, 255)))
            fontHeader.setBold(true)

            Font fontFooter = wb.createFont()
            fontFooter.setBold(true)

            // Create a row and put some cells in it. Rows are 0 based.
            Row row = sheet.createRow((short) curRow)
            curRow++
            row.setHeightInPoints(30)
            Row row2 = sheet.createRow((short) curRow)
            curRow += 2
            row2.setHeightInPoints(24)
            Row row3 = sheet.createRow((short) curRow)
            curRow++

            CellStyle styleTitulo = wb.createCellStyle()
            styleTitulo.setFont(fontTitulo)
            styleTitulo.setAlignment(CellStyle.ALIGN_CENTER)
            styleTitulo.setVerticalAlignment(CellStyle.VERTICAL_CENTER)

            CellStyle styleSubtitulo = wb.createCellStyle()
            styleSubtitulo.setFont(fontSubtitulo)
            styleSubtitulo.setAlignment(CellStyle.ALIGN_CENTER)
            styleSubtitulo.setVerticalAlignment(CellStyle.VERTICAL_CENTER)

            CellStyle styleHeader = wb.createCellStyle()
            styleHeader.setFont(fontHeader)
            styleHeader.setAlignment(CellStyle.ALIGN_CENTER)
            styleHeader.setVerticalAlignment(CellStyle.VERTICAL_CENTER)
            styleHeader.setFillForegroundColor(new XSSFColor(new java.awt.Color(50, 96, 144)));
            styleHeader.setFillPattern(CellStyle.SOLID_FOREGROUND)

            CellStyle styleFooter = wb.createCellStyle()
            styleFooter.setFont(fontFooter)

            Cell cellTitulo = row.createCell((short) iniCol)
            cellTitulo.setCellValue("PLAN OPERATIVO ANUAL POA " + anio.anio)
            cellTitulo.setCellStyle(styleTitulo)
            Cell cellSubtitulo = row2.createCell((short) iniCol)
            cellSubtitulo.setCellValue("RESUMEN POR PROYECTO")
            cellSubtitulo.setCellStyle(styleSubtitulo)

            Cell cellHeader = row3.createCell((short) curCol)
            curCol++
            cellHeader.setCellValue("")
            cellHeader.setCellStyle(styleHeader)

            cellHeader = row3.createCell((short) curCol)
            curCol++
            cellHeader.setCellValue("Proyecto")
            cellHeader.setCellStyle(styleHeader)

            cellHeader = row3.createCell((short) curCol)
            curCol++
            cellHeader.setCellValue("Arrastre ${anio.anio.toInteger() - 1}")
            cellHeader.setCellStyle(styleHeader)

            cellHeader = row3.createCell((short) curCol)
            curCol++
            cellHeader.setCellValue("Requerimientos ${anio.anio}")
            cellHeader.setCellStyle(styleHeader)

            cellHeader = row3.createCell((short) curCol)
            curCol++
            cellHeader.setCellValue("Total ${anio.anio}")
            cellHeader.setCellStyle(styleHeader)

            data.anios.each { a ->
                cellHeader = row3.createCell((short) curCol)
                cellHeader.setCellValue("${a}")
                cellHeader.setCellStyle(styleHeader)
                curCol++
            }
            def totalCols = curCol
            cellHeader = row3.createCell((short) curCol)
            cellHeader.setCellValue("Total Plurianual")
            cellHeader.setCellStyle(styleHeader)

            sheet.addMergedRegion(new CellRangeAddress(
                    iniRow, //first row (0-based)
                    iniRow, //last row  (0-based)
                    iniCol, //first column (0-based)
                    totalCols  //last column  (0-based)
            ))
            sheet.addMergedRegion(new CellRangeAddress(
                    iniRow + 1, //first row (0-based)
                    iniRow + 1, //last row  (0-based)
                    iniCol, //first column (0-based)
                    totalCols   //last column  (0-based)
            ))

            data.data.eachWithIndex { v, k ->
                curCol = iniCol
                Row tableRow = sheet.createRow((short) curRow)
                tableRow.createCell(curCol).setCellValue("" + (k + 1))
                curCol++
                tableRow.createCell(curCol).setCellValue("" + v.proyecto.toStringCompleto())
                curCol++
                def str = ""
                if (v.valores["" + (anio.anio.toInteger() - 1)] > 0) {
                    str = v.valores["" + (anio.anio.toInteger() - 1)]
                }
                tableRow.createCell(curCol).setCellValue(str)
                curCol++
                str = ""
                if (v.valores[anio.anio] > 0) {
                    str = v.valores[anio.anio]
                }
                tableRow.createCell(curCol).setCellValue(str)
                curCol++
                str = ""
                if (v.valores["T" + anio.anio] > 0) {
                    str = v.valores["T" + anio.anio]
                }
                tableRow.createCell(curCol).setCellValue(str)
                curCol++
                data.anios.each { a ->
                    str = ""
                    if (v.valores[a] > 0) {
                        str = v.valores[a]
                    }
                    tableRow.createCell(curCol).setCellValue(str)
                    curCol++
                }
                tableRow.createCell(curCol).setCellValue(v.valores["T"])
                curRow++
            }

            curCol = iniCol
            Row totalRow = sheet.createRow((short) curRow)
            Cell cellFooter = totalRow.createCell((short) curCol)
            curCol++
            cellFooter.setCellValue("")
            cellFooter.setCellStyle(styleFooter)

            cellFooter = totalRow.createCell((short) curCol)
            curCol++
            cellFooter.setCellValue("TOTAL")
            cellFooter.setCellStyle(styleFooter)

            cellFooter = totalRow.createCell((short) curCol)
            curCol++
            cellFooter.setCellValue(totales['' + (anio.anio.toInteger() - 1)])
            cellFooter.setCellStyle(styleFooter)

            cellFooter = totalRow.createCell((short) curCol)
            curCol++
            cellFooter.setCellValue(totales[anio.anio])
            cellFooter.setCellStyle(styleFooter)

            cellFooter = totalRow.createCell((short) curCol)
            curCol++
            cellFooter.setCellValue(totales["T" + anio.anio])
            cellFooter.setCellStyle(styleFooter)

            data.anios.each { a ->
                cellFooter = totalRow.createCell((short) curCol)
                curCol++
                cellFooter.setCellValue(totales[a])
                cellFooter.setCellStyle(styleFooter)
            }

            cellFooter = totalRow.createCell((short) curCol)
            cellFooter.setCellValue(totales["T"])
            cellFooter.setCellStyle(styleFooter)

            (iniCol..totalCols).each { i ->
                sheet.autoSizeColumn(i) //adjust width of the first column
            }
            def output = response.getOutputStream()
            def header = "attachment; filename=" + "poa_proyecto.xlsx"
            response.setContentType("application/application/vnd.openxmlformats-officedocument.spreadsheetml.sheet")
            response.setHeader("Content-Disposition", header)
            wb.write(output)
            output.flush()
        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }
}
