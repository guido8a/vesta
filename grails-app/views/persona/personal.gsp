<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 23/01/15
  Time: 04:06 PM
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <meta name="layout" content="main">
        <title>Configuración</title>

        <style type="text/css">
        .auth {
            width : 155px !important;
        }
        </style>

    </head>

    <body>

        <div class="panel panel-info">
            <div class="panel-heading" role="tab" id="headingOne">
                <h4 class="panel-title">
                    <a data-toggle="collapse" data-parent="#accordion" href="#collapseOne" aria-expanded="true" aria-controls="collapseOne">
                        Cambiar clave de autorización
                    </a>
                </h4>
            </div>

            <div id="collapseOne" class="panel-collapse collapse in" role="tabpanel" aria-labelledby="headingOne">
                <div class="panel-body">
                    <g:form class="form-inline" name="frmAuth" action="updateAuth">
                        <div class="form-group">
                            <label for="input1">Autorización actual</label>

                            <div class="input-group">
                                <g:passwordField name="input1" class="form-control auth"/>
                                <span class="input-group-addon"><i class="fa fa-unlock"></i></span>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="authNueva">Nueva autorización</label>

                            <div class="input-group">
                                <g:passwordField name="authNueva" class="form-control required auth"/>
                                <span class="input-group-addon"><i class="fa fa-lock"></i></span>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="authConfirm">Repita autorización</label>

                            <div class="input-group">
                                <g:passwordField name="authConfirm" class="form-control required auth"/>
                                <span class="input-group-addon"><i class="fa fa-lock"></i></span>
                            </div>
                        </div>
                        <a href="#" id="btnSaveAuth" class="btn btn-success">
                            <i class="fa fa-save"></i> Guardar
                        </a>
                    </g:form>
                </div>
            </div>
        </div>

        <script type="text/javascript">
            $(function () {
                var $frmAuth = $("#frmAuth");
                $frmAuth.validate({
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
                    },
                    rules          : {
                        input1 : {
                            remote : {
                                url  : "${createLink(action: 'validar_aut_previa_ajax')}",
                                type : "post",
                                data : {
                                    id : "${persona?.id}"
                                }
                            }
                        }
                    },
                    messages       : {
                        input1 : {
                            remote : "La autorización no concuerda"
                        }
                    }
                });

                $("#btnSaveAuth").click(function () {
                    if ($frmAuth.valid()) {
                        $.ajax({
                            type    : "POST",
                            url     : $frmAuth.attr("action"),
                            data    : $frmAuth.serialize(),
                            success : function (msg) {
                                var parts = msg.split("*");
                                log(parts[1], parts[0] == "SUCCESS" ? "success" : "error"); // log(msg, type, title, hide)
                                closeLoader();
                                $frmAuth[0].reset();
                            }
                        });
                    }
                    return false;
                });
            });
        </script>

    </body>
</html>