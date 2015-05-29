<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 04/05/15
  Time: 10:50 AM
--%>


<%@ page contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <meta name="layout" content="reportesReformaSolicitud"/>
        <title>
            ${reforma.tipo == 'R' ? 'Solicitud de reforma' : 'Ajuste'} al POA
        </title>
    </head>

    <body>
        <g:render template="/reportesReformaTemplates/solicitud"
                  model="[reforma: reforma, det: det, tipo: 'e', unidades: unidades]"/>
    </body>
</html>