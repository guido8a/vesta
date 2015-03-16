<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 16/03/15
  Time: 01:43 PM
--%>

<%@ page import="vesta.poa.Asignacion; vesta.parametros.TipoElemento; vesta.proyectos.MarcoLogico" contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <title>Proyectos</title>

        <rep:estilos orientacion="p" pagTitle="Reporte de Proyectos"/>
        <style type="text/css">
        .table {
            border-collapse : collapse;
        }

        .table, .table td, .table th {
            border : solid 1px #444;
        }

        .text-right {
            text-align : right;
        }

        h1.break {
            page-break-before : always;
        }

        small {
            font-size : 65%;
            color     : #444;
        }
        </style>
    </head>

    <body>
        <rep:headerFooter title="Reporte Proyectos"/>

        <g:each in="${fuentes}" var="fuente" status="j">
            <h1 class="${j > 0 ? 'break' : ''}">${fuente}</h1>

            <table class="table table-condensed table-bordered table-striped table-hover">
                <thead>
                    <tr>
                        <th>Proyecto</th>
                        <th>Unidad Administrativa</th>
                        <th>Monto Planificado</th>
                        <th>Priorizado</th>
                    </tr>
                </thead>
                <tbody>
                    <g:set var="total1" value="${0}"/>
                    <g:set var="total2" value="${0}"/>
                    <g:each in="${proyectos}" var="pro" status="i">
                        <tr>
                            <td style="text-align: left">
                                ${pro.codigo} - ${pro?.nombre}
                            </td>
                            <td>
                                ${pro?.unidadAdministradora}
                            </td>
                            <td style="text-align: right">
                                <g:set var="total" value="${0}"/>
                                <g:each in="${MarcoLogico.findAllByProyectoAndTipoElemento(pro, TipoElemento.get(3))}" var="marco">
                                    <g:set var="asg" value="${Asignacion.findAllByMarcoLogicoAndFuente(marco, fuente)}"/>
                                    <g:if test="${asg.size() > 0}">
                                        <g:set var="total" value="${total + (asg.sum { it.planificado })}"/>
                                    </g:if>
                                </g:each>
                                <g:set var="total1" value="${total1 + total}"/>
                                <g:formatNumber number="${total}" type="currency" currencySymbol=""/>
                            </td>
                            <td style="text-align: right">
                                <g:set var="total" value="${0}"/>
                                <g:each in="${MarcoLogico.findAllByProyectoAndTipoElemento(pro, TipoElemento.get(3))}" var="marco">
                                    <g:set var="asg" value="${Asignacion.findAllByMarcoLogicoAndFuente(marco, fuente)}"/>
                                    <g:if test="${asg.size() > 0}">
                                        <g:set var="total" value="${total + (asg.sum { it.priorizado })}"/>
                                    </g:if>
                                </g:each>
                                <g:set var="total2" value="${total2 + total}"/>
                                <g:formatNumber number="${total}" type="currency" currencySymbol=""/>
                            </td>
                        </tr>
                    </g:each>
                </tbody>
                <tfoot>
                    <tr>
                        <th colspan="2">TOTAL</th>
                        <th style="text-align: right;">
                            <g:formatNumber number="${total1}" type="currency" currencySymbol=""/>
                        </th>
                        <th style="text-align: right;">
                            <g:formatNumber number="${total2}" type="currency" currencySymbol=""/>
                        </th>
                    </tr>
                </tfoot>
            </table>

        </g:each>

    </body>
</html>