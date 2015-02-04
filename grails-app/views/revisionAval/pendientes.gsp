<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 28/01/15
  Time: 01:06 PM
--%>

<%@ page import="vesta.parametros.poaPac.Anio" contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <meta name="layout" content="main"/>
        <title>Solicitudes pendientes</title>

        <link rel="stylesheet" href="${resource(dir: 'css/custom', file: 'avales.css')}" type="text/css"/>
    </head>

    <body>

        <!-- botones -->
        <div class="btn-toolbar toolbar">
            <div class="btn-group">
                <g:link controller="avales" action="listaProcesos" class="btn btn-default btnCrear">
                    <i class="fa fa-list"></i> Procesos
                </g:link>
            </div>
        </div>

        <div role="tabpanel">

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
                <div role="tabpanel" class="tab-pane active" id="pendientes">
                    <g:if test="${solicitudes.size() > 0}">
                        <table class="table table-condensed table-striped table-hover table-bordered">
                            <thead>
                                <tr>
                                    <th style="width: 100px;"># Sol.</th>
                                    <th>Unidad</th>
                                    <th>Proceso</th>
                                    <th>Tipo</th>
                                    <th>Concepto</th>
                                    <th>Monto</th>
                                    <th>Estado</th>
                                    <th>Doc. Respaldo</th>
                                    <th style="width: 60px;">Solicitud</th>
                                    <th style="width: 60px;">Acciones</th>
                                </tr>
                            </thead>
                            <tbody>
                                <g:each in="${solicitudes}" var="p">
                                    <tr>
                                        <td>
                                            ${p.unidad?.codigo}-${p.numero}
                                        </td>
                                        <td>
                                            ${p.unidad}
                                        </td>
                                        <td>
                                            ${p.proceso.nombre}
                                        </td>
                                        <td class="${(p.tipo == 'A') ? 'E03' : 'E02'}">
                                            ${(p.tipo == "A") ? 'Anulación' : 'Aprobación'}
                                        </td>
                                        <td>
                                            ${p.concepto}
                                        </td>
                                        <td class="text-right">
                                            <g:formatNumber number="${p.monto}" type="currency"/>
                                        </td>
                                        <td class="text-center ${p.estado?.codigo}">
                                            ${p.estado?.descripcion}
                                        </td>
                                        <td class="text-center">
                                            <g:if test="${p.path}">
                                                <a href="#" class="btn btn-default btn-xs descRespaldo" iden="${p.id}" title="Ver">
                                                    <i class="fa fa-search"></i>
                                                </a>
                                            </g:if>
                                        </td>
                                        <td class="text-center">
                                            <g:if test="${p.tipo != 'A'}">
                                                <a href="#" class="btn btn-default btn-xs imprimirSolicitud" iden="${p.id}" title="Ver">
                                                    <i class="fa fa-search"></i>
                                                </a>
                                            </g:if>
                                        </td>
                                        <td class="text-center">
                                            <div class="btn-group btn-group-xs" role="group">
                                                <g:if test="${p.tipo != 'A'}">
                                                    <a href="${g.createLink(action: 'aprobarAval', id: p.id)}" class="aprobar btn btn-success" title="Aprobar">
                                                        <i class="fa fa-check"></i>
                                                    </a>
                                                </g:if>
                                                <g:else>
                                                    <a href="${g.createLink(action: 'aprobarAnulacion', id: p.id)}" class="aprobarAnulacion btn btn-success" title="Aprobar">
                                                        <i class="fa fa-check"></i>
                                                    </a>
                                                </g:else>
                                                <a href="#" class="negar btn btn-warning " iden="${p.id}" title="Negar">
                                                    <i class="fa fa-times-circle"></i>
                                                </a>
                                            </div>
                                        </td>
                                    </tr>
                                </g:each>

                            </tbody>
                        </table>
                    </g:if>
                </div>

                <div role="tabpanel" class="tab-pane" id="historial">
                    <div class="well">
                        <form class="form-inline">
                            <div class="form-group">
                                <label for="anio">Año:</label>
                                <g:select from="${Anio.list([sort: 'anio'])}" id="anio" name="anio"
                                          optionKey="id" optionValue="anio" value="${actual.id}" class="form-control input-sm"/>
                            </div>

                            <div class="form-group">
                                <label for="numero">Número:</label>
                                ${actual.anio}-GP No.<input type="text" id="numero" class="form-control input-sm"/>
                            </div>

                            <div class="form-group">
                                <label for="descProceso">Proceso:</label>
                                <input type="text" id="descProceso" class="form-control input-sm" style="width: 300px;"/>
                            </div>
                            <a href="#" class="btn btn-info btn-sm" id="buscar">
                                <i class="fa fa-search-plus"></i> Buscar
                            </a>
                        </form>
                    </div>

                    <div id="detalle">

                    </div>
                </div>
            </div>

        </div>

        <script type="text/javascript">

            function cargarHistorial(anio, numero, proceso) {
                $.ajax({
                    type    : "POST",
                    url     : "${createLink(controller: 'revisionAval', action:'historial')}",
                    data    : {
                        anio    : anio,
                        numero  : numero,
                        proceso : proceso
                    },
                    success : function (msg) {
                        $("#detalle").html(msg)
                    }
                });
            }

            $(function () {
                $(".descRespaldo").click(function () {
                    location.href = "${createLink(controller:'avales',action:'descargaSolicitud')}/" + $(this).attr("iden");

                });
                $(".imprimirSolicitud").click(function () {
                    var url = "${g.createLink(controller: 'reporteSolicitud',action: 'imprimirSolicitudAval')}/" + $(this).attr("iden");
                    location.href = "${createLink(controller:'pdf',action:'pdfLink')}?url=" + url + "&filename=Solicitud.pdf"
                });

                $("#buscar").click(function () {
                    cargarHistorial($("#anio").val(), $("#numero").val(), $("#descProceso").val())
                });
                $(".negar").click(function () {
                    var id = $(this).attr("iden");
                    var msg = $("<div>");
                    msg.html("<i class='fa fa-times-circle fa-3x pull-left text-warning text-shadow'></i><p>" +
                             "¿Está seguro que desea negar esta solicitud de aval?</p>");
                    var $txa = $("<textarea class='form-control input-sm' cols='10' rows='5' />");
                    var $p = $("<p>");
                    $p.append("<strong>Observaciones</strong>").append($txa);
                    msg.append($p);
                    bootbox.dialog({
                        title   : "Alerta",
                        message : msg,
                        buttons : {
                            cancelar : {
                                label     : "Cancelar",
                                className : "btn-primary",
                                callback  : function () {
                                }
                            },
                            eliminar : {
                                label     : "<i class='fa fa-times-circle'></i> Negar",
                                className : "btn-warning",
                                callback  : function () {
                                    openLoader("Negando solicitud");
                                    $.ajax({
                                        type    : "POST",
                                        url     : "${createLink( controller: 'revisionAval', action:'negarAval')}",
                                        data    : {
                                            id  : id,
                                            obs : $txa.val()
                                        },
                                        success : function (msg) {
                                            if (msg != "no")
                                                location.reload(true);
                                            else
                                                location.href = "${createLink(controller:'certificacion',action:'listaSolicitudes')}/?msn=Usted no tiene los permisos para negar esta solicitud"

                                        }
                                    });
                                    %{--$.ajax({--}%
                                    %{--type    : "POST",--}%
                                    %{--url     : '${createLink(action:'delete_ajax')}',--}%
                                    %{--data    : {--}%
                                    %{--id : itemId--}%
                                    %{--},--}%
                                    %{--success : function (msg) {--}%
                                    %{--var parts = msg.split("*");--}%
                                    %{--log(parts[1], parts[0] == "SUCCESS" ? "success" : "error"); // log(msg, type, title, hide)--}%
                                    %{--if (parts[0] == "SUCCESS") {--}%
                                    %{--setTimeout(function () {--}%
                                    %{--location.reload(true);--}%
                                    %{--}, 1000);--}%
                                    %{--} else {--}%
                                    %{--closeLoader();--}%
                                    %{--}--}%
                                    %{--}--}%
                                    %{--});--}%
                                }
                            }
                        }
                    });
                });
            });

        </script>

    </body>
</html>