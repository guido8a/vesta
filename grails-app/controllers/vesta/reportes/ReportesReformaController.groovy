package vesta.reportes

import vesta.modificaciones.DetalleReforma
import vesta.modificaciones.Reforma
import vesta.proyectos.ModificacionAsignacion

class ReportesReformaController {

    def index() {}

    def existente() {
        def reforma = Reforma.get(params.id)
        def detalles = DetalleReforma.findAllByReforma(reforma)
        def valorFinalDestino = [:]

        def det = [:]
        detalles.each { detalle ->
            def key = "" + detalle.asignacionOrigenId
            def keyDestino = "" + detalle.asignacionDestinoId
            if (!det[key]) {
                det[key] = [:]
                det[key].desde = [:]
                det[key].desde.proyecto = detalle.asignacionOrigen.marcoLogico.proyecto.toStringCompleto()
                det[key].desde.componente = detalle.asignacionOrigen.marcoLogico.marcoLogico.toStringCompleto()
                det[key].desde.no = detalle.asignacionOrigen.marcoLogico.numero
                det[key].desde.actividad = detalle.asignacionOrigen.marcoLogico.toStringCompleto()
                det[key].desde.partida = detalle.asignacionOrigen.toString()
                det[key].desde.inicial = detalle.asignacionOrigen.priorizado
                det[key].desde.dism = 0
                det[key].desde.aum = 0
                det[key].desde.final = detalle.asignacionOrigen.priorizado

                det[key].hasta = []
            }
            det[key].desde.dism += detalle.valor
            det[key].desde.final -= detalle.valor

            if (!valorFinalDestino[keyDestino]) {
                valorFinalDestino[keyDestino] = detalle.asignacionDestino.priorizado
            }

            def m = [:]

            m.proyecto = detalle.asignacionDestino.marcoLogico.proyecto.toStringCompleto()
            m.componente = detalle.asignacionDestino.marcoLogico.marcoLogico.toStringCompleto()
            m.no = detalle.asignacionDestino.marcoLogico.numero
            m.actividad = detalle.asignacionDestino.marcoLogico.toStringCompleto()
            m.partida = detalle.asignacionDestino.toString()
            m.inicial = valorFinalDestino[keyDestino]
            m.dism = 0
            m.aum = detalle.valor
            m.final = valorFinalDestino[keyDestino] + detalle.valor

            det[key].hasta += m

            valorFinalDestino[keyDestino] = m.final
        }

        return [reforma: reforma, det: det]
    }

    def actividad() {
        def reforma = Reforma.get(params.id)
        def detalles = DetalleReforma.findAllByReforma(reforma)
        def valorFinalDestino = [:]

        def det = [:]
        detalles.each { detalle ->
            def key = "" + detalle.asignacionOrigenId
            def keyDestino = "" + detalle.asignacionDestinoId
            if (!det[key]) {
                det[key] = [:]
                det[key].desde = [:]
                det[key].desde.proyecto = detalle.asignacionOrigen.marcoLogico.proyecto.toStringCompleto()
                det[key].desde.componente = detalle.asignacionOrigen.marcoLogico.marcoLogico.toStringCompleto()
                det[key].desde.no = detalle.asignacionOrigen.marcoLogico.numero
                det[key].desde.actividad = detalle.asignacionOrigen.marcoLogico.toStringCompleto()
                det[key].desde.partida = detalle.asignacionOrigen.toString()
                det[key].desde.inicial = detalle.asignacionOrigen.priorizado
                det[key].desde.dism = 0
                det[key].desde.aum = 0
                det[key].desde.final = detalle.asignacionOrigen.priorizado

                det[key].hasta = []
            }
            det[key].desde.dism += detalle.valor
            det[key].desde.final -= detalle.valor

            if (!valorFinalDestino[keyDestino]) {
                valorFinalDestino[keyDestino] = 0
            }

            def m = [:]

            m.proyecto = detalle.componente.proyecto.toStringCompleto()
            m.componente = detalle.componente.toStringCompleto()
            m.no = "Nueva"
            m.actividad = detalle.descripcionNuevaActividad
            m.partida = "<strong>Responsable:</strong> ${reforma.persona.unidad}\n" +
                    "<strong>Priorizado:</strong> ${detalle.valor}\n" +
                    "<strong>Partida Presupuestaria:</strong> ${detalle.presupuesto}\n" +
                    "<strong>Año:</strong> ${reforma.anio.anio}"
            m.inicial = 0
            m.dism = 0
            m.aum = detalle.valor
            m.final = valorFinalDestino[keyDestino] + detalle.valor

            det[key].hasta += m

            valorFinalDestino[keyDestino] = m.final
        }

        return [reforma: reforma, det: det]
    }

    def partida() {
        def reforma = Reforma.get(params.id)
        def detalles = DetalleReforma.findAllByReforma(reforma)
        def valorFinalDestino = [:]

        def det = [:]
        detalles.each { detalle ->
            def key = "" + detalle.asignacionOrigenId
            def keyDestino = "" + detalle.asignacionDestinoId
            if (!det[key]) {
                det[key] = [:]
                det[key].desde = [:]
                det[key].desde.proyecto = detalle.asignacionOrigen.marcoLogico.proyecto.toStringCompleto()
                det[key].desde.componente = detalle.asignacionOrigen.marcoLogico.marcoLogico.toStringCompleto()
                det[key].desde.no = detalle.asignacionOrigen.marcoLogico.numero
                det[key].desde.actividad = detalle.asignacionOrigen.marcoLogico.toStringCompleto()
                det[key].desde.partida = detalle.asignacionOrigen.toString()
                det[key].desde.inicial = detalle.asignacionOrigen.priorizado
                det[key].desde.dism = 0
                det[key].desde.aum = 0
                det[key].desde.final = detalle.asignacionOrigen.priorizado

                det[key].hasta = []
            }
            det[key].desde.dism += detalle.valor
            det[key].desde.final -= detalle.valor

            if (!valorFinalDestino[keyDestino]) {
                valorFinalDestino[keyDestino] = detalle.valor
            }

            def m = [:]

            m.proyecto = detalle.asignacionOrigen.marcoLogico.proyecto.toStringCompleto()
            m.componente = detalle.asignacionOrigen.marcoLogico.marcoLogico.toStringCompleto()
            m.no = detalle.asignacionOrigen.marcoLogico.numero
            m.actividad = detalle.asignacionOrigen.marcoLogico.toStringCompleto()
            m.partida = "<strong>Responsable:</strong> ${reforma.persona.unidad}\n" +
                    "<strong>Priorizado:</strong> 0.00\n" +
                    "<strong>Partida Presupuestaria:</strong> ${detalle.presupuesto}\n" +
                    "<strong>Año:</strong> ${reforma.anio.anio}"
            m.inicial = valorFinalDestino[keyDestino]
            m.dism = 0
            m.aum = detalle.valor
            m.final = valorFinalDestino[keyDestino] + detalle.valor

            det[key].hasta += m

            valorFinalDestino[keyDestino] = m.final
        }

        return [reforma: reforma, det: det]
    }

    def incremento() {
        def reforma = Reforma.get(params.id)
        def detalles = DetalleReforma.findAllByReformaAndAsignacionOrigenIsNull(reforma)
        def detalles2 = DetalleReforma.findAllByReformaAndAsignacionOrigenIsNotNull(reforma)

        def valorFinalDestino = [:]

        def det = [:], det2 = [:]
        detalles.eachWithIndex { detalle, i ->
            def key = "" + i
            def keyDestino = "" + detalle.asignacionDestinoId
            if (!det[key]) {
                det[key] = [:]
                det[key].desde = [:]
                det[key].desde.proyecto = false
                det[key].desde.inicial = 0
                det[key].desde.dism = 0
                det[key].desde.aum = 0
                det[key].desde.final = 0
                det[key].hasta = []
            }
            if (!valorFinalDestino[keyDestino]) {
                valorFinalDestino[keyDestino] = detalle.asignacionDestino.priorizado
            }

            def m = [:]

            m.proyecto = detalle.asignacionDestino.marcoLogico.proyecto.toStringCompleto()
            m.componente = detalle.asignacionDestino.marcoLogico.marcoLogico.toStringCompleto()
            m.no = detalle.asignacionDestino.marcoLogico.numero
            m.actividad = detalle.asignacionDestino.marcoLogico.toStringCompleto()
            m.partida = detalle.asignacionDestino.toString()
            m.inicial = valorFinalDestino[keyDestino]
            m.dism = 0
            m.aum = detalle.valor
            m.final = valorFinalDestino[keyDestino] + detalle.valor

            det[key].hasta += m

            valorFinalDestino[keyDestino] = m.final
        }
        detalles2.each { detalle ->
            def key = "" + detalle.asignacionOrigenId
            def keyDestino = "" + detalle.asignacionDestinoId
            if (!det2[key]) {
                det2[key] = [:]
                det2[key].desde = [:]
                det2[key].desde.proyecto = detalle.asignacionOrigen.marcoLogico.proyecto.toStringCompleto()
                det2[key].desde.componente = detalle.asignacionOrigen.marcoLogico.marcoLogico.toStringCompleto()
                det2[key].desde.no = detalle.asignacionOrigen.marcoLogico.numero
                det2[key].desde.actividad = detalle.asignacionOrigen.marcoLogico.toStringCompleto()
                det2[key].desde.partida = detalle.asignacionOrigen.toString()
                det2[key].desde.inicial = detalle.asignacionOrigen.priorizado
                det2[key].desde.dism = 0
                det2[key].desde.aum = 0
                det2[key].desde.final = detalle.asignacionOrigen.priorizado

                det2[key].hasta = []
            }
            det2[key].desde.dism += detalle.valor
            det2[key].desde.final -= detalle.valor

            if (!valorFinalDestino[keyDestino]) {
                valorFinalDestino[keyDestino] = detalle.asignacionDestino.priorizado
            }

            def m = [:]

            m.proyecto = detalle.asignacionDestino.marcoLogico.proyecto.toStringCompleto()
            m.componente = detalle.asignacionDestino.marcoLogico.marcoLogico.toStringCompleto()
            m.no = detalle.asignacionDestino.marcoLogico.numero
            m.actividad = detalle.asignacionDestino.marcoLogico.toStringCompleto()
            m.partida = detalle.asignacionDestino.toString()
            m.inicial = valorFinalDestino[keyDestino]
            m.dism = 0
            m.aum = detalle.valor
            m.final = valorFinalDestino[keyDestino] + detalle.valor

            det2[key].hasta += m

            valorFinalDestino[keyDestino] = m.final
        }

        return [reforma: reforma, detalles: detalles, det: det, det2: det2]
    }

    def existenteReforma() {
        def reforma = Reforma.get(params.id)
        def detalles = DetalleReforma.findAllByReforma(reforma)
        def modificaciones = ModificacionAsignacion.findAllByDetalleReformaInList(detalles)
        return [reforma: reforma, det: generaDetalles_function(modificaciones)]
    }

    def partidaReforma() {
        def reforma = Reforma.get(params.id)
        def detalles = DetalleReforma.findAllByReforma(reforma)
        def modificaciones = ModificacionAsignacion.findAllByDetalleReformaInList(detalles)
        return [reforma: reforma, det: generaDetalles_function(modificaciones)]
    }

    def actividadReforma() {
        def reforma = Reforma.get(params.id)
        def detalles = DetalleReforma.findAllByReforma(reforma)
        def modificaciones = ModificacionAsignacion.findAllByDetalleReformaInList(detalles)
        return [reforma: reforma, det: generaDetalles_function(modificaciones)]
    }

    def incrementoReforma() {
        def reforma = Reforma.get(params.id)
        def detalles = DetalleReforma.findAllByReforma(reforma)
        def modificaciones = ModificacionAsignacion.findAllByDetalleReformaInList(detalles)
        return [reforma: reforma, det: generaDetalles_function(modificaciones)]

    }

    def generaDetalles_function(List<ModificacionAsignacion> modificaciones) {
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
        return det
    }

}
