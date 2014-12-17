package vesta.parametros.geografia

import yachay.proyectos.Meta

/**
 * Clase para conectar con la tabla 'prov' de la base de datos<br/>
 * Guarda la lista de provincias
 */
class Provincia implements Serializable {
    /**
     * Zona a la cual pertenece la provincia
     */
    Zona zona
    /**
     * Región a la cual pertenece la provincia
     */
    Region region
    /**
     * Número de provincia
     */
    Integer numero
    /**
     * Nombre de la provincia
     */
    String nombre
    /**
     * Nombre para mostrar de la provincia
     */
    String nombreMostrar
    /**
     * Coordenadas de la provincia
     */
    String coords
    /**
     * Path del archivo de la imagen de la provincia
     */
    String imagen

    /**
     * Código de la provincia
     */
    String codigo

    /**
     * Posición geográfica de la provincia (longitud para ubicar en un mapa)
     */
    double longitud
    /**
     * Posición geográfica de la provincia (latitud para ubicar en un mapa)
     */
    double latitud

    /**
     * Diff
     */
    double diff
    /**
     * Zoom del mapa al mostrar la provincia
     */
    double zoom

    /**
     * Define los campos que se van a ignorar al momento de hacer logs
     */
    static auditable = [ignore: []]
    /**
     * Define el mapeo entre los campos del dominio y las columnas de la base de datos
     */
    static mapping = {
        table 'prov'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'prov__id'
        id generator: 'identity'
        version false
        columns {
            id column: 'prov__id'
            zona column: 'zona__id'
            region column: 'regn__id'
            numero column: 'provnmro'
            nombre column: 'provnmbr'
            nombreMostrar column: 'provnmms'
            coords column: 'provcrds'
            imagen column: 'provimgn'

            codigo column: 'provcdgo'

            longitud column: 'provlong'
            latitud column: 'provlatt'

            diff column: 'provdiff'
            zoom column: 'provzoom'
        }
    }

    /**
     * Define las restricciones de cada uno de los campos
     */
    static constraints = {
        zona(blank: true, nullable: true, attributes: [mensaje: 'Zona a la que pertenece la provincia'])
        region(blank: true, nullable: true, attributes: [mensaje: 'Región a la que pertenece la provincia'])
        numero(blank: true, nullable: true, attributes: [mensaje: 'Número de la provincia'])
        nombre(size: 1..63, blank: true, nullable: true, attributes: [mensaje: 'Nombre de la provincia'])
        nombreMostrar(size: 1..63, blank: true, nullable: true, attributes: [mensaje: 'Nombre de la provincia como se va a ver en el mapa'])
        coords(maxSize: 5000, blank: true, nullable: true, attributes: [mensaje: 'Coordenadas para el map'])
        imagen(maxSize: 1024, blank: true, nullable: true, attributes: [mensaje: 'Nombre del archivo del mapa de la provincia'])
        codigo(maxSize: 4, blank: true, nullable: true, attributes: [mensaje: 'Código de la provincia'])
    }

    /**
     * Genera un string para mostrar
     * @return el nombre
     */
    String toString() {
        return this.nombre
    }

    /**
     * Busca las metas de la provincia y sus coordenadas
     * @return un mapa: [metasCoords: las coordenadas de las metas, metasTotal: las metas]
     */
    def getMetas() {
        def metas = Meta.withCriteria {
            parroquia {
                canton {
                    eq("provincia", this)
                }
            }
        }

        def metasCoords = Meta.withCriteria {
            parroquia {
                canton {
                    eq("provincia", this)
                }
            }
            or {
                ne('latitud', 0.toDouble())
                ne('longitud', 0.toDouble())
            }
        }

        return [metasCoords: metasCoords, metasTotal: metas]
    }
}