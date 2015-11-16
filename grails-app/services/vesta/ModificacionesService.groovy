package vesta

import vesta.parametros.poaPac.Anio
import vesta.parametros.poaPac.Fuente
import vesta.parametros.poaPac.Mes
import vesta.proyectos.Cronograma
import vesta.proyectos.MarcoLogico
import vesta.proyectos.ModificacionProyecto

/**
 * Servicio para manejar las modificaciones
 */
class ModificacionesService {

//    static transactional = true
    static transactional = false

    def kerberosService

    def cronogramas = []

    /**
     * Agrega una modificación al cronograma. Trabaja sobre el arreglo cronogramas definido en el service
     * @param params mapa que contiene: <br/>
     * <ul>
     *     <li>idCelda: el id del cronograma (inserción y modificación)</li>
     *     <li>valor: el valor para el cronograma (inserción y modificación)</li>
     *     <li>fuente: el id de la fuente para el cronograma (inserción y modificación)</li>
     *     <li>mes: el id del mes (inserción)</li>
     *     <li>act: el id de marco lógico de la actividad (inserción)</li>
     *     <li>anio: el id del año (inserción)</li>
     *     <li>modificacion: el id de la modificación de proyecto (inserción)</li>
     *     <li>session: el objeto session</li>
     *     <li>id: el id del cronograma</li>
     * </ul>
     * @return
     */
    def agregarModificacionCronograma(params) {
        if ((cronogramas.idCelda).contains(params.idCelda)) {
            //modifico
            cronogramas.each { crono ->
                if (crono.idCelda == params.idCelda) {
                    crono.valor = params.valor.toDouble()
                    crono.fuente = Fuente.get(params.fuente)
                }
            }
        } else {
            //inserto
            def obj = [:]
            obj.idCelda = params.idCelda
            obj.id = null
            obj.mes = Mes.get(params.mes)
            obj.marcoLogico = MarcoLogico.get(params.act)
            obj.fuente = Fuente.get(params.fuente)
            obj.anio = Anio.get(params.anio)
            obj.modificacionProyecto = ModificacionProyecto.get(params.modificacion)
            obj.valor = params.valor.toDouble()
            obj.session = params.session
            if (params.id && params.id != "" && params.id != " " && params.id != "0") {
                obj.padre = Cronograma.get(params.id)
            } else {
                obj.padre = null
            }
            cronogramas.add(obj)
        }
//        println "\n\nServicio de modificacion de cronogramas"
//        cronogramas.each { cronograma ->
//            println cronograma
//        }
    } //agregar modificacion

    /**
     * Itera en el arreglo cronogramas del service y realiza inserciones en la base de datos para cada uno de los elementos
     * @return
     */
    def saveModificacion() {
        def err = 0
        def err2 = 0
        cronogramas.each { crono ->
            def cronograma = new Cronograma()
            cronograma.mes = crono.mes
            cronograma.marcoLogico = crono.marcoLogico
            cronograma.fuente = crono.fuente
            cronograma.anio = crono.anio
            cronograma.modificacionProyecto = crono.modificacionProyecto
            cronograma.valor = crono.valor
            cronograma.cronograma = null
            cronograma = kerberosService.saveObject(cronograma, Cronograma, crono.session.perfil, crono.session.usuario, "saveModificacion", "modificacionService", crono.session)
            if (cronograma.errors.getErrorCount() != 0) {
                err++
            } else {
                if (crono.padre) {
                    def padre = crono.padre
                    padre.cronograma = cronograma
                    padre = kerberosService.saveObject(padre, Cronograma, crono.session.perfil, crono.session.usuario, "saveModificacion", "modificacionService", crono.session)
                    if (padre.errors.getErrorCount() != 0) {
                        err2++
                    }
                }
            }
        }
        return [(err / cronogramas.size()), err2]
    }

    /**
     * Reinicia el arreglo cronogramas a un arreglo vacío
     * @return
     */
    def reset() {
        cronogramas = []
    }

}
