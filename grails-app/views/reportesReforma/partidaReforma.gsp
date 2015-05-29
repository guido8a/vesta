<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 04/05/15
  Time: 12:27 AM
--%>


<%@ page contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <meta name="layout" content="reportesReforma"/>
        <title>
            Reforma al POA
        </title>
    </head>

    <body>
        <g:render template="/reportesReformaTemplates/reforma"
                  model="[reforma: reforma, det: det, tipo: 'p', unidades: unidades]"/>
    </body>
</html>