package vesta.reportes

import jxl.Workbook
import jxl.WorkbookSettings
import jxl.write.*
import vesta.avales.Certificacion
import vesta.avales.ProcesoAsignacion
import vesta.avales.SolicitudAval
import vesta.parametros.PresupuestoUnidad
import vesta.parametros.TipoElemento
import vesta.parametros.UnidadEjecutora
import vesta.parametros.geografia.Canton
import vesta.parametros.geografia.Parroquia
import vesta.parametros.geografia.Provincia
import vesta.parametros.poaPac.Anio
import vesta.parametros.poaPac.Mes
import vesta.parametros.proyectos.Programa
import vesta.parametros.proyectos.TipoMeta
import vesta.poa.Asignacion
import vesta.poa.ProgramacionAsignacion
import vesta.proyectos.*

import vesta.NumberToLetterConverter

/**
 * Controlador
 */
class ReportesController {

    def dbConnectionService

    /**
     * Acción
     */
    def index = {}

    /**
     * Acción
     */
    def modificacionesPoa = {
        def unidad = UnidadEjecutora.get(params.id)
        def actual
        if (params.anio)
            actual = Anio.get(params.anio)
        else
            actual = Anio.findByAnio(new Date().format("yyyy"))
        if (!actual)
            actual = Anio.list([sort: 'anio', order: 'desc']).pop()


        def res = []

        Asignacion.findAllWhere(unidad: unidad, anio: actual).each { asg ->
            ModificacionAsignacion.findAllByDesdeOrRecibe(asg, asg, [sort: "id"]).each { mod ->
                res.add(mod)
            }
        }
        res.sort {
            it.id
        }
        return [res: res, unidad: unidad, actual: actual]
    }

    /**
     * Acción
     */
    def certificacionPac = {
        println params
        def obra = Obra.get(params.id)

        return [obra: obra]

    }

    /**
     * Acción
     */
    def modUnidad = {
        def actual
        def unidad = UnidadEjecutora.get(params.id)
        if (params.anio)
            actual = Anio.get(params.anio)
        else
            actual = Anio.findByAnio(new Date().format("yyyy"))


        def poa = Asignacion.findAllByUnidadAndAnio(unidad, actual)
        def res = []
        poa.each {
            def pac = Obra.findAllByAsignacion(it)
            if (pac)
                res += pac
        }

        [res: res, unidad: unidad, actual: actual]
    }

    /**
     * Acción
     */
    def reporteCertificaciones = {
        def actual
        if (params.anio)
            actual = Anio.get(params.anio)
        else
            actual = Anio.findByAnio(new Date().format("yyyy"))


        def mapa = [:]
        def certificaciones = Certificacion.findAllByEstado(1)

        certificaciones.each {
            def unidad = it.asignacion.unidad.nombre
            if (mapa[unidad]) {
                mapa[unidad].add(it)
            } else {
                mapa.put(unidad, [it])
            }
        }
        [mapa: mapa, actual: actual]
    }

    /**
     * Acción
     */
    def reporteGeneralCertificaciones = {
        def actual
        if (params.anio)
            actual = Anio.get(params.anio)
        else
            actual = Anio.findByAnio(new Date().format("yyyy"))


        def mapa = [:]
        def certificaciones = Certificacion.findAllByEstado(1)

        certificaciones.each {
            def unidad = it.asignacion.unidad.nombre
            if (mapa[unidad]) {
                mapa[unidad].add(it)
            } else {
                mapa.put(unidad, [it])
            }
        }
        [mapa: mapa, actual: actual]
    }

    /**
     * Acción
     */
    def certificacion = {
        println "certiificacion aaaa " + params
        def solicitud = SolicitudAval.get(params.id)
        def aval = solicitud.aval
        println "aval " + aval
        def anio = Anio.findByAnio(new Date().format("yyyy"))
        def mes = Mes.findByNumero(solicitud.fecha.format("MM").toInteger())
        def anterior = null
//        anterior=Certificacion.findByAsignacionAndFechaLessThan(cer.asignacion,new Date().parse("dd-MM-yyyy HH:mm","01-01-${anio} 00:00"))
        mes = mes?.descripcion


        def anios = [:]
        def arr = [:]
        def total
        ProcesoAsignacion.findAllByProceso(solicitud.proceso).each {
            if(it.asignacion.anio.anio.toInteger() >= anio.anio.toInteger()){
                if(arr[it.asignacion.marcoLogico]){
                    arr[it.asignacion.marcoLogico]["total"]+=it.monto
                    if(arr[it.asignacion.marcoLogico][it.asignacion.anio.anio]){
                        arr[it.asignacion.marcoLogico][it.asignacion.anio.anio]["asignaciones"].add(it)
                        arr[it.asignacion.marcoLogico][it.asignacion.anio.anio]["total"]+=it.monto

                    }else{
                        def mp=[:]
                        mp.put("asignaciones",[it])
                        mp.put("total",it.monto)

                        arr[it.asignacion.marcoLogico].put(it.asignacion.anio.anio,mp)
                    }

                }else{
                    def tmp = [:]
                    def mp=[:]
                    mp.put("asignaciones",[it])
                    mp.put("total",it.monto)
                    tmp.put(it.asignacion.anio.anio,mp)
                    tmp.put("total",it.monto)
                    arr.put(it.asignacion.marcoLogico, tmp)
                }
            }
        }

        println("arr" + arr)

        def devengado = 0
        def transf = NumberToLetterConverter.convertNumberToLetter(solicitud?.monto)

        println("-->" + transf)

        return [sol: solicitud, anio: anio, mes: mes, anterior: anterior, aval: aval, arr: arr, transf: transf, devengado: devengado]
    }

    /**
     * Acción
     */
    def reasignacion = {
        /*todo*/
        def anio = Anio.findByAnio(new Date().format("yyyy"))
        def uni99 = UnidadEjecutora.findAllByCodigo("9999")
        def resto = UnidadEjecutora.findAllByCodigoNotEqual("9999").sort { it.codigo.toInteger() }
        //resto+= UnidadEjecutora.findAllByCodigoIsNull()
        def asignado99 = 0
        def original99 = 0
        def poa99 = 0
        def totalAsg = 0
        def totalOrg = 0
        def totalPoa = 0
        def datos = []
        uni99.each {
            def temp = PresupuestoUnidad.findByUnidadAndAnio(it, anio)
            if (temp) {
                asignado99 += temp.maxCorrientes
                asignado99 += temp.maxInversion
                original99 += temp.originalCorrientes
                original99 += temp.originalInversion
            }
            temp = Asignacion.findAllByUnidadAndAnio(it, anio)
            temp.each { t ->
                poa99 += t.planificado
            }


        }
        totalAsg += asignado99
        totalOrg += original99
        totalPoa += poa99
        resto.each {
            def asig = 0
            def org = 0
            def poa = 0
            def ar = []
            ar.add(it.codigo)
            ar.add(it.nombre)
            def temp = PresupuestoUnidad.findByUnidadAndAnio(it, anio)
            if (temp) {
                //println "unidad " + it.id + " org " + temp.originalCorrientes + "  aaa  " + temp.originalInversion
                asig += temp.maxCorrientes
                asig += temp.maxInversion
                org += temp.originalCorrientes
                org += temp.originalInversion
            }
            temp = Asignacion.findAllByUnidadAndAnio(it, anio)
            temp.each { t ->
                poa += t.planificado
            }
            ar.add(asig)
            ar.add(org)
            ar.add(poa)
            datos.add(ar)
            totalAsg += asig
            totalOrg += org
            totalPoa += poa
        }
        [anio: anio, resto: resto, asignado99: asignado99, original99: original99, poa99: poa99, datos: datos, totalAsg: totalAsg, totalOrg: totalOrg, totalPoa: totalPoa]

    }

    /**
     * Acción
     */
    def reasignacionDetallado = {
        def anio = Anio.findByAnio(new Date().format("yyyy"))
        def uni99 = UnidadEjecutora.findAllByCodigo("9999")
        def resto = UnidadEjecutora.findAllByCodigoNotEqual("9999").sort { it.codigo.toInteger() }
        //resto+= UnidadEjecutora.findAllByCodigoIsNull()
        def asignado99 = 0
        def original99 = 0
        def poa99 = 0
        def totalAsg = 0
        def totalOrg = 0
        def totalPoa = 0
        def datos = []
        uni99.each {
            def asig = 0
            def org = 0
            def poa = 0
            def ar = []
            ar.add(it.codigo)
            ar.add(it.nombre)
            def temp = PresupuestoUnidad.findByUnidadAndAnio(it, anio)
            if (temp) {
                println "unidad " + it.id + " org " + temp.originalCorrientes + "  aaa  " + temp.originalInversion
                asig += temp.maxCorrientes
                asig += temp.maxInversion
                org += temp.originalCorrientes
                org += temp.originalInversion
            }
            temp = Asignacion.findAllByUnidadAndAnio(it, anio)
            temp.each { t ->
                poa += t.planificado
            }
            ar.add(asig)
            ar.add(org)
            ar.add(poa)
            datos.add(ar)
            totalAsg += asig
            totalOrg += org
            totalPoa += poa
        }
        resto.each {
            def asig = 0
            def org = 0
            def poa = 0
            def ar = []
            ar.add(it.codigo)
            ar.add(it.nombre)
            def temp = PresupuestoUnidad.findByUnidadAndAnio(it, anio)
            if (temp) {
                println "unidad " + it.id + " org " + temp.originalCorrientes + "  aaa  " + temp.originalInversion
                asig += temp.maxCorrientes
                asig += temp.maxInversion
                org += temp.originalCorrientes
                org += temp.originalInversion
            }
            temp = Asignacion.findAllByUnidadAndAnio(it, anio)
            temp.each { t ->
                poa += t.planificado
            }
            ar.add(asig)
            ar.add(org)
            ar.add(poa)
            datos.add(ar)
            totalAsg += asig
            totalOrg += org
            totalPoa += poa
        }
        [anio: anio, resto: resto, datos: datos, totalAsg: totalAsg, totalOrg: totalOrg, totalPoa: totalPoa]
    }

    /**
     * Acción
     */
    def reasignacionXls = {
        WorkbookSettings workbookSettings = new WorkbookSettings()
        workbookSettings.locale = Locale.default
        def file = File.createTempFile('reasignacion', '.xls')
        file.deleteOnExit()
        println "paso"
        WritableWorkbook workbook = Workbook.createWorkbook(file, workbookSettings)
        WritableFont font = new WritableFont(WritableFont.ARIAL, 12)
        WritableCellFormat formatXls = new WritableCellFormat(font)
        def row = 0
        WritableSheet sheet = workbook.createSheet('MySheet', 0)
        sheet.setColumnView(2, 60)
        sheet.setColumnView(3, 20)
        sheet.setColumnView(4, 20)
        sheet.setColumnView(5, 20)
        sheet.setColumnView(6, 20)

        def anio = Anio.findByAnio(new Date().format("yyyy"))
        def uni99 = UnidadEjecutora.findAllByCodigo("9999")
        def resto = UnidadEjecutora.findAllByCodigoNotEqual("9999").sort { it.codigo.toInteger() }
        //resto+= UnidadEjecutora.findAllByCodigoIsNull()
        def asignado99 = 0
        def original99 = 0
        def poa99 = 0
        def totalAsg = 0
        def totalOrg = 0
        def totalPoa = 0
        def datos = []
        def label
        def number

        /*Header*/
        WritableFont times16font = new WritableFont(WritableFont.TIMES, 11, WritableFont.BOLD, true);
        WritableCellFormat times16format = new WritableCellFormat(times16font);

        label = new Label(1, 1, "Código", times16format);
        sheet.addCell(label);
        label = new Label(2, 1, "Nombre", times16format);
        sheet.addCell(label);
        label = new Label(3, 1, "Asignado", times16format);
        sheet.addCell(label);
        label = new Label(4, 1, "Original", times16format);
        sheet.addCell(label);
        label = new Label(5, 1, "POA", times16format);
        sheet.addCell(label);
        label = new Label(6, 1, "diferencia", times16format);
        sheet.addCell(label);

        /*Fin header*/
        def columna = 2
        uni99.each {
            def temp = PresupuestoUnidad.findByUnidadAndAnio(it, anio)
            if (temp) {
                asignado99 += temp.maxCorrientes
                asignado99 += temp.maxInversion
                original99 += temp.originalCorrientes
                original99 += temp.originalInversion
            }
            temp = Asignacion.findAllByUnidadAndAnio(it, anio)
            temp.each { t ->
                poa99 += t.planificado
            }


        }

        label = new Label(1, columna, "9999");
        sheet.addCell(label);
        label = new Label(2, columna, "Planta Central");
        sheet.addCell(label);
        number = new Number(3, columna, asignado99);
        sheet.addCell(number);
        number = new Number(4, columna, original99);
        sheet.addCell(number);
        number = new Number(5, columna, poa99);
        sheet.addCell(number);
        number = new Number(6, columna, asignado99 - original99);
        sheet.addCell(number);
        columna++
        totalAsg += asignado99
        totalOrg += original99
        totalPoa += poa99
        resto.each {
            def asig = 0
            def org = 0
            def poa = 0
            def ar = []
            ar.add(it.codigo)
            ar.add(it.nombre)
            def temp = PresupuestoUnidad.findByUnidadAndAnio(it, anio)
            if (temp) {
                println "unidad " + it.id + " org " + temp.originalCorrientes + "  aaa  " + temp.originalInversion
                asig += temp.maxCorrientes
                asig += temp.maxInversion
                org += temp.originalCorrientes
                org += temp.originalInversion
            }
            temp = Asignacion.findAllByUnidadAndAnio(it, anio)
            temp.each { t ->
                poa += t.planificado
            }
            ar.add(asig)
            ar.add(org)
            ar.add(poa)
            datos.add(ar)
            totalAsg += asig
            totalOrg += org
            totalPoa += poa
            label = new Label(1, columna, it.codigo);
            sheet.addCell(label);
            label = new Label(2, columna, it.nombre);
            sheet.addCell(label);
            number = new Number(3, columna, asig);
            sheet.addCell(number);
            number = new Number(4, columna, org);
            sheet.addCell(number);
            number = new Number(5, columna, poa);
            sheet.addCell(number);
            number = new Number(6, columna, asig - org);
            sheet.addCell(number);
            columna++
        }
        label = new Label(1, columna, "TOTAL");
        sheet.addCell(label);
        label = new Label(2, columna, "");
        sheet.addCell(label);
        number = new Number(3, columna, totalAsg);
        sheet.addCell(number);
        number = new Number(4, columna, totalOrg);
        sheet.addCell(number);
        number = new Number(5, columna, totalPoa);
        sheet.addCell(number);
        number = new Number(6, columna, totalAsg - totalOrg);
        sheet.addCell(number);
        columna++

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
    def reasignacionDetalladoXls = {
        WorkbookSettings workbookSettings = new WorkbookSettings()
        workbookSettings.locale = Locale.default
        def file = File.createTempFile('reasignacion', '.xls')
        file.deleteOnExit()
        println "paso"
        WritableWorkbook workbook = Workbook.createWorkbook(file, workbookSettings)
        WritableFont font = new WritableFont(WritableFont.ARIAL, 12)
        WritableCellFormat formatXls = new WritableCellFormat(font)
        def row = 0
        WritableSheet sheet = workbook.createSheet('MySheet', 0)
        sheet.setColumnView(2, 60)
        sheet.setColumnView(3, 20)
        sheet.setColumnView(4, 20)
        sheet.setColumnView(5, 20)
        sheet.setColumnView(6, 20)

        def anio = Anio.findByAnio(new Date().format("yyyy"))
        def uni99 = UnidadEjecutora.findAllByCodigo("9999")
        def resto = UnidadEjecutora.findAllByCodigoNotEqual("9999").sort { it.codigo.toInteger() }
        //resto+= UnidadEjecutora.findAllByCodigoIsNull()
        def asignado99 = 0
        def original99 = 0
        def poa99 = 0
        def totalAsg = 0
        def totalOrg = 0
        def totalPoa = 0
        def datos = []
        def label
        def number

        /*Header*/
        WritableFont times16font = new WritableFont(WritableFont.TIMES, 11, WritableFont.BOLD, true);
        WritableCellFormat times16format = new WritableCellFormat(times16font);

        label = new Label(1, 1, "Código", times16format);
        sheet.addCell(label);
        label = new Label(2, 1, "Nombre", times16format);
        sheet.addCell(label);
        label = new Label(3, 1, "Asignado", times16format);
        sheet.addCell(label);
        label = new Label(4, 1, "Original", times16format);
        sheet.addCell(label);
        label = new Label(5, 1, "POA", times16format);
        sheet.addCell(label);
        label = new Label(6, 1, "diferencia", times16format);
        sheet.addCell(label);

        /*Fin header*/
        def columna = 2
        uni99.each {
            def asig = 0
            def org = 0
            def poa = 0
            def ar = []
            ar.add(it.codigo)
            ar.add(it.nombre)
            def temp = PresupuestoUnidad.findByUnidadAndAnio(it, anio)
            if (temp) {
                println "unidad " + it.id + " org " + temp.originalCorrientes + "  aaa  " + temp.originalInversion
                asig += temp.maxCorrientes
                asig += temp.maxInversion
                org += temp.originalCorrientes
                org += temp.originalInversion
            }
            temp = Asignacion.findAllByUnidadAndAnio(it, anio)
            temp.each { t ->
                poa += t.planificado
            }
            ar.add(asig)
            ar.add(org)
            ar.add(poa)
            datos.add(ar)
            totalAsg += asig
            totalOrg += org
            totalPoa += poa
            label = new Label(1, columna, it.codigo);
            sheet.addCell(label);
            label = new Label(2, columna, it.nombre);
            sheet.addCell(label);
            number = new Number(3, columna, asig);
            sheet.addCell(number);
            number = new Number(4, columna, org);
            sheet.addCell(number);
            number = new Number(5, columna, poa);
            sheet.addCell(number);
            number = new Number(6, columna, asig - org);
            sheet.addCell(number);
            columna++
        }
        resto.each {
            def asig = 0
            def org = 0
            def poa = 0
            def ar = []
            ar.add(it.codigo)
            ar.add(it.nombre)
            def temp = PresupuestoUnidad.findByUnidadAndAnio(it, anio)
            if (temp) {
                println "unidad " + it.id + " org " + temp.originalCorrientes + "  aaa  " + temp.originalInversion
                asig += temp.maxCorrientes
                asig += temp.maxInversion
                org += temp.originalCorrientes
                org += temp.originalInversion
            }
            temp = Asignacion.findAllByUnidadAndAnio(it, anio)
            temp.each { t ->
                poa += t.planificado
            }
            ar.add(asig)
            ar.add(org)
            ar.add(poa)
            datos.add(ar)
            totalAsg += asig
            totalOrg += org
            totalPoa += poa
            label = new Label(1, columna, it.codigo);
            sheet.addCell(label);
            label = new Label(2, columna, it.nombre);
            sheet.addCell(label);
            number = new Number(3, columna, asig);
            sheet.addCell(number);
            number = new Number(4, columna, org);
            sheet.addCell(number);
            number = new Number(5, columna, poa);
            sheet.addCell(number);
            number = new Number(6, columna, asig - org);
            sheet.addCell(number);
            columna++
        }
        label = new Label(1, columna, "TOTAL");
        sheet.addCell(label);
        label = new Label(2, columna, "");
        sheet.addCell(label);
        number = new Number(3, columna, totalAsg);
        sheet.addCell(number);
        number = new Number(4, columna, totalOrg);
        sheet.addCell(number);
        number = new Number(5, columna, totalPoa);
        sheet.addCell(number);
        number = new Number(6, columna, totalAsg - totalOrg);
        sheet.addCell(number);
        columna++

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
    def reasignacionAgrupado = {
        def anio = Anio.findByAnio(new Date().format("yyyy"))
//        def uni99 = UnidadEjecutora.findAllByCodigo("9999")
//        def resto = UnidadEjecutora.findAllByCodigoNotEqual("9999").sort{it.codigo.toInteger()}
//        resto+= UnidadEjecutora.findAllByCodigoIsNull()
        def cn = dbConnectionService.getConnection()
        def resultados = []
        def total = 0
        def sql = "SELECT '9999',prspnmro,pg.pgpscdgo,f.fntecdgo,sum(asgnplan) from asgn a,prsp p,pgps pg,fnte f where a.prsp__id = p.prsp__id and a.pgps__id = pg.pgps__id and a.fnte__id = f.fnte__id and a.unej__id in (select unej__id from unej where unejcdgo='9999') and a.mrlg__id is null and a.anio__id=${anio.id} group by 1,2,3,4 order by 3"
        cn.eachRow(sql) { d ->
            def temp = []
            temp.add(d[0])
            temp.add("Planta Central")
            temp.add(d[1])
            temp.add(d[4])
            temp.add("" + ((d[2].toString().size() < 3) ? "0" + d[2] : d[2]) + "000" + "000" + ((d[3]) ? d[3] : "000") + d[1])
            resultados.add(temp)
            total += d[4]
        }
        sql = "SELECT '9999',prspnmro,pg.pgpscdgo,f.fntecdgo,pr.proy__id,sum(asgnplan) from asgn a,prsp p,pgps pg,fnte f,mrlg m,proy pr where a.prsp__id = p.prsp__id and a.mrlg__id=m.mrlg__id and m.proy__id=pr.proy__id and pr.pgps__id = pg.pgps__id and a.fnte__id = f.fnte__id and a.unej__id in (select unej__id from unej where unejcdgo='9999') and a.mrlg__id is not null and a.anio__id=${anio.id} group by 1,2,3,4,5 order by 3"
        cn.eachRow(sql) { d ->
            def temp = []
            temp.add(d[0])
            temp.add("Planta Central")
            temp.add(d[1])
            temp.add(d[5])
            temp.add("" + ((d[3].toString().size() < 3) ? "0" + d[3] : d[3]) + ((d[4].toString().size() < 3) ? "0" + d[4] : d[4]) + "000" + ((d[3]) ? d[3] : "000") + d[1])
            resultados.add(temp)
            total += d[5]
        }

        sql = "SELECT u.unejcdgo,unejnmbr,prspnmro,pg.pgpscdgo,f.fntecdgo,sum(asgnplan) from unej u,asgn a,prsp p,pgps pg,fnte f where unejcdgo != '9999' and a.unej__id = u.unej__id and p.prsp__id = a.prsp__id and a.mrlg__id is null and pg.pgps__id = a.pgps__id  and f.fnte__id = a.fnte__id and a.anio__id=${anio.id} group by p.prspnmro,1,2,pg.pgpscdgo,f.fntecdgo order by u.unejcdgo"

        cn.eachRow(sql) { d ->
            def temp = []
            temp.add(d[0])
            temp.add(d[1])
            temp.add(d[2])
            temp.add(d[5])
            temp.add("" + ((d[3].toString().size() < 3) ? "0" + d[3] : d[3]) + "000" + "000" + ((d[4]) ? d[4] : "000") + d[2])
            resultados.add(temp)
            total += d[5]
        }

        sql = "SELECT u.unejcdgo,unejnmbr,prspnmro,pg.pgpscdgo,f.fntecdgo,pr.proy__id,sum(asgnplan) from unej u,asgn a,prsp p,pgps pg,fnte f,proy pr,mrlg m where unejcdgo != '9999' and a.unej__id = u.unej__id and p.prsp__id = a.prsp__id and a.mrlg__id is not null and a.mrlg__id = m.mrlg__id and m.proy__id = pr.proy__id and  pg.pgps__id = pr.pgps__id  and f.fnte__id = a.fnte__id and a.anio__id=${anio.id} group by p.prspnmro,1,2,pg.pgpscdgo,f.fntecdgo,pr.proy__id order by u.unejcdgo"
        cn.eachRow(sql) { d ->
            def temp = []
            temp.add(d[0])
            temp.add(d[1])
            temp.add(d[2])
            temp.add(d[6])
            temp.add("" + ((d[3].toString().size() < 3) ? "0" + d[3] : d[3]) + ((d[5].toString().size() < 3) ? "0" + d[5] : d[5]) + "000" + ((d[4]) ? d[4] : "000") + d[2])
            resultados.add(temp)
            total += d[6]
        }




        cn.close()
        [anio: anio, resultados: resultados, total: total]
    }

    /**
     * Acción
     */
    def reasignacionAgrupadoXls = {
        def anio = Anio.findByAnio(new Date().format("yyyy"))
//        def uni99 = UnidadEjecutora.findAllByCodigo("9999")
//        def resto = UnidadEjecutora.findAllByCodigoNotEqual("9999").sort{it.codigo.toInteger()}
//        resto+= UnidadEjecutora.findAllByCodigoIsNull()
        def cn = dbConnectionService.getConnection()
        def resultados = []
        def total = 0


        WorkbookSettings workbookSettings = new WorkbookSettings()
        workbookSettings.locale = Locale.default
        def file = File.createTempFile('reasignacion', '.xls')
        file.deleteOnExit()
        println "paso"
        WritableWorkbook workbook = Workbook.createWorkbook(file, workbookSettings)
        WritableFont font = new WritableFont(WritableFont.ARIAL, 12)
        WritableCellFormat formatXls = new WritableCellFormat(font)
        def row = 0
        WritableSheet sheet = workbook.createSheet('MySheet', 0)
        def label
        def number
        sheet.setColumnView(2, 50)
        sheet.setColumnView(3, 20)
        sheet.setColumnView(4, 20)
        sheet.setColumnView(5, 20)
        sheet.setColumnView(6, 20)

        /*Header*/


        WritableFont times16font = new WritableFont(WritableFont.TIMES, 11, WritableFont.BOLD, true);
        WritableCellFormat times16format = new WritableCellFormat(times16font);

        label = new Label(1, 1, "", times16format);
        sheet.addCell(label);
        label = new Label(2, 1, "Unidad", times16format);
        sheet.addCell(label);
        label = new Label(3, 1, "Código", times16format);
        sheet.addCell(label);
        label = new Label(4, 1, "Asignado", times16format);
        sheet.addCell(label);
        label = new Label(5, 1, "Partida", times16format);
        sheet.addCell(label);

        /*Fin header*/

        def columna = 2

        def sql = "SELECT '9999',prspnmro,pg.pgpscdgo,f.fntecdgo,sum(asgnplan) from asgn a,prsp p,pgps pg,fnte f where a.prsp__id = p.prsp__id and a.pgps__id = pg.pgps__id and a.fnte__id = f.fnte__id and a.unej__id in (select unej__id from unej where unejcdgo='9999') and a.mrlg__id is null and a.anio__id=${anio.id} group by 1,2,3,4 order by 3"
        cn.eachRow(sql) { d ->
            def temp = []
            temp.add(d[0])
            temp.add("Planta Central")
            temp.add(d[1])
            temp.add(d[4])
            temp.add("" + ((d[2].toString().size() < 3) ? "0" + d[2] : d[2]) + "000" + "000" + ((d[3]) ? d[3] : "000") + d[1])
            resultados.add(temp)
            total += d[4]

            label = new Label(1, columna, d[0]);
            sheet.addCell(label);
            label = new Label(2, columna, "Planta Central");
            sheet.addCell(label);
            label = new Label(3, columna, "" + ((d[2].toString().size() < 3) ? "0" + d[2] : d[2]) + "000" + "000" + ((d[3]) ? d[3] : "000") + d[1]);
            sheet.addCell(label);
            number = new Number(4, columna, d[4]);
            sheet.addCell(number);
            label = new Label(5, columna, d[1]);
            sheet.addCell(label);
            columna++
        }



        sql = "SELECT '9999',prspnmro,pg.pgpscdgo,f.fntecdgo,pr.proy__id,sum(asgnplan) from asgn a,prsp p,pgps pg,fnte f,mrlg m,proy pr where a.prsp__id = p.prsp__id and a.mrlg__id=m.mrlg__id and m.proy__id=pr.proy__id and pr.pgps__id = pg.pgps__id and a.fnte__id = f.fnte__id and a.unej__id in (select unej__id from unej where unejcdgo='9999') and a.mrlg__id is not null and a.anio__id=${anio.id} group by 1,2,3,4,5 order by 3"
        cn.eachRow(sql) { d ->
            def temp = []
            temp.add(d[0])
            temp.add("Planta Central")
            temp.add(d[1])
            temp.add(d[5])
            temp.add("" + ((d[3].toString().size() < 3) ? "0" + d[3] : d[3]) + ((d[4].toString().size() < 3) ? "0" + d[4] : d[4]) + "000" + ((d[3]) ? d[3] : "000") + d[1])
            resultados.add(temp)
            total += d[5]
            label = new Label(1, columna, d[0]);
            sheet.addCell(label);
            label = new Label(2, columna, "Planta Central");
            sheet.addCell(label);
            label = new Label(3, columna, "" + ((d[3].toString().size() < 3) ? "0" + d[3] : d[3]) + ((d[4].toString().size() < 3) ? "0" + d[4] : d[4]) + "000" + ((d[3]) ? d[3] : "000") + d[1]);
            sheet.addCell(label);
            number = new Number(4, columna, d[5]);
            sheet.addCell(number);
            label = new Label(5, columna, d[1]);
            sheet.addCell(label);
            columna++
        }

        sql = "SELECT u.unejcdgo,unejnmbr,prspnmro,pg.pgpscdgo,f.fntecdgo,sum(asgnplan) from unej u,asgn a,prsp p,pgps pg,fnte f where unejcdgo != '9999' and a.unej__id = u.unej__id and p.prsp__id = a.prsp__id and a.mrlg__id is null and pg.pgps__id = a.pgps__id  and f.fnte__id = a.fnte__id and a.anio__id=${anio.id} group by p.prspnmro,1,2,pg.pgpscdgo,f.fntecdgo order by u.unejcdgo"

        cn.eachRow(sql) { d ->
            def temp = []
            temp.add(d[0])
            temp.add(d[1])
            temp.add(d[2])
            temp.add(d[5])
            temp.add("" + ((d[3].toString().size() < 3) ? "0" + d[3] : d[3]) + "000" + "000" + ((d[4]) ? d[4] : "000") + d[2])
            resultados.add(temp)
            total += d[5]
            label = new Label(1, columna, d[0]);
            sheet.addCell(label);
            label = new Label(2, columna, d[1]);
            sheet.addCell(label);
            label = new Label(3, columna, "" + ((d[3].toString().size() < 3) ? "0" + d[3] : d[3]) + "000" + "000" + ((d[4]) ? d[4] : "000") + d[2]);
            sheet.addCell(label);
            number = new Number(4, columna, d[5]);
            sheet.addCell(number);
            label = new Label(5, columna, d[2]);
            sheet.addCell(label);
            columna++
        }

        sql = "SELECT u.unejcdgo,unejnmbr,prspnmro,pg.pgpscdgo,f.fntecdgo,pr.proy__id,sum(asgnplan) from unej u,asgn a,prsp p,pgps pg,fnte f,proy pr,mrlg m where unejcdgo != '9999' and a.unej__id = u.unej__id and p.prsp__id = a.prsp__id and a.mrlg__id is not null and a.mrlg__id = m.mrlg__id and m.proy__id = pr.proy__id and  pg.pgps__id = pr.pgps__id  and f.fnte__id = a.fnte__id and a.anio__id=${anio.id} group by p.prspnmro,1,2,pg.pgpscdgo,f.fntecdgo,pr.proy__id order by u.unejcdgo"
        cn.eachRow(sql) { d ->
            def temp = []
            temp.add(d[0])
            temp.add(d[1])
            temp.add(d[2])
            temp.add(d[6])
            temp.add("" + ((d[3].toString().size() < 3) ? "0" + d[3] : d[3]) + ((d[5].toString().size() < 3) ? "0" + d[5] : d[5]) + "000" + ((d[4]) ? d[4] : "000") + d[2])
            resultados.add(temp)
            total += d[6]
            label = new Label(1, columna, d[0]);
            sheet.addCell(label);
            label = new Label(2, columna, d[1]);
            sheet.addCell(label);
            label = new Label(3, columna, "" + ((d[3].toString().size() < 3) ? "0" + d[3] : d[3]) + ((d[5].toString().size() < 3) ? "0" + d[5] : d[5]) + "000" + ((d[4]) ? d[4] : "000") + d[2]);
            sheet.addCell(label);
            number = new Number(4, columna, d[6]);
            sheet.addCell(number);
            label = new Label(5, columna, d[2]);
            sheet.addCell(label);
            columna++
        }

        label = new Label(1, columna, "TOTAL");
        sheet.addCell(label);
        label = new Label(2, columna, "");
        sheet.addCell(label);
        label = new Label(3, columna, "");
        sheet.addCell(label);
        number = new Number(4, columna, total);
        sheet.addCell(number);
        label = new Label(5, columna, "");
        sheet.addCell(label);
        columna++


        cn.close()

        workbook.write();
        workbook.close();
        def output = response.getOutputStream()
        def header = "attachment; filename=" + "asignacionAgrupado.xls";
        response.setContentType("application/octet-stream")
        response.setHeader("Content-Disposition", header);
        output.write(file.getBytes());


    }


    def reporteAvance(ids) {
        def resultados = []
        ids.each { id ->
            def mapProyecto = [:]
            def proyecto = Proyecto.get(id.toLong())
            mapProyecto.proyecto = proyecto
            def componentes = MarcoLogico.findAllByProyectoAndTipoElemento(proyecto, TipoElemento.get(2))
            mapProyecto.componentes = []
            componentes.each { comp ->
                def mapComponente = [:]
                mapComponente.componente = comp
                mapComponente.actividades = []
                def c = MarcoLogico.createCriteria()
                def actividades = c.list {
                    and {
                        eq("marcoLogico", comp)
                        eq("estado", 0)
                    }
                }
                actividades.each { act ->
                    def mapActividad = [:]
                    mapActividad.actividad = act
                    mapActividad.metas = []
                    Meta.findAllByMarcoLogicoAndEstado(act, 0).each { meta ->
                        def mapMeta = [:]
                        mapMeta.meta = meta
                        mapMeta.avances = Avance.findAllByMeta(meta)
                        mapActividad.metas.add(mapMeta)
                    }
                    mapComponente.actividades.add(mapActividad)
                }
                mapProyecto.componentes.add(mapComponente)
            }
            resultados.add(mapProyecto)
        }
        return resultados
    }

    def reporteIntervencion(params) {
        def tipo = params.tipo
        def anio = params.anio
        def tabla = ""
        def resultados = []
        if (tipo == "N") {
            def programas = Programa.list([sort: 'descripcion'])
            programas.each { programa ->
                def ejeMap = [:]
                ejeMap.eje = programa
                ejeMap.sistemas = []
                ejeMap.total = 0
                ejeMap.rowSpan = 0
                def proyectos = Proyecto.findAllByPrograma(programa)
                proyectos.each { proyecto ->
                    def sistemaMap = [:]
                    sistemaMap.sistema = proyecto
                    sistemaMap.componentes = []

                    def componentes = MarcoLogico.findAllByProyectoAndTipoElemento(proyecto, TipoElemento.get(2))
                    componentes.each { comp ->
                        def componenteMap = [:]
                        componenteMap.componente = comp
                        componenteMap.inversion = 0
                        def actividades = MarcoLogico.findAllByMarcoLogico(comp)
                        actividades.each { act ->
                            def asignaciones = Asignacion.findAllByMarcoLogicoAndAnio(act, Anio.findByAnio(anio))
                            asignaciones.each { asg ->
                                componenteMap.inversion += asg.planificado
                            }
                        }
                        ejeMap.total += componenteMap.inversion
                        componenteMap.programa = proyecto.unidadEjecutora
                        sistemaMap.componentes.add(componenteMap)
                    }
                    sistemaMap.rowSpan = sistemaMap.componentes.size()
                    ejeMap.rowSpan += sistemaMap.rowSpan
                    ejeMap.sistemas.add(sistemaMap)
                }
                resultados.add(ejeMap)
            }

            tabla += '<table border="1">'
            tabla += '<thead>'
            tabla += '<tr class="header">'
            tabla += '<th>'
            tabla += 'EJES PROGRAMÁTICOS'
            tabla += '</th>'
            tabla += '<th>'
            tabla += 'SISTEMA'
            tabla += '</th>'
            tabla += '<th>'
            tabla += 'COMPONENTE'
            tabla += '</th>'
            tabla += '<th>'
            tabla += 'INVERSIÓN EJECUTADA EN EL ' + anio
            tabla += '</th>'
            tabla += '<th>'
            tabla += 'PROGRAMA O INSTITUTO'
            tabla += '</th>'
            tabla += '</tr>'
            tabla += '</thead>'

            tabla += '<tbody>'
            def i = 0
            def totalFinal = 0;
            resultados.each { ejeMap ->     /* i */
                def claseFila = i % 4
                def rowSpanEje = ejeMap.rowSpan
                def eje = ejeMap.eje
                def j = 0
                if (rowSpanEje > 0) {
                    def total = 0
                    def band = false
                    ejeMap.sistemas.each { sistemaMap ->  /* j */
                        def rowSpanSistema = sistemaMap.rowSpan
                        def sistema = sistemaMap.sistema
                        if (rowSpanSistema > 0) {
                            def k = 0
                            sistemaMap.componentes.each { componenteMap ->  /* k */
                                def componente = componenteMap.componente
                                def inversion = componenteMap.inversion
                                def programa = componenteMap.programa
                                if (inversion >= 0) {
                                    band = true
                                    def td = []
                                    if (j == 0) {
                                        def m = [:]
                                        m.valor = eje
                                        m.rowSpan = rowSpanEje + 1
                                        m.tipo = "text"
                                        m.style = ""
                                        td.add(m)
                                        j++
                                    }
                                    if (k == 0) {
                                        def m = [:]
                                        m.valor = sistema
                                        m.rowSpan = rowSpanSistema
                                        m.tipo = "text"
                                        m.style = ""
                                        td.add(m)
                                        k++
                                    }
                                    def m = [:]
                                    m.valor = componente
                                    m.rowSpan = 1
                                    m.tipo = "text"
                                    m.style = ""
                                    td.add(m)
                                    m = [:]
                                    m.valor = inversion
                                    m.rowSpan = 1
                                    m.tipo = "number"
                                    m.style = "text-align:right;"
                                    td.add(m)
                                    total += inversion
                                    totalFinal += inversion
                                    m = [:]
                                    m.valor = programa
                                    m.rowSpan = 1
                                    m.tipo = "text"
                                    m.style = ""
                                    td.add(m)
                                    tabla += filaTablaReporte(td, "fila_" + claseFila)
                                }
                            }
                        }
                    }
                    if (band) {
                        def td = []
                        def m = [:]
                        m.valor = "TOTAL"
                        m.rowSpan = 1
                        m.tipo = "text"
                        m.style = "text-align:right; font-weight:bold;"
                        td.add(m)
                        m = [:]
                        m.valor = ""
                        m.rowSpan = 1
                        m.tipo = "text"
                        m.style = ""
                        td.add(m)
                        m = [:]
                        m.valor = total
                        m.rowSpan = 1
                        m.tipo = "number"
                        m.style = "text-align:right; font-weight:bold;"
                        td.add(m)
                        m = [:]
                        m.valor = ""
                        m.rowSpan = 1
                        m.tipo = "text"
                        m.style = ""
                        td.add(m)
                        tabla += filaTablaReporte(td, "total_" + claseFila)
                    }
                }
                i++
            }
            tabla += '</tbody>'
            tabla += '<tfoot>'
            def td = []
            def m = [:]
            m.valor = "TOTAL"
            m.rowSpan = 1
            m.colSpan = 3
            m.tipo = "text"
            m.style = "text-align:right; font-weight:bold;"
            td.add(m)
            m = [:]
            m.valor = totalFinal
            m.rowSpan = 1
            m.tipo = "number"
            m.style = "text-align:right; font-weight:bold;"
            td.add(m)
            m = [:]
            m.valor = ""
            m.rowSpan = 1
            m.tipo = "text"
            m.style = ""
            td.add(m)
            tabla += filaTablaReporte(td, "total")
            tabla += '</tfoot>'
            tabla += '</table>'

        } else if (tipo == "P") {

        }
        return tabla
    }

    def filaTablaReporte(tds, clase) {
        def fila = ""
        fila += '<tr class="' + clase + '">'
        tds.eachWithIndex { td, i ->
            fila += '<td rowspan="' + (td.rowSpan ?: '1') + '" ' + (td.colSpan ? 'colspan="' + td.colSpan + '"' : '') + ' style="' + td.style + '" ' + (td.extras ? td.extras : "") + '>'
            if (!td.tipo || td.tipo == "text") {
                if (td.valor != null && td.valor != "null") {
                    fila += td.valor
                } else {
                    fila += ""
                }
            } else if (td.tipo == "number") {
                fila += g.formatNumber(number: td.valor, format: "###,##0", minFractionDigits: "2", maxFractionDigits: "2")
            }
            fila += '</td>'
        }
        fila += '</tr>'
        return fila
    }

    def getMarcoLogico(Long id, proy) {
        def tipo
        switch (id) {
            case 1:
                tipo = "fin"
                break;
            case 2:
                tipo = "componente"
                break;
            case 3:
                tipo = "actividad"
                break;
            case 4:
                tipo = "proposito"
                break;
        }
        def n = [:]
        def c = MarcoLogico.createCriteria()
        def ml = c.list {
            and {
                eq("proyecto", proy)
                tipoElemento {
                    eq("id", id)
                }
                eq("estado", 0)
            }
        } //ml criteria
        if (ml) {
            ml = ml[0]
            def supuestos = Supuesto.findAllByMarcoLogicoAndEstado(ml, 0)
            def ind = Indicador.findAllByMarcoLogicoAndEstado(ml, 0)
            def o = []
            ind.each {
                def p = [:]
                p.indicador = it
                p.medios = MedioVerificacion.findAllByIndicadorAndEstado(it, 0)
                o.add(p)
            }
            n[tipo] = ml
            if (id == 2) {
                n.actividades = getMarcoLogico(3, proy)
                n.metas = Meta.findAllByMarcoLogicoAndEstado(ml, 0)
            }
            n.supuestos = supuestos
            n.indicadores = o
        } //if ml
        return n
    }

    def reporteFichaProyecto(ids) {
        def proyectos = []
        ids.each { id ->
            if (id && id != "") {
                def proy = Proyecto.get(id.toLong())
                def m = [:]
                m.proyecto = proy
                m.politicas = PoliticasProyecto.findAllByProyecto(proy)
                m.financiamientos = Financiamiento.findAllByProyecto(proy)
                proyectos.add(m)
            }
        }
        return proyectos
    }

    def reporteFichaMarcoLogico_(ids) {
        def proyectos = []
        ids.each { id ->
            if (id && id != "") {
                def m = [:]
                def proy = Proyecto.get(id.toLong())
                m.proyecto = proy
                m.fin = getMarcoLogico(1.toLong(), proy)
                m.proposito = getMarcoLogico(4.toLong(), proy)
                m.componente = getMarcoLogico(2.toLong(), proy)
                proyectos.add(m)
            }
        }
        return proyectos
    }

    def treeLabel(String label, String tipo, attrs) {
        if (!attrs)
            attrs = ""
        def str = ""
        switch (tipo) {
            case "link":
                str += "<a href='#' " + attrs + ">"
                break;
            case "div":
                str += "<div " + attrs + ">"
                break;
            case "span":
                str += "<span " + attrs + ">"
                break;
            default: ""
        }
        str += label
        switch (tipo) {
            case "link":
                str += "</a>"
                break;
            case "div":
                str += "</div>"
                break;
            case "span":
                str += "</span>"
                break;
            default: ""
        }
        return str
    }


    def reporteMarcoLogico(ids) {
        def ret = []

        ids.each { id ->
            def mapProyecto = [:]
            def proyecto = Proyecto.get(id.toLong())
            mapProyecto.proyecto = proyecto

            def mapFin = [:]
            def fin = MarcoLogico.findAllByProyectoAndTipoElemento(proyecto, TipoElemento.findByDescripcion("Fin"), [sort: "id", order: "desc", max: 1])
            if (fin) {
                fin = fin[0]
            }
            mapFin.fin = fin
            mapFin.indicadores = []
            def indicadoresFin = Indicador.findAllByMarcoLogicoAndEstado(fin, 0)
            indicadoresFin.each { indi ->
                def mapIndi = [:]
                mapIndi.indicador = indi
                def medios = MedioVerificacion.findAllByIndicadorAndEstado(indi, 0)
                mapIndi.medios = medios
                mapFin.indicadores.add(mapIndi)
            }
            def supuestosFin = Supuesto.findAllByMarcoLogicoAndEstado(fin, 0)
            mapFin.supuestos = supuestosFin
            mapProyecto.fin = mapFin

            def mapProp = [:]
            def prop = MarcoLogico.findAllByProyectoAndTipoElemento(proyecto, TipoElemento.findByDescripcion("Proposito"), [sort: "id", order: "desc", max: 1])
            if (prop) {
                prop = prop[0]
            }
            mapProp.proposito = prop
            mapProp.indicadores = []
            def indicadoresProp = Indicador.findAllByMarcoLogicoAndEstado(prop, 0)
            indicadoresProp.each { indi ->
                def mapIndi = [:]
                mapIndi.indicador = indi
                def medios = MedioVerificacion.findAllByIndicadorAndEstado(indi, 0)
                mapIndi.medios = medios
                mapProp.indicadores.add(mapIndi)
            }
            def supuestosProp = Supuesto.findAllByMarcoLogicoAndEstado(prop, 0)
            mapProp.supuestos = supuestosProp
            mapProyecto.proposito = mapProp

            ret.add(mapProyecto)
        }
        return ret
    }

    def reporteMarcoLogicoTabla(ids) {
        def tabla = "<table border='1' width='100%'>"

        def trs = []

        def tdEmpty = [:]
        tdEmpty.valor = ""

        ids.each { id ->
            def proyecto = Proyecto.get(id.toLong())

            def trProy = []
            def tdProy = [:]
            tdProy.colSpan = 4
            tdProy.tipo = "text"
            tdProy.valor = proyecto.nombre
            tdProy.style = "font-weight: bold; font-size:12pt; text-align:center; background: #aaa;"
            trProy.add(tdProy)
            trs.add(trProy)

            def trHF = []
            def td = [:]
            td.valor = "Fin"
            td.style = "font-weight: bold; font-size:10pt; text-align:center; background: #e5e5e5;"
            trHF.add(td)
            td = [:]
            td.valor = "Indicadores"
            td.style = "font-weight: bold; font-size:10pt; text-align:center; background: #e5e5e5;"
            trHF.add(td)
            td = [:]
            td.valor = "Medios de verificación"
            td.style = "font-weight: bold; font-size:10pt; text-align:center; background: #e5e5e5;"
            trHF.add(td)
            td = [:]
            td.valor = "Supuestos"
            td.style = "font-weight: bold; font-size:10pt; text-align:center; background: #e5e5e5;"
            trHF.add(td)
            trs.add(trHF)

            def trFin = []
            def tdFin = [:]
            tdFin.colSpan = 1
            tdFin.tipo = "text"
            tdFin.style = ""
            trFin.add(tdFin)
            trs.add(trFin)

            def elem = MarcoLogico.findAllByProyectoAndTipoElemento(proyecto, TipoElemento.findByDescripcion("Fin"), [sort: "id", order: "desc", max: 1])
            if (elem) {
                elem = elem[0]
            }

            tdFin.valor = elem.objeto

            def rowspanFin = 0

            def supuestosFin = Supuesto.findAllByMarcoLogicoAndEstado(elem, 0)
            def sizeSupuestosFin = supuestosFin.size()
            def contSupuesto = 0

            def indicadoresFin = Indicador.findAllByMarcoLogicoAndEstado(elem, 0)
            indicadoresFin.eachWithIndex { indi, indiCont ->
                def medios = MedioVerificacion.findAllByIndicadorAndEstado(indi, 0)
                rowspanFin += medios.size()
                def tdIndi = [:]
                tdIndi.colSpan = 1
                tdIndi.rowSpan = medios.size()
                tdIndi.tipo = "text"
                tdIndi.style = ""
                tdIndi.valor = indi.descripcion
                if (indiCont == 0) {
                    trFin.add(tdIndi)
                    medios.eachWithIndex { medio, medioCont ->
                        def tdMedio = [:]
                        tdMedio.colSpan = 1
                        tdMedio.rowSpan = 1
                        tdMedio.tipo = "text"
                        tdMedio.style = ""
                        tdMedio.valor = medio.descripcion
                        if (medioCont == 0) {
                            trFin.add(tdMedio)
                            if (contSupuesto < sizeSupuestosFin) {
                                def sup = supuestosFin[contSupuesto]
                                def tdSup = [:]
                                tdSup.colSpan = 1
                                tdSup.tipo = "text"
                                tdSup.style = ""
                                tdSup.valor = sup.descripcion
                                trFin.add(tdSup)
                                contSupuesto++
                            }
                        } else {
                            def trMedio = []
                            trMedio.add(tdMedio)
                            if (contSupuesto < sizeSupuestosFin) {
                                def sup = supuestosFin[contSupuesto]
                                def tdSup = [:]
                                tdSup.colSpan = 1
                                tdSup.tipo = "text"
                                tdSup.style = ""
                                tdSup.valor = sup.descripcion
                                trMedio.add(tdSup)
                                contSupuesto++
                            }
                            trs.add(trMedio)
                        }
                    }
                } else {
                    def trIndi = []
                    trIndi.add(tdIndi)
                    trs.add(trIndi)
                    medios.eachWithIndex { medio, medioCont ->
                        def tdMedio = [:]
                        tdMedio.colSpan = 1
                        tdMedio.rowSpan = 1
                        tdMedio.tipo = "text"
                        tdMedio.style = ""
                        tdMedio.valor = medio.descripcion
                        if (medioCont == 0) {
                            trIndi.add(tdMedio)
                            if (contSupuesto < sizeSupuestosFin) {
                                def sup = supuestosFin[contSupuesto]
                                def tdSup = [:]
                                tdSup.colSpan = 1
                                tdSup.tipo = "text"
                                tdSup.style = ""
                                tdSup.valor = sup.descripcion
                                trIndi.add(tdSup)
                                contSupuesto++
                            }
                        } else {
                            def trMedio = []
                            trMedio.add(tdMedio)
                            if (contSupuesto < sizeSupuestosFin) {
                                def sup = supuestosFin[contSupuesto]
                                def tdSup = [:]
                                tdSup.colSpan = 1
                                tdSup.tipo = "text"
                                tdSup.style = ""
                                tdSup.valor = sup.descripcion
                                trMedio.add(tdSup)
                                contSupuesto++
                            }
                            trs.add(trMedio)
                        }
                    }
                }
            }
            if (sizeSupuestosFin > rowspanFin) {
                rowspanFin = supuestosFin.size()
                for (def i = contSupuesto; i < sizeSupuestosFin; i++) {
                    def sup = supuestosFin[i]
                    def trSup = []
                    def tdSup = [:]
                    tdSup.colSpan = 1
                    tdSup.tipo = "text"
                    tdSup.style = ""
                    tdSup.valor = sup.descripcion
                    trSup.add(tdEmpty)
                    trSup.add(tdEmpty)
                    trSup.add(tdSup)
                    trs.add(trSup)
                }
            }
            tdFin.rowSpan = rowspanFin


            def trHP = []
            td = [:]
            td.valor = "Propósito"
            td.style = "font-weight: bold; font-size:10pt; text-align:center; background: #e5e5e5;"
            trHP.add(td)
            td = [:]
            td.valor = "Indicadores"
            td.style = "font-weight: bold; font-size:10pt; text-align:center; background: #e5e5e5;"
            trHP.add(td)
            td = [:]
            td.valor = "Medios de verificación"
            td.style = "font-weight: bold; font-size:10pt; text-align:center; background: #e5e5e5;"
            trHP.add(td)
            td = [:]
            td.valor = "Supuestos"
            td.style = "font-weight: bold; font-size:10pt; text-align:center; background: #e5e5e5;"
            trHP.add(td)
            trs.add(trHP)

            def trProp = []
            def tdProp = [:]
            tdProp.colSpan = 1
            tdProp.tipo = "text"
            tdProp.style = ""
            trProp.add(tdProp)
            trs.add(trProp)
            elem = MarcoLogico.findAllByProyectoAndTipoElemento(proyecto, TipoElemento.findByDescripcion("Proposito"), [sort: "id", order: "desc", max: 1])
            if (elem) {
                elem = elem[0]
            }

            tdProp.valor = elem.objeto

            def rowspanProp = 0

            def supuestosProp = Supuesto.findAllByMarcoLogicoAndEstado(elem, 0)
            def sizeSupuestosProp = supuestosProp.size()
            def contSupuesto2 = 0

            def indicadoresProp = Indicador.findAllByMarcoLogicoAndEstado(elem, 0)
            indicadoresProp.eachWithIndex { indi, indiCont ->
                def medios = MedioVerificacion.findAllByIndicadorAndEstado(indi, 0)
                rowspanProp += medios.size()
                def tdIndi = [:]
                tdIndi.colSpan = 1
                tdIndi.rowSpan = medios.size()
                tdIndi.tipo = "text"
                tdIndi.style = ""
                tdIndi.valor = indi.descripcion
                if (indiCont == 0) {
                    trProp.add(tdIndi)
                    medios.eachWithIndex { medio, medioCont ->
                        def tdMedio = [:]
                        tdMedio.colSpan = 1
                        tdMedio.rowSpan = 1
                        tdMedio.tipo = "text"
                        tdMedio.style = ""
                        tdMedio.valor = medio.descripcion
                        if (medioCont == 0) {
                            trProp.add(tdMedio)
                            if (contSupuesto2 < sizeSupuestosProp) {
                                def sup = supuestosProp[contSupuesto2]
                                def tdSup = [:]
                                tdSup.colSpan = 1
                                tdSup.tipo = "text"
                                tdSup.style = ""
                                tdSup.valor = sup.descripcion
                                trProp.add(tdSup)
                                contSupuesto2++
                            }
                        } else {
                            def trMedio = []
                            trMedio.add(tdMedio)
                            if (contSupuesto2 < sizeSupuestosProp) {
                                def sup = supuestosProp[contSupuesto2]
                                def tdSup = [:]
                                tdSup.colSpan = 1
                                tdSup.tipo = "text"
                                tdSup.style = ""
                                tdSup.valor = sup.descripcion
                                trMedio.add(tdSup)
                                contSupuesto2++
                            }
                            trs.add(trMedio)
                        }
                    }
                } else {
                    def trIndi = []
                    trIndi.add(tdIndi)
                    trs.add(trIndi)
                    medios.eachWithIndex { medio, medioCont ->
                        def tdMedio = [:]
                        tdMedio.colSpan = 1
                        tdMedio.rowSpan = 1
                        tdMedio.tipo = "text"
                        tdMedio.style = ""
                        tdMedio.valor = medio.descripcion
                        if (medioCont == 0) {
                            trIndi.add(tdMedio)
                            if (contSupuesto2 < sizeSupuestosProp) {
                                def sup = supuestosProp[contSupuesto2]
                                def tdSup = [:]
                                tdSup.colSpan = 1
                                tdSup.tipo = "text"
                                tdSup.style = ""
                                tdSup.valor = sup.descripcion
                                trIndi.add(tdSup)
                                contSupuesto2++
                            }
                        } else {
                            def trMedio = []
                            trMedio.add(tdMedio)
                            if (contSupuesto2 < sizeSupuestosProp) {
                                def sup = supuestosProp[contSupuesto2]
                                def tdSup = [:]
                                tdSup.colSpan = 1
                                tdSup.tipo = "text"
                                tdSup.style = ""
                                tdSup.valor = sup.descripcion
                                trMedio.add(tdSup)
                                contSupuesto2++
                            }
                            trs.add(trMedio)
                        }
                    }
                }
            }
            if (sizeSupuestosProp > rowspanProp) {
                rowspanProp = supuestosProp.size()
                for (def i = contSupuesto2; i < sizeSupuestosProp; i++) {
                    def sup = supuestosProp[i]
                    def trSup = []
                    def tdSup = [:]
                    tdSup.colSpan = 1
                    tdSup.tipo = "text"
                    tdSup.style = ""
                    tdSup.valor = sup.descripcion
                    trSup.add(tdEmpty)
                    trSup.add(tdEmpty)
                    trSup.add(tdSup)
                    trs.add(trSup)
                }
            }
            tdProp.rowSpan = rowspanProp


            def trHC = []
            td = [:]
            td.valor = "Componente"
            td.style = "font-weight: bold; font-size:10pt; text-align:center; background: #e5e5e5;"
            trHC.add(td)
            td = [:]
            td.valor = "Indicadores"
            td.style = "font-weight: bold; font-size:10pt; text-align:center; background: #e5e5e5;"
            trHC.add(td)
            td = [:]
            td.valor = "Medios de verificación"
            td.style = "font-weight: bold; font-size:10pt; text-align:center; background: #e5e5e5;"
            trHC.add(td)
            td = [:]
            td.valor = "Supuestos"
            td.style = "font-weight: bold; font-size:10pt; text-align:center; background: #e5e5e5;"
            trHC.add(td)
            trs.add(trHC)

            def componentes = MarcoLogico.findAllByProyectoAndTipoElemento(proyecto, TipoElemento.findByDescripcion("Componente"), [sort: "id", order: "asc"])
            componentes.each { elem2 ->
                def trComp = []
                def tdComp = [:]
                tdComp.colSpan = 1
                tdComp.tipo = "text"
                tdComp.style = ""
                trComp.add(tdComp)
                trs.add(trComp)

                tdComp.valor = elem2.objeto

                def rowspanComp = 0

                def supuestosComp = Supuesto.findAllByMarcoLogicoAndEstado(elem2, 0)
                def sizeSupuestosComp = supuestosComp.size()
                def contSupuesto3 = 0

                def indicadoresComp = Indicador.findAllByMarcoLogicoAndEstado(elem2, 0)
                indicadoresComp.eachWithIndex { indi, indiCont ->
                    def medios = MedioVerificacion.findAllByIndicadorAndEstado(indi, 0)
                    rowspanComp += medios.size()
                    def tdIndi = [:]
                    tdIndi.colSpan = 1
                    tdIndi.rowSpan = medios.size()
                    tdIndi.tipo = "text"
                    tdIndi.style = ""
                    tdIndi.valor = indi.descripcion
                    if (indiCont == 0) {
                        trComp.add(tdIndi)
                        medios.eachWithIndex { medio, medioCont ->
                            def tdMedio = [:]
                            tdMedio.colSpan = 1
                            tdMedio.rowSpan = 1
                            tdMedio.tipo = "text"
                            tdMedio.style = ""
                            tdMedio.valor = medio.descripcion
                            if (medioCont == 0) {
                                trComp.add(tdMedio)
                                if (contSupuesto3 < sizeSupuestosComp) {
                                    def sup = supuestosComp[contSupuesto3]
                                    def tdSup = [:]
                                    tdSup.colSpan = 1
                                    tdSup.tipo = "text"
                                    tdSup.style = ""
                                    tdSup.valor = sup.descripcion
                                    trComp.add(tdSup)
                                    contSupuesto3++
                                }
                            } else {
                                def trMedio = []
                                trMedio.add(tdMedio)
                                if (contSupuesto3 < sizeSupuestosComp) {
                                    def sup = supuestosComp[contSupuesto3]
                                    def tdSup = [:]
                                    tdSup.colSpan = 1
                                    tdSup.tipo = "text"
                                    tdSup.style = ""
                                    tdSup.valor = sup.descripcion
                                    trMedio.add(tdSup)
                                    contSupuesto3++
                                }
                                trs.add(trMedio)
                            }
                        }
                    } else {
                        def trIndi = []
                        trIndi.add(tdIndi)
                        trs.add(trIndi)
                        medios.eachWithIndex { medio, medioCont ->
                            def tdMedio = [:]
                            tdMedio.colSpan = 1
                            tdMedio.rowSpan = 1
                            tdMedio.tipo = "text"
                            tdMedio.style = ""
                            tdMedio.valor = medio.descripcion
                            if (medioCont == 0) {
                                trIndi.add(tdMedio)
                                if (contSupuesto3 < sizeSupuestosComp) {
                                    def sup = supuestosComp[contSupuesto3]
                                    def tdSup = [:]
                                    tdSup.colSpan = 1
                                    tdSup.tipo = "text"
                                    tdSup.style = ""
                                    tdSup.valor = sup.descripcion
                                    trIndi.add(tdSup)
                                    contSupuesto3++
                                }
                            } else {
                                def trMedio = []
                                trMedio.add(tdMedio)
                                if (contSupuesto3 < sizeSupuestosComp) {
                                    def sup = supuestosComp[contSupuesto3]
                                    def tdSup = [:]
                                    tdSup.colSpan = 1
                                    tdSup.tipo = "text"
                                    tdSup.style = ""
                                    tdSup.valor = sup.descripcion
                                    trMedio.add(tdSup)
                                    contSupuesto3++
                                }
                                trs.add(trMedio)
                            }
                        }
                    }
                }
                if (sizeSupuestosComp > rowspanComp) {
                    rowspanComp = supuestosComp.size()
                    for (def i = contSupuesto3; i < sizeSupuestosComp; i++) {
                        def sup = supuestosComp[i]
                        def trSup = []
                        def tdSup = [:]
                        tdSup.colSpan = 1
                        tdSup.tipo = "text"
                        tdSup.style = ""
                        tdSup.valor = sup.descripcion
                        trSup.add(tdEmpty)
                        trSup.add(tdEmpty)
                        trSup.add(tdSup)
                        trs.add(trSup)
                    }
                }
                tdComp.rowSpan = rowspanComp
            } //componentes.each

            def trActs = []
            def tdActs = [:]
            tdActs.colSpan = 4
            tdActs.tipo = "text"
            tdActs.valor = "Actividades"
            tdActs.style = "font-weight: bold; font-size:11pt; text-align:center; background: #ccc;"
            trActs.add(tdActs)
            trs.add(trActs)

            componentes.each { comp ->
                def trCompI = []
                def tdCompI = [:]
                tdCompI.colSpan = 4
                tdCompI.tipo = "text"
                tdCompI.valor = comp.objeto
                tdCompI.style = "font-weight: bold; font-size:10pt; text-align:center; background: #eee;"
                trCompI.add(tdCompI)
                trs.add(trCompI)


                def trHA = []
                td = [:]
                td.valor = "Actividad"
                td.style = "font-weight: bold; font-size:10pt; text-align:center; background: #e5e5e5;"
                trHA.add(td)
                td = [:]
                td.valor = "Monto"
                td.style = "font-weight: bold; font-size:10pt; text-align:center; background: #e5e5e5;"
                trHA.add(td)
                td = [:]
                td.valor = "Indicadores"
                td.style = "font-weight: bold; font-size:10pt; text-align:center; background: #e5e5e5;"
                trHA.add(td)
                td = [:]
                td.valor = "Supuestos"
                td.style = "font-weight: bold; font-size:10pt; text-align:center; background: #e5e5e5;"
                trHA.add(td)
                trs.add(trHA)

                def actividades = MarcoLogico.findAllByMarcoLogicoAndEstado(comp, 0)

                actividades.eachWithIndex { act, contAct ->
                    def rowspanAct = 0
                    def trAct = []
                    def tdAct = [:]
                    tdAct.valor = act.objeto
                    def tdMonto = [:]
                    tdMonto.valor = act.monto
                    tdMonto.tipo = "number"
                    tdMonto.style = "text-align:right;"
                    trAct.add(tdAct)
                    trAct.add(tdMonto)

                    def indicadores = Indicador.findAllByMarcoLogicoAndEstado(act, 0)
                    def supuestos = Supuesto.findAllByMarcoLogicoAndEstado(act, 0)
                    def sizeSupA = supuestos.size()
                    def contSupA = 0

                    indicadores.eachWithIndex { indi, contIndi ->
                        rowspanAct++
                        def tdIndi = [:]
                        tdIndi.colSpan = 1
                        tdIndi.rowSpan = 1
                        tdIndi.tipo = "text"
                        tdIndi.style = ""
                        tdIndi.valor = indi.descripcion
                        if (contIndi == 0) {
                            trAct.add(tdIndi)
                            if (contSupA < sizeSupA) {
                                def sup = supuestos[contSupA]
                                def tdSup = [:]
                                tdSup.colSpan = 1
                                tdSup.tipo = "text"
                                tdSup.style = ""
                                tdSup.valor = sup.descripcion
                                trAct.add(tdSup)
                                contSupA++
                            }
                        } else {
                            def trIndi = []
                            trIndi.add(tdIndi)
                            if (contSupA < sizeSupA) {
                                def sup = supuestos[contSupA]
                                def tdSup = [:]
                                tdSup.colSpan = 1
                                tdSup.tipo = "text"
                                tdSup.style = ""
                                tdSup.valor = sup.descripcion
                                trIndi.add(tdSup)
                                contSupA++
                            }
                            trs.add(trIndi)
                        }
                    }

                    if (sizeSupA > rowspanAct) {
                        rowspanAct = sizeSupA
                        for (def i = contSupA; i < sizeSupA; i++) {
                            def sup = supuestos[i]
                            def trSup = []
                            def tdSup = [:]
                            tdSup.colSpan = 1
                            tdSup.tipo = "text"
                            tdSup.style = ""
                            tdSup.valor = sup.descripcion
                            trSup.add(tdEmpty)
                            trSup.add(tdEmpty)
                            trSup.add(tdSup)
                            trs.add(trSup)
                        }
                    }


                    trs.add(trAct)
                }

            }

        } //ids.each

        trs.each { tr ->
            tabla += filaTablaReporte(tr, "")
        }

        tabla += "</table>"
        return tabla
    }

    def reporteFichaMarcoLogico(ids, links) {
        def tipo = links ? "link" : "span"
        def bosque = ""
        ids.each { id ->
            def arbol = ""
            def proyecto = Proyecto.get(id.toLong())
            def band = true
            def fin = MarcoLogico.findAllByProyectoAndTipoElemento(proyecto, TipoElemento.findByDescripcion("Fin"), [sort: "id", order: "desc", max: 1])
            if (fin) {
                fin = fin[0]
            } else {
                band = false
            }
            def prop = MarcoLogico.findAllByProyectoAndTipoElemento(proyecto, TipoElemento.findByDescripcion("Proposito"), [sort: "id", order: "desc", max: 1])
            if (prop) {
                prop = prop[0]
            } else {
                band = false
            }
            if (band) {
                arbol += "<div class='tree'>" //<div> tree
                arbol += "<ul class='ulProyecto'>" //<ul> proyecto
                arbol += "<li rel='proyecto' class='liProyecto'>" //<li> proyecto
                arbol += treeLabel("Proyecto: " + proyecto.nombre, tipo, "class='proyecto' style='font-weight:bold;'")
                arbol += "<ul class='ulFinPropositoComponentes'>" //<ul> Fin Proposito Componentes
                arbol += "<li rel='fin' class='liFin'>" //<li> fin
                arbol += treeLabel("<span style='font-weight:bold;'>Fin:</span> " + fin.objeto, tipo)
                arbol += "<ul class='ulIndicadoresSupuestos'>" //<ul> indicadores supuestos
                arbol += "<li rel='indicadores' class='liIndicadores'>" //<li> indicadores
                arbol += treeLabel("Indicadores", tipo, "style='font-weight:bold;'")
                def indicadores = Indicador.findAllByMarcoLogicoAndEstado(fin, 0)
                if (indicadores.size() > 0) {
                    arbol += "<ul class='ulIndicadores'>"
                    indicadores.each { indi ->
                        arbol += "<li rel='indicador' class='liIndicador'>" //<li> indicador
                        arbol += treeLabel(indi.descripcion, tipo)
                        arbol += "<ul class='ulMedios'>" //<ul> medios
                        arbol += "<li rel='medios' class='liMedios'>" //<li> medios
                        arbol += treeLabel("Medios de verificación", tipo, "style='font-weight:bold;'")
                        arbol += "<ul class='ulMedios'>" //<ul> medios
                        def medios = MedioVerificacion.findAllByIndicadorAndEstado(indi, 0)
                        if (medios.size() > 0) {
                            medios.each { md ->
                                arbol += "<li rel='medio' class='liMedio'>" //<li> medio
                                arbol += treeLabel(md.descripcion, tipo)
                                arbol += "</li>" //</li> medio
                            } //medios.eachs
                        } //if medios.size > 0
                        arbol += "</ul>"//</ul> medios
                        arbol += "</li>" //</li> medios
                        arbol += "</ul>" //</ul> medios
                        arbol += "</li>" //</li> indicador
                    } //indicadores.each
                    arbol += "</ul>" //</ul> indicadores
                } //if indicadores.size > 0
                arbol += "</li>" //</li> indicadores

                arbol += "<li rel='supuestos' class='liSupuestos'>" //<li> supuestos
                arbol += treeLabel("Supuestos", tipo, "style='font-weight:bold;'")
                def supuestos = Supuesto.findAllByMarcoLogicoAndEstado(fin, 0)
                if (supuestos.size() > 0) {
                    arbol += "<ul class='ulSupuestos'>" //<ul> supuestos
                    supuestos.each { sup ->
                        arbol += "<li rel='supuesto' class='liSupuesto'>" //<li> supuesto
                        arbol += treeLabel(sup.descripcion, tipo)
                        arbol += "</li>" //</li> supuesto
                    } //supuestos.each
                    arbol += "</ul>" //</ul> supuestos
                }//if supuestos.size > 0
                arbol += "</li>" //</li> supuestos
                arbol += "</ul>" //</ul> indicadores supuestos
                arbol += "</li>" //</li> fin

                arbol += "<li rel='propositos' class='liPropositos'>" //<li> propositos
                arbol += treeLabel("<span style='font-weight:bold;'>Propósito:</span> " + prop.objeto, tipo)
                arbol += "<ul class='ulIndicadoresSupuestos'>" //<ul> indicadores
                arbol += "<li rel='indicadores' class='liIndicadores'>" //<li> indicadores
                arbol += treeLabel("Indicadores", tipo, "style='font-weight:bold;'")
                indicadores = Indicador.findAllByMarcoLogicoAndEstado(prop, 0)
                if (indicadores.size() > 0) {
                    arbol += "<ul class='ulIndicadores'>" //<ul> indicadores
                    indicadores.each { indi ->
                        arbol += "<li rel='indicador' class='liIndicador'>" //<li> indicador
                        arbol += treeLabel(indi.descripcion, tipo)
                        arbol += "<ul class='ulMedios'>" //<ul> medios
                        arbol += "<li rel='medios' class='liMedios'>" //<li> medios
                        arbol += treeLabel("Medios de verificación", tipo, "style='font-weight:bold;'")
                        def medios = MedioVerificacion.findAllByIndicadorAndEstado(indi, 0)
                        if (medios.size() > 0) {
                            arbol += "<ul class='ulMedios'>" //<ul> medios
                            medios.each { md ->
                                arbol += "<li class='liMedio' rel='medio'>" //<li> medio
                                arbol += treeLabel(md.descripcion, tipo)
                                arbol += "</li>" //</li> medio
                            } //medios.each
                            arbol += "</ul>" //</ul> medios
                        } //if medios.size > 0
                        arbol += "</li>" //</li> medios
                        arbol += "</ul>" //</ul> medios
                        arbol += "</li>" //</li> indicador
                    } //indicadores.each
                    arbol += "</ul>" //</ul> indicadores
                } //if indicadores.size > 0
                arbol += "</li>" //</li> indicadores
                arbol += "<li rel='supuestos' class='liSupuestos'>" //<li> supuestos
                arbol += treeLabel("Supuestos", tipo, "style='font-weight:bold;'")
                supuestos = Supuesto.findAllByMarcoLogicoAndEstado(prop, 0)
                if (supuestos.size() > 0) {
                    arbol += "<ul class='ulSupuestos'>" //<ul> supuestos
                    supuestos.each { sup ->
                        arbol += "<li class='liSupuesto' rel='supuesto'>" //<li> supuesto
                        arbol += treeLabel(sup.descripcion, tipo)
                        arbol += "</li>" //</li> supuesto
                    } //supuestos.each
                    arbol += "</ul>" //</ul> supuestos
                } //if supuestos.size > 0
                arbol += "</li>" //</li> supuestos
                arbol += "</ul>" //</ul> indicadores supuestos
                arbol += "</li>" //</li> propositos

                arbol += "<li rel='componentes' class='liComponentes'>" //<li> componentes
                arbol += treeLabel("Componentes", tipo, "style='font-weight:bold;'")
                def componentes = MarcoLogico.findAllByProyectoAndTipoElemento(proyecto, TipoElemento.findByDescripcion("Componente"))
                if (componentes.size() > 0) {
                    arbol += "<ul class='ulComponentes'>" //<ul> componentes
                    componentes.eachWithIndex { cmp, i ->
                        if (cmp.estado == 0) {
                            arbol += "<li rel='componente' class='liComponente'>" //<li> componente
                            arbol += treeLabel("<span style='font-weight:bold;'>Componente # " + (i + 1) + "</span>: " + cmp.objeto, tipo)
                            arbol += "<ul class='ulIndicadoresSupuestosActividades'>"
                            //<ul> Indicadores Supuestos Actividades
                            arbol += "<li rel='indicadores' class='liIndicadores'>" //<li> indicadores
                            arbol += treeLabel("Indicadores", tipo, "style='font-weight:bold;'")
                            indicadores = Indicador.findAllByMarcoLogicoAndEstado(cmp, 0)
                            if (indicadores.size() > 0) {
                                arbol += "<ul class='ulIndicadores'>" //<ul> indicadores
                                indicadores.each { indi ->
                                    arbol += "<li rel='indicador' class='liIndicador'>" //<li> indicador
                                    arbol += treeLabel(indi.descripcion, tipo)
                                    arbol += "<ul class='ulMedios'>" //<ul> medios
                                    arbol += "<li rel='medios' class='liMedios'>" //<li> medios
                                    arbol += treeLabel("Medios de verificación", tipo, "style='font-weight:bold;'")
                                    def medios = MedioVerificacion.findAllByIndicadorAndEstado(indi, 0)
                                    if (medios.size() > 0) {
                                        arbol += "<ul class='ulMedios'>" //<ul> medios
                                        medios.each { md ->
                                            arbol += "<li rel='medio' class='liMedio'>" //<li> medio
                                            arbol += treeLabel(md.descripcion, tipo)
                                            arbol += "</li>" //</li> medio
                                        } //medios.each
                                        arbol += "</ul>" //</ul> medios
                                    } //if medios.size > 0
                                    arbol += "</li>" //</li> medios
                                    arbol += "</ul>" //</ul> medios
                                    arbol += "</li>" //</li> indicador
                                } //indicadores.each
                                arbol += "</ul>" //</ul> indicadores
                            } //if indicadores.size > 0
                            arbol += "</li>" //</li> indicadores

                            arbol += "<li rel='supuestos' class='liSupuestos'>" //<li> supuestos
                            arbol += treeLabel("Supuestos", tipo, "style='font-weight:bold;'")
                            supuestos = Supuesto.findAllByMarcoLogicoAndEstado(cmp, 0)
                            if (supuestos.size() > 0) {
                                arbol += "<ul class='ulSupuestos'>" //<ul> supuestos
                                supuestos.each { sup ->
                                    arbol += "<li rel='supuesto' class='liSupuesto'>" //<li> supuesto
                                    arbol += treeLabel(sup.descripcion, tipo)
                                    arbol += "</li>" //</li> supuesto
                                } //supuestos.each
                                arbol += "</ul>" //</ul> supuestos
                            } //if supuestos.size > 0
                            arbol += "</li>" //</li> supuestos

                            arbol += "<li rel='actividades' class='liActividades'>" //<li> actividades
                            arbol += treeLabel("Actividades", tipo, "style='font-weight:bold;'")
                            def actividades = MarcoLogico.findAllByMarcoLogicoAndEstado(cmp, 0)
                            if (actividades.size() > 0) {
                                arbol += "<ul class='ilActividades'>" //<ul> actividades
                                actividades.eachWithIndex { a, j ->
                                    arbol += "<li rel='actividad' class='liActividad'>" //<li> actividad
                                    arbol += treeLabel("<span style='font-weight:bold;'>Actividad #" + (j + 1) + ":</span> " + a.objeto, tipo)
                                    arbol += "<ul class='ulIndicadoresSupuestos'>" //<ul> indicadores supuestos
                                    arbol += "<li rel='indicadores' class='liIndicadores'>" //<li> indicadores
                                    arbol += treeLabel("Indicadores", tipo, "style='font-weight:bold;'")
                                    indicadores = Indicador.findAllByMarcoLogicoAndEstado(a, 0)
                                    if (indicadores.size() > 0) {
                                        arbol += "<ul class='ulIndicadores'>" //<ul> indicadores
                                        indicadores.each { indi ->
                                            arbol += "<li rel='indicador' class='liIndicador'>" //<li> indicador
                                            arbol += treeLabel(indi.descripcion, tipo)
                                            arbol += "</li>" //</li> indicador
                                        } //indicadores.each
                                        arbol += "</ul>" //</ul> indicadores
                                    } //if indicadores.size > 0
                                    arbol += "</li>" //</li> indicadores

                                    arbol += "<li rel='supuestos' class='liSupuestos'>" //<li> supuestos
                                    arbol += treeLabel("Supuestos", tipo, "style='font-weight:bold;'")
                                    supuestos = Supuesto.findAllByMarcoLogicoAndEstado(a, 0)
                                    if (supuestos.size() > 0) {
                                        arbol += "<ul class='ulSupuestos'>" //<ul> supuestos
                                        supuestos.each { sup ->
                                            arbol += "<li rel='supuesto' class='liSupuesto'>" //<li> supuesto
                                            arbol += treeLabel(sup.descripcion, tipo)
                                            arbol += "</li>" //</li> supuesto
                                        } //supuestos.each
                                        arbol += "</ul>" //</ul> supuestos
                                    }//if supuestos>0
                                    arbol += "</li>" //</li> supuestos

                                    arbol += "</ul>" //</ul> indicadores supuestos
                                    arbol += "</li>" //</li> actividad
                                } //actividades.each
                                arbol += "</ul>" //</ul> actividades
                            } //if actividades.size > 0
                            arbol += "</li>" //</li> actividades
                            arbol += "</ul>" //</ul> Indicadores Supuestos Actividades
                            arbol += "</li>" //</li> componente
                        } //if cmp.estado == 0
                    } //componentes.each
                    arbol += "</ul>" //</ul> componentes
                }//if comps.size > 0
                arbol += "</li>" //</li> componentes

                arbol += "</ul>" //<ul> Fin Proposito Componentes
                arbol += "</li>" //</li> proyecto
                arbol += "</ul>" //</ul> proyecto
                arbol += "</div>" //</div> tree
            } //if band (prop && fin
            else {
                arbol += '<div style="padding-left: 0.2cm;" class="mensaje error ui-state-error ui-corner-all">'
                arbol += "<p>"
                arbol += '<span style="float: left; margin-right: .3em;" class="ui-icon ui-icon-alert"></span>'
                arbol += "El proyecto <span style='font-weight:bold;'>" + proyecto.nombre + "</span> no tiene datos suficientes para mostrar el reporte"
                arbol += "</p>"
                arbol += '</div>'
            } //else
            bosque += arbol
        } //ids.each
        return bosque
    }

    def reportePoa(ids, anioId) {
        def anio = Anio.get(anioId)
        def unidades = []
//        println ids
        ids.each { id ->
            def unidadMap = [:]
            def unidad = UnidadEjecutora.get(id.toLong())
//            println unidad.id + "   " + unidad.nombre
            def asgInv = []
//            DistribucionAsignacion.findAllByUnidadEjecutora(unidad).each {
//                if (it.asignacion.anio == anio)
//                    asgInv.add(it.asignacion)
//            }
            def sigs = Asignacion.findAll("from Asignacion  where marcoLogico is not null and unidad=${unidad.id}  and planificado > 0")

            def asgInvDiv = []
            sigs.each { asig ->
                if (asig.marcoLogico.proyecto.unidadEjecutora.id.toInteger() != unidad.id.toInteger())
                    asgInvDiv.add(asig)
            }
            def proyectos = Proyecto.findAllByUnidadEjecutora(unidad)
            def programas = []
            def corrientes = [] /**/
            def programaMap
            proyectos.each { proy ->
                def programa = proy.programa
                if (!programas?.programa?.id.contains(programa?.id)) {
                    programaMap = [:]
                    programaMap.programa = programa
                    programaMap.proyectos = []
                    programas.add(programaMap)
                }
                def c = MarcoLogico.createCriteria()
                def ml = c.list {
                    and {
                        eq("proyecto", proy)
                        tipoElemento {
                            eq("id", 3.toLong())
                        }
                        eq("estado", 0)
                    }
                } //ml criteria
                def actividades = []
                ml.each { act ->
                    def marcoMap = [:]
                    marcoMap.actividad = act
                    marcoMap.asignaciones = Asignacion.findAll("from Asignacion where marcoLogico=${act.id} and anio=${anio.id} and unidad = ${unidad.id}")
//                        Asignacion.findAllByMarcoLogicoAndAnio(act, anio)
                    actividades.add(marcoMap)
                }
                def proyectoMap = [:]
                proyectoMap.proyecto = proy
                proyectoMap.actividades = actividades
                programaMap.proyectos.add(proyectoMap)
            }

//            corrientes = Asignacion.findAllByUnidadAndMarcoLogicoIsNull(unidad) /**/

            def c = Asignacion.createCriteria()
            corrientes = c.list {
                and {
                    eq("unidad", unidad)
                    isNull("marcoLogico")
                    eq("anio", anio)
                }
            }

            unidadMap.unidad = unidad
            unidadMap.programas = programas
            unidadMap.corrientes = corrientes /**/
            unidadMap.inversion = asgInv
            unidadMap.inversionDividido = asgInvDiv

//            println unidadMap
            unidades.add(unidadMap)
        }
        return unidades
    }

    def reportePoaOriginal(ids, anioId) {
        def anio = Anio.get(anioId)
        def unidades = []
//        println ids
        ids.each { id ->
            def unidadMap = [:]
            def unidad = UnidadEjecutora.get(id.toLong())
//            println unidad.id + "   " + unidad.nombre
            def proyectos = Proyecto.findAllByUnidadEjecutora(unidad)
            def programas = []
            def corrientes = [] /**/
            def programaMap
            proyectos.each { proy ->
                def programa = proy.programa
                if (!programas?.programa?.id.contains(programa?.id)) {
                    programaMap = [:]
                    programaMap.programa = programa
                    programaMap.proyectos = []
                    programas.add(programaMap)
                }
                def c = MarcoLogico.createCriteria()
                def ml = c.list {
                    and {
                        eq("proyecto", proy)
                        tipoElemento {
                            eq("id", 3.toLong())
                        }
                        eq("estado", 0)
                    }
                } //ml criteria
                def actividades = []
                ml.each { act ->
                    def marcoMap = [:]
                    marcoMap.actividad = act
                    marcoMap.asignaciones = Asignacion.findAllByMarcoLogicoAndAnio(act, anio)
                    actividades.add(marcoMap)
                }
                def proyectoMap = [:]
                proyectoMap.proyecto = proy
                proyectoMap.actividades = actividades
                programaMap.proyectos.add(proyectoMap)
            }

//            corrientes = Asignacion.findAllByUnidadAndMarcoLogicoIsNull(unidad) /**/

            def c = Asignacion.createCriteria()
            corrientes = c.list {
                and {
                    eq("unidad", unidad)
                    isNull("marcoLogico")
                    eq("anio", anio)
                }
            }

            def corrArr = []

            corrientes.each { corriente ->
                def corrMap = [:]
                corrMap.asignacion = corriente

                corrMap.desde = 0
                corrMap.hasta = 0

                ModificacionAsignacion.findAllByDesde(corriente).each { d ->
                    corrMap.desde += d.valor
                }

                ModificacionAsignacion.findAllByRecibe(corriente).each { h ->
                    corrMap.hasta += h.valor
                }

                corrArr.add(corrMap)
            }
            unidadMap.unidad = unidad
            unidadMap.programas = programas
            unidadMap.corrientes = corrArr /**/

//            println unidadMap
            unidades.add(unidadMap)
        }
        return unidades
    }

    def getModificaciones() {

    }

    def reportePoaInversiones(anioId, ids) {
        def anio = Anio.get(anioId)
        def tabla = ""

        def meses = Mes.list()

        ids.each { id ->
            def unidad = UnidadEjecutora.get(id)
            tabla += "<h1>" + unidad.nombre + "</h1>"

            tabla += "<table border='1' width='100%'>"
            tabla += "<thead>"
            tabla += "<tr>"
            tabla += "<th rowspan='2'>Proyecto</th>"
            tabla += "<th rowspan='2'>Actividad</th>"
            tabla += "<th rowspan='2'>Asignación</th>"
            tabla += "<th colspan='12'>Meses</th>"
            tabla += "</tr>"
            tabla += "<tr>"
            meses.each { mes ->
                tabla += "<th>" + mes.descripcion[0..2] + "." + "</th>"
            }
            tabla += "</tr>"
            tabla += "</thead>"

            tabla += "<tbody>"

            def filas = []
            def contProy = 0

            def proyectos = Proyecto.findAllByUnidadEjecutora(unidad)
            println unidad.nombre
            println proyectos

            proyectos.each { proy ->
                def fila = []
                def c = MarcoLogico.createCriteria()
                def actividades = c.list {
                    and {
                        eq("proyecto", proy)
                        tipoElemento {
                            eq("id", 3.toLong())
                        }
                        eq("estado", 0)
                    }
                } //ml criteria

//                def tdCup = [:]
//                tdCup.valor = proy.codigoProyecto
//                tdCup.rowSpan = 0
//                tdCup.tipo = "text"
//                tdCup.style = ""

                def tdNombre = [:]
                tdNombre.valor = proy.nombre + (proy.codigoProyecto ? "<br/><b>CUP: " + proy.codigoProyecto + "</b>" : "")
                tdNombre.rowSpan = 0
                tdNombre.tipo = "text"
                tdNombre.style = ""
                tdNombre.extras = "class='tdNombre'"

                def contAct = 0

//                println proy
//                println actividades.size()

                if (actividades.size() == 0) {
                    def tdNoDatos = [:]
                    tdNoDatos.valor = "No se encontraron datos"
                    tdNoDatos.rowSpan = 1
                    tdNoDatos.colSpan = 14
                    tdNoDatos.tipo = "text"
                    tdNoDatos.style = ""
                    tdNoDatos.extras = "class='tdNoDatos'"

//                    tdCup.rowSpan = 1
                    tdNombre.rowSpan = 1

//                    fila.add(tdCup)
                    fila.add(tdNombre)
                    fila.add(tdNoDatos)

                    filas.add(fila)

                    contAct++
                } else {
                    actividades.each { act ->
                        def asignaciones = Asignacion.findAllByMarcoLogicoAndAnio(act, anio)

                        def tdActividad = [:]
                        tdActividad.valor = act.objeto
                        tdActividad.rowSpan = asignaciones.size()
                        tdActividad.tipo = "text"
                        tdActividad.style = ""
                        tdActividad.extras = "class='tdActividad'"

//                        tdCup.rowSpan += asignaciones.size()
                        tdNombre.rowSpan += asignaciones.size()

                        def contAsg = 0
                        if (asignaciones.size() == 0) {
//                            tdCup.rowSpan++
//                            tdNombre.rowSpan++
//                            tdActividad.rowSpan++
//
//                            def tdAsignacion = [:]
//                            tdAsignacion.valor = "WTF"
//                            tdAsignacion.rowSpan = 1
//                            tdAsignacion.tipo = "text"
//                            tdAsignacion.style = ""
//
//                            def programacion = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
//                            if (contAct == 0 && contAsg == 0) {
//                                fila.add(tdCup)
//                                fila.add(tdNombre)
//                            } else {
//                                fila = []
//                            }
//                            if (contAsg == 0) {
//                                fila.add(tdActividad)
//                            } else {
//                                fila = []
//                            }
//                            fila.add(tdAsignacion)
//                            programacion.each { prgr ->
//                                def tdProgramacion = [:]
//                                tdProgramacion.valor = prgr
//                                tdProgramacion.colSpan = 1
//                                tdProgramacion.tipo = "text"
//                                tdProgramacion.style = ""
//
//                                fila.add(tdProgramacion)
//                            }
//                            filas.add(fila)
//                            if (programacion.size() > 0) {
//                                contAsg++
//                            }
                        } else {
                            asignaciones.each { asgn ->
                                def tdAsignacion = [:]
                                tdAsignacion.valor = g.formatNumber(number: asgn.planificado, format: "###,##0", minFractionDigits: "2", maxFractionDigits: "2")
                                tdAsignacion.rowSpan = 1
                                tdAsignacion.tipo = "text"
                                tdAsignacion.style = "text-align:right;"
                                tdAsignacion.extras = "class='tdAsignacion'"

//                                def programacion = ProgramacionAsignacion.findAllByAsignacionAndEstado(asgn, 0, [sort: 'mes'])
                                if (contAct == 0 && contAsg == 0) {
//                                    fila.add(tdCup)
                                    fila.add(tdNombre)
                                } else {
                                    fila = []
                                }
                                if (contAsg == 0) {
                                    fila.add(tdActividad)
                                } else {
                                    fila = []
                                }
                                fila.add(tdAsignacion)

                                meses.each { mes ->
                                    def prc = ProgramacionAsignacion.createCriteria()
                                    def programacion = prc.list {
                                        and {
                                            eq("asignacion", asgn)
                                            eq("estado", 0)
                                            eq("mes", mes)
                                        }
                                    }
                                    def prgr, valor = "?"
                                    if (programacion.size() == 1) {
                                        valor = g.formatNumber(number: programacion[0].valor, format: "###,##0", minFractionDigits: "2", maxFractionDigits: "2")
                                    } else if (programacion.size() == 0) {
                                        valor = g.formatNumber(number: 0, format: "###,##0", minFractionDigits: "2", maxFractionDigits: "2")
                                    } else {
                                        valor = "ERROR: mas de 1 valor para este mes"
                                    }
                                    def tdProgramacion = [:]
                                    tdProgramacion.valor = valor
                                    tdProgramacion.colSpan = 1
                                    tdProgramacion.tipo = "text"
                                    tdProgramacion.style = "text-align:right;"
//                                    tdProgramacion.extras = "class='tdProgramacion_act-" + act.id + "_asg-" + asgn.id + "_prgr-" + prgr.id + "_" + prgr.mes.descripcion + "'"

                                    fila.add(tdProgramacion)
                                }

//                                programacion.each { prgr ->
//                                    def tdProgramacion = [:]
//                                    tdProgramacion.valor = g.formatNumber(number: prgr.valor, format: "###,##0", minFractionDigits: "2", maxFractionDigits: "2")
//                                    tdProgramacion.colSpan = 1
//                                    tdProgramacion.tipo = "text"
//                                    tdProgramacion.style = "text-align:right;"
////                                    tdProgramacion.extras = "class='tdProgramacion_act-" + act.id + "_asg-" + asgn.id + "_prgr-" + prgr.id + "_" + prgr.mes.descripcion + "'"
//
//                                    fila.add(tdProgramacion)
//                                }
                                filas.add(fila)
//                                if (programacion.size() > 0) {
                                contAsg++
//                                }
                            } //asignaciones.each
                        }//if asignaciones.size > 0
                        if (asignaciones.size() > 0) {
                            contAct++
                        }
                    } //actividades.each
                } //if actividades.size > 0
                if (actividades.size() > 0) {
                    contProy++
                }
            } //proyectos.each


            filas.each { fila ->
//                println fila + "\n"
                tabla += filaTablaReporte(fila, "")
            }

            tabla += "</tbody>"

            tabla += "</table>"
        }

        return tabla
    }


    def reportePoaCorrientes(anioId, ids) {
        def anio = Anio.get(anioId)
        def tabla = ""

        def totalesMes = []
        def meses = Mes.list()

        ids.each { id ->
            def unidad = UnidadEjecutora.get(id)
            tabla += "<h1>" + unidad.nombre + "</h1>"

            tabla += "<table border='1' width='100%'>"
            tabla += "<thead>"
            tabla += "<tr>"
            tabla += "<th rowspan='2'>Programa</th>"
            tabla += "<th rowspan='2'>Actividad</th>"
            tabla += "<th rowspan='2'>Asignación</th>"
            tabla += "<th colspan='12'>Meses</th>"
            tabla += "</tr>"
            tabla += "<tr>"
            meses.each { mes ->
                tabla += "<th>" + mes.descripcion[0..2] + "." + "</th>"
                totalesMes[mes.numero] = 0
            }
            tabla += "</tr>"
            tabla += "</thead>"

            def proyectos = Proyecto.findAllByUnidadEjecutora(unidad)

            tabla += "<tbody>"

            def filas = []

            def total = 0

            def corrientes = Asignacion.findAllByUnidadAndMarcoLogicoIsNull(unidad)

            corrientes.each { corriente ->
                def fila = []
                def tdPrograma = [:]
                tdPrograma.valor = corriente.programa
//                tdPrograma.rowSpan = 0
                tdPrograma.tipo = "text"
                tdPrograma.style = ""
                tdPrograma.extras = "class='tdPrograma'"
                fila.add(tdPrograma)

                def tdActividad = [:]
                tdActividad.valor = corriente.actividad
//                tdActividad.rowSpan = 0
                tdActividad.tipo = "text"
                tdActividad.style = ""
                tdActividad.extras = "class='tdActividad'"
                fila.add(tdActividad)

                def tdAsignacion = [:]
                tdAsignacion.valor = g.formatNumber(number: corriente.planificado, format: "###,##0", minFractionDigits: 2, maxFractionDigits: 2)
//                tdAsignacion.rowSpan = 0
                tdAsignacion.tipo = "number"
                tdAsignacion.style = "font-weight: bold; text-align:right; "
                tdAsignacion.extras = "class='tdAsignacion'"
                fila.add(tdAsignacion)
                total += corriente.planificado

                meses.each { mes ->
                    def prc = ProgramacionAsignacion.createCriteria()
                    def programacion = prc.list {
                        and {
                            eq("asignacion", corriente)
                            eq("estado", 0)
                            eq("mes", mes)
                        }
                    }
                    def valor
                    if (programacion.size() == 1) {
                        valor = g.formatNumber(number: programacion[0].valor, format: "###,##0", minFractionDigits: "2", maxFractionDigits: "2")
                        totalesMes[mes.numero] += programacion[0].valor
                    } else if (programacion.size() == 0) {
                        valor = g.formatNumber(number: 0, format: "###,##0", minFractionDigits: "2", maxFractionDigits: "2")
                    } else {
                        valor = "ERROR: mas de 1 valor para este mes"
                    }
                    def tdProgramacion = [:]
                    tdProgramacion.valor = valor
                    tdProgramacion.colSpan = 1
                    tdProgramacion.tipo = "number"
                    tdProgramacion.style = "text-align:right; "
                    fila.add(tdProgramacion)
                }

                filas.add(fila)
            }

            def fla = []

            def tdTotal = [:]
            tdTotal.valor = "TOTAL"
            tdTotal.colSpan = 2
            tdTotal.tipo = "text"
            tdTotal.style = "text-align:right; font-weight:bold;"
            fla.add(tdTotal)

            def tdTotal1 = [:]
            tdTotal1.valor = total
            tdTotal1.colSpan = 1
            tdTotal1.tipo = "number"
            tdTotal1.style = "text-align:right; font-weight:bold;"
            fla.add(tdTotal1)

            totalesMes.eachWithIndex { tot, i ->
                if (i > 0) {
                    def tdProgramacion = [:]
                    tdProgramacion.valor = tot
                    tdProgramacion.colSpan = 1
                    tdProgramacion.tipo = "number"
                    tdProgramacion.style = "text-align:right; font-weight:bold;"
                    fla.add(tdProgramacion)
                }
            }


            filas.each { fila ->
//                println fila + "\n"
                tabla += filaTablaReporte(fila, "")
            }
            tabla += filaTablaReporte(fla, "")

            tabla += "</tbody>"

            tabla += "</table>"
        }

        return tabla
    }

    def reporteEjecucionProyectos(id) {

        def parts = id.split("_")
        def mesId = parts[0]
        def anioId = parts[1]

        def proyectos = Proyecto.list()
        def ret = []

        proyectos.each { proy ->
            def mapProy = [:]
            mapProy.proyecto = proy.nombre
            mapProy.monto = proy.monto
            mapProy.asignaciones = 0
            mapProy.vigente = 0
            mapProy.compromiso = 0
            mapProy.devengado = 0
            mapProy.pagado = 0
            mapProy.saldoPresupuesto = 0
            mapProy.saldoDisponible = 0

            def c = MarcoLogico.createCriteria()
            def actividades = c.list {
                and {
                    eq("proyecto", proy)
                    tipoElemento {
                        eq("id", 3.toLong())
                    }
                    eq("estado", 0)
                }
            } //ml criteria
            actividades.each { acts ->
                def asignaciones = Asignacion.findAllByMarcoLogico(acts)
                asignaciones.each { asg ->
                    mapProy.asignaciones += asg.planificado

                    def c1 = Ejecucion.createCriteria()
                    def ejecuciones = c1.list {
                        eq("asignacion", asg)
                        sigef {
                            and {
                                anio {
                                    eq("id", anioId.toLong())
                                }
                                mes {
                                    eq("id", mesId.toLong())
                                }
                            }
                            order("fecha", "desc")
                        }
                    } //ml criteria

//                    def ejecuciones = Ejecucion.findAllByAsignacion(asg)
                    ejecuciones.each { ejec ->
                        mapProy.vigente += ejec.vigente
                        mapProy.compromiso += ejec.compromiso
                        mapProy.devengado += ejec.devengado
                        mapProy.pagado += ejec.pagado
                        mapProy.saldoPresupuesto += ejec.saldoPresupuesto
                        mapProy.saldoDisponible += ejec.saldoDisponible
                    }
                }
            }
            println mapProy
            ret.add(mapProy)
        }


        return ret
    }

    def reporteComponentes(ids) {
        def proyectos = []

        ids.each { id ->
            def mapProyecto = [:]

            def proyecto = Proyecto.get(id.toLong())
            mapProyecto.proyecto = proyecto

            def listComponentes = []

            def c = MarcoLogico.createCriteria()
            def componentes = c.list {
                and {
                    eq("proyecto", proyecto)
                    tipoElemento {
                        eq("id", 2.toLong())
                    }
                    eq("estado", 0)
                    order("id", "asc")
                }
            } //ml criteria

            componentes.each { comp ->
                def mapComponentes = [:]
                def actividades = MarcoLogico.findAllByEstadoAndMarcoLogico(0, comp, [sort: "id"])
                mapComponentes.componente = comp
                mapComponentes.actividades = actividades
                listComponentes.add(mapComponentes)
            }
            mapProyecto.componentes = listComponentes

            proyectos.add(mapProyecto)
        }
        return proyectos
    }


    def reportePac(ids, anioId) {
        def anio = Anio.get(anioId)
        def unidadEjecutora = UnidadEjecutora.findByCodigo("280")

        def ret = []

        ids.each { id ->
            def unidad = UnidadEjecutora.get(id)
            def c = Obra.createCriteria()
            def results = c.list {
                asignacion {
                    eq("anio", anio)
                    eq("unidad", unidad)
                }
            }

            results.each { obra ->
                def m = [:]

                m.ejercicio = anio.anio
                m.entidad = app.codigo
                m.unidadEjecutora = obra.asignacion.unidad.codigo
                m.unidadDesconcentrada = "0000"
                //println "obra "+obra.id+" asgn "+obra.asignacion.id
                if (obra.asignacion.marcoLogico)
                    m.programa = obra.asignacion.marcoLogico.proyecto.programaPresupuestario.descripcion
                else
                    m.programa = obra.asignacion.programa.descripcion
                m.subprograma = "00"
                m.proyecto = (obra.asignacion?.tipoGasto?.id == 2.toLong()) ? obra.asignacion?.marcoLogico?.proyecto?.nombre : "000"
                //m.actividad = obra.asignacion.actividad
                m.actividad = "001"
                //m.obra = obra.descripcion
                m.obra = "00"
                m.geografico = "000000"
                m.renglon = obra.asignacion.presupuesto.numero
                m.renglonAuxiliar = "0000"
                m.fuente = obra.asignacion.fuente.codigo
                m.organismo = ""
                m.correlativo = ""
                m.codigo = obra.codigoComprasPublicas.numero
                m.tipoCompra = obra.tipoCompra.descripcion
                m.detalle = obra.descripcion
                m.unidad = obra.unidad?.descripcion
                m.cantidadAnual = obra.cantidad
                m.costoUnitario = obra.costo
                m.cuatrimestre1 = (obra.cuatrimestre1 && obra.cuatrimestre1?.trim() == "1") ? "S" : ""
                m.cuatrimestre2 = (obra.cuatrimestre2 && obra.cuatrimestre2?.trim() == "1") ? "S" : ""
                m.cuatrimestre3 = (obra.cuatrimestre3 && obra.cuatrimestre3?.trim() == "1") ? "S" : ""
                m.presupuesto = obra.asignacion.presupuesto.descripcion

                ret.add(m)
            }
        }

        return ret
    }

    def reportePacXls(ids, anioId) {
        def anio = Anio.get(anioId)
        def unidadEjecutora = UnidadEjecutora.findByCodigo("280")

        def ret = []

        ids.each { id ->
            def unidad = UnidadEjecutora.get(id)
            def c = Obra.createCriteria()
            def results = c.list {
                asignacion {
                    eq("anio", anio)
                    eq("unidad", unidad)
                }
            }

            results.each { obra ->
                def m = [:]

                m.ejercicio = anio.anio
                m.entidad = app.codigo
                m.unidadEjecutora = obra.asignacion.unidad.codigo
                m.unidadDesconcentrada = "0000"
//                m.programa = obra.asignacion.programa.codigo
                if (obra.asignacion.marcoLogico)
                    m.programa = obra.asignacion.marcoLogico.proyecto.programaPresupuestario.codigo
                else
                    m.programa = obra.asignacion.programa.codigo
                m.subprograma = "00"
                m.proyecto = (obra.asignacion?.tipoGasto?.id == 2.toLong()) ? obra.asignacion?.marcoLogico?.proyecto?.nombre : "000"
                //m.actividad = obra.asignacion.actividad
                m.actividad = "001"
                //m.obra = obra.descripcion
                m.obra = "00"
                m.geografico = "000000"
                m.renglon = obra.asignacion.presupuesto.numero
                m.renglonAuxiliar = "0000"
                m.fuente = obra.asignacion.fuente.codigo
                m.organismo = ""
                m.correlativo = ""
                m.codigo = obra.codigoComprasPublicas.numero
                m.tipoCompra = obra.tipoCompra.descripcion
                m.detalle = obra.descripcion
                m.detalle1 = obra.asignacion.actividad
                m.unidad = obra.unidad?.descripcion
                m.cantidadAnual = obra.cantidad
                m.costoUnitario = obra.costo
                m.cuatrimestre1 = (obra.cuatrimestre1 && obra.cuatrimestre1?.trim() == "1") ? "S" : ""
                m.cuatrimestre2 = (obra.cuatrimestre2 && obra.cuatrimestre2?.trim() == "1") ? "S" : ""
                m.cuatrimestre3 = (obra.cuatrimestre3 && obra.cuatrimestre3?.trim() == "1") ? "S" : ""
                m.presupuesto = obra.asignacion.presupuesto.descripcion

                ret.add(m)
            }
        }

        return ret
    }

    /**
     * Acción
     */
    def avanceGUI = {

    }

    /**
     * Acción
     */
    def avanceReporteWeb = {
        params.id = params.id.split(",")
        if (params.id.class == java.lang.String) {
            params.id = [params.id]
        }
        return [resultados: reporteAvance(params.id)]
    }

    /**
     * Acción
     */
    def avanceReportePDF = {
        params.id = params.id.split(",")
        if (params.id.class == java.lang.String) {
            params.id = [params.id]
        }
        return [resultados: reporteAvance(params.id)]
    }

    /**
     * Acción
     */
    def intervencionGUI = {}

    /**
     * Acción
     */
    def intervencionReporteWeb = {
        return [tabla: reporteIntervencion(params), anio: params.anio]
    }

    /**
     * Acción
     */
    def intervencionReportePDF = {
        return [tabla: reporteIntervencion(params), anio: params.anio]
    }

    /**
     * Acción
     */
    def fichaProyectoGUI = {}

    /**
     * Acción
     */
    def fichaProyectoWeb = {
        params.id = params.id.split(",")
        if (params.id.class == java.lang.String) {
            params.id = [params.id]
        }
        return [proyectos: reporteFichaProyecto(params.id)]
    }

    /**
     * Acción
     */
    def fichaProyectoPDF = {
        params.id = params.id.split(",")
        if (params.id.class == java.lang.String) {
            params.id = [params.id]
        }
        return [proyectos: reporteFichaProyecto(params.id)]
    }

    /**
     * Acción
     */
    def buscarParroquias = {
        def parroquias = []
        if (params.parametro.trim().size() > 0) {
            parroquias = Parroquia.findAll("from Parroquia where nombre like '%${params.parametro.toUpperCase()}%' order by nombre")
            def provs = Provincia.findAll("from Provincia where nombre like '%${params.parametro.toUpperCase()}%' order by nombre")
            def cntns = Canton.findAll("from Canton where nombre like '%${params.parametro.toUpperCase()}%' order by nombre")
            provs.each {
                Canton.findAllByProvincia(it).each { c ->
                    Parroquia.findAllByCanton(c).each { pr ->
                        if (!parroquias.contains(pr)) {
                            parroquias.add(pr)
                        }
                    }
                }
            }
            cntns.each { c ->
                Parroquia.findAllByCanton(c).each { pr ->
                    if (!parroquias.contains(pr)) {
                        parroquias.add(pr)
                    }
                }
            }

        } else {
            parroquias = Parroquia.list([sort: "nombre", max: 20])
        }
        [parroquias: parroquias]
    }

    def reporteMetas(params) {
        println "buscar meta " + params

        def meta = 0
        def inversion = 0
        try {
            inversion = params.inversion.toDouble()
        } catch (e) {
            println "no hay o mal dato inv: " + params.inversion
            inversion = -1
        }
        try {
            meta = params.meta.toDouble()
        } catch (e) {
            println "no hay o mal dato meta: " + params.meta
            meta = -1
        }
        def parroquiaParam = params.parroquia.trim()
        def all = parroquiaParam == "all" ? true : false
        def parts = parroquiaParam.split("_")

        def tipo = "all", id

        if (!all) {
            id = parts[1].toString().toLong()
            tipo = parts[0]
        }

        def c = Meta.createCriteria()
        def metas = c.list {
            and {
                if (params.indicador.trim().size() > 0) {
                    if (params.indicador != "-1") {
                        eq("tipoMeta", TipoMeta.get(params.indicador.toLong()))
                    } else {
                        isNotNull("tipoMeta")
                    }
                }
                if (tipo == 'par') {
                    eq("parroquia", Parroquia.get(id))
                } else if (tipo == 'cnt') {
                    parroquia {
                        eq("canton", Canton.get(id))
                    }
                } else if (tipo == 'prv') {
                    parroquia {
                        canton {
                            eq("provincia", Provincia.get(id))
                        }
                    }
                } else if (tipo == "all") {

                }
                if (meta != -1) {
                    switch (params.tipoMeta) {
                        case "1":
                            eq("indicador", meta)
                            break;
                        case "2":
                            gt("indicador", meta)
                            break;
                        case "3":
                            lt("indicador", meta)
                            break;
                    }
                }
                if (inversion != -1) {
                    switch (params.tipoInversion) {
                        case "1":
                            eq("inversion", inversion)
                            break;
                        case "2":
                            gt("inversion", inversion)
                            break;
                        case "3":
                            lt("inversion", inversion)
                            break;
                    }
                }
            }
            and {
                tipoMeta {
                    order("descripcion", "asc")
                }
                if (tipo == 'par') {
                    parroquia {
                        order("nombre", "asc")
                    }
                } else if (tipo == 'cnt') {
                    parroquia {
                        canton {
                            order("nombre", "asc")
                        }
                    }
                    parroquia {
                        order("nombre", "asc")
                    }
                } else if (tipo == 'prv') {
                    parroquia {
                        canton {
                            provincia {
                                order("nombre", "asc")
                            }
                        }
                    }
                    parroquia {
                        canton {
                            order("nombre", "asc")
                        }
                    }
                    parroquia {
                        order("nombre", "asc")
                    }
                }
            }
        }
        return metas
    }

    /**
     * Acción
     */
    def metasGUI = {
        def signos = [[1: "Igual"], [2: "Mayor"], [3: "Menor"]]
        return [signos: signos]
    }
    /**
     * Acción
     */
    def metasWeb = {
        [metas: reporteMetas(params)]
    }
    /**
     * Acción
     */
    def metasPDF = {}
    /**
     * Acción
     */
    def metasXls = {
        def metas = reporteMetas(params)

        WorkbookSettings workbookSettings = new WorkbookSettings()
        workbookSettings.locale = Locale.default
        def file = File.createTempFile('Metas', '.xls')
        file.deleteOnExit()
        println "metas xls"
        WritableWorkbook workbook = Workbook.createWorkbook(file, workbookSettings)
        WritableFont font = new WritableFont(WritableFont.ARIAL, 12)
        WritableCellFormat formatXls = new WritableCellFormat(font)
        def row = 1
        WritableSheet sheet = workbook.createSheet('Metas', 0)

        sheet.setColumnView(0, 30)
        sheet.setColumnView(1, 30)
        sheet.setColumnView(2, 50)
        sheet.setColumnView(3, 60)
        sheet.setColumnView(4, 60)
        sheet.setColumnView(5, 60)
        sheet.setColumnView(6, 20)
        sheet.setColumnView(7, 20)
        sheet.setColumnView(8, 20)
        sheet.setColumnView(9, 20)

        def label
        def number

        /*Header*/
        WritableFont arial12font = new WritableFont(WritableFont.ARIAL, 12, WritableFont.BOLD, true);
        WritableCellFormat arial12format = new WritableCellFormat(arial12font);

        label = new Label(0, row, "Proyecto", arial12format);
        sheet.addCell(label);
        label = new Label(1, row, "Unidad", arial12format);
        sheet.addCell(label);
        label = new Label(2, row, "Provincia", arial12format);
        sheet.addCell(label);

        label = new Label(3, row, "Componente", arial12format);
        sheet.addCell(label);
        label = new Label(4, row, "Actividad", arial12format);
        sheet.addCell(label);

        label = new Label(5, row, "Indicador", arial12format);
        sheet.addCell(label);

        label = new Label(6, row, "Cantón", arial12format);
        sheet.addCell(label);
        label = new Label(7, row, "Parroquia", arial12format);
        sheet.addCell(label);
        label = new Label(8, row, "Meta", arial12format);
        sheet.addCell(label);
        label = new Label(9, row, "Inversión", arial12format);
        sheet.addCell(label);
        row++
        /*Fin header*/

        metas.each { meta ->

            label = new Label(0, row, meta?.marcoLogico.proyecto.nombre);
            sheet.addCell(label);
            label = new Label(1, row, meta?.marcoLogico.proyecto.unidadEjecutora.nombre);
            sheet.addCell(label);
            label = new Label(2, row, meta?.parroquia?.canton?.provincia?.nombre);
            sheet.addCell(label);

            label = new Label(3, row, meta?.marcoLogico?.marcoLogico?.objeto);
            sheet.addCell(label);
            label = new Label(4, row, meta?.marcoLogico?.objeto);
            sheet.addCell(label);

            label = new Label(5, row, meta?.tipoMeta?.descripcion);
            sheet.addCell(label);


            label = new Label(6, row, meta?.parroquia?.canton?.nombre);
            sheet.addCell(label);

            label = new Label(7, row, meta?.parroquia?.nombre);
            sheet.addCell(label);

            number = new Number(8, row, meta?.indicador);
            sheet.addCell(number);

            number = new Number(9, row, meta?.inversion);
            sheet.addCell(number);

            row++
        }

//        label = new Label(1, columna, "9999");
//        sheet.addCell(label);
//        number = new Number(3, columna, asignado99);
//        sheet.addCell(number);


        workbook.write();
        workbook.close();
        def output = response.getOutputStream()
        def header = "attachment; filename=" + "metas.xls";
        response.setContentType("application/octet-stream")
        response.setHeader("Content-Disposition", header);
        output.write(file.getBytes());
    }

    /**
     * Acción
     */
    def marcoLogicoGUI = {}

    /**
     * Acción
     */
    def marcoLogicoWeb = {
        params.id = params.id.split(",")
        if (params.id.class == java.lang.String) {
            params.id = [params.id]
        }

        return [tabla: reporteMarcoLogicoTabla(params.id)]
    }

    /**
     * Acción
     */
    def marcoLogicoPDF = {
        params.id = params.id.split(",")
        if (params.id.class == java.lang.String) {
            params.id = [params.id]
        }

        return [tabla: reporteMarcoLogicoTabla(params.id)]
    }

    /**
     * Acción
     */
    def fichaMarcoLogicoGUI = {}

    /**
     * Acción
     */
    def fichaMarcoLogicoWeb = {
        params.id = params.id.split(",")
        if (params.id.class == java.lang.String) {
            params.id = [params.id]
        }
        return [bosque: reporteFichaMarcoLogico(params.id, true)]
//        return [proyectos: reporteFichaMarcoLogico_(params.id)]
    }

    /**
     * Acción
     */
    def fichaMarcoLogicoPDF = {
        params.id = params.id.split(",")
        if (params.id.class == java.lang.String) {
            params.id = [params.id]
        }
        return [bosque: reporteFichaMarcoLogico(params.id, false)]
    }

    /**
     * Acción
     */
    def poaOriginalGUI = {}

    /**
     * Acción
     */
    def poaOriginalReporteWeb = {
        params.id = params.id.split(",")
        if (params.id.class == java.lang.String) {
            params.id = [params.id]
        }
        return [unidades: reportePoaOriginal(params.id, params.anio)]
    }

    /**
     * Acción
     */
    def poaGUI = {}

    /**
     * Acción
     */
    def poaReporteWeb = {
        params.id = params.id.split(",")
        if (params.id.class == java.lang.String) {
            params.id = [params.id]
        }
        return [unidades: reportePoa(params.id, params.anio)]
    }

    /**
     * Acción
     */
    def poaReportePDF = {
        params.id = params.id.split(",")
        if (params.id.class == java.lang.String) {
            params.id = [params.id]
        }
        return [unidades: reportePoa(params.id, params.anio)]
    }

    /**
     * Acción
     */
    def poaReporteDisc = {
        Number number
        WorkbookSettings workbookSettings = new WorkbookSettings()
        workbookSettings.locale = Locale.default
        params.mes = "true"

        def file = File.createTempFile('myExcelDocument', '.xls')
        file.deleteOnExit()

        WritableWorkbook workbook = Workbook.createWorkbook(file, workbookSettings)

        WritableFont font = new WritableFont(WritableFont.ARIAL, 12)
        WritableCellFormat formatXls = new WritableCellFormat(font)

        def row = 0
        WritableSheet sheet = workbook.createSheet('MySheet', 0)
//
        sheet.setColumnView(1, 40)

//            Label label = new Label(0, 2, "A label record");
//            sheet.addCell(label);

//        list.each {
//            sheet.addCell(new Label(0, row, it.codigo, format))
//            sheet.addCell(new Label(1, row++, it.nombre, format))
//        }


        params.id = params.id.split(",")
        if (params.id.class == java.lang.String) {
            params.id = [params.id]
        }
        def unidades = reportePoa(params.id, params.anio)

        /*header*/
        WritableFont times16font = new WritableFont(WritableFont.TIMES, 11, WritableFont.BOLD, true);
        WritableCellFormat times16format = new WritableCellFormat(times16font);
        Label label = new Label(0, 1, "Entidad", times16format);
        sheet.addCell(label);
        label = new Label(1, 1, "Unidad Ejecutora", times16format);
        sheet.addCell(label);
        label = new Label(2, 1, "Objetivo estratégico", times16format);
        sheet.addCell(label);
        label = new Label(3, 1, "Eje programático", times16format);
        sheet.addCell(label);
        label = new Label(4, 1, "Política", times16format);
        sheet.addCell(label);
        label = new Label(5, 1, "CUP", times16format);
        sheet.addCell(label);
        label = new Label(6, 1, "Programa", times16format);
        sheet.addCell(label);
        label = new Label(7, 1, "Proyecto", times16format);
        sheet.addCell(label);
        label = new Label(8, 1, "Componente", times16format);
        sheet.addCell(label);
        label = new Label(9, 1, "Actividad", times16format);
        sheet.addCell(label);
        label = new Label(10, 1, "Meta", times16format);
        sheet.addCell(label);
        label = new Label(11, 1, "Indicador", times16format);
        sheet.addCell(label);
        label = new Label(12, 1, "Tipo gasto", times16format);
        sheet.addCell(label);
        label = new Label(13, 1, "Fuente financiamiento", times16format);
        sheet.addCell(label);
        label = new Label(14, 1, "Grupo gasto", times16format);
        sheet.addCell(label);
        label = new Label(15, 1, "Partida presupuestaria", times16format);
        sheet.addCell(label);
        label = new Label(16, 1, "Asignado", times16format);
        sheet.addCell(label);
        /*fin header*/
        def columna = 2

        def max = 17
        if (params.mes == "true") {
            Mes.list([sort: 'numero']).each { mes ->
                label = new Label(16 + mes.numero, 1, mes.descripcion, times16format);
                sheet.addCell(label);
                max++
            }
        }
        label = new Label(max, 1, "Total presupuesto", times16format);
        sheet.addCell(label);

        def granTotal = 0

        unidades.each {
            def pu = PresupuestoUnidad.findByUnidadAndAnio(it.unidad, Anio.get(params.anio))
            def totalAsignado = 0, totalTotal = 0
            def totalMeses = []
            12.times { t ->
                totalMeses[t] = 0
            }


            it.inversionDividido.each { inv ->

                def total = 0
                def agr = []
                12.times { mes ->
                    def mm = mes + 1
                    def pr = ProgramacionAsignacion.findAll("from ProgramacionAsignacion where asignacion = ${inv.id} and mes = ${mm}")
                    if (pr.size() == 1) {
                        pr = pr[0]

                        if (params.mes == "true") {
                            number = new Number(17 + mes, columna, pr.valor);
                            agr.add(number)
//                            sheet.addCell(number);
                        }
                        total += pr.valor
                        totalMeses[mes] += pr.valor
                    } else if (pr.size() > 1) {
                        if (params.mes == "true") {
                        }
                    } else {
                        if (params.mes == "true") {
                            number = new Number(17 + mes, columna, 0);
                            agr.add(number)
//                            sheet.addCell(number);
                        }
                    }
                }

                //println "inv dividido "+inv.id+" plan  "+inv.planificado+" suma "+total

                if (total.toFloat().round(2) != inv.planificado.toFloat().round(2)) {
                    label = new Label(0, columna, "APP");
                    sheet.addCell(label);
                    label = new Label(1, columna, it.unidad.nombre);
                    sheet.addCell(label);
                    label = new Label(2, columna, inv.marcoLogico.proyecto.objetivoEstrategico.descripcion);
                    sheet.addCell(label);
                    label = new Label(3, columna, inv.marcoLogico.proyecto.ejeProgramatico.descripcion);
                    sheet.addCell(label);
                    def politicas = PoliticasProyecto.findByProyecto(inv.marcoLogico.proyecto)
                    label = new Label(4, columna, politicas.politica.descripcion);
                    sheet.addCell(label);
                    label = new Label(5, columna, inv.marcoLogico.proyecto.codigoProyecto);
                    sheet.addCell(label);
                    label = new Label(6, columna, inv.marcoLogico.proyecto.programa.descripcion);
                    sheet.addCell(label);
                    label = new Label(7, columna, inv.marcoLogico.proyecto.nombre);
                    sheet.addCell(label);
                    label = new Label(8, columna, inv.marcoLogico.marcoLogico.objeto);
                    sheet.addCell(label);
                    label = new Label(9, columna, inv.marcoLogico.objeto);
                    sheet.addCell(label);
                    label = new Label(10, columna, inv.id.toString());
                    sheet.addCell(label);
                    label = new Label(11, columna, inv.indicador);
                    sheet.addCell(label);
                    label = new Label(12, columna, "Inversión");
                    sheet.addCell(label);
                    label = new Label(13, columna, inv.fuente.descripcion);
                    sheet.addCell(label);
                    label = new Label(14, columna, inv.presupuesto?.presupuesto?.descripcion);
                    sheet.addCell(label);
                    label = new Label(15, columna, inv.presupuesto?.numero);
                    sheet.addCell(label);
                    number = new Number(16, columna, inv.planificado);
                    sheet.addCell(number);

                    agr.each { celda ->
                        sheet.addCell(celda);
                    }

                    totalAsignado += inv.planificado


                    if (params.mes == "true")
                        number = new Number(29, columna, total);
                    else
                        number = new Number(17, columna, total);
                    sheet.addCell(number);
                    totalTotal += total
                    columna++
                }


            }


            it.programas.each { programaMap ->
                if (programaMap.proyectos.size() > 0 && programaMap.proyectos.actividades.size() > 0 && programaMap.proyectos.actividades.asignaciones.size() > 0) {
                    programaMap.proyectos.each { proyectoMap ->
                        proyectoMap.actividades.each { actividadMap ->
                            actividadMap.asignaciones.each { asignacion ->
                                if (asignacion.reubicada != 'S') {
                                    def total = 0
                                    def agr = []
                                    12.times { mes ->
                                        def mm = mes + 1
                                        def pr = ProgramacionAsignacion.findAll("from ProgramacionAsignacion where asignacion = ${asignacion.id} and mes = ${mm}")
                                        if (pr.size() == 1) {
                                            pr = pr[0]
                                            def desde = ModificacionAsignacion.findAllByDesde(pr.asignacion)
                                            def hasta = ModificacionAsignacion.findAllByRecibe(pr.asignacion)
                                            if (params.mes == "true") {
                                                number = new Number(17 + mes, columna, pr.valor);
                                                agr.add(number)
                                            }
                                            total += pr.valor
                                            totalMeses[mes] += pr.valor
                                        } else if (pr.size() > 1) {
                                            if (params.mes == "true") {
                                            }
                                        } else {
                                            if (params.mes == "true") {
                                                number = new Number(17 + mes, columna, 0);
                                                agr.add(number)
                                            }
                                        }
                                    }

                                    //  println "inv proy "+asignacion.id+" plan  "+asignacion.planificado+" suma "+total
                                    if (total.toFloat().round(2) != asignacion.planificado.toFloat().round(2)) {
                                        label = new Label(0, columna, "APP");
                                        sheet.addCell(label);
                                        label = new Label(1, columna, it.unidad.nombre);
                                        sheet.addCell(label);
                                        label = new Label(2, columna, proyectoMap.proyecto.objetivoEstrategico.descripcion);
                                        sheet.addCell(label);
                                        label = new Label(3, columna, proyectoMap.proyecto.ejeProgramatico.descripcion);
                                        sheet.addCell(label);
                                        def politicas = PoliticasProyecto.findByProyecto(proyectoMap.proyecto)
                                        label = new Label(4, columna, politicas.politica.descripcion);
                                        sheet.addCell(label);
                                        label = new Label(5, columna, proyectoMap.proyecto.codigoProyecto);
                                        sheet.addCell(label);
                                        label = new Label(6, columna, programaMap.programa.descripcion);
                                        sheet.addCell(label);
                                        label = new Label(7, columna, proyectoMap.proyecto.nombre);
                                        sheet.addCell(label);
                                        label = new Label(8, columna, actividadMap.actividad.marcoLogico.objeto);
                                        sheet.addCell(label);
                                        label = new Label(9, columna, actividadMap.actividad.objeto);
                                        sheet.addCell(label);
                                        label = new Label(10, columna, asignacion.id.toString());
                                        sheet.addCell(label);
                                        label = new Label(11, columna, asignacion.indicador);
                                        sheet.addCell(label);
                                        label = new Label(12, columna, "Inversión");
                                        sheet.addCell(label);
                                        label = new Label(13, columna, asignacion.fuente.descripcion);
                                        sheet.addCell(label);
                                        label = new Label(14, columna, asignacion.presupuesto?.presupuesto?.descripcion);
                                        sheet.addCell(label);
                                        label = new Label(15, columna, asignacion.presupuesto?.numero);
                                        sheet.addCell(label);
                                        number = new Number(16, columna, asignacion.planificado);
                                        sheet.addCell(number);

                                        agr.each { celda ->
                                            sheet.addCell(celda);
                                        }

                                        totalAsignado += asignacion.planificado
                                        if (params.mes == "true")
                                            number = new Number(29, columna, total);
                                        else
                                            number = new Number(17, columna, total);
                                        sheet.addCell(number);
                                        totalTotal += total
                                        columna++
                                    }


                                }
                            } //actividadMap.asignaciones.each -> asignacion
                        } //proyectoMap.actividades.each -> actividadMap
                    } //programaMap.proyectos.each -? proyectoMap
                } //if programaMap.proyectos.size >0
            } //unidad.programas.each -> programaMap

            it.corrientes.each { asignacion ->

                def tot = 0
                def agr = []
                12.times { mes ->
                    def mm = mes + 1
                    def pr = ProgramacionAsignacion.findAll("from ProgramacionAsignacion where asignacion = ${asignacion.id} and mes = ${mm}")
                    if (pr.size() == 1) {
                        pr = pr[0]
                        if (params.mes == "true") {
                            number = new Number(17 + mes, columna, pr.valor);
                            agr.add(number)
                        }
                        totalMeses[mes] += pr.valor
                        tot += pr.valor
                    } else if (pr.size() > 1) {
                        if (params.mes == "true") {
                        }
                    } else {
                        if (params.mes == "true") {
                            number = new Number(17 + mes, columna, 0);
                            agr.add(number)
                        }
                    }
                }

                // println "inv corr "+asignacion.id+" plan  "+asignacion.planificado+" suma "+tot

                if (tot.toFloat().round(2) != asignacion.planificado.toFloat().round(2)) {
                    label = new Label(0, columna, "APP");
                    sheet.addCell(label);
                    label = new Label(1, columna, it.unidad.nombre);
                    sheet.addCell(label);
                    label = new Label(2, columna, pu?.objetivoEstrategico?.descripcion);
                    sheet.addCell(label);
                    label = new Label(3, columna, pu?.ejeProgramatico?.descripcion);
                    sheet.addCell(label);
                    label = new Label(4, columna, pu?.politica?.descripcion);
                    sheet.addCell(label);
                    label = new Label(5, columna, "N/A");
                    sheet.addCell(label);
                    label = new Label(6, columna, asignacion.programa.descripcion);
                    sheet.addCell(label);
                    label = new Label(7, columna, "");
                    sheet.addCell(label);
                    label = new Label(8, columna, "");
                    sheet.addCell(label);
                    label = new Label(9, columna, asignacion.actividad);
                    sheet.addCell(label);
                    label = new Label(10, columna, asignacion.id.toString());
                    sheet.addCell(label);
                    label = new Label(11, columna, asignacion.indicador);
                    sheet.addCell(label);
                    label = new Label(12, columna, "Corriente");
                    sheet.addCell(label);
                    label = new Label(13, columna, asignacion.fuente.descripcion);
                    sheet.addCell(label);
                    label = new Label(14, columna, asignacion.presupuesto?.presupuesto?.descripcion);
                    sheet.addCell(label);
                    label = new Label(15, columna, asignacion.presupuesto?.numero);
                    sheet.addCell(label);
                    number = new Number(16, columna, asignacion.planificado);
                    sheet.addCell(number);

                    totalAsignado += asignacion.planificado
                    agr.each { celda ->
                        sheet.addCell(celda);
                    }


                    if (params.mes == "true")
                        number = new Number(29, columna, tot);
                    else
                        number = new Number(17, columna, tot);
                    sheet.addCell(number);
                    totalTotal += tot
                    columna++
                }


            }

            if (totalAsignado > 0 || totalTotal > 0) {
                label = new Label(0, columna, "TOTAL");
                sheet.addCell(label);
                label = new Label(1, columna, it.unidad.nombre);
                sheet.addCell(label);
                label = new Label(2, columna, "(corrientes+inversión)");
                sheet.addCell(label);
                label = new Label(3, columna, "");
                sheet.addCell(label);
                label = new Label(4, columna, "Máximo corrientes");
                sheet.addCell(label);
                number = new Number(5, columna, (pu?.maxCorrientes) ? pu.maxCorrientes : 0);
                sheet.addCell(number);
                label = new Label(6, columna, "");
                sheet.addCell(label);
                label = new Label(7, columna, "");
                sheet.addCell(label);
                label = new Label(8, columna, "Máximo inversión");
                sheet.addCell(label);
                number = new Number(9, columna, (pu?.maxInversion) ? pu.maxInversion : 0);
                sheet.addCell(number);
                label = new Label(10, columna, "");
                sheet.addCell(label);
                label = new Label(11, columna, "");
                sheet.addCell(label);
                label = new Label(12, columna, "");
                sheet.addCell(label);
                label = new Label(13, columna, "");
                sheet.addCell(label);
                label = new Label(14, columna, "");
                sheet.addCell(label);
                label = new Label(15, columna, "");
                sheet.addCell(label);
                number = new Number(16, columna, totalAsignado);
                sheet.addCell(number);

                if (params.mes == "true") {
                    12.times() { mes ->
                        number = new Number(17 + mes, columna, totalMeses[mes]);
                        sheet.addCell(number);
                    }
                }
                if (params.mes == "true")
                    number = new Number(29, columna, totalTotal);
                else
                    number = new Number(17, columna, totalTotal);
                sheet.addCell(number);
                granTotal += totalTotal
                columna += 2
            }
        }

        workbook.write();
        workbook.close();
        def output = response.getOutputStream()
        def header = "attachment; filename=" + "ReportePOA.xls";
        response.setContentType("application/octet-stream")
        response.setHeader("Content-Disposition", header);
        output.write(file.getBytes());
    }

    def format(val, tipo) {
        if (!texto || text == "")
            text = ""
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
    def poaReporteCsv = {
        println "aqui reporte poa excel "
        WorkbookSettings workbookSettings = new WorkbookSettings()
        workbookSettings.locale = Locale.default

        def file = File.createTempFile('myExcelDocument', '.xls')
        file.deleteOnExit()

        WritableWorkbook workbook = Workbook.createWorkbook(file, workbookSettings)

        WritableFont font = new WritableFont(WritableFont.ARIAL, 12)
        WritableCellFormat formatXls = new WritableCellFormat(font)

        def row = 0
        WritableSheet sheet = workbook.createSheet('MySheet', 0)
//
        sheet.setColumnView(2, 40)

//            Label label = new Label(0, 2, "A label record");
//            sheet.addCell(label);

//        list.each {
//            sheet.addCell(new Label(0, row, it.codigo, format))
//            sheet.addCell(new Label(1, row++, it.nombre, format))
//        }


        params.id = params.id.split(",")
        if (params.id.class == java.lang.String) {
            params.id = [params.id]
        }
        def unidades = reportePoa(params.id, params.anio)

        def arch = ""
        def sep = "&"
        def headInversion = ""
        def inversion = ""

        def headCorriente = ""
        def corriente = ""
        /*header*/
        WritableFont times16font = new WritableFont(WritableFont.TIMES, 11, WritableFont.BOLD, true);
        WritableCellFormat times16format = new WritableCellFormat(times16font);
        Label label = new Label(0, 1, "ID", times16format);
        sheet.addCell(label);
        label = new Label(1, 1, "Entidad", times16format);
        sheet.addCell(label);
        label = new Label(2, 1, "Unidad Ejecutora", times16format);
        sheet.addCell(label);
        label = new Label(3, 1, "Objetivo estratégico", times16format);
        sheet.addCell(label);
        label = new Label(4, 1, "Eje programático", times16format);
        sheet.addCell(label);
        label = new Label(5, 1, "Política", times16format);
        sheet.addCell(label);
        label = new Label(6, 1, "CUP", times16format);
        sheet.addCell(label);
        label = new Label(7, 1, "Programa", times16format);
        sheet.addCell(label);
        label = new Label(8, 1, "Proyecto", times16format);
        sheet.addCell(label);
        label = new Label(9, 1, "Componente", times16format);
        sheet.addCell(label);
        label = new Label(10, 1, "Actividad", times16format);
        sheet.addCell(label);
        label = new Label(11, 1, "Meta", times16format);
        sheet.addCell(label);
        label = new Label(12, 1, "Indicador", times16format);
        sheet.addCell(label);
        label = new Label(13, 1, "Tipo gasto", times16format);
        sheet.addCell(label);
        label = new Label(14, 1, "Fuente financiamiento", times16format);
        sheet.addCell(label);
        label = new Label(15, 1, "Grupo gasto", times16format);
        sheet.addCell(label);
        label = new Label(16, 1, "Partida presupuestaria", times16format);
        sheet.addCell(label);
        label = new Label(17, 1, "Asignado", times16format);
        sheet.addCell(label);
        /*fin header*/
        def columna = 2

        def max = 18
        if (params.mes == "true") {
            Mes.list([sort: 'numero']).each { mes ->
                headInversion += mes.descripcion + sep
                label = new Label(17 + mes.numero, 1, mes.descripcion, times16format);
                sheet.addCell(label);
                max++
            }
        }
        label = new Label(max, 1, "Total presupuesto", times16format);
        sheet.addCell(label);
        headInversion += "Total presupuesto" + sep
        headInversion += "\n"

        def granTotal = 0

        unidades.each {
            def pu = PresupuestoUnidad.findByUnidadAndAnio(it.unidad, Anio.get(params.anio))
            def totalAsignado = 0, totalTotal = 0
            def totalMeses = []
            12.times { t ->
                totalMeses[t] = 0
            }

            it.inversionDividido.each { inv ->

                label = new Label(0, columna, inv.id.toString());
                sheet.addCell(label);
                label = new Label(1, columna, "APP");
                sheet.addCell(label);
                label = new Label(2, columna, it.unidad.nombre);
                sheet.addCell(label);

                label = new Label(3, columna, inv.marcoLogico.proyecto.objetivoEstrategico.descripcion);
                sheet.addCell(label);
                label = new Label(4, columna, inv.marcoLogico.proyecto.ejeProgramatico.descripcion);
                sheet.addCell(label);
                def politicas = PoliticasProyecto.findByProyecto(inv.marcoLogico.proyecto)
                label = new Label(5, columna, politicas.politica.descripcion);
                sheet.addCell(label);
                label = new Label(6, columna, inv.marcoLogico.proyecto.codigoProyecto);
                sheet.addCell(label);
                label = new Label(7, columna, inv.marcoLogico.proyecto.programa.descripcion);
                sheet.addCell(label);
                label = new Label(8, columna, inv.marcoLogico.proyecto.nombre);
                sheet.addCell(label);
                label = new Label(9, columna, inv.marcoLogico.marcoLogico.objeto);
                sheet.addCell(label);
                label = new Label(10, columna, inv.marcoLogico.objeto);
                sheet.addCell(label);
                label = new Label(11, columna, inv.meta);
                sheet.addCell(label);
                label = new Label(12, columna, inv.indicador);
                sheet.addCell(label);
                label = new Label(13, columna, "Inversión");
                sheet.addCell(label);
                label = new Label(14, columna, inv.fuente.descripcion);
                sheet.addCell(label);
                label = new Label(15, columna, inv.presupuesto?.presupuesto?.descripcion);
                sheet.addCell(label);
                label = new Label(16, columna, inv.presupuesto?.numero);
                sheet.addCell(label);
                Number number = new Number(17, columna, inv.planificado);
                sheet.addCell(number);

                totalAsignado += inv.planificado

                def total = 0

                12.times { mes ->
                    def mm = mes + 1
                    def pr = ProgramacionAsignacion.findAll("from ProgramacionAsignacion where asignacion = ${inv.id} and mes = ${mm}")
                    if (pr.size() == 1) {
                        pr = pr[0]
                        def desde = ModificacionAsignacion.findAllByDesde(pr.asignacion)
                        def hasta = ModificacionAsignacion.findAllByRecibe(pr.asignacion)
                        if (params.mes == "true") {
                            inversion += format(pr.valor, "number") + sep
                            number = new Number(18 + mes, columna, pr.valor);
                            sheet.addCell(number);
                        }
                        total += pr.valor
                        totalMeses[mes] += pr.valor
                    } else if (pr.size() > 1) {
                        if (params.mes == "true") {
                            inversion += "?" + sep
                        }
                    } else {
                        if (params.mes == "true") {
                            inversion += "0" + sep
                            number = new Number(18 + mes, columna, 0);
                            sheet.addCell(number);
                        }
                    }
                }
                inversion += format(total, "number") + sep
                if (params.mes == "true")
                    number = new Number(30, columna, total);
                else
                    number = new Number(18, columna, total);
                sheet.addCell(number);
                totalTotal += total
                inversion += "\n"
                columna++

            }

            it.programas.each { programaMap ->
                if (programaMap.proyectos.size() > 0 && programaMap.proyectos.actividades.size() > 0 && programaMap.proyectos.actividades.asignaciones.size() > 0) {
                    programaMap.proyectos.each { proyectoMap ->
                        proyectoMap.actividades.each { actividadMap ->
                            actividadMap.asignaciones.each { asignacion ->
//                                if (asignacion.reubicada != 'S') {
                                label = new Label(0, columna, asignacion.id.toString());
                                sheet.addCell(label);
                                label = new Label(1, columna, "APP");
                                sheet.addCell(label);
                                label = new Label(2, columna, it.unidad.nombre);
                                sheet.addCell(label);
                                label = new Label(3, columna, proyectoMap.proyecto?.objetivoEstrategico?.descripcion);
                                sheet.addCell(label);
                                label = new Label(4, columna, proyectoMap.proyecto?.ejeProgramatico?.descripcion);
                                sheet.addCell(label);
                                def politicas = PoliticasProyecto.findByProyecto(proyectoMap.proyecto)
                                label = new Label(5, columna, politicas.politica.descripcion);
                                sheet.addCell(label);
                                label = new Label(6, columna, proyectoMap.proyecto.codigoProyecto);
                                sheet.addCell(label);
                                label = new Label(7, columna, programaMap.programa?.descripcion);
                                sheet.addCell(label);
                                label = new Label(8, columna, proyectoMap.proyecto.nombre);
                                sheet.addCell(label);
                                label = new Label(9, columna, actividadMap.actividad.marcoLogico.objeto);
                                sheet.addCell(label);
                                label = new Label(10, columna, actividadMap.actividad.objeto);
                                sheet.addCell(label);
                                label = new Label(11, columna, asignacion.meta);
                                sheet.addCell(label);
                                label = new Label(12, columna, asignacion.indicador);
                                sheet.addCell(label);
                                label = new Label(13, columna, "Inversión");
                                sheet.addCell(label);
                                label = new Label(14, columna, asignacion.fuente.descripcion);
                                sheet.addCell(label);
                                label = new Label(15, columna, asignacion.presupuesto?.presupuesto?.descripcion);
                                sheet.addCell(label);
                                label = new Label(16, columna, asignacion.presupuesto?.numero);
                                sheet.addCell(label);
                                Number number = new Number(17, columna, asignacion.getValorReal());
                                sheet.addCell(number);

                                totalAsignado += asignacion.getValorReal()

                                def total = 0

                                12.times { mes ->
                                    def mm = mes + 1
                                    def pr = ProgramacionAsignacion.findAll("from ProgramacionAsignacion where asignacion = ${asignacion.id} and mes = ${mm}")
                                    if (pr.size() == 1) {
                                        pr = pr[0]
                                        def desde = ModificacionAsignacion.findAllByDesde(pr.asignacion)
                                        def hasta = ModificacionAsignacion.findAllByRecibe(pr.asignacion)
                                        if (params.mes == "true") {
                                            inversion += format(pr.valor, "number") + sep
                                            number = new Number(18 + mes, columna, pr.valor);
                                            sheet.addCell(number);
                                        }
                                        total += pr.valor
                                        totalMeses[mes] += pr.valor
                                    } else if (pr.size() > 1) {
                                        if (params.mes == "true") {
                                            inversion += "?" + sep
                                        }
                                    } else {
                                        if (params.mes == "true") {
                                            inversion += "0" + sep
                                            number = new Number(18 + mes, columna, 0);
                                            sheet.addCell(number);
                                        }
                                    }
                                }
                                inversion += format(total, "number") + sep
                                if (params.mes == "true")
                                    number = new Number(30, columna, total);
                                else
                                    number = new Number(18, columna, total);
                                sheet.addCell(number);
                                totalTotal += total
                                inversion += "\n"
                                columna++
//                            }
                            } //actividadMap.asignaciones.each -> asignacion
                        } //proyectoMap.actividades.each -> actividadMap
                    } //programaMap.proyectos.each -? proyectoMap
                } //if programaMap.proyectos.size >0
            } //unidad.programas.each -> programaMap
            it.corrientes.each { asignacion ->
                label = new Label(0, columna, asignacion.id.toString());
                sheet.addCell(label);
                label = new Label(1, columna, "APP");
                sheet.addCell(label);
                label = new Label(2, columna, it.unidad.nombre);
                sheet.addCell(label);
                label = new Label(3, columna, pu?.objetivoEstrategico?.descripcion);
                sheet.addCell(label);
                label = new Label(4, columna, pu?.ejeProgramatico?.descripcion);
                sheet.addCell(label);
                label = new Label(5, columna, pu?.politica?.descripcion);
                sheet.addCell(label);
                label = new Label(6, columna, "N/A");
                sheet.addCell(label);
                label = new Label(7, columna, asignacion.programa.descripcion);
                sheet.addCell(label);
                label = new Label(8, columna, "");
                sheet.addCell(label);
                label = new Label(9, columna, "");
                sheet.addCell(label);
                label = new Label(10, columna, asignacion.actividad);
                sheet.addCell(label);
                label = new Label(11, columna, asignacion.meta);
                sheet.addCell(label);
                label = new Label(12, columna, asignacion.indicador);
                sheet.addCell(label);
                label = new Label(13, columna, "Corriente");
                sheet.addCell(label);
                label = new Label(14, columna, asignacion.fuente.descripcion);
                sheet.addCell(label);
                label = new Label(15, columna, asignacion.presupuesto?.presupuesto?.descripcion);
                sheet.addCell(label);
                label = new Label(16, columna, asignacion.presupuesto?.numero);
                sheet.addCell(label);
                def number = new Number(17, columna, asignacion.planificado);
                sheet.addCell(number);

                totalAsignado += asignacion.planificado

                def tot = 0
                12.times { mes ->
                    def mm = mes + 1
                    def pr = ProgramacionAsignacion.findAll("from ProgramacionAsignacion where asignacion = ${asignacion.id} and mes = ${mm}")
                    if (pr.size() == 1) {
                        pr = pr[0]
                        if (params.mes == "true") {
                            corriente += format(pr.valor, "number") + sep
                            number = new Number(18 + mes, columna, pr.valor);
                            sheet.addCell(number);
                        }
                        totalMeses[mes] += pr.valor
                        tot += pr.valor
                    } else if (pr.size() > 1) {
                        if (params.mes == "true") {
                            corriente += "?" + sep
                        }
                    } else {
                        if (params.mes == "true") {
                            corriente += "0" + sep
                            number = new Number(18 + mes, columna, 0);
                            sheet.addCell(number);
                        }
                    }
                }
                corriente += format(tot, "number") + sep
                if (params.mes == "true")
                    number = new Number(30, columna, tot);
                else
                    number = new Number(18, columna, tot);
                sheet.addCell(number);
                totalTotal += tot
                corriente += "\n"
                columna++
            }

            if (totalAsignado > 0 || totalTotal > 0) {
                label = new Label(1, columna, "TOTAL");
                sheet.addCell(label);
                label = new Label(2, columna, it.unidad.nombre);
                sheet.addCell(label);
                label = new Label(3, columna, "(corrientes+inversión)");
                sheet.addCell(label);
                label = new Label(4, columna, "");
                sheet.addCell(label);
                label = new Label(5, columna, "Máximo corrientes");
                sheet.addCell(label);
                def number = new Number(6, columna, (pu?.maxCorrientes) ? pu.maxCorrientes : 0);
                sheet.addCell(number);
                label = new Label(7, columna, "");
                sheet.addCell(label);
                label = new Label(8, columna, "");
                sheet.addCell(label);
                label = new Label(9, columna, "Máximo inversión");
                sheet.addCell(label);
                number = new Number(10, columna, (pu?.maxInversion) ? pu.maxInversion : 0);
                sheet.addCell(number);
                label = new Label(11, columna, "");
                sheet.addCell(label);
                label = new Label(12, columna, "");
                sheet.addCell(label);
                label = new Label(13, columna, "");
                sheet.addCell(label);
                label = new Label(14, columna, "");
                sheet.addCell(label);
                label = new Label(15, columna, "");
                sheet.addCell(label);
                label = new Label(16, columna, "");
                sheet.addCell(label);
                number = new Number(17, columna, totalAsignado);
                sheet.addCell(number);

                if (params.mes == "true") {
                    12.times() { mes ->
                        corriente += format(totalMeses[mes]) + sep
                        number = new Number(18 + mes, columna, totalMeses[mes]);
                        sheet.addCell(number);
                    }
                }
                corriente += format(totalTotal) + sep
                if (params.mes == "true")
                    number = new Number(30, columna, totalTotal);
                else
                    number = new Number(18, columna, totalTotal);
                sheet.addCell(number);
                granTotal += totalTotal
                corriente += "\n\n"
                columna += 2
            }
        }

        arch += headInversion
        arch += inversion
        arch += corriente

        arch += "\n"
//        if (granTotal > 0) {
//            arch += "TOTAL" + sep
//            label = new Label(0, columna, "TOTAL");
//            sheet.addCell(label);
//            arch += "" + sep
//            label = new Label(1, columna, "");
//            sheet.addCell(label);
//            arch += "" + sep
//            label = new Label(2, columna, "");
//            sheet.addCell(label);
//            arch += "" + sep
//            label = new Label(3, columna, "");
//            sheet.addCell(label);
//            arch += "" + sep
//            label = new Label(4, columna, "");
//            sheet.addCell(label);
//            arch += "" + sep
//            label = new Label(5, columna, "");
//            sheet.addCell(label);
//            arch += "" + sep
//            label = new Label(6, columna, "");
//            sheet.addCell(label);
//            arch += "" + sep
//            label = new Label(7, columna, "");
//            sheet.addCell(label);
//            arch += "" + sep
//            label = new Label(8, columna, "");
//            sheet.addCell(label);
//            arch += "" + sep
//            label = new Label(9, columna, "");
//            sheet.addCell(label);
//            arch += "" + sep
//            label = new Label(10, columna, "");
//            sheet.addCell(label);
//            arch += "" + sep
//            label = new Label(11, columna, "");
//            sheet.addCell(label);
//            arch += "" + sep
//            label = new Label(12, columna, "");
//            sheet.addCell(label);
//            arch += "" + sep
//            label = new Label(13, columna, "");
//            sheet.addCell(label);
//            arch += "" + sep
//            label = new Label(14, columna, "");
//            sheet.addCell(label);
//            arch += "" + sep
//            label = new Label(15, columna, "");
//            sheet.addCell(label);
//
////            def number = new Number(17, columna, granTotal+2);
////            sheet.addCell(number);
////            arch += format(granTotal) + sep
//        }

//            response.setHeader("Content-disposition", "attachment; filename=reporte_poa.csv");
//            render(contentType: "text/csv ", text: "${arch}");


        workbook.write();
        workbook.close();
        def output = response.getOutputStream()
        def header = "attachment; filename=" + "ReportePOA.xls";
        response.setContentType("application/octet-stream")
        response.setHeader("Content-Disposition", header);
        output.write(file.getBytes());
    }

    /**
     * Acción
     */
    def poaOriginalReporteCsv = {
        WorkbookSettings workbookSettings = new WorkbookSettings()
        workbookSettings.locale = Locale.default

        def file = File.createTempFile('myExcelDocument', '.xls')
        file.deleteOnExit()
//        println "paso"
        WritableWorkbook workbook = Workbook.createWorkbook(file, workbookSettings)

        WritableFont font = new WritableFont(WritableFont.ARIAL, 12)
        WritableCellFormat formatXls = new WritableCellFormat(font)

        def row = 0
        WritableSheet sheet = workbook.createSheet('MySheet', 0)
//
        sheet.setColumnView(1, 40)

//            Label label = new Label(0, 2, "A label record");
//            sheet.addCell(label);

//        list.each {
//            sheet.addCell(new Label(0, row, it.codigo, format))
//            sheet.addCell(new Label(1, row++, it.nombre, format))
//        }


        params.id = params.id.split(",")
        if (params.id.class == java.lang.String) {
            params.id = [params.id]
        }
        def unidades = reportePoaOriginal(params.id, params.anio)

        def arch = ""
        def sep = "&"
        def headInversion = ""
        def inversion = ""

        def headCorriente = ""
        def corriente = ""
        /*header*/
        WritableFont times16font = new WritableFont(WritableFont.TIMES, 11, WritableFont.BOLD, true);
        WritableCellFormat times16format = new WritableCellFormat(times16font);
        Label label = new Label(0, 1, "Entidad", times16format);
        sheet.addCell(label);
        label = new Label(1, 1, "Unidad Ejecutora", times16format);
        sheet.addCell(label);
        label = new Label(2, 1, "Objetivo estratégico", times16format);
        sheet.addCell(label);
        label = new Label(3, 1, "Eje programático", times16format);
        sheet.addCell(label);
        label = new Label(4, 1, "Política", times16format);
        sheet.addCell(label);
        label = new Label(5, 1, "CUP", times16format);
        sheet.addCell(label);
        label = new Label(6, 1, "Programa", times16format);
        sheet.addCell(label);
        label = new Label(7, 1, "Proyecto", times16format);
        sheet.addCell(label);
        label = new Label(8, 1, "Componente", times16format);
        sheet.addCell(label);
        label = new Label(9, 1, "Actividad", times16format);
        sheet.addCell(label);
        label = new Label(10, 1, "Meta", times16format);
        sheet.addCell(label);
        label = new Label(11, 1, "Indicador", times16format);
        sheet.addCell(label);
        label = new Label(12, 1, "Tipo gasto", times16format);
        sheet.addCell(label);
        label = new Label(13, 1, "Fuente financiamiento", times16format);
        sheet.addCell(label);
        label = new Label(14, 1, "Grupo gasto", times16format);
        sheet.addCell(label);
        label = new Label(15, 1, "Partida presupuestaria", times16format);
        sheet.addCell(label);
        label = new Label(16, 1, "Asignado", times16format);
        sheet.addCell(label);
        /*fin header*/
        def fila = 2


        def max = 17

        headInversion += "Total presupuesto" + sep
        headInversion += "\n"

        def granTotal = 0

        unidades.each {
            println "unidad " + it.unidad
            def pu = PresupuestoUnidad.findByUnidadAndAnio(it.unidad, Anio.get(params.anio))
            def totalAsignado = 0, totalTotal = 0
            def totalMeses = []
            12.times { t ->
                totalMeses[t] = 0
            }
            it.programas.each { programaMap ->
                if (programaMap.proyectos.size() > 0 && programaMap.proyectos.actividades.size() > 0 && programaMap.proyectos.actividades.asignaciones.size() > 0) {
                    programaMap.proyectos.each { proyectoMap ->
                        proyectoMap.actividades.each { actividadMap ->
                            actividadMap.asignaciones.each { asignacion ->

                                inversion += format("APP") + sep
                                label = new Label(0, fila, "APP");
                                sheet.addCell(label);
                                inversion += format(it.unidad.nombre) + sep
                                label = new Label(1, fila, it.unidad.nombre);
                                sheet.addCell(label);
                                //println "-----" + proyectoMap.proyecto.objetivoEstrategico
                                inversion += format(proyectoMap.proyecto.objetivoEstrategico.descripcion) + sep
                                label = new Label(2, fila, proyectoMap.proyecto.objetivoEstrategico.descripcion);
                                sheet.addCell(label);
                                inversion += format(proyectoMap.proyecto.ejeProgramatico.descripcion) + sep
                                label = new Label(3, fila, proyectoMap.proyecto.ejeProgramatico.descripcion);
                                sheet.addCell(label);
                                def politicas = PoliticasProyecto.findByProyecto(proyectoMap.proyecto)
                                inversion += format(politicas.politica.descripcion) + sep
                                label = new Label(4, fila, politicas.politica.descripcion);
                                sheet.addCell(label);
                                inversion += format(proyectoMap.proyecto.codigoProyecto) + sep
                                label = new Label(5, fila, proyectoMap.proyecto.codigoProyecto);
                                sheet.addCell(label);
                                inversion += format(programaMap.programa.descripcion) + sep
                                label = new Label(6, fila, programaMap.programa.descripcion);
                                sheet.addCell(label);
                                inversion += format(proyectoMap.proyecto.nombre) + sep
                                label = new Label(7, fila, proyectoMap.proyecto.nombre);
                                sheet.addCell(label);
                                inversion += format(actividadMap.actividad.marcoLogico.objeto) + sep
                                label = new Label(8, fila, actividadMap.actividad.marcoLogico.objeto);
                                sheet.addCell(label);
                                inversion += format(actividadMap.actividad.objeto) + sep
                                label = new Label(9, fila, actividadMap.actividad.objeto);
                                sheet.addCell(label);
                                inversion += format(asignacion.meta) + sep
                                label = new Label(10, fila, asignacion.meta);
                                sheet.addCell(label);
                                inversion += format(asignacion.indicador) + sep
                                label = new Label(11, fila, asignacion.indicador);
                                sheet.addCell(label);
                                inversion += format("Inversión") + sep
                                label = new Label(12, fila, "Inversión");
                                sheet.addCell(label);
                                inversion += format(asignacion.fuente.descripcion) + sep
                                label = new Label(13, fila, asignacion.fuente.descripcion);
                                sheet.addCell(label);
                                inversion += format(asignacion.presupuesto?.presupuesto?.descripcion) + sep
                                label = new Label(14, fila, asignacion.presupuesto?.presupuesto?.descripcion);
                                sheet.addCell(label);
                                inversion += format(asignacion.presupuesto?.numero) + sep
                                label = new Label(15, fila, asignacion.presupuesto?.numero);
                                sheet.addCell(label);
                                inversion += format(asignacion.planificado, "number") + sep
                                Number number = new Number(16, fila, asignacion.planificado);
                                sheet.addCell(number);

                                totalAsignado += asignacion.planificado

                                def total = 0


                                sheet.addCell(number);
                                totalTotal += total
                                inversion += "\n"
                                fila++
                            } //actividadMap.asignaciones.each -> asignacion
                        } //proyectoMap.actividades.each -> actividadMap
                    } //programaMap.proyectos.each -? proyectoMap
                } //if programaMap.proyectos.size >0
            } //unidad.programas.each -> programaMap
            it.corrientes.each { asig ->
                def asignacion = asig.asignacion
                corriente += format("APP") + sep
                label = new Label(0, fila, "APP");
                sheet.addCell(label);
                corriente += format(it.unidad.nombre) + sep
                label = new Label(1, fila, it.unidad.nombre);
                sheet.addCell(label);
                label = new Label(2, fila, pu?.objetivoEstrategico?.descripcion);
                sheet.addCell(label);
                label = new Label(3, fila, pu?.ejeProgramatico?.descripcion);
                sheet.addCell(label);
                label = new Label(4, fila, pu?.politica?.descripcion);
                sheet.addCell(label);
                label = new Label(5, fila, "N/A");
                sheet.addCell(label);
                label = new Label(6, fila, asignacion.programa.descripcion);
                sheet.addCell(label);
                label = new Label(7, fila, "");
                sheet.addCell(label);
                label = new Label(8, fila, "");
                sheet.addCell(label);
                label = new Label(9, fila, asignacion.actividad);
                sheet.addCell(label);
                label = new Label(10, fila, asignacion.meta);
                sheet.addCell(label);
                label = new Label(11, fila, asignacion.indicador);
                sheet.addCell(label);
                label = new Label(12, fila, "Corriente");
                sheet.addCell(label);
                label = new Label(13, fila, asignacion.fuente.descripcion);
                sheet.addCell(label);
                label = new Label(14, fila, asignacion.presupuesto?.presupuesto?.descripcion);
                sheet.addCell(label);
                label = new Label(15, fila, asignacion.presupuesto?.numero);
                sheet.addCell(label);
                def ta = asignacion.planificado + asig.desde - asig.hasta
                def number = new Number(16, fila, ta);
                sheet.addCell(number);

                totalAsignado += ta

                def tot = 0
//                12.times { mes ->
//                    def mm = mes + 1
//                    def pr = ProgramacionAsignacion.findAll("from ProgramacionAsignacion where asignacion = ${asignacion.id} and mes = ${mm}")
//                    if (pr.size() == 1) {
//                        pr = pr[0]
//                        if (params.mes == "true") {
//                            corriente += format(pr.valor, "number") + sep
//                            number = new Number(17 + mes, fila, pr.valor);
//                            sheet.addCell(number);
//                        }
//                        totalMeses[mes] += pr.valor
//                        tot += pr.valor
//                    } else if (pr.size() > 1) {
//                        if (params.mes == "true") {
//                            corriente += "?" + sep
//                        }
//                    } else {
//                        if (params.mes == "true") {
//                            corriente += "0" + sep
//                            number = new Number(17 + mes, fila, 0);
//                            sheet.addCell(number);
//                        }
//                    }
//                }
//                corriente += format(tot, "number") + sep
//                if (params.mes == "true")
//                    number = new Number(29, fila, tot);
//                else
//                    number = new Number(17, fila, tot);
//                sheet.addCell(number);
//                totalTotal += tot
                corriente += "\n"
                fila++
            }

            if (totalAsignado > 0 || totalTotal > 0) {
                label = new Label(0, fila, "TOTAL");
                sheet.addCell(label);
                label = new Label(1, fila, it.unidad.nombre);
                sheet.addCell(label);
                label = new Label(2, fila, "(corrientes+inversión)");
                sheet.addCell(label);
                label = new Label(3, fila, "");
                sheet.addCell(label);
                label = new Label(4, fila, "Máximo corrientes");
                sheet.addCell(label);
                def number = new Number(5, fila, pu?.maxCorrientes);
                sheet.addCell(number);
                label = new Label(6, fila, "");
                sheet.addCell(label);
                label = new Label(7, fila, "");
                sheet.addCell(label);
                label = new Label(8, fila, "Máximo inversión");
                sheet.addCell(label);
                number = new Number(9, fila, pu?.maxInversion);
                sheet.addCell(number);
                label = new Label(10, fila, "");
                sheet.addCell(label);
                label = new Label(11, fila, "");
                sheet.addCell(label);
                label = new Label(12, fila, "");
                sheet.addCell(label);
                label = new Label(13, fila, "");
                sheet.addCell(label);
                label = new Label(14, fila, "");
                sheet.addCell(label);
                corriente += "" + sep
                label = new Label(15, fila, "");
                sheet.addCell(label);
                number = new Number(16, fila, totalAsignado);
                sheet.addCell(number);

                if (params.mes == "true") {
                    12.times() { mes ->
                        corriente += format(totalMeses[mes]) + sep
                        number = new Number(17 + mes, fila, totalMeses[mes]);
                        sheet.addCell(number);
                    }
                }
//                corriente += format(totalTotal) + sep
//                if (params.mes == "true")
//                    number = new Number(29, fila, totalTotal);
//                else
//                    number = new Number(17, fila, totalTotal);
//                sheet.addCell(number);
//                granTotal += totalTotal
                fila += 2
            }
        }

        arch += headInversion
        arch += inversion
        arch += corriente

        arch += "\n"
        if (granTotal > 0) {
            arch += "TOTAL" + sep
            label = new Label(0, fila, "TOTAL");
            sheet.addCell(label);
            arch += "" + sep
            label = new Label(1, fila, "");
            sheet.addCell(label);
            arch += "" + sep
            label = new Label(2, fila, "");
            sheet.addCell(label);
            arch += "" + sep
            label = new Label(3, fila, "");
            sheet.addCell(label);
            arch += "" + sep
            label = new Label(4, fila, "");
            sheet.addCell(label);
            arch += "" + sep
            label = new Label(5, fila, "");
            sheet.addCell(label);
            arch += "" + sep
            label = new Label(6, fila, "");
            sheet.addCell(label);
            arch += "" + sep
            label = new Label(7, fila, "");
            sheet.addCell(label);
            arch += "" + sep
            label = new Label(8, fila, "");
            sheet.addCell(label);
            arch += "" + sep
            label = new Label(9, fila, "");
            sheet.addCell(label);
            arch += "" + sep
            label = new Label(10, fila, "");
            sheet.addCell(label);
            arch += "" + sep
            label = new Label(11, fila, "");
            sheet.addCell(label);
            arch += "" + sep
            label = new Label(12, fila, "");
            sheet.addCell(label);
            arch += "" + sep
            label = new Label(13, fila, "");
            sheet.addCell(label);
            arch += "" + sep
            label = new Label(14, fila, "");
            sheet.addCell(label);
            arch += "" + sep
            label = new Label(15, fila, "");
            sheet.addCell(label);

            def number = new Number(17, fila, granTotal);
            sheet.addCell(number);
        }

//            response.setHeader("Content-disposition", "attachment; filename=reporte_poa.csv");
//            render(contentType: "text/csv ", text: "${arch}");


        workbook.write();
        workbook.close();
        def output = response.getOutputStream()
        def header = "attachment; filename=" + "ReportePOAOriginal.xls";
        response.setContentType("application/octet-stream")
        response.setHeader("Content-Disposition", header);
        output.write(file.getBytes());
    }

    /**
     * Acción
     */
    def poaReporteCsv_bck = {
        params.id = params.id.split(",")
        if (params.id.class == java.lang.String) {
            params.id = [params.id]
        }
        def unidades = reportePoa(params.id, params.anio)

        def arch = ""
        def sep = "&"
        def headInversion = ""
        def inversion = ""

        def headCorriente = ""
        def corriente = ""

        headInversion += "Entidad" + sep
        headInversion += "Tipo" + sep
        headInversion += "Programa" + sep
        headInversion += "Proyecto" + sep
        headInversion += "Actividad" + sep
        headInversion += "Presupuesto" + sep
        headInversion += "Grupo gasto" + sep
        headInversion += "Monto actividad" + sep
        headInversion += "Asignación\n"

        headCorriente += "Entidad" + sep
        headCorriente += "Tipo" + sep
        headCorriente += "Programa" + sep
        headCorriente += "Actividad" + sep
        headCorriente += "Meta" + sep
        headCorriente += "Indicador" + sep
        headCorriente += "Partida" + sep
        headCorriente += "Fuente" + sep
        headCorriente += "Presupuesto" + sep

        if (params.mes == "true") {
            Mes.list([sort: 'numero']).each { mes ->
                headCorriente += mes.descripcion + sep
            }
        }
        headCorriente += "\n"

        unidades.each {
            it.programas.each { programaMap ->
                if (programaMap.proyectos.size() > 0 && programaMap.proyectos.actividades.size() > 0 && programaMap.proyectos.actividades.asignaciones.size() > 0) {
                    programaMap.proyectos.each { proyectoMap ->
                        proyectoMap.actividades.each { actividadMap ->
                            actividadMap.asignaciones.each { asignacion ->
                                inversion += (it.unidad.nombre ? it.unidad.nombre.replaceAll("\\n", "") : "") + sep
                                inversion += "Inversion" + sep
                                inversion += (programaMap.programa.descripcion ? programaMap.programa.descripcion.replaceAll("\\n", "") : "") + sep
                                inversion += (proyectoMap.proyecto.nombre ? proyectoMap.proyecto.nombre.replaceAll("\\n", "") : "") + sep
                                inversion += (actividadMap.actividad.objeto ? actividadMap.actividad.objeto.replaceAll("\\n", "") : "") + sep
                                inversion += (asignacion.presupuesto?.descripcion ? asignacion.presupuesto?.descripcion.replaceAll("\\n", "") : "") + sep
                                inversion += (asignacion.presupuesto?.presupuesto?.descripcion ? asignacion.presupuesto?.presupuesto?.descripcion.replaceAll("\\n", "") : "") + sep
                                inversion += actividadMap.actividad.monto.toDouble().round(2) + sep
                                inversion += asignacion.planificado.toDouble().round(2) + "\n"
                            }
                        }
                    }
                }
            }
            def total = 0
            it.corrientes.each { asignacion ->
                corriente += (it.unidad.nombre ? it.unidad.nombre.replaceAll("\\n", "") : "") + sep
                corriente += "Corriente" + sep
                corriente += (asignacion.programa.descripcion ? asignacion.programa.descripcion.replaceAll("\\n", "") : "") + sep
                corriente += (asignacion.actividad ? asignacion.actividad.replaceAll("\\n", "") : "") + sep
                corriente += (asignacion.meta ? (asignacion.meta).replaceAll("\\n", "") : "") + sep
                corriente += (asignacion.indicador ? asignacion.indicador.replaceAll("\\n", "") : "") + sep
                corriente += asignacion.presupuesto?.numero + "." + asignacion.presupuesto?.descripcion + sep
                corriente += (asignacion.fuente.descripcion ? asignacion.fuente.descripcion.replaceAll("\\n", "") : "") + sep
                corriente += asignacion.planificado.toDouble().round(2) + sep
                total += asignacion.planificado

                if (params.mes == "true") {
                    12.times { mes ->
//                    def pr = ProgramacionAsignacion.findAllByMesAndAsignacion(mes, asignacion)
                        def pr = ProgramacionAsignacion.findAll("from ProgramacionAsignacion where asignacion = ${asignacion.id} and mes = ${mes}")
                        if (pr.size() == 1) {
                            pr = pr[0]
                            corriente += pr.valor + sep
                        } else if (pr.size() > 1) {
                            corriente += "?" + sep
                        } else {
                            corriente += "0" + sep
                        }
                    }
                }
                corriente += "\n"
            }
            if (total > 0) {
                corriente += "" + sep
                corriente += "" + sep
                corriente += "" + sep
                corriente += "" + sep
                corriente += "" + sep
                corriente += "" + sep
                corriente += "" + sep
                corriente += "TOTAL" + sep
                corriente += total.toDouble().round(2) + "\n"
            }
        }

        arch += headInversion
        arch += inversion
        arch += "\n"
        arch += headCorriente
        arch += corriente

        response.setHeader("Content-disposition", "attachment; filename=reporte_poa.csv");
        render(contentType: "text/csv ", text: "${arch}");

    }

    /**
     * Acción
     */
    def modificacionesProyectoGUI = {}

    /**
     * Acción
     */
    def modificacionesProyectoWeb = {
//        params.id = params.id.split(",")
//        if (params.id.class == java.lang.String) {
//            params.id = [params.id]
//        }
//        params.id = 12
        def proyecto = Proyecto.get(params.id)
        def mods = ModificacionProyecto.findAllByProyecto(proyecto)
        [mods: mods]
    }

    /**
     * Acción
     */
    def modificacionesProyectoPDF = {
        //        params.id = params.id.split(",")
//        if (params.id.class == java.lang.String) {
//            params.id = [params.id]
//        }
//        params.id = 12
        def proyecto = Proyecto.get(params.id)
        def mods = ModificacionProyecto.findAllByProyecto(proyecto)
        [mods: mods]
    }

    /**
     * Acción
     */
    def poaInversionesGUI = {}

    /**
     * Acción
     */
    def poaInversionesReporteWeb = {
        params.id = params.id.split(",")
        if (params.id.class == java.lang.String) {
            params.id = [params.id]
        }
        println "anio " + params.anio + " id " + params.id
        def actual
        if (params.anio)
            actual = Anio.get(params.anio)
        else
            actual = Anio.findByAnio(new Date().format("yyyy"))
        if (!actual)
            actual = Anio.list([sort: 'anio', order: 'desc']).pop()

        return [tabla: reportePoaInversiones(actual.id, params.id)]
    }

    /**
     * Acción
     */
    def poaInversionesReportePDF = {
        params.id = params.id.split(",")
        if (params.id.class == java.lang.String) {
            params.id = [params.id]
        }
        return [tabla: reportePoaInversiones(params.anio, params.id)]
    }

    /**
     * Acción
     */
    def poaCorrientesGUI = {}

    /**
     * Acción
     */
    def poaCorrientesReporteWeb = {
        params.id = params.id.split(",")
        if (params.id.class == java.lang.String) {
            params.id = [params.id]
        }
        return [tabla: reportePoaCorrientes(params.anio, params.id)]
    }

    /**
     * Acción
     */
    def poaCorrientesReportePDF = {
        println "params " + params
        params.id = params.id.split(",")
        if (params.id.class == java.lang.String) {
            params.id = [params.id]
        }
        return [tabla: reportePoaCorrientes(params.anio, params.id)]
    }

    /**
     * Acción
     */
    def reporteSQL = {
        if (params) {
            println "recibe de parametros: ${params}"
            params.id = params.id.split(",")
            if (params.id.class == java.lang.String) {
                params.id = [params.id]
            }
            return [resultados: consulta(params.id)]
        }
    }

    /**
     * Acción
     */
    def consulta = { ids ->
        def cn = dbConnectionService.getConnection()
        def resultados = []
        def detalle = []
        def proy = ""
        def tx = """select proynmbr, 'nn' as asgn__id, crng.mess__id, messvlor, 0 as prasetdo
            from crng, anio, mrlg, proy, mess
            where mrlg.mrlg__id = crng.mrlg__id and proy.proy__id = mrlg.proy__id and
                  anio.anio__id = crng.anio__id and anioanio = '2011' and proy.proy__id = 9 and
                  mrlg.mrlg__id = 31 and mess.mess__id = crng.mess__id
            order by mess.messnmro """
        cn.eachRow(tx) { d ->
            if (resultados.size() == 0) resultados << d.proynmbr
            detalle << [d.asgn__id, d.mess__id, d.messvlor]
        }
        resultados << detalle
        println resultados
        return resultados
    }

    /**
     * Acción
     */
    def ejecucionProyectosGUI = {
        def sigef = Sigef.list()
        def meses = []
        sigef.each { sig ->
            def m = [:]
            m.key = sig.mes.id + "_" + sig.anio.id
            m.value = sig.mes.descripcion + " " + sig.anio.anio
            meses << m
        }
        return [meses: meses]
    }

    /**
     * Acción
     */
    def ejecucionProyectosWeb = {
        return [proyectos: reporteEjecucionProyectos(params.id)]
    }

    /**
     * Acción
     */
    def ejecucionProyectosPDF = {
        return [proyectos: reporteEjecucionProyectos(params.id)]
    }

    /**
     * Acción
     */
    def componentesGUI = {}

    /**
     * Acción
     */
    def componentesWeb = {
        params.id = params.id.split(",")
        if (params.id.class == java.lang.String) {
            params.id = [params.id]
        }
        return [proyectos: reporteComponentes(params.id)]
    }

    /**
     * Acción
     */
    def componentesPdf = {
        params.id = params.id.split(",")
        if (params.id.class == java.lang.String) {
            params.id = [params.id]
        }
        return [proyectos: reporteComponentes(params.id)]
    }

    /**
     * Acción
     */
    def componentesCsv = {
        params.id = params.id.split(",")
        if (params.id.class == java.lang.String) {
            params.id = [params.id]
        }
        def proyectos = reporteComponentes(params.id)

        def arch = "Proyecto;Componente;Actividad;Monto" + "\n"
        proyectos.each { proyecto ->
            def totalProyecto = 0
            proyecto.componentes.each { comp ->
                def totalComponente = 0
                comp.actividades.each { act ->
                    arch += (proyecto.proyecto.nombre ? proyecto.proyecto.nombre : "") + ";"
                    arch += (comp.componente.objeto ? comp.componente.objeto : "") + ";"
                    arch += (act.objeto ? act.objeto : "") + ";"
                    arch += act.monto + "\n"
                    totalComponente += act.monto
                    totalProyecto += act.monto
                }
                if (totalComponente > 0) {
                    arch += " ; ;Total;" + totalComponente + "\n"
                }
            }
            if (totalProyecto > 0) {
                arch += " ; ;TOTAL;" + totalProyecto + "\n\n"
            }
        }

        response.setHeader("Content-disposition", "attachment; filename=componentes_proyectos.csv");
        render(contentType: "text/csv", text: "${arch}");
    }

    /**
     * Acción
     */
    def pacGUI = {

    }

    /**
     * Acción
     */
    def pacWeb = {
        params.id = params.id.split(",")
        if (params.id.class == java.lang.String) {
            params.id = [params.id]
        }
        return [result: reportePac(params.id, params.anio)]
    }

    /**
     * Acción
     */
    def pacPdf = {

    }

    /**
     * Acción
     */
    def pacCsv = {

        WorkbookSettings workbookSettings = new WorkbookSettings()
        workbookSettings.locale = Locale.default

        def file = File.createTempFile('myExcelDocument', '.xls')
        file.deleteOnExit()
        println "paso"
        WritableWorkbook workbook = Workbook.createWorkbook(file, workbookSettings)

        WritableFont font = new WritableFont(WritableFont.ARIAL, 12)
        WritableCellFormat formatXls = new WritableCellFormat(font)

        def row = 0
        WritableSheet sheet = workbook.createSheet('MySheet', 0)
        // fija el ancho de la columna
        // sheet.setColumnView(1,40)


        params.id = params.id.split(",")
        if (params.id.class == java.lang.String) {
            params.id = [params.id]
        }
        WritableFont times16font = new WritableFont(WritableFont.TIMES, 11, WritableFont.BOLD, true);
        WritableCellFormat times16format = new WritableCellFormat(times16font);

        // inicia textos y numeros para asocias a columnas
        def label = new Label(0, 1, "Texto", times16format);
        def nmro = new Number(12, 1, 9999);

        def result = reportePacXls(params.id, params.anio)

        label = new Label(0, 1, "EJERCICIO", times16format); sheet.addCell(label);
        label = new Label(1, 1, "ENTIDAD", times16format); sheet.addCell(label);
        label = new Label(2, 1, "UNIDAD EJECUTORA", times16format); sheet.addCell(label);
        label = new Label(3, 1, "UNIDAD DESCONCENTRADA", times16format); sheet.addCell(label);
        label = new Label(4, 1, "PROGRAMA", times16format); sheet.addCell(label);
        label = new Label(5, 1, "SUBPROGRAMA", times16format); sheet.addCell(label);
        label = new Label(6, 1, "PROYECTO", times16format); sheet.addCell(label);
        label = new Label(7, 1, "ACTIVIDAD", times16format); sheet.addCell(label);
        label = new Label(8, 1, "OBRA", times16format); sheet.addCell(label);
        label = new Label(9, 1, "GEOGRAFICO", times16format); sheet.addCell(label);
        label = new Label(10, 1, "RENGLÓN", times16format); sheet.addCell(label);
        label = new Label(11, 1, "RENGLON AUXILIAR", times16format); sheet.addCell(label);
        label = new Label(12, 1, "FUENTE", times16format); sheet.addCell(label);
        label = new Label(13, 1, "ORGANISMO", times16format); sheet.addCell(label);
        label = new Label(14, 1, "CORRELATIVO", times16format); sheet.addCell(label);
        label = new Label(15, 1, "CPC", times16format); sheet.addCell(label);
        label = new Label(16, 1, "TIPO COMPRA", times16format); sheet.addCell(label);
        label = new Label(17, 1, "DETALLE DEL PRODUCTO", times16format); sheet.addCell(label);
        label = new Label(18, 1, "CANTIDAD ANUAL", times16format); sheet.addCell(label);
        label = new Label(19, 1, "UNIDAD", times16format); sheet.addCell(label);
        label = new Label(20, 1, "COSTO UNITARIO", times16format); sheet.addCell(label);
        label = new Label(21, 1, " ", times16format); sheet.addCell(label);   //TOTAL
        label = new Label(22, 1, "CUATRIMESTRE 1", times16format); sheet.addCell(label);
        label = new Label(23, 1, "CUATRIMESTRE 2", times16format); sheet.addCell(label);
        label = new Label(24, 1, "CUATRIMESTRE 3", times16format); sheet.addCell(label);

        def columna = 2

        result.each {
            label = new Label(0, columna, it.ejercicio); sheet.addCell(label);
            label = new Label(1, columna, it.entidad); sheet.addCell(label);
            label = new Label(2, columna, it.unidadEjecutora); sheet.addCell(label);
            label = new Label(3, columna, it.unidadDesconcentrada); sheet.addCell(label);
            label = new Label(4, columna, it.programa); sheet.addCell(label);
            label = new Label(5, columna, it.subprograma); sheet.addCell(label);
            label = new Label(6, columna, it.proyecto); sheet.addCell(label);
            label = new Label(7, columna, it.actividad); sheet.addCell(label);
            label = new Label(8, columna, it.obra); sheet.addCell(label);
            label = new Label(9, columna, it.geografico); sheet.addCell(label);
            label = new Label(10, columna, it.renglon); sheet.addCell(label);
            label = new Label(11, columna, it.renglonAuxiliar); sheet.addCell(label);
            label = new Label(12, columna, it.fuente); sheet.addCell(label);
            label = new Label(13, columna, it.organismo); sheet.addCell(label);
            label = new Label(14, columna, it.correlativo); sheet.addCell(label);
            label = new Label(15, columna, it.codigo); sheet.addCell(label);
            label = new Label(16, columna, it.tipoCompra); sheet.addCell(label);
            label = new Label(17, columna, (it.detalle ?: "")); sheet.addCell(label);
            nmro = new Number(18, columna, it.cantidadAnual); sheet.addCell(nmro);
            label = new Label(19, columna, it.unidad); sheet.addCell(label);
            nmro = new Number(20, columna, it.costoUnitario); sheet.addCell(nmro);
            nmro = new Number(21, columna, it.costoUnitario * it.cantidadAnual); sheet.addCell(nmro);
            label = new Label(22, columna, it.cuatrimestre1); sheet.addCell(label);
            label = new Label(23, columna, it.cuatrimestre2); sheet.addCell(label);
            label = new Label(24, columna, it.cuatrimestre3); sheet.addCell(label);
/*
            arch += it.ejercicio + ";"
            arch += it.entidad + ";"
            arch += it.unidadEjecutora + ";"
            arch += it.programa + ";"
            arch += it.proyecto + ";"
            arch += it.actividad + ";"
            arch += it.renglon + ";"
            arch += it.presupuesto + ";"
            arch += it.fuente + ";"
            arch += it.codigo + ";"
            arch += it.tipoCompra + ";"
            arch += (it.detalle ?: "") + ";"
            arch += it.cantidadAnual + ";"
            arch += it.unidad + ";"
            arch += g.formatNumber(number: it.costoUnitario, format: "###,##0", minFractionDigit: 2, maxFractionDigits: 2) + ";"
            arch += it.cuatrimestre1 + ";"
            arch += it.cuatrimestre2 + ";"
            arch += it.cuatrimestre3 + "\n"
*/
            columna++
        }

        workbook.write();
        workbook.close();
        def output = response.getOutputStream()
        def header = "attachment; filename=" + "ReportePAC.xls";
        response.setContentType("application/octet-stream")
        response.setHeader("Content-Disposition", header);
        output.write(file.getBytes());
    }

    /**
     * Acción
     */
    def distribuciones = {

        def unidad = UnidadEjecutora.get(params.id)
        def actual = Anio.get(params.anio)

        def asgs = Asignacion.findAll("from Asignacion where marcoLogico is not null and unidad =${unidad.id} and reubicada='S' and anio=${actual.id} order by id")

        [asgs: asgs, unidad: unidad, actual: actual]


    }

    /**
     * Acción
     */
    def usuariosGUI = {

    }

    /**
     * Acción
     */
    def usuariosWeb = {

    }
    /**
     * Acción
     */
    def usuariosPdf = {

    }

    /**
     * Acción
     */
    def ejecucionUEGUI = {
    }


}
