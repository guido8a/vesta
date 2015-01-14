package vesta.proyectos

import org.springframework.dao.DataIntegrityViolationException
import vesta.parametros.TipoElemento
import vesta.parametros.poaPac.Anio
import vesta.seguridad.Shield


/**
 * Controlador que muestra las pantallas de manejo de Cronograma
 */
class CronogramaController extends Shield {

    static allowedMethods = [save_ajax: "POST", delete_ajax: "POST"]

    /**
     * Acción que muestra el cronograma de un proyecto
     */
    def show() {
        println "show cronograma " + params
        def proyecto = Proyecto.get(params.id)
        def componentes = MarcoLogico.withCriteria {
            eq("proyecto", proyecto)
            eq("tipoElemento", TipoElemento.get(2))
            eq("estado", 0)
            order("id", "asc")
        }
        def fuentes = Financiamiento.findAllByProyecto(proyecto).fuente
        def anio
        if (!params.anio)
            anio = Anio.findByAnio(new Date().format("yyyy").toString())
        else
            anio = Anio.get(params.anio)
        if (!anio)
            anio = Anio.list([sort: 'anio']).pop()
        println "anio " + anio

        return [proyecto: proyecto, componentes: componentes, anio: anio, fuentes: fuentes]
    }

    /**
     * Acción que permite modificar  el cronograma de un proyecto
     */
    def form() {
        println "form cronograma " + params
        def proyecto = Proyecto.get(params.id)
        def act = null
        if (params.act && params.act != "")
            act = MarcoLogico.get(params.act)
        def componentes = MarcoLogico.withCriteria {
            eq("proyecto", proyecto)
            eq("tipoElemento", TipoElemento.get(2))
            eq("estado", 0)
            order("id", "asc")
        }
        def anio
        if (!params.anio)
            anio = Anio.findByAnio(new Date().format("yyyy").toString())
        else
            anio = Anio.get(params.anio)
        if (!anio)
            anio = Anio.findAll("from Anio order by anio").pop()
        def finan = Financiamiento.findAllByProyectoAndAnio(proyecto, anio)
        def fuentes = []
        def totAnios = [:]
        finan.each {
            fuentes.add(it.fuente)
            totAnios.put(it.fuente.id, it.monto)
        }
        //println "anio "+anio+" total anios "+totAnios
        return [proyecto: proyecto, componentes: componentes, anio: anio, fuentes: fuentes, totAnios: totAnios, actSel: act]
    }

}
