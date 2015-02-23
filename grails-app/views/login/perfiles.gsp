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
        <title>Perfiles</title>
        <link href="${resource(dir: 'css', file: 'login.css')}" rel="stylesheet"/>
    </head>

    <body>
        <div class="row">
            <div class="col-md-3 col-md-offset-9 col-sm-4 col-sm-offset-8 col-xs-6" style="background: none">
                <div class="tdn-tab tdn-tab-left tdn-tab-primary" style="background: none">
                    <div class="tdn-tab-heading">
                        <a href="#" class="selected">Perfiles</a>
                    </div>

                    <div class="tdn-tab-body" style="background: white">
                        <img class="img-login" src="${resource(dir: 'images', file: 'logo-login.png')}"/>

                        <g:form name="frmLogin" action="savePerfil">
                            <g:select from="${perfiles}" name="perfil" class="form-control input-login" optionKey="id"/>

                            <div class="text-right">
                                <a href="#" id="btn-login" class="btn btn-primary">Validar <i class="fa fa-unlock"></i>
                                </a>
                            </div>
                        </g:form>
                    </div>
                </div>
            </div>
        </div>

        <script type="text/javascript">
            var $frm = $("#frmLogin");
            function doLogin() {
                if ($frm.valid()) {
                    $("#btn-login").replaceWith(spinner);
                    $frm.submit();
                }
            }

            $(function () {
                $("#btn-login").click(function () {
                    doLogin();
                });
            });

        </script>

    </body>
</html>