package vesta.seguridad
/*Usuario del sistema*/
/**
 * Clase para conectar con la tabla 'prsn' de la base de datos<br/>
 * Usuario del sistema
 */
class Persona implements Serializable {
    /**
     * Cédula de la persona
     */
    String cedula
    /**
     * Nombre de la persona
     */
    String nombre
    /**
     * Apellido de la persona
     */
    String apellido
    /**
     * Sexo de la persona
     */
    String sexo
    /**
     * Indica si la persona es o no discapacitada (S para sí, N para no)
     */
    String discapacitado
    /**
     * Fecha de nacimiento de la persona
     */
    Date fechaNacimiento
    /**
     * Dirección de la persona
     */
    String direccion
    /**
     * Número de teléfono de la persona
     */
    String telefono
    /**
     * Dirección de e-mail de la persona
     */
    String mail
    /**
     * Número de fax de la persona
     */
    String fax
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
        table 'prsn'
        sort 'apellido'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'prsn__id'
        id generator: 'identity'
        version false
        columns {
            id column: 'prsn__id'
            cedula column: 'prsncdla'
            nombre column: 'prsnnmbr'
            apellido column: 'prsnapll'
            sexo column: 'prsnsexo'
            discapacitado column: 'prsndscp'
            fechaNacimiento column: 'prsnfcna'
            direccion column: 'prsndire'
            telefono column: 'prsntelf'
            mail column: 'prsnmail'
            fax column: 'prsnfaxx'
            observaciones column: 'prsnobsr'
        }
    }

    /**
     * Define las restricciones de cada uno de los campos
     */
    static constraints = {
        cedula(matches: /^[0-2]{1}[0-9]{9}$/, size: 1..13, blank: false, attributes: ['mensaje': 'Número de cédula de identidad de la persona'])
        nombre(matches: /^[a-zA-ZñÑ áéíóúÁÉÍÚÓüÜ-]+$/, size: 1..40, blank: false, attributes: ['mensaje': 'Nombre de la persona'])
        apellido(matches: /^[a-zA-ZñÑ áéíóúÁÉÍÚÓüÜ-]+$/, size: 1..40, blank: false, attributes: ['mensaje': 'Apellido de la persona'])
        sexo(inList: ["F", "M"], size: 1..1, blank: false, attributes: ['mensaje': 'Sexo de la persona'])
        discapacitado(matches: /^[0-1]{1}$/, size: 1..1, blank: true, nullable: true, attributes: ['mensaje': 'Si la persona es discapacitadad o no'])
        fechaNacimiento(max: new Date(), blank: true, nullable: true, attributes: ['mensaje': 'Fecha de nacimiento de la persona'])
        direccion(matches: /^[a-zA-Z0-9ñÑ .,áéíóúÁÉÍÚÓüÜ#_-]+$/, size: 1..127, blank: true, nullable: true, attributes: ['mensaje': 'Dirección de la persona'])
        telefono(size: 1..10, blank: true, nullable: true, attributes: ['mensaje': 'Teléfono de la persona'])
        mail(email: true, size: 1..40, blank: true, nullable: true, attributes: ['mensaje': 'E-mail de la persona'])
        fax(size: 1..40, blank: true, nullable: true, attributes: ['mensaje': 'Fax de la persona'])
        observaciones(matches: /^[a-zA-Z0-9ñÑ .,áéíóúÁÉÍÚÓüÜ#_-]+$/, size: 1..127, blank: true, nullable: true, attributes: ['mensaje': 'Observaciones adicionales'])
    }

    /**
     * Genera un string para mostrar
     * @return el nombre y el apellido concatenado
     */
    String toString() {
        "${this.nombre} ${this.apellido}"
    }
}