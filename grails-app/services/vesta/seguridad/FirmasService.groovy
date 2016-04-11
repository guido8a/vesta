package vesta.seguridad

import vesta.parametros.UnidadEjecutora

/**
 * Servicio para el firmar electronicamente documentos
 */
class FirmasService {

    /*
    *Ubicación de la carpeta de firmas
    */
    String path = "firmas/"
//    def qrCodeService
    def QRCodeService
    def proyectosService

    def servletContext
//    static transactional = true
    static transactional = false

    def g = new org.codehaus.groovy.grails.plugins.web.taglib.ApplicationTagLib()

    def listaFirmasCombos() {
        def unidad = UnidadEjecutora.findByCodigo("DPI") // DIRECCIÓN DE PLANIFICACIÓN E INVERSIÓN

        def directores = Persona.withCriteria {
            eq("unidad", unidad)
            ilike("cargo", "%director%")
        }
        def gerentes = Persona.withCriteria {
            eq("unidad", unidad.padre)
            ilike("cargo", "%gerente%")
        }

        return [directores: directores + gerentes, gerentes: gerentes]
    }

    def listaFirmasCorrientes() {
//        def unidad = UnidadEjecutora.findAllByCodigoInList(["DA","DF" ]) // DIRECCIONES ADMINISTRATIVA y FINANCIERA
        def unidad = UnidadEjecutora.findAllByCodigoInList(["DF"]) // DIRECCIONES ADMINISTRATIVA y FINANCIERA

        def directores = Persona.findAllByUnidadInListAndCargoIlike(unidad, "%director%")
        def gerentes = Persona.findAllByUnidadAndCargoIlike(unidad[0].padre, "%gerente%")

        return [directores: directores + gerentes, gerentes: gerentes]
    }

    def listaDirectoresUnidad(UnidadEjecutora unidad) {
        //quitado el 03-06-2015, cambiado por lo de mas abajo....
//        def directores = Persona.withCriteria {
//            eq("unidad", unidad)
//            cargoPersonal {
//                ilike("descripcion", "%director%")
//            }
//        }
//        return directores
        def unidades = unidad.unidades
        println "unidades: $unidades, ${unidades[0].codigo}"
        def directores
        if(unidades[0].codigo == 'GG') {
            directores = Persona.withCriteria {
                inList("unidad", unidades)
                ilike("cargo", "%gerent%")
                eq("estaActivo", 1)
            }
        } else {
            directores = Persona.withCriteria {
                inList("unidad", unidades)
                ilike("cargo", "%director%")
                eq("estaActivo", 1)
            }
        }
        return directores
    }

    def listaDirectoresUnidadCorr(UnidadEjecutora unidad) {
        def directores = Persona.withCriteria {
            eq("unidad", unidad)
            ilike("cargo", "%director%")
            eq("estaActivo", 1)
        }
        return directores
    }

    def listaGerentesUnidad(UnidadEjecutora unidad) {
//        def codigosNo = ['343', '9999', 'GT'] // yachay, Gerencia general, Gerencia tecnica
        def gerentes = []
//        def padre = unidad.padre
        def unidades = unidad.unidades
//        println padre.codigo +"   "+codigosNo.contains(padre.codigo)
//        if (codigosNo.contains(padre.codigo)) {
//            gerentes = listaDirectoresUnidad(unidad)
//        } else {


//        if (unidad.padre.codigo == '9999') {
        if (unidad.padre.codigo == 'GG') {
            gerentes = listaDirectoresUnidad(unidad)

            def gerenteUnidad = Persona.withCriteria {
                eq("unidad", unidad)
                ilike("cargo", "%gerente%")
                eq("estaActivo", 1)
            }
            gerentes += gerenteUnidad
        } else {
            gerentes = Persona.withCriteria {
                inList("unidad", unidades)
                ilike("cargo", "%gerente%")
                eq("estaActivo", 1)
//                cargoPersonal {
//                    ilike("descripcion", "%gerente%")
//                }
            }
        }
//        }
        return gerentes
    }


//    def vesta.parametros.UnidadEjecutora requirentes(unej) {
    def requirentes(unej) {
        def requirentes = []
//        def general = UnidadEjecutora.findByCodigo('9999')
        def general = UnidadEjecutora.findByCodigo('GG')
        def tecnica = UnidadEjecutora.findByCodigo('GT')
        def administrativaFinan = UnidadEjecutora.findByCodigo('GAF')
        def planificacion = UnidadEjecutora.findByCodigo('GPE')
        def juridica = UnidadEjecutora.findByCodigo('GJ')
        def gerencias = UnidadEjecutora.findAllByPadreAndNombreIlike(tecnica, 'gerenc%', [sort: 'nombre'])
        def direcciones = UnidadEjecutora.findAllByPadreAndNombreIlike(general, 'direcc%', [sort: 'nombre'])
        requirentes = gerencias + direcciones + administrativaFinan + juridica + planificacion + general
//        println "requirentes: $requirentes"

        def un = unej
//        println("unej " + un.id)
        while(un != null) {
//            println " verfica si es $un"
            if(requirentes.find { it.id == un.id }) {
//                println "si contiene retorna $un"
                return un
            }
            un = un.padre
        }

        return null
    }

    /** gerencias: lista todas las direcciones de la generencia **/
    def gerencias(unej) {
        def resultado = []
//        def general = UnidadEjecutora.findByCodigo('9999')
        def general = UnidadEjecutora.findByCodigo('GG')
        def tecnica = UnidadEjecutora.findByCodigo('GT')
        def administrativaFinan = UnidadEjecutora.findByCodigo('GAF')
        def planificacion = UnidadEjecutora.findByCodigo('GPE')
        def juridica = UnidadEjecutora.findByCodigo('GJ')
        def gerencias = UnidadEjecutora.findAllByPadreAndNombreIlike(tecnica, 'gerenc%', [sort: 'nombre'])
        def direcciones = UnidadEjecutora.findAllByPadreAndNombreIlike(general, 'direcc%', [sort: 'nombre'])
        println "gerencias: ${gerencias.codigo}\n direccines: ${direcciones.codigo}"
        resultado = gerencias + direcciones + administrativaFinan + juridica + planificacion + general
//        println "requirentes: $requirentes"

        def un = unej
//        println("unej " + un.id)
        while(un != null) {
//            println " verfica si es $un"
            if(resultado.find { it.id == un.id }) {
//                println "si contiene retorna $un"
                def hijos = [un] + dependientes(un)
                hijos = hijos.unique()
//                println "hijos: ${hijos.codigo}"
                return hijos
            }
            un = un.padre
        }

        return null
    }



    /** busca unej dentro de la generencia **/
    def dependientes(gr) {
        if(gr.codigo == 'GG') { return gr }
        if(gr.codigo == 'DC') { return gr }
        if(gr.codigo == 'DGC') { return gr }
        if(gr.codigo == 'DRI') { return gr }
        return unidadHijo(gr)
    }

    /** busca unej dentro de la generencia **/
    def unidadHijo(gr) {
        println "busca hijos de ${gr.codigo}"
        def unej = UnidadEjecutora.findAllByPadre(gr)
        def hijos = UnidadEjecutora.countByPadre(unej)
        if(hijos > 0) {
            unej += unidadHijo(unej)
        } else {
            return unej
        }
    }


    /**
     * Firma digitalmente un documento
     * @param usuario es el usuario que firma
     * @param accion es el nombre de la accion
     * @param controlador es el nombre del controlador
     * @param idAccion es el identificador pasado a la accion
     * @param documento es el nombre del documento
     * @param password es la contraseña de autorizacion del usuario
     * @param baseUri def baseUri = request.scheme + "://" + request.serverName + ":" + request.serverPort
     * @return un objeto de tipo firma con la información de la firma electrónica
     */
    def firmarDocumento(usuario, password, firma, baseUri) {
        def user = Persona.get(usuario)
        if (firma.usuario != user) {
            return "ERROR*El usuario no concuerda con la firma"
        }
        if (user.autorizacion == password.encodeAsMD5()) {
//            println "paso  "
            try {
                def now = new Date()
                def key = ""
                def texto = baseUri + g.createLink(controller: "firma", action: "verDocumento") + "?ky="
                def pathQr = servletContext.getRealPath("/") + path
                def nombre = "" + user.login + "_" + now.format("dd_MM_yyyy_mm_ss") + ".png"
                new File(pathQr).mkdirs()
                println " "+now.format("ddMMyyyyhhmmss.SSS")+" "+" nombre "+nombre+"  "+user.login.encodeAsMD5()+"   "+(user.autorizacion.substring(10,20))
                key = now.format("ddMMyyyyhhmmss.SSS").encodeAsMD5() + (user.login.encodeAsMD5().substring(0, 10)) + (user.autorizacion.substring(10, 20))
                // println "key "+key
                texto += key
                //plugin antiguo de QR
//                def fos = new FileOutputStream(pathQr + nombre)
//                qrCodeService.renderPng(texto, 100, fos)
//                fos.close()

                //plugin nuevo de QR
//                def texto = request.scheme + "://" + "10.0.0.3" + ":" + request.serverPort + g.createLink(controller: "firma", action: "verDocumento") + "?ky="
//                def pathQr = servletContext.getRealPath("/") + "firmas/"
//                def nombre = "" + session.usuario.login + "_" + new Date().format("dd_MM_yyyy_MM_ss") + ".png"
                def logo = servletContext.getRealPath("/") + "images/logo_yachay_qr.png"
                Map information = [chl: texto]
                information.chs = "200x200"
                QRCodeService.createQRCode(information, logo, pathQr, nombre)

                firma.fecha = now
                firma.key = key
                firma.path = nombre
                firma.estado = "F"
                println "FIRMA ${firma.id} creado archivo: $nombre"
                firma.save(flush: true)
                return firma
            } catch (e) {
                println "error al generar la firma \n " + e.printStackTrace()
                return "ERROR*No se pudo generar la firma"
            }
        } else {
            return "ERROR*La clave de autorización es incorrecta"
        }

    }
}
