package vesta.reportes

import vesta.parametros.poaPac.Anio
import vesta.parametros.poaPac.Mes
import vesta.proyectos.Proyecto

class ReportesNuevosController {

    def poaProyectoGUI() {
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
        return [proys: proys, meses: meses, anio: anio, params: params]
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

}
