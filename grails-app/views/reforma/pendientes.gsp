<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 21/04/15
  Time: 12:26 PM
--%>


<%@ page contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <meta name="layout" content="main">
        <title>Reformas pendientes</title>
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
                    <th>Acciones</th>
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
                        <td>
                            <div class="btn-group btn-group-sm" role="group">
                                <g:link controller="reportes" action="${reforma.tipoSolicitud == 'E' ? 'existente' :
                                        reforma.tipoSolicitud == 'A' ? 'actividad' :
                                                reforma.tipoSolicitud == 'P' ? 'partida' :
                                                        reforma.tipoSolicitud == 'I' ? 'incremento' : ''}" id="${reforma.id}" class="btn btn-info btnVer" title="Ver">
                                    <i class="fa fa-search"></i>
                                </g:link>
                                <g:link action="procesar" id="${reforma.id}" class="btn btn-default" title="Procesar">
                                    <i class="fa fa-pencil-square-o"></i>
                                </g:link>
                            </div>
                        </td>
                    </tr>
                </g:each>
            </tbody>
        </table>

        <script type="text/javascript">
            $(function () {
                $(".btnVer").click(function () {
                    var url = $(this).attr("href");
                    location.href = "${createLink(controller:'pdf',action:'pdfLink')}?url=" + url + "&filename=solicitud_reforma.pdf";
                });
            });
        </script>
    </body>
</html>