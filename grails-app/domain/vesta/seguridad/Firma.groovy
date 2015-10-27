package vesta.seguridad
/**
 * Clase para controlar las fimas digitales
 */
class Firma {
    /**
     * Usuario que firma
     */
    Persona usuario
    /**
     * Fecha de firma
     */
    Date fecha
    /**
     *  Nombre de la acción
     */
    String accion
    /**
     *  Nombre del controlador
     */
    String controlador
    /**
     *  identificador pasado a la accion
     */
    String idAccion
    /**
     *  Nombre de la acción para ver el documento antes de firmar
     */
    String accionVer
    /**
     *  Nombre del controlador para ver el documento antes de firmar
     */
    String controladorVer
    /**
     *  identificador pasado a la accion para ver el documento antes de firmar
     */
    String idAccionVer
    /**
     *  Nombre de la acción para negar el documento
     */
    String accionNegar
    /**
     *  Nombre del controlador para negar el documento
     */
    String controladorNegar
    /**
     *  identificador pasado a la accion para negar el documento
     */
    String idAccionNegar
    /**
     *  nombre del documento
     */
    String documento
    /**
     *  path del codigo QR
     */
    String path
    /**
     *  llave de autentificacion
     */
    String key
    /**
     *  Concepto de la firma
     */
    String concepto
    /**
     * estado: S->solicitado F->firmado N-> negado
     */
    String estado = "S"
    /**
     * observaciones
     */
    String observaciones = "S"
    /**
     * determina si necesita pasar por el controlador de pdf S-> si N-> no
     */
    String esPdf = "S"

    /**
     * tipo de la firma
     */
    String tipoFirma

    /**
     * Define los campos que se van a ignorar al momento de hacer logs
     */
    static auditable = [ignore: []]

    /**
     * Define el mapeo entre los campos del dominio y las columnas de la base de datos
     */
    static mapping = {
        table 'frma'
        cache usage: 'read-write', include: 'non-lazy'
        version false
        id generator: 'identity'
        sort "fecha"
        columns {
            id column: 'frma__id'
            usuario column: 'prsn__id'
            fecha column: 'frmafcha'
            accion column: 'frmaaccn'
            controlador column: 'frmactrl'
            idAccion column: 'frmaidac'
            accionVer column: 'frmaaccv'
            controladorVer column: 'frmactrv'
            idAccionVer column: 'frmaidav'
            documento column: 'frmadocm'
            path column: 'frmapath'
            key column: 'frma_key'
            estado column: 'frmaetdo'
            concepto column: 'frmacnct'
            observaciones column: 'frmaobrs'
            esPdf column: 'frmaepdf'
            tipoFirma column: 'frmatipo'
            accionNegar column: 'frmaacng'
            controladorNegar column: 'frmactng'
            idAccionNegar column: 'frmaidng'
        }
    }
    static constraints = {
        usuario(blank: false, nullable: false)
        fecha(blank: true, nullable: true)
        accion(blank: true, nullable: true, size: 1..100)
        controlador(blank: true, nullable: true, size: 1..100)
        idAccion(blank: true, nullable: true, size: 1..10)
        documento(blank: true, nullable: true, size: 1..100)
        path(blank: true, nullable: true, size: 1..255)
        key(blank: true, nullable: true, size: 1..255)
        concepto(blank: true, nullable: true, size: 1..1023)
        observaciones(blank: true, nullable: true, size: 1..1023)
        estado(blank: false, nullable: false, size: 1..1)
        esPdf(blank: false, nullable: false, size: 1..1)
        accionVer(blank: true, nullable: true, size: 1..100)
        controladorVer(blank: true, nullable: true, size: 1..100)
        idAccionVer(blank: true, nullable: true, size: 1..10)
        tipoFirma(blank: true, nullable: true)
        accionNegar(blank: true, nullable: true)
        controladorNegar(blank: true, nullable: true)
        idAccionNegar(blank: true, nullable: true)
    }
}
