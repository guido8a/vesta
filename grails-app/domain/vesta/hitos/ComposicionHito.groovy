package vesta.hitos

import yachay.avales.ProcesoAval
import yachay.proyectos.MarcoLogico
import yachay.proyectos.Proyecto

class ComposicionHito  {
    /*
    * Hito
    */
    Hito hito
    /*
    * Proyecto
    */
    Proyecto proyecto
    /*
    * MArco lógico
    */
    MarcoLogico marcoLogico
    /*
    * Proceso
    */
    ProcesoAval proceso
    /*
    * Fecha de creación
    */
    Date fecha = new Date()
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
        table 'cmht'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'cmht__id'
        id generator: 'identity'
        version false
        columns {
            id column: 'cmht__id'
            hito column: 'hito__id'
            marcoLogico column: 'mrlg__id'
            proyecto column: 'proy__id'
            proceso column: 'poas__id'
            fecha column: 'cmhtfcha'
            avanceFisico column: 'cmhtavfs'
            avanceFinanciero column: 'cmhtavfi'
        }
    }
/**
 * Define las restricciones de cada uno de los campos
 */
    static constraints = {
        hito(blank: false, nullable: false)
        marcoLogico(blank: true, nullable: true)
        proyecto(blank: true, nullable: true)
        proceso(blank: true, nullable: true)
        fecha(blank: false, nullable: false)

    }

    def calcularAvanceFisico(){
        def avance = 0
        def tot = 0
        def avanceTotal = 0
        if(this.proyecto){
            println "--->proyecto!!!! "+this.proyecto
            def procesos = ProcesoAval.findAllByProyecto(this.proyecto)
            if(procesos.size()==0)
                return 0
            else{
                tot = procesos.sum{it.getMonto()}

                println "total procesos "+tot
                procesos.each {p->
                    avance=0
                    def representacion = p.getMonto()*100/tot
                    println "-----------------------"
                    println "proceso "+p.nombre+" representacion "+representacion
                    def avfs = AvanceFisico.findAllByProcesoAndCompletadoIsNotNull(p)
                    avfs.each {av->
                        avance+=av.avance
                    }
                    println "avance  "+(representacion*avance/100)
                    avanceTotal+=representacion*avance/100
                }
                avance=avanceTotal
            }


        }
        if(this.proceso){
            println "-->proceso!!!!"
            avance = this.proceso.avanceFisico
            println "avance  "+avance

        }
        if(this.marcoLogico){

            if(this.marcoLogico.tipoElemento.id==3){
                return this.marcoLogico.getAvanceFisico()
            }else{
                println "-->Componente!!!! "
                def totalP = this.marcoLogico.totalPriorizado
                println "total p "+totalP
                def acts = MarcoLogico.findAllByMarcoLogico(this.marcoLogico)
                def representcion = 0
                acts.each {a->
                    representcion = a.getTotalPriorizado()*100/totalP
                    def avanceA = a.getAvanceFisico()
                    println "representacion "+representcion+" avance "+avanceA
                    avance+= representcion*avanceA/100
                }

            }
        }
        println "return "+avance
        return avance
    }

    def getPriorizado(){
        if(this.proyecto){
            return this.proyecto.getValorPriorizado()
        }
        if(proceso){
            return this.proceso.monto
        }
        if(marcoLogico){
            return this.marcoLogico.getTotalPriorizado()
        }

    }


}
