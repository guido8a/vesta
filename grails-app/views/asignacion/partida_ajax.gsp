<%--
  Created by IntelliJ IDEA.
  User: fabricio
  Date: 31/08/15
  Time: 01:21 PM
--%>
<div style="width: 100%;height: 500px;overflow-y: auto;float: right;">
    <table class="table table-condensed table-bordered table-striped table-hover" style="width: 600px;">
        <thead>
        <th style="width: 100px">Número</th>
        <th style="width: 250px">Partida</th>
        <th style="width: 70px">Acciones</th>
        </thead>
        <tbody id="tdDetalles">
        <g:each in="${partidas}" var="partida">
            <tr id="trPartidas" data-id="${partida?.id}">
                <td>
                    ${partida?.numero}
                </td>
                <td>
                    ${partida?.descripcion}
                </td>
                <td style="text-align: center">
                    <a href="#" id="btnSel"  class="btn btn-success btn-sm btnP" title="Seleccionar" prt="${partida?.id}" num="${partida?.numero}" des="${partida?.descripcion}"><i class="fa fa-check"></i></a>
                </td>
            </tr>
        </g:each>
        </tbody>
    </table>
</div>


<script type="text/javascript">

    $(".btnP").click(function () {
//        console.log("--->" + $(this).attr("prt"));
//        $("#prsp_id").val($(this).attr("prt"));
        var tt = ($(this).attr("num") + " - " +  $(this).attr("des"))
        $("#prsp_id").val(tt);
        $("#prsp_hide").val($(this).attr("prt"));
        $("#dlgPartida").modal("hide");

    });


</script>