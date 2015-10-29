<%--
  Created by IntelliJ IDEA.
  User: fabricio
  Date: 21/01/15
  Time: 03:08 PM
--%>

<%--
  Created by IntelliJ IDEA.
  User: svt
  Date: 8/12/2014
  Time: 4:07 PM
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main"/>
        <title>Solicitud de anulación del aval ${aval.fechaAprobacion.format("yyyy")}-GP No.${aval.numeroAval}</title>

        <script type="text/javascript" src="${resource(dir: 'js/plugins/jquery-validation-1.13.1/dist', file: 'additional-methods.min.js')}"></script>

    </head>

    <body>

        <elm:message tipo="${flash.tipo}" clase="${flash.clase}">${flash.message}</elm:message>

        <div class="btn-toolbar" role="toolbar">
            <div class="btn-group" role="group">
                <g:link class="btn btn-default" controller="avales" action="avalesProceso" id="${aval.procesoId}">
                    <i class="fa fa-list"></i> Avales
                </g:link>
            </div>
        </div>

        <g:if test="${sol && sol.estado.codigo == 'D01' && sol.observaciones}">
            <div class="row">
                <div class="col-md-12">
                    <elm:message tipo="warning" close="false">${sol?.observaciones}</elm:message>
                </div>
            </div>
        </g:if>

        <elm:container tipo="horizontal" titulo="Solicitud de anulación de aval">
            <g:uploadForm class="form-horizontal frmUpload" action="guardarSolicitud" controller="avales">
                <input type="hidden" name="aval" value="${aval.id}">
                <input type="hidden" name="tipo" value="A">
                <input type="hidden" name="monto" value="${aval.monto}">
                <input type="hidden" name="proceso" value="${aval.proceso.id}">
                <input type="hidden" name="numero" value="${numero}">
                <input type="hidden" name="solicitud" value="${sol?.id}">

                <div class="form-group keeptogether required">
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
                </div>

                <div class="form-group keeptogether required">
                    <span class="grupo">
                        <label class="col-md-2 control-label">
                            Monto
                        </label>

                        <div class="col-md-2">
                            <p class="form-control-static">
                                <g:formatNumber number="${aval.monto}" type="currency" currencySymbol=""/>
                            </p>
                        </div>
                    </span>
                </div>

                <div class="form-group keeptogether ">
                    <span class="grupo">
                        <label for="memorando" class="col-md-2 control-label">
                            Doc. de soporte
                        </label>

                        <div class="col-md-2">
                            <g:textField name="memorando" class="form-control input-sm required" required="" value="${sol?.memo}"/>
                        </div>
                    </span>
                    <span class="grupo">
                        <label for="file" class="col-md-2 control-label">
                            Doc. de respaldo
                        </label>

                        <div class="col-md-3">
                            <input type="file" name="file" id="file" class="form-control input-sm"/>
                            <g:if test="${sol?.path}">
                                <g:link controller="avales" action="descargaSolicitud" id="${sol.id}">
                                    <i class="fa fa-download"></i> ${sol.path}
                                </g:link>
                            </g:if>
                        </div>
                    </span>
                </div>

                <div class="form-group keeptogether required">
                    <span class="grupo">
                        <label for="concepto" class="col-md-2 control-label">
                            Justificación
                        </label>

                        <div class="col-md-7">
                            <g:textArea name="concepto" maxlength="1024" style="height: 80px;" class="form-control required"
                                        required="" value="${sol?.concepto}"/>
                        </div>
                    </span>
                </div>

                <div class="form-group keeptogether required">
                    <span class="grupo">
                        <label for="firma1" class="col-md-2 control-label">
                            Pedir revisión de
                        </label>

                        <div class="col-md-3">
                            <g:if test="${sol?.estado?.codigo == 'D01'}">
                                <p class="form-control-static">
                                    ${sol?.director}
                                </p>
                            </g:if>
                            <g:else>
                            %{--*${solicitud?.directorId}*--}%
                                <g:select from="${personas}" optionKey="id" class="form-control input-sm required"
                                          optionValue="${{
                                              it.nombre + ' ' + it.apellido
                                          }}" name="firma1" value="${sol?.directorId}" noSelection="['': '.. Seleccione ..']"/>
                            </g:else>
                        </div>
                    </span>
                </div>

                <div class="form-group">
                    <span class="grupo">
                        <div class="col-md-8 text-right">
                            <g:link action="listaProcesos" class="btn btn-default">
                                Cancelar
                            </g:link>
                            <a href="#" class="btn btn-success" id="enviar">
                                <i class="fa fa-save"></i> Guardar y enviar
                            </a>
                        </div>
                    </span>
                </div>
            </g:uploadForm>
        </elm:container>

        <script type="text/javascript">
            $(function () {
                var validator = $(".frmUpload").validate({
                    rules          : {
                        file : {
//                            accept    : ["application/pdf", "application/download", "application/vnd.ms-pdf"],
                            accept    : "application/pdf,application/download,application/vnd.ms-pdf",
                            extension : "pdf"

                        }

                    },
                    messages       : {
                        file : {
                            accept    : "Por favor seleccione un PDF",
                            extension : "Por favor seleccione un PDF"
                        }
                    },
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
                $("#enviar").click(function () {
                    $(".frmUpload").submit();
                });
            });
        </script>

        %{--<script>--}%
        %{--$("#enviar").click(function () {--}%
        %{--var memorando = $("#memorando").val();--}%
        %{--var concepto = $("#concepto").val();--}%
        %{--var file = $("#file").val();--}%
        %{--var msg = "";--}%

        %{--if (concepto.length > 1024) {--}%
        %{--msg += "<br>El concepto debe tener máximo 1024 caracteres. Tamaño actual " + concepto.length + "."--}%
        %{--}--}%
        %{--if (concepto.trim().length < 1) {--}%
        %{--msg += "<br>Por favor ingrese un concepto."--}%
        %{--}--}%
        %{--if (memorando.trim().length < 1) {--}%
        %{--msg += "<br>Por favor ingrese un número de memorando."--}%
        %{--}--}%

        %{--if (file.length < 1) {--}%
        %{--msg += "<br>Por favor seleccione un archivo."--}%
        %{--} else {--}%
        %{--var ext = file.split('.').pop();--}%
        %{--if (ext != "pdf") {--}%
        %{--msg += "<br>Por favor seleccione un archivo de formato pdf. El formato " + ext + " no es aceptado por el sistema"--}%
        %{--}--}%
        %{--}--}%

        %{--if (msg == "") {--}%
        %{--$("form").submit()--}%
        %{--} else {--}%
        %{--$.box({--}%
        %{--title  : "Error",--}%
        %{--text   : msg,--}%
        %{--dialog : {--}%
        %{--resizable : false,--}%
        %{--buttons   : {--}%
        %{--"Cerrar" : function () {--}%

        %{--}--}%
        %{--}--}%
        %{--}--}%
        %{--});--}%
        %{--}--}%
        %{--});--}%
        %{--</script>--}%
    </body>
</html>