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
            <h1 class="${i > 0 ? 'break' : ''}">${p.nombre} <small>${anio}</small></h1>
            <table class="table table-condensed table-bordered">
                <thead>
                    <tr>
                        <th>Componente</th>
                        <th>Actividad</th>
                        <th>Partida</th>
                        <th>Asignación</th>
                        <g:each in="${Mes.list([sort: 'numero'])}" var="m">
                            <th>${m.descripcion[0..2]}.</th>
                        </g:each>
                    </tr>
                </thead>
                <tbody>
                    <g:each in="${MarcoLogico.findAllByProyectoAndTipoElemento(p, TipoElemento.get(3))}" var="act">
                        <g:each in="${Asignacion.findAllByMarcoLogico(act)}" var="asg">
                            <tr>
                                <td>${asg.marcoLogico.marcoLogico.objeto}</td>
                                <td>${asg.marcoLogico.objeto}</td>
                                <td class="text-right">${asg.presupuesto.numero}</td>
                                <td class="text-right"><g:formatNumber number="${asg.priorizado != 0 ? asg.priorizado : asg.planificado}" type="currency" currencySymbol=""/></td>
                                <g:each in="${meses}" var="m">
                                    <g:set var="prog" value="${ProgramacionAsignacion.findByMesAndAsignacion(m, asg)}"/>
                                    <g:set var="val" value="${prog ? prog.valor : 0}"/>
                                    <td class="text-right">
                                        <g:formatNumber number="${val}" type="currency" currencySymbol=""/>
                                    </td>
                                </g:each>
                            </tr>
                        </g:each>
                    </g:each>
                </tbody>
            </table>
        </g:each>
    </body>
</html>