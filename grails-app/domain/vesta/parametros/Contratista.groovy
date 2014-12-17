package vesta.parametros

/**
 * Clase para conectar con la tabla 'cntr' de la base de datos
 */
class Contratista {
    /**
     * Dirección del contratista
     */
    String direccion
    /**
     * Ruc del contratista
     */
    String ruc
    /**
     * Fecha de creación del contratista
     */
    Date fecha
    /**
     * Nombre de contacto del contratista
     */
    String nombreCont
    /**
     * Nombre del contratista
     */
    String nombre
    /**
     * Apellido del contratista
     */
    String apellido
    /**
     * Direción e-mail del contratista
     */
    String mail
    /**
     * Observaciones
     */
    String observaciones
    /**
     * Estado
     */
    String estado
    /**
     * Teléfono del contratista
     */
    String telefono

    /**
     * Define los campos que se van a ignorar al momento de hacer logs
     */
    static auditable = [ignore: []]

    /**
     * Define el mapeo entre los campos del dominio y las columnas de la base de datos
     */
    static mapping = {
        table 'cntr'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'cntr__id'
        id generator: 'identity'
        version false
        columns {
            id column: 'cntr__id'
            ruc column: 'cntr_ruc'
            direccion column: 'cntrdire'
            fecha column: 'cntrfech'
            nombreCont column: 'cntrnbct'
            nombre column: 'cntrnmbr'
            apellido column: 'cntrapll'
            mail column: 'cntrmail'
            observaciones column: 'cntrobsv'
            estado column: 'cntretdo'
            telefono column: 'cntrtlfn'
        }
    }

    /**
     * Define las restricciones de cada uno de los campos
     */
    static constraints = {
        ruc(size: 1..13, blank: false, nullable: false, attributes: [mensaje: 'Ruc del Contratista'])
        direccion(size: 1..255, blank: true, nullable: true, attributes: [mensaje: 'Direccion del Contratista'])
        fecha(max: new Date(), blank: true, nullable: true, attributes: [mensaje: 'Fecha'])
        nombreCont(size: 1..63, blank: true, nullable: true, attributes: [mensaje: 'Nombre del Contratista'])
        nombre(size: 1..63, blank: false, nullable: false, attributes: [mensaje: 'Nombre'])
        apellido(size: 1..63, blank: true, nullable: true, attributes: [mensaje: 'Apellido'])
        observaciones(size: 1..255, blank: true, nullable: true, attributes: [mensaje: 'Observaciones'])
        telefono(size: 1..40, blank: true, nullable: true, attributes: [mensaje: 'Telefono del Contratista'])
        mail(size: 1..40, blank: true, nullable: true, attributes: [mensaje: 'Mail'])
        estado(blank: true, nullable: true, attributes: [mensaje: 'Estado del Contratista'])
    }
}
