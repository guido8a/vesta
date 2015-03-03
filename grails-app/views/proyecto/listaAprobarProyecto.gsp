<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 23/01/15
  Time: 12:33 PM
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <meta name="layout" content="main">
        <title>Aprobar proyecto</title>
    </head>

    <body>

        <!-- botones -->

        <div class="btn-toolbar toolbar bg-info corner-all " style="padding: 5px">

            <div class="btn-group col-md-2 noPadding">
                <input type="text" class="form-control input-sm buscar" id="search_nombre" placeholder="Nombre" value="${params.search_nombre}">
            </div><!-- /input-group -->

            <div class="btn-group">
                <g:link controller="proyecto" action="listaAprobarProyecto" class="btn btn-sm btn-default btnSearch">
                    <i class="fa fa-search"></i> Buscar
                </g:link>
                <g:link controller="proyecto" action="listaAprobarProyecto" class="btn btn-sm btn-default">
                    <i class="fa fa-close"></i> Borrar búsqueda
                </g:link>
            </div><!-- /input-group -->
        </div>

        <table class="table table-bordered table-condensed table-hover table-striped">
            <thead>
                <tr>
                    <g:sortableColumn property="nombre" title="Nombre"/>
                    <g:sortableColumn property="codigoProyecto" title="Código"/>
                    <g:sortableColumn property="monto" title="Monto"/>
                    <g:sortableColumn property="estado" title="Estado"/>
                    <g:sortableColumn property="aprobado" title="Aprobado"/>

                </tr>
            </thead>
            <tbody>
                <g:if test="${proyectoInstanceCount > 0}">
                    <g:each in="${proyectoInstanceList}" status="i" var="proyectoInstance">
                        <tr data-aprobado="${proyectoInstance.aprobado}" data-id="${proyectoInstance.id}">
                            <td>
                                <elm:textoBusqueda busca="${params.search_nombre}">
                                    ${proyectoInstance.nombre}
                                </elm:textoBusqueda>
                            </td>
                            <td>
                                ${proyectoInstance.codigoProyecto}
                            </td>
                            <td class="text-right">
                                <g:formatNumber number="${proyectoInstance.monto.toDouble()}" type="currency" currencySymbol=" "/>
                            </td>
                            <td>
                                ${proyectoInstance.estadoProyecto}
                            </td>
                            <td>
                                ${proyectoInstance.aprobado == "a" ? "Aprobado" : "No aprobado"}
                            </td>
                        </tr>
                    </g:each>
                </g:if>
                <g:else>
                    <tr class="danger">
                        <td class="text-center" colspan="38">
                            <g:if test="${params.search && params.search != ''}">
                                No se encontraron resultados para su búsqueda
                            </g:if>
                            <g:else>
                                No se encontraron registros que mostrar
                            </g:else>
                        </td>
                    </tr>
                </g:else>
            </tbody>
        </table>

        <elm:pagination total="${proyectoInstanceCount}" params="${params}"/>

        <script type="text/javascript">

            function armaParams() {
                var params = "";
                if ("${params.search_nombre}" != "") {
                    if (params != "") {
                        params += "&";
                    }
                    params += "search_nombre=${params.search_nombre}";
                }
//                if (params != "") {
//                    params = "?" + params;
//                }
                var returnParams = "?list=listaAprobarProyecto";
                if (params != "") {
                    returnParams += "&" + params;
                }
                return returnParams;
                return params;
            }

            function buscar() {
                var $btn = $(".btnSearch");
                var str = "";
                var desde = $.trim($("#search_desde").val());
                var hasta = $.trim($("#search_hasta").val());
                var nombre = $.trim($("#search_nombre").val());
                var programa = $.trim($("#search_programa").val());

                if (desde != "") {
                    str += "search_desde=" + desde;
                }
                if (hasta != "") {
                    if (str != "") {
                        str += "&";
                    }
                    str += "search_hasta=" + hasta;
                }
                if (nombre != "") {
                    if (str != "") {
                        str += "&";
                    }
                    str += "search_nombre=" + nombre;
                }
                if (programa != "") {
                    if (str != "") {
                        str += "&";
                    }
                    str += "search_programa=" + programa;
                }

                var url = $btn.attr("href") + "?" + str;
                if (str == "") {
                    url = $btn.attr("href");
                }
                location.href = url;
            }

            function createContextMenu(node) {
                var $tr = $(node);

                var aprobado = $tr.data("aprobado");

                var items = {
                    header      : {
                        label  : "Acciones",
                        header : true
                    },
                    ver         : {
                        label  : "Ver",
                        icon   : "fa fa-search",
                        action : function ($element) {
                            var id = $element.data("id");
                            $.ajax({
                                type    : "POST",
                                url     : "${createLink(action:'show_ajax')}",
                                data    : {
                                    id : id
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
                    },
                    marcoLogico : {
                        label  : "Marco lógico",
                        icon   : "fa fa-calendar-o",
                        action : function ($element) {
                            var id = $element.data("id");
                            var win = window.open("${createLink(controller:'marcoLogico', action:'marcoLogicoProyecto')}/" + id + armaParams(), '_blank');
                            win.focus();
                            %{--location.href = "${createLink(controller:'marcoLogico', action:'marcoLogicoProyecto')}/" + id + armaParams();--}%
                        }
                    },
                    cronograma  : {
                        label  : "Cronograma",
                        icon   : "fa fa-calendar",
                        action : function ($element) {
                            var id = $element.data("id");
                            var win = window.open("${createLink(controller: 'cronograma', action:'show')}/" + id + armaParams(), '_blank');
                            win.focus();
                            %{--location.href = "${createLink(controller: 'cronograma', action:'show')}/" + id + armaParams();--}%
                        }
                    }
                };

                if (aprobado != "a") {
                    items.aprobar = {
                        label            : "<span class='text-success'>Aprobar</span>",
                        icon             : "fa fa-check text-success",
                        separator_before : true,
                        action           : function ($element) {
                            var id = $element.data("id");

                            var msg = "<div class='row'>";
                            msg += "<div class='col-md-12'>Ingrese su clave de aprobación</div>";
                            msg += '</div>';
                            msg += "<div class='row'>";
                            msg += "<div class='col-md-9'>";
                            msg += '<div class="input-group">';
                            msg += "<input type='password' id='txtAuth' class='form-control input-sm' />";
                            msg += '<span class="input-group-addon"><i class="fa fa-unlock"></i></span>';
                            msg += '</div>';
                            msg += "</div>";
                            msg += '</div>';

                            var submitAuth = function () {
                                openLoader("Procesando autorización");
                                $.ajax({
                                    type    : "POST",
                                    url     : "${createLink(action:'aprobarProyecto_ajax')}",
                                    data    : {
                                        auth : $("#txtAuth").val(),
                                        proy : id
                                    },
                                    success : function (msg) {
                                        var parts = msg.split("*");
                                        log(parts[1], parts[0] == "SUCCESS" ? "success" : "error"); // log(msg, type, title, hide)
                                        setTimeout(function () {
                                            if (parts[0] == "SUCCESS") {
                                                b.modal("hide");
                                                location.reload(true);
                                            } else {
                                                closeLoader();
                                                return false;
                                            }
                                        }, 1000);
                                    },
                                    error   : function () {
                                        log("Ha ocurrido un error interno", "error");
                                    }
                                });
                            };

                            var b = bootbox.dialog({
                                title   : "Aprobar Proyecto",
                                message : msg,
                                class   : "modal-sm",
                                buttons : {
                                    cancelar : {
                                        label     : "Cancelar",
                                        className : "btn-primary",
                                        callback  : function () {
                                        }
                                    },
                                    success  : {
                                        label     : "<i class='fa fa-check'></i> Aprobar",
                                        className : "btn-success",
                                        callback  : function () {
                                            submitAuth();
                                        }
                                    }
                                }
                            });
                            setTimeout(function () {
                                b.find(".form-control").first().focus();
                                $("#txtAuth").keyup(function (ev) {
                                    if (ev.keyCode == 13) {
                                        submitAuth();
                                    }
                                });
                            }, 500);
                        }
                    }
                }

                return items
            }

            $(function () {
                $("#btn_buscar").click(function () {
                    var $div = $("#divBuscar");
                    if ($div.is(":visible")) {
                        $div.addClass("hide");
                        $(this).html(' <i class="fa fa-search-plus"></i> Mostrar opciones de búsqueda');
                    } else {
                        $div.removeClass("hide");
                        $(this).html(' <i class="fa fa-search-minus"></i> Ocultar opciones de búsqueda');
                    }
                });

                $(".btnSearch").click(function () {
                    buscar();
                });
                $(".buscar").keyup(function (ev) {
                    if (ev.keyCode == 13) {
                        buscar();
                    }
                });

                $("tbody>tr").contextMenu({
                    items  : createContextMenu,
                    onShow : function ($element) {
                        $element.addClass("success");
                    },
                    onHide : function ($element) {
                        $(".success").removeClass("success");
                    }
                });
            });
        </script>

    </body>
</html>