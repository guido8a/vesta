package vesta.proyectos
/**
 * Clase para conectar con la tabla 'idsp' de la base de datos
 */
class IndicadoresSenplades   {
    /**
     * Proyecto del indicador
     */
    Proyecto proyecto
    /**
     * Valor de la tasa de análisis financiero del indicador
     */
    double tasaAnalisisFinanciero
    /**
     * Valor actual neto del indicador
     */
    double valorActualNeto
    /**
     * Valor de la tasa interna de retorno del indicador
     */
    double tasaInternaDeRetorno
    /**
     * Valor de la tasa de análisis económico del indicador
     */
    double tasaAnalisisEconomico
    /**
     * Valor actual neto económico del indicador
     */
    double valorActualNetoEconomico
    /**
     * Valor de la tasa interna de retorno económico del indicador
     */
    double tasaInternaDeRetornoEconomico
    /**
     * Valor del costo beneficio del indicador
     */
    double costoBeneficio
    /**
     * Pierde país
     */
    String pierdePais
    /**
     * Impactos del indicador
     */
    String impactos
    /**
     * Metodología del indicador
     */
    String metodologia
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
        table 'idsp'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'idsp__id'
        id generator: 'identity'
        version false
        columns {
            id column: 'idsp__id'
            proyecto column: 'proy__id'
            tasaAnalisisFinanciero column: 'idsptsfn'
            valorActualNeto column: 'idspvnfn'
            tasaInternaDeRetorno column: 'idsptrfn'
            tasaAnalisisEconomico column: 'idsptsec'
            valorActualNetoEconomico column: 'idspvnec'
            tasaInternaDeRetornoEconomico column: 'idsptrec'
            costoBeneficio column: 'idspcsbn'
            pierdePais column: 'idspprdd'
            impactos column: 'idspimpt'
            metodologia column: 'idspmeto'
            observaciones column: 'idspobsr'
        }
    }

    /**
     * Define las restricciones de cada uno de los campos
     */
    static constraints = {
        proyecto(blank: true, nullable: true, attributes: [mensaje: 'Proyecto'])
        tasaAnalisisFinanciero(blank: true, nullable: true, attributes: [mensaje: 'Tasa de Análisis Financiero'])
        valorActualNeto(blank: true, nullable: true, attributes: [mensaje: 'Valor actual neto del análisis financiero'])
        tasaInternaDeRetorno(blank: true, nullable: true, attributes: [mensaje: 'Tasa interna de retorno del análisis financiero'])
        tasaAnalisisEconomico(blank: true, nullable: true, attributes: [mensaje: 'Tasa de análisis económico'])
        valorActualNetoEconomico(blank: true, nullable: true, attributes: [mensaje: 'Valor actual neto análisis económico'])
        tasaInternaDeRetornoEconomico(blank: true, nullable: true, attributes: [mensaje: 'Tasa interna de retorno del análisis económico'])
        costoBeneficio(blank: true, nullable: true, attributes: [mensaje: 'Relación costo beneficio '])
        pierdePais(size: 1..1023, blank: true, nullable: true, attributes: [mensaje: 'Lo que pierde el país si el proyecto no se ejecuta'])
        impactos(size: 1..1023, blank: true, nullable: true, attributes: [mensaje: 'Resultados e impactos esperados del proyecto'])
        metodologia(size: 1..1023, blank: true, nullable: true, attributes: [mensaje: 'Metodología para determinar el retorno del proyecto'])
        observaciones(size: 1..1023, blank: true, nullable: true, attributes: [mensaje: 'Observaciones'])
    }
}