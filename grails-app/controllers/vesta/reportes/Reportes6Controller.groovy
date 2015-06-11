package vesta.reportes

import org.apache.poi.ss.usermodel.CellStyle
import org.apache.poi.ss.util.CellRangeAddress
import org.apache.poi.xssf.usermodel.XSSFCell as Cell
import org.apache.poi.xssf.usermodel.XSSFRow as Row
import org.apache.poi.xssf.usermodel.XSSFSheet as Sheet
import org.apache.poi.xssf.usermodel.XSSFWorkbook as Workbook
import vesta.avales.Aval
import vesta.avales.EstadoAval
import vesta.avales.ProcesoAsignacion
import vesta.parametros.poaPac.Fuente
import vesta.parametros.poaPac.Presupuesto
import vesta.poa.Asignacion

class Reportes6Controller {

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
                tableCell.setCellValue(v.partida.numero[0..1])
                tableCell.setCellStyle(styleTabla)
                curCol++

                tableCell = tableRow.createCell(curCol)
                tableCell.setCellValue(v.actividad.numero)
                tableCell.setCellStyle(styleTabla)
                curCol++

                tableCell = tableRow.createCell(curCol)
                tableCell.setCellValue(v.actividad.toStringCompleto())
                tableCell.setCellStyle(styleTabla)
                curCol++

                tableCell = tableRow.createCell(curCol)
                tableCell.setCellValue(v.actividad.responsable.gerencia.nombre)
                tableCell.setCellStyle(styleTabla)
                curCol++

                tableCell = tableRow.createCell(curCol)
                tableCell.setCellValue(v.valores.priorizado)
                tableCell.setCellStyle(styleNumber)
                curCol++

                tableCell = tableRow.createCell(curCol)
                tableCell.setCellValue(v.valores.avales)
                tableCell.setCellStyle(styleNumber)
                curCol++

                tableCell = tableRow.createCell(curCol)
                tableCell.setCellValue(v.valores.disponible)
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

        return [data: data, totales: totales, titulo: titulo, subtitulo: subtitulo]
    }

    def disponibilidadFuente_funcion(Fuente fuente) {
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
            }
            asignaciones.each { asg ->
                def actividad = asg.marcoLogico

                def key = numero + "_" + actividad.id

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
}
