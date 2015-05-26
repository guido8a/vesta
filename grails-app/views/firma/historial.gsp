<%--
  Created by IntelliJ IDEA.
  User: fabricio
  Date: 19/01/15
  Time: 12:33 PM
--%>

<table class="table table-condensed table-bordered table-striped table-hover">
    <thead>
        <tr>
            <th style="width: 90px;">Fecha</th>
            <th style="width: 60px;">Tipo</th>
            %{--<th>Documento</th>--}%
            <th>Concepto</th>
            <th style="width: 80px;">Estado</th>
            <th style="width: 80px;">Ver</th>
        </tr>
    </thead>
    <tbody>
        <g:each in="${datos}" var="firma">
            <tr data-estado="${firma.estado}">
                <td style="text-align: center">${firma.fecha.format("dd-MM-yyyy")}</td>
                <td style="text-align: center">
                    <g:if test="${firma.tipoFirma == 'AVAL'}">
                        Aval
                    </g:if>
                    <g:elseif test="${firma.tipoFirma == 'RFRM'}">
                        Reforma
                    </g:elseif>
                    <g:elseif test="${firma.tipoFirma == 'AJST'}">
                        Ajuste
                    </g:elseif>
                </td>
                %{--<td style="text-align: center">${firma.documento}</td>--}%
                <td>${firma.concepto}</td>
                <td>
                    <g:if test="${firma.estado == 'F'}">
                        Firmado
                    </g:if>
                    <g:elseif test="${firma.estado == 'S'}">
                        Pendiente
                    </g:elseif>
                    <g:else>
                        Negado
                    </g:else>
                </td>
                <td style="text-align: center">
                    <g:if test="${firma.estado == 'F'}">
                        <a href="#" class="imprimir btn btn-info btn-sm" iden="${firma.id}"><i class="fa fa-print"></i> Ver
                        </a>
                    </g:if>
                </td>
            </tr>
        </g:each>
    </tbody>
</table>
<script>
    $(".imprimir").button({icons : {primary : "ui-icon-print"}, text : false}).click(function () {
        location.href = "${createLink(controller:'firma',action:'ver')}/" + $(this).attr("iden")
    })


</script>