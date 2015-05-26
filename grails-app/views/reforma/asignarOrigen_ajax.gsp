<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 23/04/15
  Time: 03:34 PM
--%>

<form id="frmReforma">
    <table class="table table-bordered table-hover table-condensed" style="margin-top: 10px;">
        <thead>
            <tr>
                <th style="width:234px;">Proyecto</th>
                <th style="width:234px;">Componente</th>
                <th style="width:234px;">Actividad</th>
                <th style="width:234px;">Asignación</th>
                <th style="width:195px;">Monto</th>
                <th style="width:135px;">Máximo</th>
            </tr>
        </thead>
        <tbody>
            <tr class="info">
                <td class="grupo">
                    <g:select from="${proyectos}" optionKey="id" optionValue="nombre" name="proyecto" class="form-control input-sm required requiredCombo"
                              noSelection="['-1': 'Seleccione...']"/>
                </td>
                <td class="grupo" id="divComp">
                </td>
                <td class="grupo" id="divAct">
                </td>
                <td class="grupo" id="divAsg">
                </td>
                <td class="grupo text-right">
                    <div class="input-group">
                        <g:textField type="text" name="monto" class="form-control required input-sm number money"/>
                        <span class="input-group-addon"><i class="fa fa-usd"></i></span>
                    </div>
                </td>
                <td id="max">

                </td>
            </tr>
            <g:if test="${reforma.tipoSolicitud == 'I'}">
                <tr class="success">
                    <td>
                        ${detalle.asignacionDestino.marcoLogico.proyecto.toStringCompleto()}
                    </td>
                    <td>
                        ${detalle.asignacionDestino.marcoLogico.marcoLogico.toStringCompleto()}
                    </td>
                    <td>
                        ${detalle.asignacionDestino.marcoLogico.numero} - ${detalle.asignacionDestino.marcoLogico.toStringCompleto()}
                    </td>
                    <td>
                        ${detalle.asignacionDestino}
                    </td>
                    <td>
                        <strong>Total:</strong> <g:formatNumber number="${detalle.valor}" type="currency" currencySymbol=""/><br/>
                        <strong>Por asignar:</strong> <g:formatNumber number="${detalle.saldo}" type="currency" currencySymbol=""/><br/>
                    </td>
                    <td>

                    </td>
                </tr>
            </g:if>
            <g:elseif test="${reforma.tipoSolicitud == 'C'}">
                <tr class="success">
                    <td>
                        ${detalle.componente.proyecto.toStringCompleto()}
                    </td>
                    <td>
                        ${detalle.componente.toStringCompleto()}
                    </td>
                    <td>
                        Nueva - ${detalle.descripcionNuevaActividad}
                    </td>
                    <td>
                        <strong>Responsable:</strong> ${reforma.persona.unidad}
                        <strong>Priorizado:</strong> ${detalle.valor}
                        <strong>Partida Presupuestaria:</strong> ${detalle.presupuesto}
                        <strong>Año:</strong> ${reforma.anio.anio}
                    </td>
                    <td>
                        <strong>Total:</strong> <g:formatNumber number="${detalle.valor}" type="currency" currencySymbol=""/><br/>
                        <strong>Por asignar:</strong> <g:formatNumber number="${detalle.saldo}" type="currency" currencySymbol=""/><br/>
                    </td>
                    <td>

                    </td>
                </tr>
            </g:elseif>
        </tbody>
    </table>
</form>

<script type="text/javascript">

    function getMaximo(asg) {
        if ($("#asignacion").val() != "-1") {
            $.ajax({
                type    : "POST",
                url     : "${createLink(action:'getMaximoAsg',controller: 'avales')}",
                data    : {
                    id : asg
                },
                success : function (msg) {
                    var valor = parseFloat(msg);
//                            console.log("valor=", valor);
                    var tot = 0;
                    $(".tableReformaNueva").each(function () {
                        var d = $(this).data();
                        if ("" + d.origen.asignacion_id == "" + asg) {
                            tot += parseFloat(d.origen.monto);
                        }
                    });
                    var ok = valor - tot;
//                            console.log("tot=", tot);
//                            console.log("utilizable= ", ok);

                    var val = parseFloat("${detalle.saldo}");
                    var max = Math.min(val, ok);

                    $("#max").html("$" + number_format(max, 2, ".", ","))
                            .attr("valor", max).data("max", max);
                    $("#monto").attr("tdnMax", max);
                }
            });
        }
    }

    $(function () {

        $("#frmReforma").validate({
            errorClass     : "help-block",
            onfocusout     : false,
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

        $("#proyecto").val("-1").change(function () {
            $("#divComp").html(spinner);
            $.ajax({
                type    : "POST",
                url     : "${createLink(controller: 'modificacionesPoa', action:'componentesProyectoAjuste_ajax')}",
                data    : {
                    id : $("#proyecto").val(),
                    anio: "${anio}"
                },
                success : function (msg) {
                    $("#divComp").html(msg);
                    $("#divAct").html("");
                    $("#divAsg").html("");
                }
            });
        });
    });
</script>