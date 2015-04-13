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
            font-size : 70%;
            color     : #777;
        }
        </style>

    </head>

    <body>
        <rep:headerFooter title="POA Proyecto${proys.size() == 1 ? '' : 's'}"/>

        <g:each in="${proys}" var="p" status="i">
            <g:set var="total" value="${0}"/>
            <h1 class="${i > 0 ? 'break' : ''}">${p.nombre} <small>${anio}</small></h1>
            <table class="table table-condensed table-bordered">
                <thead>
                    <tr>
                        <th style="width: 220px">Componente</th>
                        <th style="width: 515px">Actividad</th>
                        <th>Responsable</th>
                        <th style="width: 85px">Fecha ini.</th>
                        <th style="width: 85px">Fecha fin</th>
                        <th style="width: 120px">Asignación</th>
                    </tr>
                </thead>
                <tbody>
                    <g:each in="${MarcoLogico.findAllByProyectoAndTipoElemento(p, TipoElemento.get(3))}" var="act">
                        <g:each in="${Asignacion.findAllByMarcoLogico(act)}" var="asg">
                            <g:set var="total" value="${total + act.monto}"/>
                            <tr>
                                <td>${asg.marcoLogico.marcoLogico.objeto}</td>
                                <td>${asg.marcoLogico.objeto}</td>
                                <td>${act.responsable}</td>
                                <td>${act.fechaInicio.format("dd-MM-yyyy")}</td>
                                <td>${act.fechaFin.format("dd-MM-yyyy")}</td>
                                <td class="text-right"><g:formatNumber number="${act.monto}" type="currency" currencySymbol=""/></td>
                            </tr>
                        </g:each>
                    </g:each>
                </tbody>
                <tfoot>
                    <tr>
                        <th colspan="5" class="text-right">TOTAL</th>
                        <th class="text-right"><g:formatNumber number="${total}" type="currency" currencySymbol=""/></th>
                    </tr>
                </tfoot>
            </table>
        </g:each>
    </body>
</html>