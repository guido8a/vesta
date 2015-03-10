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
            <h1>${p.nombre} <small>${anio}</small></h1>
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