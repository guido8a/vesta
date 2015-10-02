<%--
  Created by IntelliJ IDEA.
  User: fabricio
  Date: 02/10/15
  Time: 09:48 AM
--%>
<%--
  Created by IntelliJ IDEA.
  User: fabricio
  Date: 14/01/15
  Time: 03:24 PM
--%>

<%@ page import="vesta.parametros.TipoElemento" contentType="text/html;charset=UTF-8" %>

<elm:message tipo="${flash.tipo}" clase="${flash.clase}">${flash.message}</elm:message>

<g:form action="guardarLiberacionPermanente" name="frmLiberar" method="POST" role="form">
    <input type="hidden" name="id" id="id" value="${aval.id}">

    <div style="padding: 5px;" class="alert alert-info">
        <div class="form-group keeptogether">
            <span class="grupo">
                <label for="contrato" class="col-md-3 control-label">
                    Contrato:
                </label>
                <g:if test="${edi == 'si'}">
                    <div class="col-md-5">
                        <g:textField class="form-control input-sm required" name="contrato" id="contrato" value="${aval?.contrato}" readonly="true"/>
                    </div>
                </g:if>
                <g:else>
                    <div class="col-md-5">
                        <g:textField class="form-control input-sm required" name="contrato" id="contrato" value="${aval?.contrato}"/>
                    </div>
                </g:else>

            </span>
            *
        </div>
        <div class="form-group keeptogether">
            <span class="grupo">
                <label for="certificacion" class="col-md-3 control-label">
                    Certificación presupuestaria:
                </label>
                <g:if test="${edi == 'si'}">
                    <div class="col-md-5">
                        <g:textField class="form-control input-sm required" name="certificacion" id="certificacion" value="${aval?.certificacion}" readonly="true"/>
                    </div>
                </g:if>
                <g:else>
                    <div class="col-md-5">
                        <g:textField class="form-control input-sm required" name="certificacion" id="certificacion" value="${aval?.certificacion}"/>
                    </div>
                </g:else>

            </span>
            *
        </div>
    </div>

    <div style="padding: 5px;" class="alert alert-success">
        <div class="form-group keeptogether">
            <span class="grupo">
                <label for="contrato" class="col-md-3 control-label">
                    Documento de respaldo:
                </label>
                <g:if test="${edi == 'si'}">
                    <div class="col-md-5">
                        <g:textField class="form-control input-sm " name="archivo" value="${aval?.pathLiberacion}" readonly="true" />
                    </div>
                </g:if>
                <g:else>
                    <div class="col-md-5">
                        <input type="file"  class="form-control input-sm required" id="archivo" name="archivo">
                    </div>
                </g:else>

            </span>
            *
        </div>
    </div>

    <input type="hidden" id="datos" name="datos">
    <input type="hidden" id="monto" name="monto">
    <fieldset>
        <legend>Detalle</legend>
        <table class="table table-condensed table-bordered table-striped table-hover">
            <thead>
            <tr>

                <th>Fuente</th>
                <th>Partida</th>
                <th>Priorizado</th>
                <th>Monto</th>
                <th>Monto Avalado</th>
            </tr>
            </thead>
            <tbody>
            <g:set var="total" value="${0}"/>
            <g:each in="${detalle}" var="asg">
                <g:set var="total" value="${total.toDouble() + asg.monto}"/>
                <tr>
                    <td>${asg.asignacion.fuente.descripcion}</td>
                    <td>${asg.asignacion.presupuesto.descripcion}</td>
                    <td style="text-align: right">
                        <g:formatNumber number="${asg.asignacion.priorizado}" format="###,##0" minFractionDigits="2" maxFractionDigits="2"/>
                    </td>
                    <td style="text-align: right" id="monto_${asg.id}">
                        <g:formatNumber number="${asg.monto}" format="###,##0" minFractionDigits="2" maxFractionDigits="2"/>
                    </td>
                    <td style="text-align: right;">
                        <g:if test="${edi == 'si'}">
                            <input type="text" class="form-control input-sm required det_${asg.id} detalle decimal" iden="${asg.id}" name="montoAvalado"
                                   value="${g.formatNumber(number: asg.monto, maxFractionDigits: 2, minFractionDigits: 2)}" readonly="true"
                                   style="width: 100px;text-align: right; float: right" max="${asg.monto}">
                        </g:if>
                        <g:else>
                            <input type="text" class="form-control input-sm required det_${asg.id} detalle decimal" iden="${asg.id}" name="montoAvalado"
                                   value="${g.formatNumber(number: asg.monto, maxFractionDigits: 2, minFractionDigits: 2)}"
                                   style="width: 100px;text-align: right; float: right" max="${asg.monto}">
                        </g:else>

                    </td>

                </tr>
            </g:each>
            <tr>
                <td colspan="3" style="font-weight: bold">TOTAL PROCESO</td>
                <td style="font-weight: bold;text-align: right"><g:formatNumber number="${total}" format="###,##0" minFractionDigits="2" maxFractionDigits="2"/></td>
                <td style="font-weight: bold;text-align: right" id="total" valor="${total}"><g:formatNumber number="${total}" format="###,##0" minFractionDigits="2" maxFractionDigits="2"/></td>
            </tr>
            </tbody>
        </table>

    </fieldset>
</g:form>

<script type="text/javascript">
    $(".btn").button();
    $(".detalle").blur(function () {
        calcular();
        monto();
    });

    function monto () {
        var monto = $("#total").attr("valor");
        $("#monto").val(monto);
    }

    function calcular() {

        var total = 0;
        $("#datos").val("");
        $(".detalle").each(function () {
            var monto = $(this).val();
//            console.log("monto " + monto)
            monto = monto.replace(new RegExp(",", 'g'), ".");
            var max = $(this).attr("max");
            if (monto == "")
                monto = 0;
            if (isNaN(monto))
                monto = 0;
            else
                monto = monto * 1;
            if (monto == 0)
                $(this).val(monto);
            if (monto > max * 1) {
                log("El monto avalado no puede ser mayor al monto planificado",'error');
                $(this).val(0)
                monto = 0
            }
            $("#datos").val($("#datos").val() + $(this).attr("iden") + ";" + monto + "&");
            total += monto
        });
        $("#total").html(total);
        $("#total").attr("valor", total)
    }


    var validator = $("#frmLiberar").validate({
        errorClass     : "help-block",
        errorPlacement : function (error, element) {
            if (element.parent().hasClass("input-group")) {
                error.insertAfter(element.parent());
            } else {
                error.insertAfter(element);
            }
            element.parents(".grupo").addClass('has-error');
        },
        success        : function (label) {
            label.parents(".grupo").removeClass('has-error');
            label.remove();
        }
    });

</script>
