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

        <style type="text/css">
        #tree {
            overflow-y: auto;
            height: 440px;
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
                            url  : '${createLink(action:"loadTreePart")}',
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
                        root           : {
                            icon: "fa fa-folder text-warning"
                        },
                        padreActivo    : {
                            icon: "fa fa-building-o text-info"
                        },
                        padreInactivo  : {
                            icon: "fa fa-building-o text-muted"
                        },
                        hijoActivo     : {
                            icon: "fa fa-home text-success"
                        },
                        hijoInactivo   : {
                            icon: "fa fa-home text-muted"
                        },
                        usuarioActivo  : {
                            icon: "fa fa-user text-info"
                        },
                        usuarioInactivo: {
                            icon: "fa fa-user text-muted"
                        }
                    }
                });
            });
        </script>

    </body>
</html>