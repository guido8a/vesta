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
        <title>Estructura institucional</title>

        <script src="${resource(dir: 'js/plugins/jstree-3.0.8/dist', file: 'jstree.min.js')}"></script>
        <link href="${resource(dir: 'js/plugins/jstree-3.0.8/dist/themes/default', file: 'style.min.css')}" rel="stylesheet">
        <link href="${resource(dir: 'css/custom', file: 'jstree-context.css')}" rel="stylesheet">

        <style type="text/css">
        #tree {
            overflow-y : auto;
            height     : 440px;
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
                <div class="input-group">
                    <input type="text" class="form-control input-sm" placeholder="Buscador">
                    <span class="input-group-btn">
                        <a href="#" class="btn btn-sm btn-success" type="button"><i class="fa fa-search"></i></a>
                    </span>
                </div><!-- /input-group -->
            </div>
        </div>

        <div id="tree" class="well hide">

        </div>

        <script type="text/javascript">
            function createContextMenu(node) {
                var nodeStrId = node.id;
                var $node = $("#" + nodeStrId);
                var nodeId = nodeStrId.split("_")[1];
                var nodeType = $node.data("jstree").type;
                var nodeUsu = $node.data("usuario");

                var esRoot = nodeType == "root";
                var esYachay = nodeType == "yachay";
                var esUnidad = nodeType.contains("unidad");
                var esUsuario = nodeType.contains("usuario");

                var items = {};

                var agregarEntidad = {
                    label : "Agregar entidad",
                    icon  : "fa fa-home text-success",
                    action: function () {
                    }
                };
                var docsEntidad = {
                    label          : "Documentos entidad",
                    icon           : "fa fa-files-o",
                    separator_after: true,
                    action         : function () {

                    }
                };
                var agregarUsu = {
                    label          : "Agregar usuario",
                    icon           : "fa fa-user text-success",
                    separator_after: true,
                    action         : function () {

                    }
                };
                var responsablesUnidad = {
                    label : "Responsables",
                    icon  : "fa fa-users text-info",
                    action: function () {

                    }
                };
                var verEntidad = {
                    label           : "Ver datos de la entidad",
                    icon            : "fa fa-laptop text-info",
                    separator_before: true,
                    action          : function () {
                        $.ajax({
                            type   : "POST",
                            url    : "${createLink(controller: "unidadEjecutora", action:'show_ajax')}",
                            data   : {
                                id: nodeId
                            },
                            success: function (msg) {
                                bootbox.dialog({
                                    title  : "Ver Entidad",
                                    message: msg,
                                    buttons: {
                                        ok: {
                                            label    : "Aceptar",
                                            className: "btn-primary",
                                            callback : function () {
                                            }
                                        }
                                    }
                                });
                            }
                        });
                    }
                };
                var editarEntidad = {
                    label : "Editar datos de la entidad",
                    icon  : "fa fa-pencil text-info",
                    action: function () {

                    }
                };
                var presupuestoEntidad = {
                    label           : "Presupuesto entidad",
                    icon            : "fa fa-money",
                    separator_before: true,
                    action          : function () {

                    }
                };
                var modificarPresupuesto = {
                    label : "Modificar presupuesto",
                    icon  : "fa fa-calculator",
                    action: function () {

                    }
                };

                var verUsuario = {
                    label           : "Ver datos del usuario",
                    icon            : "fa fa-laptop text-info",
                    separator_before: true,
                    action          : function () {
                        $.ajax({
                            type   : "POST",
                            url    : "${createLink(controller: "persona", action:'show_ajax')}",
                            data   : {
                                id: nodeId
                            },
                            success: function (msg) {
                                bootbox.dialog({
                                    title  : "Ver Usuario",
                                    message: msg,
                                    buttons: {
                                        ok: {
                                            label    : "Aceptar",
                                            className: "btn-primary",
                                            callback : function () {
                                            }
                                        }
                                    }
                                });
                            }
                        });
                    }
                };
                var editarUsuario = {
                    label           : "Editar datos del usuario",
                    icon            : "fa fa-pencil text-info",
                    separator_before: true,
                    action          : function () {

                    }
                };

                if (esRoot) {
                    items.agregarEntidad = agregarEntidad;
                } else if (esYachay) {
                    items.agregarEntidad = agregarEntidad;
                    items.presupuestoEntidad = presupuestoEntidad;
                    items.modificarPresupuesto = modificarPresupuesto;
                    items.documentos = docsEntidad;
                    items.agregarUsuario = agregarUsu;
                    items.ver = verEntidad;
                    items.editar = editarEntidad;
                } else if (esUnidad) {
                    items.agregarEntidad = agregarEntidad;
                    items.documentos = docsEntidad;
                    items.agregarUsuario = agregarUsu;
                    items.responsables = responsablesUnidad;
                    items.ver = verEntidad;
                    items.editar = editarEntidad;
                } else if (esUsuario) {
                    items.ver = verUsuario;
                    items.editar = editarUsuario;
                }
                return items;
            }

            $(function () {
                $('#tree').on("loaded.jstree", function () {
                    $("#loading").hide();
                    $("#tree").removeClass("hide");
                }).on("select_node.jstree", function (node, selected, event) {
//                    $('#tree').jstree('toggle_node', selected.selected[0]);
                }).jstree({
                    plugins    : ["types", "state", "contextmenu", "search"],
                    core       : {
                        multiple      : false,
                        check_callback: true,
                        themes        : {
                            variant: "small",
                            dots   : true,
                            stripes: true
                        },
                        data          : {
                            async: false,
                            url  : '${createLink(action:"loadTreePart_ajax")}',
                            data : function (node) {
                                return {
                                    id   : node.id,
                                    sort : "${params.sort?:'apellido'}",
                                    order: "${params.order?:'asc'}"
                                };
                            }
                        }
                    },
                    contextmenu: {
                        show_at_node: false,
                        items       : createContextMenu
                    },
                    state      : {
                        key: "unidades"
                    },
                    search     : {
                        fuzzy            : false,
                        show_only_matches: true,
                        ajax             : {
                            url    : "${createLink(action:'arbolSearch_ajax')}",
                            success: function (msg) {
                                var json = $.parseJSON(msg);
                                $.each(json, function (i, obj) {
                                    $('#tree').jstree("open_node", obj);
                                });
                            }
                        }
                    },
                    types      : {
                        root               : {
                            icon: "fa fa-folder text-warning"
                        },
                        yachay             : {
                            icon: "fa fa-building text-info"
                        },
                        unidadPadreActivo  : {
                            icon: "fa fa-building-o text-info"
                        },
                        unidadPadreInactivo: {
                            icon: "fa fa-building-o text-muted"
                        },
                        unidadHijoActivo   : {
                            icon: "fa fa-home text-success"
                        },
                        unidadHijoInactivo : {
                            icon: "fa fa-home text-muted"
                        },
                        usuarioActivo      : {
                            icon: "fa fa-user text-info"
                        },
                        usuarioInactivo    : {
                            icon: "fa fa-user text-muted"
                        }
                    }
                });
            });
        </script>

    </body>
</html>