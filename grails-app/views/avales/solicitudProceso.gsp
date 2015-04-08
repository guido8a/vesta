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

        <input type="hidden" name="id" value="${proceso?.id}">

        <div class="btn-toolbar" role="toolbar">
            <div class="btn-group" role="group">
                <g:link controller="avales" action="listaProcesos" class="btn btn-default">
                    <i class="fa fa-bars"></i> Lista de Procesos
                </g:link>
            </div>
        </div>

        <div class="wizard-container row">
            <div class="col-md-4 wizard-step wizard-next-step corner-left wizard-completed">
                <span class="badge wizard-badge">1</span>
                <g:link action="nuevaSolicitud" id="${proceso.id}">Proceso de aval</g:link>
            </div>

            <div class="col-md-4 wizard-step wizard-next-step wizard-completed">
                <span class="badge wizard-badge">2</span>
                <g:link action="solicitudAsignaciones" id="${proceso.id}">Asignaciones</g:link>
            </div>

            <div class="col-md-4 wizard-step corner-right wizard-current">
                <span class="badge wizard-badge">3</span> Solicitud
            </div>
        </div>

        <g:uploadForm class="form-horizontal wizard-form corner-bottom frmAval" action="guardarSolicitud" controller="avales">
            <g:hiddenField name="proceso" value="${proceso.id}"/>
            <g:hiddenField name="disp" id="disponible" value="${disponible}"/>
            <g:hiddenField name="monto" value="${disponible}"/>
            <g:hiddenField name="numero" value="${numero}"/>
            <input type="hidden" name="referencial" value="${refencial}">

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
                            <g:textField name="memorando" class="form-control input-sm required" maxlength="63" style="width: 250px"/>
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
                            <input type="file" name="file" id="file" class="form-control input-sm required" style="margin-left: -10px"/>
                        </g:if>
                        <g:else>
                            <p class="form-control-static">
                                <a href="${resource(dir: 'pdf/solicitudAval', file: solicitud?.path)}" target="_blank"  style="margin-left: -10px">
                                    ${solicitud?.path}
                                </a>
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
                            <g:textArea name="concepto" maxlength="1024" required="" class="form-control input-sm required" style="height: 80px;resize: none"/>
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
                        Autorización electrónica
                    </label>

                    <div class="col-md-4">
                        <g:if test="${!readOnly}">
                            <g:select from="${personas}" optionKey="id" class="form-control input-sm required" optionValue="${{
                                it.nombre + ' ' + it.apellido
                            }}" name="firma1"/>
                        </g:if>
                        <g:else>
                            <p class="form-control-static">
                                ${solicitud?.firma?.usuario}
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
                            <g:textArea name="notaTecnica" style="resize: none" maxlength="350" class="form-control input-sm"/>
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
                        <a href="#" id="btnEnviar" class="btn btn-success">
                            <i class="fa fa-save"></i> Guardar y Enviar <i class="fa fa-paper-plane-o"></i>
                        </a>
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
                    if ($(".frmAval").valid()) {
                        bootbox.confirm("¿Está seguro de querer enviar la solicitud?<br/>" +
                                        "Una vez enviada no podrá ser modificada ni podrá iniciar otro proceso de solicitud hasta que éste " +
                                        "sea completado", function (res) {
                            if (res) {
                                openLoader("Por favor espere");
                                $(".frmAval").submit();
                            }
                        });
                    }
                });
            });
        </script>

    </body>
</html>