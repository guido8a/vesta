package vesta.proyectos

import vesta.modificaciones.DetalleReforma
import vesta.modificaciones.Reforma
import vesta.parametros.UnidadEjecutora
import vesta.poa.Asignacion
import vesta.seguridad.Firma
import vesta.seguridad.Persona

/*La modificación de la asignación presupuestaria se refiere a la redistribución del valor asignado lo cual implica además una reprogramación.*/
/**
 * Clase para conectar con la tabla 'mdas' de la base de datos<br/>
 * La modificación de la asignación presupuestaria se refiere a la redistribución del valor asignado
 * lo cual implica además una reprogramación
 */
class ModificacionAsignacion {
    /**
     * Usuario que realiza la modificacion
     */
    Persona usuario
    /**
     * Asignación que envía
     */
    Asignacion desde
    /**
     * Asignación que recibe
     */
    Asignacion recibe
    /**
     * Modificación proyecto
     */
    ModificacionProyecto modificacionProyecto
    /**
     * Fecha
     */
    Date fecha
    /**
     * Valor
     */
    double valor
    /**
     * Path al archivo PDF
     */
    String pdf
    /**
     * Unidad ejecutora
     */
    UnidadEjecutora unidad
    /**
     * Primera firma de aprobación
     */
    Firma firma1
    /**
     * Segunda firma de aprobación
     */
    Firma firma2
    /**
     * Estado: P = pendiente, A = aprobado
     */
    String estado = 'P'
    /**
     * Numero de la modificacion
     */
    Integer numero = 0
    /**
     * Texto para el pdf
     */
    String textoPdf
    /**
     * Detalle de reforma que originó esta modificación
     */
    DetalleReforma detalleReforma
    /**
     * Valor inicial de la asignación de origen
     */
    Double originalOrigen = 0
    /**
     * Valor inicial de la asignación de destino
     */
    Double originalDestino = 0

    /**
     * Define los campos que se van a ignorar al momento de hacer logs
     */
    static auditable = [ignore: []]

    /**
     * Define el mapeo entre los campos del dominio y las columnas de la base de datos
     */
    static mapping = {
        table 'mdas'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'mdas__id'
        id generator: 'identity'
        version false
        columns {
            id column: 'mdas__id'
            usuario column: 'prsn__id'
            desde column: 'asgndsde'
            recibe column: 'asgnrcbe'
            modificacionProyecto column: 'mdfc__id'
            fecha column: 'mdasfcha'
            valor column: 'mdasvlor'
            unidad column: 'unej__id'
            firma1 column: 'frma_id1'
            firma2 column: 'frma_id2'
            estado column: 'mdasetdo'
            numero column: 'mdasnmro'
            textoPdf column: 'mdastxpd'
            textoPdf type: 'text'
            detalleReforma column: 'dtrf__id'
            originalOrigen column: 'mdasoror'
            originalDestino column: 'mdasords'
        }
    }

    /**
     * Define las restricciones de cada uno de los campos
     */
    static constraints = {
        desde(blank: true, nullable: true, attributes: [mensaje: 'Asignación desde donde sale dinero'])
        recibe(blank: true, nullable: true, attributes: [mensaje: 'Asignación que recibe el dinero'])
        modificacionProyecto(blank: true, nullable: true, attributes: [mensaje: 'Modificación'])
        fecha(blank: true, nullable: true, attributes: [mensaje: 'Fecha'])
        valor(blank: true, nullable: true, attributes: [mensaje: 'Valor redistribuido, siempre en positivo'])
        pdf(blank: true, nullable: true, size: 1..250)
        unidad(blank: true, nullable: true)
        firma1(blank: true, nullable: true)
        firma2(blank: true, nullable: true)
        estado(blank: true, nullable: true, maxSize: 1)
        textoPdf(blank: true, nullable: true)
        usuario(blank: true, nullable: true)
    }
}