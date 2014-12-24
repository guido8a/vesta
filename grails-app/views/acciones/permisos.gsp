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

        <div class="btn-toolbar">
            <div class="btn-group">
                <g:link controller="acciones" action="acciones" class="btn btn-sm btn-default">
                    <i class="fa fa-unlock-alt"></i> Gestionar módulos
                </g:link>
            </div>

            <div class="btn-group">
                <a href="#" id="btnCrearPerfil" class="btn btn-sm btn-default">
                    <i class="fa fa-file-o"></i> Crear perfil
                </a>
                <a href="#" id="btnEditarPerfil" class="btn btn-sm btn-default">
                    <i class="fa fa-pencil"></i> Editar perfil
                </a>
                <a href="#" id="btnBorrarPerfil" class="btn btn-sm btn-default">
                    <i class="fa fa-trash-o"></i> Eliminar perfil
                </a>
            </div>

            <div class="btn-group">
                <a href="#" id="btnCrearModulo" class="btn btn-sm btn-default">
                    <i class="fa fa-file-o"></i> Crear módulo
                </a>
                <a href="#" id="btnEditarModulo" class="btn btn-sm btn-default">
                    <i class="fa fa-pencil"></i> Editar módulo
                </a>
                <a href="#" id="btnBorrarModulo" class="btn btn-sm btn-default">
                    <i class="fa fa-trash-o"></i> Eliminar módulo
                </a>
            </div>
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

            /* **************************************** PERFIL ******************************************************** */
            function submitFormPerfil() {
                var $form = $("#frmPrfl");
                var $btn = $("#dlgCreateEdit").find("#btnSave");
                if ($form.valid()) {
                    $btn.replaceWith(spinner);
                    openLoader("Guardando Prfl");
                    $.ajax({
                        type   : "POST",
                        url    : $form.attr("action"),
                        data   : $form.serialize(),
                        success: function (msg) {
                            var parts = msg.split("*");
                            log(parts[1], parts[0] == "SUCCESS" ? "success" : "error"); // log(msg, type, title, hide)
                            setTimeout(function () {
                                if (parts[0] == "SUCCESS") {
                                    location.reload(true);
                                } else {
                                    spinner.replaceWith($btn);
                                    return false;
                                }
                            }, 1000);
                        }
                    });
                } else {
                    return false;
                } //else
            }
            function deletePerfil(itemId) {
                bootbox.dialog({
                    title  : "Alerta",
                    message: "<i class='fa fa-trash-o fa-3x pull-left text-danger text-shadow'></i><p>" +
                    "¿Está seguro que desea eliminar el Perfil seleccionado (<strong>" + $("#perfil").find("option:selected").text() + "</strong>)? " +
                    "Esta acción no se puede deshacer.</p>",
                    buttons: {
                        cancelar: {
                            label    : "Cancelar",
                            className: "btn-primary",
                            callback : function () {
                            }
                        },
                        eliminar: {
                            label    : "<i class='fa fa-trash-o'></i> Eliminar",
                            className: "btn-danger",
                            callback : function () {
                                openLoader("Eliminando Prfl");
                                $.ajax({
                                    type   : "POST",
                                    url    : '${createLink(controller: 'prfl', action:'delete_ajax')}',
                                    data   : {
                                        id: itemId
                                    },
                                    success: function (msg) {
                                        var parts = msg.split("*");
                                        log(parts[1], parts[0] == "SUCCESS" ? "success" : "error"); // log(msg, type, title, hide)
                                        if (parts[0] == "SUCCESS") {
                                            setTimeout(function () {
                                                location.reload(true);
                                            }, 1000);
                                        } else {
                                            closeLoader();
                                        }
                                    }
                                });
                            }
                        }
                    }
                });
            }
            function createEditPerfil(id) {
                var title = id ? "Editar" : "Crear";
                var data = id ? {id: id} : {};
                $.ajax({
                    type   : "POST",
                    url    : "${createLink(controller: 'prfl', action:'form_ajax')}",
                    data   : data,
                    success: function (msg) {
                        var b = bootbox.dialog({
                            id   : "dlgCreateEdit",
                            title: title + " Prfl",

                            message: msg,
                            buttons: {
                                cancelar: {
                                    label    : "Cancelar",
                                    className: "btn-primary",
                                    callback : function () {
                                    }
                                },
                                guardar : {
                                    id       : "btnSave",
                                    label    : "<i class='fa fa-save'></i> Guardar",
                                    className: "btn-success",
                                    callback : function () {
                                        return submitFormPerfil();
                                    } //callback
                                } //guardar
                            } //buttons
                        }); //dialog
                        setTimeout(function () {
                            b.find(".form-control").first().focus()
                        }, 500);
                    } //success
                }); //ajax
            } //createEdit
            /* **************************************** PERFIL ******************************************************** */

            /* **************************************** MODULO ******************************************************** */
            /* **************************************** MODULO ******************************************************** */

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

                $("#btnCrearPerfil").click(function () {
                    createEditPerfil();
                    return false;
                });

                $("#btnEditarPerfil").click(function () {
                    createEditPerfil($("#perfil").val());
                    return false;
                });

                $("#btnBorrarPerfil").click(function () {
                    deletePerfil($("#perfil").val());
                    return false;
                });

            });
        </script>
    </body>
</html>