package vesta.seguridad

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
     * Acción que muestra una lista de acciones filtrando por módulo y tipo
     */
    def acciones_ajax() {
        def acciones = Accn.withCriteria {
            eq("modulo", Modulo.get(params.id))
            order("tipo", "asc")
            control {
                order("nombre", "asc")
            }
            order("nombre", "asc")
        }
        return [acciones: acciones]
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
     * Acción que itera sobre todos los controladores creados en el proyecto grails, los busca en la base de datos y si no los encuentra los inserta dentro de la tabla representada en el dominio Ctrl
     */
    def cargarControladores_ajax() {
        println "cargar controladores"
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
        render("Se han agregado ${i} Controladores")
    }
}
