<table class="table table-condensed table-bordered table-hover" style="margin-top: 5px;">
    <thead>
        <tr>
            <th>Responsable</th>
            <th>Tipo</th>
            <th>Desde</th>
            <th>Hasta</th>
            <th>Observaciones</th>
            <th width="35">&nbsp;</th>
        </tr>
    </thead>

    <tbody id="tbResponsables">
        <g:each in="${responsables}" var="res">
            <tr class="${res.tipo.id}_${res.responsable.id}" id="${res.id}">
                <td class="responsable" id="${res.responsable.id}">
                    ${res.responsable.nombre} ${res.responsable.apellido}
                </td>
                <td class="tipo" id="${res.tipo.descripcion}">
                    ${res.tipo.descripcion}
                </td>
                <td class="desde">
                    ${res.desde.format("dd-MM-yyyy")}
                </td>
                <td class="hasta">
                    ${res.hasta.format("dd-MM-yyyy")}
                </td>
                <td class="observaciones">
                    ${res.observaciones}
                </td>
                <td>
                    <a href="#" class="btn btn-danger btn-xs btnDeleteRes" data-id="${res.id}" title="Dar de baja">
                        <i class="fa fa-power-off"></i>
                    </a>
                </td>
            </tr>
        </g:each>
    </tbody>
</table>

<script type="text/javascript">
    $(function () {
        $(".btnDeleteRes").click(function () {
            var id = $(this).data("id");
            $.ajax({
                type    : "POST",
                url     : "${createLink(action: 'removeResponable_ajax')}",
                data    : {
                    id : id
                },
                success : function (msg) {
                    var parts = msg.split("*");
                    log(parts[1], parts[0] == "SUCCESS" ? "success" : "error"); // log(msg, type, title, hide)
                    closeLoader();
                    if (parts[0] == "SUCCESS") {
                        reloadTablaResponsables();
                    } else {
                        return false;
                    }
                }
            });
        });
    });
</script>