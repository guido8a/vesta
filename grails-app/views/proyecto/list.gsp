<%@ page import="vesta.parametros.poaPac.Anio; vesta.proyectos.Proyecto" %>
<!DOCTYPE html>
<html>
    <head>
        <meta name="layout" content="main">
        <title>Banco de Proyectos</title>
    </head>

    <body>

        <elm:message tipo="${flash.tipo}" clase="${flash.clase}">${flash.message}</elm:message>

        <!-- botones -->
        <div class="btn-toolbar toolbar">
            <div class="btn-group">
                <a href="#" class="btn btn-sm btn-default btnCrear">
                    <i class="fa fa-file-o"></i> Nuevo proyecto
                </a>
            </div>

            <div class="btn-group">
                <g:link class=" btn btn-sm btn-success excel " action="cargarExcel">
                    <i class="fa fa-file-excel-o"></i>
                    Cargar Excel
                </g:link>

                <a class="btn btn-sm btn-success" id="reporte">
                    <i class="fa fa-print"></i>
                    Reporte de Total de Priorización
                </a>
                <g:link controller="reportesNuevos" action="reporteProyectosGUI" class="btn btn-sm btn-success">
                    <i class="fa fa-print"></i>
                    Reporte de Total de Priorización Por Fuente
                </g:link>
            </div>

            <div class="btn-group">
                <a class="btn btn-sm btn-default" id="btn_buscar">
                    <g:if test="${params.search_programa || params.search_nombre || params.search_desde || params.search_hasta}">
                        <i class="fa fa-search-minus"></i>
                        Ocultar opciones de búsqueda
                    </g:if>
                    <g:else>
                        <i class="fa fa-search-plus"></i>
                        Mostrar opciones de búsqueda
                    </g:else>
                </a>
            </div>
        </div>

        <div class="btn-toolbar toolbar bg-info corner-all ${params.search_programa || params.search_nombre || params.search_desde || params.search_hasta ? '' : 'hide'}"
             id="divBuscar" style="padding: 5px">
            <div class="btn-group col-md-2 noPadding">
                <div class="input-group input-group-sm">
                    <input type="text" class="form-control input-sm number money buscar" id="search_desde" placeholder="Desde" value="${params.search_desde}">
                    <span class="input-group-addon">
                        <i class="fa fa-usd"></i>
                    </span>
                </div><!-- /input-group -->
            </div>

            <div class="btn-group col-md-2 noPadding">
                <div class="input-group input-group-sm">
                    <input type="text" class="form-control input-sm number money buscar" id="search_hasta" placeholder="Hasta" value="${params.search_hasta}">
                    <span class="input-group-addon">
                        <i class="fa fa-usd"></i>
                    </span>
                </div><!-- /input-group -->
            </div>

            <div class="btn-group col-md-2 noPadding">
                <input type="text" class="form-control input-sm buscar" id="search_nombre" placeholder="Nombre" value="${params.search_nombre}">
            </div><!-- /input-group -->

            <div class="btn-group  col-md-2 noPadding">
                <input type="text" class="form-control input-sm buscar" id="search_programa" placeholder="Programa" value="${params.search_programa}">
            </div><!-- /input-group -->

            <div class="btn-group">
                <g:link controller="proyecto" action="list" class="btn btn-sm btn-default btnSearch">
                    <i class="fa fa-search"></i> Buscar
                </g:link>
                <g:link controller="proyecto" action="list" class="btn btn-sm btn-default">
                    <i class="fa fa-close"></i> Borrar búsqueda
                </g:link>
            </div><!-- /input-group -->
        </div>

        <div style="width: 1200px; overflow: auto">
            <table class="table table-condensed table-bordered table-striped table-hover" style="width: auto;">
                <thead>
                    <tr>
                        <g:sortableColumn property="codigo" title="Código"/>
                        <g:sortableColumn property="nombre" title="Proyecto"/>
                        <g:sortableColumn property="unidadAdministradora" title="Unidad Administradora"/>
                        <g:sortableColumn property="monto" title="Monto Total (USD)"/>
                        <th>Descripción</th>
                        <th>Programa</th>
                        <g:each in="${anios}" var="anio">
                            <th>${anio.anio}</th>
                        </g:each>
                        <th>Total Planificado</th>
                        <th>Total Priorizado</th>
                    </tr>
                </thead>
                <tbody>
                    <g:if test="${proyectoInstanceCount > 0}">
                        <g:each in="${proyectoInstanceList}" status="i" var="proyectoInstance">
                            <tr data-id="${proyectoInstance.id}" data-nombre="${proyectoInstance.nombre}">

                                <td>
                                    <g:fieldValue bean="${proyectoInstance}" field="codigo"/>
                                </td>

                                <td>
                                    <elm:textoBusqueda busca="${params.search_nombre}">
                                        <g:fieldValue bean="${proyectoInstance}" field="nombre"/>
                                    </elm:textoBusqueda>
                                </td>
                                <td>
                                    ${proyectoInstance.unidadAdministradora}
                                </td>

                                <td class="text-right">
                                    <g:formatNumber number="${proyectoInstance.monto}" type="currency" currencySymbol=""/>
                                </td>

                                <td>
                                    ${proyectoInstance?.descripcion?.size() > 70 ? proyectoInstance?.descripcion?.toString()[0..70] + "..." : proyectoInstance?.descripcion}
                                </td>

                                <td>
                                    <elm:textoBusqueda busca="${params.search_programa}">
                                        ${proyectoInstance?.programa?.descripcion?.size() > 50 ? proyectoInstance?.programa?.descripcion?.toString()[0..50] + "..." : proyectoInstance?.programa?.descripcion}
                                    %{--<g:fieldValue bean="${proyectoInstance}" field="programa"/>--}%
                                    </elm:textoBusqueda>
                                </td>

                                <g:each in="${anios}" var="anio">
                                    <td>
                                        <g:formatNumber number="${proyectoInstance.getValorPlanificadoAnio(anio)}" type="currency" currencySymbol=""/>
                                    </td>
                                </g:each>

                                <td class="text-right">
                                    <g:formatNumber number="${proyectoInstance.valorPlanificado}" type="currency" currencySymbol=""/>
                                </td>

                                <td class="text-right">
                                    <g:formatNumber number="${proyectoInstance.valorPriorizado}" type="currency" currencySymbol=""/>
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
        </div>
        <elm:pagination total="${proyectoInstanceCount}" params="${params}"/>

        <script type="text/javascript">

            function armaParams() {
                var params = "";
                if ("${params.search_programa}" != "") {
                    params += "search_programa=${params.search_programa}";
                }
                if ("${params.search_nombre}" != "") {
                    if (params != "") {
                        params += "&";
                    }
                    params += "search_nombre=${params.search_nombre}";
                }
                if ("${params.search_desde}" != "") {
                    if (params != "") {
                        params += "&";
                    }
                    params += "search_desde=${params.search_desde}";
                }
                if ("${params.search_hasta}" != "") {
                    if (params != "") {
                        params += "&";
                    }
                    params += "search_hasta=${params.search_hasta}";
                }
//                if (params != "") {
//                    params = "?" + params;
//                }
                var returnParams = "?list=list";
                if (params != "") {
                    returnParams += "&" + params;
                }
                console.log(returnParams);
                return returnParams;
            }

            function submitFormProyecto(id) {
                var $form = $("#frmProyecto");
                var $btn = $("#dlgCreateEdit").find("#btnSave");
                if ($form.valid()) {
                    $btn.replaceWith(spinner);
                    openLoader("Guardando Proyecto");
                    $.ajax({
                        type    : "POST",
                        url     : $form.attr("action"),
                        data    : $form.serialize(),
                        success : function (msg) {
                            var parts = msg.split("*");
                            log(parts[1], parts[0] == "SUCCESS" ? "success" : "error"); // log(msg, type, title, hide)
                            setTimeout(function () {
                                if (parts[0] == "SUCCESS") {
                                    if (id) {
                                        location.reload(true);
                                    } else {
                                        metasProyecto(parts[2], true);
                                    }
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
            function deleteProyecto(itemId) {
                bootbox.dialog({
                    title   : "Alerta",
                    message : "<i class='fa fa-trash-o fa-3x pull-left text-danger text-shadow'></i><p>" +
                              "¿Está seguro que desea eliminar el Proyecto seleccionado? Esta acción no se puede deshacer.</p>",
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
                                openLoader("Eliminando Proyecto");
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
            function createEditProyecto(id, nombre) {
                openLoader();
                var title = id ? "Editar Proyecto" : "Crear Proyecto";
                var data = id ? {id : id} : {};
                if (id && nombre) {
                    title += ": " + nombre;
                }
                $.ajax({
                    type    : "POST",
                    url     : "${createLink(action:'form_ajax')}",
                    data    : data,
                    success : function (msg) {
                        closeLoader();
                        var b = bootbox.dialog({
                            id      : "dlgCreateEdit",
                            title   : title,
                            class   : "modal-lg",
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
                                        return submitFormProyecto(id);
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

            function metasProyecto(id, reload) {
                $.ajax({
                    type    : "POST",
                    url     : "${createLink(controller: 'metaBuenVivirProyecto', action:'list_ajax')}",
                    data    : {
                        id : id
                    },
                    success : function (msg) {
                        bootbox.dialog({
                            title   : "Metas del Plan Nacional de Desarrollo",
                            class   : "modal-lg",
                            message : msg,
                            buttons : {
                                ok : {
                                    label     : "Aceptar",
                                    className : "btn-primary",
                                    callback  : function () {
                                        if (reload) {
                                            location.reload(true);
                                        }
                                    }
                                }
                            }
                        });
                    }
                });
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

            $(function () {
                $("#reporte").click(function () {
                    var url = "${createLink(controller: 'reportes2', action: 'reporteTotalPriorizacion')}";
                    location.href = "${createLink(controller:'pdf',action:'pdfLink')}?url=" + url;
                });
                $(".btnCrear").click(function () {
                    createEditProyecto();
                    return false;
                });

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
                    return false;
                });
                $(".buscar").keyup(function (ev) {
                    if (ev.keyCode == 13) {
                        buscar();
                    }
                });

                $("tbody>tr").contextMenu({
                    items  : {
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
                        editar      : {
                            label  : "Editar",
                            icon   : "fa fa-pencil",
                            action : function ($element) {
                                var id = $element.data("id");
                                createEditProyecto(id, $element.data("nombre"));
                            }
                        },
                        metas       : {
                            label  : "Metas del P.N.D.",
                            icon   : "fa fa-flag-checkered",
                            action : function ($element) {
                                var id = $element.data("id");
                                metasProyecto(id);
                            }
                        },
                        presupuesto : {
                            label            : "Presupuesto/Fuentes",
                            icon             : "fa fa-calculator",
                            separator_before : true,
                            action           : function ($element) {
                                var id = $element.data("id");
                                $.ajax({
                                    type    : "POST",
                                    url     : "${createLink(controller: 'financiamiento', action:'list_ajax')}",
                                    data    : {
                                        id : id
                                    },
                                    success : function (msg) {
                                        bootbox.dialog({
                                            title   : "Presupuesto/Fuentes",
                                            class   : "modal-lg",
                                            message : msg,
                                            buttons : {
                                                ok : {
                                                    label     : "Salir",
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
                        documentos  : {
                            label  : "Documentos",
                            icon   : "fa fa-files-o",
                            action : function ($element) {
                                var id = $element.data("id");
                                $.ajax({
                                    type    : "POST",
                                    url     : "${createLink(controller: 'documento', action:'listProyecto_ajax')}",
                                    data    : {
                                        id : id
                                    },
                                    success : function (msg) {
                                        bootbox.dialog({
                                            title   : "Documentos",
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
                        plan        : {
                            label            : "Plan de proyecto",
                            icon             : "fa fa-calendar-o",
                            separator_before : true,
                            action           : function ($element) {
                                var id = $element.data("id");
                                location.href = "${createLink(controller:'marcoLogico', action:'marcoLogicoProyecto')}/" + id + armaParams();
                            }
                        },
                        cronograma  : {
                            label  : "Cronograma",
                            icon   : "fa fa-calendar",
                            action : function ($element) {
                                var id = $element.data("id");
                                location.href = "${createLink(controller: 'cronograma', action:'show')}/" + id + armaParams();
                            }
                        },
                        pac         : {
                            label  : "Asignaciones",
                            icon   : "fa fa-money",
                            action : function ($element) {
                                var id = $element.data("id");
                                location.href = "${createLink(controller: 'asignacion', action:'asignacionProyectov2')}/" + id
                            }
                        }
                        <g:if test="${usu.esDirector || usu.esGerente}">
                        ,
                        eliminar    : {
                            label            : "Eliminar",
                            icon             : "fa fa-trash-o",
                            separator_before : true,
                            action           : function ($element) {
                                var id = $element.data("id");
                                deleteProyecto(id);
                            }
                        }
                        </g:if>
                    },
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
