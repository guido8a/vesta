<%--
  Created by IntelliJ IDEA.
  User: fabricio
  Date: 18/08/15
  Time: 01:09 PM
--%>

<%@ page import="vesta.parametros.poaPac.Anio; vesta.poa.ProgramacionAsignacion; vesta.proyectos.MarcoLogico" contentType="text/html;charset=UTF-8" %>

<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta name="layout" content="main"/>
    %{--<title>Asignaciones de la unidad: ${unidad}</title>--}%
    <title>Programación de asignaciones de gasto permanente</title>
</head>

<body>

<div class="btn-toolbar toolbar">
    <div class="btn-group">
        <a href="#" class="btn btn-default btnRegresar">
            <i class="fa fa-arrow-left"></i> Regresar
        </a>
        <div style="margin-left: 15px;display: inline-block;">
            <b style="font-size: 11px">Año:</b>
            <g:select from="${Anio.list([sort: 'anio'])}" id="anio_asg" name="anio" optionKey="id" optionValue="anio" value="${actual.id}" style="font-size: 11px;width: 150px;display: inline" class="form-control"/>
        </div>
    </div>

    <div class="btn-group">

        <a href="#" class="btn btn-default " id="btnActualizar">
            <i class="fa fa-refresh"></i> Actualizar
        </a>

    </div>
</div>

<elm:container tipo="horizontal" titulo="Programación de asignaciones de gasto permanente, para el año ${actual}" color="black">
    <table class="table table-condensed table-bordered table-striped" style="font-size: 11px;">
        <thead>
        <tr>
            <th>Enero</th>
            <th>Feb.</th>
            <th>Marzo</th>
            <th>Abril</th>
            <th>Mayo</th>
            <th>Junio</th>
            <th>Julio</th>
            <th>Agos.</th>
            <th>Sept.</th>
            <th>Oct.</th>
            <th>Nov.</th>
            <th>Dic.</th>
            <th style="">Total</th>
            <th></th>
        </tr>
        </thead>
        <tbody>
        <g:set var="ene" value="${0}"/>
        <g:set var="feb" value="${0}"/>
        <g:set var="mar" value="${0}"/>
        <g:set var="abr" value="${0}"/>
        <g:set var="may" value="${0}"/>
        <g:set var="jun" value="${0}"/>
        <g:set var="jul" value="${0}"/>
        <g:set var="ago" value="${0}"/>
        <g:set var="sep" value="${0}"/>
        <g:set var="oct" value="${0}"/>
        <g:set var="nov" value="${0}"/>
        <g:set var="dic" value="${0}"/>
        <g:set var="asignado" value="0"/>

        <g:each in="${corrientes}" var="asg" status="i">
            <g:set var="totalFila" value="${0}"/>
            <g:set var="totalMeses" value="${0}"/>

            <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                <td colspan="15">%{--<b>Programa:</b>${asg?.programa?.descripcion}--}% <b>Actividad:</b> ${asg?.tarea?.actividad?.descripcion} <b>Partida:</b> ${asg.presupuesto.descripcion}
                </td>
            </tr>

            <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                <g:set var="suma" value="${0}"/>

                <g:each in="${meses}" var="cont">


                    <g:set var="mesReal" value="${vesta.parametros.poaPac.Mes.findByNumero(cont)}"/>

                    <g:set var="progTotal" value="${ProgramacionAsignacion.findAll('from ProgramacionAsignacion where asignacion = ' + asg.id + ' and mes = ' + mesReal?.id + ' and padre is null')}"/>


                    <g:if test="${progTotal.size() > 0}">
                        <g:set var="progTotal" value="${progTotal.pop()}"/>
                    </g:if>
                    <g:else>
                        <g:set var="progTotal" value="${[valor: 0]}"/>
                    </g:else>

                    <g:set var="totalMeses" value="${totalMeses += progTotal?.valor}"/>

                </g:each>

                <g:if test="${totalMeses != 0}">

                    <g:each in="${meses}" var="mes" status="j">

                        <g:set var="mesReal2" value="${vesta.parametros.poaPac.Mes.findByNumero(mes)}"/>

                        <g:set var="progra" value="${ProgramacionAsignacion.findAll('from ProgramacionAsignacion where asignacion = ' + asg.id + ' and mes = ' + mesReal2?.id + ' and padre is null')}"/>

                        <g:if test="${progra.size() > 0}">
                            <g:set var="progra" value="${progra.pop()}"/>
                        </g:if>
                        <g:else>
                            <g:set var="progra" value="${[valor: 0]}"/>
                        </g:else>


                        <td class="${mes}" style="width: 70px;padding: 0;height: 30px">

                            <input type="text" class="${j} valor asg_cor_${asg.id} form-control input-sm number money" mes="${mes}"
                                   value="${g.formatNumber(number: progra?.valor, format: '###,##0', minFractionDigits: '2', maxFractionDigits: '2')}">

                            <g:set var="totalFila" value="${totalFila += progra.valor}"/>

                            <g:if test="${j == 0}">
                                <g:set var="ene" value="${ene.toDouble() + progra?.valor}"/>
                            </g:if>
                            <g:if test="${j == 1}">
                                <g:set var="feb" value="${feb.toDouble() + progra?.valor}"/>
                            </g:if>
                            <g:if test="${j == 2}">
                                <g:set var="mar" value="${mar.toDouble() + progra?.valor}"/>
                            </g:if>
                            <g:if test="${j == 3}">
                                <g:set var="abr" value="${abr.toDouble() + progra?.valor}"/>
                            </g:if>
                            <g:if test="${j == 4}">
                                <g:set var="may" value="${may.toDouble() + progra?.valor}"/>
                            </g:if>
                            <g:if test="${j == 5}">
                                <g:set var="jun" value="${jun.toDouble() + progra?.valor}"/>
                            </g:if>
                            <g:if test="${j == 6}">
                                <g:set var="jul" value="${jul.toDouble() + progra?.valor}"/>
                            </g:if>
                            <g:if test="${j == 7}">
                                <g:set var="ago" value="${ago.toDouble() + progra?.valor}"/>
                            </g:if>
                            <g:if test="${j == 8}">
                                <g:set var="sep" value="${sep.toDouble() + progra?.valor}"/>
                            </g:if>
                            <g:if test="${j == 9}">
                                <g:set var="oct" value="${oct.toDouble() + progra?.valor}"/>
                            </g:if>
                            <g:if test="${j == 10}">
                                <g:set var="nov" value="${nov.toDouble() + progra?.valor}"/>
                            </g:if>
                            <g:if test="${j == 11}">
                                <g:set var="dic" value="${dic.toDouble() + progra?.valor}"/>
                            </g:if>
                        </td>
                    </g:each>

                </g:if>
                <g:else>

                    <g:set var="valorPrio" value="${asg?.priorizado}"/>

                    <g:set var="valorMes" value="${valorPrio / 12}"/>


                    <g:each in="${meses}" var="mes" status="j">

                        <g:set var="mesReal3" value="${vesta.parametros.poaPac.Mes.findByNumero(mes)}"/>

                        <g:set var="progra" value="${ProgramacionAsignacion.findAll('from ProgramacionAsignacion where asignacion = ' + asg.id + ' and mes = ' + mesReal3?.id + ' and padre is null')}"/>

                        <g:if test="${progra.size() > 0}">
                            <g:set var="progra" value="${progra.pop()}"/>
                        </g:if>
                        <g:else>
                            <g:set var="progra" value="${[valor: 0]}"/>
                        </g:else>



                        <td class="${mes}" style="width: 70px;padding: 0;height: 30px">

                            <g:if test="${j != 11}">
                                <input type="text" class="${j} valor asg_cor_${asg.id} form-control input-sm number money" mes="${mes}"
                                       value="${g.formatNumber(number: valorMes, format: '###,##0', minFractionDigits: '2', maxFractionDigits: '2')}">
                            </g:if>
                            <g:else>
                                <input type="text" class="${j} valor asg_cor_${asg.id} form-control input-sm number money" mes="${mes}"
                                       value="${g.formatNumber(number: (valorPrio - (valorMes * 11)), format: '###,##0', minFractionDigits: '2', maxFractionDigits: '2')}">
                            </g:else>

                            %{--${"valor"  + valorMes}--}%

                            <g:set var="totalFila" value="${totalFila += valorMes}"/>

                            <g:if test="${j == 0}">
                                <g:set var="ene" value="${ene.toDouble() + valorMes}"/>
                            </g:if>
                            <g:if test="${j == 1}">
                                <g:set var="feb" value="${feb.toDouble() + valorMes}"/>
                            </g:if>
                            <g:if test="${j == 2}">
                                <g:set var="mar" value="${mar.toDouble() + valorMes}"/>
                            </g:if>
                            <g:if test="${j == 3}">
                                <g:set var="abr" value="${abr.toDouble() + valorMes}"/>
                            </g:if>
                            <g:if test="${j == 4}">
                                <g:set var="may" value="${may.toDouble() + valorMes}"/>
                            </g:if>
                            <g:if test="${j == 5}">
                                <g:set var="jun" value="${jun.toDouble() + valorMes}"/>
                            </g:if>
                            <g:if test="${j == 6}">
                                <g:set var="jul" value="${jul.toDouble() + valorMes}"/>
                            </g:if>
                            <g:if test="${j == 7}">
                                <g:set var="ago" value="${ago.toDouble() + valorMes}"/>
                            </g:if>
                            <g:if test="${j == 8}">
                                <g:set var="sep" value="${sep.toDouble() + valorMes}"/>
                            </g:if>
                            <g:if test="${j == 9}">
                                <g:set var="oct" value="${oct.toDouble() + valorMes}"/>
                            </g:if>
                            <g:if test="${j == 10}">
                                <g:set var="nov" value="${nov.toDouble() + valorMes}"/>
                            </g:if>
                            <g:if test="${j == 11}">
                                %{--<g:set var="dic" value="${dic.toDouble() + (valorPrio - (valorMes * 11))}"/>--}%
                                <g:set var="dic" value="${dic.toDouble() + valorMes}"/>
                            </g:if>
                        </td>
                    </g:each>

                </g:else>


                %{--<g:set var="totalFila" value="${(totalFila + (valorPrio - (valorMes * 11))) - valorMes}"/>--}%
                %{--<g:set var="totalFila" value="${(totalFila + (valorPrio - (valorMes * 11))) - valorMes}"/>--}%


                <td class="total" id="total_cor_${asg.id}" style="width: 80px;text-align: right;${(totalFila.toDouble().round(2) != asg.priorizado.toDouble().round(2)) ? 'color:red;' : ''}padding-top:0px;padding-bottom: 0px;line-height: 30px">
                    <g:formatNumber number="${totalFila}" type="currency" currencySymbol=""/>
                </td>

                <g:if test="${max?.aprobadoCorrientes == 0}">
                    <td class=""><a href="#" class="btn guardar ajax" asg="${asg.id}" icono="ico_cor_${i}" max="${(asg.redistribucion == 0) ? asg.planificado : asg.redistribucion}" clase="asg_cor_${asg.id}" total="total_cor_${asg.id}">Guardar</a>
                    </td>
                </g:if>


                <td style="width: 50px;text-align: center;padding-top:0px;padding-bottom: 0px">
                    <a href="#" class="btn guardar ajax btn-primary btn-sm" asg="${asg.id}" icono="ico_cor_${i}" max="${asg.priorizado}" clase="asg_cor_${asg.id}" total="total_cor_${asg.id}" title="guardar">
                        <i class="fa fa-floppy-o"></i></a> ${asg?.priorizado}
                %{--</a>--}%
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
            <td style="text-align: center"><g:formatNumber number="${ene.toDouble() + feb.toDouble() + mar.toDouble() + abr.toDouble() + may.toDouble() + jun.toDouble() + jul.toDouble() + ago.toDouble() + sep.toDouble() + oct.toDouble() + nov.toDouble() + dic.toDouble()}" type="currency" currencySymbol=""/></td>
        </tr>
        </tbody>
    </table>
</elm:container>





<script type="text/javascript">
    $("#accordion").tabs();
    $("[name=programa]").selectmenu({width : 180});
    $(".btn_arbol").button({icons : { primary : "ui-icon-bullet"}})
    $(".btn").button()
    //    $(".back").button("option", "icons", {primary : 'ui-icon-arrowreturnthick-1-w'});

    $(".guardar").button({
        icons : {
            primary : "ui-icon-disk"
        },
        text  : false
    })
    $("#anio_asg").change(function () {
        location.href = "${createLink(controller:'asignacion',action:'programacionAsignacionesCorrientes')}?id=${unidad.id}&anio=" + $(this).val()
    });

    $(".btnRegresar").click(function () {
//        window.history.back()
        location.href="${createLink(controller: 'asignacion', action: 'asignacionesCorrientesv2')}"
    });

    $("#btnActualizar").click(function () {
        window.location.reload(true)
    });


    $(".guardar").click(function () {
        var icono = $("#" + $(this).attr("icono"))
        var total = 0
        var max = $(this).attr("max") * 1
        var datos = ""
        $.each($("." + $(this).attr("clase")), function () {
            var val = $(this).val()
            val = str_replace(",", "", val)
            val = val * 1
            total += val
            datos += $(this).attr("mes") + ":" + val + ";"
        });
        total = parseFloat(total).toFixed(2);
        if (total != max) {
            bootbox.alert({
                message : "El total programado ( " + number_format(total, 2, ".", ",") + " ) es diferente al monto priorizado: " + number_format(max, 2, ".", ",") + " " +
                ",diferencia: ( " + number_format((max - total), 2, ".", ",") + " )",
                title   : "Error",
                class   : "modal-error"
            });
        } else {
            $.ajax({
                type    : "POST",
                url     : "${createLink(action:'guardarProgramacion',controller:'asignacion')}",
                data    : "asignacion=" + $(this).attr("asg") + "&datos=" + datos,
                success : function (msg) {
                    if (msg == "ok") {
                        log("Programación guardada correctamente", "success");
                    }
                }
            });
        }

    });


</script>

</body>
</html>