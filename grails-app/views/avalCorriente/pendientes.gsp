<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 25/06/15
  Time: 12:44 PM
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <meta name="layout" content="main"/>
        <title>Avales gasto permanente pendientes</title>

        <link rel="stylesheet" href="${resource(dir: 'css/custom', file: 'avales.css')}" type="text/css"/>
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
                    <g:if test="${procesos.size() > 0}">
                        <table class="table table-bordered table-hover table-condensed">
                            <thead>
                                <tr>
                                    <th>Solicita</th>
                                    <th>Nombre del proceso</th>
                                    <th>Concepto</th>
                                    <th>Estado</th>
                                    <th style="width: 85px">Fecha</th>
                                    <th style="width: 85px">Inicio</th>
                                    <th style="width: 85px">Fin</th>
                                    <th>Monto</th>
                                    <th>Acciones</th>
                                </tr>
                            </thead>
                            <tbody>
                                <g:each in="${procesos}" var="proc">
                                    <tr>
                                        <td>${proc.usuario.unidad} - ${proc.usuario}</td>
                                        <td>${proc.nombreProceso}</td>
                                        <td>${proc.concepto}</td>
                                        <td class="${proc.estado.codigo}">${proc.estado.descripcion}</td>
                                        <td>${proc.fechaSolicitud.format("dd-MM-yyyy")}</td>
                                        <td>${proc.fechaInicioProceso.format("dd-MM-yyyy")}</td>
                                        <td>${proc.fechaFinProceso.format("dd-MM-yyyy")}</td>
                                        <td class="text-right"><g:formatNumber number="${proc.monto}" type="currency" currencySymbol=""/></td>
                                        <td>
                                            <div class="btn-group btn-group-xs" role="group">
                                                <a href="#" class="btn btn-default btnPrint" data-id="${proc.id}" title="Imprimir">
                                                    <i class="fa fa-print"></i>
                                                </a>
                                                <g:if test="${proc.usuario.id == session.usuario.id && (proc.estado.codigo == 'P01' || proc.estado.codigo == 'D01')}">
                                                    <g:link class="btn btn-info" action="nuevaSolicitud" id="${proc.id}" title="Editar">
                                                        <i class="fa fa-pencil"></i>
                                                    </g:link>
                                                </g:if>
                                                <g:elseif test="${proc.director.id == session.usuario.id && (proc.estado.codigo == 'R01' || proc.estado.codigo == 'D02')}">
                                                    <g:link class="btn btn-info" action="revisarSolicitud" id="${proc.id}" title="Revisar">
                                                        <i class="fa fa-pencil"></i>
                                                    </g:link>
                                                </g:elseif>
                                                <g:elseif test="${session.perfil.codigo == 'ASAF' && (proc.estado.codigo == 'E01' || proc.estado.codigo == 'D03')}">
                                                    <g:link class="btn btn-success" action="solicitarFirmas" id="${proc.id}" title="Revisar">
                                                        <i class="fa fa-check"></i>
                                                    </g:link>
                                                </g:elseif>
                                                <g:elseif test="${proc.estado.codigo == 'EF1'}">
                                                %{-- TODO: validar quien puede aqui y en q estado debe estar el proceso --}%
                                                    <g:link class="btn btn-success btnModificar" action="nuevaSolicitud" id="${proc.id}" title="Modificar aval">
                                                        <i class="fa fa-pencil"></i>
                                                    </g:link>
                                                </g:elseif>
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

                $(".btnModificar").click(function () {
                    var url = $(this).attr("href");

                    var msg = $("<div>Ingrese su clave de autorización</div>");
                    var $txt = $("<input type='password' class='form-control input-sm'/>");

                    var $group = $('<div class="input-group">');
                    var $span = $('<span class="input-group-addon"><i class="fa fa-lock"></i> </span>');
                    $group.append($txt).append($span);

                    msg.append($group);

                    var bAuth = bootbox.dialog({
                        title   : "Autorización electrónica",
                        message : msg,
                        class   : "modal-sm",
                        buttons : {
                            cancelar : {
                                label     : "Cancelar",
                                className : "btn-primary",
                                callback  : function () {
                                }
                            },
                            eliminar : {
                                label     : "<i class='fa fa-pencil'></i> Modificar",
                                className : "btn-success",
                                callback  : function () {
                                    $.ajax({
                                        type    : "POST",
                                        url     : '${createLink( action:'validarModificarAval')}',
                                        data    : {
                                            pass : $txt.val()
                                        },
                                        success : function (msg) {
                                            if (msg == "ERROR") {
                                                closeLoader();
                                                bootbox.alert({
                                                            message : "Clave incorrecta",
                                                            title   : "Error",
                                                            class   : "modal-error"
                                                        }
                                                );
                                            } else {
                                                location.href = url + "?a=" + msg;
                                            }
                                        },
                                        error   : function () {
                                            log("Ha ocurrido un error interno", "error");

                                            closeLoader();
                                        }
                                    });
                                }
                            }
                        }
                    });
                    setTimeout(function () {
                        bAuth.find(".form-control").first().focus();
                    }, 500);
                    return false;
                });

                $(".btnPrint").click(function () {
                    var url = "${g.createLink(controller: 'reporteSolicitud',action: 'solicitudAvalCorriente')}/" + $(this).data("id");
                    location.href = "${createLink(controller:'pdf',action:'pdfLink')}?url=" + url + "&filename=solicitud_aval_corriente.pdf";
                    return false;
                });
            });
        </script>
    </body>
</html>