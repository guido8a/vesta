<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 10/04/15
  Time: 03:28 PM
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <meta name="layout" content="main">
        <title>POA por Área de Gestión del año ${anio.anio}</title>
    </head>

    <body>
        <h1>POA por Área de gestión del año ${anio.anio}</h1>

        <table class="table table-bordered table-hover table-condensed table-bordered">
            <thead>
                <tr>
                    <th>Responsable</th>
                    <th>Total</th>
                </tr>
            </thead>
            <tbody>
                <g:set var="total" value="${0}"/>
                <g:each in="${data}" var="v">
                    <g:set var="total" value="${total + v.value.total}"/>
                    <tr>
                        <td>${v.value.responsable}</td>
                        <td class="text-right"><g:formatNumber number="${v.value.total}" type="currency" currencySymbol=""/></td>
                    </tr>
                </g:each>
            </tbody>
            <tfoot>
                <tr>
                    <th class="text-right">TOTAL</th>
                    <th class="text-right"><g:formatNumber number="${total}" type="currency" currencySymbol=""/></th>
                </tr>
            </tfoot>
        </table>

    </body>
</html>