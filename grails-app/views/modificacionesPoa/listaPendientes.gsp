<%@ page import="vesta.parametros.TipoElemento" contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main"/>
        <title>Solicitudes pendientes</title>
    </head>

    <body>

        <elm:message tipo="${flash.tipo}" clase="${flash.clase}">${flash.message}</elm:message>


        <div role="tabpanel">
            <!-- Nav tabs -->
            <ul class="nav nav-pills" role="tablist">
                <li role="presentation" class="active">
                    <a href="#solicitudes" aria-controls="home" role="tab" data-toggle="pill">
                        Solicitudes pendientes
                    </a>
                </li>
                <li role="presentation">
                    <a href="#historial" aria-controls="profile" role="tab" data-toggle="pill">
                        Historial
                    </a>
                </li>
            </ul>

            <!-- Tab panes -->
            <div class="tab-content">
                <div role="tabpanel" class="tab-pane active" id="solicitudes">
                    <g:if test="${solicitudes.size() > 0}">
                        <table class="table table-condensed table-bordered table-striped table-hover">
                            <thead>
                                <tr>
                                    <th># Sol.</th>
                                    <th>Fecha</th>
                                    <th>Unidad</th>
                                    <th>Proyecto</th>
                                    <th>Concepto</th>
                                    <th>Estado</th>
                                    <th>Solicitud</th>
                                    <th>Matriz</th>
                                    <th>Acción</th>
                                </tr>
                            </thead>
                            <tbody>
                                <g:each in="${solicitudes}" var="p">
                                    <tr data-id="${p?.id}">
                                        <td>${p.id}</td>
                                        <td>${p.fecha.format("dd-MM-yyyy")}</td>
                                        <td>${p.usuario.unidad}</td>
                                        <td title="${p.origen.marcoLogico.proyecto.toStringCompleto()}">${p.origen.marcoLogico.proyecto}</td>
                                        <td>${p.concepto}</td>
                                        <td style="text-align: center" class="E0${p.estado}">
                                            <g:if test="${p.estado == 0}">
                                                Solicitado
                                            </g:if>
                                            <g:if test="${p.estado == 1}">
                                                Aprobado
                                            </g:if>
                                            <g:if test="${p.estado == 2}">
                                                Negado
                                            </g:if>
                                        </td>
                                        <td style="text-align: center">
                                            <a href="${g.createLink(controller: 'pdf', action: 'pdfLink')}?url=${g.createLink(action: "solicitudReformaPdf", controller: "reporteSolicitud", id: p.id)}"
                                               class="btn btn-info btn-sm">
                                                <i class="fa fa-search"></i> Ver
                                            </a>
                                        </td>
                                        <td style="text-align: center">
                                            <a href="${g.createLink(controller: 'pdf', action: 'pdfLink')}?url=${g.createLink(action: "solicitudReformaPoa", controller: "reporteReformaPoa", id: p.id)}"
                                               class="btn btn-info btn-sm">
                                                <i class="fa fa-search"></i> Ver
                                            </a>
                                        </td>
                                        <td style="text-align: center">
                                            <a href="${g.createLink(controller: 'modificacionesPoa', action: 'verSolicitud', id: p.id)}"
                                               class="btn btn-success btn-sm" iden="${p.id}" title="Aprobar o Negar">
                                                <i class="fa fa-gear"></i> Procesar
                                            </a>
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

                <div role="tabpanel" class="tab-pane" id="historial">
                    <table class="table table-condensed table-bordered table-striped table-hover">
                        <thead>
                            <tr>
                                <th># Sol.</th>
                                <th>Unidad</th>
                                <th>Proyecto</th>
                                <th>Concepto</th>
                                <th>Estado</th>
                                <th>Solicitud</th>
                                <th>Matriz</th>
                                <th>Reforma</th>
                                <th>Ver</th>
                            </tr>
                        </thead>
                        <tbody>
                            <g:each in="${historial}" var="p">
                                <tr>
                                    <td>${p.id}</td>
                                    <td>${p.usuario.unidad}</td>
                                    <td title="${p.origen.marcoLogico.proyecto.toStringCompleto()}">${p.origen.marcoLogico.proyecto}</td>
                                    <td >${p.concepto}</td>
                                    %{--<td style="text-align: center" class="${(p.estado == 0) ? 'solicitado' : (p.estado == 1 || p.estado == 3) ? 'aprobado' : 'negado'}">--}%
                                    <td style="text-align: center" class="${p.estado == 0 ? 'azul' : (p.estado == 1 || p.estado == 3) ? 'verde' :  p.estado ==5 ? 'amarillo' :'rojo'}" >
                                        <strong>
                                        <g:if test="${p.estado == 0}" >
                                            Solicitado
                                        </g:if>
                                        <g:if test="${p.estado == 1 || p.estado == 3}">
                                            Aprobado
                                        </g:if>
                                        <g:if test="${p.estado == 2}">
                                           Negado
                                        </g:if>
                                        <g:if test="${p.estado == 5}">
                                            Aprobado sin firmas
                                        </g:if>
                                        </strong>

                                    </td>
                                    <td style="text-align: center">
                                        <a href="${g.createLink(controller: 'pdf', action: 'pdfLink')}?url=${g.createLink(action: "solicitudReformaPdf", controller: "reporteSolicitud", id: p.id)}"
                                           class="btn btn-info btn-sm">
                                            <i class="fa fa-search"></i> Ver
                                        </a>
                                    </td>
                                    <td style="text-align: center">
                                        <a href="${g.createLink(controller: 'pdf', action: 'pdfLink')}?url=${g.createLink(action: "solicitudReformaPoa", controller: "reporteReformaPoa", id: p.id)}"
                                           class="btn btn-info btn-sm">
                                            <i class="fa fa-search"></i> Ver
                                        </a>
                                    </td>
                                    <td style="text-align: center">
                                        <g:if test="${p.estado == 3 || p.estado == 5}">
                                            <a href="${g.createLink(controller: 'pdf', action: 'pdfLink')}?url=${g.createLink(action: "reformaPoa", controller: "reporteReformaPoa", id: p.id)}"
                                               class="btn btn-info btn-sm">
                                                <i class="fa fa-search"></i> Ver
                                            </a>
                                        </g:if>
                                    </td>
                                    <td style="text-align: center">
                                        <a href="${g.createLink(controller: 'modificacionesPoa', action: 'verSolicitud', id: p.id)}"
                                           class="btn btn-success btn-sm" iden="${p.id}">
                                            <i class="fa fa-search"></i> Ver
                                        </a>

                                    </td>

                                </tr>
                            </g:each>

                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <div id="negar">
            <input type="hidden" id="avalId">
            Esta seguro que desea negar esta solicitud de certificación?
        </div>

        <script>
            function cargarHistorial(anio, numero, proceso) {
            }

            $("#tabs").tabs()
            $(".aprobar").button({icons : {primary : "ui-icon-check"}, text : false});

            $(".aprobarAnulacion").button({icons : {primary : "ui-icon-check"}, text : false});
            $(".negar").button({icons : {primary : "ui-icon-close"}, text : false}).click(function () {
                $("#avalId").val($(this).attr("iden"))
                $("#negar").dialog("open")
            });
            $("#negar").dialog({
                autoOpen  : false,
                resizable : false,
                title     : 'Negar solicitud',
                modal     : true,
                draggable : true,
                width     : 400,
                height    : 150,
                position  : 'center',
                open      : function (event, ui) {
                    $(".ui-dialog-titlebar-close").hide();
                },
                buttons   : {
                    "Cancelar" : function () {
                        $("#negar").dialog("close")
                    }, "Negar" : function () {
                        $.ajax({
                            type    : "POST", url : "${createLink(action:'negar', controller: 'modificacionesPoa')}",
                            data    : "id=" + $("#avalId").val(),
                            success : function (msg) {
                                if (msg != "no")
                                    location.reload(true)
                                else
                                    location.href = "${createLink(controller:'certificacion',action:'listaSolicitudes')}/?msn=Usted no tiene los permisos para negar esta solicitud"

                            }
                        });
                    }
                }
            });
        </script>
    </body>
</html>