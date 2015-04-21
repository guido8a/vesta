<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 21/04/15
  Time: 08:50 AM
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <meta name="layout" content="main">
        <title>Lista de reformas</title>
    </head>

    <body>

        <table class="table table-bordered table-hover table-condensed">
            <thead>
                <tr>
                    <th>Solicita</th>
                    <th>Fecha</th>
                    <th>Concepto</th>
                    <th>Tipo</th>
                    <th>Estado</th>
                </tr>
            </thead>
            <tbody>
                <g:each in="${reformas}" var="reforma">
                    <tr>
                        <td>${reforma.persona}</td>
                        <td>${reforma.fecha.format("dd-MM-yyyy")}</td>
                        <td>${reforma.concepto}</td>
                        <td>
                            ${reforma.tipo == 'R' ? 'Reforma' : reforma.tipo == 'A' ? 'Ajuste' : '??'}
                            ${reforma.tipoSolicitud == 'E' ? ' a asignaciones existentes' :
                                    reforma.tipoSolicitud == 'A' ? ' a nueva actividad' :
                                            reforma.tipoSolicitud == 'P' ? 'a nueva partida' :
                                                    reforma.tipoSolicitud == 'I' ? ' de incremento' : '??'}
                        </td>
                        <td>${reforma.estado.descripcion}</td>
                    </tr>
                </g:each>
            </tbody>
        </table>
    </body>
</html>