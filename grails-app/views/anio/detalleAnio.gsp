<input type="hidden" value="${anio.id}" id="anio">
<table class="table table-condensed table-bordered table-striped">
    <thead>
        <tr>
            <th>Código</th>
            <th>Proyecto</th>
            <th>Total</th>
        </tr>
    </thead>
    <tbody>
        <g:each in="${arr}" var="a">
            <tr>
                <td>${a.proyecto.codigo}</td>
                <td>${a.proyecto.nombre}</td>
                <td class="text-right">
                    <g:formatNumber number="${a.total}" type="currency" currencySymbol=""/>
                </td>
            </tr>
        </g:each>
    </tbody>
    <tfoot>
        <tr>
            <th colspan="2" class="text-center">Total</th>
            <th class="text-right">
                <g:formatNumber number="${total}" type="currency" currencySymbol=""/>
            </th>
        </tr>
    </tfoot>
</table>

<g:if test="${anio.estado == 0}">
    <a href="#" style="margin-top: 10px;margin-bottom: 10px" class="btn btn-primary" id="aprobar">Aprobar proforma</a>
</g:if>
<g:else>
    Las asignaciones ya han sido aprobadas para este año
</g:else>
<script type="text/javascript">


    $("#aprobar").click(function () {
        var boton = $(this);
        bootbox.confirm({
                    message  : "Esta seguro?",
                    title    : "Advertencia",
                    class    : "modal-error",
                    callback : function (result) {
                        if (result) {
                            openLoader();
                            $.ajax({
                                type    : "POST",
                                url     : "${createLink(action:'aprobarAnio')}",
                                data    : {
                                    anio : $("#anio").val()
                                },
                                success : function (msg) {
                                    if (msg != "no") {
                                        window.location.href = "${createLink(action:'vistaAprobarAño')}"
                                    } else {
                                        log("Error interno")
                                    }
                                }
                            });
                        }

                    }
                }
        );

    });
</script>