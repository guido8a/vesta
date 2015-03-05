<%--
  Created by IntelliJ IDEA.
  User: fabricio
  Date: 20/01/15
  Time: 03:46 PM
--%>


<table class="table table-condensed table-bordered table-striped table-hover">
    <thead>
    <tr>
        <th>Componente</th>
        <th>Actividad</th>
        <th>Partida</th>
        <th>Priorizado</th>
        <th>Monto</th>
        <th></th>
        <th></th>
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
            <td style="text-align: center">
                <g:if test="${band}">
                    <a href="#" class="edit btn btn-info btn-sm" iden="${asg.id}" data-asg="${asg.asignacion.id}" title="Editar"
                       data-monto="${g.formatNumber(number: asg.monto, maxFractionDigits: 2,minFractionDigits: 2)}">
                        <i class="fa fa-pencil"></i>
                    </a>
                </g:if>
            </td>
            <td style="text-align: center">
                <g:if test="${band}">
                    <a href="#" class="borrar btn btn-danger btn-sm" iden="${asg.id}" title="Borrar"> <i class="fa fa-trash"></i> </a>
                </g:if>
            </td>
        </tr>
    </g:each>
    <tr>
        <td colspan="4" style="font-weight: bold">TOTAL PROCESO</td>
        <td style="font-weight: bold;text-align: right">
            <g:formatNumber number="${total}" type="currency" currencySymbol=""/>
        </td>
        <td></td>
        <td></td>
    </tr>
    </tbody>
</table>
<script>
    $(".edit").click(function () {
        vaciar();
        var max = getMaximo($(this).data("asg"), $(this).data("monto"));
        editarAsg($(this).attr("iden"), max);
//        $("#dlgMax").text(number_format(max, 2, '.', ','));
    });


    $(".borrar").click(function () {
        var idTr = $(this).attr("iden");
        var b = bootbox.dialog({
                title : "Borrar asignación",
                message :"Esta seguro de borrar la asignación?",
                buttons : {
                    aceptar : {
                        label     : "Aceptar",
                        className : "btn-success",
                        callback  : function () {
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
                                            title : "Error",
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
                    },
                    cancelar : {
                        label     : "Cancelar",
                        className : "btn-primary",
                        callback  : function () {
                        }
                    }
                }
        });
    });



</script>