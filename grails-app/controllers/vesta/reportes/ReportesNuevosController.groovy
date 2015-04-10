package vesta.reportes

import vesta.parametros.poaPac.Anio
import vesta.parametros.poaPac.Fuente
import vesta.parametros.poaPac.Mes
import vesta.proyectos.MarcoLogico
import vesta.proyectos.Proyecto

class ReportesNuevosController {

    def poaProyectoGUI() {
    }

    def poaAreaGestionGUI() {
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

    def poaProyectoPdf() {
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
