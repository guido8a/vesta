<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 13/03/15
  Time: 12:10 PM
--%>

<%@ page import="vesta.proyectos.MarcoLogico; vesta.poa.Asignacion; vesta.proyectos.Proyecto" contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <meta name="layout" content="main">
        <title>Reporte proyectos</title>
    </head>

    <body>

        <table class="table table-bordered table-condensed">
            <thead>
                <tr>
                    <th>Proyecto</th>
                    <th>Componente</th>
                    <th>#</th>
                    <th>Actividad</th>
                    <th>Responsable</th>
                    <g:each in="${anios}" var="anio">
                        <th>${anio.anio}</th>
                    </g:each>
                </tr>
            </thead>
            <tbody>
                <g:each in="${Proyecto.list([sort: 'nombre'])}" var="proyecto">
                    <tr>
                        <td>${proyecto.nombre}</td>
                        <td>${asg.marcoLogico.marcoLogico.objeto}</td>
                        <td>${asg.marcoLogico.numero}</td>
                        <td>${asg.marcoLogico.objeto}</td>
                        <td>${asg.unidad.nombre}</td>
                        <g:each in="${anios}" var="anio">
                            <g:set var="asignaciones" value="${Asignacion.withCriteria {
                                inList("marcoLogico", MarcoLogico.findAllByProyecto(proyecto))
                                eq("anio", anio)
                                inList("fuente", fuentes)
                            }}"/>
                            <td>
                                <g:formatNumber number="${asignaciones.size() > 0 ? asignaciones.sum {
                                    it.planificado
                                } : 0}" type="currency" currencySymbol=""/>
                            </td>
                        </g:each>
                    </tr>
                </g:each>
            </tbody>
        </table>
    </body>
</html>