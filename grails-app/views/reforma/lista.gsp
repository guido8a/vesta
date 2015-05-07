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
                    %{--<th>Solicitud</th>--}%
                    <th>Ver</th>
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
                                            reforma.tipoSolicitud == 'C' ? ' de incremento a nueva actividad' :
                                                    reforma.tipoSolicitud == 'P' ? 'a nueva partida' :
                                                            reforma.tipoSolicitud == 'I' ? ' de incremento' : '??'}
                        </td>
                        <td>${reforma.estado.descripcion}</td>
                        <td style="text-align: center">
                            <div class="btn-group" role="group">
                                <g:if test="${reforma.estado.codigo == 'E02'}">
                                    <g:set var="accion" value="${reforma.tipoSolicitud == 'E' ? 'existenteReforma' :
                                            reforma.tipoSolicitud == 'A' ? 'actividadReforma' :
                                                    reforma.tipoSolicitud == 'C' ? 'incrementoActividadReforma' :
                                                            reforma.tipoSolicitud == 'P' ? 'partidaReforma' :
                                                                    reforma.tipoSolicitud == 'I' ? 'incrementoReforma' : ''}"/>
                                    <g:set var="fileName" value="${reforma.tipoSolicitud == 'E' ? 'reforma_existente' :
                                            reforma.tipoSolicitud == 'A' ? 'reforma_actividad' :
                                                    reforma.tipoSolicitud == 'C' ? 'reforma_incremento_actividad' :
                                                            reforma.tipoSolicitud == 'P' ? 'reforma_partida' :
                                                                    reforma.tipoSolicitud == 'I' ? 'reforma_incremento' : ''}.pdf"/>
                                    <a href="${g.createLink(controller: 'pdf', action: 'pdfLink')}?url=${g.createLink(controller: "reportesReforma", action: accion, id: reforma.id)}&filename=${fileName}"
                                       class="btn btn-sm btn-success btnVer" title="Reforma">
                                        <i class="fa fa-sign-out"></i> Reforma
                                    </a>
                                </g:if>
                                <g:else>
                                    <g:set var="accion" value="${reforma.tipoSolicitud == 'E' ? 'existente' :
                                            reforma.tipoSolicitud == 'A' ? 'actividad' :
                                                    reforma.tipoSolicitud == 'C' ? 'incrementoActividad' :
                                                            reforma.tipoSolicitud == 'P' ? 'partida' :
                                                                    reforma.tipoSolicitud == 'I' ? 'incremento' : ''}"/>
                                    <g:set var="fileName" value="${reforma.tipoSolicitud == 'E' ? 'solicitud_existente' :
                                            reforma.tipoSolicitud == 'A' ? 'solicitud_actividad' :
                                                    reforma.tipoSolicitud == 'C' ? 'solicitud_incremento_actividad' :
                                                            reforma.tipoSolicitud == 'P' ? 'solicitud_partida' :
                                                                    reforma.tipoSolicitud == 'I' ? 'solicitud_incremento' : ''}.pdf"/>
                                    <a href="${g.createLink(controller: 'pdf', action: 'pdfLink')}?url=${g.createLink(controller: "reportesReforma", action: accion, id: reforma.id)}&filename=${fileName}"
                                       class="btn btn-sm btn-info btnVer" title="Solicitud">
                                        <i class="fa fa-sign-in"></i> Solicitud
                                    </a>
                                </g:else>
                            </div>
                        </td>
                    </tr>
                </g:each>
            </tbody>
        </table>

        <script type="text/javascript">

        </script>
    </body>
</html>