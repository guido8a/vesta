<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 12/12/14
  Time: 12:15 PM
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <meta name="layout" content="no-menu">
        <title>Entrada</title>
        <link href="${resource(dir: 'css', file: 'login.css')}" rel="stylesheet"/>
    </head>

    <body>
        <div class="row">
            <div class="col-md-3 col-md-offset-9">
                <div class="tdn-tab tdn-tab-left tdn-tab-primary">
                    <div class="tdn-tab-heading">
                        <a href="#" class="selected">Entrada</a>
                    </div>

                    <div class="tdn-tab-body">
                        <img class="img-login" src="${resource(dir: 'images', file: 'logo-login.png')}"/>

                        <div class="input-group input-login">
                            <g:textField name="user" class="form-control" placeholder="Usuario"/>
                            <span class="input-group-addon"><i class="fa fa-user"></i></span>
                        </div>

                        <div class="input-group input-login">
                            <g:passwordField name="pass" class="form-control" placeholder="Contraseña"/>
                            <span class="input-group-addon"><i class="fa fa-unlock-alt"></i></span>
                        </div>

                        <div class="text-right">
                            <a href="#" class="btn btn-primary">Validar <i class="fa fa-unlock"></i></a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>