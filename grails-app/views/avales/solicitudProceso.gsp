<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 19/03/15
  Time: 03:33 PM
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main"/>
        <title>Nueva solicitud de aval: 3-Solicitud</title>

        <link href="${resource(dir: 'css/custom', file: 'wizard.css')}" rel="stylesheet"/>

    </head>

    <body>
        <elm:message tipo="${flash.tipo}" clase="${flash.clase}">${flash.message}</elm:message>
        <elm:message tipo="error" clase="error">${params.error}</elm:message>


        <input type="hidden" name="id" value="${proceso?.id}">

        <div class="btn-toolbar" role="toolbar">
            <div class="btn-group" role="group">
                <g:link controller="avales" action="listaProcesos" class="btn btn-default">
                    <i class="fa fa-bars"></i> Lista de Procesos
                </g:link>
                <g:if test="${proceso}">
                    <g:link controller="avales" action="avalesProceso" id="${proceso?.id}" class="btn btn-default">
                        <i class="fa fa-bars"></i> Solicitudes y avales del proceso
                    </g:link>
                </g:if>
            </div>
        </div>

        <g:if test="${solicitud && solicitud.estado.codigo == 'D01' && solicitud.observaciones}">
            <div class="row">
                <div class="col-md-12">
                    <elm:message tipo="warning" close="false">${solicitud?.observaciones}</elm:message>
                </div>
            </div>
        </g:if>

    %{--****************************************************************************************************************************************--}%
        <elm:wizardAvales paso="3" proceso="${proceso}"/>
    %{--****************************************************************************************************************************************--}%

    %{--<div class="wizard-container row">--}%
    %{--<div class="col-md-4 wizard-step wizard-next-step corner-left wizard-completed">--}%
    %{--<span class="badge wizard-badge">1</span>--}%
    %{--<g:link action="nuevaSolicitud" id="${proceso.id}">Proceso de aval</g:link>--}%
    %{--</div>--}%

    %{--<div class="col-md-4 wizard-step wizard-next-step wizard-completed">--}%
    %{--<span class="badge wizard-badge">2</span>--}%
    %{--<g:link action="solicitudAsignaciones" id="${proceso.id}">Asignaciones</g:link>--}%
    %{--</div>--}%

    %{--<div class="col-md-4 wizard-step corner-right wizard-current">--}%
    %{--<span class="badge wizard-badge">3</span> Solicitud--}%
    %{--</div>--}%
    %{--</div>--}%

        <g:uploadForm class="form-horizontal wizard-form corner-bottom frmAval" action="guardarSolicitud" controller="avales">
            <g:hiddenField name="proceso" value="${proceso.id}"/>
            <g:hiddenField name="disp" id="disponible" value="${disponible}"/>
            <g:hiddenField name="monto" value="${disponible}"/>
            <g:hiddenField name="numero" value="${numero}"/>
            <g:hiddenField name="referencial" value="${refencial}"/>
            <g:hiddenField name="solicitud" value="${solicitud?.id}"/>
            <g:hiddenField name="preview" value=""/>

            <div class="row">
                <span class="grupo">
                    <label class="col-md-2 control-label">
                        Número
                    </label>

                    <div class="col-md-2">
                        <p class="form-control-static">
                            ${numero}
                        </p>
                    </div>
                </span>

                <span class="grupo">
                    <label for="monto" class="col-md-2 control-label">
                        Monto
                    </label>

                    <div class="col-md-2">
                        <p class="form-control-static">
                            <strong><g:formatNumber number="${disponible}" type="currency"/></strong>
                        </p>
                    </div>
                </span>
            </div>

            <div class="row">
                <label class="col-md-2 control-label">
                    Proyecto
                </label>

                <div class="col-md-9">
                    <p class="form-control-static">
                        ${proceso.proyecto.toStringCompleto()}
                    </p>
                </div>
            </div>

            <div class="row">
                <span class="grupo">
                    <label for="memorando" class="col-md-2 control-label">
                        Doc. de soporte
                    </label>

                    <div class="col-md-2">
                        <g:if test="${!readOnly}">
                            <g:textField name="memorando" class="form-control input-sm " maxlength="63" style="width: 250px"
                                         value="${solicitud?.memo}"/>
                        </g:if>
                        <g:else>
                            <p class="form-control-static">
                                ${solicitud?.memo}
                            </p>
                        </g:else>
                    </div>
                </span>

                <span class="grupo">
                    <label for="monto" class="col-md-2 control-label" style="margin-left: 10px;">
                        Doc. de respaldo
                    </label>

                    <div class="col-md-5">
                        <g:if test="${!readOnly}">
                            <g:if test="${solicitud?.path}">
                                <input type="hidden" name="path" id="path" value="${solicitud?.path}" readonly style="margin-left: -10px"/>
                                Archivo subido:
                                <a href="${resource(dir: 'pdf/solicitudAval', file: solicitud?.path)}" target="_blank">
                                    <i class="fa fa-download"></i> ${solicitud?.path}
                                </a>
                            </g:if>
                            <input type="file" name="file" id="file" class="form-control input-sm " style="margin-left: -10px"/>
                        </g:if>
                        <g:else>
                            <p class="form-control-static">
                                <g:if test="${solicitud?.path}">
                                    <a href="${resource(dir: 'pdf/solicitudAval', file: solicitud?.path)}" target="_blank" style="margin-left: -10px">
                                        <i class="fa fa-download"></i> ${solicitud?.path}
                                    </a>
                                </g:if>
                                <g:else>
                                    No ha subido un archivo
                                </g:else>
                            </p>
                        </g:else>
                    </div>
                </span>
            </div>

            <div class="row">
                <span class="grupo">
                    <label for="memorando" class="col-md-2 control-label">
                        Descripción del proceso
                    </label>

                    <div class="col-md-9">
                        <g:if test="${!readOnly}">
                            <g:textArea name="concepto" maxlength="1024" required="" class="form-control input-sm required"
                                        style="height: 80px;resize: none" value="${solicitud?.concepto}"/>
                        </g:if>
                        <g:else>
                            <p class="form-control-static">
                                ${solicitud?.concepto}
                            </p>
                        </g:else>
                    </div>
                </span>
            </div>

            <div class="row">
                <span class="grupo">
                    <label for="firma1" class="col-md-2 control-label">
                        Pedir revisión de
                    </label>

                    <div class="col-md-4">
                        <g:if test="${!readOnly}">
                            <g:if test="${solicitud?.estado?.codigo == 'D01'}">
                                <p class="form-control-static">
                                    ${solicitud?.director}
                                </p>
                            </g:if>
                            <g:else>
                            %{--*${solicitud?.directorId}*--}%
                                <g:select from="${personas}" optionKey="id" class="form-control input-sm required"
                                          optionValue="${{
                                              it.nombre + ' ' + it.apellido
                                          }}" name="firma1" value="${solicitud?.directorId}" noSelection="['': '.. Seleccione ..']"/>
                            </g:else>
                        </g:if>
                        <g:else>
                            <p class="form-control-static">
                                ${solicitud?.director}
                            </p>
                        </g:else>
                    </div>
                </span>
            </div>

            <div class="row">
                <span class="grupo">
                    <label for="notaTecnica" class="col-md-2 control-label">
                        Nota Técnica
                    </label>

                    <div class="col-md-9">
                        <g:if test="${!readOnly}">
                            <g:textArea name="notaTecnica" style="resize: none" maxlength="350" class="form-control input-sm"
                                        value="${solicitud?.notaTecnica}"/>
                        </g:if>
                        <g:else>
                            <p class="form-control-static">
                                ${solicitud?.notaTecnica}
                            </p>
                        </g:else>
                    </div>
                </span>
            </div>

            <div class="row">
                <div class="col-md-11 text-right">
                    <g:if test="${!readOnly}">
                        <div class="btn-group" role="group">
                            <a href="#" id="btnPreview" class="btn btn-default ${solicitud ? '' : 'disabled'}" title="Previsualizar">
                                <i class="fa fa-search"></i> Previsualizar
                            </a>
                            <a href="#" id="btnGuardar" class="btn btn-info" title="Guardar y seguir editando">
                                <i class="fa fa-save"></i> Guardar
                            </a>
                            <a href="#" id="btnEnviar" class="btn btn-success" title="Guardar y solicitar revisión">
                                <i class="fa fa-save"></i> Guardar y Enviar <i class="fa fa-paper-plane-o"></i>
                            </a>
                        </div>
                    </g:if>
                </div>
            </div>
        </g:uploadForm>

        <script type="text/javascript">
            $(function () {
                $(".frmAval").validate({
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

                $("#btnEnviar").click(function () {
                    $("#preview").val("");
                    if ($(".frmAval").valid()) {
                        bootbox.confirm("<strong>¿Está seguro de querer enviar la solicitud?</strong><br/><br/>" +
                                        "Una vez enviada ya no se podrá modificar los datos de la Solicitud", function (res) {
                            if (res) {
                                openLoader("Por favor espere");
                                $(".frmAval").submit();
                            }
                        });
                    }
                });

                $("#btnGuardar").click(function () {
                    if ($(".frmAval").valid()) {
                        $("#preview").val("S");
                        openLoader("Por favor espere");
                        $(".frmAval").submit();
                    }
                });

                $("#btnPreview").click(function () {
                    var url = "${g.createLink(controller: 'reporteSolicitud',action: 'imprimirSolicitudAval')}/?id=${solicitud?.id}";
                    location.href = "${createLink(controller:'pdf',action:'pdfLink')}?url=" + url + "&filename=solicitud.pdf"
                });
            });
        </script>

    </body>
</html>