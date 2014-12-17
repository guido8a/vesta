package vesta.proyectos

import yachay.parametros.TipoDocumento

/**
 * Clase para conectar con la tabla 'docp' de la base de datos
 */
class DocumentoProceso {
    /**
     * Liquidación
     */
    Liquidacion liquidacion
    /**
     * Tipo de documento
     */
    TipoDocumento tipo
    /**
     * Descripción
     */
    String descripcion
    /**
     * Palabras clave
     */
    String clave
    /**
     * Resumen
     */
    String resumen
    /**
     * Path del archivo subido
     */
    String documento

    /**
     * Define los campos que se van a ignorar al momento de hacer logs
     */
    static auditable = [ignore: []]

    /**
     * Define el mapeo entre los campos del dominio y las columnas de la base de datos
     */
    static mapping = {
        table 'docp'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'docp__id'
        id generator: 'identity'
        version false
        columns {
            id column: 'docp__id'
            liquidacion column: 'lqdc__id'
            tipo column: 'tpdc__id'
            descripcion column: 'dcmtdscr'
            clave column: 'dcmtclve'
            resumen column: 'dcmtrsmn'
            documento column: 'dcmtdcmt'
        }
    }

    /**
     * Define las restricciones de cada uno de los campos
     */
    static constraints = {
        liquidacion(nullable: false, blank: false)
        descripcion(size: 1..63, blank: true, nullable: true, attributes: [mensaje: 'Descripción del documento'])
        tipo(nullable: false, blank: false, attributes: [mensaje: 'Tipo del documento'])
        clave(size: 1..63, blank: true, nullable: true, attributes: [mensaje: 'Palabras clave'])
        resumen(size: 1..1024, blank: true, nullable: true, attributes: [mensaje: 'Resumen'])
        documento(size: 1..255, blank: true, nullable: true, attributes: [mensaje: 'Ruta del documento'])
    }

    /**
     * Genera un string para mostrar
     * @return la descripción
     */
    String toString() {
        return this.descripcion
    }
}
