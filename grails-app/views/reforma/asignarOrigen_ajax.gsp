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
                    <g:formatNumber number="${detalle.valor}" type="currency" currencySymbol=""/>
                </td>
                <td id="max">

                </td>
            </tr>
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

                    $("#max").html("$" + number_format(ok, 2, ".", ","))
                            .attr("valor", ok).data("max", ok);
                    $("#monto").attr("tdnMax", ok);
                }
            });
        }
    }

    $(function () {
        $("#proyecto").val("-1").change(function () {
            $("#divComp").html(spinner);
            $.ajax({
                type    : "POST",
                url     : "${createLink(controller: 'modificacionesPoa', action:'componentesProyectoAjuste_ajax')}",
                data    : {
                    id : $("#proyecto").val()
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