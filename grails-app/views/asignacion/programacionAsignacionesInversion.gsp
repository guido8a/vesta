<%@ page import="vesta.poa.ProgramacionAsignacion; vesta.proyectos.MarcoLogico" contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta name="layout" content="main"/>
    <title>Asignaciones del proyecto: ${proyecto}</title>


<style type="text/css">
.valor{
    width: 60px;
    text-align: center;
    margin: 0px;
    color: #000000;
}
</style>
</head>

<body>

<div class="btn-toolbar toolbar">
    <div class="btn-group">
<g:link class="btn btn-default btn-sm" controller="asignacion" action="asignacionProyectov2"  params="[id:proyecto.id,anio:actual.id]">Asignaciones</g:link>
<div style="margin-left: 15px;display: inline-block;">
    <b style="font-size: 11px">Año:</b>
    <g:select from="${vesta.parametros.poaPac.Anio.list([sort:'anio'])}" id="anio_asg" name="anio" optionKey="id" optionValue="anio" value="${actual.id}" style="font-size: 11px;width: 150px;display: inline" class="form-control"/>
</div>
</div>
</div>
<elm:container tipo="horizontal" titulo="Programación de las asignaciones del proyecto: ${proyecto?.toStringLargo()}, para el año ${actual}" color="black" >

    <table  class="table table-condensed table-bordered table-striped">
        <thead>
        <th style="width: 70px;">Enero</th>
        <th style="width: 70px;">Feb.</th>
        <th style="width: 70px;">Marzo</th>
        <th style="width: 70px;">Abril</th>
        <th style="width: 70px;">Mayo</th>
        <th style="width: 70px;">Junio</th>
        <th style="width: 70px;">Julio</th>
        <th style="width: 70px;">Agos.</th>
        <th style="width: 70px;">Sept.</th>
        <th style="width: 70px;">Oct.</th>
        <th style="width: 70px;">Nov.</th>
        <th style="width: 70px;">Dic.</th>
        <th style="width: 80px;">Total</th>
        <th></th>
        <th></th>
        </thead>
        <tbody>
        <g:set var="ene" value="${0}"></g:set>
        <g:set var="feb" value="${0}"></g:set>
        <g:set var="mar" value="${0}"></g:set>
        <g:set var="abr" value="${0}"></g:set>
        <g:set var="may" value="${0}"></g:set>
        <g:set var="jun" value="${0}"></g:set>
        <g:set var="jul" value="${0}"></g:set>
        <g:set var="ago" value="${0}"></g:set>
        <g:set var="sep" value="${0}"></g:set>
        <g:set var="oct" value="${0}"></g:set>
        <g:set var="nov" value="${0}"></g:set>
        <g:set var="dic" value="${0}"></g:set>
        <g:set var="asignado" value="0"></g:set>
        <g:each in="${inversiones}" var="asg" status="i">
            <g:set var="totalFila" value="${0}"></g:set>
            <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                <td colspan="13"><b>Asignación#${i+1} </b>${asg}</td>
                <td></td>
                <td></td>
            </tr>
            <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                <g:each in="${meses}" var="mes" status="j">
                    <g:if test="${ProgramacionAsignacion.findAll('from ProgramacionAsignacion where asignacion = '+asg.id+' and mes = '+mes.id+' and padre is null').size()>0}" >
                        <g:set var="progra" value="${ProgramacionAsignacion.findAll('from ProgramacionAsignacion where asignacion = '+asg.id+' and mes = '+mes.id+' and padre is null')?.pop()}"></g:set>
                        <td class="${mes}" style="width: 70px;">
                            <input type="text" class="${j} valor asg_cor_${asg.id} form-control input-sm number money"  mes="${mes.id}"   value="${g.formatNumber(number:progra?.valor, format:'###,##0', minFractionDigits:'2',maxFractionDigits:'2')}">
                            <g:set var="totalFila" value="${totalFila+=progra.valor}"></g:set>
                            <g:if test="${j==0}">
                                <g:set var="ene" value="${ene.toDouble()+progra?.valor}"></g:set>
                            </g:if>
                            <g:if test="${j==1}">
                                <g:set var="feb" value="${feb.toDouble()+progra?.valor}"></g:set>
                            </g:if>
                            <g:if test="${j==2}">
                                <g:set var="mar" value="${mar.toDouble()+progra?.valor}"></g:set>
                            </g:if>
                            <g:if test="${j==3}">
                                <g:set var="abr" value="${abr.toDouble()+progra?.valor}"></g:set>
                            </g:if>
                            <g:if test="${j==4}">
                                <g:set var="may" value="${may.toDouble()+progra?.valor}"></g:set>
                            </g:if>
                            <g:if test="${j==5}">
                                <g:set var="jun" value="${jun.toDouble()+progra?.valor}"></g:set>
                            </g:if>
                            <g:if test="${j==6}">
                                <g:set var="jul" value="${jul.toDouble()+progra?.valor}"></g:set>
                            </g:if>
                            <g:if test="${j==7}">
                                <g:set var="ago" value="${ago.toDouble()+progra?.valor}"></g:set>
                            </g:if>
                            <g:if test="${j==8}">
                                <g:set var="sep" value="${sep.toDouble()+progra?.valor}"></g:set>
                            </g:if>
                            <g:if test="${j==9}">
                                <g:set var="oct" value="${oct.toDouble()+progra?.valor}"></g:set>
                            </g:if>
                            <g:if test="${j==10}">
                                <g:set var="nov" value="${nov.toDouble()+progra?.valor}"></g:set>
                            </g:if>
                            <g:if test="${j==11}">
                                <g:set var="dic" value="${dic.toDouble()+progra?.valor}"></g:set>
                            </g:if>
                        </td>
                    </g:if>
                    <g:else>
                        <td class="${mes}" style="width: 70px;">
                            <input type="text" class="${mes} valor asg_cor_${asg.id} form-control input-sm number money" mes="${mes.id}"   value="0.00">
                        </td>
                    </g:else>
                </g:each>
                <td class="total" id="total_cor_${asg.id}" style="width: 80px;text-align: right;${(totalFila.toDouble().round(2)!=asg.priorizado.toDouble().round(2))?'color:red;':''}">
                    <g:formatNumber number="${totalFila}" type="currency"/>
                </td>
                <g:if test="${actual.estado==0}">
                    <td>
                        <a href="#" class="btn guardar ajax btn-primary btn-sm" asg="${asg.id}"   icono="ico_cor_${i}" max="${asg.priorizado}" clase="asg_cor_${asg.id}" total="total_cor_${asg.id}" title="guardar">
                            <i class="fa fa-floppy-o"></i>
                        </a>
                    </td>
                </g:if>
                <td class="ui-state-active"><span class="" id="ico_cor_${i}" title="Guardado" style="display: none"><span class="ui-icon ui-icon-check"></span></span></td>
            </tr>

        </g:each>
        <tr>
            <td colspan="15"><b>TOTALES</b></td>
        </tr>
        <tr>
            <td style="text-align: center"><g:formatNumber number="${ene}" format="###,##0" minFractionDigits="2" maxFractionDigits="2"/></td>
            <td style="text-align: center"><g:formatNumber number="${feb}" format="###,##0" minFractionDigits="2" maxFractionDigits="2"/></td>
            <td style="text-align: center"><g:formatNumber number="${mar}" format="###,##0" minFractionDigits="2" maxFractionDigits="2"/></td>
            <td style="text-align: center"><g:formatNumber number="${abr}" format="###,##0" minFractionDigits="2" maxFractionDigits="2"/></td>
            <td style="text-align: center"><g:formatNumber number="${may}" format="###,##0" minFractionDigits="2" maxFractionDigits="2"/></td>
            <td style="text-align: center"><g:formatNumber number="${jun}" format="###,##0" minFractionDigits="2" maxFractionDigits="2"/></td>
            <td style="text-align: center"><g:formatNumber number="${jul}" format="###,##0" minFractionDigits="2" maxFractionDigits="2"/></td>
            <td style="text-align: center"><g:formatNumber number="${ago}" format="###,##0" minFractionDigits="2" maxFractionDigits="2"/></td>
            <td style="text-align: center"><g:formatNumber number="${sep}" format="###,##0" minFractionDigits="2" maxFractionDigits="2"/></td>
            <td style="text-align: center"><g:formatNumber number="${oct}" format="###,##0" minFractionDigits="2" maxFractionDigits="2"/></td>
            <td style="text-align: center"><g:formatNumber number="${nov}" format="###,##0" minFractionDigits="2" maxFractionDigits="2"/></td>
            <td style="text-align: center"><g:formatNumber number="${dic}" format="###,##0" minFractionDigits="2" maxFractionDigits="2"/></td>
            <td style="text-align: center"><g:formatNumber number="${ene.toDouble()+feb.toDouble()+mar.toDouble()+abr.toDouble()+may.toDouble()+jun.toDouble()+jul.toDouble()+ago.toDouble()+sep.toDouble()+oct.toDouble()+nov.toDouble()+dic.toDouble()}" format="###,##0" minFractionDigits="2" maxFractionDigits="2"/></td>
        </tr>
        </tbody>
    </table>
</elm:container>


    <script type="text/javascript">
        $("#anio_asg").change(function(){
            location.href="${createLink(controller:'asignacion',action:'programacionAsignacionesInversion')}?id=${proyecto.id}&anio="+$(this).val()
        });

        $(".guardar").click(function() {
            var icono = $("#" + $(this).attr("icono"))
            var total = 0
            var max = $(this).attr("max")*1
            var datos =""
            $.each($("."+$(this).attr("clase")),function(){
                var val = $(this).val()
                val = str_replace(".","",val)
                val = str_replace(",",".",val)
                val=val*1
                total+= val
                datos+=$(this).attr("mes")+":"+val+";"
            });
            total =parseFloat(total).toFixed(2);
            if(total!=max){
                bootbox.alert({
                            message: "El total programado ( "+number_format(total,2,".",",")+" ) es diferente al monto priorizado: "+number_format(max,2,".",","),
                            title :"Error",
                            class : "modal-error"
                        }
                );
                $("#"+$(this).attr("total")).html(total).css("color","red").show("pulsate")
            }else{
                $("#"+$(this).attr("total")).html(total).css("color","black")
                $.ajax({
                    type: "POST",
                    url: "${createLink(action:'guardarProgramacion',controller:'asignacion')}",
                    data: "asignacion="+$(this).attr("asg")+"&datos="+datos ,
                    success: function(msg) {
                        if(msg=="ok"){
                            icono.show("pulsate")
                            window.location.reload(true)
                        }
                    }
                });
            }

        });


    </script>

    </body>
    </html>