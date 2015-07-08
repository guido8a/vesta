package vesta.poaCorrientes

import vesta.parametros.poaPac.Anio
import vesta.seguridad.Shield

class PoaCorrienteController extends Shield {

    def copiarPoa() {
        def aniosDesde = ActividadCorriente.withCriteria {
            projections {
                distinct("anio")
            }
        }

        return [aniosDesde: aniosDesde]
    }

    def cargaActividadesDisponibles_ajax() {
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
}
