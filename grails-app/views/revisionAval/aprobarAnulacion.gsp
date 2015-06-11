<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 20/03/15
  Time: 12:34 PM
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <meta name="layout" content="main"/>
        <title>Aprobar anulación de aval</title>
    </head>

    <body>

        <elm:message tipo="${flash.tipo}" clase="${flash.clase}">${flash.message}</elm:message>
        <div class="btn-toolbar toolbar">
            <div class="btn-group">
                <g:link controller="revisionAval" action="pendientes" class="btn btn-default">
                    <i class="fa fa-chevron-left"></i> Regresar
                </g:link>
            </div>
        </div>

        <g:if test="${solicitud.estado.codigo != 'E01' && solicitud.estado.codigo != 'D03'}">
            <div class="alert alert-danger">
                <i class="fa fa-exclamation-triangle fa-2x"></i> Ya ha solicitado la firma para esta solicitud, no puede hacerlo nuevamente
            </div>
        </g:if>
        <g:else>
            <g:if test="${solicitud.estado.codigo == "D03"}">
                <div class="alert alert-warning">
                    <g:if test="${solicitud.aval.firmaAnulacion1.observaciones && solicitud.aval.firmaAnulacion1.observaciones != '' && solicitud.aval.firmaAnulacion1.observaciones != 'S'}">
                        <h4>Devuelto por ${solicitud.aval.firmaAnulacion1.usuario}</h4>
                        ${solicitud.aval.firmaAnulacion1.observaciones}
                    </g:if>
                    <g:if test="${solicitud.aval.firmaAnulacion2.observaciones && solicitud.aval.firmaAnulacion2.observaciones != '' && solicitud.aval.firmaAnulacion2.observaciones != 'S'}">
                        <h4>Devuelto por ${solicitud.aval.firmaAnulacion2.usuario}</h4>
                        ${solicitud.aval.firmaAnulacion2.observaciones}
                    </g:if>
                </div>
            </g:if>

            <elm:container tipo="horizontal" titulo="Solicitud de anulación a aprobar">
                <table class="table table-condensed table-bordered">
                    <thead>
                        <tr>
                            <th>Proceso</th>
                            <th>Tipo</th>
                            <th>Concepto</th>
                            <th>Monto</th>
                            <th>Estado</th>
                            <th>Doc. Respaldo</th>
                            %{--<th>Solicitud</th>--}%
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>${solicitud.proceso.nombre}</td>
                            <td class="E03">Anulación</td>
                            <td>${solicitud.concepto}</td>
                            <td style="text-align: right">${solicitud.monto}</td>
                            <td style="">${solicitud.estado?.descripcion}</td>
                            <td style="text-align: center">
                                <g:if test="${solicitud.path}">
                                    <a href="#" class="btn btn-default btn-sm descRespaldo" iden="${solicitud.id}">
                                        <i class="fa fa-search"></i>
                                    </a>
                                </g:if>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </elm:container>

        %{--<elm:container tipo="horizontal" titulo="Anular">--}%
        %{--<h3>Descargue el formulario, firmelo y subalo</h3>--}%
        %{--<g:form action="guardarAnulacion" class="frmAprobar form-horizontal" enctype="multipart/form-data">--}%
        %{--<input type="hidden" name="id" value="${solicitud.id}">--}%

        %{--<div class="form-group">--}%
        %{--<label for="archivo" class="col-sm-2 control-label">--}%
        %{--Documento de respaldo--}%
        %{--</label>--}%

        %{--<div class="col-sm-3">--}%
        %{--<input type="file" id="archivo" name="archivo" class="form-control">--}%
        %{--</div>--}%
        %{--</div>--}%

        %{--Ingrese el número del aval y descargue el formulario con un clic  </br>--}%
        %{--Después de llenar y firmar el documento del Aval súbalo al sistema. </br> </br>--}%
        %{--<div class="fila">--}%
        %{--<div class="labelSvt">--}%
        %{--<a href="#" class="btn btn-success" id="aprobar">--}%
        %{--Anular aval--}%
        %{--</a>--}%
        %{--</div>--}%
        %{--</div>--}%

        %{--</g:form>--}%
        %{--</elm:container>--}%

            <elm:container tipo="horizontal" titulo="Autorizaciones electrónicas">
                <form id="frmFirmas">
                    <div class="row">
                        <div class="col-md-3 grupo">
                            <g:if test="${solicitud.estado.codigo == "D03"}">
                                ${solicitud.aval.firma1.usuario}
                            </g:if>
                            <g:else>
                                <g:select from="${personas}" optionKey="id" optionValue="${{
                                    it.nombre + ' ' + it.apellido
                                }}" noSelection="['': '- Seleccione -']" name="firma2" class="form-control required input-sm"/>
                            </g:else>
                        </div>

                        <div class="col-md-3 grupo">
                            <g:if test="${solicitud.estado.codigo == "D03"}">
                                ${solicitud.aval.firma2.usuario}
                            </g:if>
                            <g:else>
                                <g:select from="${personasGerente}" optionKey="id" optionValue="${{
                                    it.nombre + ' ' + it.apellido
                                }}" noSelection="['': '- Seleccione -']" name="firma3" class="form-control required input-sm"/>
                            </g:else>
                        </div>
                    </div>
                </form>
            </elm:container>

            <div class="row">
                <div class="col-md-5">
                    <div class="btn-group" role="group" aria-label="...">
                        <a href="#" class="btn btn-default" id="btnPreview" title="Previsualizar">
                            <i class="fa fa-search"></i> Previsualizar
                        </a>
                        <a href="#" class="btn btn-success" id="btnSolicitar" title="Aprobar y solicitar firmas">
                            <i class="fa fa-pencil"></i> Solicitar firmas
                        </a>
                        <a href="#" class="btn btn-danger" id="btnNegar" title="Negar definitivamente la anulación del aval">
                            <i class="fa fa-thumbs-down"></i> Negar
                        </a>
                    </div>
                </div>
                %{--<div class="btn-toolbar toolbar" style="margin-top: 15px;">--}%
                %{--<div class="btn-group">--}%
                %{--<a href="#" class="btn btn-default" id="solicitarFirma">--}%
                %{--Solicitar firma--}%
                %{--</a>--}%
                %{--</div>--}%
                %{--</div>--}%
            </div>

        %{--<script type="text/javascript">--}%
        %{--$(function () {--}%
        %{--$(".descRespaldo").click(function () {--}%
        %{--location.href = "${createLink(controller:'avales',action:'descargaSolicitud')}/" + $(this).attr("iden");--}%
        %{--});--}%

        %{--$("#aprobar").click(function () {--}%
        %{--var file = $("#archivo").val()--}%
        %{--var msg = ""--}%
        %{--if (file.length < 1) {--}%
        %{--msg += "<br>Por favor seleccione un archivo."--}%
        %{--} else {--}%
        %{--var ext = file.split('.').pop();--}%
        %{--if (ext != "pdf") {--}%
        %{--msg += "<br>Por favor seleccione un archivo de formato pdf. El formato " + ext + " no es aceptado por el sistema"--}%
        %{--}--}%
        %{--}--}%
        %{--if (msg == "") {--}%
        %{--$(".frmAprobar").submit()--}%
        %{--} else {--}%
        %{--bootbox.alert(msg);--}%
        %{--}--}%
        %{--});--}%

        %{--});--}%
        %{--</script>--}%

            <script type="text/javascript">
                $(function () {

                    $("#frmFirmas").validate({
                        errorClass     : "help-block",
                        errorPlacement : function (error, element) {
                            if (element.parent().hasClass("input-group")) {
                                error.insertAfter(element.parent());
                            } else {
                                error.insertAfter(element);
                            }
                            element.parents(".grupo").addClass('has-error');
                        },
                        success        : function (label) {
                            label.parents(".grupo").removeClass('has-error');
                            label.remove();
                        }

                    });

                    $("#btnPreview").click(function () {
                        var url = "${createLink(controller: 'reporteSolicitud', action: 'imprimirSolicitudAnulacionAval')}/?id=${solicitud.id}";
                        location.href = "${createLink(controller:'pdf',action:'pdfLink')}?url=" + url + "&filename=solicitud_anulacion_aval.pdf";
                        return false;
                    });

                    $("#btnSolicitar").click(function () {
                        if ($("#frmFirmas").valid()) {

                            bootbox.confirm(
                                    "<div class='alert alert-danger'>¿Está seguro? Una vez solicitada la firma no podrá modificar el documento</div>",
                                    function (res) {
                                        if (res) {
                                            openLoader("Solicitando");
                                            var aval = $("#numero").val();
                                            var obs = $("#richText").val();
                                            $.ajax({
                                                type    : "POST",
                                                url     : "${createLink(controller: 'revisionAval', action:'guarAnulacionDoc')}",
                                                data    : {
                                                    id     : "${solicitud.id}",
//                                                    auth   : $auth.val(),
                                                    aval   : aval,
                                                    obs    : obs,
                                                    firma2 : $("#firma2").val(),
                                                    firma3 : $("#firma3").val(),
                                                    enviar : "true"
                                                },
                                                success : function (msg) {
                                                    var parts = msg.split("*");
                                                    log(parts[1], parts[0]); // log(msg, type, title, hide)
                                                    if (parts[0] == "SUCCESS") {
                                                        setTimeout(function () {
                                                            location.href = "${createLink(action: 'pendientes')}";
                                                        }, 1000);
                                                    } else {
                                                        closeLoader();
                                                    }
                                                }
                                            });
                                        }
                                    });
                        }
                        return false;
                    });

                    $("#btnNegar").click(function () {
                        bootbox.confirm(
                                "<div class='alert alert-danger'>¿Está seguro de querer negar esta anulación de aval?</div>",
                                function (res) {
                                    if (res) {
                                        openLoader("Negando");
                                        var aval = $("#numero").val();
                                        var obs = $("#richText").val();
                                        $.ajax({
                                            type    : "POST",
                                            url     : "${createLink(controller: 'revisionAval', action:'negarAval')}",
                                            data    : {
                                                id   : "${solicitud.id}",
                                                aval : aval,
                                                obs  : obs
                                            },
                                            success : function (msg) {
                                                var parts = msg.split("*");
                                                log(parts[1], parts[0]); // log(msg, type, title, hide)
                                                if (parts[0] == "SUCCESS") {
                                                    setTimeout(function () {
                                                        location.href = "${createLink(action: 'pendientes')}";
                                                    }, 1000);
                                                } else {
                                                    closeLoader();
                                                }
                                            }
                                        });
                                    }
                                });
                        return false;
                    });

                    $("#guardarDatosDoc").click(function () {
                        var aval = $("#numero").val();
                        var obs = $("#richText").val();
                        $.ajax({
                            type    : "POST",
                            url     : "${createLink(controller: 'revisionAval',action:'guarDatosDoc')}",
                            data    : {
                                id     : "${solicitud.id}",
                                aval   : aval,
                                obs    : obs,
                                firma2 : $("#firma2").val(),
                                firma3 : $("#firma3").val()
                            },
                            success : function (msg) {
                                var parts = msg.split("*");
                                log(parts[1], parts[0] == "SUCCESS" ? "success" : "error"); // log(msg, type, title, hide)
                            }
                        });
                        return false;
                    });
                    $(".imprimirSolicitud").click(function () {
                        var url = "${g.createLink(controller: 'reporteSolicitud',action: 'imprimirSolicitudAval')}/?id=" + $(this).attr("iden");
                        location.href = "${createLink(controller:'pdf',action:'pdfLink')}?url=" + url + "&filename=solicitud.pdf";
                        return false;
                    });
                    $(".descRespaldo").click(function () {
                        var id = $(this).attr("iden");
                        $.ajax({
                            type    : "POST",
                            url     : "${createLink(controller: 'avales', action: 'validarSolicitud_ajax')}",
                            data    : {
                                id : id
                            },
                            success : function (msg) {
                                var parts = msg.split("*");
                                if (parts[0] == "SUCCESS") {
                                    location.href = "${createLink(controller:'avales',action:'descargaSolicitud')}/" + $(this).attr("iden");
                                } else {
                                    log(parts[1], parts[0] == "SUCCESS" ? "success" : "error"); // log(msg, type, title, hide)
                                }
                            }
                        });
                        return false;
                    });
                });
            </script>
        </g:else>

    </body>
</html>