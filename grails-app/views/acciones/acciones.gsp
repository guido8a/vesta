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

        <div class="alert alert-primary padding-sm">
            Seleccione el módulo para editar acciones y procesos
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

        <div class="btn-toolbar">
            <div class="btn-group">
                <g:link controller="acciones" action="permisos" class="btn btn-sm btn-default">
                    <i class="fa fa-unlock-alt"></i> Gestionar permisos
                </g:link>
            </div>

            <div class="btn-group">
                <a href="#" id="btnCargarCont" class="btn btn-sm btn-default">
                    <i class="fa fa-paper-plane"></i> Cargar controladores
                </a>
                <a href="#" id="btnCargarAcc" class="btn btn-sm btn-default">
                    <i class="fa fa-paper-plane-o"></i> Cargar acciones
                </a>
            </div>
        </div>

        <script type="text/javascript">
            $(function () {
                $(".mdlo").click(function () {
                    var id = $(this).attr("id");
                    $("#acciones").html(spinner);
                    $(".active").removeClass("active");
                    $(this).parent().addClass("active");
                    $.ajax({
                        type   : "POST",
                        url    : "${createLink(controller:'acciones', action:'acciones_ajax')}",
                        data   : {
                            id: id
                        },
                        success: function (msg) {
                            $("#acciones").html(msg);
                        }
                    });
                    return false;
                }).first().click();

                $("#btnCargarCont").click(function () {
                    bootbox.confirm("¿Está seguro de querer cargar los controladores desde Grails?", function (result) {
                        if (result) {
                            openLoader();
                            $.ajax({
                                type   : "POST",
                                url    : "${createLink(controller:'acciones', action:'cargarControladores_ajax')}",
                                success: function (msg) {
                                    closeLoader();
                                    var parts = msg.split("*");
                                    log(parts[1], parts[0] == "SUCCESS" ? "success" : "error"); // log(msg, type, title, hide)
                                    $(".mdlo").first().click();
                                }
                            });
                        }
                    });
                });
                $("#btnCargarAcc").click(function () {
                    bootbox.confirm("¿Está seguro de querer cargar las acciones desde Grails?", function (result) {
                        if (result) {
                            openLoader();
                            $.ajax({
                                type   : "POST",
                                url    : "${createLink(controller:'acciones', action:'cargarAcciones_ajax')}",
                                success: function (msg) {
                                    closeLoader();
                                    var parts = msg.split("*");
                                    log(parts[1], parts[0] == "SUCCESS" ? "success" : "error"); // log(msg, type, title, hide)
                                    $(".mdlo").first().click();
                                }
                            });
                        }
                    });
                });
            });
        </script>

    </body>
</html>