package vesta.proyectos

import vesta.parametros.CodigoComprasPublicas
import vesta.parametros.Unidad
import vesta.parametros.poaPac.TipoCompra
import vesta.poa.Asignacion

/*Para cada actividad asignada un presupuesto, se registra el plan anual de compras como obras a alcanzar, ejecutar o productos a adquirir.*/
/**
 * Clase para conectar con la tabla 'obra' de la base de datos<br/>
 * Para cada actividad asignada a un presupuesto, se registra el plan anual de compras como obras a alcanzar, ejecutar o productos a adquirir
 */
class Obra implements Serializable {
    /**
     * Unidad de la obra
     */
    Unidad unidad
    /**
     * Código de compras públicas de la obra
     */
    CodigoComprasPublicas codigoComprasPublicas
    /**
     * Tipo de compra
     */
    TipoCompra tipoCompra
    /**
     * Asignación de la obra
     */
    Asignacion asignacion
    /**
     * Obra padre de la obra actual
     */
    Obra obra
    /**
     * Modificaci&oacutel;n de proyecto
     */
    ModificacionProyecto modificacionProyecto
    /**
     * Descripción de la obra
     */
    String descripcion
    /**
     * Cantidad
     */
    double cantidad
    /**
     * Costo de la obra
     */
    double costo
    /**
     * Indica si está o no en el primer cuatrimestre (S: sí)
     */
    String cuatrimestre1
    /**
     * Indica si está o no en el segundo cuatrimestre (S: sí)
     */
    String cuatrimestre2
    /**
     * Indica si está o no en el tercer cuatrimestre (S: sí)
     */
    String cuatrimestre3
    /**
     * Valor de ejecución de la obra
     */
    double ejecucion
    /**
     * Estado de la obra
     */
    String estado
    /**
     * Fecha de inicio de la obra
     */
    Date fechaInicio
    /**
     * Fecha de fin de la obra
     */
    Date fechaFin
    /**
     * Observaciones
     */
    String observaciones
    /**
     * Indica si tiene o no certificado (S: sí, N: no)
     */
    String certificado    /* S--> si    N--> no*/
    /**
     * Fecha del certificado
     */
    Date fechaCertificado

    /**
     * Define los campos que se van a ignorar al momento de hacer logs
     */
    static auditable = [ignore: []]

    /**
     * Define el mapeo entre los campos del dominio y las columnas de la base de datos
     */
    static mapping = {
        table 'obra'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'obra__id'
        id generator: 'identity'
        version false
        columns {
            id column: 'obra__id'
            unidad column: 'undd__id'
            codigoComprasPublicas column: 'cpac__id'
            tipoCompra column: 'tpcp__id'
            asignacion column: 'asgn__id'
            obra column: 'obrapdre'
            modificacionProyecto column: 'mdfc__id'
            descripcion column: 'obradscr'
            cantidad column: 'obracntd'
            costo column: 'obracsto'
            cuatrimestre1 column: 'obractr1'
            cuatrimestre2 column: 'obractr2'
            cuatrimestre3 column: 'obractr3'
            ejecucion column: 'obraejec'
            estado column: 'obraetdo'
            fechaInicio column: 'obrafcin'
            fechaFin column: 'obrafcfn'
            observaciones column: 'obraobsr'
            certificado column: 'obracrtf'
            fechaCertificado column: 'obrafccr'
        }
    }

    /**
     * Define las restricciones de cada uno de los campos
     */
    static constraints = {
        unidad(blank: true, nullable: true, attributes: [mensaje: 'Unidad de medida'])
        codigoComprasPublicas(blank: true, nullable: true, attributes: [mensaje: 'Código de Compras Públicas'])
        tipoCompra(blank: true, nullable: true, attributes: [mensaje: 'Tipo de Compra'])
        asignacion(blank: true, nullable: true, attributes: [mensaje: 'Asignación presupuestaria a la actividad'])
        obra(blank: true, nullable: true, attributes: [mensaje: 'Registro original de la obra'])
        modificacionProyecto(blank: true, nullable: true, attributes: [mensaje: 'Documento de modificación con el que se modifica o crea un nuevo registro'])
        descripcion(size: 1..255, blank: true, nullable: true, attributes: [mensaje: 'Descripción del producto, bien o servicio a adquirir'])
        cantidad(blank: true, nullable: true, attributes: [mensaje: 'Cantidad'])
        costo(blank: true, nullable: true, attributes: [mensaje: 'Costo unitario'])
        cuatrimestre1(size: 1..1, blank: true, nullable: true, attributes: [mensaje: 'A ejecutarse en el cuatrimestre 1 S/N'])
        cuatrimestre2(size: 1..1, blank: true, nullable: true, attributes: [mensaje: 'A ejecutarse en el cuatrimestre 2 S/N'])
        cuatrimestre3(size: 1..1, blank: true, nullable: true, attributes: [mensaje: 'A ejecutarse en el cuatrimestre 3 S/N'])
        ejecucion(blank: true, nullable: true, attributes: [mensaje: 'Ejecución'])
        estado(size: 1..1, blank: true, nullable: true, attributes: [mensaje: 'Estado'])
        fechaInicio(blank: true, nullable: true, attributes: [mensaje: 'Fecha de Inicio'])
        fechaFin(blank: true, nullable: true, attributes: [mensaje: 'Fecha de Fin'])
        observaciones(size: 1..127, blank: true, nullable: true, attributes: [mensaje: 'Observaciones'])
        certificado(size: 1..1, nullable: true, blank: true)
        fechaCertificado(blank: true, nullable: true)
    }
}