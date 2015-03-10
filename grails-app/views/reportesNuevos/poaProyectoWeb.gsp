<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 10/03/15
  Time: 11:35 AM
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
                        <th>Responsable</th>
                        <th>Fecha ini.</th>
                        <th>Fecha fin</th>
                        <th>Asignación</th>
                    </tr>
                </thead>
                <tbody>
                    <g:each in="${MarcoLogico.findAllByProyectoAndTipoElemento(p, TipoElemento.get(3))}" var="act">
                        <g:each in="${Asignacion.findAllByMarcoLogico(act)}" var="asg">
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
            </table>
        </g:each>
    </body>
</html>