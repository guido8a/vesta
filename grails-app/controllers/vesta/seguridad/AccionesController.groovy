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
     * Acción llamada con ajax que cambia el nombre de una acción
     */
    def accionCambiarNombre_ajax() {
        def accion = Accn.get(params.id)
        accion.descripcion = params.descripcion.trim()
        if (!accion.save(flush: true)) {
            render "ERROR*" + renderErrors(bean: accion)
        } else {
            render "SUCCESS*Nombre de la acción modificado exitosamente"
        }
    }
}
