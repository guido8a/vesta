package vesta.reportes

import vesta.modificaciones.DetalleReforma
import vesta.modificaciones.Reforma
import vesta.proyectos.ModificacionAsignacion

class ReportesReformaCorrientesController {

    public static Map generaDetallesReforma_function(Reforma reforma) {
        def detalles = DetalleReforma.findAllByReforma(reforma)
        def modificaciones = ModificacionAsignacion.findAllByDetalleReformaInList(detalles)
        def det = [:]

        modificaciones.each { modificacion ->
            def key = "" + modificacion.desdeId
            if (!det[key]) {
                det[key] = [:]
                det[key].desde = [:]
                det[key].desde.objetivo = modificacion.desde.tarea.actividad.macroActividad.objetivoGastoCorriente.descripcion
                det[key].desde.macro = modificacion.desde.tarea.actividad.macroActividad.descripcion
                det[key].desde.actividad = modificacion.desde.tarea.actividad.descripcion
                det[key].desde.tarea = modificacion.desde.tarea.descripcion
                det[key].desde.partida = modificacion.desde.presupuesto.numero
                det[key].desde.inicial = modificacion.originalOrigen
                det[key].desde.dism = 0
                det[key].desde.aum = 0
                det[key].desde.final = modificacion.originalOrigen

                det[key].hasta = []
            }
            if (modificacion.detalleReforma.reforma.tipoSolicitud == "T") {
                if (modificacion.valor < 0) {
                    det[key].desde.dism += modificacion.valor * -1
                    det[key].desde.final -= modificacion.valor * -1
                } else {
                    det[key].desde.aum += modificacion.valor
                    det[key].desde.final += modificacion.valor
                }
            } else {
                det[key].desde.dism += modificacion.valor
                det[key].desde.final -= modificacion.valor
            }

            if (modificacion.recibe) {
                def m = [:]

                m.objetivo = modificacion.recibe.tarea.actividad.macroActividad.objetivoGastoCorriente.descripcion
                m.macro = modificacion.recibe.tarea.actividad.macroActividad.descripcion
                m.actividad = modificacion.recibe.tarea.actividad.descripcion
                m.tarea = modificacion.recibe.tarea.descripcion
                m.partida = modificacion.recibe.presupuesto.numero
                m.inicial = modificacion.originalDestino
                m.dism = 0
                m.aum = modificacion.valor
                m.final = modificacion.originalDestino + modificacion.valor

                det[key].hasta += m
            }
        }
        return det
    }

    public static Map generaDetallesSolicitudExistente(Reforma reforma) {
        def detalles = DetalleReforma.findAllByReforma(reforma, [sort: "asignacionOrigen"])
        def valorFinalDestino = [:]
        def det = [:]
        def total = 0
        detalles.each { detalle ->
            total += detalle.valor
            def key = "" + detalle.asignacionOrigenId
            def keyDestino = "" + detalle.asignacionDestinoId
            if (!det[key]) {
                det[key] = [:]
                det[key].desde = [:]
                det[key].desde.id = detalle.id
                det[key].desde.objetivo = detalle.asignacionOrigen.tarea.actividad.macroActividad.objetivoGastoCorriente.descripcion
                det[key].desde.macro = detalle.asignacionOrigen.tarea.actividad.macroActividad.descripcion
                det[key].desde.actividad = detalle.asignacionOrigen.tarea.actividad.descripcion
                det[key].desde.tarea = detalle.asignacionOrigen.tarea.descripcion
                det[key].desde.responsable = detalle.asignacionOrigen.unidad.gerencia.codigo
                det[key].desde.partida = detalle.asignacionOrigen.presupuesto.numero
                det[key].desde.inicial = detalle.valorOrigenInicial
                det[key].desde.dism = 0
                det[key].desde.aum = 0
                det[key].desde.final = detalle.valorOrigenInicial

                det[key].hasta = []
            }
            det[key].desde.dism += detalle.valor
            det[key].desde.final -= detalle.valor

            if (!valorFinalDestino[keyDestino]) {
                valorFinalDestino[keyDestino] = detalle.valorDestinoInicial
            }

            def m = [:]

            m.id = detalle.id
            m.objetivo = detalle.asignacionDestino.tarea.actividad.macroActividad.objetivoGastoCorriente.descripcion
            m.macro = detalle.asignacionDestino.tarea.actividad.macroActividad.descripcion
            m.actividad = detalle.asignacionDestino.tarea.actividad.descripcion
            m.tarea = detalle.asignacionDestino.tarea.descripcion
            m.responsable = detalle.asignacionDestino.unidad.gerencia.codigo
            m.partida = detalle.asignacionDestino.presupuesto.numero
            m.inicial = valorFinalDestino[keyDestino]
            m.dism = 0
            m.aum = detalle.valor
            m.final = valorFinalDestino[keyDestino] + detalle.valor

            det[key].hasta += m

            valorFinalDestino[keyDestino] = m.final
        }
        return [det: det, det2: [:], total: total]
    }

    public static Map generaDetallesSolicitudPartida(Reforma reforma) {
        def detalles = DetalleReforma.findAllByReforma(reforma, [sort: "asignacionOrigen"])
        def valorFinalDestino = [:]
        def det = [:]
        def total = 0
        detalles.each { detalle ->
            total += detalle.valor
            def key = "" + detalle.asignacionOrigenId
            def keyDestino = "" + detalle.asignacionDestinoId
            if (!det[key]) {
                det[key] = [:]
                det[key].desde = [:]
                det[key].desde.id = detalle.id
                det[key].desde.objetivo = detalle.asignacionOrigen.tarea.actividad.macroActividad.objetivoGastoCorriente.descripcion
                det[key].desde.macro = detalle.asignacionOrigen.tarea.actividad.macroActividad.descripcion
                det[key].desde.actividad = detalle.asignacionOrigen.tarea.actividad.descripcion
                det[key].desde.tarea = detalle.asignacionOrigen.tarea.descripcion
                det[key].desde.responsable = detalle.asignacionOrigen.unidad.gerencia.codigo
                det[key].desde.partida = detalle.asignacionOrigen.presupuesto.numero
                det[key].desde.inicial = detalle.valorOrigenInicial
                det[key].desde.dism = 0
                det[key].desde.aum = 0
                det[key].desde.final = detalle.valorOrigenInicial

                det[key].hasta = []
            }
            det[key].desde.dism += detalle.valor
            det[key].desde.final -= detalle.valor

            if (!valorFinalDestino[keyDestino]) {
                valorFinalDestino[keyDestino] = detalle.valor
            }

            def m = [:]

            m.id = detalle.id
            m.objetivo = detalle.asignacionOrigen.tarea.actividad.macroActividad.objetivoGastoCorriente.descripcion
            m.macro = detalle.asignacionOrigen.tarea.actividad.macroActividad.descripcion
            m.actividad = detalle.asignacionOrigen.tarea.actividad.descripcion
            m.tarea = detalle.asignacionOrigen.tarea.descripcion
            m.responsable = detalle.asignacionOrigen.unidad.gerencia.codigo
            m.partida = detalle.presupuesto.numero
            m.inicial = valorFinalDestino[keyDestino]
            m.dism = 0
            m.aum = detalle.valor
            m.final = valorFinalDestino[keyDestino] + detalle.valor

            det[key].hasta += m

            valorFinalDestino[keyDestino] = m.final
        }
        return [det: det, det2: [:], total: total]
    }
}
