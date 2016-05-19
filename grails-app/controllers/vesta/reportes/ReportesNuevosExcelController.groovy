package vesta.reportes

import org.apache.poi.ss.usermodel.CellStyle
import org.apache.poi.ss.usermodel.DataFormat
import org.apache.poi.ss.usermodel.Font
import org.apache.poi.ss.usermodel.IndexedColors
import org.apache.poi.ss.util.CellRangeAddress
import org.apache.poi.xssf.usermodel.XSSFCell as Cell
import org.apache.poi.xssf.usermodel.XSSFColor
import org.apache.poi.xssf.usermodel.XSSFCreationHelper
import org.apache.poi.xssf.usermodel.XSSFRow as Row
import org.apache.poi.xssf.usermodel.XSSFSheet as Sheet
import org.apache.poi.xssf.usermodel.XSSFWorkbook as Workbook
import vesta.parametros.poaPac.Fuente


class ReportesNuevosExcelController {

    public static getEstilos(Workbook wb) {

        XSSFCreationHelper createHelper = wb.getCreationHelper();
        def numberFormat = createHelper.createDataFormat().getFormat('#,##0.00')
        def dateFormat = createHelper.createDataFormat().getFormat("dd-MM-yyyy")

        Font fontYachay = wb.createFont()
        fontYachay.setFontHeightInPoints((short) 12)
        fontYachay.setBold(true)

        Font fontTitulo = wb.createFont()
        fontTitulo.setFontHeightInPoints((short) 12)
        fontTitulo.setBold(true)

        Font fontSubtitulo = wb.createFont()
        fontSubtitulo.setFontHeightInPoints((short) 12)
        fontSubtitulo.setBold(true)

        Font fontHeader = wb.createFont()
        fontHeader.setFontHeightInPoints((short) 9)
        fontHeader.setColor(new XSSFColor(new java.awt.Color(255, 255, 255)))
        fontHeader.setBold(true)

        Font fontTabla = wb.createFont()
        fontTabla.setFontHeightInPoints((short) 9)

        Font fontSubtotal = wb.createFont()
        fontSubtotal.setFontHeightInPoints((short) 9)
        fontSubtotal.setBold(true)

        Font fontFecha = wb.createFont()
        fontFecha.setFontHeightInPoints((short) 9)

        Font fontFooter = wb.createFont()
        fontFooter.setFontHeightInPoints((short) 9)
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

        CellStyle styleFecha = wb.createCellStyle()
        styleFecha.setVerticalAlignment(CellStyle.VERTICAL_CENTER)
        styleFecha.setFont(fontFecha)
        styleFecha.setWrapText(true);

        CellStyle styleTabla = wb.createCellStyle()
        styleTabla.setVerticalAlignment(CellStyle.VERTICAL_CENTER)
        styleTabla.setFont(fontTabla)
        styleTabla.setWrapText(true);
        styleTabla.setBorderBottom(CellStyle.BORDER_THIN);
        styleTabla.setBottomBorderColor(IndexedColors.BLACK.getIndex());
        styleTabla.setBorderLeft(CellStyle.BORDER_THIN);
        styleTabla.setLeftBorderColor(IndexedColors.BLACK.getIndex());
        styleTabla.setBorderRight(CellStyle.BORDER_THIN);
        styleTabla.setRightBorderColor(IndexedColors.BLACK.getIndex());
        styleTabla.setBorderTop(CellStyle.BORDER_THIN);
        styleTabla.setTopBorderColor(IndexedColors.BLACK.getIndex());

        CellStyle styleDate = styleTabla.clone()
        styleDate.setDataFormat(dateFormat);

        CellStyle styleNumber = styleTabla.clone()
        styleNumber.setDataFormat(numberFormat);

        CellStyle styleSubtotal = styleTabla.clone()
        styleSubtotal.setFont(fontSubtotal)
        styleSubtotal.setAlignment(CellStyle.ALIGN_CENTER)
        styleSubtotal.setFillForegroundColor(new XSSFColor(new java.awt.Color(111, 169, 237)));
        styleSubtotal.setFillPattern(CellStyle.SOLID_FOREGROUND)

        CellStyle styleSubtotalNumber = styleSubtotal.clone()
        styleSubtotalNumber.setAlignment(CellStyle.ALIGN_RIGHT)
        styleSubtotalNumber.setDataFormat(numberFormat);

        CellStyle styleFooterText = styleTabla.clone()
        styleFooterText.setFont(fontFooter)
        styleFooterText.setFillForegroundColor(new XSSFColor(new java.awt.Color(200, 200, 200)));
        styleFooterText.setFillPattern(CellStyle.SOLID_FOREGROUND)

        CellStyle styleFooterCenter = styleFooterText.clone()
        styleFooterCenter.setAlignment(CellStyle.ALIGN_RIGHT)

        CellStyle styleFooter = styleFooterText.clone()
        styleFooter.setDataFormat(numberFormat);

        return [styleYachay    : styleYachay, styleTitulo: styleTitulo, styleSubtitulo: styleSubtitulo, styleHeader: styleHeader,
                styleNumber    : styleNumber, styleFooter: styleFooter, styleDate: styleDate,
                styleSubtotal  : styleSubtotal, styleSubtotalNumber: styleSubtotalNumber, styleTabla: styleTabla,
                styleFooterText: styleFooterText, styleFooterCenter: styleFooterCenter, styleFecha: styleFecha]
    }

    public static setTitulos(Sheet sheet, estilos, int iniRow, int iniCol, String titulo, String subtitulo) {
        CellStyle styleYachay = estilos.styleYachay
        CellStyle styleTitulo = estilos.styleTitulo
        CellStyle styleSubtitulo = estilos.styleSubtitulo
        CellStyle styleFecha = estilos.styleFecha

        def curRow = iniRow

        Row rowYachay = sheet.createRow((short) curRow)
        Cell cellYachay = rowYachay.createCell((short) iniCol)
        cellYachay.setCellValue("EMPRESA PÚBLICA YACHAY EP")
        cellYachay.setCellStyle(styleYachay)
        curRow++

        Row rowTitulo = sheet.createRow((short) curRow)
        Cell cellTitulo = rowTitulo.createCell((short) iniCol)
        cellTitulo.setCellValue(titulo)
        cellTitulo.setCellStyle(styleTitulo)
        curRow++

        if (subtitulo && subtitulo != "") {
            Row rowSubtitulo = sheet.createRow((short) curRow)
            Cell cellSubtitulo = rowSubtitulo.createCell((short) iniCol + 3)
            cellSubtitulo.setCellValue(subtitulo)
            cellSubtitulo.setCellStyle(styleTitulo)
            curRow++
        }

        Row rowFecha = sheet.createRow((short) curRow)
        Cell cellFecha = rowFecha.createCell((short) iniCol + 1)
        cellFecha.setCellValue("Fecha del reporte: " + new Date().format("dd-MM-yyyy HH:mm"))
        cellFecha.setCellStyle(styleFecha)
        curRow++

        return curRow
    }



    public static joinTitulos(Sheet sheet, int iniRow, int iniCol, int totalCols) {
        joinTitulos(sheet, iniRow, iniCol, totalCols, true)
    }

    public static joinTitulos(Sheet sheet, int iniRow, int iniCol, int totalCols, boolean subtitulo) {
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
        if (subtitulo) {
            sheet.addMergedRegion(new CellRangeAddress(
                    iniRow + 2, //first row (0-based)
                    iniRow + 2, //last row  (0-based)
                    iniCol, //first column (0-based)
                    totalCols   //last column  (0-based)
            ))
            sheet.addMergedRegion(new CellRangeAddress(
                    iniRow + 3, //first row (0-based)
                    iniRow + 3, //last row  (0-based)
                    iniCol + 1, //first column (0-based)
                    iniCol + 2   //last column  (0-based)
            ))
        } else {
            sheet.addMergedRegion(new CellRangeAddress(
                    iniRow + 2, //first row (0-based)
                    iniRow + 2, //last row  (0-based)
                    iniCol + 1, //first column (0-based)
                    iniCol + 2   //last column  (0-based)
            ))
        }
    }

    def poaGrupoGastoXls() {
        def fuente = Fuente.get(params.fnt.toLong())
        def reportes = new ReportesNuevosController()
        def data = reportes.poaGrupoGastos_funcion(fuente)
        def anio = data.anio
        def totales = data.totales

        def iniRow = 0
        def iniCol = 1

        def curRow = iniRow
        def curCol = iniCol

        try {
            Workbook wb = new Workbook()
            Sheet sheet = wb.createSheet("POA por grupo de gastos")
            // Create a new font and alter it.
            def estilos = getEstilos(wb)
            CellStyle styleHeader = estilos.styleHeader
            CellStyle styleTabla = estilos.styleTabla
            CellStyle styleNumber = estilos.styleNumber
            CellStyle styleFooter = estilos.styleFooter
            CellStyle styleFooterCenter = estilos.styleFooterCenter

            // Create a row and put some cells in it. Rows are 0 based.
            def titulo = "PLAN OPERATIVO ANUAL POA " + anio.anio
            def subtitulo = "RESUMEN POR GRUPO DE GASTO" + (fuente ? " - FUENTE " + fuente.toString() : "")
            curRow = setTitulos(sheet, estilos, iniRow, iniCol, titulo, subtitulo)

            Row rowHeader = sheet.createRow((short) curRow)
            Cell cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("GRUPO DE GASTO")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 3000)
            curCol++

            cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("DESCRIPCIÓN")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 12500)
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
            curRow++

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

            joinTitulos(sheet, iniRow, iniCol, totalCols)

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
                def str = v.valores["" + (anio.anio.toInteger() - 1)] ?: 0
                tableCell = tableRow.createCell(curCol)
                tableCell.setCellValue(str)
                tableCell.setCellStyle(styleNumber)
                curCol++
                str = v.valores[anio.anio] ?: 0
                tableCell = tableRow.createCell(curCol)
                tableCell.setCellValue(str)
                tableCell.setCellStyle(styleNumber)
                curCol++
                str = v.valores["T" + anio.anio] ?: 0
                tableCell = tableRow.createCell(curCol)
                tableCell.setCellValue(str)
                tableCell.setCellStyle(styleNumber)
                curCol++
                data.anios.each { a ->
                    str = v.valores[a] ?: 0
                    tableCell = tableRow.createCell(curCol)
                    tableCell.setCellValue(str)
                    tableCell.setCellStyle(styleNumber)
                    curCol++
                }
                tableCell = tableRow.createCell(curCol)
                tableCell.setCellValue(v.valores["T"] ?: 0)
                tableCell.setCellStyle(styleNumber)
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
            def estilos = getEstilos(wb)
            CellStyle styleHeader = estilos.styleHeader
            CellStyle styleTabla = estilos.styleTabla
            CellStyle styleNumber = estilos.styleNumber
            CellStyle styleFooter = estilos.styleFooter
            CellStyle styleFooterCenter = estilos.styleFooterCenter

            // Create a row and put some cells in it. Rows are 0 based.
            def titulo = "PLANIFICACIÓN OPERATIVA ANUAL - POA AÑO " + anio.anio
            def subtitulo = "RESUMEN POR UNIDAD EJECUTORA"
            curRow = setTitulos(sheet, estilos, iniRow, iniCol, titulo, subtitulo)

            Row rowHeader = sheet.createRow((short) curRow)
            Cell cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("NÚMERO")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 2000)
            curRow++
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

            joinTitulos(sheet, iniRow, iniCol, totalCols)

            data.data.eachWithIndex { v, k ->
                curCol = iniCol
                Row tableRow = sheet.createRow((short) curRow)
                def tableCell = tableRow.createCell(curCol)
                tableCell.setCellValue("" + (k + 1))
                tableCell.setCellStyle(styleTabla)
                curCol++
                tableCell = tableRow.createCell(curCol)
                tableCell.setCellValue("" + v.unidad.nombre)
                tableCell.setCellStyle(styleTabla)
                curCol++
                tableCell = tableRow.createCell(curCol)
                tableCell.setCellValue(v.unidad.codigo)
                tableCell.setCellStyle(styleTabla)
                curCol++
                def str = v.valores["" + (anio.anio.toInteger() - 1)] ?: 0
                tableCell = tableRow.createCell(curCol)
                tableCell.setCellValue(str)
                tableCell.setCellStyle(styleNumber)
                curCol++
                str = v.valores[anio.anio] ?: 0
                tableCell = tableRow.createCell(curCol)
                tableCell.setCellValue(str)
                tableCell.setCellStyle(styleNumber)
                curCol++
                str = v.valores["T" + anio.anio] ?: 0
                tableCell = tableRow.createCell(curCol)
                tableCell.setCellValue(str)
                tableCell.setCellStyle(styleNumber)
                curCol++
                data.anios.each { a ->
                    str = v.valores[a] ?: 0
                    tableCell = tableRow.createCell(curCol)
                    tableCell.setCellValue(str)
                    tableCell.setCellStyle(styleNumber)
                    curCol++
                }
                tableCell = tableRow.createCell(curCol)
                tableCell.setCellValue(v.valores["T"] ?: 0)
                tableCell.setCellStyle(styleNumber)
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
            def header = "attachment; filename=" + "poa_unidad_ejecutora.xlsx"
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
        def iniCol = 1

        def curRow = iniRow
        def curCol = iniCol

        try {
            Workbook wb = new Workbook()
            Sheet sheet = wb.createSheet("POA por proyecto")
            // Create a new font and alter it.
            def estilos = getEstilos(wb)
            CellStyle styleHeader = estilos.styleHeader
            CellStyle styleTabla = estilos.styleTabla
            CellStyle styleNumber = estilos.styleNumber
            CellStyle styleFooter = estilos.styleFooter
            CellStyle styleFooterCenter = estilos.styleFooterCenter

            def titulo = "PLAN OPERATIVO ANUAL POA " + anio.anio
            def subtitulo = "RESUMEN POR PROYECTO"
            curRow = setTitulos(sheet, estilos, iniRow, iniCol, titulo, subtitulo)

            Row rowHeader = sheet.createRow((short) curRow)
            Cell cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("NÚMERO")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 2000)
            curCol++

            cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("PROYECTO")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 12500)
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
            curRow++

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

            joinTitulos(sheet, iniRow, iniCol, totalCols)

            data.data.eachWithIndex { v, k ->
                curCol = iniCol
                Row tableRow = sheet.createRow((short) curRow)
                def tableCell = tableRow.createCell(curCol)
                tableCell.setCellValue("" + (k + 1))
                tableCell.setCellStyle(styleTabla)
                curCol++
                tableCell = tableRow.createCell(curCol)
                tableCell.setCellValue("" + v.proyecto.toStringCompleto())
                tableCell.setCellStyle(styleTabla)
                curCol++
                def str = v.valores["" + (anio.anio.toInteger() - 1)] ?: 0
                tableCell = tableRow.createCell(curCol)
                tableCell.setCellValue(str)
                tableCell.setCellStyle(styleNumber)
                curCol++
                str = v.valores[anio.anio] ?: 0
                tableCell = tableRow.createCell(curCol)
                tableCell.setCellValue(str)
                tableCell.setCellStyle(styleNumber)
                curCol++
                str = v.valores["T" + anio.anio] ?: 0
                tableCell = tableRow.createCell(curCol)
                tableCell.setCellValue(str)
                tableCell.setCellStyle(styleNumber)
                curCol++
                data.anios.each { a ->
                    str = v.valores[a] ?: 0
                    tableCell = tableRow.createCell(curCol)
                    tableCell.setCellValue(str)
                    tableCell.setCellStyle(styleNumber)
                    curCol++
                }
                tableCell = tableRow.createCell(curCol)
                tableCell.setCellValue(v.valores["T"] ?: 0)
                tableCell.setCellStyle(styleNumber)
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

    def poaFuenteXls() {
        def reportes = new ReportesNuevosController()
        def data = reportes.poaFuente_funcion()
        def anio = data.anio
        def totales = data.totales

        def iniRow = 0
        def iniCol = 1

        def curRow = iniRow
        def curCol = iniCol

        try {
            Workbook wb = new Workbook()
            Sheet sheet = wb.createSheet("POA por fuente de financiamiento")
            // Create a new font and alter it.
            def estilos = getEstilos(wb)
            CellStyle styleHeader = estilos.styleHeader
            CellStyle styleTabla = estilos.styleTabla
            CellStyle styleNumber = estilos.styleNumber
            CellStyle styleFooter = estilos.styleFooter
            CellStyle styleFooterCenter = estilos.styleFooterCenter

            // Create a row and put some cells in it. Rows are 0 based.
            def titulo = "PLAN OPERATIVO ANUAL POA " + anio.anio
            def subtitulo = "RESUMEN POR FUENTE DE FINANCIAMIENTO"
            curRow = setTitulos(sheet, estilos, iniRow, iniCol, titulo, subtitulo)

            Row rowHeader = sheet.createRow((short) curRow)
            Cell cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("FUENTE DE FINANCIAMIENTO")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 4000)
            curCol++

            cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("DESCRIPCIÓN")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 12500)
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
            curRow++

            joinTitulos(sheet, iniRow, iniCol, totalCols)

            data.data.eachWithIndex { v, k ->
                curCol = iniCol
                Row tableRow = sheet.createRow((short) curRow)
                def tableCell = tableRow.createCell(curCol)
                tableCell.setCellValue(v.fuente.codigo)
                tableCell.setCellStyle(styleTabla)
                curCol++
                tableCell = tableRow.createCell(curCol)
                tableCell.setCellValue("" + v.fuente.descripcion)
                tableCell.setCellStyle(styleTabla)
                curCol++
                def str = v.valores[anio.anio] ?: 0
                tableCell = tableRow.createCell(curCol)
                tableCell.setCellValue(str)
                tableCell.setCellStyle(styleNumber)
                curCol++
                str = v.valores["T" + anio.anio] ?: 0
                tableCell = tableRow.createCell(curCol)
                tableCell.setCellValue(str)
                tableCell.setCellStyle(styleNumber)
                curCol++
                data.anios.each { a ->
                    str = v.valores[a] ?: 0
                    tableCell = tableRow.createCell(curCol)
                    tableCell.setCellValue(str)
                    tableCell.setCellStyle(styleNumber)
                    curCol++
                }
                tableCell = tableRow.createCell(curCol)
                tableCell.setCellValue(v.valores["T"] ?: 0)
                tableCell.setCellStyle(styleNumber)
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

            def output = response.getOutputStream()
            def header = "attachment; filename=" + "poa_fuente_financiamiento.xlsx"
            response.setContentType("application/application/vnd.openxmlformats-officedocument.spreadsheetml.sheet")
            response.setHeader("Content-Disposition", header)
            wb.write(output)
            output.flush()
        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }
}
