package vesta.hitos

class Hito {
    /*
     * Descripción
     */
    String descripcion
    /*
    * Fecha de creación
    */
    Date fecha
    /*
   * Fecha de cumplimiento
   */
    Date fechaCumplimiento

   /*
   * Fecha de esperada de inicio
   */
    Date inicio
    /*
  * Fecha de esperada de cumpliento
  */
    Date fechaPlanificada
  /*
  * Tipo de hito, financiero o físico
  */
    String tipo /*  I--> inicio  N--> no inicio  */
    /*
   * avance físico
   */
    double avanceFisico = 0
    /*
  * avance financiero
  */
    double avanceFinanciero = 0
    /**
   * Define el mapeo entre los campos del dominio y las columnas de la base de datos
   */
    static mapping = {
        table 'hito'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'hito__id'
        id generator: 'identity'
        version false
        columns {
            id column: 'cmht__id'
            descripcion column: 'hitodscr'
            fecha column: 'hitofcha'
            inicio column: 'hitofcin'
            fechaCumplimiento column: 'hitofccm'
            fechaPlanificada column: 'hitofcpl'
            avanceFisico column: 'hitoavfs'
            avanceFinanciero column: 'hitoavfi'
        }
    }
/**
 * Define las restricciones de cada uno de los campos
 */
    static constraints = {

        fecha(blank: false, nullable: false)
        fechaCumplimiento(blank: true, nullable: true)
        fechaPlanificada(blank: true, nullable: true)
        inicio(blank: true, nullable: true)
        descripcion(blank: false, nullable: false,size: 1..1024)
    }

    def getAvaneFisico(){
        def avance = 0
        def total = 0
        def comps = ComposicionHito.findAllByHito(this)
        if(comps.size()>0){
            total=comps.sum{it.getPriorizado()}
            println "total  hito "+total
        }else{
            return 0
        }
        comps.each {c->
            def representacion = c.getPriorizado()*100/total
            def avanceF=c.calcularAvanceFisico()
            println "comp "+c.id+" "+c.getPriorizado()+" representacion "+representacion+"  "+avanceF
            avance+=representacion*avanceF/100
            println "avance "+representacion*avanceF/100
        }
        println avance
        return avance
    }
}
