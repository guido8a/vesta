<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 28/11/14
  Time: 11:56 AM
--%>


<%@ page import="vesta.parametros.TipoElemento; vesta.parametros.TipoElemento; vesta.parametros.TipoElemento; vesta.parametros.TipoElemento; vesta.parametros.TipoElemento; vesta.parametros.TipoElemento; vesta.parametros.TipoElemento; vesta.parametros.TipoElemento; vesta.proyectos.MarcoLogico; vesta.parametros.TipoElemento" contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <title>Reporte de Total de Priorización</title>
        <rep:estilos orientacion="p" pagTitle="Reporte de Total de Priorización"/>
        <style type="text/css">

        table {
            font-size : 9pt;
        }

        th {
            background : #cccccc;
        }

        ol {
            counter-reset : item;
            padding       : 0;
        }

        ol li {
            display       : block;
            margin-bottom : 15px;
        }

        ol li:before {
            content           : counter(item) ". ";
            counter-increment : item;
            font-weight       : bold;
        }

        td {
            text-align : center;
        }

        .table {
            border-collapse : collapse;
        }

        .table, .table td, .table th {
            border : solid 1px #555;
        }
        </style>
    </head>

    <body>
        <rep:headerFooter titulo="Reporte Total Priorización"/>


        %{--<table>--}%
        <table class="table table-condensed table-bordered table-striped table-hover">
            <thead>
                <tr>
                    <th style="text-align: center">Proyecto</th>
                    <th style="text-align: center">Unidad Administrativa</th>
                    <th style="text-align: center">Monto Planificado</th>
                    <th style="text-align: center">Priorizado</th>
                </tr>
            </thead>
            <tbody>
                <g:set var="total" value="${0}"/>
                <g:set var="total2" value="${0}"/>
                <g:each in="${proyectos}" var="pro" status="i">
                    <tr>
                        <td style="text-align: left">
                            ${pro?.nombre}
                        </td>
                        <td>
                            ${pro?.unidadAdministradora}
                        </td>
                        <td style="text-align: right">
                            <g:set var="marcos" value="${0}"/>
                            <g:set var="subTotal" value="${0}"/>
                            <g:each in="${MarcoLogico.findAllByProyectoAndTipoElemento(pro, TipoElemento.get(3))}" var="parcial">
                                <g:set var="marcos" value="${marcos + parcial?.monto}"/>
                            </g:each>
                            <g:set var="total" value="${total + marcos}"/>
                            <g:formatNumber number="${marcos}" type="currency" currencySymbol=""/>
                        </td>
                        <td style="text-align: right">
                            <g:each in="${MarcoLogico.findAllByProyectoAndTipoElemento(pro, TipoElemento.get(3))}" var="mlo">
                                <g:set var="subTotal" value="${subTotal + mlo?.getTotalPriorizado()}"/>
                            </g:each>
                            <g:set var="total2" value="${total2 + subTotal}"/>
                            <g:formatNumber number="${subTotal}" type="currency" currencySymbol=""/>
                        </td>
                    </tr>
                </g:each>
            </tbody>
            <tfoot>
                <tr>
                    <th colspan="2">TOTAL</th>
                    <th style="text-align: right;">
                        <g:formatNumber number="${total}" type="currency" currencySymbol=""/>
                    </th>
                    <th style="text-align: right;">
                        <g:formatNumber number="${total2}" type="currency" currencySymbol=""/>
                    </th>
                </tr>
            </tfoot>
        </table>
    </body>
</html>