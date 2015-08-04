package vesta.parametros

/**
 * Clase para conectar con la tabla 'lclz' de la base de datos
 */
class Localizacion {

    /**
     * Código de la localización
     */
    String codigo
    /**
     * Descripción de la localización
     */
    String descripcion

    /**
     * Define los campos que se van a ignorar al momento de hacer logs
     */
    static auditable = [ignore: []]

    /**
     * Define el mapeo entre los campos del dominio y las columnas de la base de datos
     */
    static mapping = {
        table 'lclz'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'lclz__id'
        id generator: 'identity'
        version false
        columns {
            codigo column: 'lclzcdgo'
            descripcion column: 'lclzdscr'
        }
    }

    /**
     * Define las restricciones de cada uno de los campos
     */
    static constraints = {
        codigo maxSize: 4
        descripcion maxSize: 511
    }

    /**
     * Genera un string para mostrar
     * @return la descripción
     */
    String toString() {
        return this.descripcion
    }
}
