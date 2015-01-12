<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 6/22/11
  Time: 12:04 PM
  To change this template use File | Settings | File Templates.
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta name="layout" content="main"/>

    <script type="text/javascript"
            src="${resource(dir: 'js/jquery/plugins/validation', file: 'jquery.validate.min.js')}"></script>
    <script type="text/javascript"
            src="${resource(dir: 'js/jquery/plugins/validation', file: 'additional-methods.js')}"></script>
    <script type="text/javascript"
            src="${resource(dir: 'js/jquery/plugins/validation', file: 'messages_es.js')}"></script>

    <script type="text/javascript"
            src="${resource(dir: 'js/jquery/plugins/qtip', file: 'jquery.qtip.min.js')}"></script>

    <link rel="stylesheet" href="${resource(dir: 'js/jquery/plugins/qtip', file: 'jquery.qtip.css')}"/>

    <title>
        Politicas del proyecto
    </title>
</head>

<body>

<div class="dialog" title="Politicas">
    <table>
        <thead>
        <tr style="padding: 5px;">
            <th style="padding: 5px;" class="ui-widget-header ui-corner-tl">
                <input type="checkbox" name="selAll" id="selAll"/>
            </th>
            <th style="padding: 5px;" class="ui-widget-header ui-corner-tr">
                Politica
            </th>
        </tr>
        </thead>
        <tbody>
        <g:each in="${pols}" status="i" var="pol">
            <tr class="${i % 2 == 0 ? 'even' : 'odd'}">
                <td style="text-align: center;">
                    <input type="checkbox" name="sel" class="sel"
                           id="sel_${pol.politica.id}" ${(pol.contains || pol.contains == "true") ? "checked" : ""}/>
                </td>
                <td>
                    ${pol.politica.descripcion}
                </td>
            </tr>
        </g:each>
        </tbody>
    </table>
</div>


<script type="text/javascript">
    $(function() {
        $("#selAll").click(function() {
            $(".sel").attr("checked", $("#selAll").is(":checked"));
        });

        $(".sel").click(function() {
            var sel = true;
            $(".sel").each(function() {
                if ($(this).is(":checked")) {
                    sel = sel & true;
                } else {
                    sel = sel & false;
                }
            });
            if (sel) {
                $("#selAll").attr("checked", true);
            } else {
                $("#selAll").attr("checked", false);
            }
        });
    });
</script>

</body>
</html>