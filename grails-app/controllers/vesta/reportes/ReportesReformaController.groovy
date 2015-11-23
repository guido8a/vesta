package vesta.reportes

import vesta.modificaciones.DetalleReforma
import vesta.modificaciones.Reforma
import vesta.parametros.UnidadEjecutora
import vesta.proyectos.ModificacionAsignacion

class ReportesReformaController {

    def firmasService

    /**
     * Acción que muestra el pdf de la solicitud de reforma existente
     */
    def existente() {
        Reforma reforma = Reforma.get(params.id.toString().toLong())
        def det
        if (reforma.tipo == "C") {
            det = ReportesReformaCorrientesController.generaDetallesSolicitudExistente(reforma).det
        } else {
            det = generaDetallesSolicitudExistente(reforma).det
        }

        def uni = firmasService.requirentes(reforma.persona.unidad)

        return [reforma: reforma, det: det, unidades: reforma.persona.unidad.unidadYGerencia, uni: uni]
    }

    /**
     * Acción que muestra el pdf de la solicitud de reforma a nueva actividad
     */
    def actividad() {
        def reforma = Reforma.get(params.id.toString().toLong())

        def uni = firmasService.requirentes(reforma.persona.unidad)


        return [reforma: reforma, det: generaDetallesSolicitudActividad(reforma).det, unidades: reforma.persona.unidad.unidadYGerencia, uni: uni]
    }

    /**
     * Acción que muestra el pdf de la solicitud de reforma de incremento a nueva actividad
     */
    def incrementoActividad() {
        def reforma = Reforma.get(params.id.toString().toLong())
        def d = generaDetallesSolicitudIncrementoActividad(reforma)

       def uni = firmasService.requirentes(reforma.persona.unidad)

        return [reforma: reforma, det: d.det2, det2: d.det, unidades: reforma.persona.unidad.unidadYGerencia, uni: uni]
    }

    /**
     * Acción que muestra el pdf de la solicitud de reforma a nuevas partidas
     */
    def partida() {
        def reforma = Reforma.get(params.id.toString().toLong())
        def det
        if (reforma.tipo == "C") {
            det = ReportesReformaCorrientesController.generaDetallesSolicitudPartida(reforma).det
        } else {
            det = generaDetallesSolicitudPartida(reforma).det
        }

        def uni = firmasService.requirentes(reforma.persona.unidad)

        return [reforma: reforma, det: det, unidades: reforma.persona.unidad.unidadYGerencia, uni: uni]
    }

    /**
     * Acción que muestra el pdf de la solicitud de reforma de incremento
     */
    def incremento() {
        def reforma = Reforma.get(params.id.toString().toLong())
        def d = generaDetallesSolicitudIncremento(reforma)

        def uni = firmasService.requirentes(reforma.persona.unidad)

        return [reforma: reforma, det: d.det2, det2: d.det, unidades: reforma.persona.unidad.unidadYGerencia, uni: uni]
    }

    /**
     * Acción que muestra el pdf de la solicitud de reforma de modificacion de techos
     */
    def techo() {
        def reforma = Reforma.get(params.id.toString().toLong())

        def uni = firmasService.requirentes(reforma.persona.unidad)

        return [reforma: reforma, det: generaDetallesSolicitudTecho(reforma).det, unidades: reforma.persona.unidad.unidadYGerencia, uni: uni]
    }

    /**
     * Acción que muestra el pdf de previsualización de reforma existente
     */
    def existentePreviewReforma() {
        def reforma = Reforma.get(params.id.toString().toLong())
//        println reforma.nota
//        println reforma.nota.encodeAsHTML()
//        println reforma.nota.decodeHTML()
        return [reforma: reforma, det: generaDetallesSolicitudExistente(reforma).det, unidades: reforma.persona.unidad.unidadYGerencia]
    }

    /**
     * Acción que muestra el pdf de previsualización de reforma de a nueva actividad
     */
    def actividadPreviewReforma() {
        def reforma = Reforma.get(params.id.toString().toLong())
        return [reforma: reforma, det: generaDetallesSolicitudActividad(reforma).det, unidades: reforma.persona.unidad.unidadYGerencia]
    }

    /**
     * Acción que muestra el pdf de previsualización de reforma de incremento a nuevas actividades
     */
    def incrementoActividadPreviewReforma() {
        def reforma = Reforma.get(params.id.toString().toLong())
        def d = generaDetallesSolicitudIncrementoActividad(reforma)
        return [reforma: reforma, det: d.det, unidades: reforma.persona.unidad.unidadYGerencia]
    }

    /**
     * Acción que muestra el pdf de previsualización de reforma a nuevas partidas
     */
    def partidaPreviewReforma() {
//        println "partidaPreviewReforma params: $params"
        def reforma = Reforma.get(params.id.toString().toLong())
//        println "..reforma: $reforma"
//        println "..det: ${generaDetallesSolicitudPartida(reforma).det}"
//        println "..unidades: ${reforma.persona.unidad.unidadYGerencia}"
        return [reforma: reforma, det: generaDetallesSolicitudPartida(reforma).det, unidades: reforma.persona.unidad.unidadYGerencia]
    }

    /**
     * Acción que muestra el pdf de previsualización de reforma de incremento
     */
    def incrementoPreviewReforma() {
        def reforma = Reforma.get(params.id.toString().toLong())
        def d = generaDetallesSolicitudIncremento(reforma)
        return [reforma: reforma, det: d.det, unidades: reforma.persona.unidad.unidadYGerencia]
    }

    /**
     * Acción que muestra el pdf de reforma existente
     */
    def existenteReforma() {
        def reforma = Reforma.get(params.id.toString().toLong())
        def det
        if (reforma.tipo == "C") {
            det = ReportesReformaCorrientesController.generaDetallesReforma_function(reforma)
        } else {
            det = generaDetallesReforma_function(reforma)
        }
        return [reforma: reforma, det: det, unidades: reforma.persona.unidad.unidadYGerencia]
    }

    /**
     * Acción que muestra el pdf de reforma a nuevas partidas
     */
    def partidaReforma() {
        def reforma = Reforma.get(params.id.toString().toLong())
        def det
        if (reforma.tipo == "C") {
            det = ReportesReformaCorrientesController.generaDetallesReforma_function(reforma)
        } else {
            det = generaDetallesReforma_function(reforma)
        }
        return [reforma: reforma, det: det, unidades: reforma.persona.unidad.unidadYGerencia]
    }

    /**
     * Acción que muestra el pdf de reforma a nuevas actividades
     */
    def actividadReforma() {
        def reforma = Reforma.get(params.id.toString().toLong())
        return [reforma: reforma, det: generaDetallesReforma_function(reforma), unidades: reforma.persona.unidad.unidadYGerencia]
    }

    /**
     * Acción que muestra el pdf de reforma de incremento a nuevas actividades
     */
    def incrementoActividadReforma() {
        def reforma = Reforma.get(params.id.toString().toLong())
        return [reforma: reforma, det: generaDetallesReforma_function(reforma), unidades: reforma.persona.unidad.unidadYGerencia]
    }

    /**
     * Acción que muestra el pdf de reforma de incremento
     */
    def incrementoReforma() {
        def reforma = Reforma.get(params.id.toString().toLong())
        return [reforma: reforma, det: generaDetallesReforma_function(reforma), unidades: reforma.persona.unidad.unidadYGerencia]
    }

    /**
     * Acción que muestra el pdf de reforma de modificación de techos
     */
    def techoReforma() {
        def reforma = Reforma.get(params.id.toString().toLong())
        return [reforma: reforma, det: generaDetallesReforma_function(reforma), unidades: reforma.persona.unidad.unidadYGerencia]
    }

    public static Map generaDetallesReforma_function(Reforma reforma) {
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
//                det[key].desde.responsable = modificacion.desde.marcoLogico.responsable.gerencia.codigo
                det[key].desde.responsable = modificacion.desde.marcoLogico.responsable.codigo  //responsable celeste

//                det[key].desde.partida = modificacion.desde.toString()
//                det[key].desde.partida = "<strong>Priorizado:</strong> " + modificacion.desde.priorizado +
//                        " <strong>Partida:</strong> ${modificacion.desde.presupuesto.numero}"
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

                m.proyecto = modificacion.recibe.marcoLogico.proyecto.toStringCompleto()
                m.componente = modificacion.recibe.marcoLogico.marcoLogico.toStringCompleto()
                m.no = modificacion.recibe.marcoLogico.numero
                m.actividad = modificacion.recibe.marcoLogico.toStringCompleto()
//                m.responsable = modificacion.recibe.marcoLogico.responsable.gerencia.codigo
                m.responsable = modificacion.recibe.marcoLogico.responsable.codigo  //responsable celeste
//            m.partida = modificacion.recibe.toString()
//                m.partida = "<strong>Priorizado:</strong> " + modificacion.recibe.priorizado +
//                        " <strong>Partida:</strong> ${modificacion.recibe.presupuesto.numero}"
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
                det[key].desde.proyecto = detalle.asignacionOrigen.marcoLogico.proyecto.toStringCompleto()
                det[key].desde.componente = detalle.asignacionOrigen.marcoLogico.marcoLogico.toStringCompleto()
                det[key].desde.no = detalle.asignacionOrigen.marcoLogico.numero
                det[key].desde.actividad = detalle.asignacionOrigen.marcoLogico.toStringCompleto()
//                det[key].desde.responsable = detalle.asignacionOrigen.marcoLogico.responsable.gerencia.codigo
                det[key].desde.responsable = detalle.asignacionOrigen.marcoLogico.responsable.codigo  //responsable celeste
//                det[key].desde.responsable = proyectosService.getUnidadYGerencia(detalle.asignacionOrigen.marcoLogico.responsable).gerencia.codigo
//                det[key].desde.partida = detalle.asignacionOrigen.toString()
//                det[key].desde.partida = "<strong>Priorizado:</strong> " + detalle.asignacionOrigen.priorizado +
//                        " <strong>Partida:</strong> ${detalle.asignacionOrigen.presupuesto.numero}"
                det[key].desde.partida = detalle.asignacionOrigen.presupuesto.numero
//                det[key].desde.inicial = detalle.asignacionOrigen.priorizado
                det[key].desde.inicial = detalle.valorOrigenInicial
                det[key].desde.dism = 0
                det[key].desde.aum = 0
//                det[key].desde.final = detalle.asignacionOrigen.priorizado
                det[key].desde.final = detalle.valorOrigenInicial

                det[key].hasta = []
            }
            det[key].desde.dism += detalle.valor
            det[key].desde.final -= detalle.valor

            if (!valorFinalDestino[keyDestino]) {
//                valorFinalDestino[keyDestino] = detalle.asignacionDestino.priorizado
                valorFinalDestino[keyDestino] = detalle.valorDestinoInicial
            }

            def m = [:]

            m.id = detalle.id
            m.proyecto = detalle.asignacionDestino.marcoLogico.proyecto.toStringCompleto()
            m.componente = detalle.asignacionDestino.marcoLogico.marcoLogico.toStringCompleto()
            m.no = detalle.asignacionDestino.marcoLogico.numero
            m.actividad = detalle.asignacionDestino.marcoLogico.toStringCompleto()
//            m.responsable = detalle.asignacionDestino.marcoLogico.responsable.gerencia.codigo
            m.responsable = detalle.asignacionDestino.marcoLogico.responsable.codigo  //responsable celeste
//            m.responsable = proyectosService.getUnidadYGerencia(detalle.asignacionDestino.marcoLogico.responsable).gerencia.codigo
//            m.partida = detalle.asignacionDestino.toString()
//            m.partida = "<strong>Priorizado:</strong> " + detalle.asignacionDestino.priorizado +
//                    " <strong>Partida:</strong> ${detalle.asignacionDestino.presupuesto.numero}"
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

    public static Map generaDetallesSolicitudActividad(Reforma reforma) {
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
                det[key].desde.proyecto = detalle.asignacionOrigen.marcoLogico.proyecto.toStringCompleto()
                det[key].desde.componente = detalle.asignacionOrigen.marcoLogico.marcoLogico.toStringCompleto()
                det[key].desde.no = detalle.asignacionOrigen.marcoLogico.numero
                det[key].desde.actividad = detalle.asignacionOrigen.marcoLogico.toStringCompleto()
//                det[key].desde.responsable = detalle.asignacionOrigen.marcoLogico.responsable.gerencia.codigo
                det[key].desde.responsable = detalle.asignacionOrigen.marcoLogico.responsable.codigo  //responsable celeste
//                det[key].desde.responsable = detalle.asignacionOrigen.marcoLogico.responsable.gerencia.codigo
//                det[key].desde.responsable = proyectosService.getUnidadYGerencia(detalle.asignacionOrigen.marcoLogico.responsable).gerencia.codigo
//                det[key].desde.partida = detalle.asignacionOrigen.toString()
//                det[key].desde.partida = "<strong>Priorizado:</strong> " + detalle.asignacionOrigen.priorizado +
//                        " <strong>Partida:</strong> ${detalle.asignacionOrigen.presupuesto.numero}"
                det[key].desde.partida = detalle.asignacionOrigen.presupuesto.numero
//                det[key].desde.inicial = detalle.asignacionOrigen.priorizado
                det[key].desde.inicial = detalle.valorOrigenInicial
                det[key].desde.dism = 0
                det[key].desde.aum = 0
//                det[key].desde.final = detalle.asignacionOrigen.priorizado
                det[key].desde.final = detalle.valorOrigenInicial

                det[key].hasta = []
            }
            det[key].desde.dism += detalle.valor
            det[key].desde.final -= detalle.valor

            if (!valorFinalDestino[keyDestino]) {
                valorFinalDestino[keyDestino] = 0
            }

            def m = [:]

            m.id = detalle.id
            m.proyecto = detalle.componente.proyecto.toStringCompleto()
            m.componente = detalle.componente.toStringCompleto()
            m.no = "Nueva"
            m.actividad = detalle.descripcionNuevaActividad
//            m.responsable = detalle.reforma.persona.unidad.gerencia.codigo
            m.responsable = requirentesUnej(detalle.reforma.persona.unidad.id)
//            m.partida = "<strong>Priorizado:</strong> ${detalle.valor}" +
//                    " <strong>Partida:</strong> ${detalle.presupuesto.numero}"
            m.partida = detalle.presupuesto.numero
            m.inicial = 0
            m.dism = 0
            m.aum = detalle.valor
            m.final = valorFinalDestino[keyDestino] + detalle.valor
            m.mrlg = detalle.componente.id

            det[key].hasta += m

            valorFinalDestino[keyDestino] = m.final
        }
        return [det: det, det2: [:], total: total]
    }

    public static Map generaDetallesSolicitudIncrementoActividad(Reforma reforma) {
        def detalles = DetalleReforma.findAllByReformaAndAsignacionOrigenIsNotNull(reforma, [sort: "asignacionOrigen"])
        def detalles2 = DetalleReforma.findAllByReformaAndAsignacionOrigenIsNull(reforma, [sort: "descripcionNuevaActividad"])
        def valorFinalDestino = [:]
        def det = [:], det2 = [:]
        def detallado = [:]
        def total = 0, totalSaldo = 0
        detalles2.eachWithIndex { detalle, i ->
            totalSaldo += detalle.saldo
            def key = "" + i
            def keyDestino = "" + detalle.asignacionDestinoId
            if (!det2[key]) {
                det2[key] = [:]
                det2[key].desde = [:]
                det2[key].desde.proyecto = false
                det2[key].desde.inicial = 0
                det2[key].desde.dism = 0
                det2[key].desde.aum = 0
                det2[key].desde.final = 0
                det2[key].hasta = []
            }
            if (!valorFinalDestino[keyDestino]) {
                valorFinalDestino[keyDestino] = 0
            }

            def m = [:]

            m.id = detalle.id
            m.asignacion = detalle.descripcionNuevaActividad
            m.proyecto = detalle.componente.proyecto.toStringCompleto()
            m.componente = detalle.componente.toStringCompleto()
            m.no = "Nueva"
            m.actividad = detalle.descripcionNuevaActividad
//            m.responsable = detalle.reforma.persona.unidad.gerencia.codigo
            m.responsable = requirentesUnej(detalle.reforma.persona.unidad.id)
//            m.responsable = proyectosService.getUnidadYGerencia(detalle.reforma.persona.unidad).gerencia.codigo
//            m.partida = "<strong>Priorizado:</strong> ${detalle.valor}\n" +
//                    " <strong>Partida:</strong> ${detalle.presupuesto}"
            m.partida = detalle.presupuesto
            m.inicial = 0
            m.dism = 0
            m.aum = detalle.valor
            m.saldo = Math.round(detalle.saldo *100)/100
            m.final = valorFinalDestino[keyDestino] + detalle.valor
            m.mrlg = detalle.componente.id

            det2[key].hasta += m

            valorFinalDestino[keyDestino] = m.final
        }

        valorFinalDestino = [:]
        def valorFinalOrigen = [:]
        detalles.eachWithIndex { detalle, i ->
            total += detalle.valor
            def key = "" + detalle.asignacionOrigenId
            def keyDestino = "" + detalle.descripcionNuevaActividad
            def keyDetallado = "" + i
            if (!det[key]) {
                det[key] = [:]
                det[key].desde = [:]
                det[key].desde.id = detalle.id
                det[key].desde.proyecto = detalle.asignacionOrigen.marcoLogico.proyecto.toStringCompleto()
                det[key].desde.componente = detalle.asignacionOrigen.marcoLogico.marcoLogico.toStringCompleto()
                det[key].desde.no = detalle.asignacionOrigen.marcoLogico.numero
                det[key].desde.actividad = detalle.asignacionOrigen.marcoLogico.toStringCompleto()
//                det[key].desde.responsable = detalle.asignacionOrigen.marcoLogico.responsable.gerencia.codigo
                det[key].desde.responsable = detalle.asignacionOrigen.marcoLogico.responsable.codigo   //responsable celeste
//                det[key].desde.responsable = proyectosService.getUnidadYGerencia(detalle.asignacionOrigen.marcoLogico.responsable).gerencia.codigo
//                det[key].desde.partida = detalle.asignacionOrigen.toString()
//                det[key].desde.partida = "<strong>Priorizado:</strong> " + detalle.asignacionOrigen.priorizado +
//                        " <strong>Partida:</strong> ${detalle.asignacionOrigen.presupuesto.numero}"
                det[key].desde.partida = detalle.asignacionOrigen.presupuesto.numero
//                det[key].desde.inicial = detalle.asignacionOrigen.priorizado
                det[key].desde.inicial = detalle.valorOrigenInicial
                det[key].desde.dism = 0
                det[key].desde.aum = 0
//                det[key].desde.final = detalle.asignacionOrigen.priorizado
                det[key].desde.final = detalle.valorOrigenInicial

                det[key].hasta = []
            }
            det[key].desde.dism += detalle.valor
            det[key].desde.final -= detalle.valor

            if (!valorFinalOrigen[key]) {
//                valorFinalOrigen[key] = detalle.asignacionOrigen.priorizado
                valorFinalOrigen[key] = detalle.valorOrigenInicial
            }

            if (!detallado[keyDetallado]) {
                detallado[keyDetallado] = [:]
                detallado[keyDetallado].desde = [:]
                detallado[keyDetallado].desde.id = detalle.id
                detallado[keyDetallado].desde.asignacion = detalle.asignacionOrigenId
                detallado[keyDetallado].desde.proyecto = detalle.asignacionOrigen.marcoLogico.proyecto.toStringCompleto()
                detallado[keyDetallado].desde.componente = detalle.asignacionOrigen.marcoLogico.marcoLogico.toStringCompleto()
                detallado[keyDetallado].desde.no = detalle.asignacionOrigen.marcoLogico.numero
                detallado[keyDetallado].desde.actividad = detalle.asignacionOrigen.marcoLogico.toStringCompleto()
//                detallado[keyDetallado].desde.responsable = detalle.asignacionOrigen.marcoLogico.responsable.gerencia.codigo
                detallado[keyDetallado].desde.responsable = detalle.asignacionOrigen.marcoLogico.responsable.codigo //responsable celeste
//                detallado[keyDetallado].desde.responsable = proyectosService.getUnidadYGerencia(detalle.asignacionOrigen.marcoLogico.responsable).gerencia.codigo
//                detallado[keyDetallado].desde.partida = detalle.asignacionOrigen.toString()
//                det[key].desde.partida = "<strong>Priorizado:</strong> " + detalle.asignacionOrigen.priorizado +
//                        " <strong>Partida:</strong> ${detalle.asignacionOrigen.presupuesto.numero}"
                detallado[keyDetallado].desde.partida = detalle.asignacionOrigen.presupuesto.numero
                detallado[keyDetallado].desde.inicial = valorFinalOrigen[key]
                valorFinalOrigen[key] -= detalle.valor
                detallado[keyDetallado].desde.dism = detalle.valor
                detallado[keyDetallado].desde.aum = 0
                detallado[keyDetallado].desde.final = valorFinalOrigen[key]
                detallado[keyDetallado].hasta = []
            }

            if (!valorFinalDestino[keyDestino]) {
                valorFinalDestino[keyDestino] = 0
            }

            def m = [:]

            m.id = detalle.id
            m.asignacion = detalle.descripcionNuevaActividad
            m.proyecto = detalle.componente.proyecto.toStringCompleto()
            m.componente = detalle.componente.toStringCompleto()
            m.no = "Nueva"
            m.actividad = detalle.descripcionNuevaActividad
//            m.responsable = detalle.reforma.persona.unidad.gerencia
            m.responsable = requirentesUnej(detalle.reforma.persona.unidad.id)
//            m.responsable = proyectosService.getUnidadYGerencia(detalle.reforma.persona.unidad).gerencia.codigo
//            m.partida = "<strong>Priorizado:</strong> " + detalle.valor +
//                    " <strong>Partida:</strong> ${detalle.presupuesto}\n"
            m.partida = detalle.presupuesto.numero
            m.inicial = valorFinalDestino[keyDestino]

            m.dism = 0
            m.aum = detalle.valor
            m.saldo = Math.round(detalle.saldo *100)/100
            m.final = valorFinalDestino[keyDestino] + detalle.valor
            m.mrlg = detalle.componente.id

            det[key].hasta += m
            detallado[keyDetallado].hasta += m

            valorFinalDestino[keyDestino] = m.final
        }
        return [det: det, det2: det2, detallado: detallado, total: total, saldo: totalSaldo]
    }

    public static Map generaDetallesSolicitudPartida(Reforma reforma) {
        def detalles = DetalleReforma.findAllByReforma(reforma, [sort: "asignacionOrigen"])
        def valorFinalDestino = [:]
        def det = [:]
        def total = 0
//        println "Map... 1"
        detalles.each { detalle ->
            total += detalle.valor
            def key = "" + detalle.asignacionOrigenId
            def keyDestino = "" + detalle.asignacionDestinoId
//            println "Map... 2"

            if (!det[key]) {
                det[key] = [:]
                det[key].desde = [:]
                det[key].desde.id = detalle.id
                det[key].desde.proyecto = detalle.asignacionOrigen.marcoLogico.proyecto.toStringCompleto()
                det[key].desde.componente = detalle.asignacionOrigen.marcoLogico.marcoLogico.toStringCompleto()
                det[key].desde.no = detalle.asignacionOrigen.marcoLogico.numero
                det[key].desde.actividad = detalle.asignacionOrigen.marcoLogico.toStringCompleto()
//                det[key].desde.responsable = detalle.asignacionOrigen.marcoLogico.responsable.gerencia.codigo
                det[key].desde.responsable = detalle.asignacionOrigen.marcoLogico.responsable.codigo //responsable celeste
//                det[key].desde.responsable = proyectosService.getUnidadYGerencia(detalle.asignacionOrigen.marcoLogico.responsable).gerencia.codigo
//                det[key].desde.partida = detalle.asignacionOrigen.toString()
//                det[key].desde.partida = "<strong>Priorizado:</strong> " + detalle.asignacionOrigen.priorizado +
//                        " <strong>Partida:</strong> ${detalle.asignacionOrigen.presupuesto.numero}"
                det[key].desde.partida = detalle.asignacionOrigen.presupuesto.numero
                det[key].desde.inicial = detalle.asignacionOrigen.priorizado
                det[key].desde.dism = 0
                det[key].desde.aum = 0
//                det[key].desde.final = detalle.asignacionOrigen.priorizado
                det[key].desde.final = detalle.valorOrigenInicial

                det[key].hasta = []
            }
//            println "Map... 3"

            det[key].desde.dism += detalle.valor
            det[key].desde.final -= detalle.valor

            if (!valorFinalDestino[keyDestino]) {
                valorFinalDestino[keyDestino] = detalle.valor
            }

            def m = [:]

            m.id = detalle.id
            m.proyecto = detalle.asignacionOrigen.marcoLogico.proyecto.toStringCompleto()
            m.componente = detalle.asignacionOrigen.marcoLogico.marcoLogico.toStringCompleto()
            m.no = detalle.asignacionOrigen.marcoLogico.numero
            m.actividad = detalle.asignacionOrigen.marcoLogico.toStringCompleto()
//            m.responsable = detalle.asignacionOrigen.marcoLogico.responsable.gerencia.codigo
            m.responsable = detalle.asignacionOrigen.marcoLogico.responsable.codigo  //responsable celeste
//            m.responsable = proyectosService.getUnidadYGerencia(detalle.asignacionOrigen.marcoLogico.responsable).gerencia.codigo
//            m.partida = "<strong>Priorizado:</strong> 0.00\n" +
//                    " <strong>Partida:</strong> ${detalle.presupuesto.numero}\n"
            m.partida = detalle.presupuesto.numero

            m.dism = 0
            m.aum = detalle.valor

//            println "generaDetallesSolicitudPartida: valor: ${detalle.valor}, final: ${valorFinalDestino[keyDestino]}"
//            println "Map... 4"

            if(reforma.tipoSolicitud == "P") { //si se trata de partidas, el origen inicla es 0
                m.inicial = 0
                m.final = detalle.valor
            } else {
                m.inicial = valorFinalDestino[keyDestino]
                m.final = valorFinalDestino[keyDestino] + detalle.valor
            }


            det[key].hasta += m

            valorFinalDestino[keyDestino] = m.final
        }
        return [det: det, det2: [:], total: total]
    }

    public static Map generaDetallesSolicitudIncremento(Reforma reforma) {
        def detalles = DetalleReforma.findAllByReformaAndAsignacionOrigenIsNotNull(reforma, [sort: "asignacionOrigen"])
        def detalles2 = DetalleReforma.findAllByReformaAndAsignacionOrigenIsNull(reforma, [sort: "asignacionDestino"])

        def valorFinalDestino = [:]

        def det = [:], det2 = [:]
        def detallado = [:]
        def total = 0, totalSaldo = 0
        detalles2.eachWithIndex { detalle, i ->
            totalSaldo += detalle.saldo
            def key = "" + i
            def keyDestino = "" + detalle.asignacionDestinoId
            if (!det2[key]) {
                det2[key] = [:]
                det2[key].desde = [:]
                det2[key].desde.proyecto = false
                det2[key].desde.inicial = 0
                det2[key].desde.dism = 0
                det2[key].desde.aum = 0
                det2[key].desde.final = 0
                det2[key].hasta = []
            }
            if (!valorFinalDestino[keyDestino]) {
//                valorFinalDestino[keyDestino] = detalle.asignacionDestino.priorizado
                valorFinalDestino[keyDestino] = detalle.valorDestinoInicial
            }

            def m = [:]

            m.id = detalle.id
            m.asignacion = detalle.asignacionDestinoId
            m.proyecto = detalle.asignacionDestino.marcoLogico.proyecto.toStringCompleto()
            m.componente = detalle.asignacionDestino.marcoLogico.marcoLogico.toStringCompleto()
            m.no = detalle.asignacionDestino.marcoLogico.numero
            m.actividad = detalle.asignacionDestino.marcoLogico.toStringCompleto()
//            m.responsable = detalle.asignacionDestino.marcoLogico.responsable.gerencia.codigo
            m.responsable = detalle.asignacionDestino.marcoLogico.responsable.codigo  //responsable celeste
//            m.responsable = proyectosService.getUnidadYGerencia(detalle.asignacionDestino.marcoLogico.responsable).gerencia.codigo
//            m.partida = detalle.asignacionDestino.toString()
//            m.partida = "<strong>Priorizado:</strong> " + detalle.asignacionDestino.priorizado +
//                    " <strong>Partida:</strong> ${detalle.asignacionDestino.presupuesto.numero}"
            m.partida = detalle.asignacionDestino.presupuesto.numero
            m.inicial = valorFinalDestino[keyDestino]
            m.dism = 0
            m.saldo = Math.round(detalle.saldo *100)/100
            m.aum = detalle.valor
            m.final = valorFinalDestino[keyDestino] + detalle.valor

            det2[key].hasta += m

            valorFinalDestino[keyDestino] = m.final
        }
        valorFinalDestino = [:]
        def valorFinalOrigen = [:]
        detalles.eachWithIndex { detalle, i ->
            total += detalle.valor
            def key = "" + detalle.asignacionOrigenId
            def keyDestino = "" + detalle.asignacionDestinoId
            def keyDetallado = "" + i
            if (!det[key]) {
                det[key] = [:]
                det[key].desde = [:]
                det[key].desde.proyecto = detalle.asignacionOrigen.marcoLogico.proyecto.toStringCompleto()
                det[key].desde.componente = detalle.asignacionOrigen.marcoLogico.marcoLogico.toStringCompleto()
                det[key].desde.no = detalle.asignacionOrigen.marcoLogico.numero
                det[key].desde.actividad = detalle.asignacionOrigen.marcoLogico.toStringCompleto()
//                det[key].desde.responsable = detalle.asignacionOrigen.marcoLogico.responsable.gerencia.codigo
                det[key].desde.responsable = detalle.asignacionOrigen.marcoLogico.responsable.codigo  //responsable celeste
//                det[key].desde.responsable = proyectosService.getUnidadYGerencia(detalle.asignacionOrigen.marcoLogico.responsable).gerencia.codigo
//                det[key].desde.partida = detalle.asignacionOrigen.toString()
//                det[key].desde.partida = "<strong>Priorizado:</strong> " + detalle.asignacionOrigen.priorizado +
//                        " <strong>Partida:</strong> ${detalle.asignacionOrigen.presupuesto.numero}"
                det[key].desde.partida = detalle.asignacionOrigen.presupuesto.numero
//                det[key].desde.inicial = detalle.asignacionOrigen.priorizado
                det[key].desde.inicial = detalle.valorOrigenInicial
                det[key].desde.dism = 0
                det[key].desde.aum = 0
//                det[key].desde.final = detalle.asignacionOrigen.priorizado
                det[key].desde.final = detalle.valorOrigenInicial

                det[key].hasta = []
            }
            det[key].desde.dism += detalle.valor
            det[key].desde.final -= detalle.valor

            if (!valorFinalOrigen[key]) {
//                valorFinalOrigen[key] = detalle.asignacionOrigen.priorizado
                valorFinalOrigen[key] = detalle.valorOrigenInicial
            }

            if (!detallado[keyDetallado]) {
                detallado[keyDetallado] = [:]
                detallado[keyDetallado].desde = [:]
                detallado[keyDetallado].desde.id = detalle.id
                detallado[keyDetallado].desde.asignacion = detalle.asignacionOrigenId
                detallado[keyDetallado].desde.proyecto = detalle.asignacionOrigen.marcoLogico.proyecto.toStringCompleto()
                detallado[keyDetallado].desde.componente = detalle.asignacionOrigen.marcoLogico.marcoLogico.toStringCompleto()
                detallado[keyDetallado].desde.no = detalle.asignacionOrigen.marcoLogico.numero
                detallado[keyDetallado].desde.actividad = detalle.asignacionOrigen.marcoLogico.toStringCompleto()
//                detallado[keyDetallado].desde.responsable = detalle.asignacionOrigen.marcoLogico.responsable.gerencia.codigo
                detallado[keyDetallado].desde.responsable = detalle.asignacionOrigen.marcoLogico.responsable.codigo   //responsable celeste
//                detallado[keyDetallado].desde.responsable = proyectosService.getUnidadYGerencia(detalle.asignacionOrigen.marcoLogico.responsable).gerencia.codigo
//                detallado[keyDetallado].desde.partida = detalle.asignacionOrigen.toString()
//                det[key].desde.partida = "<strong>Priorizado:</strong> " + detalle.asignacionOrigen.priorizado +
//                        " <strong>Partida:</strong> ${detalle.asignacionOrigen.presupuesto.numero}"
                detallado[keyDetallado].desde.partida = detalle.asignacionOrigen.presupuesto.numero
                detallado[keyDetallado].desde.inicial = valorFinalOrigen[key]
                valorFinalOrigen[key] -= detalle.valor
                detallado[keyDetallado].desde.dism = detalle.valor
                detallado[keyDetallado].desde.aum = 0
                detallado[keyDetallado].desde.final = valorFinalOrigen[key]
                detallado[keyDetallado].hasta = []
            }

            if (!valorFinalDestino[keyDestino]) {
//                valorFinalDestino[keyDestino] = detalle.asignacionDestino.priorizado
                valorFinalDestino[keyDestino] = detalle.valorDestinoInicial
            }

            def m = [:]

            m.id = detalle.id
            m.asignacion = detalle.asignacionDestinoId
            m.proyecto = detalle.asignacionDestino.marcoLogico.proyecto.toStringCompleto()
            m.componente = detalle.asignacionDestino.marcoLogico.marcoLogico.toStringCompleto()
            m.no = detalle.asignacionDestino.marcoLogico.numero
            m.actividad = detalle.asignacionDestino.marcoLogico.toStringCompleto()
//            m.responsable = detalle.asignacionDestino.marcoLogico.responsable.gerencia.codigo
            m.responsable = detalle.asignacionDestino.marcoLogico.responsable.codigo  //responsable celeste
//            m.responsable = proyectosService.getUnidadYGerencia(detalle.asignacionDestino.marcoLogico.responsable).gerencia.codigo
//            m.partida = detalle.asignacionDestino.toString()
//            m.partida = "<strong>Priorizado:</strong> " + detalle.asignacionDestino.priorizado +
//                    " <strong>Partida:</strong> ${detalle.asignacionDestino.presupuesto.numero}"
            m.partida = detalle.asignacionDestino.presupuesto.numero
            m.inicial = valorFinalDestino[keyDestino]
            m.dism = 0
            m.aum = detalle.valor
            m.final = valorFinalDestino[keyDestino] + detalle.valor

            det[key].hasta += m
            detallado[keyDetallado].hasta += m

            valorFinalDestino[keyDestino] = m.final
        }
        return [det: det, det2: det2, detallado: detallado, total: total, saldo: totalSaldo]
    }

    public static Map generaDetallesSolicitudTecho(Reforma reforma) {
        def detalles = DetalleReforma.findAllByReforma(reforma, [sort: "asignacionOrigen"])
        def det = [:]
        def total = 0
        detalles.each { detalle ->
            total += detalle.valor
            def key = ""
            if (detalle.asignacionOrigen) {
                key += detalle.asignacionOrigenId
                if (!det[key]) {
                    det[key] = [:]
                    det[key].desde = [:]
                    det[key].desde.id = detalle.id
                    det[key].desde.proyecto = detalle.asignacionOrigen.marcoLogico.proyecto.toStringCompleto()
                    det[key].desde.componente = detalle.asignacionOrigen.marcoLogico.marcoLogico.toStringCompleto()
                    det[key].desde.no = detalle.asignacionOrigen.marcoLogico.numero
                    det[key].desde.actividad = detalle.asignacionOrigen.marcoLogico.toStringCompleto()
//                    det[key].desde.responsable = detalle.asignacionOrigen.marcoLogico.responsable.gerencia.codigo
                    det[key].desde.responsable = detalle.asignacionOrigen.marcoLogico.responsable.codigo  //responsable celeste
//                    det[key].desde.responsable = proyectosService.getUnidadYGerencia(detalle.asignacionOrigen.marcoLogico.responsable).gerencia.codigo
//                det[key].desde.partida = detalle.asignacionOrigen.toString()
//                    det[key].desde.partida = "<strong>Priorizado:</strong> " + detalle.asignacionOrigen.priorizado +
//                            " <strong>Partida:</strong> ${detalle.asignacionOrigen.presupuesto.numero}"
                    det[key].desde.partida = detalle.asignacionOrigen.presupuesto.numero
//                    det[key].desde.inicial = detalle.asignacionOrigen.priorizado
                    det[key].desde.inicial = detalle.valorOrigenInicial
                    det[key].desde.dism = 0
                    det[key].desde.aum = 0
//                    det[key].desde.final = detalle.asignacionOrigen.priorizado
                    det[key].desde.final = detalle.valorOrigenInicial

                    det[key].hasta = []
                }
            } else {
                key += detalle.presupuestoId
                if (!det[key]) {
                    det[key] = [:]
                    det[key].desde = [:]
                    det[key].desde.id = detalle.id
                    det[key].desde.proyecto = detalle.componente.proyecto.toStringCompleto()
                    det[key].desde.componente = detalle.componente.marcoLogico.toStringCompleto()
                    det[key].desde.no = detalle.componente.numero
                    det[key].desde.actividad = detalle.componente.toStringCompleto()
                    det[key].desde.responsable = detalle.reforma.persona.unidad.gerencia
//                    det[key].desde.responsable = proyectosService.getUnidadYGerencia(detalle.reforma.persona.unidad).gerencia.codigo
//                det[key].desde.partida = detalle.asignacionOrigen.toString()
//                    det[key].desde.partida = "<strong>Priorizado:</strong> 0.00" +
//                            " <strong>Partida:</strong> ${detalle.presupuesto.numero}"
                    det[key].desde.partida = detalle.presupuesto.numero
                    det[key].desde.inicial = 0
                    det[key].desde.dism = 0
                    det[key].desde.aum = 0
                    det[key].desde.final = 0

                    det[key].hasta = []
                }
            }

            if (detalle.valor < 0) {
                det[key].desde.dism += detalle.valor * -1
                det[key].desde.final -= detalle.valor * -1
            } else {
                det[key].desde.aum += detalle.valor
                det[key].desde.final += detalle.valor
            }
        }
        return [det: det, det2: [:], total: total]
    }

    static String requirentesUnej(id) {
        def requirentes = []
        def general = UnidadEjecutora.findByCodigo('9999')
        def tecnica = UnidadEjecutora.findByCodigo('GT')
        def administrativaFinan = UnidadEjecutora.findByCodigo('GAF')
        def planificacion = UnidadEjecutora.findByCodigo('GPE')
        def juridica = UnidadEjecutora.findByCodigo('GJ')
        def gerencias = UnidadEjecutora.findAllByPadreAndNombreIlike(tecnica, 'gerenc%', [sort: 'nombre'])
        def direcciones = UnidadEjecutora.findAllByPadreAndNombreIlike(general, 'direcc%', [sort: 'nombre'])
        def unej = UnidadEjecutora.get(id)
        requirentes = gerencias + direcciones + administrativaFinan + juridica + planificacion
        def un = unej
        while(un != null) {
            if(requirentes.find { it.id == un.id }) {
                return un.codigo.toString()
            }
            un = un.padre
        }
        return null
    }
}
