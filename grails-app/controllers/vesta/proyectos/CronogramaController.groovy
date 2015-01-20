package vesta.proyectos

import org.springframework.dao.DataIntegrityViolationException
import vesta.avales.Certificacion
import vesta.avales.DistribucionAsignacion
import vesta.parametros.TipoElemento
import vesta.parametros.poaPac.Anio
import vesta.parametros.poaPac.Fuente
import vesta.parametros.poaPac.Mes
import vesta.parametros.poaPac.Presupuesto
import vesta.poa.Asignacion
import vesta.poa.ProgramacionAsignacion
import vesta.seguridad.Shield


/**
 * Controlador que muestra las pantallas de manejo de Cronograma
 */
class CronogramaController extends Shield {

    static allowedMethods = [save_ajax: "POST", delete_ajax: "POST"]

    def dbConnectionService
    def buscadorService
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
            fuentes.add(it)
            totAnios.put(it.fuente.id, it.monto)
        }
        def campos = ["numero": ["Número", "string"], "descripcion": ["Descripción", "string"]]
        return [proyecto: proyecto, componentes: componentes, anio: anio, fuentes: fuentes, totAnios: totAnios, actSel: act, campos: campos]
    }

    /**
     * Acción llamada con ajax que guarda los datos de un cronograma modificado
     */
    def save_ajax() {
        println "PARAMS"
        println params

        def actividad = MarcoLogico.get(params.act)
        def valor = 0
        if (params.id) {
            Cronograma.findAllByMarcoLogicoAndCronogramaIsNull(actividad).each {
                if (it.id.toLong() != params.id.toLong())
                    valor += (it.valor + it.valor2)
            }
        }
        if (!params.presupuesto2) {
            params.presupuesto2 = 0
        }
        if (actividad.monto >= valor + params.presupuesto1.toDouble() + params.presupuesto2.toDouble()) {
            def crono = new Cronograma()
            if (params.id) {
                crono = Cronograma.get(params.id)
            }
            def mes = Mes.get(params.mes.toLong())

            crono.mes = mes
            crono.anio = Anio.get(params.anio.toLong())
            crono.marcoLogico = actividad

            crono.fuente = Fuente.get(params.fuente1.toLong())
            crono.presupuesto = Presupuesto.get(params.partida1)
            crono.valor = params.presupuesto1.toDouble()

            if (params.presupuesto2.toDouble() > 0) {
                crono.fuente2 = Fuente.get(params.fuente2.toLong())
                crono.presupuesto2 = Presupuesto.get(params.partida2)
                crono.valor2 = params.presupuesto2.toDouble()
            } else {
                crono.fuente2 = null
                crono.presupuesto2 = null
                crono.valor2 = params.presupuesto2.toDouble()
            }

            if (crono.save(flush: true)) {
                render "SUCCESS*Cronograma guardado exitosamente"
            } else {
                render "ERROR*" + renderErrors(bean: crono)
            }
        } else {
            render "ERROR*Los valores ingresados superan el máximo disponible para la actividad"
        }
    }

    def calcularAsignaciones_ajax() {
        //println "calc asg "+params
        def proyecto = Proyecto.get(params.proyecto)
        def anio = Anio.get(params.anio)
        def cn = dbConnectionService.getConnection()
        def res = true
        def asignaciones = []
        def bandUnidad = true
        def errores = ""

        MarcoLogico.withCriteria {
            eq("tipoElemento", TipoElemento.get(3))
            eq("proyecto", proyecto)
            eq("estado", 0)
        }.each { comp ->
//            println "comp "+comp.responsable
            if (!comp.responsable)
                bandUnidad = false
            Asignacion.withCriteria {
                eq("marcoLogico", comp)
                eq("anio", anio)
                isNull("padre")
            }.each { aa ->
                if (res) {
                    res = verificarHijas(aa)
                    asignaciones.add(aa)
                }
            }

        }
        print "band unidad " + bandUnidad
        if (bandUnidad) {
            if (res) {
                asignaciones.each { asg ->
                    res = eliminaHijas(asg)
                    if (res) {
                        try {
                            asg.delete(flush: true)
                        } catch (e) {
                            println "no pudo borrar  " + asg.id + "  e " + e
                            res = false
                        }
                    }
                }
            }
        } else {
            render "ERROR*No se pueden crear las asignaciones, revise que todas las actividades del proyecto tengan responsables"
            return
        }
        /*Inicio del cambio!!! usando views*/
        if (!res) {
            render "ERROR*No se pudo eliminar todas las asignaciones, revise que no tengan modificaciones o certificaciones"
        } else {
            //creo la vista
            def nombreVista = "vista_asg_${session.usuario.id}"
            def sqlView = "CREATE or replace  VIEW ${nombreVista} as (SELECT c.crng__id as crono,c.mrlg__id as mrlg,c.fnte__id as fuente,c.anio__id as anio,c.prsp__id as prsp,c.messvlor as valor from crng c,mrlg m where c.mrlg__id=m.mrlg__id and m.proy__id=${proyecto.id} and m.tpel__id=3 and m.mrlgetdo=0 and c.anio__id = ${anio.id})union(SELECT c.crng__id as crono,c.mrlg__id as mrlg,c.fnte2_id as fuente,c.anio__id as anio,c.prsp2_id as prsp,c.mesvlor2 as valor from crng c,mrlg m where c.mrlg__id=m.mrlg__id and m.proy__id=${proyecto.id} and m.tpel__id=3 and m.mrlgetdo=0 and c.anio__id = ${anio.id} and prsp2_id is not null);"
            //println "sql "+sqlView
            cn.execute(sqlView.toString())
            /*fin del cambio*/
            def sql = "select c.mrlg, c.fuente,c.prsp,sum(c.valor) from ${nombreVista} c,mrlg m where c.mrlg=m.mrlg__id and m.proy__id=${proyecto.id} and m.tpel__id=3 and m.mrlgetdo=0 and c.anio = ${anio.id} group by c.mrlg,c.fuente,c.prsp order by 1"
            //println "sql "+sql
            cn.eachRow(sql.toString()) { row ->
                //println "row "+row
                def asg = new Asignacion()
                def marco = MarcoLogico.get(row.mrlg)
                asg.marcoLogico = marco
                asg.anio = anio
                asg.presupuesto = Presupuesto.get(row.prsp)
                asg.fuente = Fuente.get(row.fuente)
                asg.planificado = row.sum
                asg.unidad = marco.responsable
                asg.save(flush: true)
                def maxNum = 1
                def band = true
                def prsp1 = false
                Cronograma.findAll("from Cronograma where marcoLogico=${row.mrlg} " +
                        "and fuente=${row.fuente} " +
                        "and anio=${anio.id} " +
                        "and presupuesto=${row.prsp}").each { crg ->
                    // println crg.valor+"  mes "+crg.mes.descripcion+" mrlg "+crg.marcoLogico.id

                    maxNum = crg.mes.numero
                    def progra = new ProgramacionAsignacion()
                    progra.mes = crg.mes
                    progra.asignacion = asg
                    progra.cronograma = crg
                    progra.valor = crg.valor
                    progra.cronograma = crg
                    if (!progra.save(flush: true)) {
                        println "Error save progra1: " + progra.errors
                    }
                }
                Cronograma.findAll("from Cronograma where marcoLogico=${row.mrlg} " +
                        "and fuente=${row.fuente} " +
                        "and anio=${anio.id} " +
                        "and presupuesto2=${row.prsp}").each { crg ->
                    //println crg.valor+"  mes "+crg.mes.descripcion+" mrlg "+crg.marcoLogico.id
                    maxNum = crg.mes.numero
                    def progra = new ProgramacionAsignacion()
                    progra.mes = crg.mes
                    progra.asignacion = asg
                    progra.cronograma = crg
                    progra.valor = crg.valor2
                    if (!progra.save(flush: true)) {
                        println "Error save progra2: " + progra.errors
                    }
                }
            }
            sqlView = "drop VIEW vista_asg_${session.usuario.id};"
            //println "sql "+sqlView
            cn.execute(sqlView.toString())
            cn.close()
            render "SUCCESS*Asignaciones generadas exitosamente"
        }
    }

    boolean verificarHijas(asgn) {
        def hijas = Asignacion.findAllByPadre(asgn)
        def res = true
        println "verificando " + asgn.id
        hijas.each {
            println "verificando hija " + it.id
            res = verificarHijas(it)
            if (!res)
                return false
            if (DistribucionAsignacion.findAllByAsignacion(it).size() > 0) {
                return false
            }
            if (ModificacionAsignacion.findAllByDesdeOrRecibe(it, it).size() > 0) {
                return false
            }
            if (Certificacion.findAllByAsignacion(it).size() > 0)
                return false
        }
        if (DistribucionAsignacion.findAllByAsignacion(asgn).size() > 0) {
            return false
        }
        if (ModificacionAsignacion.findAllByDesdeOrRecibe(asgn, asgn).size() > 0) {
            return false
        }
        if (Certificacion.findAllByAsignacion(asgn).size() > 0)
            return false

        println "paso... true"
        return true
    }

    def eliminaHijas(asgn) {
        def hijas = Asignacion.findAllByPadre(asgn)
        def masHijas = []
        def res = true
        hijas.each {
            if (res) {
                res = eliminaHijas(it)
                println " ---------------- borra programaciones"
                ProgramacionAsignacion.findAllByAsignacion(it).each { prg ->
                    prg.delete(flush: true)
                }
                Obra.findAllByAsignacion(it).each { ob ->
                    ob.delete(flush: true)
                }
                println "borradas PAC----------------"
                try {
                    println "Asignacion a borrar: ${it.id}"
                    it.delete(flush: true)
                } catch (e) {
                    res = false
                }
            }
        }
        if (res) {
            try {
                ProgramacionAsignacion.findAllByAsignacion(asgn).each { prg ->
                    prg.delete(flush: true)
                }
                Obra.findAllByAsignacion(asgn).each { ob ->
                    ob.delete(flush: true)
                }
            } catch (e) {
                println "no pudo  borrar 2 "
                res = false
            }
        }
        return res
    }

    def buscarPresupuesto() {
        println "presupuesto en cronograma"
        def listaTitulos = ["Número", "Descripción"]
        def listaCampos = ["numero", "descripcion"]
        def funciones = [null, null]
        def url = g.createLink(action: "buscarPresupuesto", controller: "asignacion")
        def funcionJs = ""
        funcionJs += 'function(){'
        funcionJs += ' var idReg = $(this).attr("regId");\n' +
                '            var txtReg = $(this).attr("txtReg");\n' +
                '            $("#partida2").val(idReg);\n' +
                '            $(".bsc_desc-2").val(txtReg);\n' +
                '            $(".modal-search").modal("hide");'
        funcionJs += '}'
        def numRegistros = 20
        def extras = ""

        if (!params.reporte) {
            if (params.excel) {
                session.dominio = Presupuesto
                session.funciones = funciones
                def anchos = [30, 70]
                /*anchos para el set column view en excel (no son porcentajes)*/
                redirect(controller: "reportesBuscador", action: "reporteBuscadorExcel", params: [listaCampos: listaCampos, listaTitulos: listaTitulos, tabla: "Obra", orden: params.orden, ordenado: params.ordenado, criterios: params.criterios, operadores: params.operadores, campos: params.campos, titulo: "Partidas presupuestarias", anchos: anchos, extras: extras, landscape: true])
            } else {
                def lista = buscadorService.buscar(Presupuesto, "Presupuesto", "excluyente", params, true, extras)
                /* Dominio, nombre del dominio , excluyente o incluyente ,params tal cual llegan de la interfaz del buscador, ignore case */
                lista.pop()
                render(view: '../tablaBuscador', model: [listaTitulos: listaTitulos, listaCampos: listaCampos, lista: lista, funciones: funciones, url: url, controller: "asignacion", numRegistros: numRegistros, funcionJs: funcionJs, paginas: 10])
            }

        } else {
//            println "entro reporte"
            /*De esto solo cambiar el dominio, el parametro tabla, el paramtero titulo y el tamaño de las columnas (anchos)*/
            session.dominio = Presupuesto
            session.funciones = funciones
            def anchos = [30, 70]
            /*el ancho de las columnas en porcentajes... solo enteros*/
            redirect(controller: "reportesBuscador", action: "reporteBuscador", params: [listaCampos: listaCampos, listaTitulos: listaTitulos, tabla: "Obra", orden: params.orden, ordenado: params.ordenado, criterios: params.criterios, operadores: params.operadores, campos: params.campos, titulo: "Obras", anchos: anchos, extras: extras, landscape: true])
        }
    }

}
