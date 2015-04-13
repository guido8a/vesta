<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 10/04/15
  Time: 03:45 PM
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <meta name="layout" content="main">
        <title>POA detallado por Área de Gestión del año ${anio.anio}</title>

        <style type="text/css">
        .total {
            font-weight : bold;
        }
        </style>
    </head>

    <body>
        <h1>POA detallado por Área de gestión del año ${anio.anio}</h1>

        <table class="table table-bordered table-hover table-condensed table-bordered">
            <thead>
                <tr>
                    <th style="width: 300px;">Responsable</th>
                    <th>Actividad</th>
                    <th style="width: 150px;">Total</th>
                </tr>
            </thead>
            <tbody>
                <g:set var="totalFinal" value="${0}"/>
                <g:each in="${data}" var="v">
                    <g:set var="total" value="${0}"/>
                    <g:each in="${v.value.actividades}" var="v1">
                        <g:set var="total" value="${total + v1.value.total}"/>
                        <g:set var="totalFinal" value="${totalFinal + v1.value.total}"/>
                        <tr>
                            <td>${v.value.responsable}</td>
                            <td>${v1.value.act.toStringCompleto()}</td>
                            <td class="text-right"><g:formatNumber number="${v1.value.total}" type="currency" currencySymbol=""/></td>
                        </tr>
                    </g:each>
                    <tr class="info">
                        <td colspan="2" class="total">${v.value.responsable} - TOTAL</td>
                        <td class="total text-right"><g:formatNumber number="${total}" type="currency" currencySymbol=""/></td>
                    </tr>
                </g:each>
            </tbody>
            <tfoot>
                <tr class="success">
                    <td colspan="2" class="total">TOTAL</td>
                    <td class="total text-right"><g:formatNumber number="${totalFinal}" type="currency" currencySymbol=""/></td>
                </tr>
            </tfoot>
        </table>

    </body>
</html>