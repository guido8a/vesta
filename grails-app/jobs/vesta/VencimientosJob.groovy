package vesta

import vesta.avales.Aval
import vesta.avales.SolicitudAval
import vesta.seguridad.Persona
import vesta.seguridad.Prfl
import vesta.seguridad.Sesn


class VencimientosJob {

    def dbConnectionService
    def mailService

    static triggers = {
//        simple repeatInterval: 5000l // execute job once in 5 seconds
        simple startDelay: 1000 * 60, repeatInterval: 1000 * 60 * 10   // ejecuta cada 10 minutos
    }

    def execute() {
        // executa job
        /** todo: buscar que avales se van a vencer y avisar mediante mail al DP o al D **/
        def cn = dbConnectionService.getConnection()
        def directorDP = Sesn.findByPerfilInList(Prfl.findAllByCodigo("DP"))
        def gerenteGAF = Sesn.findByPerfilInList(Prfl.findAllByCodigo("GAF"))
        def autoridadRq  // quien ha firmado la solicitud del aval

        def tx = "select aval__id, avalnmro, prconmbr, prcofcin, prcofcfn from prco, aval " +
                "where aval.prco__id = prco.prco__id and edav__id = 89 and prcofcfn < (cast(now() as date) + 5)"
        println "vencimientos: $tx"
        cn.eachRow(tx.toString()) { av ->
            // determina quien ha firmado la solicitud del aval
            autoridadRq = Persona.get(SolicitudAval.findByAval(Aval.get(av.aval__id)))
            try {
                if (autoridadRq.mail) {
                    mailService.sendMail {
                        to autoridadRq
                        subject "Alerta de vencimiento del aval número GPE-${av.avalnmro}"
                        body "El aval número GPE-${av.avalnmro} para ${av.prconmbr} tiene fecha de vencimiento: ${av.prcofcfn}"
                    }
                } else {
                    println "El usuario ${autoridadRq} no tiene email"
                }
            } catch (e) {
                println "error email " + e.printStackTrace()
            }
            // mail para DP
            try {
                if (directorDP?.usuario?.mail) {
                    mailService.sendMail {
                        to directorDP.usuario.mail
                        subject "Alerta de vencimiento del aval número GPE-${av.avalnmro}"
                        body "El aval número GPE-${av.avalnmro} para ${av.prconmbr} tiene fecha de vencimiento: ${av.prcofcfn}"
                    }
                } else {
                    println "El usuario ${directorDP.usuario} no tiene email"
                }
            } catch (e) {
                println "error email " + e.printStackTrace()
            }
        }

        tx = "select avcr__id, avcrnmav, avcrnmpr, avcrfcin, avcrfcfn, frmagrnt from avcr " +
                "where edav__id = 89 and avcrfcfn < (cast(now() as date) + 5)"
        println "vencimientos corr: $tx"
        cn.eachRow(tx.toString()) { av ->
            // determina quien ha firmado la solicitud del aval
            autoridadRq = Persona.get(av.frmagrnt)
            try {
                if (autoridadRq.mail) {
                    mailService.sendMail {
                        to autoridadRq
                        subject "Alerta de vencimiento del aval número GAF-${av.avalnmav}"
                        body "El aval número GAF-${av.avalnmav} para ${av.acvrnmpr} tiene fecha de vencimiento: ${av.avcrfcfn}"
                    }
                } else {
                    println "El usuario ${autoridadRq} no tiene email"
                }
            } catch (e) {
                println "error email " + e.printStackTrace()
            }
            // mail para GAF
            try {
                if (gerenteGAF?.usuario?.mail) {
                    mailService.sendMail {
                        to gerenteGAF.usuario.mail
                        subject "Alerta de vencimiento del aval número GPE-${av.avalnmav}"
                        body "El aval número GAF-${av.avalnmav} para ${av.acvrnmpr} tiene fecha de vencimiento: ${av.avcrfcfn}"
                    }
                } else {
                    println "El usuario ${gerenteGAF.usuario} no tiene email"
                }
            } catch (e) {
                println "error email " + e.printStackTrace()
            }

        }
    }
}
