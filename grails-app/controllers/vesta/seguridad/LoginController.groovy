package vesta.seguridad

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
        def user = Persona.withCriteria {
            eq("login", params.login, [ignoreCase: true])
            eq("estaActivo", 1)
        }

        if (user.size() == 0) {
            flash.message = "No se ha encontrado el usuario"
            flash.tipo = "error"
        } else if (user.size() > 1) {
            flash.message = "Ha ocurrido un error grave"
            flash.tipo = "error"
        } else {
            user = user.first()
            session.usuario = user
            session.usuarioKerberos = user.login
            session.time = new Date()
            session.unidad = user.unidad
            def perf = Sesn.findAllByUsuario(user)
            def perfiles = []
            perf.each { p ->
//                    println "verf perfil "+p+" "+p.estaActivo
                if (p.estaActivo)
                    perfiles.add(p)
            }
            if (perfiles.size() == 0) {
                flash.message = "No puede ingresar porque no tiene ningun perfil asignado a su usuario. Comuníquese con el administrador."
                flash.tipo = "error"
                flash.icon = "icon-warning"
                session.usuario = null
            }
        }
    }

    def validar_old() {
//        println "valida "+params
        def user = Persona.withCriteria {
            eq("login", params.login, [ignoreCase: true])
            eq("activo", 1)
        }

        if (user.size() == 0) {
            flash.message = "No se ha encontrado el usuario"
            flash.tipo = "error"
        } else if (user.size() > 1) {
            flash.message = "Ha ocurrido un error grave"
            flash.tipo = "error"
        } else {
            user = user[0]
            println "sta activo " + user.estaActivo
            if (!user.estaActivo) {
                flash.message = "El usuario ingresado no esta activo."
                flash.tipo = "error"
                redirect(controller: 'login', action: "login")
                return
            } else {
                session.usuario = user
                session.usuarioKerberos = user.login
                session.time = new Date()
                session.departamento = user.departamento
                session.triangulo = user.esTriangulo()
                def perf = Sesn.findAllByUsuario(user)
                def perfiles = []
                perf.each { p ->
//                    println "verf perfil "+p+" "+p.estaActivo
                    if (p.estaActivo)
                        perfiles.add(p)
                }
                if (perfiles.size() == 0) {
                    flash.message = "No puede ingresar porque no tiene ningun perfil asignado a su usuario. Comuníquese con el administrador."
                    flash.tipo = "error"
                    flash.icon = "icon-warning"
                    session.usuario = null
                } else {
                    def admin = false
                    perfiles.each {
                        if (it.perfil.codigo == "ADM") {
                            admin = true
                        }
                    }
                    if (!admin) {
                        def par = Parametros.list([sort: "id", order: "desc"])
                        if (par.size() > 0) {
                            par = par.pop()
                            if (par.validaLDAP == 0)
                                admin = true
                        }
                    }

                    if (!admin) {
                        if (!conecta(user, params.pass)) {
                            flash.message = "No se pudo validar la información ingresada con el sistema LDAP, contraseña incorrecta o usuario no registrado en el LDAP"
                            flash.tipo = "error"
                            flash.icon = "icon-warning"
                            session.usuario = null
                            session.departamento = null
                            redirect(controller: 'login', action: "login")
                            return
                        }
                    } else {
                        if (params.pass.encodeAsMD5() != user.password) {
                            flash.message = "Contraseña incorrecta"
                            flash.tipo = "error"
                            flash.icon = "icon-warning"
                            session.usuario = null
                            session.departamento = null
                            redirect(controller: 'login', action: "login")
                            return
                        }
                    }
                    if (perfiles.size() == 1) {
                        session.usuario.vaciarPermisos()
                        session.perfil = perfiles.first().perfil
                        cargarPermisos()
                        def cn = "inicio"
                        def an = "index"
                        def count = 0
                        def permisos = Prpf.findAllByPerfil(session.perfil)
                        permisos.each {
                            def perm = PermisoUsuario.findAllByPersonaAndPermisoTramite(session.usuario, it.permiso)
                            perm.each { pr ->
                                if (pr.estaActivo) {
                                    session.usuario.permisos.add(pr.permisoTramite)
                                }
                            }
                        }
                        if (session.usuario.esTriangulo()) {
                            count = Alerta.countByDepartamentoAndFechaRecibidoIsNull(session.departamento)
                        } else {
                            count = Alerta.countByPersonaAndFechaRecibidoIsNull(session.usuario)
                        }

                        if (count > 0)
                            redirect(controller: 'alertas', action: 'list')
                        else {//
                            if (session.usuario.getPuedeDirector()) {
                                redirect(controller: "retrasadosWeb", action: "reporteRetrasadosConsolidadoDir", params: [dpto: Persona.get(session.usuario.id).departamento.id, inicio: "1", dir: "1"])
                            } else {
                                if (session.usuario.getPuedeJefe()) {
                                    redirect(controller: "retrasadosWeb", action: "reporteRetrasadosConsolidado", params: [dpto: Persona.get(session.usuario.id).departamento.id], inicio: "1")
                                } else {
                                    redirect(controller: "inicio", action: "index")
                                }

                            }
                        }
//                    redirect(controller: cn, action: an)
                        return
                    } else {
                        session.usuario.vaciarPermisos()
                        redirect(action: "perfiles")
                        return
                    }
                }
            }

        }
        redirect(controller: 'login', action: "login")
    }

    def perfiles() {
        def usuarioLog = session.usuario
        def perfilesUsr = Sesn.findAllByUsuario(usuarioLog, [sort: 'perfil'])
        def perfiles = []
        perfilesUsr.each { p ->
            if (p.estaActivo)
                perfiles.add(p)
        }
        return [perfilesUsr: perfiles]
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
                redirect(controller: 'alertas', action: 'list')
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
