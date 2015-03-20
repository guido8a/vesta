<%--
  Created by IntelliJ IDEA.
  User: fabricio
  Date: 20/01/15
  Time: 03:46 PM
--%>
<script type="text/javascript" src="${resource(dir: 'js', file: 'ui.js')}"></script>

<script src="${resource(dir: 'js/plugins/fixed-header-table-1.3', file: 'jquery.fixedheadertable.js')}"></script>
<link rel="stylesheet" type="text/css" href="${resource(dir: 'js/plugins/fixed-header-table-1.3/css', file: 'defaultTheme.css')}"/>

<table class="table table-condensed table-bordered table-striped table-hover" id="tblDetalle">
    <thead>
        <tr>
            <th>Componente</th>
            <th>Actividad</th>
            <th>Partida</th>
            <th>Priorizado</th>
            <th>Monto</th>
            <g:if test="${!readOnly}">
                <th></th>
            </g:if>
        </tr>
    </thead>
    <tbody>
        <g:set var="total" value="${0}"/>
        <g:each in="${detalle}" var="asg">
            <g:set var="total" value="${total.toDouble() + asg.monto}"/>
            <tr iden="${asg?.id}">
                <td>${asg.asignacion.marcoLogico.marcoLogico}</td>
                <td>${asg.asignacion.marcoLogico.numero} - ${asg.asignacion.marcoLogico}</td>
                <td>${asg.asignacion.presupuesto.numero}</td>
                <td style="text-align: right">
                    <g:formatNumber number="${asg.asignacion.priorizado}" type="currency" currencySymbol=""/>
                </td>
                <td style="text-align: right" id="monto_${asg.id}"
                    valor="${asg.monto}">
                    <g:formatNumber number="${asg.monto}" type="currency" currencySymbol=""/>
                </td>
                <g:if test="${!readOnly}">
                    <td style="text-align: center">
                        <div class="btn-group" role="group">
                        %{--<g:if test="${band}">--}%
                        %{--<a href="#" class="edit btn btn-info btn-xs" iden="${asg.id}" data-asg="${asg.asignacion.id}" title="Editar"--}%
                        %{--data-monto="${g.formatNumber(number: asg.monto, maxFractionDigits: 2, minFractionDigits: 2)}">--}%
                        %{--<i class="fa fa-pencil"></i>--}%
                        %{--</a>--}%
                        %{--</g:if>--}%
                            <g:if test="${band}">
                                <a href="#" class="borrar btn btn-danger btn-xs" iden="${asg.id}" title="Borrar">
                                    <i class="fa fa-trash"></i>
                                </a>
                            </g:if>
                        </div>
                    </td>
                </g:if>
            </tr>
        </g:each>
    </tbody>
    <tfoot>
        <tr>
            <td colspan="4" style="font-weight: bold">TOTAL PROCESO</td>
            <td style="font-weight: bold;text-align: right">
                <g:formatNumber number="${total}" type="currency" currencySymbol=""/>
            </td>
            <g:if test="${!readOnly}">
                <td></td>
            </g:if>
        </tr>
    </tfoot>
</table>
<script>
    //    $(".edit").click(function () {
    //        vaciar();
    //        var max = getMaximo($(this).data("asg"), $(this).data("monto"));
    //        editarAsg($(this).attr("iden"), max);
    ////        $("#dlgMax").text(number_format(max, 2, '.', ','));
    //    });

    $("#tblDetalle").fixedHeaderTable({
        height     : 200,
        autoResize : true,
        footer     : true
    });

    $(".borrar").click(function () {
        var idTr = $(this).attr("iden");

        bootbox.confirm("¿Está seguro de borrar la asignación?", function (res) {
            if (res) {
                $.ajax({
                    type    : "POST",
                    url     : "${createLink(action:'borrarDetalle')}",
                    data    : {
                        id : idTr
                    },
                    success : function (msg) {
                        if (msg == "ok") {
                            getDetalle();
                            vaciar();
                        } else {
                            bootbox.dialog({
                                title   : "Error",
                                message : "No se puede borrar porque el proceso tiene un aval o una solicitud de aval pendiente",
                                buttons : {
                                    cancelar : {
                                        label     : "Cancelar",
                                        className : "btn-primary",
                                        callback  : function () {
                                        }
                                    }
                                }
                            });
                        }
                    }
                });
            }
        })

    });



</script>