package vesta.reportes

import jxl.Workbook
import org.apache.poi.ss.usermodel.IndexedColors
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
                def anioAsg = asg.anio
                if (anioAsg.id == anio.id) {
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
        def fuente = Fuente.get(params.id)
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

    def reporteAvalesExcel() {
        def cn = dbConnectionService.getConnection()
        def tx = "select avalnmro, avalfcap, prconmbr, unejnmbr, sum(poasmnto), fnte__id " +
                "from prco, slav, unej, aval, poas, asgn " +
                "where slav.prco__id = prco.prco__id and unej.unej__Id = slav.unej__id and " +
                "aval.prco__id = prco.prco__id and poas.prco__id = prco.prco__id and " +
                "asgn.asgn__id = poas.asgn__id " +
                "group by avalnmro, avalfcap, prconmbr, unejnmbr, avalnmro, avalfcap, fnte__id " +
                "order by avalnmro, fnte__id;"

//        println("params " + params)
        cn.eachRow(tx.toString()) {d ->
           println d.unejnmbr
        }
        cn.close()


        def fuente = Fuente.get(params.fnt.toLong())
        def proceso = ProcesoAsignacion.withCriteria {
            asignacion {
                eq('fuente', fuente)
                groupProperty('marcoLogico')
            }
        }
        def procesosAval = []
        def avales = []

        proceso.each {
            procesosAval += it.proceso
        }


        procesosAval.each {
            avales += Aval.findAllByProceso(it)
        }

//        println("proceso " + proceso)
//        println("proceso aval " + procesosAval)
//        println("avales " + avales)

        def iniRow = 2
        def iniCol = 1

        def curRow = iniRow
        def curCol = iniCol

        try {

            Workbook wb = new Workbook()
            Sheet sheet = wb.createSheet("Reporte de Avales")

            Font fontYachay = wb.createFont()
            fontYachay.setFontHeightInPoints((short) 14)
            fontYachay.setColor(new XSSFColor(new java.awt.Color(23, 54, 93)))
            fontYachay.setBold(true)

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
            styleTabla.setBorderTop(CellStyle.BORDER_THIN);
            styleTabla.setTopBorderColor(IndexedColors.BLACK.getIndex());

            CellStyle styleFooter = wb.createCellStyle()
            styleFooter.setFont(fontFooter)
            styleFooter.setFillForegroundColor(new XSSFColor(new java.awt.Color(200, 200, 200)));
            styleFooter.setFillPattern(CellStyle.SOLID_FOREGROUND)
            styleFooter.setBorderBottom(CellStyle.BORDER_THIN);
            styleFooter.setBottomBorderColor(IndexedColors.BLACK.getIndex());
            styleFooter.setBorderTop(CellStyle.BORDER_THIN);
            styleFooter.setTopBorderColor(IndexedColors.BLACK.getIndex());
            styleFooter.setBorderLeft(CellStyle.BORDER_THIN);
            styleFooter.setLeftBorderColor(IndexedColors.BLACK.getIndex());
            styleFooter.setBorderRight(CellStyle.BORDER_THIN);
            styleFooter.setRightBorderColor(IndexedColors.BLACK.getIndex());

            CellStyle styleFooterCenter = wb.createCellStyle()
            styleFooterCenter.setFont(fontFooter)
            styleFooterCenter.setAlignment(CellStyle.ALIGN_CENTER)
            styleFooterCenter.setVerticalAlignment(CellStyle.VERTICAL_CENTER)

            styleFooterCenter.setBorderBottom(CellStyle.BORDER_THIN);
            styleFooterCenter.setBottomBorderColor(IndexedColors.BLACK.getIndex());
            styleFooterCenter.setBorderTop(CellStyle.BORDER_MEDIUM_DASHED);
            styleFooterCenter.setTopBorderColor(IndexedColors.BLACK.getIndex());
            styleFooterCenter.setFillForegroundColor(new XSSFColor(new java.awt.Color(200, 200, 200)));
            styleFooterCenter.setFillPattern(CellStyle.SOLID_FOREGROUND)


            Row rowYachay = sheet.createRow((short) curRow)
            curRow++
            Cell cellTitulo = rowYachay.createCell((short) 3)
            cellTitulo.setCellValue("EMPRESA PÚBLICA YACHAY EP")
            cellTitulo.setCellStyle(styleYachay)

            Row rowSubtitulo = sheet.createRow((short) curRow)
            curRow++
            Cell cellSubtitulo = rowSubtitulo.createCell((short) 3)
            cellSubtitulo.setCellValue("REPORTE DE AVALES")
            cellSubtitulo.setCellStyle(styleSubtitulo)

            Row rowFecha = sheet.createRow((short) curRow)
            curRow++
            Cell cellFecha = rowFecha.createCell((short) 1)
            cellFecha.setCellValue("Fecha del reporte: " + new Date().format("dd-MM-yyyy HH:mm"))

            Row rowHeader = sheet.createRow((short) curRow)
            rowSubtitulo.setHeightInPoints(30)
            curRow++
            Cell cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("N° AVAL")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 2000)
            curCol++

            cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("FECHA EMISIÓN AVAL")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 2000)
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
            cellHeader.setCellValue("RESPONSABLE")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 10000)
            curCol++

            def totalCols = curCol
            def totalPriorizado = 0

            proceso.each {
                curCol = iniCol
                Row tableRow = sheet.createRow((short) curRow)
                Cell cellTabla = tableRow.createCell((short) curCol)

                cellTabla.setCellValue(it.asignacion.marcoLogico.numero)
                cellTabla.setCellStyle(styleTabla)
                curCol++
                cellTabla = tableRow.createCell((short) curCol)
                cellTabla.setCellValue(it.asignacion.anio.anio)
                cellTabla.setCellStyle(styleTabla)
                curCol++
                cellTabla = tableRow.createCell((short) curCol)
                cellTabla.setCellValue(it.asignacion.marcoLogico.toStringCompleto())
                cellTabla.setCellStyle(styleTabla)
                curCol++
                cellTabla = tableRow.createCell((short) curCol)
                cellTabla.setCellValue(it.asignacion.priorizado)
                cellTabla.setCellStyle(styleTabla)
                totalPriorizado += it.asignacion.priorizado
                curCol++
                cellTabla = tableRow.createCell((short) curCol)
                cellTabla.setCellValue(it.asignacion.marcoLogico.responsable.nombre)
                cellTabla.setCellStyle(styleTabla)
                curCol++
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
            cellFooter.setCellValue("")
            cellFooter.setCellStyle(styleFooter)

            cellFooter = totalRow.createCell((short) curCol)
            curCol++
            cellFooter.setCellValue("TOTAL")
            cellFooter.setCellStyle(styleFooter)

            cellFooter = totalRow.createCell((short) curCol)
            curCol++
            cellFooter.setCellValue(totalPriorizado)
            cellFooter.setCellStyle(styleFooter)


            cellFooter = totalRow.createCell((short) curCol)
            curCol++
            cellFooter.setCellValue("")
            cellFooter.setCellStyle(styleFooter)


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

        def fuente = Fuente.get(params.fnt.toLong())

        def modificacion = ModificacionAsignacion.withCriteria {
            desde {
                eq("fuente", fuente)
            }
        }

        def iniRow = 2
        def iniCol = 1

        def curRow = iniRow
        def curCol = iniCol

        try {

            Workbook wb = new Workbook()
            Sheet sheet = wb.createSheet("Reporte de reformas")

            Font fontYachay = wb.createFont()
            fontYachay.setFontHeightInPoints((short) 14)
            fontYachay.setColor(new XSSFColor(new java.awt.Color(23, 54, 93)))
            fontYachay.setBold(true)

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
            styleTabla.setBorderTop(CellStyle.BORDER_THIN);
            styleTabla.setTopBorderColor(IndexedColors.BLACK.getIndex());

            CellStyle styleFooter = wb.createCellStyle()
            styleFooter.setFont(fontFooter)
            styleFooter.setFillForegroundColor(new XSSFColor(new java.awt.Color(200, 200, 200)));
            styleFooter.setFillPattern(CellStyle.SOLID_FOREGROUND)
            styleFooter.setBorderBottom(CellStyle.BORDER_THIN);
            styleFooter.setBottomBorderColor(IndexedColors.BLACK.getIndex());
            styleFooter.setBorderTop(CellStyle.BORDER_THIN);
            styleFooter.setTopBorderColor(IndexedColors.BLACK.getIndex());
            styleFooter.setBorderLeft(CellStyle.BORDER_THIN);
            styleFooter.setLeftBorderColor(IndexedColors.BLACK.getIndex());
            styleFooter.setBorderRight(CellStyle.BORDER_THIN);
            styleFooter.setRightBorderColor(IndexedColors.BLACK.getIndex());

            CellStyle styleFooterCenter = wb.createCellStyle()
            styleFooterCenter.setFont(fontFooter)
            styleFooterCenter.setAlignment(CellStyle.ALIGN_CENTER)
            styleFooterCenter.setVerticalAlignment(CellStyle.VERTICAL_CENTER)

            styleFooterCenter.setBorderBottom(CellStyle.BORDER_THIN);
            styleFooterCenter.setBottomBorderColor(IndexedColors.BLACK.getIndex());
            styleFooterCenter.setBorderTop(CellStyle.BORDER_MEDIUM_DASHED);
            styleFooterCenter.setTopBorderColor(IndexedColors.BLACK.getIndex());
            styleFooterCenter.setFillForegroundColor(new XSSFColor(new java.awt.Color(200, 200, 200)));
            styleFooterCenter.setFillPattern(CellStyle.SOLID_FOREGROUND)


            Row rowYachay = sheet.createRow((short) curRow)
            curRow++
            Cell cellTitulo = rowYachay.createCell((short) 4)
            cellTitulo.setCellValue("EMPRESA PÚBLICA YACHAY EP")
            cellTitulo.setCellStyle(styleYachay)

            Row rowSubtitulo = sheet.createRow((short) curRow)
            curRow++
            Cell cellSubtitulo = rowSubtitulo.createCell((short) 4)
            cellSubtitulo.setCellValue("REPORTE DE REFORMAS Y AJUSTES")
            cellSubtitulo.setCellStyle(styleSubtitulo)

            Row rowFecha = sheet.createRow((short) curRow)
            curRow++
            Cell cellFecha = rowFecha.createCell((short) 1)
            cellFecha.setCellValue("Fecha del reporte: " + new Date().format("dd-MM-yyyy HH:mm"))

            Row rowHeader = sheet.createRow((short) curRow)
            rowSubtitulo.setHeightInPoints(30)
            curRow++
            Cell cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("C")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 2000)
            curCol++

            cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("P")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 2000)
            curCol++

            cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("N°")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 2000)
            curCol++

            cellHeader = rowHeader.createCell((short) curCol)
            cellHeader.setCellValue("ACTIVIDAD")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 20000)
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
            cellHeader.setCellValue("VALOR CODIFICADO")
            cellHeader.setCellStyle(styleHeader)
            sheet.setColumnWidth(curCol, 4000)
            curCol++


            def totalCols = curCol
            def totalInicial = 0
            def totalFinal = 0

//            println("mod " + modificacion)

            modificacion.each {
                curCol = iniCol
                Row tableRow = sheet.createRow((short) curRow)
                Cell cellTabla = tableRow.createCell((short) curCol)

                Row tableRow2 = sheet.createRow((short) curRow + 1)
                Cell cellTabla2 = tableRow2.createCell((short) curCol)

                cellTabla.setCellValue(it?.desde?.programa?.descripcion)
                cellTabla.setCellStyle(styleTabla)
                cellTabla2.setCellValue(it?.recibe?.programa?.descripcion)
                cellTabla2.setCellStyle(styleTabla)
                curCol++
                cellTabla = tableRow.createCell((short) curCol)
                cellTabla.setCellValue(it?.desde?.componente?.descripcion)
                cellTabla.setCellStyle(styleTabla)
                cellTabla2 = tableRow2.createCell((short) curCol)
                cellTabla2.setCellValue(it?.recibe?.componente?.descripcion)
                cellTabla2.setCellStyle(styleTabla)
                curCol++
                cellTabla = tableRow.createCell((short) curCol)
                cellTabla.setCellValue(it.desde.marcoLogico.numero)
                cellTabla.setCellStyle(styleTabla)
                cellTabla2 = tableRow2.createCell((short) curCol)
                cellTabla2.setCellValue(it.recibe.marcoLogico.numero)
                cellTabla2.setCellStyle(styleTabla)
                curCol++
                cellTabla = tableRow.createCell((short) curCol)
                cellTabla.setCellValue(it.desde.marcoLogico.toStringCompleto())
                cellTabla.setCellStyle(styleTabla)
                cellTabla2 = tableRow2.createCell((short) curCol)
                cellTabla2.setCellValue(it.recibe.marcoLogico.toStringCompleto())
                cellTabla2.setCellStyle(styleTabla)
                curCol++
                cellTabla = tableRow.createCell((short) curCol)
                cellTabla.setCellValue(it.originalOrigen)
                cellTabla.setCellStyle(styleTabla)
                cellTabla2 = tableRow2.createCell((short) curCol)
                cellTabla2.setCellValue(it.originalDestino)
                cellTabla2.setCellStyle(styleTabla)
                totalInicial += (it.originalOrigen + it.originalDestino)
                curCol++
                cellTabla = tableRow.createCell((short) curCol)
                cellTabla.setCellValue(it.valor)
                cellTabla.setCellStyle(styleTabla)
                cellTabla2 = tableRow2.createCell((short) curCol)
                cellTabla2.setCellValue('')
                cellTabla2.setCellStyle(styleTabla)
                curCol++
                cellTabla = tableRow.createCell((short) curCol)
                cellTabla.setCellValue('')
                cellTabla.setCellStyle(styleTabla)
                cellTabla2 = tableRow2.createCell((short) curCol)
                cellTabla2.setCellValue(it.valor)
                cellTabla2.setCellStyle(styleTabla)
                curCol++
                cellTabla = tableRow.createCell((short) curCol)
                cellTabla.setCellValue(it.originalOrigen + it.valor)
                cellTabla.setCellStyle(styleTabla)
                cellTabla2 = tableRow2.createCell((short) curCol)
                cellTabla2.setCellValue(it.originalDestino - it.valor)
                cellTabla2.setCellStyle(styleTabla)
                totalFinal += ((it.originalOrigen + it.valor) + (it.originalDestino - it.valor))
                curCol++
                curRow++

            }


            curCol = iniCol
            Row totalRow = sheet.createRow((short) curRow + 1)
            Cell cellFooter = totalRow.createCell((short) curCol)
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
            cellFooter.setCellValue('TOTAL')
            cellFooter.setCellStyle(styleFooter)

            cellFooter = totalRow.createCell((short) curCol)
            curCol++
            cellFooter.setCellValue(totalInicial)
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
            cellFooter.setCellValue(totalFinal)
            cellFooter.setCellStyle(styleFooter)


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

    def reportePdfAvales() {

        def fuente = Fuente.get(params.fnt.toLong())
        def proceso = ProcesoAsignacion.withCriteria {
            asignacion {
                eq('fuente', fuente)
                groupProperty('marcoLogico')
            }
        }

        return [proceso: proceso]

    }

    def reporteEgresosGastosPdf() {

        def data = poaGrupoGastosPlanificado_funcion()
        return [anio: data.anio, data: data.data, anios: data.anios, totales: data.totales]


    }

    def reporteEgresosGastosExcel() {


        def reportes = new ReportesNuevosController()
        def data = poaGrupoGastosPlanificado_funcion()
        def anio = data.anio
        def totales = data.totales

        def iniRow = 2
        def iniCol = 1

        def curRow = iniRow
        def curCol = iniCol

        try {

            Workbook wb = new Workbook()
            Sheet sheet = wb.createSheet("Reporte de egresos no permanentes")

            Font fontYachay = wb.createFont()
            fontYachay.setFontHeightInPoints((short) 14)
            fontYachay.setColor(new XSSFColor(new java.awt.Color(23, 54, 93)))
            fontYachay.setBold(true)

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

            Font fontTabla = wb.createFont()
            fontTabla.setFontHeightInPoints((short) 9)

            Font fontFooter = wb.createFont()
            fontHeader.setFontHeightInPoints((short) 9)
            fontFooter.setBold(true)


            def estilos = ReportesNuevosExcelController.getEstilos(wb)
            CellStyle styleHeader = estilos.styleHeader
            CellStyle styleTabla = estilos.styleTabla
            CellStyle styleFooter = estilos.styleFooter
            CellStyle styleFooterCenter = estilos.styleFooterCenter

            // Create a row and put some cells in it. Rows are 0 based.
            def titulo = "REPORTE DE EGRESOS NO PERMANENTES"
            def subtitulo = "GRUPO DE GASTO - EN DÓLARES"
            curRow = ReportesNuevosExcelController.setTitulos(sheet, estilos, iniRow, iniCol, titulo, subtitulo)

//            Row rowFecha = sheet.createRow((short) curRow)
//            curRow++
//            Cell cellFecha = rowFecha.createCell((short) 1)
//            cellFecha.setCellValue("Fecha del reporte: " + new Date().format("dd-MM-yyyy HH:mm"))
//
            Row rowHeader = sheet.createRow((short) curRow)
//            rowSubtitulo.setHeightInPoints(30)
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

                tableRow.createCell(curCol).setCellValue(v.partida.numero.replaceAll("0", ""))
                curCol++
                tableRow.createCell(curCol).setCellValue("" + v.partida.descripcion)
                curCol++
                def str = ""
                str = ""

                data.anios.each { a ->
                    str = ""
                    if (v.valores[a] > 0) {
                        str = v.valores[a]
                    }
                    tableRow.createCell(curCol).setCellValue(str)
                    curCol++
                }
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

            data.anios.each { b ->
                cellFooter = totalRow.createCell((short) curCol)
                curCol++
                cellFooter.setCellValue(totales[b] ?: 0)
                cellFooter.setCellStyle(styleFooter)
            }


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
