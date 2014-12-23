<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 23/12/14
  Time: 04:10 PM
--%>

<%@ page import="vesta.seguridad.Prfl" contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <meta name="layout" content="main"/>
        <title>Gestionar permisos y módulos</title>
    </head>

    <body>

        <div class="alert alert-primary padding-sm">
            <div class="row margin-sm">
                <div class="col-md-8">
                    <p class="form-control-static">
                        Seleccione el módulo y el perfil para fijar permisos
                    </p>
                </div>

                <div class="col-md-2">
                    <p class="form-control-static">
                        Seleccione el perfil
                    </p>
                </div>

                <div class="col-md-2">
                    <g:select name="perfil" class="form-control input-sm" from="${Prfl.list([sort: 'nombre'])}"
                              optionKey="id" optionValue="nombre"/>
                </div>
            </div>
        </div>

        <ul class="nav nav-pills corner-all" style="border: solid 1px #cccccc; margin-bottom: 10px;">
            <g:each in="${modulos}" var="modulo">
                <li role="presentation">
                    <a href="#" class="mdlo" id="${modulo.id}">${modulo.nombre}</a>
                </li>
            </g:each>
        %{--<li role="presentation" class="active"><a href="#">Home</a></li>--}%
        </ul>

        <div class="well" id="permisos">

        </div>

        <script type="text/javascript">

            function reload() {
                var id = $(".active").find(".mdlo").attr("id");
                var perfil = $("#perfil").val();
                $("#permisos").html(spinner);
                $.ajax({
                    type   : "POST",
                    url    : "${createLink(controller:'acciones', action:'permisos_ajax')}",
                    data   : {
                        id  : id,
                        perf: perfil
                    },
                    success: function (msg) {
                        $("#permisos").html(msg);
                    }
                });
            }

            $(function () {
                $(".mdlo").click(function () {
                    $(".active").removeClass("active");
                    $(this).parent().addClass("active");
                    reload();
                    return false;
                }).first().click();

                $("#perfil").change(function () {
                    reload();
                });
            });
        </script>
    </body>
</html>