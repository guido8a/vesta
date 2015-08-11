package vesta.reportes

import jxl.Workbook
import jxl.WorkbookSettings
import jxl.write.*
import vesta.parametros.PresupuestoUnidad
import vesta.parametros.TipoElemento
import vesta.parametros.UnidadEjecutora
import vesta.parametros.poaPac.Anio
import vesta.poa.Asignacion
import vesta.proyectos.MarcoLogico
import vesta.proyectos.Proyecto
import vesta.seguridad.Persona

class Reportes2Controller {

    def format(val, tipo) {
        if (tipo == "")
            tipo = "text"
        def ret
        if (tipo == "text") {
            ret = val ? val.toString().replaceAll("\\n", "") : ""
        } else if (tipo == "number") {
            ret = val ? val.toDouble().round(2) : 0
        }
        return ret
    }

    /**
     * Acción
     */
    def index = {}

    /**
     * Acción
     */
    def usuariosGUI = {

    }

    /**
     * Acción
     */
    def totales = {
        def actual
        if (params.anio)
            actual = Anio.get(params.anio)
        else
            actual = Anio.findByAnio(new Date().format("yyyy"))
        if (!actual)
            actual = Anio.list([sort: 'anio', order: 'desc']).pop()


        def unidades = UnidadEjecutora.list([sort: 'nombre'])
//        def unidades = UnidadEjecutora.findAllById(103)
        def mapa = [:]
        unidades.each { unj ->

            def totC = 0
            def totI = 0
            Asignacion.findAllByUnidadAndAnio(unj, actual).each { asg ->

                if (asg.marcoLogico) {
                    if (asg.planificado > 0)
                        totI += asg.getValorReal()
//                    else
                    //println "asg 0 "+asg.id+"  valor real "+asg.getValorReal()+" plan "+asg.planificado+" reu "+asg.reubicada

                } else {
                    totC += asg.planificado
                }

            }

            //println "put "+totI+"  "+totC
            mapa.put(unj.nombre, [unj.codigo, totI, totC])

        }

        [actual: actual, mapa: mapa]


    }

    /**
     * Acción
     */
    def usuariosWeb = {
        def usuarios = Persona.list()
        usuarios = usuarios.sort { it.apellido }
        return [usuarios: usuarios]
    }

    /**
     * Acción
     */
    def usuariosPdf = {
        def usuarios = Persona.list()
        usuarios = usuarios.sort { it.apellido }
        return [usuarios: usuarios]
    }

    /**
     * Acción
     */
    def usuariosCsv = {

        WorkbookSettings workbookSettings = new WorkbookSettings()
        workbookSettings.locale = Locale.default
        def file = File.createTempFile('usuarios', '.xls')
        def label
        file.deleteOnExit()

        WritableWorkbook workbook = Workbook.createWorkbook(file, workbookSettings)
        WritableFont font = new WritableFont(WritableFont.ARIAL, 12)
        WritableCellFormat formatXls = new WritableCellFormat(font)
        def row = 2
        WritableSheet sheet = workbook.createSheet('MySheet', 0)
        sheet.setColumnView(1, 30)
        sheet.setColumnView(2, 30)
        sheet.setColumnView(3, 62)
        sheet.setColumnView(4, 13)
        sheet.setColumnView(5, 35)
        sheet.setColumnView(6, 40)

        /*Header*/
        WritableFont times16font = new WritableFont(WritableFont.TIMES, 14, WritableFont.BOLD, true);
        WritableCellFormat times16format = new WritableCellFormat(times16font);
        label = new Label(1, 1, "Apellido", times16format); sheet.addCell(label);
        label = new Label(2, 1, "Nombre", times16format); sheet.addCell(label);
        label = new Label(3, 1, "Unidad", times16format); sheet.addCell(label);
        label = new Label(4, 1, "Teléfono", times16format); sheet.addCell(label);
        label = new Label(5, 1, "Correo", times16format); sheet.addCell(label);
        label = new Label(6, 1, "Cargo", times16format); sheet.addCell(label);


        def usuarios = Persona.list()
        usuarios = usuarios.sort { it.apellido }
        font = new WritableFont(WritableFont.ARIAL, 11)
        formatXls = new WritableCellFormat(font)

        usuarios.each { u ->
            label = new Label(1, row, u.apellido?.toUpperCase(), formatXls); sheet.addCell(label);
            label = new Label(2, row, u.nombre?.toUpperCase(), formatXls); sheet.addCell(label);
            label = new Label(3, row, u.unidad.nombre?.toUpperCase(), formatXls); sheet.addCell(label);
            label = new Label(4, row, u.telefono, formatXls); sheet.addCell(label);
            label = new Label(5, row, u.mail, formatXls); sheet.addCell(label);
            label = new Label(6, row, u.cargo?.toUpperCase(), formatXls); sheet.addCell(label);
            row++

        }

        workbook.write();
        workbook.close();
        def output = response.getOutputStream()
        def header = "attachment; filename=" + "reasignacion.xls";
        response.setContentType("application/octet-stream")
        response.setHeader("Content-Disposition", header);
        output.write(file.getBytes());
    }

    /**
     * Acción
     */
    def techosGUI = {}

    /**
     * Acción
     */
    def techosWeb = {
        def c = PresupuestoUnidad.createCriteria()
        def results = c.list {
            and {
                unidad {
                    order("nombre", "asc")
                }
                order("anio", "asc")
            }
        }
        return [results: results]
    }

    /**
     * Acción
     */
    def techosPdf = {
        def c = PresupuestoUnidad.createCriteria()
        def results = c.list {
            and {
                unidad {
                    order("nombre", "asc")
                }
                order("anio", "asc")
            }
        }
        return [results: results]
    }
    /**
     * Acción
     */
    def techosCsv = {
        def c = PresupuestoUnidad.createCriteria()
        def results = c.list {
            and {
                unidad {
                    order("nombre", "asc")
                }
                order("anio", "asc")
            }
        }

        WorkbookSettings workbookSettings = new WorkbookSettings()
        workbookSettings.locale = Locale.default
        def file = File.createTempFile('techos', '.xls')
        def label
        file.deleteOnExit()

        WritableWorkbook workbook = Workbook.createWorkbook(file, workbookSettings)
        WritableFont font = new WritableFont(WritableFont.ARIAL, 12)
        WritableCellFormat formatXls = new WritableCellFormat(font)
        def row = 2
        WritableSheet sheet = workbook.createSheet('techos', 0)
        sheet.setColumnView(1, 30)
        sheet.setColumnView(2, 30)
        sheet.setColumnView(3, 62)
        sheet.setColumnView(4, 13)
        sheet.setColumnView(5, 35)
        sheet.setColumnView(6, 40)
        sheet.setColumnView(7, 35)
        sheet.setColumnView(8, 35)

        /*Header*/
        WritableFont times16font = new WritableFont(WritableFont.TIMES, 14, WritableFont.BOLD, true);
        WritableCellFormat times16format = new WritableCellFormat(times16font);
        label = new Label(1, 1, "Unidad ejecutora", times16format);
        sheet.addCell(label);
        label = new Label(2, 1, "Año", times16format);
        sheet.addCell(label);
        label = new Label(3, 1, "Objetivo estratégico", times16format);
        sheet.addCell(label);
        label = new Label(4, 1, "Objetivo GPR", times16format);
        sheet.addCell(label);
        label = new Label(5, 1, "Eje programático", times16format);
        sheet.addCell(label);
        label = new Label(6, 1, "Política", times16format);
        sheet.addCell(label);
        label = new Label(7, 1, "Max. corriente", times16format);
        sheet.addCell(label);
        label = new Label(8, 1, "Max. inversión", times16format);
        sheet.addCell(label);

        font = new WritableFont(WritableFont.ARIAL, 11)
        formatXls = new WritableCellFormat(font)

        results.each { u ->
            label = new Label(1, row, u.unidad?.nombre, formatXls);
            sheet.addCell(label);
            label = new Label(2, row, u.anio?.anio, formatXls);
            sheet.addCell(label);
            label = new Label(3, row, u.objetivoEstrategico?.descripcion, formatXls);
            sheet.addCell(label);
            label = new Label(4, row, u.objetivoGobiernoResultado?.descripcion, formatXls);
            sheet.addCell(label);
            label = new Label(5, row, u.ejeProgramatico?.descripcion, formatXls);
            sheet.addCell(label);
            label = new Label(6, row, u.politica?.descripcion, formatXls);
            sheet.addCell(label);
            def number = new Number(7, row, u.maxCorrientes, formatXls);
            sheet.addCell(number);
            number = new Number(8, row, u.maxInversion, formatXls);
            sheet.addCell(number);
            row++

        }

        workbook.write();
        workbook.close();
        def output = response.getOutputStream()
        def header = "attachment; filename=" + "techos.xls";
        response.setContentType("application/octet-stream")
        response.setHeader("Content-Disposition", header);
        output.write(file.getBytes());

//        def arch = ""

//        arch += "Unidad ejecutora" + ";"
//        arch += "Año" + ";"
//        arch += "Objetivo estratégico" + ";"
//        arch += "Objetivo GPR" + ";"
//        arch += "Eje programático" + ";"
//        arch += "Política" + ";"
//        arch += "Max. corriente" + ";"
//        arch += "Max. inversión" + ";"
//        arch += "\n"
//
//        results.each { u ->
//            arch += format(u.unidad?.nombre) + ";"
//            arch += format(u.anio?.anio) + ";"
//            arch += format(u.objetivoEstrategico?.descripcion) + ";"
//            arch += format(u.objetivoGobiernoResultado?.descripcion) + ";"
//            arch += format(u.ejeProgramatico?.descripcion) + ";"
//            arch += format(u.politica?.descripcion) + ";"
//            arch += format(u.maxCorrientes) + ";"
//            arch += format(u.maxInversion) + ";"
//            arch += "\n"
//        }
//
//        response.setHeader("Content-disposition", "attachment; filename=reporte_techos.csv");
//        render(contentType: "text/ csv ", text: "${arch}");
    }


    def reporteAsignacionProyecto = {

//        println("reporteAsignacionProyecto " + params)

        def proyecto = Proyecto.get(params.id)
        def asignaciones = []
        def actual

        if (params.resp || params.comp) {
//            println("con filtro!"  + params.resp + " " + params.comp)

            def unidadE
            def compon

            if (params.resp) {
                unidadE = UnidadEjecutora.findByNombre(params.resp)

//                println("unidad " + unidadE)


                if (params.anio)
                    actual = Anio.get(params.anio)
                else
                    actual = Anio.findByAnio(new Date().format("yyyy"))
                if (!actual)
                    actual = Anio.list([sort: 'anio', order: 'desc']).pop()

                def totalR = 0
                def totalUnidadR = 0
                def maxInvR = 0

                MarcoLogico.withCriteria {
                    eq("proyecto", proyecto)
                    eq("tipoElemento", TipoElemento.get(3))
                    eq("estado", 0)
                    eq("responsable", unidadE)
                    marcoLogico {
                        order("numeroComp", "asc")
                    }
                    order("numero", "asc")
                }.each { ml ->
                    def asig = Asignacion.withCriteria {
                        eq("marcoLogico", ml)
                        eq("anio", actual)
                        order("id", "asc")
                    }
                    if (asig) {
                        asignaciones += asig
                        asig.each { asg ->
                            totalR = totalR + asg.getValorReal()
                        }
                    }
                }

//                MarcoLogico.findAll("from MarcoLogico where proyecto = ${proyecto.id} and tipoElemento=3 and estado=0 and responsable=${unidadE.id}").each {
//                    def asig = Asignacion.findAll("from Asignacion where marcoLogico=${it.id} and anio=${actual.id}  order by id")
//                    if (asig) {
//                        asignaciones += asig
//                        asig.each { asg ->
//                            totalR = totalR + asg.getValorReal()
//                        }
//                    }
//                }

//                asignaciones.sort { it.unidad.nombre }
                def unidad = UnidadEjecutora.findByPadreIsNull()
                maxInvR = PresupuestoUnidad.findByAnioAndUnidad(actual, unidad)?.maxInversion
                if (!maxInvR)
                    maxInvR = 0

                return [asignaciones: asignaciones, actual: actual, proyecto: proyecto, total: totalR, totalUnidad: totalUnidadR, maxInv: maxInvR]

            } else {
                compon = MarcoLogico.findByObjeto(params.comp)

                if (params.anio)
                    actual = Anio.get(params.anio)
                else
                    actual = Anio.findByAnio(new Date().format("yyyy"))
                if (!actual)
                    actual = Anio.list([sort: 'anio', order: 'desc']).pop()

                def total = 0
                def totalUnidad = 0
                def maxInv = 0
                MarcoLogico.withCriteria {
                    eq("proyecto", proyecto)
                    eq("tipoElemento", TipoElemento.get(3))
                    eq("estado", 0)
                    marcoLogico {
                        order("numeroComp", "asc")
                    }
                    order("numero", "asc")
                }.each { ml ->
                    def asig = Asignacion.withCriteria {
                        eq("marcoLogico", ml)
                        eq("anio", actual)
                        order("id", "asc")
                    }
                    if (asig) {
                        asignaciones += asig
                        asig.each { asg ->
                            total = total + asg.getValorReal()
                        }
                    }
                }
//                MarcoLogico.findAll("from MarcoLogico where proyecto = ${proyecto.id} and tipoElemento=3 and estado=0").each {
//                    def asig = Asignacion.findAll("from Asignacion where marcoLogico=${it.id} and anio=${actual.id}   order by id")
//                    if (asig) {
//                        asignaciones += asig
//                        asig.each { asg ->
//                            total = total + asg.getValorReal()
//                        }
//                    }
//                }
//            asignaciones.sort { it.unidad.nombre }
                def unidad = UnidadEjecutora.findByPadreIsNull()
                maxInv = PresupuestoUnidad.findByAnioAndUnidad(actual, unidad)?.maxInversion
                if (!maxInv)
                    maxInv = 0
                return [asignaciones: asignaciones, actual: actual, proyecto: proyecto, total: total, totalUnidad: totalUnidad, maxInv: maxInv]
            }
        } else {
            if (params.anio) {
                actual = Anio.get(params.anio)
            } else {
                actual = Anio.findByAnio(new Date().format('yyyy'))
            }

            if (!actual) {
                actual = Anio.list([sort: 'anio', order: 'desc']).pop()
            }
            def total = 0
            def totalUnidad = 0
            def maxInv = 0
//            MarcoLogico.findAll("from MarcoLogico where proyecto = ${proyecto.id} and tipoElemento=3 and estado=0").each {
//                def asig = Asignacion.findAll("from Asignacion where marcoLogico=${it.id} and anio=${actual.id}   order by id")
//                if (asig) {
//                    asignaciones += asig
////                    println "add " + asig.id + " " + asig.unidad
//                    asig.each { asg ->
//                        total = total + asg.getValorReal()
//                    }
//                }
//            }

            MarcoLogico.withCriteria {
                eq("proyecto", proyecto)
                eq("tipoElemento", TipoElemento.get(3))
                eq("estado", 0)
                marcoLogico {
                    order("numeroComp", "asc")
                }
                order("numero", "asc")
            }.each { ml ->
                def asig = Asignacion.withCriteria {
                    eq("marcoLogico", ml)
                    eq("anio", actual)
                    order("id", "asc")
                }
                if (asig) {
                    asignaciones += asig
                    asig.each { asg ->
                        total = total + asg.getValorReal()
                    }
                }
            }

//            asignaciones.sort { it.unidad.nombre }
            def unidad = UnidadEjecutora.findByPadreIsNull()
            maxInv = PresupuestoUnidad.findByAnioAndUnidad(actual, unidad)?.maxInversion
            if (!maxInv)
                maxInv = 0

            return [asignaciones: asignaciones, actual: actual, proyecto: proyecto, total: total, totalUnidad: totalUnidad, maxInv: maxInv]
        }
    }


    def reporteAsignacionProyecto2 = {

        def proyecto = Proyecto.get(params.id)
        def asignaciones = []
        def actual

        if (params.anio) {
            actual = Anio.get(params.anio)
        } else {
            actual = Anio.findByAnio(new Date().format('yyyy'))
        }

        if (!actual) {
            actual = Anio.list([sort: 'anio', order: 'desc']).pop()
        }

        def data = [:]
        def anios = []

        def totalPriorizado = 0
        def totalesAnios = [:]

        MarcoLogico.withCriteria {
            eq("proyecto", proyecto)
            eq("tipoElemento", TipoElemento.get(3))
            eq("estado", 0)
            marcoLogico {
                order("numeroComp", "asc")
            }
            order("numero", "asc")
        }.each { ml ->
            def asig = Asignacion.withCriteria {
                eq("marcoLogico", ml)
                anio {
                    order("anio", "asc")
                }
            }
            if (asig) {
                asignaciones += asig
                asig.each { asg ->
                    def anio = asg.anio.anio
                    if (!anios.contains(anio)) {
                        anios += anio
                    }
                    if (!totalesAnios[anio]) {
                        totalesAnios[anio] = 0
                    }
                }
            }
        }

        asignaciones.each { Asignacion asg ->
            def ml = "" + asg.marcoLogico.numero
            def key = ml + "-" + asg.unidad.id + "-" + asg.presupuesto.numero
            def anio = asg.anio.anio
            if (!data[key]) {
                data[key] = [:]
            }
            if (!data[key][ml]) {
                data[key][ml] = [ml: asg.marcoLogico, un: asg.unidad, pa: asg.presupuesto.numero, prio: asg.priorizado, anios: [:]]
                totalPriorizado += asg.priorizado
            }
            if (!data[key][ml]["anios"][anio]) {
                data[key][ml]["anios"][anio] = asg
                totalesAnios[anio] += asg.getValorReal()
            }
        }

        return [actual: actual, proyecto: proyecto, totalPriorizado: totalPriorizado, totalesAnios: totalesAnios, anios: anios, data: data]
    }


    def reporteTotalPriorizacion = {


        def proyectos = Proyecto.list()
        def actividades
        def marcos
        def elemento = TipoElemento.get(3)
        def montos = []
        def priorizados = []

        proyectos.each {
            marcos = MarcoLogico.findAllByProyectoAndTipoElemento(it, elemento)
//            marcos.each {m->
//                montos += m.monto
//                priorizados += m.getTotalPriorizado()
//            }
        }

//        println("-->" + marcos)

        return [marcos: marcos, proyectos: proyectos]


    }


    def reporteAsignacionUnidad = {

        println("params " + params)

        def proyecto = Proyecto.get(params.id)
        def asignaciones = []
        def actual

        if (params.resp || params.comp) {
//            println("con filtro!"  + params.resp + " " + params.comp)

            def unidadE
            def compon

            if (params.resp) {
                unidadE = UnidadEjecutora.findByNombre(params.resp)

//                println("unidad " + unidadE)


                if (params.anio)
                    actual = Anio.get(params.anio)
                else
                    actual = Anio.findByAnio(new Date().format("yyyy"))
                if (!actual)
                    actual = Anio.list([sort: 'anio', order: 'desc']).pop()

                def totalR = 0
                def totalUnidadR = 0
                def maxInvR = 0
                MarcoLogico.findAll("from MarcoLogico where proyecto = ${proyecto.id} and tipoElemento=3 and estado=0 and responsable=${unidadE.id}").each {
                    def asig = Asignacion.findAll("from Asignacion where marcoLogico=${it.id} and anio=${actual.id} and unidad=${params.ses} order by id")
                    if (asig) {
                        asignaciones += asig
                        asig.each { asg ->
                            totalR = totalR + asg.getValorReal()
                        }
                    }
                }


                asignaciones.sort { it.unidad.nombre }
                def unidad = UnidadEjecutora.findByPadreIsNull()
                maxInvR = PresupuestoUnidad.findByAnioAndUnidad(actual, unidad)?.maxInversion
                if (!maxInvR)
                    maxInvR = 0

                [asignaciones: asignaciones, actual: actual, proyecto: proyecto, total: totalR, totalUnidad: totalUnidadR, maxInv: maxInvR, unidad: params.ses]

            } else {
                compon = MarcoLogico.findByObjeto(params.comp)

                if (params.anio)
                    actual = Anio.get(params.anio)
                else
                    actual = Anio.findByAnio(new Date().format("yyyy"))
                if (!actual)
                    actual = Anio.list([sort: 'anio', order: 'desc']).pop()

                def total = 0
                def totalUnidad = 0
                def maxInv = 0
                MarcoLogico.findAll("from MarcoLogico where proyecto = ${proyecto.id} and tipoElemento=3 and estado=0").each {
                    def asig = Asignacion.findAll("from Asignacion where marcoLogico=${it.id} and anio=${actual.id} and unidad=${params.ses}  order by id")
                    if (asig) {
                        asignaciones += asig
                        asig.each { asg ->
                            total = total + asg.getValorReal()
                        }
                    }
                }
                asignaciones.sort { it.unidad.nombre }
                def unidad = UnidadEjecutora.findByPadreIsNull()
                maxInv = PresupuestoUnidad.findByAnioAndUnidad(actual, unidad)?.maxInversion
                if (!maxInv)
                    maxInv = 0
                [asignaciones: asignaciones, actual: actual, proyecto: proyecto, total: total, totalUnidad: totalUnidad, maxInv: maxInv, unidad: params.ses]
            }


        } else {
            if (params.anio) {
                actual = Anio.get(params.anio)
            } else {
                actual = Anio.findByAnio(new Date().format('yyyy'))
            }

            if (!actual) {
                actual = Anio.list([sort: 'anio', order: 'desc']).pop()
            }


            def total = 0
            def totalUnidad = 0
            def maxInv = 0
            MarcoLogico.findAll("from MarcoLogico where proyecto = ${proyecto.id} and tipoElemento=3 and estado=0").each {
                def asig = Asignacion.findAll("from Asignacion where marcoLogico=${it.id} and anio=${actual.id} and unidad=${params.ses} order by id")
                if (asig) {
                    asignaciones += asig
                    println "add " + asig.id + " " + asig.unidad
                    asig.each { asg ->
                        total = total + asg.getValorReal()
                    }
                }
            }

            asignaciones.sort { it.unidad.nombre }
            def unidad = UnidadEjecutora.findByPadreIsNull()
            maxInv = PresupuestoUnidad.findByAnioAndUnidad(actual, unidad)?.maxInversion
            if (!maxInv)
                maxInv = 0

            [asignaciones: asignaciones, actual: actual, proyecto: proyecto, total: total, totalUnidad: totalUnidad, maxInv: maxInv, unidad: params.ses]

        }

    }


}
