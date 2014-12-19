<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 19/12/14
  Time: 04:55 PM
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <meta name="layout" content="main"/>
        <title>Estructura del Menú y Procesos</title>
    </head>

    <body>

        <div class="alert alert-primary">
            Seleccione el módulo para fijar permisos o editar acciones y procesos
        </div>

        <ul class="nav nav-pills corner-all" style="border: solid 1px #cccccc; margin-bottom: 10px;">
            <g:each in="${modulos}" var="modulo">
                <li role="presentation">
                    <a href="#" class="mdlo" id="${modulo.id}">${modulo.nombre}</a>
                </li>
            </g:each>
        %{--<li role="presentation" class="active"><a href="#">Home</a></li>--}%
        </ul>

        <div class="well" id="acciones">

        </div>

        <script type="text/javascript">
            $(function () {
                $(".mdlo").click(function () {
                    var id = $(this).attr("id");
                    $.ajax({
                        type: "POST",
                        url: "${createLink(controller:'acciones', action:'acciones_ajax')}",
                        data: {
                            id: id
                        },
                        success: function (msg) {
                            alert(msg)
                        }
                    });
                    return false;
                });
            });
        </script>

    </body>
</html>