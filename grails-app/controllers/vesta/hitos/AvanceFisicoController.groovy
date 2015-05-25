package vesta.hitos

import vesta.avales.ProcesoAval
import vesta.proyectos.Proceso

class AvanceFisicoController extends vesta.seguridad.Shield {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST", delete: "GET"]

    /**
     * Acción que muestra la lista de avances físicos de un proceso y permite agregar nuevos
     */
    def list = {
        def proceso = ProcesoAval.get(params.id)
        def ultimoAvance = AvanceFisico.findAllByProceso(proceso, [sort: "fecha", order: "desc"])
        def minAvance = 0
        def minDate = "";
        if (ultimoAvance.size() > 0) {
            def ua = ultimoAvance.first()
            minAvance = ua.avance
            minDate = (ua.fecha + 1).format("dd-MM-yyyy")
        }
        def maxAvance = 100 - minAvance

        def totalAvance = AvanceFisico.findAllByProceso(proceso)
        if (totalAvance.size() > 0) {
            totalAvance = totalAvance.sum { it.avance }
        } else {
            totalAvance = 0
        }
        maxAvance = 100 - totalAvance

        def tot = 0
        AvanceFisico.findAllByProceso(proceso).each {
            println "\t" + it.avance
            tot += it.avance
        }
        println "????? " + tot

        println ">>>>>>>>>>>>>>> " + totalAvance + " max " + maxAvance

        return [proceso: proceso, minAvance: minAvance, maxAvance: maxAvance, minDate: minDate]
    }

    /**
     * Acción cargada con ajax que retorna la lista de avances físicos de un proceso
     */
    def avanceFisicoProceso_ajax = {
        def proceso = ProcesoAval.get(params.id)
        def avances = AvanceFisico.findAllByProceso(proceso, [sort: "inicio"])
        return [proceso: proceso, avances: avances]
    }
    /**
     * Acción llamada con ajax que agrega un avance físico a un proceso
     */
    def addAvanceFisicoProceso_ajax = {
//        println("params af " + params)

        def proceso = ProcesoAval.get(params.id)
        def avance = new AvanceFisico()
        params.inicio = new Date().parse("dd-MM-yyyy", params.inicio)
        params.fin = new Date().parse("dd-MM-yyyy", params.fin)
        params.avance = params.avance.toString().toDouble()
        avance.properties = params
        avance.proceso = proceso
        if (avance.save(flush: true)) {
            def max = 100 - avance.avance
            def totalAvance = AvanceFisico.findAllByProceso(proceso).sum { it.avance }
            max = 100 - totalAvance
            def minDate = (avance.fecha + 1).format("dd-MM-yyyy")
//            render "SUCCESS_" + avance.avance + "_" + max + "_" + minDate
            render "SUCCESS*Avance físico " + avance.observaciones + " agregado"
        } else {
            render "error*Ha ocurrido un error"
        }
    }

    def agregarAvance = {
        def avance = AvanceFisico.get(params.id)
        def av = new AvanceAvance()
        av.avanceFisico = avance
        av.avance = params.avance.toDouble()
        av.descripcion = params.desc
        av.save(flush: true)
        render "ok"
    }

    def detalleAv = {
        def av = AvanceFisico.get(params.id)
        [av: av, avances: AvanceAvance.findAllByAvanceFisico(av, [sort: "id"])]
    }

    /**
     * Acción llamada con ajax que elimina un avance físico a un proceso
     */
    def deleteAvanceFisicoProceso_ajax = {
        def avance = AvanceFisico.get(params.id)
        def proceso = avance.proceso
        try {
            avance.delete(flush: true)

            def ultimoAvance = AvanceFisico.findAllByProceso(proceso, [sort: "fecha", order: "desc"])
            def minAvance = 0
            def minDate = "";
            if (ultimoAvance.size() > 0) {
                def ua = ultimoAvance.first()
                minAvance = ua.avance
                minDate = (ua.fecha + 1).format("dd-MM-yyyy")
            }
            def maxAvance = 100 - minAvance
            def totalAvance = AvanceFisico.findAllByProceso(proceso).sum { it.avance }
            maxAvance = 100 - totalAvance
            render "OK_" + minAvance + "_" + maxAvance + "_" + minDate
        } catch (Exception e) {
            e.printStackTrace()
            render "NO"
        }
    }

    def completar = {
        def avance = AvanceFisico.get(params.id)
        avance.completado = new Date()
        avance.save(flash: true)
        render "OK"
    }


    def agregarSubact () {

        println("params " + params)

        def proceso = Proceso.get(params.id)

        return [proceso:proceso]

    }

}
