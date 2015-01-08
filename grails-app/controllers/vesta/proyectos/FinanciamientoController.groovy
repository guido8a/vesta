package vesta.proyectos

import org.springframework.dao.DataIntegrityViolationException
import vesta.parametros.poaPac.Anio
import vesta.parametros.poaPac.Fuente
import vesta.seguridad.Shield


/**
 * Controlador que muestra las pantallas de manejo de Financiamiento
 */
class FinanciamientoController extends Shield {

    static allowedMethods = [save_ajax: "POST", delete_ajax: "POST"]

    /**
     * Acción llamada con ajax que muestra y permite modificar los financiamientos de un proyecto
     */
    def list_ajax() {
        def proyecto = Proyecto.get(params.id)
        return [proyecto: proyecto]
    }

    /**
     * Acción llamada con ajax que llena la tabla de los financiamientos de un proyecto
     */
    def tablaFinanciamientosProyecto_ajax() {
        def proyecto = Proyecto.get(params.id)

        def financiamientos = Financiamiento.withCriteria {
            eq("proyecto", proyecto)
            anio {
                order("anio", "asc")
            }
            fuente {
                order("descripcion", "asc")
            }
        }

        return [proyecto: proyecto, financiamientos: financiamientos]
    }

    /**
     * Acción llamada con ajax que guarda un nuevo financiamiento de un proyecto
     */
    def save_ajax() {
        def proyecto = Proyecto.get(params.id.toLong())
        def anio = Anio.get(params.anio.toLong())
        def fuente = Fuente.get(params.fuente.toLong())

        def financiamientos = Financiamiento.withCriteria {
            eq("proyecto", proyecto)
            eq("anio", anio)
            eq("fuente", fuente)
        }
        def financiamiento
        if (financiamientos.size() == 0) {
            financiamiento = new Financiamiento()
        } else if (financiamientos.size() == 1) {
            financiamiento = financiamientos.first()
        } else {
            financiamiento = financiamientos.first()
            println "Existen ${financiamientos.size()} financiamientos............"
        }
        financiamiento.proyecto = proyecto
        financiamiento.anio = anio
        financiamiento.fuente = fuente
        financiamiento.monto = params.monto.toDouble()
        if (financiamiento.save(flush: true)) {
            render "SUCCESS*Financiamiento agregado*" + financiamiento.id
        } else {
            "ERROR*" + renderErrors(bean: financiamiento)
        }
    }

    /**
     * Acción llamada con ajax que permite eliminar un elemento
     * @render ERROR*[mensaje] cuando no se pudo eliminar correctamente, SUCCESS*[mensaje] cuando se eliminó correctamente
     */
    def delete_ajax() {
        if (params.id) {
            def financiamientoInstance = Financiamiento.get(params.id)
            if (!financiamientoInstance) {
                render "ERROR*No se encontró Financiamiento."
                return
            }
            try {
                financiamientoInstance.delete(flush: true)
                render "SUCCESS*Eliminación de Financiamiento exitosa."
                return
            } catch (DataIntegrityViolationException e) {
                render "ERROR*Ha ocurrido un error al eliminar Financiamiento"
                return
            }
        } else {
            render "ERROR*No se encontró Financiamiento."
            return
        }
    } //delete para eliminar via ajax
}
