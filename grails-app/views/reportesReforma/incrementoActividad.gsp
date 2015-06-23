<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 06/05/15
  Time: 10:39 AM
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
                  model="[reforma: reforma, det: det, det2: det2, tipo: 'c', unidades: unidades]"/>
    </body>
</html>