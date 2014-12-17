package vesta.proyectos

import yachay.parametros.TipoModificacion
import yachay.parametros.UnidadEjecutora
import yachay.parametros.poaPac.Anio
import yachay.seguridad.Usro

/**
 * Clase para conectar con la tabla 'mdfc' de la base de datos
 */
class ModificacionProyecto implements Serializable {
    /**
     * Informe de la modificación de proyecto
     */
    Informe informe
    /**
     * Tipo de modificación de proyecto
     */
    TipoModificacion tipoModificacion
    /**
     * Proyecto de la modificación de proyecto
     */
    Proyecto proyecto
    /**
     * Unidad ejecutora de la modificación de proyecto
     */
    UnidadEjecutora unidad
    /**
     * Valor de la modificación de proyecto
     */
    double valor
    /**
     * DEscripción de la modificación de proyecto
     */
    String descripcion
    /**
     * Fecha de la modificación de proyecto
     */
    Date fecha
    /**
     * Fecha de aprobación de la modificación de proyecto
     */
    Date fechaAprobacion
    /**
     * Usuario que solicita la modificación de proyecto
     */
    Usro solicitante
    /**
     * Usuario responsable de la modificación de proyecto
     */
    Usro responsable
    /**
     * Estado de la modificación de proyecto (0: solicitada, 1: negada, 2: aprobada, 3: usada)
     */
    int estado = 0 /* 0 -> solicitada | 1-> negada | 2-> aprobada  | 3-> usada*/
    /**
     * Observaciones
     */
    String observaciones
    /**
     * Año de la modificación de proyecto
     */
    Anio anio

    /**
     * Define los campos que se van a ignorar al momento de hacer logs
     */
    static auditable = [ignore: []]

    /**
     * Define el mapeo entre los campos del dominio y las columnas de la base de datos
     */
    static mapping = {
        table 'mdfc'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'mdfc__id'
        id generator: 'identity'
        version false
        columns {
            id column: 'mdfc__id'
            informe column: 'info__id'
            tipoModificacion column: 'tpmd__id'
            proyecto column: 'proy__id'
            unidad column: 'unej__id'
            valor column: 'mdfcvlor'
            descripcion column: 'mdfcdscr'
            fecha column: 'mdfcfcha'
            fechaAprobacion column: 'mdfcfcap'
            observaciones column: 'mdfcobsr'
            responsable column: 'usro__id'
            estado column: 'mdfcetdo'
            anio column: 'anio__id'
            solicitante column: 'usroslct'
        }
    }

    /**
     * Define las restricciones de cada uno de los campos
     */
    static constraints = {
        informe(blank: true, nullable: true, attributes: [mensaje: 'Informe correspondiente que genera la modificación'])
        tipoModificacion(blank: true, nullable: true, attributes: [mensaje: 'Tipo de Modificación'])
        proyecto(blank: true, nullable: true)
        unidad(blank: true, nullable: true)
        valor(blank: true, nullable: true, attributes: [mensaje: 'Valor de la modificación si se trata de modificación en la inversión para actividades del marco lógico'])
        descripcion(size: 1..1023, blank: true, nullable: true, attributes: [mensaje: 'Descripción de la modificación de acuerdo a su tipo'])
        fecha(blank: true, nullable: true, attributes: [mensaje: 'Fecha de la modificación'])
        fechaAprobacion(blank: true, nullable: true, attributes: [mensaje: 'Fecha de aprobación de la modificación'])
        observaciones(size: 1..127, blank: true, nullable: true, attributes: [mensaje: 'Observaciones'])
        estado(nullable: false, blank: false)
        responsable(nullable: true, blank: true)
        solicitante(nullable: true, blank: true)
        anio(nullable: true, blank: true)
    }
}