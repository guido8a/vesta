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
            width : 110px !important;
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
                    <form class="form-inline">
                        <div class="form-group">
                            <label for="authAct">Autorización actual</label>

                            <div class="input-group">
                                <g:passwordField name="authAct" class="form-control auth"/>
                                <span class="input-group-addon"><i class="fa fa-unlock"></i></span>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="authNueva">Nueva autorización</label>

                            <div class="input-group">
                                <g:passwordField name="authNueva" class="form-control auth"/>
                                <span class="input-group-addon"><i class="fa fa-lock"></i></span>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="authConfirm">Repita autorización</label>

                            <div class="input-group">
                                <g:passwordField name="authConfirm" class="form-control auth"/>
                                <span class="input-group-addon"><i class="fa fa-lock"></i></span>
                            </div>
                        </div>
                        <button type="submit" class="btn btn-default">Send invitation</button>
                    </form>
                </div>
            </div>
        </div>

    </body>
</html>