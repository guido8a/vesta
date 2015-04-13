<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 13/04/15
  Time: 10:45 AM
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <meta name="layout" content="main">
        <title>POA por Grupo de Gasto del año ${anio.anio}</title>
    </head>

    <body>
        <h1>POA por Grupo de Gasto del año ${anio.anio}</h1>

        <table class="table table-bordered table-hover table-condensed table-bordered">
            <thead>
                <tr>
                    <th>Partida presupuestaria padre</th>
                    <th>Partida presupuestaria</th>
                    <th>Total</th>
                </tr>
            </thead>
            <tbody>
                <g:set var="totalFinal" value="${0}"/>
                <g:each in="${data}" var="v">
                    <g:set var="total" value="${0}"/>
                    <g:each in="${v.value.hijos}" var="v1">
                        <tr>
                            <td>${v.value.padre}</td>
                            <td>${v1.value.partida}</td>
                            <td>${v1.value.total}</td>
                        </tr>
                    </g:each>
                </g:each>
            </tbody>
            <tfoot>
                <tr>
                    <th class="text-right">TOTAL</th>
                    <th class="text-right"><g:formatNumber number="${totalFinal}" type="currency" currencySymbol=""/></th>
                </tr>
            </tfoot>
        </table>

    </body>
</html>