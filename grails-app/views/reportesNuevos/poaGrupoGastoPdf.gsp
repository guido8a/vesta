<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 13/04/15
  Time: 02:57 PM
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <title>POA por Grupo de Gastos</title>

        <rep:estilos orientacion="l" pagTitle="POA: Resumen por Grupo de Gasto ${anio.anio}"/>

        <style type="text/css">
        .table {
            margin-top      : 0.5cm;
            width           : 100%;
            border-collapse : collapse;
        }

        .table, .table td, .table th {
            border : solid 1px #444;
        }

        .table td, .table th {
            padding : 3px;
        }

        .text-right {
            text-align : right;
        }

        h1.break {
            page-break-before : always;
        }

        small {
            font-size : 70%;
            color     : #777;
        }

        .table th {
            background     : #326090;
            color          : #fff;
            text-align     : center;
            text-transform : uppercase;
        }

        .actual {
            background : #c7daed;
        }

        .info {
            background : #6fa9ed;
        }

        .text-right {
            text-align : right !important;
        }

        .text-center {
            text-align : center;
        }
        </style>

    </head>

    <body>
        <rep:headerFooter title="PLAN OPERATIVO ANUAL POA ${anio.anio}" subtitulo="Resumen por Grupo de Gasto"/>

        <table class="table table-bordered table-hover table-condensed table-bordered">
            <thead>
                <tr>
                    <th></th>
                    <th></th>
                    <th>Arrastre ${anio.anio.toInteger() - 1}</th>
                    <th>Requerimientos ${anio.anio}</th>
                    <th>Total ${anio.anio}</th>
                    <g:each in="${anios}" var="a">
                        <th>${a}</th>
                    </g:each>
                    <th>Total Plurianual</th>
                </tr>
            </thead>
            <tbody>
                <g:each in="${data}" var="v">
                    <tr>
                        <td>${v.partida.descripcion}</td>
                        <td class="text-center">${v.partida.numero.replaceAll("0", "")}</td>
                        <td class="text-right actual">
                            <g:if test="${v.valores["" + (anio.anio.toInteger() - 1)] > 0}">
                                <g:formatNumber number="${v.valores["" + (anio.anio.toInteger() - 1)]}" type="currency" currencySymbol=""/>
                            </g:if>
                            <g:else>
                                -
                            </g:else>
                        </td>
                        <td class="text-right actual">
                            <g:if test="${v.valores[anio.anio] > 0}">
                                <g:formatNumber number="${v.valores[anio.anio]}" type="currency" currencySymbol=""/>
                            </g:if>
                            <g:else>
                                -
                            </g:else>
                        </td>
                        <td class="text-right info">
                            <g:if test="${v.valores["T" + anio.anio] > 0}">
                                <g:formatNumber number="${v.valores["T" + anio.anio]}" type="currency" currencySymbol=""/>
                            </g:if>
                            <g:else>
                                -
                            </g:else>
                        </td>
                        <g:each in="${anios}" var="a">
                            <td class="text-right">
                                <g:if test="${v.valores[a] > 0}">
                                    <g:formatNumber number="${v.valores[a] ?: 0}" type="currency" currencySymbol=""/>
                                </g:if>
                                <g:else>
                                    -
                                </g:else>
                            </td>
                        </g:each>
                        <td class="text-right">
                            <g:formatNumber number="${v.valores['T']}" type="currency" currencySymbol=""/>
                        </td>
                    </tr>
                </g:each>
            </tbody>
            <tfoot>
                <tr>
                    <th></th>
                    <th class="text-right">TOTAL</th>
                    <th class="text-right"><g:formatNumber number="${totales['2014']}" type="currency" currencySymbol=""/></th>
                    <th class="text-right"><g:formatNumber number="${totales['2015']}" type="currency" currencySymbol=""/></th>
                    <th class="text-right"><g:formatNumber number="${totales['T2015']}" type="currency" currencySymbol=""/></th>
                    <g:each in="${anios}" var="a">
                        <th class="text-right"><g:formatNumber number="${totales[a] ?: 0}" type="currency" currencySymbol=""/></th>
                    </g:each>
                    <th class="text-right"><g:formatNumber number="${totales['T']}" type="currency" currencySymbol=""/></th>
                </tr>
            </tfoot>
        </table>

    </body>
</html>