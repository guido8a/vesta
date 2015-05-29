<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 07/05/15
  Time: 03:50 PM
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
                  model="[reforma: reforma, det: det, tipo: 'c', unidades: unidades]"/>
    </body>
</html>