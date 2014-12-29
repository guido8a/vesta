package vesta.reportes

import vesta.avales.Aval
import vesta.avales.ProcesoAsignacion
import vesta.avales.ProcesoAval
import vesta.hitos.AvanceFisico
import vesta.parametros.TipoElemento
import vesta.poa.Asignacion
import vesta.proyectos.MarcoLogico

class Reportes3Controller {

    def actividadesRetrasoEjecucionUI = {
    }

    def actividadesRetrasoEjecucion = {
        if (!params.fecha) {
            params.fecha = new Date().format("dd-MM-yyyy")
        }
        def fecha = new Date().parse("dd-MM-yyyy", params.fecha)

        def actividades = []

        //marco logico tipo 3 (actividad) con fecha menor o igual a params.fecha
        def allActividades = MarcoLogico.withCriteria {
            eq("tipoElemento", TipoElemento.get(3))
            le("fechaInicio", fecha)
            order("proyecto", "asc")
            order("fechaInicio", "asc")
        }
        allActividades.each { act ->
            def asignaciones = Asignacion.findAllByMarcoLogico(act)
            if (asignaciones.size() == 0 || ProcesoAsignacion.countByAsignacionInList(asignaciones) == 0) {
                actividades += act
            }
        }
        return [actividades: actividades, fecha: fecha]
    }

    def avalesEmitidosUI = {
    }

    def avalesEmitidos = {
        if (!params.fecha) {
            params.fecha = new Date().format("dd-MM-yyyy")
        }
        def fecha = new Date().parse("dd-MM-yyyy", params.fecha)
        def avales = Aval.withCriteria {
            le("fechaAprobacion", fecha)
            order("proceso", "asc")
        }

        return [avales: avales, fecha: fecha]
    }

    def subactividadesPorProcesoUI = {
    }

    def subactividadesPorProceso = {
        if (!params.fecha) {
            params.fecha = new Date().format("dd-MM-yyyy")
        }
        def fecha = new Date().parse("dd-MM-yyyy", params.fecha)
        def proceso = ProcesoAval.get(params.id)

        def avances = AvanceFisico.withCriteria {
            eq("proceso", proceso)
            le("fecha", fecha)
            order("inicio", "asc")
        }

        return [fecha: fecha, avances: avances, proceso: proceso]
    }

}
