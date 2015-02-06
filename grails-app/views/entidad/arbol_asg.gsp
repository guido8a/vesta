<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 24/12/14
  Time: 12:07 PM
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <meta name="layout" content="main">
        <title>Asignaciones</title>

        <script src="${resource(dir: 'js/plugins/jstree-3.0.8/dist', file: 'jstree.min.js')}"></script>
        <link href="${resource(dir: 'js/plugins/jstree-3.0.8/dist/themes/default', file: 'style.min.css')}" rel="stylesheet">
        <link href="${resource(dir: 'css/custom', file: 'jstree-context.css')}" rel="stylesheet">

        <style type="text/css">
        #tree {
            overflow-y : auto;
            height     : 440px;
        }

        .jstree-search {
            color : #5F87B2 !important;
        }
        </style>

    </head>

    <body>

        <div id="loading" class="text-center">
            <p>
                Cargando los departamentos
            </p>

            <p>
                <img src="${resource(dir: 'images/spinners', file: 'spinner_64.GIF')}" alt='Cargando...'/>
            </p>

            <p>
                Por favor espere
            </p>
        </div>

        <div class="row" style="margin-bottom: 10px;">
            <div class="col-md-2">
                <div class="input-group input-group-sm">
                    <g:textField name="searchArbol" class="form-control input-sm" placeholder="Buscador"/>
                    <span class="input-group-btn">
                        <a href="#" id="btnSearchArbol" class="btn btn-sm btn-info">
                            <i class="fa fa-search"></i>&nbsp;
                        </a>
                    </span>
                </div><!-- /input-group -->
            </div>

            <div class="col-md-3 hidden" id="divSearchRes">
                <span id="spanSearchRes">
                    5 resultados
                </span>

                <div class="btn-group">
                    <a href="#" class="btn btn-xs btn-default" id="btnNextSearch" title="Siguiente">
                        <i class="fa fa-chevron-down"></i>&nbsp;
                    </a>
                    <a href="#" class="btn btn-xs btn-default" id="btnPrevSearch" title="Anterior">
                        <i class="fa fa-chevron-up"></i>&nbsp;
                    </a>
                    <a href="#" class="btn btn-xs btn-default" id="btnClearSearch" title="Limpiar búsqueda">
                        <i class="fa fa-close"></i>&nbsp;
                    </a>
                </div>
            </div>

            <div class="col-md-1">
                <div class="btn-group">
                    <a href="#" class="btn btn-xs btn-default" id="btnCollapseAll" title="Cerrar todos los nodos">
                        <i class="fa fa-minus-square-o"></i>&nbsp;
                    </a>
                    <a href="#" class="btn btn-xs btn-default" id="btnExpandAll" title="Abrir todos los nodos">
                        <i class="fa fa-plus-square"></i>&nbsp;
                    </a>
                </div>
            </div>
        </div>

        <div id="tree" class="well hidden">

        </div>

        <script type="text/javascript">
            var searchRes = [];
            var posSearchShow = 0;
            var $treeContainer = $("#tree");

            function submitFormUnidad() {
                var $form = $("#frmUnidadEjecutora");
                var $btn = $("#dlgCreateEdit").find("#btnSave");
                if ($form.valid()) {
                    $btn.replaceWith(spinner);
                    openLoader("Guardando Entidad");
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

            function createEditUnidad(id, parentId) {
                var title = id ? "Editar" : "Crear";
                var data = id ? {id : id} : {};
                if (parentId) {
                    data.padre = parentId;
                }
                $.ajax({
                    type    : "POST",
                    url     : "${createLink(controller: 'unidadEjecutora', action:'form_ajax')}",
                    data    : data,
                    success : function (msg) {
                        var b = bootbox.dialog({
                            id    : "dlgCreateEdit",
                            title : title + " Entidad",

                            class : "modal-lg",

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
                                        return submitFormUnidad();
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

            function submitFormPersona() {
                var $form = $("#frmPersona");
                var $btn = $("#dlgCreateEdit").find("#btnSave");
                if ($form.valid()) {
                    var data = $form.serialize();
                    data += "&perfiles=";
                    $(".perfiles").each(function () {
                        data += $(this).data("id") + "_";
                    });
                    $btn.replaceWith(spinner);
                    openLoader("Guardando Persona");
                    $.ajax({
                        type    : "POST",
                        url     : $form.attr("action"),
                        data    : data,
                        success : function (msg) {
                            var parts = msg.split("*");
                            log(parts[1], parts[0] == "SUCCESS" ? "success" : "error"); // log(msg, type, title, hide)
                            setTimeout(function () {
                                if (parts[0] == "SUCCESS") {
                                    location.reload(true);
                                } else {
                                    closeLoader();
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
            function createEditPersona(id, unidadId) {
                var title = id ? "Editar" : "Crear";
                var data = id ? {id : id} : {};
                if (unidadId) {
                    data.unidad = unidadId;
                }
                $.ajax({
                    type    : "POST",
                    url     : "${createLink(controller: 'persona', action:'form_ajax')}",
                    data    : data,
                    success : function (msg) {
                        var b = bootbox.dialog({
                            id    : "dlgCreateEdit",
                            title : title + " Persona",

                            class : "modal-lg",

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
                                        return submitFormPersona();
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
            function cambiarPassPersona(id, tipo) {
                var title = "";
                var $alert = $("<div class='alert alert-info'>");

                var submitFormPass = function () {
                    if ($form.valid()) {
                        openLoader("Guardando");
                        $.ajax({
                            type    : "POST",
                            url     : '${createLink(controller: 'persona', action:'savePass_ajax')}',
                            data    : {
                                id     : id,
                                tipo   : tipo,
                                input1 : set1.input.val(),
                                input2 : set2.input.val(),
                                input3 : set3.input.val()
                            },
                            success : function (msg) {
                                var parts = msg.split("*");
                                log(parts[1], parts[0] == "SUCCESS" ? "success" : "error"); // log(msg, type, title, hide)
                                closeLoader();
                            }
                        });
                    } else {
                        return false;
                    }
                };

                var createInput = function (num) {
                    var $grupo = $("<div class='grupo'>");
                    var $inputGroup = $("<div class='input-group input-group-sm'>");
                    var $input = $("<input type='password' id='input" + num + "' name='input" + num + "' class='form-control input-sm required'>");
                    $input.keyup(function (ev) {
                        if (ev.keyCode == 13) {
                            submitFormPass();
                        }
                    });
                    var $span = $("<span class='input-group-addon'>");
                    if (tipo == "pass") {
                        $span.html("<i class='fa fa-unlock'></i> ");
                    } else if (tipo == "auth") {
                        $span.html("<i class='fa fa-unlock-alt'></i> ");
                    }
                    var $row = $("<div class='row'>");
                    var $cell1 = $("<div class='col-md-4'>");
                    var $cell2 = $("<div class='col-md-6'>");
                    $inputGroup.append($input);
                    $inputGroup.append($span);
                    $grupo.append($inputGroup);
                    $cell2.append($grupo);
                    $row.append($cell1);
                    $row.append($cell2);
                    return {input : $input, row : $row, cell : $cell1};
                };

                var set1 = createInput(1);
                var set2 = createInput(2);
                var set3 = createInput(3);

                var $form = $("<form>");
                $form.attr("id", "frmPass");
                var strEqualTo = "";

                if (tipo == "pass") {
                    $alert.text("Ingrese la nueva contraseña del usuario");
                    title = "Cambio de contraseña del usuario";
                    set2.cell.text("Contraseña nueva");
                    set3.cell.text("Verifique la contraseña");
                    $form.append(set2.row).append(set3.row);
                    strEqualTo = "Repita la nueva contraseña";
                } else if (tipo == "auth") {
                    $alert.text("Ingrese su autorización actual y la nueva");
                    title = "Cambio de autorización del usuario";
                    set1.cell.text("Autorización actual");
                    set2.cell.text("Autorización nueva");
                    set3.cell.text("Verifique la autorización");
                    $form.append(set1.row).append(set2.row).append(set3.row);
                    strEqualTo = "Repita su nueva autorización";
                }

                $form.prepend($alert);

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
                    },
                    rules          : {
                        input1 : {
                            remote : {
                                url  : "${createLink(controller:'persona',action: 'validar_aut_previa_ajax')}",
                                type : "post",
                                data : {
                                    id : id
                                }
                            }
                        },
                        input2 : {
                            notEqualTo : "#input1"
                        },
                        input3 : {
                            equalTo : "#input2"
                        }
                    },
                    messages       : {
                        input1 : {
                            remote : "La autorización no concuerda con la ingresada"
                        },
                        input2 : {
                            notEqualTo : "No ingrese su autorización actual"
                        },
                        input3 : {
                            equalTo : strEqualTo
                        }
                    }
                });

                var b = bootbox.dialog({
                    title   : title,
                    message : $form,
                    buttons : {
                        cancelar : {
                            label     : "Cancelar",
                            className : "btn-primary",
                            callback  : function () {
                            }
                        },
                        guardar  : {
                            label     : "<i class='fa fa-save'></i> Guardar",
                            className : "btn-success",
                            callback  : function () {
                                submitFormPass();
                            }
                        }
                    }
                });
                setTimeout(function () {
                    b.find(".form-control").first().focus()
                }, 500);
            }

            function createContextMenu(node) {
                var nodeStrId = node.id;
                var $node = $("#" + nodeStrId);
                var nodeId = nodeStrId.split("_")[1];
                var nodeType = $node.data("jstree").type;

                var nodeText = $node.children("a").first().text();

//                var $parent = $node.parent().parent();
//                var parentStrId = $parent.attr("id");
//                var parentId = parentStrId.split("_")[1];
//                var tienePadre = parentId !== undefined;

                var esRoot = nodeType == "root";
                var esYachay = nodeType == "yachay";
                var esProyecto = nodeType.contains("proy");

                var items = {};

                var inversiones = {
                    label            : "Asignación de inversiones",
                    icon             : "fa fa-money text-success",
                    separator_before : true,
                    action           : function () {
                        location.href = "${createLink(controller: 'asignacion', action: 'asignacionProyectov2')}/" + nodeId;
                    }
                };

                var pac = {
                    label            : "Plan Anual de Compras",
                    icon             : "fa fa-shopping-cart text-info",
                    separator_before : true,
                    action           : function () {

                    }
                };
                var verProyecto = {
                    label  : "Ver",
                    icon   : "fa fa-search",
                    action : function () {
                        $.ajax({
                            type    : "POST",
                            url     : "${createLink(controller: 'proyecto', action:'show_ajax')}",
                            data    : {
                                id : nodeId
                            },
                            success : function (msg) {
                                bootbox.dialog({
                                    title   : "Ver Proyecto",
                                    class   : "modal-lg",
                                    message : msg,
                                    buttons : {
                                        ok : {
                                            label     : "Aceptar",
                                            className : "btn-primary",
                                            callback  : function () {
                                            }
                                        }
                                    }
                                });
                            }
                        });
                    }
                };

                if (esRoot) {
//                    items.agregarEntidad = agregarEntidad;
                } else if (esYachay) {

                } else if (esProyecto) {
                    items.ver = verProyecto;
                    items.inversiones = inversiones;
                    items.pac = pac;
                }
                return items;
            }

            function scrollToNode($scrollTo) {
                $treeContainer.jstree("deselect_all").jstree("select_node", $scrollTo).animate({
                    scrollTop : $scrollTo.offset().top - $treeContainer.offset().top + $treeContainer.scrollTop() - 50
                });
            }

            function scrollToRoot() {
                var $scrollTo = $("#root");
                scrollToNode($scrollTo);
            }

            function scrollToSearchRes() {
                var $scrollTo = $(searchRes[posSearchShow]).parents("li").first();
                $("#spanSearchRes").text("Resultado " + (posSearchShow + 1) + " de " + searchRes.length);
                scrollToNode($scrollTo);
            }

            $(function () {

                $treeContainer.on("loaded.jstree", function () {
                    $("#loading").hide();
                    $("#tree").removeClass("hidden");
                }).on("select_node.jstree", function (node, selected, event) {
//                    $('#tree').jstree('toggle_node', selected.selected[0]);
                }).jstree({
                    plugins     : ["types", "state", "contextmenu", "search"],
                    core        : {
                        multiple       : false,
                        check_callback : true,
                        themes         : {
                            variant : "small",
                            dots    : true,
                            stripes : true
                        },
                        data           : {
                            async : false,
                            url   : '${createLink(action:"loadTreeProyPart_ajax")}',
                            data  : function (node) {
                                return {
                                    id    : node.id,
                                    sort  : "${params.sort?:'apellido'}",
                                    order : "${params.order?:'asc'}"
                                };
                            }
                        }
                    },
                    contextmenu : {
                        show_at_node : false,
                        items        : createContextMenu
                    },
                    state       : {
                        key : "unidades"
                    },
                    search      : {
                        fuzzy             : false,
                        show_only_matches : false,
                        ajax              : {
                            url     : "${createLink(action:'arbolSearchProy_ajax')}",
                            success : function (msg) {
                                var json = $.parseJSON(msg);
                                $.each(json, function (i, obj) {
                                    $('#tree').jstree("open_node", obj);
                                });
                                setTimeout(function () {
                                    searchRes = $(".jstree-search");
                                    var cantRes = searchRes.length;
                                    posSearchShow = 0;
                                    $("#divSearchRes").removeClass("hidden");
                                    $("#spanSearchRes").text("Resultado " + (posSearchShow + 1) + " de " + cantRes);
                                    scrollToSearchRes();
                                }, 300);

                            }
                        }
                    },
                    types       : {
                        root   : {
                            icon : "fa fa-folder text-warning"
                        },
                        yachay : {
                            icon : "fa fa-building text-info"
                        },
                        proy   : {
                            icon : "fa fa-clipboard text-success"
                        }
                    }
                });

                $("#btnExpandAll").click(function () {
                    $treeContainer.jstree("open_all");
                    scrollToRoot();
                    return false;
                });

                $("#btnCollapseAll").click(function () {
                    $treeContainer.jstree("close_all");
                    scrollToRoot();
                    return false;
                });

                $('#btnSearchArbol').click(function () {
                    $treeContainer.jstree(true).search($.trim($("#searchArbol").val()));
                    return false;
                });
                $("#searchArbol").keypress(function (ev) {
                    if (ev.keyCode == 13) {
                        $treeContainer.jstree(true).search($.trim($("#searchArbol").val()));
                        return false;
                    }
                });

                $("#btnPrevSearch").click(function () {
                    if (posSearchShow > 0) {
                        posSearchShow--;
                    } else {
                        posSearchShow = searchRes.length - 1;
                    }
                    scrollToSearchRes();
                    return false;
                });

                $("#btnNextSearch").click(function () {
                    if (posSearchShow < searchRes.length - 1) {
                        posSearchShow++;
                    } else {
                        posSearchShow = 0;
                    }
                    scrollToSearchRes();
                    return false;
                });

                $("#btnClearSearch").click(function () {
                    $treeContainer.jstree("clear_search");
                    $("#searchArbol").val("");
                    posSearchShow = 0;
                    searchRes = [];
                    scrollToRoot();
                    $("#divSearchRes").addClass("hidden");
                    $("#spanSearchRes").text("");
                });

            });
        </script>

    </body>
</html>