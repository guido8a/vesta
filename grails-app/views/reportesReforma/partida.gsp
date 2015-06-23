<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 04/05/15
  Time: 11:40 AM
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <meta name="layout" content="reportesReformaSolicitud"/>
        <title>
            ${reforma.tituloSolicitud}
        </title>
    </head>

    <body>
        <g:render template="/reportesReformaTemplates/solicitud"
                  model="[reforma: reforma, det: det, tipo: 'p', unidades: unidades]"/>
    </body>
</html>