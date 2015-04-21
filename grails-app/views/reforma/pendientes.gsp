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

        <div role="tabpanel" style="margin-top: 15px;">

            <!-- Nav tabs -->
            <ul class="nav nav-pills" role="tablist">
                <li role="presentation" class="active">
                    <a href="#pendientes" aria-controls="home" role="tab" data-toggle="pill">
                        Solicitudes pendientes
                    </a>
                </li>
                <li role="presentation">
                    <a href="#historial" aria-controls="profile" role="tab" data-toggle="pill">
                        Historial solicitudes
                    </a>
                </li>
            </ul>

            <!-- Tab panes -->
            <div class="tab-content">
                <div role="tabpanel" class="tab-pane active" id="pendientes" style="margin-top: 20px;">
                    <g:if test="${reformas.size() > 0}">
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
                    </g:if>
                    <g:else>
                        <div class="alert alert-info" style="width: 450px;margin-top: 20px">No existen solicitudes pendientes</div>
                    </g:else>
                </div>

                <div role="tabpanel" class="tab-pane" id="historial" style="margin-top: 20px">
                    %{--<div class="well">--}%
                    %{--<form class="form-inline">--}%
                    %{--<div class="form-group">--}%
                    %{--<label for="anio">Año:</label>--}%
                    %{--<g:select from="${Anio.list([sort: 'anio'])}" id="anio" name="anio"--}%
                    %{--optionKey="id" optionValue="anio" value="${actual.id}" class="form-control input-sm"/>--}%
                    %{--</div>--}%

                    %{--<div class="form-group">--}%
                    %{--<label for="numero">Número:</label>--}%
                    %{--${actual.anio}-GP No.<input type="text" id="numero" class="form-control input-sm"/>--}%
                    %{--</div>--}%

                    %{--<div class="form-group">--}%
                    %{--<label for="descProceso">Requirente:</label>--}%
                    %{--<g:select name="requirente" from="${UnidadEjecutora.list([sort: 'nombre'])}" noSelection="['': '- Seleccione -']"--}%
                    %{--class="form-control input-sm" style="width: 200px;" optionKey="id"/>--}%
                    %{--</div>--}%

                    %{--<div class="form-group">--}%
                    %{--<label for="descProceso">Proceso:</label>--}%
                    %{--<input type="text" id="descProceso" class="form-control input-sm" style="width: 200px;"/>--}%
                    %{--</div>--}%
                    %{--<a href="#" class="btn btn-info btn-sm" id="buscar">--}%
                    %{--<i class="fa fa-search-plus"></i> Buscar--}%
                    %{--</a>--}%
                    %{--</form>--}%
                    %{--</div>--}%

                    <div id="detalle">

                    </div>
                </div>
            </div>

        </div>

        <script type="text/javascript">

            function buscar() {
                $.ajax({
                    type    : "POST",
                    url     : "${createLink(action:'historial_ajax')}",
                    success : function (msg) {
                        $("#detalle").html(msg);
                    }
                });
            }

            $(function () {
                buscar();
                $(".btnVer").click(function () {
                    var url = $(this).attr("href");
                    location.href = "${createLink(controller:'pdf',action:'pdfLink')}?url=" + url + "&filename=solicitud_reforma.pdf";
                });
            });
        </script>
    </body>
</html>