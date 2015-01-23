<%@ page import="vesta.parametros.Catalogo" %>
<%--
  Created by IntelliJ IDEA.
  User: fabricio
  Date: 22/12/14
  Time: 12:44 PM
--%>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main"/>
        <title>Catálogo del sistema</title>
    </head>

    <body>
        <div class="panel panel-default">
            <div class="panel-body">
                <div class="btn-toolbar" role="toolbar">
                    <div class="btn-group" role="group" style="margin-right: 15px;">
                        <a href="#" class="modulo btn btn-default btn-sm" id="creaCtlg" name="modulo">
                            <i class="fa fa-file-o"></i>
                            Crear Catálogo
                        </a>
                        <a href="#" class="modulo btn btn-default btn-sm" id="editCtlg" name="modulo">
                            <i class="fa fa-pencil"></i>
                            Editar Catálogo
                        </a>
                        <a href="#" class="modulo btn btn-default btn-sm" id="borraCtlg" name="modulo">
                            <i class="fa fa-trash-o"></i>
                            Borrar Catálogo
                        </a>
                    </div>

                    <form class="form-inline">
                        <div class="form-group">
                            <label for="catalogo">Seleccione un Catálogo</label>
                            <g:select optionKey="id" from="${Catalogo.list([sort: 'nombre'])}"
                                      class="form-control input-sm"
                                      name="catalogo" style="width: 280px;"/>
                        </div>

                        <a href="#" class="modulo btn btn-default btn-sm" id="ver">
                            Ver Items
                        </a>
                    </form>
                </div>
            </div>
        </div>

        <div class="" id="parm">
            <div id="ajx" style="width:820px; padding-left: 20px; "></div>

            <div id="ajx_prfl" style="width:540px;"></div>

            <div id="ajx_menu" style="width:540px;"></div>
        </div>

        <div id="datosPerfil" class="container entero  ui-corner-bottom">
        </div>

        <script type="text/javascript">
            $(function () {
                $("#procesos").click(function () {
                    var datos = armar();
                    //alert(datos)
                    $.ajax({
                        type    : "POST", url : "../ajaxPermisos",
                        data    : "ids=" + datos + "&tipo=P",
                        success : function (msg) {
                            $("#ajx").html(msg)
                        }
                    });
                });

                $(".modulo").click(function () {
                    var datos = armar();
//            alert(datos)
                    $.ajax({
                        type    : "POST", url : "${createLink(action:'cargaItem',controller:'catalogo')}",
                        data    : "ids=" + datos + "&ctlg=" + $('#catalogo').val(),
                        success : function (msg) {
                            $("#ajx").html(msg)
                        }
                    });
                });

                $(".rd_tipo").click(function () {
                    $("#ajx").html('');
                    //location.reload();
                });

                $("#perfil").click(function () {
                    $("#ajx").html('');
                    //location.reload();
                });

                $("#vermenu").button().click(function () {
                    $.ajax({
                        type    : "POST", url : "../verMenu",
                        data    : "prfl=" + $('#perfil').val() + "&tpac=" + tipo(),
                        success : function (msg) {
                            $("#ajx").html(msg)
                        }
                    });
                });

                function armar() {
                    var datos = [];
                    $('.modulo:checked').each(
                            function () {
                                datos.push($(this).val());
                            }
                    );
                    return datos
                }

                function tipo() {
                    var datos = [];
                    $('.rd_tipo:checked').each(
                            function () {
                                datos.push($(this).val());
                            }
                    );
                    return datos
                }

                $("#creaCtlg").click(function () {
                    createEditRow();
                    return false;
                });

                $("#editCtlg").click(function () {
                    var idCatalogo = $("#catalogo").val();
                    createEditRow(idCatalogo);
                    return false;
                });

                $("#borraCtlg").click(function () {
                    var idCatalogo = $("#catalogo").val();
                    deleteRow(idCatalogo);
                    return false;

                });

                $("#ajx_prfl").dialog({
                    autoOpen  : false,
                    resizable : false,
                    title     : 'Crear un Catálogo',
                    modal     : true,
                    draggable : false,
                    width     : 420,
                    position  : 'center',
                    open      : function (event, ui) {
                        $(".ui-dialog-titlebar-close").hide();
                    },
                    buttons   : {
                        "Grabar"   : function () {
                            $(this).dialog("close");
                            $.ajax({
                                type : "POST", url : "${createLink(action:'grabaCtlg',controller:'catalogo')}",
                                data : "&nombre=" + $('#nombre').val() + "&codigo=" + $('#codigo').val() +
                                        "&estado=" + $('#estado').val() + "&id=" + $('#id_ctlg').val(),
                                success : function (msg) {
                                    //$("#ajx").html(msg)
                                    location.reload(true);

                                }
                            });
                        },
                        "Cancelar" : function () {
                            $(this).dialog("close");
                        }
                    }
                });

                $("#ajx_menu").dialog({
                    autoOpen  : false,
                    resizable : false,
                    title     : 'Crear un Módulo',
                    modal     : true,
                    draggable : false,
                    width     : 420,
                    position  : 'center',
                    open      : function (event, ui) {
                        $(".ui-dialog-titlebar-close").hide();
                    },
                    buttons   : {
                        "Grabar"   : function () {
                            $(this).dialog("close");
                            $.ajax({
                                type : "POST", url : "../grabaMdlo",
                                data : "&nombre=" + $('#nombre').val() + "&descripcion=" + $('#descripcion').val() +
                                        "&id=" + $('#id_mdlo').val() + "&orden=" + $('#orden').val(),
                                success : function (msg) {
                                    $("#ajx").html(msg);
                                    location.reload(true);

                                }
                            });
                        },
                        "Cancelar" : function () {
                            $(this).dialog("close");
                        }
                    }
                });

                function submitForm() {
                    var $form = $("#frmCatalogo");
                    var $btn = $("#dlgCreateEdit").find("#btnSave");
                    if ($form.valid()) {
                        $btn.replaceWith(spinner);
                        openLoader("Guardando Catálogo");
                        $.ajax({
                            type    : "POST",
                            url     : $form.attr("action"),
                            data    : $form.serialize(),
                            success : function (msg) {
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

                function createEditRow(id) {
                    var title = id ? "Editar" : "Crear";
                    var data = id ? {id : id} : {};
                    $.ajax({
                        type    : "POST",
                        url     : "${createLink(action:'form_ajax')}",
                        data    : data,
                        success : function (msg) {
                            var b = bootbox.dialog({
                                id    : "dlgCreateEdit",
                                title : title + " Catálogo",

                                message : msg,
                                buttons : {
                                    cancelar : {
                                        label     : "Cancelar",
                                        className : "btn-primary",
                                        callback  : function () {
                                        }
                                    },
                                    guardar  : {
                                        id        : "btnSave",
                                        label     : "<i class='fa fa-save'></i> Guardar",
                                        className : "btn-success",
                                        callback  : function () {
                                            return submitForm();
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

                function deleteRow(itemId) {
                    bootbox.dialog({
                        title   : "Alerta",
                        message : "<i class='fa fa-trash-o fa-3x pull-left text-danger text-shadow'></i><p>" +
                                "¿Está seguro que desea eliminar el Catalogo seleccionado? Esta acción no se puede deshacer.</p>",
                        buttons : {
                            cancelar : {
                                label     : "Cancelar",
                                className : "btn-primary",
                                callback  : function () {
                                }
                            },
                            eliminar : {
                                label     : "<i class='fa fa-trash-o'></i> Eliminar",
                                className : "btn-danger",
                                callback  : function () {
                                    openLoader("Eliminando Catálogo");
                                    $.ajax({
                                        type    : "POST",
                                        url     : '${createLink(action:'delete_ajax')}',
                                        data    : {
                                            id : itemId
                                        },
                                        success : function (msg) {
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

            });

        </script>

    </body>
</html>