<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 9/19/11
  Time: 11:34 AM
  To change this template use File | Settings | File Templates.
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <meta name="layout" content="main"/>
        <title>Error</title>
    </head>

    <body>
        <g:link action="documentos" id="${id}" name="btn_back">Regresar</g:link>

        <div style="padding: 0 .7em; margin-top: 10px;" class="ui-state-error ui-corner-all">
            <p>
                <span style="float: left; margin-right: .3em;" class="ui-icon ui-icon-alert"></span>
                <strong>Ha ocurrido un error:</strong> No se ha podido encontrar el archivo solicitado:
            </p>

            <p style="padding-left: 50px; font-weight: bold; font-style: italic;">
                ${archivo}
            </p>
        </div>

        <script type="text/javascript">
            $(function() {
                $("[name=btn_back]").button({
                    icons: {
                        primary: "ui-icon-arrowthick-1-w"
                    }
                });
            });
        </script>

    </body>
</html>