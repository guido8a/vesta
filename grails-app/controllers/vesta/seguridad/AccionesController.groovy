package vesta.seguridad

class AccionesController {

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

    }
}
