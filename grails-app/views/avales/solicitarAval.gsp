<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 27/01/15
  Time: 12:47 PM
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <meta name="layout" content="main"/>
        <title>Solicitud de aval -- Proceso: ${proceso.nombre}</title>
    </head>

    <body>

        <div class="btn-toolbar" role="toolbar">
            <div class="btn-group" role="group">
                <g:link class="btn btn-default" controller="avales" action="avalesProceso" id="${proceso.id}">
                    <i class="fa fa-list"></i> Avales
                </g:link>

                <a href="#" class="btn btn-success" id="enviar">
                    <i class="fa fa-save"></i> Guardar y enviar
                </a>
                <g:link action="listaProcesos" class="btn btn-default">
                Cancelar
            </g:link>
            </div>

        </div>

        <div class="modal-contenido">
            <g:uploadForm class="form-horizontal frmAval" action="guardarSolicitud" controller="avales">
                <g:hiddenField name="proceso" value="${proceso.id}"/>
                <g:hiddenField name="disp" id="disponible" value="${disponible}"/>
                <g:hiddenField name="monto" value="${disponible}"/>
                <g:hiddenField name="numero" value="${numero}"/>

                <div class="form-group keeptogether required">
                    <span class="grupo">
                        <label for="nombre" class="col-md-2 control-label">
                            Número
                        </label>

                        <div class="col-md-1">
                            <p class="form-control-static">
                                ${numero}
                            </p>
                        </div>
                    </span>

                </div>

                <div class="form-group keeptogether required">
                    <span class="grupo">
                        <label for="monto" class="col-md-2 control-label">
                            Monto
                        </label>

                        <div class="col-md-2">
                            <div class="input-group">
                                <p class="form-control-static">
                                    <g:formatNumber number="${disponible}" type="currency" currencySymbol=""/>
                                </p>
                            </div>
                        </div>
                    </span>
                    <span class="grupo">
                        <label for="monto" class="col-md-2 control-label">
                            Disponible
                        </label>

                        <div class="col-md-2">
                            <p class="form-control-static">
                                <g:formatNumber number="${disponible}" type="currency" currencySymbol=""/>
                            </p>
                        </div>
                    </span>
                </div>

                <div class="form-group keeptogether required">
                    <span class="grupo">
                        <label for="memorando" class="col-md-2 control-label">
                            Doc. de soporte
                        </label>

                        <div class="col-md-2">
                            <g:textField name="memorando" required="" class="form-control input-sm required"/>
                        </div>
                    </span>
                    <span class="grupo">
                        <label for="monto" class="col-md-2 control-label">
                            Doc. de respaldo
                        </label>

                        <div class="col-md-3">
                            <input type="file" name="file" id="file" class="form-control input-sm required"/>
                        </div>
                    </span>
                </div>

                <div class="form-group keeptogether required">
                    <span class="grupo">
                        <label for="memorando" class="col-md-2 control-label">
                            Concepto
                        </label>

                        <div class="col-md-7">
                            <g:textArea name="concepto" maxlength="1024" required="" class="form-control input-sm required" style="height: 80px;resize: none"/>
                        </div>
                    </span>
                </div>

                <div class="form-group keeptogether required">
                    <span class="grupo">
                        <label for="firma1" class="col-md-2 control-label">
                            Aut. electrónica
                        </label>

                        <div class="col-md-2">
                            <g:select from="${personas}" optionKey="id" class="form-control input-sm required" optionValue="${{
                                it.nombre + ' ' + it.apellido
                            }}" name="firma1"/>
                        </div>
                    </span>
                </div>

                %{--<div class="form-group">--}%
                    %{--<span class="grupo">--}%
                        %{--<div class="col-md-8 text-right">--}%
                            %{--<g:link action="listaProcesos" class="btn btn-default">--}%
                                %{--Cancelar--}%
                            %{--</g:link>--}%
                            %{--<a href="#" class="btn btn-success" id="enviar">--}%
                                %{--<i class="fa fa-save"></i> Guardar y enviar--}%
                            %{--</a>--}%
                        %{--</div>--}%
                    %{--</span>--}%
                %{--</div>--}%
            </g:uploadForm>
        </div>

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

                $("#enviar").click(function () {
                    $(".frmAval").submit();
//                    var monto = $("#monto").val();
//
////        monto = monto.replace(new RegExp("\\.", 'g'), "");
//                    monto = monto.replace(new RegExp(",", 'g'), ".");
//
//                    var memorando = $("#memorando").val();
//                    var concepto = $("#concepto").val();
//                    var file = $("#file").val();
//                    var msg = "";
//                    var disponible = $("#disponible").val();
//
//                    if (isNaN(monto)) {
//                        msg += "<br>El monto debe ser un número positivo";
//                    } else {
//                        monto = monto * 1;
//                    }
//                    if (monto < 0.00001) {
//                        msg += "<br>El monto debe ser un número positivo mayor que cero.";
//                    }
//                    if (monto > disponible * 1) {
//                        msg += "<br>El monto debe ser menor o igual que " + number_format(disponible, 2, ",", ".") + ".";
//                    }
//                    if (concepto.length > 1024) {
//                        msg += "<br>El concepto debe tener máximo 1024 caracteres. Tamaño actual " + concepto.length + ".";
//                    }
//                    if (concepto.trim().length < 1) {
//                        msg += "<br>Por favor ingrese un concepto.";
//                    }
//
//                    if (msg == "") {
//                        $("form").submit()
//                    } else {
//                        $.bootbox(msg);
//                    }
                });
            });

        </script>

    </body>
</html>