package vesta.seguridad

import org.springframework.dao.DataIntegrityViolationException
import sun.misc.Perf
import vesta.parametros.TipoResponsable
import vesta.parametros.UnidadEjecutora
import vesta.proyectos.ResponsableProyecto
import vesta.seguridad.Shield


/**
 * Controlador que muestra las pantallas de manejo de Persona
 */
class PersonaController extends Shield {

    static allowedMethods = [save_ajax: "POST", delete_ajax: "POST"]

    /**
     * Acción que redirecciona a la lista (acción "list")
     */
    def index() {
        redirect(action: "list", params: params)
    }

    /**
     * Función que saca la lista de elementos según los parámetros recibidos
     * @param params objeto que contiene los parámetros para la búsqueda:: max: el máximo de respuestas, offset: índice del primer elemento (para la paginación), search: para efectuar búsquedas
     * @param all boolean que indica si saca todos los resultados, ignorando el parámetro max (true) o no (false)
     * @return lista de los elementos encontrados
     */
    def getList(params, all) {
        params = params.clone()
        params.max = params.max ? Math.min(params.max.toInteger(), 100) : 10
        params.offset = params.offset ?: 0
        if (all) {
            params.remove("max")
            params.remove("offset")
        }
        def list
        if (params.search) {
            def c = Persona.createCriteria()
            list = c.list(params) {
                or {
                    /* TODO: cambiar aqui segun sea necesario */

                    ilike("apellido", "%" + params.search + "%")
                    ilike("autorizacion", "%" + params.search + "%")
                    ilike("cedula", "%" + params.search + "%")
                    ilike("direccion", "%" + params.search + "%")
                    ilike("discapacitado", "%" + params.search + "%")
                    ilike("fax", "%" + params.search + "%")
                    ilike("login", "%" + params.search + "%")
                    ilike("mail", "%" + params.search + "%")
                    ilike("nombre", "%" + params.search + "%")
                    ilike("observaciones", "%" + params.search + "%")
                    ilike("sexo", "%" + params.search + "%")
                    ilike("sigla", "%" + params.search + "%")
                    ilike("telefono", "%" + params.search + "%")
                }
            }
        } else {
            list = Persona.list(params)
        }
        if (!all && params.offset.toInteger() > 0 && list.size() == 0) {
            params.offset = params.offset.toInteger() - 1
            list = getList(params, all)
        }
        return list
    }

    /**
     * Acción que muestra la lista de elementos
     * @return personaInstanceList: la lista de elementos filtrados, personaInstanceCount: la cantidad total de elementos (sin máximo)
     */
    def list() {
        def personaInstanceList = getList(params, false)
        def personaInstanceCount = getList(params, true).size()
        return [personaInstanceList: personaInstanceList, personaInstanceCount: personaInstanceCount]
    }

    /**
     * Acción llamada con ajax que muestra la información de un elemento particular
     * @return personaInstance el objeto a mostrar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def show_ajax() {
        if (params.id) {
            def personaInstance = Persona.get(params.id)
            if (!personaInstance) {
                render "ERROR*No se encontró Persona."
                return
            }
            def perfiles = Sesn.withCriteria {
                eq("usuario", personaInstance)
                perfil {
                    order("nombre", "asc")
                }
            }
            return [personaInstance: personaInstance, perfiles: perfiles]
        } else {
            render "ERROR*No se encontró Persona."
        }
    } //show para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que muestra un formulario para crear o modificar un elemento
     * @return personaInstance el objeto a modificar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def form_ajax() {
        def personaInstance = new Persona()
        def perfiles = []
        if (params.id) {
            personaInstance = Persona.get(params.id)
            if (!personaInstance) {
                render "ERROR*No se encontró Persona."
                return
            }
            perfiles = Sesn.withCriteria {
                eq("usuario", personaInstance)
                perfil {
                    order("nombre", "asc")
                }
            }
        }
        personaInstance.properties = params
        return [personaInstance: personaInstance, perfiles: perfiles]
    } //form para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que guarda la información de un elemento
     * @render ERROR*[mensaje] cuando no se pudo grabar correctamente, SUCCESS*[mensaje] cuando se grabó correctamente
     */
    def save_ajax() {
        def personaInstance = new Persona()
        if (params.id) {
            personaInstance = Persona.get(params.id)
            if (!personaInstance) {
                render "ERROR*No se encontró Persona."
                return
            }
        }
        personaInstance.properties = params
        if (!personaInstance.save(flush: true)) {
            render "ERROR*Ha ocurrido un error al guardar Persona: " + renderErrors(bean: personaInstance)
            return
        }

        def perfiles = params.perfiles
//        println params
//        println "PERFILES: " + perfiles
        if (perfiles) {
            def perfilesOld = Sesn.findAllByUsuario(personaInstance)
            def perfilesSelected = []
            def perfilesInsertar = []
            (perfiles.split("_")).each { perfId ->
                def perf = Prfl.get(perfId.toLong())
                if (!perfilesOld.perfil.id.contains(perf.id)) {
                    perfilesInsertar += perf
                } else {
                    perfilesSelected += perf
                }
            }
            def commons = perfilesOld.perfil.intersect(perfilesSelected)
            def perfilesDelete = perfilesOld.perfil.plus(perfilesSelected)
            perfilesDelete.removeAll(commons)

//            println "perfiles old      : " + perfilesOld
//            println "perfiles selected : " + perfilesSelected
//            println "perfiles insertar : " + perfilesInsertar
//            println "perfiles delete   : " + perfilesDelete

            def errores = ""

            perfilesInsertar.each { perfil ->
                def sesion = new Sesn()
                sesion.usuario = personaInstance
                sesion.perfil = perfil
                if (!sesion.save(flush: true)) {
                    errores += renderErrors(bean: sesion)
                    println "error al guardar sesion: " + sesion.errors
                }
            }
            perfilesDelete.each { perfil ->
                def sesion = Sesn.findAllByPerfilAndUsuario(perfil, personaInstance)
                try {
                    if (sesion.size() == 1) {
                        sesion.first().delete(flush: true)
                    } else {
                        errores += "Existen ${sesion.size()} registros del permiso " + perfil.nombre
                    }
                } catch (Exception e) {
                    errores += "Ha ocurrido un error al eliminar el perfil " + perfil.nombre
                    println "error al eliminar perfil: " + e
                }
            }
        }
        render "SUCCESS*${params.id ? 'Actualización' : 'Creación'} de Persona exitosa."
        return
    } //save para grabar desde ajax

    /**
     * Acción llamada con ajax que permite eliminar un elemento
     * @render ERROR*[mensaje] cuando no se pudo eliminar correctamente, SUCCESS*[mensaje] cuando se eliminó correctamente
     */
    def delete_ajax() {
        if (params.id) {
            def personaInstance = Persona.get(params.id)
            if (!personaInstance) {
                render "ERROR*No se encontró Persona."
                return
            }
            try {
                personaInstance.delete(flush: true)
                render "SUCCESS*Eliminación de Persona exitosa."
                return
            } catch (DataIntegrityViolationException e) {
                render "ERROR*Ha ocurrido un error al eliminar Persona"
                return
            }
        } else {
            render "ERROR*No se encontró Persona."
            return
        }
    } //delete para eliminar via ajax

    /**
     * Acción llamada con ajax que modifica la contraseña o la autorización de un usuario
     * @render ERROR*[mensaje] cuando no se pudo grabar correctamente, SUCCESS*[mensaje] cuando se grabó correctamente
     */
    def savePass_ajax() {
        println params
        def persona = Persona.get(params.id)
        def str = params.tipo == "pass" ? "contraseña" : "autorización"
        params.input2 = params.input2.trim()
        params.input3 = params.input3.trim()
        if (params.input2 == params.input3) {
            if (params.tipo == "pass") {
                persona.password = params.input2.encodeAsMD5()
            } else {
                if (persona.autorizacion == params.input1.trim().encodeAsMD5()) {
                    persona.autorizacion = params.input2.encodeAsMD5()
                } else {
                    render "ERROR*La autorización actual es incorrecta"
                    return
                }
            }
        } else {
            render "ERROR*La ${str} y la verificación no coinciden"
            return
        }
        render "SUCCESS*La ${str} ha sido modificada exitosamente"
    }

    /**
     * Acción llamada con ajax que valida que no se duplique la propiedad login
     * @render boolean que indica si se puede o no utilizar el valor recibido
     */
    def validar_unique_login_ajax() {
        params.login = params.login.toString().trim()
        if (params.id) {
            def obj = Persona.get(params.id)
            if (obj.login.toLowerCase() == params.login.toLowerCase()) {
                render true
                return
            } else {
                render Persona.countByLoginIlike(params.login) == 0
                return
            }
        } else {
            render Persona.countByLoginIlike(params.login) == 0
            return
        }
    }

    /**
     * Acción llamada con ajax que valida que no se duplique la propiedad mail
     * @render boolean que indica si se puede o no utilizar el valor recibido
     */
    def validar_unique_mail_ajax() {
        params.mail = params.mail.toString().trim()
        if (params.id) {
            def obj = Persona.get(params.id)
            if (obj.mail.toLowerCase() == params.mail.toLowerCase()) {
                render true
                return
            } else {
                render Persona.countByMailIlike(params.mail) == 0
                return
            }
        } else {
            render Persona.countByMailIlike(params.mail) == 0
            return
        }
    }

    /**
     * Acción llamada con ajax que valida que el valor ingresado corresponda con el valor almacenado de la autorización
     * @render boolean que indica si se puede o no utilizar el valor recibido
     */
    def validar_aut_previa_ajax() {
        params.input1 = params.input1.trim()
        def obj = Persona.get(params.id)
        if (obj.autorizacion == params.input1.encodeAsMD5()) {
            render true
        } else {
            render false
        }
    }

    /**
     * Acción llamada con ajax que muestra y permite modificar los responsables de una unidad
     */
    def responsablesUnidad_ajax() {
        def unidad = UnidadEjecutora.get(params.id)
        def usuarios = Persona.findAllByUnidad(unidad)

        def responsableProyectoInstanceList = []
        def ls = ResponsableProyecto.findAllByUnidad(unidad, [sort: "desde"])
        def cont = 0
        def ahora = new Date()
        ls.each {
            if (it.unidad.id == unidad.id) {
                def m = [:]
                m.obj = it
                if (it) {
                    if (it?.desde <= ahora && it?.hasta >= ahora) {
                        m.clase = "activo"
                    } else {
                        if (it?.desde < ahora) {
                            m.clase = "pasado"
                        } else {
                            if (it?.hasta > ahora) {
                                m.clase = "futuro"
                            }
                        }
                    }
                    m.estado = m.clase
                    m.clase += " " + (it?.tipo.descripcion).toLowerCase()
                    responsableProyectoInstanceList.add(m)
                    cont++
                }
            }
        }
        responsableProyectoInstanceList.sort { it.activo }
        def responsableProyectoInstanceTotal = cont

        return [usuarios: usuarios, unidad: unidad, responsableProyectoInstanceList: responsableProyectoInstanceList, responsableProyectoInstanceTotal: responsableProyectoInstanceTotal]
    }

    /**
     * Acción llamada con ajax que carga la lista de los responsables de una unidad
     */
    def tablaResponsables_ajax() {
        def unidad = UnidadEjecutora.get(params.id)

        def now = new Date()

        def responsables = ResponsableProyecto.withCriteria {
            eq("unidad", unidad)
            le("desde", now)
            ge("hasta", now)
            and {
                order("tipo", "asc")
                order("desde", "asc")
            }
        }
        return [unidad: unidad, responsables: responsables]
    }

    /**
     * Acción llamada con ajax que permite agregar responsables
     */
    def formResponsable_ajax() {
        def unidad = UnidadEjecutora.get(params.id)
        return [unidad: unidad]
    }

    /**
     * Acción llamada con ajax que guarda un nuevo responsable
     */
    def addResponsable_ajax() {
        def unidad = UnidadEjecutora.get(params.unidad.toLong())
        def usuario = Persona.get(params.responsable.toLong())
        def tipo = TipoResponsable.get(params.tipo.toLong())

        def desde = new Date().parse("dd-MM-yyyy", params.desde_input)
        def hasta = new Date().parse("dd-MM-yyyy", params.hasta_input)

        def responsable = new ResponsableProyecto()

        if (params.id) {
            responsable = ResponsableProyecto.get(params.id)
        }

        responsable.responsable = usuario
        responsable.unidad = unidad
        responsable.desde = desde
        responsable.hasta = hasta
        responsable.tipo = tipo
        responsable.observaciones = params.observaciones

        if (!responsable.save(flush: true)) {
            println responsable.errors
            render("ERROR*" + renderErrors(bean: responsable))
        } else {
            render "SUCCESS*Responsable asignado correctamente"
        }
    }

    /**
     * Acción llamada con ajax que da de baja a un responsable
     */
    def removeResponable_ajax() {
        def responsable = ResponsableProyecto.get(params.id)
        responsable.hasta = new Date()

        if (!responsable.save(flush: true)) {
            println responsable.errors
            render "ERROR*" + renderErrors(bean: responsable)
        } else {
            render "SUCCESS*Responsable dado de baja exitosamente"
        }
    }

    /**
     * Acción llamada con ajax que carga los responsables de un cierto tipo
     */
    def responsablesPorTipo_ajax() {
        /*
       'E' 'Ejecución'
       'I' 'Planificación'
       'S' 'Seguimiento'
       'A' 'Administrativo'
       'F' 'Financiero'

       administrativo
       si esigef = 9999 -> solo de la direccion administrativa // id=93
       else -> de la unidad

       ejecucion
       de la unidad

       financiero
       si esigef = 9999 -> solo de la direccion financiera // id=94
       else -> de la unidad

       planificacion
       si esigef = 9999 -> solo de la direccion de planificacion // id=85
       else -> de la unidad

       seguimiento
       si esigef = 9999 -> solo de la direccion de planificacion // id=85
       else -> de la unidad
       */

        def unidad = UnidadEjecutora.get(params.unidad)
        def tipo = TipoResponsable.get(params.tipo)

        def dirAdmin = UnidadEjecutora.get(93)
        def dirFinan = UnidadEjecutora.get(94)
        def dirPlan = UnidadEjecutora.get(85)

        def usuarios = []
        if (tipo) {
            switch (tipo.codigo) {
                case 'A':
                    if (unidad.codigo == "9999") {
                        usuarios = Persona.findAllByUnidad(dirAdmin)
                    } else {
                        if (unidad) {
                            usuarios = Persona.findAllByUnidad(unidad)
                        }
                    }
                    break;
                case 'E':
                    usuarios = Persona.findAllByUnidad(unidad)
                    break;
                case 'F':
                    if (unidad.codigo == "9999") {
                        usuarios = Persona.findAllByUnidad(dirFinan)
                    } else {
                        if (unidad) {
                            usuarios = Persona.findAllByUnidad(unidad)
                        }
                    }
                    break;
                case 'I':
/*
                    if (unidad.codigo == "9999") {
                        usuarios = Usro.findAllByUnidad(dirPlan)
                    } else {
*/
                    if (unidad) {
                        usuarios = Persona.findAllByUnidad(unidad)
                    }
/*
                    }
*/
                    break;
                case 'S':
                    if (unidad.codigo == "9999") {
                        usuarios = Persona.findAllByUnidad(dirPlan)
                    } else {
                        if (unidad) {
                            usuarios = Persona.findAllByUnidad(unidad)
                        }
                    }
                    break;
            }
        }
        usuarios.sort { it.nombre }

        def ls = []
        usuarios.each { u ->
            def m = [:]
            m.key = u.id
            m.value = u.nombre.toLowerCase().split(' ').collect {
                it.capitalize()
            }.join(' ') + " " + u.apellido.toLowerCase().split(' ').collect { it.capitalize() }.join(' ')
            ls.add(m)
        }

        render g.select(from: ls, optionKey: 'key', optionValue: 'value', name: "responsable",
                "class": "form-control input-sm required")
    }

    /**
     * Acción que le permite al usuario cambiar su configuración personal (contraseña, autorización...)
     */
    def personal() {
        def usu = Persona.get(session.usuario.id)
        return [persona: usu]
    }

    /**
     * Acción que actualiza la clave de autorización
     */
    def updateAuth() {
        def usu = Persona.get(session.usuario.id)

        def input = params.input1.toString().trim()
        if (input != "") {
            input = input.encodeAsMD5()
        }

        if (input == usu.autorizacion) {
            if (params.authNueva.toString().trim() == params.authConfirm.toString().trim()) {
                usu.autorizacion = params.authNueva.toString().trim().encodeAsMD5()
                if (usu.save(flush: true)) {
                    render "SUCCESS*Clave de autorización modificada exitosamente"
                } else {
                    render "ERROR*" + renderErrors(bean: usu)
                }
            } else {
                render "ERROR*Las claves de autorización no concuerdan"
            }
        } else {
            render "ERROR*La clave de autorización es incorrecta"
        }
    }
}
