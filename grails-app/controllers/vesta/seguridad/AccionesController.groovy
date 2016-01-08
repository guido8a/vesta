package vesta.seguridad

import groovy.time.TimeCategory

class AccionesController extends Shield {

    /**
     * Acción que redirecciona a acciones
     */
    def index() {
        redirect(action: "acciones")
    }

    /**
     * Acción que muestra un listado de acciones ordenadas por módulo
     */
    def acciones() {
        def modulos = Modulo.list([sort: "orden"])
        return [modulos: modulos]
    }

    /**
     * Acción que muestra una lista de acciones filtrando por módulo y tipo para editar las acciones
     */
    def acciones_ajax() {
//        println "acciones_ajax params: $params"
        def pruebasInicio = new Date()
        def pruebasFin
        def excede = false

        def accn = Accn.createCriteria()
        def acciones = accn.list(max: 60, offset: 0) {
//            ilike("nombre", "%${params.criterio}%")
            eq("modulo", Modulo.get(params.id))
            not {
                ilike("nombre", "%_ajax%")
                ilike("nombre", "%_old%")
            }
            order("tipo", "asc")
            control {
                ilike("nombre", "%${params.criterio}%")
                order("nombre", "asc")
            }
            order("nombre", "asc")
        }
        def modulo = Modulo.list([sort: 'nombre'])

        excede = (acciones.totalCount > 60)

        pruebasFin = new Date()
//        println "tiempo acciones_ajax: ${TimeCategory.minus(pruebasFin, pruebasInicio)}, total reg: ${acciones.totalCount}"
        params.criterio = params.criterio
        return [acciones: acciones, modulo: modulo, excede: excede, total: acciones.totalCount]
    }

    /**
     * Acción llamada con ajax que cambia el tipo de una acción entre Menú y Proceso
     */
    def accionCambiarTipo_ajax() {
        def accion = Accn.get(params.id)
        accion.tipo = Tpac.findByCodigo(params.tipo)
        if (!accion.save(flush: true)) {
            render "ERROR*" + renderErrors(bean: accion)
        } else {
            render "SUCCESS*Tipo de acción modificado exitosamente"
        }
    }

    /**
     * Acción llamada con ajax que cambia el nombre de varias acciones
     */
    def accionCambiarNombre_ajax() {
        def errores = ""
        def cont = 0

        params.each { k, v ->
            if (k.toString().startsWith("desc")) {
                def parts = k.split("_")
                if (parts.size() == 2) {
                    def id = parts[1].toLong()
                    def accion = Accn.get(id)
                    accion.descripcion = v.trim()
                    if (!accion.save(flush: true)) {
                        errores += renderErrors(bean: accion)
                    } else {
                        cont++
                    }
                }
            }
        }
        if (errores == "") {
            render "SUCCESS*Nombre de ${cont} acci${cont == 1 ? 'ón' : 'ones'} modificado${cont == 1 ? '' : 's'} exitosamente"
        } else {
            render "ERROR*" + errores
        }
    }

    /**
     * Acción llamada con ajax que cambia el módulo al que pertenecen varias acciones
     */
    def accionCambiarModulo_ajax() {
        def errores = ""
        def cont = 0

        params.each { k, v ->
            if (k.toString().startsWith("mod")) {
                def parts = k.split("_")
                if (parts.size() == 2) {
                    def id = parts[1].toLong()
                    def accion = Accn.get(id)
                    accion.modulo = Modulo.get(v.toLong())
                    if (!accion.save(flush: true)) {
                        errores += renderErrors(bean: accion)
                    } else {
                        cont++
                    }
                }
            }
        }
        if (errores == "") {
            render "SUCCESS*Módulo de ${cont} acci${cont == 1 ? 'ón' : 'ones'} modificado${cont == 1 ? '' : 's'} exitosamente"
        } else {
            render "ERROR*" + errores
        }
    }

    /**
     * Acción llamada con ajax que itera sobre todos los controladores creados en el proyecto grails, los busca en la base de datos y si no los encuentra los inserta dentro de la tabla representada en el dominio Ctrl
     */
    def cargarControladores_ajax() {
//        println "cargar controladores"
        def i = 0
        grailsApplication.controllerClasses.each {
            //def  lista = Ctrl.list()
            def ctr = Ctrl.findByNombre(it.getName())
            if (!ctr) {
                ctr = new Ctrl()
                ctr.nombre = it.getName()
                ctr.save(flush: true)
                i++
            }
        }
        render("SUCCESS*Se ha${i == 1 ? '' : 'n'} agregado ${i} Controlador${i == 1 ? '' : 'es'}")
    }

    /**
     * Acción llamada con ajax que itera sobre todos los controladores creados en el proyecto, analiza las acciones de cada controlador, las busca en la base de datos y si no las encuentra las inserta en la tabla representada por el dominio Accn
     */
    def cargarAcciones_ajax() {
//        println "cargar acciones"
        def ac = []
        def accs = [:]
        def i = 0
        def ignore = ["afterInterceptor", "beforeInterceptor"]
        grailsApplication.controllerClasses.each { ct ->
            def t = []
            ct.getURIs().each {
                def s = it.split("/")
                if (s.size() > 2) {
                    if (!t.contains(s[2])) {
                        if (!ignore.contains(s[2])) {
                            if (!(s[2] =~ "Service")) {
                                def accn = Accn.findByNombreAndControl(s[2], Ctrl.findByNombre(ct.getName()))
                                //println "si service "+ s[2]+" accion "+accn.id+" url "+it
                                if (accn == null) {
//                                    println "if 2";
                                    accn = new Accn()
                                    accn.nombre = s[2]
                                    accn.control = Ctrl.findByNombre(ct.getName())
                                    accn.descripcion = s[2]
                                    accn.accnAuditable = 1
                                    if (s[2] =~ "save" || s[2] =~ "update" || s[2] =~ "delete" || s[2] =~ "guardar") {
                                        accn.tipo = Tpac.get(2)
                                    } else {
                                        accn.tipo = Tpac.get(1)
                                    }
                                    accn.modulo = Modulo.findByDescripcionLike("no%asignado")
                                    accn.save(flush: true)
                                    i++
//                                    println "errores " + accn.errors
                                }
                                t.add(s.getAt(2))
                            } else {
//                                println "no sale por el service "+s[2]+" "+it
                            }
                        } else {
                            //println "no sale por el ignore "+ignore
                        }
                    } else {
                        //println "no sale por el contains t  "+it+"   "+t
                    }
                } else {
                    // println "no sele por el size "+it
                }
            }
            accs.put(ct.getName(), t)
            t = null
        }
        render("SUCCESS*Se ha${i == 1 ? '' : 'n'} agregado ${i} acci${i == 1 ? 'ón' : 'ones'}")
    }

    /**
     * Acción que muestra los módulos a los que un perfil tiene acceso
     */
    def permisos() {
        def modulos = Modulo.list([sort: "orden"])
        return [modulos: modulos]
    }

    /**
     * Acción llamada con ajax que muestra una lista de acciones filtrando por módulo y tipo para editar los permisos
     */
    def permisos_ajax() {
        def perfil = Prfl.get(params.perf.toLong())
        def modulo = Modulo.get(params.id)
        def accn = Accn.createCriteria()
        def excede = true
        def acciones = accn.list(max: 60, offset: 0) {
            eq("modulo", modulo)
            not {
                ilike("nombre", "%_ajax%")
                ilike("nombre", "%_old%")
            }
            order("tipo", "asc")
            control {
                ilike("nombre", "%${params.criterio}%")
                order("nombre", "asc")
            }
            order("nombre", "asc")
        }

        excede = (acciones.totalCount > 60)

//        println "total reg: ${acciones.totalCount}"
        params.criterio = params.criterio
        return [acciones: acciones, perfil: perfil, modulo: modulo, excede: excede, total: acciones.totalCount]

    }

    /**
     * Acción llamada con ajax que guarda los permisos de un perfil
     */
    def guardarPermisos_ajax() {
        def perfil = Prfl.get(params.perfil.toLong())
        def modulo = Modulo.get(params.modulo.toLong())

        //todos los permisos actuales de este perfil en este modulo
        def permisosOld = Prms.withCriteria {
            eq("perfil", perfil)
            accion {
                eq("modulo", modulo)
            }
        }
        def accionesSelected = []
        def accionesInsertar = []
        (params.accion.split(",")).each { accionId ->
            if (accionId) {
                def accion = Accn.get(accionId.toLong())
                if (!permisosOld.accion.id.contains(accion.id)) {
                    accionesInsertar += accion
                } else {
                    accionesSelected += accion
                }
            }
        }

        def commons = permisosOld.accion.intersect(accionesSelected)
        def accionesDelete = permisosOld.accion.plus(accionesSelected)
        accionesDelete.removeAll(commons)

        def errores = ""

        accionesInsertar.each { accion ->
            def perm = new Prms()
            perm.accion = accion
            perm.perfil = perfil
            if (!perm.save(flush: true)) {
                errores += renderErrors(bean: perm)
                println "error al guardar permiso: " + perm.errors
            }
        }
        accionesDelete.each { accion ->
            def perm = Prms.findAllByPerfilAndAccion(perfil, accion)
            try {
                if (perm.size() == 1) {
                    perm.first().delete(flush: true)
                } else {
                    errores += "Existen ${perm.size()} registros del permiso " + accion.nombre
                }
            } catch (Exception e) {
                errores += "Ha ocurrido un error al eliminar el permiso " + accion.nombre
                println "error al eliminar permiso: " + e
            }
        }
        if (errores == "") {
            render "SUCCESS*${accionesInsertar.size()} acci${accionesInsertar.size() == 1 ? 'ón' : 'ones'} insertada${accionesInsertar.size() == 1 ? '' : 's'}" +
                    " y ${accionesDelete.size()} acci${accionesDelete.size() == 1 ? 'ón' : 'ones'} eliminada${accionesDelete.size() == 1 ? '' : 's'} exitosamente"
        } else {
            render "ERROR*" + errores
        }
    }
}
