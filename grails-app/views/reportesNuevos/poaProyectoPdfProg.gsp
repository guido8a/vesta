<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 10/03/15
  Time: 02:44 PM
--%>

<%@ page import="vesta.poa.ProgramacionAsignacion; vesta.poa.Asignacion; vesta.parametros.TipoElemento; vesta.proyectos.MarcoLogico; vesta.parametros.poaPac.Mes" contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <title>POA Proyecto${proys.size() == 1 ? '' : 's'}</title>

        <rep:estilos orientacion="l" pagTitle="POA Proyecto${proys.size() == 1 ? '' : 's'}"/>

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
        <rep:headerFooter title="POA Proyecto${proys.size() == 1 ? '' : 's'}"/>

        <g:each in="${proys}" var="p" status="i">

            <g:set var="totalAsg" value="${0}"/>

            <g:set var="total0" value="${0}"/>
            <g:set var="total1" value="${0}"/>
            <g:set var="total2" value="${0}"/>
            <g:set var="total3" value="${0}"/>
            <g:set var="total4" value="${0}"/>
            <g:set var="total5" value="${0}"/>
            <g:set var="total6" value="${0}"/>
            <g:set var="total7" value="${0}"/>
            <g:set var="total8" value="${0}"/>
            <g:set var="total9" value="${0}"/>
            <g:set var="total10" value="${0}"/>
            <g:set var="total11" value="${0}"/>

            <h1 class="${i > 0 ? 'break' : ''}">${p.nombre} <small>${anio}</small></h1>
            <table class="table table-condensed table-bordered">
                <thead>
                    <tr>
                        <th style="width: 100px;">Componente</th>
                        <th style="width: 100px;">Actividad</th>
                        <th style="width: 50px;">Partida</th>
                        <th style="width: 80px;">Asignación</th>
                        <g:each in="${Mes.list([sort: 'numero'])}" var="m">
                            <th style="width: 80px;">${m.descripcion[0..2]}.</th>
                        </g:each>
                    </tr>
                </thead>
                <tbody>
                    <g:each in="${MarcoLogico.findAllByProyectoAndTipoElemento(p, TipoElemento.get(3))}" var="act">
                        <g:each in="${Asignacion.findAllByMarcoLogico(act)}" var="asg">
                            <g:set var="val" value="${asg.priorizado != 0 ? asg.priorizado : asg.planificado}"/>
                            <g:set var="totalAsg" value="${totalAsg + val}"/>
                            <tr>
                                <td>${asg.marcoLogico.marcoLogico.objeto}</td>
                                <td title="${asg.marcoLogico.objeto}">${asg.marcoLogico.objeto.size() > 50 ? asg.marcoLogico.objeto[0..49] + '...' : asg.marcoLogico.objeto}</td>
                                <td class="text-right">${asg.presupuesto.numero}</td>
                                <td class="text-right"><g:formatNumber number="${val}" type="currency" currencySymbol=""/></td>
                                <g:each in="${meses}" var="m" status="j">
                                    <g:set var="prog" value="${ProgramacionAsignacion.findByMesAndAsignacion(m, asg)}"/>
                                    <g:set var="val" value="${prog ? prog.valor : 0}"/>
                                    <g:if test="${j == 0}">
                                        <g:set var="total0" value="${total0 + val}"/>
                                    </g:if>
                                    <g:if test="${j == 1}">
                                        <g:set var="total1" value="${total1 + val}"/>
                                    </g:if>
                                    <g:if test="${j == 2}">
                                        <g:set var="total2" value="${total2 + val}"/>
                                    </g:if>
                                    <g:if test="${j == 3}">
                                        <g:set var="total3" value="${total3 + val}"/>
                                    </g:if>
                                    <g:if test="${j == 4}">
                                        <g:set var="total4" value="${total4 + val}"/>
                                    </g:if>
                                    <g:if test="${j == 5}">
                                        <g:set var="total5" value="${total5 + val}"/>
                                    </g:if>
                                    <g:if test="${j == 6}">
                                        <g:set var="total6" value="${total6 + val}"/>
                                    </g:if>
                                    <g:if test="${j == 7}">
                                        <g:set var="total7" value="${total7 + val}"/>
                                    </g:if>
                                    <g:if test="${j == 8}">
                                        <g:set var="total8" value="${total8 + val}"/>
                                    </g:if>
                                    <g:if test="${j == 9}">
                                        <g:set var="total9" value="${total9 + val}"/>
                                    </g:if>
                                    <g:if test="${j == 10}">
                                        <g:set var="total10" value="${total10 + val}"/>
                                    </g:if>
                                    <g:if test="${j == 11}">
                                        <g:set var="total11" value="${total11 + val}"/>
                                    </g:if>
                                    <td class="text-right">
                                        <g:formatNumber number="${val}" type="currency" currencySymbol=""/>
                                    </td>
                                </g:each>
                            </tr>
                        </g:each>
                    </g:each>
                </tbody>
                <tfoot>
                    <tr>
                        <th colspan="3" class="text-right">TOTAL</th>
                        <th class="text-right"><g:formatNumber number="${totalAsg}" type="currency" currencySymbol=""/></th>
                        <g:each in="${meses}" var="m" status="j">
                            <th class="text-right">
                                <g:set var="val" value="-1"/>
                                <g:if test="${j == 0}">
                                    <g:set var="val" value="${total0}"/>
                                </g:if>
                                <g:if test="${j == 1}">
                                    <g:set var="val" value="${total1}"/>
                                </g:if>
                                <g:if test="${j == 2}">
                                    <g:set var="val" value="${total2}"/>
                                </g:if>
                                <g:if test="${j == 3}">
                                    <g:set var="val" value="${total3}"/>
                                </g:if>
                                <g:if test="${j == 4}">
                                    <g:set var="val" value="${total4}"/>
                                </g:if>
                                <g:if test="${j == 5}">
                                    <g:set var="val" value="${total5}"/>
                                </g:if>
                                <g:if test="${j == 6}">
                                    <g:set var="val" value="${total6}"/>
                                </g:if>
                                <g:if test="${j == 7}">
                                    <g:set var="val" value="${total7}"/>
                                </g:if>
                                <g:if test="${j == 8}">
                                    <g:set var="val" value="${total8}"/>
                                </g:if>
                                <g:if test="${j == 9}">
                                    <g:set var="val" value="${total9}"/>
                                </g:if>
                                <g:if test="${j == 10}">
                                    <g:set var="val" value="${total10}"/>
                                </g:if>
                                <g:if test="${j == 11}">
                                    <g:set var="val" value="${total11}"/>
                                </g:if>
                                <g:formatNumber number="${val}" type="currency" currencySymbol=""/>
                            </th>
                        </g:each>
                    </tr>
                </tfoot>
            </table>
        </g:each>
    </body>
</html>