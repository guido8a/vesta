package vesta.parametros

/**
 * Clase para conectar con la tabla 'entd' de la base de datos
 */
class Entidad implements Serializable {
    /**
     * Nombre de la entidad
     */
    String nombre
    /**
     * Dirección de la entidad
     */
    String direccion
    /**
     * Sigla de la entidad
     */
    String sigla
    /**
     * Objetivo de la entidad
     */
    String objetivo
    /**
     * Número de teléfono de la entidad
     */
    String telefono
    /**
     * Número de fax de la entidad
     */
    String fax
    /**
     * Dirección de e-mail de la entidad
     */
    String email
    /**
     * Observaciones
     */
    String observaciones

    /**
     * Define los campos que se van a ignorar al momento de hacer logs
     */
    static auditable = [ignore: []]

    /**
     * Define el mapeo entre los campos del dominio y las columnas de la base de datos
     */
    static mapping = {
        table 'entd'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'entd__id'
        id generator: 'identity'
        version false
        columns {
            id column: 'entd__id'
            nombre column: 'entdnmbr'
            direccion column: 'entddire'
            sigla column: 'entdsgla'
            objetivo column: 'entdobjt'
            telefono column: 'entdtelf'
            fax column: 'entdfaxx'
            email column: 'entdmail'
            observaciones column: 'entdobsr'
        }
    }

    /**
     * Define las restricciones de cada uno de los campos
     */
    static constraints = {
        nombre(size: 1..63, blank: false, attributes: [mensaje: 'Nombre de la entidad o ministerio'])
        direccion(size: 1..127, blank: true, nullable: true, attributes: [mensaje: 'Dirección de la entidad o ministerio'])
        sigla(size: 1..7, blank: true, nullable: true, attributes: [mensaje: 'Sigla identificativa'])
        objetivo(size: 1..63, blank: true, nullable: true, attributes: [mensaje: 'Objetivo institucional o de la entidad'])
        telefono(size: 1..63, blank: true, nullable: true, attributes: [mensaje: 'Teléfonos, se los separa con “;”'])
        fax(size: 1..63, blank: true, nullable: true, attributes: [mensaje: 'Números de fax, se los separa con “;”'])
        email(size: 1..63, blank: true, nullable: true, attributes: [mensaje: 'Dirección de correo electrónico institucional'])
        observaciones(size: 1..127, blank: true, nullable: true, attributes: [mensaje: 'Observaciones'])
    }

    /**
     * Genera un string para mostrar
     * @return el nombre
     */
    String toString() {
        return this.nombre
    }
}