<table>
    <tbody>
        <th class="ui-state-default">Proyecto</th>
        <th class="ui-state-default">Unidad</th>
        <th class="ui-state-default">Provincia</th>

        <th class="ui-state-default">Componente</th>
        <th class="ui-state-default">Actividad</th>

        <th class="ui-state-default">Indicador</th>

        <th class="ui-state-default">Cant&oacute;n</th>
        <th class="ui-state-default">Parroquia</th>
        <th class="ui-state-default">Meta</th>
        <th class="ui-state-default">Inversión</th>
    </tbody>
    <tbody>
        <g:each in="${metas}" var="meta" status="i">
            <tr>

                <td>${meta.marcoLogico.proyecto}</td>
                <td>${meta.marcoLogico.proyecto.unidadEjecutora}</td>
                <td>${meta?.parroquia?.canton?.provincia}</td>

                <td>${meta.marcoLogico?.marcoLogico?.objeto}</td>
                <td>${meta.marcoLogico?.objeto}</td>

                <td>${meta.tipoMeta}</td>
                <td>${meta?.parroquia?.canton}</td>
                <td>${meta?.parroquia}</td>
                <td style="text-align: right;">
                    <g:formatNumber number="${meta?.indicador}" format="###,##0" minFractionDigits="2" maxFractionDigits="2"/>
                </td>

                <td style="text-align: right;">
                    <g:formatNumber number="${meta?.inversion}" format="###,##0" minFractionDigits="2" maxFractionDigits="2"/>
                </td>

            </tr>
        </g:each>
    </tbody>
</table>
<script type="text/javascript">
    $(".btn").button()

</script>