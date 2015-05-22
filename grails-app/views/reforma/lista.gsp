<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 21/04/15
  Time: 08:50 AM
--%>

<%@ page import="vesta.seguridad.Persona" contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <meta name="layout" content="main">
        <title>Lista de reformas</title>

        <link rel="stylesheet" href="${resource(dir: 'css/custom', file: 'avales.css')}" type="text/css"/>
    </head>

    <body>

        <!-- botones -->
        <div class="btn-toolbar toolbar">
            <div class="btn-group">
                <g:link action="reformas" class="btn btn-default btnCrear">
                    <i class="fa fa-file-o"></i> Solicitar reforma
                </g:link>
            </div>
        </div>

        <table class="table table-bordered table-hover table-condensed">
            <thead>
                <tr>
                    <th>Solicita</th>
                    <th>Fecha</th>
                    <th>Concepto</th>
                    <th>Tipo</th>
                    <th>Estado</th>
                    <th>Acciones</th>
                </tr>
            </thead>
            <tbody>
                <g:each in="${reformas}" var="reforma">
                    <tr>
                        <td>${reforma.persona.unidad} - ${reforma.persona}</td>
                        <td>${reforma.fecha.format("dd-MM-yyyy")}</td>
                        <td>${reforma.concepto}</td>
                        <td>
                            <elm:tipoReforma reforma="${reforma}"/>
                        </td>
                        <td class="${reforma.estado.codigo}">${reforma.estado.descripcion}</td>
                        <td style="text-align: center">
                            <div class="btn-group btn-group-sm" role="group">
                                <elm:linkPdfReforma reforma="${reforma}"/>
                            </div>
                        </td>
                    </tr>
                </g:each>
            </tbody>
        </table>
    </body>
</html>