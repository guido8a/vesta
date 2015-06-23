<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 08/05/15
  Time: 12:50 PM
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <meta name="layout" content="reportesReformaSolicitud"/>
        <title>
            ${reforma.tituloReforma}
        </title>
    </head>

    <body>
        <g:render template="/reportesReformaTemplates/previewReforma"
                  model="[reforma: reforma, det: det, tipo: 'e', unidades: unidades]"/>
    </body>
</html>