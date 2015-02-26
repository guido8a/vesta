package vesta.seguridad

class InicioController extends Shield {

    def inicio() {
        redirect(action: "index")
    }

    def index() {}

    def demoUI() {

    }

    def parametros() {

    }

    def busquedaMenu() {
        def perfil = session.perfil
//        def itemsOld = [:]
        def items = [:]
        def search = params.search.toString().trim()

//        def accionesOld = Prms.findAllByPerfil(perfil).accion.sort { it.modulo.orden }
        def acciones = Prms.withCriteria {
            eq("perfil", perfil)
            or {
                accion {
                    or {
                        ilike("nombre", "%" + search + "%")
                        ilike("descripcion", "%" + search + "%")
                        modulo {
                            ilike("nombre", "%" + search + "%")
                            ilike("descripcion", "%" + search + "%")
                        }
                    }
                }
            }
        }.accion.sort { it.modulo.orden }

        acciones.each { ac ->
            if (ac.tipo.codigo == "M") {
                if (!items[ac.modulo.id]) {
                    items[ac.modulo.id] = [modulo: ac.modulo, acciones: []]
                }
                items[ac.modulo.id].acciones += ac
            }
        }
//        accionesOld.each { ac ->
//            if (ac.tipo.codigo == "M") {
//                if (!itemsOld[ac.modulo.id]) {
//                    itemsOld[ac.modulo.id] = [modulo: ac.modulo, acciones: []]
//                }
//                itemsOld[ac.modulo.id].acciones += ac
//            }
//        }

        return [params: params, items: items]
    }
}


