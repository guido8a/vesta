package vesta.proyectos
/**
 * Clase para conectar con la tabla 'paso' de la base de datos
 */
class Paso   {
    /**
     * Proceso del paso
     */
    Proceso proceso
    /**
     * Orden del paso
     */
    Integer orden
    /**
     * Nombre del paso
     */
    String nombre
    /**
     * Descripción del paso
     */
    String descripcion
    /**
     * Obligación del paso
     */
    String obligacion
    /**
     * Tabla del paso
     */
    String tabla
    /**
     * Estado del paso
     */
    String estado
    /**
     * Tabla Esp
     */
    String tablaEsp

    /**
     * Define los campos que se van a ignorar al momento de hacer logs
     */
    static auditable = [ignore: []]

    /**
     * Define el mapeo entre los campos del dominio y las columnas de la base de datos
     */
    static mapping = {
        table 'paso'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'paso__id'
        id generator: 'identity'
        version false
        columns {
            id column: 'paso__id'
            proceso column: 'prcs__id'
            orden column: 'pasoordn'
            nombre column: 'pasonmbr'
            descripcion column: 'pasodscr'
            obligacion column: 'pasooblg'
            tabla column: 'pasotbla'
            estado column: 'pasoetdo'

            tablaEsp column: 'pasotbes'
        }
    }

    /**
     * Define las restricciones de cada uno de los campos
     */
    static constraints = {
        id(attributes: [mensaje: 'Código secuencial del paso'])
        proceso(blank: true, nullable: true, attributes: [mensaje: 'Proceso'])
        orden(blank: true, nullable: true, attributes: [mensaje: 'Orden preestablecido o recomendado en el llenado de datos'])
        nombre(size: 1..63, blank: true, nullable: true, attributes: [mensaje: 'Nombre del paso'])
        descripcion(size: 1..255, blank: true, nullable: true, attributes: [mensaje: 'Descripción del paso'])
        obligacion(size: 1..1, blank: true, nullable: true, attributes: [mensaje: 'Paso obligatorio o no'])
        tabla(size: 1..127, blank: false, nullable: false, attributes: [mensaje: 'Tabla o tablas en las que se ingresan registros'])
        estado(size: 1..1, blank: true, nullable: true, attributes: [mensaje: 'Estado del paso'])
        tablaEsp(size: 1..127, blank: false, nullable: false, attributes: [mensaje: 'Nombre de la tabla o tablas en español, para mostrar'])
    }

    /**
     * Genera un string para mostrar
     * @return el nombre
     */
    String toString() {
        return this.nombre
    }
}