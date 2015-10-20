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
                tableCell.setCellValue(v?.actividad?.responsable?.gerencia?.nombre)
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

        return [data: data, totales: totales, titulo: titulo, subtitulo: subtitulo]
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

//        println("params excel p " + params)


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

}
