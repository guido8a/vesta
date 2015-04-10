<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 10/03/15
  Time: 02:36 PM
--%>

<%@ page import="vesta.poa.ProgramacionAsignacion; vesta.poa.Asignacion; vesta.proyectos.MarcoLogico; vesta.parametros.poaPac.Mes; vesta.parametros.TipoElemento" contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <meta name="layout" content="main">
        <title>POA Proyecto${proys.size() == 1 ? '' : 's'}</title>
    </head>

    <body>
        <g:each in="${proys}" var="p">

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

            <h1>${p.nombre} <small>${anio}</small></h1>
            <table style="width:1400px;" class="table table-condensed table-bordered">
                <thead>
                    <tr>
                        <th style="width: 118px;">Componente</th>
                        <th style="width: 118px;">Actividad</th>
                        <th style="width: 58px;">Partida</th>
                        <th style="width: 85px;">Asignación</th>
                        <g:each in="${meses}" var="m" status="i">
                            <th style="width: 85px;">${m.descripcion[0..2]}.</th>
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
                                <g:each in="${meses}" var="m" status="i">
                                    <g:set var="prog" value="${ProgramacionAsignacion.findByMesAndAsignacion(m, asg)}"/>
                                    <g:set var="val" value="${prog ? prog.valor : 0}"/>
                                    <g:if test="${i == 0}">
                                        <g:set var="total0" value="${total0 + val}"/>
                                    </g:if>
                                    <g:if test="${i == 1}">
                                        <g:set var="total1" value="${total1 + val}"/>
                                    </g:if>
                                    <g:if test="${i == 2}">
                                        <g:set var="total2" value="${total2 + val}"/>
                                    </g:if>
                                    <g:if test="${i == 3}">
                                        <g:set var="total3" value="${total3 + val}"/>
                                    </g:if>
                                    <g:if test="${i == 4}">
                                        <g:set var="total4" value="${total4 + val}"/>
                                    </g:if>
                                    <g:if test="${i == 5}">
                                        <g:set var="total5" value="${total5 + val}"/>
                                    </g:if>
                                    <g:if test="${i == 6}">
                                        <g:set var="total6" value="${total6 + val}"/>
                                    </g:if>
                                    <g:if test="${i == 7}">
                                        <g:set var="total7" value="${total7 + val}"/>
                                    </g:if>
                                    <g:if test="${i == 8}">
                                        <g:set var="total8" value="${total8 + val}"/>
                                    </g:if>
                                    <g:if test="${i == 9}">
                                        <g:set var="total9" value="${total9 + val}"/>
                                    </g:if>
                                    <g:if test="${i == 10}">
                                        <g:set var="total10" value="${total10 + val}"/>
                                    </g:if>
                                    <g:if test="${i == 11}">
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
                        <g:each in="${meses}" var="m" status="i">
                            <th class="text-right">
                                <g:set var="val" value="-1"/>
                                <g:if test="${i == 0}">
                                    <g:set var="val" value="${total0}"/>
                                </g:if>
                                <g:if test="${i == 1}">
                                    <g:set var="val" value="${total1}"/>
                                </g:if>
                                <g:if test="${i == 2}">
                                    <g:set var="val" value="${total2}"/>
                                </g:if>
                                <g:if test="${i == 3}">
                                    <g:set var="val" value="${total3}"/>
                                </g:if>
                                <g:if test="${i == 4}">
                                    <g:set var="val" value="${total4}"/>
                                </g:if>
                                <g:if test="${i == 5}">
                                    <g:set var="val" value="${total5}"/>
                                </g:if>
                                <g:if test="${i == 6}">
                                    <g:set var="val" value="${total6}"/>
                                </g:if>
                                <g:if test="${i == 7}">
                                    <g:set var="val" value="${total7}"/>
                                </g:if>
                                <g:if test="${i == 8}">
                                    <g:set var="val" value="${total8}"/>
                                </g:if>
                                <g:if test="${i == 9}">
                                    <g:set var="val" value="${total9}"/>
                                </g:if>
                                <g:if test="${i == 10}">
                                    <g:set var="val" value="${total10}"/>
                                </g:if>
                                <g:if test="${i == 11}">
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