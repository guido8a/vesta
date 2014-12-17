package vesta.test

import org.springframework.dao.DataIntegrityViolationException
import vesta.seguridad.Shield


/**
 * Controlador que muestra las pantallas de manejo de Test
 */
class TestController extends Shield {

    static allowedMethods = [save_ajax: "POST", delete_ajax: "POST"]

    /**
     * Acción que redirecciona a la lista (acción "list")
     */
    def index() {
        redirect(action:"list", params: params)
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
        if(all) {
            params.remove("max")
            params.remove("offset")
        }
        def list
        if(params.search) {
            def c = Test.createCriteria()
            list = c.list(params) {
                or {
                    /* TODO: cambiar aqui segun sea necesario */
                    
                    ilike("codigo", "%" + params.search + "%")  
                    ilike("email", "%" + params.search + "%")  
                    ilike("login", "%" + params.search + "%")  
                    ilike("mail", "%" + params.search + "%")  
                    ilike("nombre", "%" + params.search + "%")  
                }
            }
        } else {
            list = Test.list(params)
        }
        if (!all && params.offset.toInteger() > 0 && list.size() == 0) {
            params.offset = params.offset.toInteger() - 1
            list = getList(params, all)
        }
        return list
    }

    /**
     * Acción que muestra la lista de elementos
     * @return testInstanceList: la lista de elementos filtrados, testInstanceCount: la cantidad total de elementos (sin máximo)
     */
    def list() {
        def testInstanceList = getList(params, false)
        def testInstanceCount = getList(params, true).size()
        return [testInstanceList: testInstanceList, testInstanceCount: testInstanceCount]
    }

    /**
     * Acción llamada con ajax que muestra la información de un elemento particular
     * @return testInstance el objeto a mostrar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def show_ajax() {
        if(params.id) {
            def testInstance = Test.get(params.id)
            if(!testInstance) {
                render "ERROR*No se encontró Test."
                return
            }
            return [testInstance: testInstance]
        } else {
            render "ERROR*No se encontró Test."
        }
    } //show para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que muestra un formaulario para crear o modificar un elemento
     * @return testInstance el objeto a modificar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def form_ajax() {
        def testInstance = new Test()
        if(params.id) {
            testInstance = Test.get(params.id)
            if(!testInstance) {
                render "ERROR*No se encontró Test."
                return
            }
        }
        testInstance.properties = params
        return [testInstance: testInstance]
    } //form para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que guarda la información de un elemento
     * @render ERROR*[mensaje] cuando no se pudo grabar correctamente, SUCCESS*[mensaje] cuando se grabó correctamente
     */
    def save_ajax() {
        def testInstance = new Test()
        if(params.id) {
            testInstance = Test.get(params.id)
            if(!testInstance) {
                render "ERROR*No se encontró Test."
                return
            }
        }
        testInstance.properties = params
        if(!testInstance.save(flush: true)) {
            render "ERROR*Ha ocurrido un error al guardar Test: " + renderErrors(bean: testInstance)
            return
        }
        render "SUCCESS*${params.id ? 'Actualización' : 'Creación'} de Test exitosa."
        return
    } //save para grabar desde ajax

    /**
     * Acción llamada con ajax que permite eliminar un elemento
     * @render ERROR*[mensaje] cuando no se pudo eliminar correctamente, SUCCESS*[mensaje] cuando se eliminó correctamente
     */
    def delete_ajax() {
        if(params.id) {
            def testInstance = Test.get(params.id)
            if (!testInstance) {
                render "ERROR*No se encontró Test."
                return
            }
            try {
                testInstance.delete(flush: true)
                render "SUCCESS*Eliminación de Test exitosa."
                return
            } catch (DataIntegrityViolationException e) {
                render "ERROR*Ha ocurrido un error al eliminar Test"
                return
            }
        } else {
            render "ERROR*No se encontró Test."
            return
        }
    } //delete para eliminar via ajax
    
    /**
     * Acción llamada con ajax que valida que no se duplique la propiedad codigo
     * @render boolean que indica si se puede o no utilizar el valor recibido
     */
    def validar_unique_codigo_ajax() {
        params.codigo = params.codigo.toString().trim()
        if (params.id) {
            def obj = Test.get(params.id)
            if (obj.codigo.toLowerCase() == params.codigo.toLowerCase()) {
                render true
                return
            } else {
                render Test.countByCodigoIlike(params.codigo) == 0
                return
            }
        } else {
            render Test.countByCodigoIlike(params.codigo) == 0
            return
        }
    }
        
    /**
     * Acción llamada con ajax que valida que no se duplique la propiedad email
     * @render boolean que indica si se puede o no utilizar el valor recibido
     */
    def validar_unique_email_ajax() {
        params.email = params.email.toString().trim()
        if (params.id) {
            def obj = Test.get(params.id)
            if (obj.email.toLowerCase() == params.email.toLowerCase()) {
                render true
                return
            } else {
                render Test.countByEmailIlike(params.email) == 0
                return
            }
        } else {
            render Test.countByEmailIlike(params.email) == 0
            return
        }
    }
        
    /**
     * Acción llamada con ajax que valida que no se duplique la propiedad login
     * @render boolean que indica si se puede o no utilizar el valor recibido
     */
    def validar_unique_login_ajax() {
        params.login = params.login.toString().trim()
        if (params.id) {
            def obj = Test.get(params.id)
            if (obj.login.toLowerCase() == params.login.toLowerCase()) {
                render true
                return
            } else {
                render Test.countByLoginIlike(params.login) == 0
                return
            }
        } else {
            render Test.countByLoginIlike(params.login) == 0
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
            def obj = Test.get(params.id)
            if (obj.mail.toLowerCase() == params.mail.toLowerCase()) {
                render true
                return
            } else {
                render Test.countByMailIlike(params.mail) == 0
                return
            }
        } else {
            render Test.countByMailIlike(params.mail) == 0
            return
        }
    }
        
}
