package vesta.reportes

import vesta.parametros.TipoElemento
import vesta.parametros.poaPac.Anio
import vesta.parametros.poaPac.Fuente
import vesta.parametros.poaPac.Mes
import vesta.parametros.poaPac.Presupuesto
import vesta.poa.Asignacion
import vesta.proyectos.MarcoLogico
import vesta.proyectos.Proyecto

class ReportesNuevosController {

    def poaGrupoGastos_funcion() {
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

    def poaAreaGestionGUI() {
    }

    def poaAreaGestionPdf() {
    }

    def poaGrupoGastoGUI() {
        def data = poaGrupoGastos_funcion()
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

    def poaGrupoGastoPdf() {
        def data = poaGrupoGastos_funcion()
        return [anio: data.anio, data: data.data, anios: data.anios, totales: data.totales]
    }

    def poaGrupoGastoPdfDetallado() {
    }

    def poaProyectoGUI() {
        def data = poaProyecto_funcion()
        return [anio: data.anio, data: data.data, anios: data.anios, totales: data.totales]
    }

    def poaProyectoPdf() {
        def data = poaProyecto_funcion()
        return [anio: data.anio, data: data.data, anios: data.anios, totales: data.totales]
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

}
