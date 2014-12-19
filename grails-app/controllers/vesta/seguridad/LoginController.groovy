package vesta.seguridad

import vesta.alertas.Alerta

class LoginController {

    def index() {
        redirect(action: 'login')
    }

    def validarSesion() {
        println "sesion creada el:" + new Date(session.getCreationTime()) + " hora actual: " + new Date()
        println "último acceso:" + new Date(session.getLastAccessedTime()) + " hora actual: " + new Date()

        println session.usuario
        if (session.usuario) {
            render "OK"
        } else {
            flash.message = "Su sesión ha caducado, por favor ingrese nuevamente."
            render "NO"
        }
    }

    def login() {
        def usu = session.usuario
        def cn = "inicio"
        def an = "index"
        if (usu) {
//            if (session.cn && session.an) {
//                cn = session.cn
//                an = session.an
//            }
            redirect(controller: cn, action: an)
        }
    }

    def validar() {
        if (!params.user || !params.pass) {
            redirect(controller: "login", action: "login")
            return
        }
        def user = Persona.withCriteria {
            ilike("login", params.user)
            eq("estaActivo", 1)
        }

        if (user.size() == 0) {
            flash.message = "No se ha encontrado el usuario"
            flash.tipo = "error"
            redirect(controller: 'login', action: "login")
            return
        } else if (user.size() > 1) {
            flash.message = "Ha ocurrido un error grave"
            flash.tipo = "error"
            redirect(controller: 'login', action: "login")
            return
        } else {
            user = user.first()
            session.usuario = user
            session.usuarioKerberos = user.login
            session.time = new Date()
            session.unidad = user.unidad
            def perfiles = Sesn.findAllByUsuario(user)
            if (perfiles.size() == 0) {
                flash.message = "No puede ingresar porque no tiene ningun perfil asignado a su usuario. Comuníquese con el administrador."
                flash.tipo = "error"
                flash.icon = "icon-warning"
                session.usuario = null
                session.unidad = null
                redirect(controller: 'login', action: "login")
                return
            } else {
                if (params.pass.encodeAsMD5() != user.password) {
                    flash.message = "Contraseña incorrecta"
                    flash.tipo = "error"
                    flash.icon = "icon-warning"
                    session.usuario = null
                    session.unidad = null
                    redirect(controller: 'login', action: "login")
                    return
                }
            }
            if (perfiles.size() == 1) {
                doLogin(perfiles.first().perfil)
            } else {
                redirect(action: "perfiles")
                return
            }
        }
    }

    def doLogin(perfil) {
        session.perfil = perfil
        cargarPermisos()
        def count = Alerta.countByPersonaAndFechaRecibidoIsNull(session.usuario)
        if (count > 0) {
            redirect(controller: 'alerta', action: 'list')
            return
        } else {
            if (session.an && session.cn) {
                redirect(controller: session.cn, action: session.an, params: session.pr)
            } else {
                redirect(controller: "inicio", action: "index")
            }
            return
        }
    }

    def perfiles() {
        def usuarioLog = session.usuario
//        def perfilesUsr = Sesn.findAllByUsuario(usuarioLog, [sort: 'perfil'])
//        def perfiles = []
//        perfilesUsr.each { p ->
//            perfiles.add(p)
//        }

        def perfiles = Sesn.withCriteria {
            eq("usuario", usuarioLog)
            perfil {
                order("nombre", "asc")
            }
        }

        return [perfiles: perfiles]
    }

    def savePerfil() {
        if (!params.perfil) {
            redirect(controller: "inicio", action: "perfiles")
        }
        def perfil = Prfl.get(params.perfil)
        doLogin(perfil)
    }

    def savePer() {
        def sesn = Sesn.get(params.prfl)
        def perf = sesn.perfil

        if (perf) {

            def permisos = Prpf.findAllByPerfil(perf)
//            println "perfil "+perf.descripcion+"  "+perf.codigo
            permisos.each {
//                println "perm "+it.permiso+"  "+it.permiso.codigo
                def perm = PermisoUsuario.findAllByPersonaAndPermisoTramite(session.usuario, it.permiso)
                perm.each { pr ->
//                    println "fechas "+pr.fechaInicio+"  "+pr.fechaFin+" "+pr.id+" "+pr.estaActivo
                    if (pr.estaActivo) {

                        session.usuario.permisos.add(pr.permisoTramite)
                    }
                }

            }
//            println "permisos " + session.usuario.permisos.id + "  " + session.usuario.permisos
//            println "add " + session.usuario.permisos
//            println "puede recibir " + session.usuario.getPuedeRecibir()
//            println "puede getPuedeVer " + session.usuario.getPuedeVer()
//            println "puede getPuedeAdmin " + session.usuario.getPuedeAdmin()
//            println "puede getPuedeJefe " + session.usuario.getPuedeJefe()
//            println "puede getPuedeDirector " + session.usuario.getPuedeDirector()
//            println "puede getPuedeExternos " + session.usuario.getPuedeExternos()
//            println "puede getPuedeAnular " + session.usuario.getPuedeAnular()
//            println "puede getPuedeTramitar " + session.usuario.getPuedeTramitar()
            session.perfil = perf
            cargarPermisos()
//            if (session.an && session.cn) {
//                if (session.an.toString().contains("ajax")) {
//                    redirect(controller: "inicio", action: "index")
//                } else {
//                    redirect(controller: session.cn, action: session.an, params: session.pr)
//                }
//            } else {
            def count = 0
            if (session.usuario.esTriangulo()) {
                count = Alerta.countByDepartamentoAndFechaRecibidoIsNull(session.departamento)
            } else {
                count = Alerta.countByPersonaAndFechaRecibidoIsNull(session.usuario)
            }

            if (count > 0)
                redirect(controller: 'alerta', action: 'list')
            else {//
//                redirect(controller: "retrasadosWeb", action: "reporteRetrasadosConsolidado", params: [dpto: Persona.get(session.usuario.id).departamento.id,inicio:"1"])
                if (session.usuario.getPuedeDirector()) {
                    redirect(controller: "retrasadosWeb", action: "reporteRetrasadosConsolidadoDir", params: [dpto: Persona.get(session.usuario.id).departamento.id, inicio: "1", dir: "1"])
                } else {
                    if (session.usuario.getPuedeJefe()) {
                        redirect(controller: "retrasadosWeb", action: "reporteRetrasadosConsolidado", params: [dpto: Persona.get(session.usuario.id).departamento.id, inicio: "1"])
                    } else {
                        redirect(controller: "inicio", action: "index")
                    }

                }
            }
//            }
        } else {
            redirect(action: "login")
        }
    }

    def logout() {
        session.usuario = null
        session.perfil = null
        session.permisos = null
        session.menu = null
        session.an = null
        session.cn = null
        session.invalidate()
        redirect(controller: 'login', action: 'login')
    }

    def finDeSesion() {

    }

    def cargarPermisos() {
        def permisos = Prms.findAllByPerfil(session.perfil)
        def hp = [:]
        permisos.each {
//                println(it.accion.accnNombre+ " " + it.accion.control.ctrlNombre)
            if (hp[it.accion.control.ctrlNombre.toLowerCase()]) {
                hp[it.accion.control.ctrlNombre.toLowerCase()].add(it.accion.accnNombre.toLowerCase())
            } else {
                hp.put(it.accion.control.ctrlNombre.toLowerCase(), [it.accion.accnNombre.toLowerCase()])
            }

        }
        session.permisos = hp
//        println "permisos menu "+session.permisos
    }
}
