package vesta

import vesta.parametros.UnidadEjecutora
import vesta.parametros.poaPac.Anio
import vesta.poa.Actividad
import vesta.poa.Asignacion
import vesta.proyectos.MarcoLogico
import vesta.proyectos.Proyecto

class ProyectosService {

    def getUnidadesUnidad(UnidadEjecutora unidad) {
        def padre = unidad.padre
        def unidades = [unidad]
        def codigosNo = ['343', '9999', 'GT'] // yachay, Gerencia general, Gerencia tecnica
        if (!codigosNo.contains(padre.codigo)) {
            unidades += padre
            unidades += UnidadEjecutora.findAllByPadre(padre)
        } else {
            unidades += UnidadEjecutora.findAllByPadre(unidad)
        }
        return unidades.unique().sort { it.nombre }
    }

//    def getAsignacionesUnidad(List<UnidadEjecutora> unidades, Anio anio) {
//        def asignaciones = Asignacion.findAllByAnioAndUnidadInList(anio, unidades)
//        return asignaciones
//    }
//
//    def getProyectosUnidad(List<Asignacion> asignaciones) {
//        def proyectos = []
//        asignaciones.each { a ->
//            def p = a.marcoLogico.proyecto
//            if (!proyectos.contains(p)) {
//                proyectos.add(p)
//            }
//        }
//        return proyectos
//    }
//
//    def getComponentesUnidadProyecto(List<Asignacion> asignaciones, Proyecto proyecto) {
//        def componentes = []
//        asignaciones.each { a ->
//            def p = a.marcoLogico.proyecto
//            def c = a.marcoLogico.marcoLogico
//            if (p.id == proyecto.id && !componentes.contains(c)) {
//                componentes.add(c)
//            }
//        }
//        return componentes
//    }
//
//    def getActividadesUnidadComponente(List<Asignacion> asignaciones, MarcoLogico componente) {
//        def actividades = []
//        asignaciones.each { a ->
//            def c = a.marcoLogico.marcoLogico
//            def act = a.marcoLogico
//            if (c.id == componente.id && !actividades.contains(act)) {
//                actividades.add(act)
//            }
//        }
//        return actividades
//    }
//
//    def getAsignacionesUnidadActividad(List<Asignacion> asignaciones, MarcoLogico actividad) {
//        def asg = []
//        asignaciones.each { a ->
//            def act = a.marcoLogico
//            if (act.id == actividad.id && !asg.contains(act)) {
//                asg.add(a)
//            }
//        }
//        return asg
//    }


    def getAsignacionesUnidad(UnidadEjecutora unidad, Anio anio) {
        def unidades = getUnidadesUnidad(unidad)
        def asignaciones = Asignacion.findAllByAnioAndUnidadInList(anio, unidades)
        return asignaciones.unique()
    }

    def getProyectosUnidad(UnidadEjecutora unidad, Anio anio) {
        def asignaciones = getAsignacionesUnidad(unidad, anio)
        def proyectos = []
        def proyectos2 = []
        def p
        def i
//        asignaciones.each { a ->
//            p = a.marcoLogico.proyecto
//            if (!proyectos.contains(p)) {
//                proyectos.add(p)
//            }
//        }

        asignaciones.each { e ->
            i = e.marcoLogico.proyecto.id
            if (!proyectos2.contains(i)) {
                proyectos2.add(i)
            }
        }

        proyectos2.each {
            proyectos += Proyecto.get(it)
        }

//        println("pro " + proyectos.unique())
        return proyectos.unique().sort { it.nombre }
    }

    def getComponentesUnidadProyecto(UnidadEjecutora unidad, Anio anio, Proyecto proyecto) {
        def asignaciones = getAsignacionesUnidad(unidad, anio)
        def componentes = []
        def componentes2 = []
//        asignaciones.each { a ->
//            def p = a.marcoLogico.proyecto
//            def c = a.marcoLogico.marcoLogico
//            if (p.id == proyecto.id && !componentes.contains(c)) {
//                componentes.add(c)
//            }
//        }

        asignaciones.each { f ->
            def p2 = f.marcoLogico.proyecto
            def c2 = f.marcoLogico.marcoLogico.id
            if (p2.id == proyecto.id && !componentes2.contains(c2)) {
                componentes2.add(c2)
            }

        }
        componentes2.each {
            componentes += MarcoLogico.get(it)
        }
//        println("comp " + componentes)
        return componentes.unique().sort { it.objeto }
    }

    def getActividadesUnidadComponente(UnidadEjecutora unidad, Anio anio, MarcoLogico componente) {
        def asignaciones = getAsignacionesUnidad(unidad, anio)
        def actividades = []
        def actividades2 = []
//        asignaciones.each { a ->
//            def c = a.marcoLogico.marcoLogico
//            def act = a.marcoLogico
//            if (c.id == componente.id && !actividades.contains(act)) {
//                actividades.add(act)
//            }
//        }

        asignaciones.each { b ->
            def c3 = b.marcoLogico.marcoLogico
            def act2 = b.marcoLogico.id
            if (c3.id == componente.id && !actividades2.contains(act2)) {
                actividades2.add(act2)
            }
        }

        actividades2.each {
            actividades += MarcoLogico.get(it)
        }

        println("act " + actividades)
        return actividades.unique().sort { it.numero }
    }

    def getAsignacionesUnidadActividad(UnidadEjecutora unidad, Anio anio, MarcoLogico actividad) {
        def asignaciones = getAsignacionesUnidad(unidad, anio)
        def asg = []
        asignaciones.each { a ->
            def act = a.marcoLogico
            if (act.id == actividad.id && !asg.contains(act)) {
                asg.add(a)
            }
        }
        return asg.unique()
    }
}
