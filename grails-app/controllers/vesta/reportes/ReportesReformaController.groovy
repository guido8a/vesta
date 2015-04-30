package vesta.reportes

import vesta.modificaciones.DetalleReforma
import vesta.modificaciones.Reforma
import vesta.proyectos.ModificacionAsignacion

class ReportesReformaController {

    def index() {}

    def existente() {
        def reforma = Reforma.get(params.id)
        def detalles = DetalleReforma.findAllByReforma(reforma)
        def total = 0
        if (detalles.size() > 0) {
            total = detalles.sum { it.valor }
        }
        return [reforma: reforma, detalles: detalles, total: total]

    }

    def actividad() {
        def reforma = Reforma.get(params.id)
        def detalles = DetalleReforma.findAllByReforma(reforma)
        def total = 0
        if (detalles.size() > 0) {
            total = detalles.sum { it.valor }
        }

        return [reforma: reforma, detalles: detalles, total: total]
    }

    def partida() {
        def reforma = Reforma.get(params.id)
        def detalles = DetalleReforma.findAllByReforma(reforma)
        def total = 0
        if (detalles.size() > 0) {
            total = detalles.sum { it.valor }
        }
        return [reforma: reforma, detalles: detalles, total: total]

    }

    def incremento() {
        def reforma = Reforma.get(params.id)
        def detalles = DetalleReforma.findAllByReformaAndAsignacionOrigenIsNull(reforma)
        def detalles2 = DetalleReforma.findAllByReformaAndAsignacionOrigenIsNotNull(reforma)

        def total = 0
        if (detalles.size() > 0) {
            total = detalles.sum { it.valor }
        }

        return [reforma: reforma, detalles: detalles, total: total, detalles2: detalles2]
    }

    def existenteReforma() {
        def reforma = Reforma.get(params.id)
        def detalles = DetalleReforma.findAllByReforma(reforma)
        def modificaciones = ModificacionAsignacion.findAllByDetalleReformaInList(detalles)

        def det = [:]
        modificaciones.each { modificacion ->
            def key = "" + modificacion.desdeId
            if (!det[key]) {
                det[key] = [:]
                det[key].desde = [:]
                det[key].desde.proyecto = modificacion.desde.marcoLogico.proyecto.toStringCompleto()
                det[key].desde.componente = modificacion.desde.marcoLogico.marcoLogico.toStringCompleto()
                det[key].desde.no = modificacion.desde.marcoLogico.numero
                det[key].desde.actividad = modificacion.desde.marcoLogico.toStringCompleto()
                det[key].desde.partida = modificacion.desde.toString()
                det[key].desde.inicial = modificacion.originalOrigen
                det[key].desde.dism = 0
                det[key].desde.aum = 0
                det[key].desde.final = modificacion.originalOrigen

                det[key].hasta = []
            }
            det[key].desde.dism += modificacion.valor
            det[key].desde.final -= modificacion.valor

            def m = [:]

            m.proyecto = modificacion.recibe.marcoLogico.proyecto.toStringCompleto()
            m.componente = modificacion.recibe.marcoLogico.marcoLogico.toStringCompleto()
            m.no = modificacion.recibe.marcoLogico.numero
            m.actividad = modificacion.recibe.marcoLogico.toStringCompleto()
            m.partida = modificacion.recibe.toString()
            m.inicial = modificacion.originalDestino
            m.dism = 0
            m.aum = modificacion.valor
            m.final = modificacion.originalDestino + modificacion.valor

            det[key].hasta += m
        }

        println det

        return [reforma: reforma, modificaciones: modificaciones, det: det]
    }

    def partidaReforma() {
        def reforma = Reforma.get(params.id)
        def detalles = DetalleReforma.findAllByReforma(reforma)
        def modificaciones = ModificacionAsignacion.findAllByDetalleReformaInList(detalles)
        return [reforma: reforma, modificaciones: modificaciones]
    }

    def actividadReforma() {
        def reforma = Reforma.get(params.id)
        def detallesReforma = DetalleReforma.findAllByReforma(reforma)
        def detalles = ModificacionAsignacion.findAllByDetalleReformaInList(detallesReforma)
        def total = 0
        if (detalles.size() > 0) {
            total = detalles.sum { it.valor }
        }
        return [reforma: reforma, detalles: detalles, total: total]

    }


    def incrementoReforma() {

        def reforma = Reforma.get(params.id)
        def detalles = DetalleReforma.findAllByReforma(reforma)

        def modificaciones = ModificacionAsignacion.findAllByDetalleReformaInList(detalles)

        return [reforma: reforma, modificaciones: modificaciones]

    }

}
