package vesta.poaCorrientes

import vesta.parametros.UnidadEjecutora
import vesta.parametros.poaPac.Anio
import vesta.seguridad.Shield



class PoaCorrienteController extends Shield {
    def dbConnectionService

    def copiarPoa() {
        def aniosDesde = ActividadCorriente.withCriteria {
            projections {
                distinct("anio")
            }
        }

        return [aniosDesde: aniosDesde]
    }

    def cargaActividadesDisponibles_ajax() {
        println("params " + params)
        def anio = Anio.get(params.anio)
        def macro = MacroActividad.get(params.macro)

        def acts = ActividadCorriente.findAllByAnioAndMacroActividad(anio, macro)
        return [acts: acts]
    }

    def cargaActividadesCopiadas_ajax() {
        def anio = Anio.get(params.anio)
        def macro = MacroActividad.get(params.macro)

        def acts = ActividadCorriente.findAllByAnioAndMacroActividad(anio, macro)
        return [acts: acts]
    }

    def cargarOtrosAnios_ajax() {
        def anio = Anio.get(params.anio)
        def anios = Anio.findAllByIdNotEqual(anio.id, [sort: "anio"])

        def select = g.select(name: "anioHasta", from: anios, "class": "form-control input-sm", optionKey: "id", optionValue: "anio")
        def js = "<script type='text/javascript'>" +
                "\$(\"#anioHasta\").change(function () {\n" +
                "    \$(\"#spAnioHasta\").text(\$(\"#anioHasta\").find(\"option:selected\").text());\n" +
                "});" +
                "</script>"
        render select + js
    }

    def copiarActividadesTareas_ajax() {
        println "COPIAR ACT: " + params
        def errores = ""
        def anioHasta = Anio.get(params.hasta)

        def actsId = params.acts.split(",")
        def tarsId = params.tareas.split(",")

        def mapActs = [:]

        actsId.each { aId ->
            if (aId.toString().trim() != "") {
                def act = ActividadCorriente.get(aId.toString().toLong())
                if (act) {
                    def nuevaAct = new ActividadCorriente()
                    nuevaAct.macroActividad = act.macroActividad
                    nuevaAct.anio = anioHasta
                    nuevaAct.descripcion = act.descripcion
                    nuevaAct.meta = act.meta
                    if (nuevaAct.save(flush: true)) {
                        mapActs["" + act.id] = nuevaAct
                    } else {
                        println "error al guardar nueva actividad: " + nuevaAct.errors
                        errores += renderErrors(bean: nuevaAct)
                    }
                }
            }
        }

        tarsId.each { tId ->
            if (tId.toString().trim() != "") {
                def tar = Tarea.get(tId.toString().trim().toLong())
                if (tar) {
                    def nuevaTarea = new Tarea()
                    nuevaTarea.actividad = mapActs["" + tar.actividadId]
                    nuevaTarea.descripcion = tar.descripcion
                    if (!nuevaTarea.save(flush: true)) {
                        println "error al guardar la nueva tarea: " + nuevaTarea.errors
                        errores += renderErrors(bean: nuevaTarea)
                    }
                }
            }
        }

        if (errores == "") {
            render "SUCCESS*Actividades y tareas copiadas exitosamente"
        } else {
            render "ERROR*" + errores
        }
    }

    def eliminarActividadesTareas_ajax() {
        println "ELIMINAR ACT: " + params
        def errores = ""

        def actsId = params.acts.split(",")
        def tarsId = params.tareas.split(",")

        tarsId.each { tId ->
            if (tId.toString().trim() != "") {
                def tar = Tarea.get(tId.toString().trim().toLong())
                if (tar) {
                    try {
                        tar.delete(flush: true)
                    } catch (e) {
                        errores += "<li>No se pudo eliminar la tarea " + tar.descripcion + "</li>"
                    }
                }
            }
        }
        actsId.each { aId ->
            if (aId.toString().trim() != "") {
                def act = ActividadCorriente.get(aId.toString().toLong())
                if (act) {
                    try {
                        act.delete(flush: true)
                    } catch (e) {
                        errores += "<li>No se pudo eliminar la actividad " + act.descripcion + "</li>"
                    }
                }
            }
        }

        if (errores == "") {
            render "SUCCESS*Actividades y tareas eliminadas exitosamente"
        } else {
            render "ERROR*<ul>" + errores + "</ul>"
        }
    }

    def administrar () {


        def cn = dbConnectionService.getConnection()
        def actual
        if (params.anio) {
            actual = Anio.get(params.anio)
        } else {
            actual = Anio.findByAnio(new Date().format("yyyy"))
        }

        def unidad = UnidadEjecutora.get(session.unidad.id)
        def proyectos = unidad.getProyectosUnidad(actual, session.perfil.codigo.toString())

        def anios__id = 0
        try {
            anios__id = cn.rows("select distinct asgn.anio__id, anioanio from asgn, mrlg, anio " +
                    "where mrlg.mrlg__id = asgn.mrlg__id and proy__id in (${proyectos.id.join(',')}) and " +
                    "anio.anio__id = asgn.anio__id and cast(anioanio as integer) >= ${actual.anio} " +
                    "order by anioanio".toString()).anio__id

        } catch (e) {
            println e
        }

        def anios = []
        if(anios__id) {
            anios = Anio.findAllByIdInList(anios__id)
        }


        return [anios: anios, actual: actual]

    }

    def cargarObjetivos_ajax () {

        def anio = Anio.get(params.anio)
        List<ObjetivoGastoCorriente> objetivos = []
        ActividadCorriente.findAllByAnio(anio).each { ac ->
            def ob = ac.macroActividad.objetivoGastoCorriente
            if (!objetivos.contains(ob)) {
                objetivos += ob
            }
        }
        objetivos = objetivos.unique().sort { it.descripcion }
        return [objetivos: objetivos, params: params]

    }

    def cargarMacro_ajax () {
        if (!params.mod) {
            params.mod = ""
        }
        def objetivo = ObjetivoGastoCorriente.get(params.objetivo)
        def macroActividades = MacroActividad.findAllByObjetivoGastoCorriente(objetivo)
        return [macro: macroActividades, params: params, valor: params.mac ?: '']
    }

    def cargarActividades_ajax() {

        def anio = Anio.get(params.anio)
        def macro = MacroActividad.get(params.macro)

        def acts = ActividadCorriente.findAllByAnioAndMacroActividad(anio, macro)
        return [acts: acts]

    }
}
