package vesta.seguridad

import vesta.parametros.CargoPersonal
import vesta.parametros.UnidadEjecutora

/**
 * Clase para conectar con la tabla 'usro' de la base de datos
 */
class Usro implements Serializable {
    /**
     * Persona
     */
    Persona persona
    /**
     * Cargo del usuario
     */
    CargoPersonal cargoPersonal
    /**
     * Unidad ejecutora del usuario
     */
    UnidadEjecutora unidad
    /**
     * Nombre de usuario del usuario
     */
    String usroLogin
    /**
     * Contraseña del usuario
     */
    String usroPassword
    /**
     * Autorización del usuario
     */
    String autorizacion
    /**
     * Sigla del usuario
     */
    String sigla
    /**
     * Indica si el usuario está o no activo
     */
    int usroActivo
    /**
     * Fecha de cambio de contraseña
     */
    Date fechaPass
    /**
     * Observaciones
     */
    String observaciones

    /**
     * Define las relaciones uno a varios
     */
    static hasMany = [sesiones: Sesn, accesos: Accs, alertas: vesta.alertas.Alerta]

    /**
     * Define los campos que se van a ignorar al momento de hacer logs
     */
    static auditable = [ignore: ['usroPassword']]

    /**
     * Define el mapeo entre los campos del dominio y las columnas de la base de datos
     */
    static mapping = {
        table 'usro'
        cache usage: 'read-write', include: 'non-lazy'
        version false
        id generator: 'identity'

        columns {
            id column: 'usro__id'
            persona column: 'prsn__id'
            cargoPersonal column: 'cgpr__id'
            usroLogin column: 'usrologn'
            usroPassword column: 'usropass'
            autorizacion column: 'usroatrz'
            sigla column: 'usrosgla'
            usroActivo column: 'usroactv'
            fechaPass column: 'usrofcps'
            observaciones column: 'usroobsr'
            unidad column: 'unej__id'
        }
    }

    /**
     * Define las restricciones de cada uno de los campos
     */
    static constraints = {
        persona(blank: false, nullable: false, attributes: [mensaje: 'Persona'], unique: true)
        cargoPersonal(blank: true, nullable: true, attributes: [mensaje: 'Cargo'])
        usroLogin(matches: /^[a-zA-Z0-9ñÑ .,áéíóúÁÉÍÚÓüÜ#_+-]{1,15}$/, size: 1..15, blank: false, nullable: false, unique: true, attributes: [mensaje: 'Nombre de usuario'])
        usroPassword(matches: /^[a-zA-Z0-9ñÑ .,áéíóúÁÉÍÚÓüÜ#_+-]+$/, size: 1..64, blank: false, nullable: false, attributes: [mensaje: 'Contraseña para el ingreso al sistema'])
        autorizacion(matches: /^[a-zA-Z0-9ñÑ .,áéíóúÁÉÍÚÓüÜ#_+-]+$/, size: 1..255, blank: false, nullable: false, attributes: [mensaje: 'Contraseña para autorizaciones'])
        sigla(matches: /^[a-zA-Z]{1,8}$/, size: 1..8, blank: false, nullable: false, attributes: [mensaje: 'Sigla del usuario'])
        usroActivo(matches: /^[0-1]{1}$/, size: 1..1, blank: false, nullable: false, attributes: [mensaje: 'Usuario activo o no'])
        fechaPass(blank: true, nullable: true, attributes: [mensaje: 'Fecha de cambio de contraseña'])
        observaciones(matches: /^[a-zA-Z0-9ñÑ .,áéíóúÁÉÍÚÓüÜ#_+-]+$/, size: 1..255, blank: true, nullable: true, attributes: [mensaje: 'Observaciones'])
        unidad(blank: true, nullable: true, attributes: [mensaje: 'Unidad Ejecutora a la que pertenece el usuario'])
    }

    /**
     * Genera un string para mostrar
     * @return el nombre de usuario
     */
    String toString() {
        return "${this.usroLogin}"
    }

}
