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

        <g:each in="${fuentes}" var="fuente">
            <h2>${fuente}</h2>

            <table class="table table-bordered table-condensed">
                <thead>
                    <tr>
                        <th>Proyecto</th>
                        <th>Unidad Administrativa</th>
                        <th>Monto Planificado</th>
                    </tr>
                </thead>
                <tbody>
                    <g:each in="${Proyecto.list([sort: 'nombre'])}" var="proyecto">
                        <tr>

                        </tr>
                    </g:each>
                </tbody>
            </table>
        </g:each>

    </body>
</html>