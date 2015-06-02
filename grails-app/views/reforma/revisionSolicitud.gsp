<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 22/05/15
  Time: 10:21 AM
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <meta name="layout" content="main"/>
        <title>Revisar solicitud de reforma</title>
    </head>

    <body>
        <h1>Revisar solicitud de reforma</h1>

        <g:if test="${reforma.estado.codigo == 'D02' && reforma.firmaSolicitud.observaciones && reforma.firmaSolicitud.observaciones != '' && reforma.firmaSolicitud.observaciones != 'S'}">
            <elm:message tipo="warning"><strong>Devuelto por ${reforma.firmaSolicitud.usuario}</strong>: ${reforma.firmaSolicitud.observaciones}</elm:message>
        </g:if>

        <div class="row">
            <div class="col-md-2 show-label">
                Solicitado por
            </div>

            <div class="col-md-4">
                ${reforma.persona}
            </div>

            <div class="col-md-2 show-label">
                Fecha
            </div>

            <div class="col-md-4">
                ${reforma.fecha.format("dd-MM-yyyy")}
            </div>
        </div>

        <div class="row">
            <div class="col-md-2 show-label">
                Concepto
            </div>

            <div class="col-md-10">
                ${reforma.concepto}
            </div>
        </div>

        <div class="row">
            <div class="col-md-2 show-label">
                Tipo de reforma
            </div>

            <div class="col-md-10">
                <elm:tipoReforma reforma="${reforma}"/>
            </div>
        </div>

        <g:render template="/reportesReformaTemplates/tablaSolicitud"
                  model="[det: det, tipo: reforma.tipoSolicitud.toLowerCase()]"/>

        <form id="frmFirmas">
            <div class="row">
                <div class="col-md-2 show-label">Autorización electrónica</div>

                <div class="col-md-3 grupo">
                    <g:if test="${reforma.estado.codigo == 'D02'}">
                        <p class="static-control">
                            ${reforma.firmaSolicitud.usuario}
                        </p>
                    </g:if>
                    <g:else>
                        <g:select from="${gerentes}" optionKey="id" optionValue="${{
                            it.nombre + ' ' + it.apellido
                        }}" noSelection="['': '- Seleccione -']" name="firma" class="form-control required input-sm"/>
                    </g:else>
                </div>
            </div>
        </form>


        <div class="row">
            <div class="col-md-5">
                <div class="btn-group" role="group" aria-label="...">
                    <elm:linkPdfReforma reforma="${reforma}" class="btn-default" title="Previsualizar" label="true"/>
                    <a href="#" class="btn btn-danger" id="btnDevolver" title="Devolver al requirente con observaciones">
                        <i class="fa fa-thumbs-down"></i> Devolver al requirente
                    </a>
                    <a href="#" class="btn btn-success" id="btnSolicitar" title="Solicitar firma del gerente">
                        <i class="fa fa-pencil"></i> Solicitar firma
                    </a>
                </div>
            </div>
        </div>

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

                $("#btnSolicitar").click(function () {
                    if ($("#frmFirmas").valid()) {
                        var $msg = $("<div>");
                        var $form = $("<form class='form-horizontal'>");

                        var $r2 = $("<div class='form-group'\"'>");
                        $r2.append("<label class='col-sm-4 control-label' for='obs'>Autorización</label>");
                        var $auth = $("<input type='password' class='form-control required'/>");
                        var auth = $("<div class='col-sm-8 grupo'>");
                        var authGrp = $("<div class='input-group'>");
                        authGrp.append($auth);
                        authGrp.append("<span class='input-group-addon'><i class='fa fa-unlock-alt'></i></span>");
                        auth.append(authGrp);
                        $r2.append(auth);
                        $form.append($r2);

                        $msg.append($form);

                        $form.validate({
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

                        bootbox.dialog({
                            title   : "Solicitar firma",
                            message : $msg,
                            class   : "modal-sm",
                            buttons : {
                                devolver : {
                                    label     : "<i class='fa fa-pencil'></i> Solicitar firma",
                                    className : "btn-success",
                                    callback  : function () {
                                        if ($form.valid()) {
                                            openLoader("Solicitando");
                                            $.ajax({
                                                type    : "POST",
                                                url     : "${createLink(action: 'enviarAGerente_ajax')}",
                                                data    : {
                                                    id    : "${reforma.id}",
                                                    firma : $("#firma").val(),
                                                    auth  : $auth.val()
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
                                                },
                                                error   : function () {
                                                    log("Ha ocurrido un error interno", "error");
                                                    closeLoader();
                                                }
                                            });
                                        }
                                        return false;
                                    }
                                },
                                cancelar : {
                                    label     : "Cancelar",
                                    className : "btn-default",
                                    callback  : function () {
                                    }
                                }
                            }
                        });
                    }
                    return false;
                });

                $("#btnDevolver").click(function () {
                    var $msg = $("<div>");
                    var $form = $("<form class='form-horizontal'>");
                    var $r1 = $("<div class='form-group'\"'>");
                    $r1.append("<label class='col-sm-2 control-label' for='obs'>Observaciones</label>");
                    var $obs = $("<textarea name='obs' id='obs' class='form-control required'/>");
                    var obs = $("<div class='col-sm-10 grupo'>");
                    obs.append($obs);
                    $r1.append(obs);
                    $form.append($r1);

                    var $r2 = $("<div class='form-group'\"'>");
                    $r2.append("<label class='col-sm-2 control-label' for='obs'>Autorización</label>");
                    var $auth = $("<input type='password' name='auth' id='auth' class='form-control required'/>");
                    var auth = $("<div class='col-sm-5 grupo'>");
                    var authGrp = $("<div class='input-group'>");
                    authGrp.append($auth);
                    authGrp.append("<span class='input-group-addon'><i class='fa fa-unlock-alt'></i></span>");
                    auth.append(authGrp);
                    $r2.append(auth);
                    $form.append($r2);

                    $msg.append($form);

                    $form.validate({
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

                    bootbox.dialog({
                        title   : "Devolver al requirente",
                        message : $msg,
                        buttons : {
                            devolver : {
                                label     : "<i class='fa fa-thumbs-down'></i> Devolver al requirente",
                                className : "btn-danger",
                                callback  : function () {
                                    if ($form.valid()) {
                                        openLoader("Devolviendo");
                                        $.ajax({
                                            type    : "POST",
                                            url     : "${createLink(action: 'devolverARequirente_ajax')}",
                                            data    : {
                                                id   : "${reforma.id}",
                                                obs  : $obs.val(),
                                                auth : $auth.val()
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
                                            },
                                            error   : function () {
                                                log("Ha ocurrido un error interno", "error");
                                                closeLoader();
                                            }
                                        });
                                    }
                                    return false;
                                }
                            },
                            cancelar : {
                                label     : "Cancelar",
                                className : "btn-default",
                                callback  : function () {
                                }
                            }
                        }
                    });
                    return false;
                });
            });
        </script>

    </body>
</html>