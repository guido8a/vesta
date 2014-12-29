<table class="ui-widget-content ui-corner-all" width="100%" style="font-size: 13px;">
    <thead style="font-size: 14px;">
        <tr>

            <g:each in="${headers}" var="titulo" status="i">
                <th class="ui-widget-header ${(i == 0) ? 'ui-corner-tl' : ''}">${titulo.text}</th>
            </g:each>
            <th class="ui-widget-header ui-corner-tr">
                Eliminar
            </th>
        </tr>
    </thead>
    <tbody>
        <g:if test="${lista.size() == 0}">
            <tr>
                <td colspan="${headers.size() + 1}" class="ui-state-active ui-corner-bottom"
                    style="font-weight: bold; padding: 5px; font-size: larger; text-align: center;">
                    No se encontraron ${tipo} para este proyecto
                </td>
            </tr>
        </g:if>
        <g:else>
            <g:each in="${lista}" var="elem" status="i">
                <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                    <g:each in="${headers}" var="titulo">
                        <td style="text-align: ${titulo.align};">
                            <g:if test="${elem[titulo.name]?.class == java.sql.Timestamp}">
                                ${elem[titulo.name].format('dd-MM-yyyy')}
                            </g:if>
                            <g:else>
                                <g:if test="${elem[titulo.name]?.class == java.lang.Double}">
                                    <g:formatNumber number="${elem[titulo.name]}"
                                                    format="###,##0"
                                                    minFractionDigits="2" maxFractionDigits="2"/>
                                </g:if>
                                <g:else>
                                    <g:if test="${titulo.property && elem[titulo.name]}">
                                        ${elem[titulo.name][titulo.property]}
                                    </g:if>
                                    <g:else>
                                        ${elem[titulo.name]}
                                    </g:else>
                                </g:else>
                            </g:else>
                        </td>
                    </g:each>
                    <td style="text-align: center;">
                        <g:checkBox name="id" id="${elem.id}" value="${elem.id}" class="del"
                                    checked="false"/>
                    </td>
                </tr>
            </g:each>
        </g:else>
    </tbody>
    <g:if test="${lista.size() > 0}">
        <tfoot>
            <tr>
                <g:if test="${headers.size() - 1 > 0}">
                    <td colspan="${headers.size() - 1}">&nbsp;</td>
                </g:if>
                <td class="ui-state-active" style="text-align: right; color: #000000; padding-right: 15px;">
                    Chequear todos
                </td>
                <td class="ui-state-active ui-corner-br" style="text-align: center;">
                    <g:checkBox name="delAll" id="delAll" value="all"
                                checked="false" title="Todos"/>
                </td>
            </tr>
        </tfoot>
    </g:if>
</table>

<script type="text/javascript">
    $(function() {

        var clase = "ui-state-highlight";

        $("#delAll").click(function() {
            $(".del").attr("checked", $("#delAll").is(":checked"));
            if ($("#delAll").is(":checked")) {
                $(".del").parent().parent().addClass(clase);
            } else {
                $(".del").parent().parent().removeClass(clase);
            }
        });

        $(".del").click(function() {

            var sel = true;
            $(".del").each(function() {
                if ($(this).is(":checked")) {
                    $(this).parent().parent().addClass(clase);
                    sel = sel & true;
                } else {
                    $(this).parent().parent().removeClass(clase);
                    sel = sel & false;
                }
            });
            if (sel) {
                $("#delAll").attr("checked", true);
            } else {
                $("#delAll").attr("checked", false);
            }
        });
    });
</script>