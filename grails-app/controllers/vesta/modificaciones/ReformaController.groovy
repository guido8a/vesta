package vesta.modificaciones

import vesta.alertas.Alerta
import vesta.avales.EstadoAval
import vesta.parametros.UnidadEjecutora
import vesta.parametros.poaPac.Anio
import vesta.poa.Asignacion
import vesta.proyectos.Proyecto
import vesta.seguridad.Firma
import vesta.seguridad.Persona
import vesta.seguridad.Shield


/**
 * Controlador que muestra las pantallas de manejo de Reforma
 */
class ReformaController extends Shield {

    /**
     * Acción que muestra los diferentes tipos de reforma posibles y permite seleccionar uno para comenzar el proceso
     */
    def reformas() {

    }

    /**
     * Acción que muestra la lista de todas las reformas, con su estado y una opción para ver el pdf
     */
    def lista() {
        def reformas = Reforma.list([sort: "fecha", order: "desc"])
        return [reformas: reformas]
    }

    /**
     * Acción que muestra la lista de las reformas solicitadas para q un analista de planificación apruebe y pida firmas o niegue
     */
    def pendientes() {
        def estadoSolicitado = EstadoAval.findByCodigo("E01")
        def reformas = Reforma.findAllByTipoAndEstado("R", estadoSolicitado, [sort: "fecha", order: "desc"])
        return [reformas: reformas]
    }

    /**
     * Acción para que el analista de planificación apruebe y pida firmas o niegue la solicitud
     */
    def procesar() {
        def reforma = Reforma.get(params.id)
        def detalles = DetalleReforma.findAllByReforma(reforma)
        def total = 0
        if (detalles.size() > 0) {
            total = detalles.sum { it.valor }
        }
        def unidad = UnidadEjecutora.findByCodigo("DPI") // DIRECCIÓN DE PLANIFICACIÓN E INVERSIÓN
        def personasFirmas = Persona.findAllByUnidad(unidad)
        def gerentes = Persona.findAllByUnidad(unidad.padre)
        return [reforma: reforma, detalles: detalles, total: total, personas: personasFirmas, gerentes: gerentes]
    }

    /**
     * no vale
     */
    def existente_old() {
        def proyectos = []
        def actual
        Asignacion.list().each {
//            println "p "+proyectos
            def p = it.marcoLogico.proyecto
            if (!proyectos?.id.contains(p.id)) {
                proyectos.add(p)
            }
        }
        if (params.anio) {
            actual = Anio.get(params.anio)
        } else {
            actual = Anio.findByAnio(new Date().format("yyyy"))
        }

        proyectos = proyectos.sort { it.nombre }

        def proyectos2 = Proyecto.findAllByAprobadoPoa('S', [sort: 'nombre'])

        def campos = ["numero": ["Número", "string"], "descripcion": ["Descripción", "string"]]
//        println "pro "+proyectos
        def unidad = UnidadEjecutora.findByCodigo("DPI") // DIRECCIÓN DE PLANIFICACIÓN E INVERSIÓN
        def personasFirmas = Persona.findAllByUnidad(unidad)
        def gerentes = Persona.findAllByUnidad(unidad.padre)

        def totalOrigen = 0
        def totalDestino = 0

        return [proyectos      : proyectos, proyectos2: proyectos2, actual: actual, campos: campos, personas: gerentes + personasFirmas,
                personasGerente: gerentes, totalOrigen: totalOrigen, totalDestino: totalDestino]
    }

    /**
     * Acción que permite realizar una solicitud de reforma a asignaciones existentes
     */
    def existente() {
        def proyectos = []
        def actual
        Asignacion.list().each {
//            println "p "+proyectos
            def p = it.marcoLogico.proyecto
            if (!proyectos?.id.contains(p.id)) {
                proyectos.add(p)
            }
        }
        if (params.anio) {
            actual = Anio.get(params.anio)
        } else {
            actual = Anio.findByAnio(new Date().format("yyyy"))
        }

        proyectos = proyectos.sort { it.nombre }

        def proyectos2 = Proyecto.findAllByAprobadoPoa('S', [sort: 'nombre'])

        def campos = ["numero": ["Número", "string"], "descripcion": ["Descripción", "string"]]
//        println "pro "+proyectos
        def unidad = UnidadEjecutora.findByCodigo("DPI") // DIRECCIÓN DE PLANIFICACIÓN E INVERSIÓN
        def personasFirmas = Persona.findAllByUnidad(unidad)
        def gerentes = Persona.findAllByUnidad(unidad.padre)

        def total = 0

        def reforma = null, detalles = [], editable = true
        if (params.id) {
            editable = false
            reforma = Reforma.get(params.id)
            detalles = DetalleReforma.findAllByReforma(reforma)
            def solicitadoSinFirma = EstadoAval.findByCodigo("EF4")
            def devuelto = EstadoAval.findByCodigo("D01")
            def estados = [solicitadoSinFirma, devuelto]
            if (estados.contains(reforma.estado)) {
                editable = true
            }
            if (detalles.size() > 0) {
                total = detalles.sum { it.valor }
            }
        }

        return [proyectos      : proyectos, proyectos2: proyectos2, actual: actual, campos: campos, personas: gerentes + personasFirmas,
                personasGerente: gerentes, total: total, editable: editable, reforma: reforma, detalles: detalles]
    }

    /**
     * Acción llamada con ajax que elimina un detalle de una reforma existente
     */
    def deleteDetalle_ajax() {
        def detalle = DetalleReforma.get(params.id)
        try {
            detalle.delete(flush: true)
        } catch (e) {
            render "ERROR*Ha ocurrido un error al eliminar el detalle de la reforma"
        }
        render "SUCCESS*Detalle eliminado exitosamente"
    }

    /**
     * Acción llamada con ajax que guarda una solicitud de reforma de asignaciones existentes
     */
    def saveExistente_ajax() {
        def anio = Anio.get(params.anio.toLong())
        def personaRevisa
        def solicitadoSinFirma = EstadoAval.findByCodigo("EF4")

        def now = new Date()
        def usu = Persona.get(session.usuario.id)

        def reforma
        if (params.id) {
            reforma = Reforma.get(params.id)
            if (!reforma) {
                reforma = new Reforma()
            }
            personaRevisa = reforma.firmaSolicitud.usuario
        } else {
            reforma = new Reforma()
            personaRevisa = Persona.get(params.firma.toLong())
        }

        reforma.anio = anio
        reforma.persona = usu
        reforma.estado = solicitadoSinFirma
        reforma.concepto = params.concepto.trim()
        reforma.fecha = now
        reforma.tipo = "R"
        reforma.tipoSolicitud = "E"
        if (!reforma.save(flush: true)) {
            println "error al crear la reforma: " + reforma.errors
            render "ERROR*" + renderErrors(bean: reforma)
            return
        }

        if (params.id) {
            def firmaRevisa = reforma.firmaSolicitud
            firmaRevisa.estado = "S"
            firmaRevisa.save(flush: true)
        } else {
            def firmaRevisa = new Firma()
            firmaRevisa.usuario = personaRevisa
            firmaRevisa.fecha = now
            firmaRevisa.accion = "firmarReforma"
            firmaRevisa.controlador = "reforma"
            firmaRevisa.idAccion = reforma.id
            firmaRevisa.accionVer = "existente"
            firmaRevisa.controladorVer = "reportesReforma"
            firmaRevisa.idAccionVer = reforma.id
            firmaRevisa.accionNegar = "devolverReforma"
            firmaRevisa.controladorNegar = "reforma"
            firmaRevisa.idAccionNegar = reforma.id
            firmaRevisa.concepto = "Reforma a asignaciones existentes (${now.format('dd-MM-yyyy')}): " + reforma.concepto
            firmaRevisa.tipoFirma = "RFRM"
            if (!firmaRevisa.save(flush: true)) {
                println "error al crear firma: " + firmaRevisa.errors
                render "ERROR*" + renderErrors(bean: firmaRevisa)
                return
            }
            reforma.firmaSolicitud = firmaRevisa
            reforma.save(flush: true)
        }
        def alerta = new Alerta()
        alerta.from = usu
        alerta.persona = personaRevisa
        alerta.fechaEnvio = now
        alerta.mensaje = "Solicitud de reforma a asignaciones existentes (${now.format('dd-MM-yyyy')}): " + reforma.concepto
        alerta.controlador = "firma"
        alerta.accion = "firmasPendientes"
        alerta.id_remoto = 0
        if (!alerta.save(flush: true)) {
            println "error alerta: " + alerta.errors
        }

        def errores = ""
        params.each { k, v ->
            if (k.toString().startsWith("r")) {
                def parts = v.toString().split("_")
                if (parts.size() >= 3) {
                    def origenId = parts[0].toLong()
                    def destinoId = parts[1].toLong()
                    def monto = parts[2].toDouble()

                    def asignacionOrigen = Asignacion.get(origenId)
                    def asignacionDestion = Asignacion.get(destinoId)

                    def detalle = new DetalleReforma()
                    detalle.reforma = reforma
                    detalle.asignacionOrigen = asignacionOrigen
                    detalle.asignacionDestino = asignacionDestion
                    detalle.valor = monto
                    if (!detalle.save(flush: true)) {
                        println "error al guardar detalle: " + detalle.errors
                        errores += renderErrors(bean: detalle)
                    }
                }
            }
        }
        if (errores == "") {
            render "SUCCESS*Reforma solicitada exitosamente"
        } else {
            render "ERROR*" + errores
        }
    }

    /**
     * Acción que permite realizar una solicitud de reforma a nueva actividad
     */
    def actividad() {

    }

    /**
     * Acción que permite realizar una solicitud de reforma a nueva partida
     */
    def partida() {

    }

    /**
     * Acción que permite realizar una solicitud de reforma de incremento
     */
    def incremento() {

    }

    /**
     * Acción para que un director requirente devuelva una reforma al requirente
     */
    def devolverReforma() {
        def now = new Date()
        def usu = Persona.get(session.usuario.id)

        def reforma = Reforma.get(params.id)
        reforma.estado = EstadoAval.findByCodigo("D01") //devuelto
        reforma.save(flush: true)
        def alerta = new Alerta()
        alerta.from = usu
        alerta.persona = reforma.persona
        alerta.fechaEnvio = now
        alerta.mensaje = "Devolución de solicitud de reforma a asignaciones existentes: " + reforma.concepto
        alerta.controlador = "reforma"
        alerta.accion = "existente"
        alerta.id_remoto = reforma.id
        if (!alerta.save(flush: true)) {
            println "error alerta: " + alerta.errors
        }
        render "OK"
    }

    /**
     * Acción para que un director requirente firme una reforma
     */
    def firmarReforma() {
        def firma = Firma.findByKey(params.key)
        if (!firma) {
            response.sendError(403)
        } else {
            def reforma = Reforma.findByFirmaSolicitud(firma)
            def estadoSolicitado = EstadoAval.findByCodigo("E01")
            reforma.estado = estadoSolicitado
            reforma.save(flush: true)
            render "ok"
        }
    }

}
