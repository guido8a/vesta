<%@ page import="vesta.poa.ProgramacionAsignacion; vesta.proyectos.MarcoLogico" contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta name="layout" content="main"/>
    <title>Asignaciones del proyecto: ${proyecto}</title>


    <style type="text/css">

    input{
        font-size: 10px !important;
        margin: 0px;
    }
    </style>
</head>

<body>

<div class="btn-toolbar toolbar">
    <div class="btn-group">
        <a href="#" class="btn btn-default btnRegresar">
            <i class="fa fa-arrow-left"></i> Regresar
        </a>
        <g:link class="btn btn-default btn-sm" controller="asignacion" action="asignacionProyectov2"  params="[id:proyecto.id,anio:actual.id]"><i class="fa fa-money"></i> Asignaciones</g:link>

        <div style="margin-left: 15px;display: inline-block;">
            <b style="font-size: 11px">Año:</b>
            <g:select from="${vesta.parametros.poaPac.Anio.list([sort:'anio'])}" id="anio_asg" name="anio" optionKey="id" optionValue="anio" value="${actual.id}" style="font-size: 11px;width: 150px;display: inline" class="form-control"/>
        </div>
    </div>
</div>
<elm:container tipo="horizontal" titulo="Programación de las asignaciones del proyecto: ${proyecto?.toStringLargo()}, para el año ${actual}" color="black" >
    <table  class="table table-condensed table-bordered table-striped" style="font-size: 11px;">
        <thead>
        <th style=";">Enero</th>
        <th style=";">Feb.</th>
        <th style=";">Marzo</th>
        <th style=";">Abril</th>
        <th style=";">Mayo</th>
        <th style=";">Junio</th>
        <th style=";">Julio</th>
        <th style=";">Agos.</th>
        <th style=";">Sept.</th>
        <th style=";">Oct.</th>
        <th style=";">Nov.</th>
        <th style=";">Dic.</th>
        <th style="">Total</th>
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
                <td colspan="14" style="font-size: 12px;" ><b>Asignación#${i+1} </b>${asg}</td>
                %{--<td></td>--}%
            </tr>
            <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                <g:each in="${meses}" var="mes" status="j">
                    <g:if test="${ProgramacionAsignacion.findAll('from ProgramacionAsignacion where asignacion = '+asg.id+' and mes = '+mes.id+' and padre is null').size()>0}" >
                        <g:set var="progra" value="${ProgramacionAsignacion.findAll('from ProgramacionAsignacion where asignacion = '+asg.id+' and mes = '+mes.id+' and padre is null')?.pop()}"/>
                        <td class="${mes}"  style="width: 70px;padding: 0px;height: 30px">
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
                        <td class="${mes}" style="width: 70px;padding: 0px;height: 30px">
                            <input type="text" class="${mes} valor asg_cor_${asg.id} form-control input-sm number money" mes="${mes.id}"   value="0.00">
                        </td>
                    </g:else>
                </g:each>
                <td class="total" id="total_cor_${asg.id}" style="width: 80px;text-align: right;${(totalFila.toDouble().round(2)!=asg.priorizado.toDouble().round(2))?'color:red;':''}padding-top:0px;padding-bottom: 0px;line-height: 30px">
                    <g:formatNumber number="${totalFila}" type="currency" currencySymbol=""/>
                   %{--${totalFila}-----${asg.priorizado}--}%
                    %{--<g:formatNumber number="${asg.priorizado}" type="currency" currencySymbol=""/>--}%
                </td>
                <td style="width: 50px;text-align: center;padding-top:0px;padding-bottom: 0px">
                    <a href="#" class="btn guardar ajax btn-primary btn-sm" asg="${asg.id}"   icono="ico_cor_${i}" max="${asg.priorizado}" clase="asg_cor_${asg.id}" total="total_cor_${asg.id}" title="guardar">
                        <i class="fa fa-floppy-o"></i></a>
                    </a>
                </td>

            </tr>
        </g:each>
        <tr>
            <td colspan="15"><b>TOTALES</b></td>
        </tr>
        <tr>
            <td style="text-align: center"><g:formatNumber number="${ene}" type="currency" currencySymbol=""/></td>
            <td style="text-align: center"><g:formatNumber number="${feb}" type="currency" currencySymbol=""/></td>
            <td style="text-align: center"><g:formatNumber number="${mar}" type="currency" currencySymbol=""/></td>
            <td style="text-align: center"><g:formatNumber number="${abr}" type="currency" currencySymbol=""/></td>
            <td style="text-align: center"><g:formatNumber number="${may}" type="currency" currencySymbol=""/></td>
            <td style="text-align: center"><g:formatNumber number="${jun}" type="currency" currencySymbol=""/></td>
            <td style="text-align: center"><g:formatNumber number="${jul}" type="currency" currencySymbol=""/></td>
            <td style="text-align: center"><g:formatNumber number="${ago}" type="currency" currencySymbol=""/></td>
            <td style="text-align: center"><g:formatNumber number="${sep}" type="currency" currencySymbol=""/></td>
            <td style="text-align: center"><g:formatNumber number="${oct}" type="currency" currencySymbol=""/></td>
            <td style="text-align: center"><g:formatNumber number="${nov}" type="currency" currencySymbol=""/></td>
            <td style="text-align: center"><g:formatNumber number="${dic}" type="currency" currencySymbol=""/></td>
            <td style="text-align: center"><g:formatNumber number="${ene.toDouble()+feb.toDouble()+mar.toDouble()+abr.toDouble()+may.toDouble()+jun.toDouble()+jul.toDouble()+ago.toDouble()+sep.toDouble()+oct.toDouble()+nov.toDouble()+dic.toDouble()}" type="currency" currencySymbol=""/></td>
        </tr>
        </tbody>
    </table>
</elm:container>
<script type="text/javascript">
    $("#anio_asg").change(function(){
        location.href="${createLink(controller:'asignacion',action:'programacionAsignacionesInversionPrio')}?id=${proyecto.id}&anio="+$(this).val()
    });

    $(".guardar").click(function(e) {
        var icono = $("#" + $(this).attr("icono"))
        var total = 0
        var max = $(this).attr("max")*1
        var datos =""
        $.each($("."+$(this).attr("clase")),function(){
            var val = $(this).val()
            val = str_replace(",","",val)
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
            e.preventDefault()
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


    $(".btnRegresar").click(function () {
        window.history.back()

    });


</script>

</body>
</html>