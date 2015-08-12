package vesta.reportes

import jxl.Workbook
import jxl.WorkbookSettings
import jxl.write.Label
import jxl.write.WritableSheet
import jxl.write.WritableWorkbook
import vesta.NumberToLetterConverter
import vesta.avales.AvalCorriente
import vesta.avales.AvalCorrienteController
import vesta.avales.ProcesoAsignacion
import vesta.avales.SolicitudAval
import vesta.contratacion.Aprobacion
import vesta.contratacion.DetalleMontoSolicitud
import vesta.contratacion.Solicitud
import vesta.modificaciones.SolicitudModPoa
import vesta.parametros.poaPac.Anio
import vesta.poa.Asignacion
import vesta.seguridad.Prfl
import vesta.seguridad.Sesn
import vesta.seguridad.Persona

/**
 * Controlador que permite generar reportes relacionados con solicitudes y sus aprobaciones
 */
class ReporteSolicitudController {

    /**
     * Acción que genera un archivo XLS de las solicitudes
     */
    def solicitudesXls = {

        def perfil = session.perfil
        def usuario = Persona.get(session.usuario.id)
        def unidad = usuario.unidad

        def iniRow = 1
        def iniCol = 0

//        mostraba todas las solicitudes
//        def list2 = Solicitud.findAll("from Solicitud order by unidadEjecutora.id,fecha")

//        muestra solo las que correspondel al perfil
        def todos = ["GP", "DP", "DS", "ASAF", "ASGJ", "ASPL", "GAF", "GJ"]

        def c = Solicitud.createCriteria()
        def list2 = c.list(params) {
            if (!todos.contains(perfil.codigo)) {
                eq("unidadEjecutora", unidad)
            }
            if (params.search) {
                ilike("nombreProceso", "%" + params.search + "%")
            }
            //puede ver todas las no aprobadas aun
//            if (["ASAF", "ASGJ", ""].contains(perfil.codigo)) {
            eq("estado", "P")
//            }
            //si es Analista admin. o Analista juridico -> puede ver todas las que no hayan sido ya validadas
            if (perfil.codigo == "ASAF") {
                isNull("validadoAdministrativaFinanciera")
            }
            if (perfil.codigo == "ASGJ") {
                isNull("validadoJuridica")
            }
            //si es Gerencia admin o Gerencia juridica -> puede ver las que ya han sido revisadas por su analista
            if (perfil.codigo == "GAF") {
                isNotNull("revisadoAdministrativaFinanciera")
            }
            if (perfil.codigo == "GJ") {
                isNotNull("revisadoJuridica")
            }
            //si es Director requirente puede ver las ya validadas
            if (perfil.codigo == "DRRQ") {
                isNotNull("validadoAdministrativaFinanciera")
                isNotNull("validadoJuridica")
            }
        }

        def list01 = []
        def list02 = []
        def anios = []

        list2.each { s ->
            def aprobaciones = s.aprobacion
            if (aprobaciones && s.tipoAprobacion?.codigo != "NA") {
                list01 += s
            } else {
                list02 += s
            }
        }
        def list = list01 + list02

        list.each { sol ->
            DetalleMontoSolicitud.findAllBySolicitud(sol, [sort: "anio"]).each { d ->
                if (!anios.contains(d.anio)) {
                    anios.add(d.anio)
                }
            }
        }

        WorkbookSettings workbookSettings = new WorkbookSettings()
        workbookSettings.locale = Locale.default
        def file = File.createTempFile('solicitudes', '.xls')
        def label
        def number
        file.deleteOnExit()

        WritableWorkbook workbook = Workbook.createWorkbook(file, workbookSettings)
        def row = iniRow
        def col = iniCol
        WritableSheet sheet = workbook.createSheet('MySheet', 0)

        label = new Label(3, row, "YACHAY EP"); sheet.addCell(label);
        sheet.setColumnView(col, 30)
        row++
        label = new Label(3, row, "Lista de solicitudes de contratación"); sheet.addCell(label);
        sheet.setColumnView(col, 30)

        row += 2

        label = new Label(col, row, "Proyecto"); sheet.addCell(label);
        sheet.setColumnView(col, 30)
        col++
        label = new Label(col, row, "Componente"); sheet.addCell(label);
        sheet.setColumnView(col, 30)
        col++
        label = new Label(col, row, "N.Poa"); sheet.addCell(label);
        sheet.setColumnView(col, 20)
        col++
        label = new Label(col, row, "Nombre"); sheet.addCell(label);
        sheet.setColumnView(col, 30)
        col++
        label = new Label(col, row, "Objetivo"); sheet.addCell(label);
        sheet.setColumnView(col, 30)
        col++
        label = new Label(col, row, "TDR's"); sheet.addCell(label);
        col++
        label = new Label(col, row, "Responsable"); sheet.addCell(label);
        sheet.setColumnView(col, 20)
        col++
        anios.each { a ->
            label = new Label(col, row, "Valor ${a.anio}"); sheet.addCell(label);
            sheet.setColumnView(col, 20)
            col++
        }
        label = new Label(col, row, "Monto"); sheet.addCell(label);
        sheet.setColumnView(col, 20)
        col++
        label = new Label(col, row, "Aprobacion"); sheet.addCell(label);
        sheet.setColumnView(col, 20)
        col++
        label = new Label(col, row, "Fecha Solicitud"); sheet.addCell(label);
        sheet.setColumnView(col, 20)

        row++
        list.each { solicitudInstance ->
            col = iniCol
            label = new Label(col, row, solicitudInstance.actividad.proyecto.toString()); sheet.addCell(label);
            col++
            label = new Label(col, row, solicitudInstance.actividad.marcoLogico.toString()); sheet.addCell(label);
            col++
            label = new Label(col, row, Asignacion.findByMarcoLogico(solicitudInstance.actividad)?.presupuesto?.numero); sheet.addCell(label);
            col++
            label = new Label(col, row, solicitudInstance.nombreProceso); sheet.addCell(label);
            col++
            label = new Label(col, row, solicitudInstance.objetoContrato); sheet.addCell(label);
            col++
            label = new Label(col, row, "X"); sheet.addCell(label);
            col++
            label = new Label(col, row, solicitudInstance.unidadEjecutora?.codigo); sheet.addCell(label);
            col++

            anios.each { a ->
                def valor = DetalleMontoSolicitud.findByAnioAndSolicitud(a, solicitudInstance)
                if (valor) {
                    number = new jxl.write.Number(col, row, valor.monto); sheet.addCell(number);
                } else {
                    label = new Label(col, row, ""); sheet.addCell(label);
                }
                col++
            }
            number = new jxl.write.Number(col, row, solicitudInstance.montoSolicitado); sheet.addCell(number);
            col++
            def estado = solicitudInstance.aprobacion
            if (estado) {
                label = new Label(col, row, solicitudInstance.tipoAprobacion?.descripcion + " (" + estado?.fechaRealizacion?.format("dd-MM-yyyy") + ")");
                sheet.addCell(label);
                col++
            } else {
                label = new Label(col, row, "Pendiente"); sheet.addCell(label);
                col++
            }
            label = new Label(col, row, solicitudInstance.fecha?.format('dd-MM-yyyy')); sheet.addCell(label);
            col++

            row++
        }

        workbook.write();
        workbook.close();
        def output = response.getOutputStream()
        def header = "attachment; filename=" + "solicitudes.xls";
        response.setContentType("application/octet-stream")
        response.setHeader("Content-Disposition", header);
        output.write(file.getBytes());
    }

    /**
     * Acción que genera un archivo PDF de las solicitudes
     */
    def solicitudes = {
        println "solicitudes"
        def list2 = Solicitud.findAll("from Solicitud order by unidadEjecutora.id,fecha")




        def nombreProceso

        list2.each {

            nombreProceso = it.nombreProceso

            if (nombreProceso) {
                nombreProceso = nombreProceso.replaceAll("&nbsp", " ")
                nombreProceso = nombreProceso.replaceAll("&Oacute;", "Ó")
                nombreProceso = nombreProceso.replaceAll("&oacute;", "ó")
                nombreProceso = nombreProceso.replaceAll("&Aacute;", "Á")
                nombreProceso = nombreProceso.replaceAll("&aacute;", "á")
                nombreProceso = nombreProceso.replaceAll("&Eacute;", "É")
                nombreProceso = nombreProceso.replaceAll("&eacute;", "é")
                nombreProceso = nombreProceso.replaceAll("&Iacute;", "Í")
                nombreProceso = nombreProceso.replaceAll("&iacute;", "í")
                nombreProceso = nombreProceso.replaceAll("&Uacute;", "Ú")
                nombreProceso = nombreProceso.replaceAll("&uacute;", "ú")
                nombreProceso = nombreProceso.replaceAll("&ntilde;", "ñ")
                nombreProceso = nombreProceso.replaceAll("&Ntilde;", "Ñ")
                nombreProceso = nombreProceso.replaceAll("&ldquo;", '"')
                nombreProceso = nombreProceso.replaceAll("&rdquo;", '"')
                nombreProceso = nombreProceso.replaceAll("&lquo;", "'")
                nombreProceso = nombreProceso.replaceAll("&rquo;", "'")

            } else {

                nombreProceso = ""
            }

            it.nombreProceso = nombreProceso
        }

        def list01 = []
        def list02 = []
        def anios = []

        list2.each { s ->
            def aprobaciones = s.aprobacion
            if (aprobaciones && s.tipoAprobacion?.codigo != "NA") {
                list01 += s
            } else {
                list02 += s
            }
        }
        def list = list01 + list02

        list.each { sol ->
            DetalleMontoSolicitud.findAllBySolicitud(sol, [sort: "anio"]).each { d ->
                if (!anios.contains(d.anio)) {
                    anios.add(d.anio)
                }
            }
        }
        return [solicitudInstanceList: list, anios: anios]
    }

    /**
     * Acción que genera un archivo PDF de las solicitudes aprobadas
     */
    def aprobadas = {
//        println "aprobadas"
        def list = []
        def list2 = Solicitud.findAll("from Solicitud order by unidadEjecutora.id,fecha")

        list2.each { s ->
            def aprobaciones = s.aprobacion
            if (aprobaciones && s?.tipoAprobacion && s?.tipoAprobacion?.codigo != "NA") {
                list += s
            }
        }

        def anios = []


        list.each { sol ->
            DetalleMontoSolicitud.findAllBySolicitud(sol, [sort: "anio"]).each { d ->
                if (!anios.contains(d.anio)) {
                    anios.add(d.anio)
                }
            }
        }
        return [solicitudInstanceList: list, anios: anios]
    }

    /**
     * Acción que genera un archivo XLS de las solicitudes aprobadas
     */
    def aprobadasXLS = {
//        println "aprobadas"
        def list = []
        def list2 = Solicitud.findAll("from Solicitud order by unidadEjecutora.id,fecha")

        list2.each { s ->
            if (s.aprobacion && s?.tipoAprobacion && s?.tipoAprobacion?.codigo != "NA") {
                list += s
            }
        }

        def anios = []

//        list = list.sort { it.aprobacion?.descripcion + it.unidadEjecutora?.nombre + it.fecha.format("dd-MM-yyyy") }
//        list = list.sort { a, b ->
//            ((a.aprobacion?.descripcion <=> b.aprobacion?.descripcion) ?:
//                    (a.unidadEjecutora?.nombre <=> b.unidadEjecutora?.nombre)) ?:
//                    (a.fecha?.format("dd-MM-yyyy") <=> b.fecha?.format("dd-MM-yyyy"))
//    }


        list.each { sol ->
            DetalleMontoSolicitud.findAllBySolicitud(sol, [sort: "anio"]).each { d ->
                if (!anios.contains(d.anio)) {
                    anios.add(d.anio)
                }
            }
        }

        def iniRow = 1
        def iniCol = 0

        WorkbookSettings workbookSettings = new WorkbookSettings()
        workbookSettings.locale = Locale.default
        def file = File.createTempFile('solicitudes_aprobadas', '.xls')
        def label
        def number
        file.deleteOnExit()

        WritableWorkbook workbook = Workbook.createWorkbook(file, workbookSettings)
        def row = iniRow
        def col = iniCol
        WritableSheet sheet = workbook.createSheet('MySheet', 0)

        label = new Label(3, row, "YACHAY EP"); sheet.addCell(label);
        sheet.setColumnView(col, 30)
        row++
        label = new Label(3, row, "Lista de solicitudes de contratación aprobadas"); sheet.addCell(label);
        sheet.setColumnView(col, 30)

        row += 2

        label = new Label(col, row, "Proyecto"); sheet.addCell(label);
        sheet.setColumnView(col, 30)
        col++
        label = new Label(col, row, "Componente"); sheet.addCell(label);
        sheet.setColumnView(col, 30)
        col++
        label = new Label(col, row, "N.Poa"); sheet.addCell(label);
        sheet.setColumnView(col, 20)
        col++
        label = new Label(col, row, "Nombre"); sheet.addCell(label);
        sheet.setColumnView(col, 30)
        col++
        label = new Label(col, row, "Objetivo"); sheet.addCell(label);
        sheet.setColumnView(col, 30)
        col++
        label = new Label(col, row, "TDR's"); sheet.addCell(label);
        col++
        label = new Label(col, row, "Responsable"); sheet.addCell(label);
        sheet.setColumnView(col, 20)
        col++
        anios.each { a ->
            label = new Label(col, row, "Valor ${a.anio}"); sheet.addCell(label);
            sheet.setColumnView(col, 20)
            col++
        }
        label = new Label(col, row, "Monto"); sheet.addCell(label);
        sheet.setColumnView(col, 20)
        col++
        label = new Label(col, row, "Aprobacion"); sheet.addCell(label);
        sheet.setColumnView(col, 20)
        col++
        label = new Label(col, row, "Fecha Solicitud"); sheet.addCell(label);
        sheet.setColumnView(col, 20)

        row++

        list.each { solicitudInstance ->
            col = iniCol
            label = new Label(col, row, solicitudInstance.actividad.proyecto.toString()); sheet.addCell(label);
            col++
            label = new Label(col, row, solicitudInstance.actividad.marcoLogico.toString()); sheet.addCell(label);
            col++
            label = new Label(col, row, Asignacion.findByMarcoLogico(solicitudInstance.actividad)?.presupuesto?.numero); sheet.addCell(label);
            col++
            label = new Label(col, row, solicitudInstance.nombreProceso); sheet.addCell(label);
            col++
            label = new Label(col, row, solicitudInstance.objetoContrato); sheet.addCell(label);
            col++
            label = new Label(col, row, "X"); sheet.addCell(label);
            col++
            label = new Label(col, row, solicitudInstance.unidadEjecutora?.codigo); sheet.addCell(label);
            col++

            anios.each { a ->
                def valor = DetalleMontoSolicitud.findByAnioAndSolicitud(a, solicitudInstance)
                if (valor) {
                    number = new jxl.write.Number(col, row, valor.monto); sheet.addCell(number);
                } else {
                    label = new Label(col, row, ""); sheet.addCell(label);
                }
                col++
            }
            number = new jxl.write.Number(col, row, solicitudInstance.montoSolicitado); sheet.addCell(number);
            col++
            def estado = solicitudInstance.aprobacion
            if (estado) {
                println "1:::: " + estado
                println "2:::: " + estado?.fechaRealizacion
                println "3:::: " + solicitudInstance.tipoAprobacion
                label = new Label(col, row, solicitudInstance.tipoAprobacion?.descripcion + " (" + estado?.fechaRealizacion?.format("dd-MM-yyyy") + ")");
                sheet.addCell(label);
                col++
            } else {
                label = new Label(col, row, "Pendiente"); sheet.addCell(label);
                col++
            }
            label = new Label(col, row, solicitudInstance.fecha?.format('dd-MM-yyyy')); sheet.addCell(label);
            col++

            row++
        }

        workbook.write();
        workbook.close();
        def output = response.getOutputStream()
        def header = "attachment; filename=" + "solicitudes_aprobadas.xls";
        response.setContentType("application/octet-stream")
        response.setHeader("Content-Disposition", header);
        output.write(file.getBytes());
    }

    /**
     * Acción que genera un archivo PDF de las solicitudes listas para la reunión de aprobación
     */
    def solicitudesReunion = {
        def list = []
        list = Solicitud.findAll("from Solicitud where  incluirReunion='S' order by unidadEjecutora.id,fecha")
        def anios = []
        list.each { sol ->
            DetalleMontoSolicitud.findAllBySolicitud(sol, [sort: "anio"]).each { d ->
                if (!anios.contains(d.anio)) {
                    anios.add(d.anio)
                }


            }
        }
        return [solicitudInstanceList: list, anios: anios]
    }

    /**
     * Acción que genera un archivo PDF de una solicitud
     */
    def imprimirSolicitud = {
        def solicitud = Solicitud.get(params.id)

        def firmas = []

        if (solicitud.usuario) {
//            firmas += [cargo: solicitud?.usuario?.cargoPersonal?.descripcion ?: "Responsable unidad", usuario: solicitud.usuario]
            firmas += [cargo: solicitud?.usuario?.cargo ?: "Responsable unidad", usuario: solicitud.usuario]
        }
        return [solicitud: solicitud, firmas: firmas]
    }

    /**
     * Acción que muestra un pdf de la aprobacion de la solicitud
     * @deprecated ya no se usa, se usa imprimirActaReunionAprobacion
     */
    @Deprecated
    def imprimirActaAprobacion = {
////        println "Acta aprobacion:::: " + params
//        def solicitud = Solicitud.get(params.id)
//        def aprobacion = Aprobacion.findBySolicitud(solicitud)
//
////        def cargoDirectorPlanificacion = CargoPersonal.findByCodigo("DRPL")
////        def cargoGerentePlanificacion = CargoPersonal.findByCodigo("GRPL")
////
////        def directorPlanificacion = Usro.findByCargoPersonal(cargoDirectorPlanificacion)
////        def gerentePlanificacion = Usro.findByCargoPersonal(cargoGerentePlanificacion)
////
////        def firmas = []
////        if (directorPlanificacion) {
////            firmas += [cargo: "Director de planificación", usuario: directorPlanificacion]
////        }
////        if (gerentePlanificacion) {
////            firmas += [cargo: "Gerente de planificación", usuario: gerentePlanificacion]
////        }
//        def firmas = []
//        if (params.fgp != "null") {
//            def gerentePlanificacion = Usro.get(params.fgp)
//            if (gerentePlanificacion) {
////                firmas += [cargo: "GERENTE DE PLANIFICACIÓN", usuario: gerentePlanificacion]
//                firmas += [cargo: gerentePlanificacion?.cargoPersonal?.descripcion ?: "GERENTE DE PLANIFICACIÓN", usuario: gerentePlanificacion]
//            }
//        }
//        if (params.fdp != "null") {
//            def directorPlanificacion = Usro.get(params.fdp)
//            if (directorPlanificacion) {
////                firmas += [cargo: "DIRECTOR DE PLANIFICACIÓN", usuario: directorPlanificacion]
//                firmas += [cargo: directorPlanificacion?.cargoPersonal?.descripcion ?: "DIRECTOR DE PLANIFICACIÓN", usuario: directorPlanificacion]
//            }
//        }
//        if (params.fgt != "null") {
//            def gerenteTec = Usro.get(params.fgt)
//            if (gerenteTec) {
////                firmas += [cargo: "GERENTE TÉCNICO", usuario: gerenteTec]
//                firmas += [cargo: gerenteTec?.cargoPersonal?.descripcion ?: "GERENTE TÉCNICO", usuario: gerenteTec]
//            }
//        }
//        if (params.frq != "null") {
//            def req = Usro.get(params.frq)
//            if (req) {
//                firmas += [cargo: "REQUIRENTE", usuario: req]
//            }
//        }
//
//        return [solicitud: solicitud, aprobacion: aprobacion, firmas: firmas]
    }

    /**
     * Acción que genera un archivo PDF de la solicitud de aval
     */
    def imprimirSolicitudAval = {
//        println "impr sol " + params
        def solicitud = SolicitudAval.get(params.id)
//        println "solcitud " + solicitud

        def anio = Anio.findByAnio(new Date().format("yyyy"))
        def devengado = 0
        def anios = [:]
        def arr = [:]
        def total

        ProcesoAsignacion.findAllByProceso(solicitud.proceso).each {
            if (it.asignacion.anio.anio.toInteger() >= anio.anio.toInteger()) {
                if (arr[it.asignacion.marcoLogico]) {
                    arr[it.asignacion.marcoLogico]["total"] += it.monto
                    arr[it.asignacion.marcoLogico]["devengado"] += it.devengado
                    if (arr[it.asignacion.marcoLogico][it.asignacion.anio.anio]) {
                        arr[it.asignacion.marcoLogico][it.asignacion.anio.anio]["asignaciones"].add(it)
                        arr[it.asignacion.marcoLogico][it.asignacion.anio.anio]["total"] += it.monto


                    } else {
                        def mp = [:]
                        mp.put("asignaciones", [it])
                        mp.put("total", it.monto)
                        arr[it.asignacion.marcoLogico].put(it.asignacion.anio.anio, mp)
                    }

                } else {
                    def tmp = [:]
                    def mp = [:]
                    mp.put("asignaciones", [it])
                    mp.put("total", it.monto)

                    tmp.put(it.asignacion.anio.anio, mp)
                    tmp.put("total", it.monto)
                    tmp.put("devengado", it.devengado)
                    arr.put(it.asignacion.marcoLogico, tmp)
                }
            }
        }

        def dosDevengado = 0

        ProcesoAsignacion.findAllByProceso(solicitud.proceso).each {
            dosDevengado += it.devengado
        }

//        println("arr " + arr)

//        println("--><<<<>>" + arr)

        return [solicitud: solicitud, anios: anios, arr: arr, devengado: dosDevengado, anio: anio]
    }

    /**
     * Acción que genera un archivo PDF de la negacion de la solicitud de aval
     */
    def imprimirSolicitudAnulacionAval = {
//        println "impr sol " + params
        def solicitud = SolicitudAval.get(params.id)
//        println "solcitud " + solicitud
        return [solicitud: solicitud]
    }

    def imprimirActaReunionAprobacion = {
        def reunion = Aprobacion.get(params.id.toLong())
        def solicitudes = Solicitud.findAllByAprobacion(reunion)
        def firmas = []
        def anios = []
        if (reunion.firmaGerenciaTecnica || reunion.firmaDireccionPlanificacion || reunion.firmaGerenciaPlanificacion) {
            def gerentePlanificacion = reunion.firmaGerenciaPlanificacion
            if (gerentePlanificacion) {
                firmas += [cargo: gerentePlanificacion?.cargoPersonal?.descripcion ?: "GERENTE DE PLANIFICACIÓN", usuario: gerentePlanificacion]
            }
            def directorPlanificacion = reunion.firmaDireccionPlanificacion
            if (directorPlanificacion) {
                firmas += [cargo: directorPlanificacion?.cargoPersonal?.descripcion ?: "DIRECTOR DE PLANIFICACIÓN", usuario: directorPlanificacion]
            }
            def gerenteTec = reunion.firmaGerenciaTecnica
            if (gerenteTec) {
                firmas += [cargo: gerenteTec?.cargoPersonal?.descripcion ?: "GERENTE TÉCNICO", usuario: gerenteTec]
            }
        } else {
            if (params.fgp != "null") {
                def gerentePlanificacion = Persona.get(params.fgp)
                reunion.firmaGerenciaPlanificacion = gerentePlanificacion
                if (gerentePlanificacion) {
                    firmas += [cargo: gerentePlanificacion?.cargoPersonal?.descripcion ?: "GERENTE DE PLANIFICACIÓN", usuario: gerentePlanificacion]
//                firmas += [cargo: "GERENTE DE PLANIFICACIÓN", usuario: gerentePlanificacion]
                }
            }
            if (params.fdp != "null") {
                def directorPlanificacion = Persona.get(params.fdp)
                reunion.firmaDireccionPlanificacion = directorPlanificacion
                if (directorPlanificacion) {
//                firmas += [cargo: "DIRECTOR DE PLANIFICACIÓN", usuario: directorPlanificacion]
                    firmas += [cargo: directorPlanificacion?.cargoPersonal?.descripcion ?: "DIRECTOR DE PLANIFICACIÓN", usuario: directorPlanificacion]
                }
            }
            if (params.fgt != "null") {
                def gerenteTec = Persona.get(params.fgt)
                reunion.firmaGerenciaTecnica = gerenteTec
                if (gerenteTec) {
//                firmas += [cargo: "GERENTE TÉCNICO", usuario: gerenteTec]
                    firmas += [cargo: gerenteTec?.cargoPersonal?.descripcion ?: "GERENTE TÉCNICO", usuario: gerenteTec]
                }
            }
            if (!reunion.save(flush: true)) {
                println "error save reunion firmas: " + reunion.errors
            }
        }
        solicitudes.each { sol ->
            DetalleMontoSolicitud.findAllBySolicitud(sol, [sort: "anio"]).each { d ->
                if (!anios.contains(d.anio)) {
                    anios.add(d.anio)
                }
            }
        }

        return [reunion: reunion, solicitudes: solicitudes, firmas: firmas, anios: anios]
    }

    def solicitudReformaPdf = {
        def sol = SolicitudModPoa.get(params.id)
        def fecha = sol.fecha.format("dd-MM-yyyy")
        def nmroMemo = ''
        def para = 'Srta Econ. Rocio Elizabeth Gavilanes Reyes'
        def cargo = 'GERENTE DE PLANIFICACIÓN'
        def asunto = 'Solicitud de reforma del POA'
        def nombreFirma = sol.usuario
        def cargofirma = ''
        def gerente = Sesn.findByPerfil(Prfl.findByCodigo("GP"))
        if (gerente) {
            gerente = gerente.usuario
        }
        return [fecha: fecha, numero: nmroMemo, para: para, cargo: cargo, asunto: asunto, nombreFirma: nombreFirma, cargoFirma: cargofirma, gerente: gerente, solicitud: sol]


    }

    def respuestaSolicitudReforma = {

        def fecha = new Date().format("dd-MM-yyyy")
        def nmroMemo = 'YACHAY-GAF-2014-0102-MI'
        def para = 'Srta Abg. Gabriela Valeria Diaz Peñafiel'
        def cargo = 'Gerente de Planificación'
        def asunto = 'solicitud de reforma del poa'
        def nombreFirma = 'Abg. Gabriela Valeria Diaz Peñafiel'
        def cargofirma = 'GERENTE ADMINISTRATIVA FINANCIERA'

        return [fecha: fecha, numero: nmroMemo, para: para, cargo: cargo, asunto: asunto, nombreFirma: nombreFirma, cargoFirma: cargofirma]
    }

    def solicitudAvalCorriente() {
        def proceso = AvalCorriente.get(params.id)
        return [proceso: proceso, detalles: AvalCorrienteController.arreglarDetalles(proceso)]
    }

    def avalCorriente() {
        def proceso = AvalCorriente.get(params.id)
        def transf = NumberToLetterConverter.convertNumberToLetter(proceso?.monto)

        return [proceso: proceso, detalles: AvalCorrienteController.arreglarDetalles(proceso), transf: transf]
    }
}
