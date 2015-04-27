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
                                            reforma.tipoSolicitud == 'P' ? 'a nueva partida' :
                                                    reforma.tipoSolicitud == 'I' ? ' de incremento' : '??'}
                        </td>
                        <td>${reforma.estado.descripcion}</td>
                        <td style="text-align: center">
                             <g:if test="${reforma.estado.codigo == 'E02'}">
                            <div class="btn-group" role="group">
                                    <a href="${g.createLink(controller: 'pdf', action: 'pdfLink')}?url=${g.createLink(controller:"reportesReforma",  action: reforma.tipoSolicitud == 'E' ? 'existenteReforma' :
                                            reforma.tipoSolicitud == 'A' ? 'actividadReforma' :
                                                    reforma.tipoSolicitud == 'P' ? 'partidaReforma' :
                                                            reforma.tipoSolicitud == 'I' ? 'incrementoReforma' : '', id: reforma.id )}" class="btn btn-sm btn-success btnVer" title="Reforma">
                                        <i class="fa fa-sign-out"></i> Reforma
                                    </a>
                            </div>
                         </g:if>
                            <g:else>
                                <div class="btn-group" role="group">
                                        <a href="${g.createLink(controller: 'pdf', action: 'pdfLink')}?url=${g.createLink(controller:"reportesReforma",  action: reforma.tipoSolicitud == 'E' ? 'existente' :
                                                reforma.tipoSolicitud == 'A' ? 'actividad' :
                                                        reforma.tipoSolicitud == 'P' ? 'partida' :
                                                                reforma.tipoSolicitud == 'I' ? 'incremento' : '', id: reforma.id )}" class="btn btn-sm btn-info btnVer" title="Solicitud">
                                            <i class="fa fa-sign-in"></i> Solicitud
                                        </a>
                                </div>
                            </g:else>
                        </td>
                    </tr>
                </g:each>
            </tbody>
        </table>

        <script type="text/javascript">

        </script>
    </body>
</html>