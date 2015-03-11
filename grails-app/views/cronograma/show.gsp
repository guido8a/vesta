<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 13/01/15
  Time: 04:40 PM
--%>

<%@ page import="vesta.proyectos.MarcoLogico; vesta.proyectos.Cronograma; vesta.parametros.poaPac.Mes; vesta.parametros.poaPac.Anio" contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <meta name="layout" content="main">
        <title>Cronograma del proyecto</title>

        %{--<link rel="stylesheet" type="text/css" href="${resource(dir: 'js/plugins/DataTables-1.10.4/media/css', file: 'jquery.dataTables.min.css')}">--}%
        %{--<script type="text/javascript" charset="utf8" src="${resource(dir: 'js/plugins/DataTables-1.10.4/media/js', file: 'jquery.dataTables.min.js')}"></script>--}%

        %{--<script src="${resource(dir: 'js/plugins/fixed-header-table-1.3', file: 'jquery.fixedheadertable.js')}"></script>--}%
        %{--<link rel="stylesheet" type="text/css" href="${resource(dir: 'js/plugins/fixed-header-table-1.3/css', file: 'defaultTheme.css')}"/>--}%

        <style type="text/css">
        table {
            font-size : 9pt;
        }

        td, th {
            vertical-align : middle !important;
        }

        .divTabla {
            max-height : 450px;
            overflow-y : auto;
            overflow-x : auto;
        }

        tfoot {
            font-size : larger;
        }
        </style>

    </head>

    <body>
        <g:set var="editable" value="${anio.estado == 0 && proyecto.aprobado != 'a'}"/>
        <g:if test="${params.list != 'list'}">
            <g:set var="editable" value="${false}"/>
        </g:if>

        <!-- botones -->
        <div class="btn-toolbar toolbar">
            <div class="btn-group">
                <g:link controller="proyecto" action="${params.list}" params="${params}" class="btn btn-sm btn-default">
                    <i class="fa fa-list"></i> Lista de proyectos
                </g:link>
            </div>
            <g:if test="${editable}">
                <div class="btn-group">
                    <g:link controller="cronograma" action="form" params="${params}" class="btn btn-sm btn-info btn-edit">
                        <i class="fa fa-pencil"></i> Editar
                    </g:link>
                </div>
            </g:if>
            <div class="btn-group">
                <g:link controller="asignacion" action="asignacionProyectov2" id="${proyecto.id}" class="btn btn-sm btn-default">
                    <i class="fa fa-money"></i> Asignaciones
                </g:link>
            </div>
            <g:if test="${params.act}">
                <div class="btn-group">
                    <g:link controller="marcoLogico" action="marcoLogicoProyecto" id="${proyecto.id}" class="btn btn-sm btn-default"
                            params="[list: params.list]">
                        <i class="fa fa-calendar-o"></i> Plan de proyecto
                    </g:link>
                </div>
            </g:if>
        </div>

        <g:if test="${proyecto.aprobado == 'a'}">
            <div class="alert alert-info">
                El proyecto está aprobado, no puede modificar el cronograma
            </div>
        </g:if>

        <elm:container tipo="horizontal" titulo="Cronograma del proyecto ${proyecto?.toStringMedio()}, para el año ${anio}" color="black">
            <g:if test="${!params.act}">
                <div class="divIndice ">
                    <g:each in="${componentes}" var="comp">
                        <a href="#comp${comp.id}" class="scrollComp ">
                            <strong>Componente ${comp.numeroComp}</strong>:
                        ${(comp.objeto.length() > 100) ? comp.objeto.substring(0, 100) + "..." : comp.objeto}
                        </a>
                    </g:each>
                </div>
            </g:if>

            <div class="divTabla">
                <g:render template="/templates/tablaCrono"
                          model="[anio: anio, componentes: componentes, actSel: actSel]"/>
            </div>
        </elm:container>

        <div class="modal fade" id="modalCronoVer">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span>
                        </button>
                        <h4 class="modal-title" id="modalTitleVer">Cronograma</h4>
                    </div>

                    <div class="modal-body">
                        <div class="alert alert-info">
                            <div id="divActividadVer"></div>

                            <div id="divInfoVer" class="text-warning"></div>
                        </div>

                        <div class="row">
                            <div class="col-md-3 show-label">Presupuesto (1)</div>

                            <div class="col-md-9" id="div_presupuesto1"></div>
                        </div>

                        <div class="row">
                            <div class="col-md-3 show-label">Partida (1)</div>

                            <div class="col-md-9" id="div_bsc-desc-partida1"></div>
                        </div>

                        <div class="row">
                            <div class="col-md-3 show-label">Fuente (1)</div>

                            <div class="col-md-9" id="div_desc-fuente1"></div>
                        </div>
                        <hr/>

                        <div class="row">
                            <div class="col-md-3 show-label">Presupuesto (2)</div>

                            <div class="col-md-9" id="div_presupuesto2"></div>
                        </div>

                        <div class="row">
                            <div class="col-md-3 show-label">Partida (2)</div>

                            <div class="col-md-9" id="div_bsc-desc-partida2"></div>
                        </div>

                        <div class="row">
                            <div class="col-md-3 show-label">Fuente (2)</div>

                            <div class="col-md-9" id="div_desc-fuente2"></div>
                        </div>
                    </div>

                    <div class="modal-footer">
                        <a href="#" class="btn btn-default" id="btnModalCancelVer">Cerrar</a>
                    </div>
                </div><!-- /.modal-content -->
            </div><!-- /.modal-dialog -->
        </div><!-- /.modal -->

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
                if (params != "") {
                    params = "&" + params;
                }
                return params;
            }

            function setDivs($td) {
                $.each($td.data(), function (key, val) {
                    var id = key.replace(/([a-z])([A-Z])/g, '$1-$2').toLowerCase();
                    var $div = $("#div_" + id);
                    if ($div.length > 0) {
                        if (id == "presupuesto1" || id == "presupuesto2") {
                            $div.text(number_format(val, 2, ".", ","));
                        } else {
                            $div.text(val);
                        }
                    }
                });
            }

            var $container = $(".divTabla");
            $container.scrollTop(0 - $container.offset().top + $container.scrollTop());
            $(function () {

                $(".comp").each(function () {
                    var id = $(this).attr("id");
                    var actividades = $(".act." + id);
                    if (actividades.length == 0) {
                        $(this).hide();
                        $(".total." + id).hide();
                    }
                });

                $(".btn-edit").click(function () {
                    openLoader();
                });
                $("#anio").val(${anio.id}).change(function () {
                    openLoader();
                    location.href = "${createLink(controller: 'cronograma', action: 'show', id: proyecto.id)}?anio=" +
                                    $("#anio").val() + armaParams() + "&act=${actSel?.id}&list=${params.list}";
                });

                $(".scrollComp").click(function () {
                    var $scrollTo = $($(this).attr("href"));
                    $container.animate({
                        scrollTop : $scrollTo.offset().top - $container.offset().top + $container.scrollTop()
                    });
                    return false;
                });

                $("#btnModalCancelVer").click(function () {
                    $('#modalCronoVer').modal("hide");
                    return false;
                });
                $(".nop").contextMenu({
                    items  : {
                        header : {
                            label  : "Sin acciones",
                            header : true
                        }
                    },
                    onShow : function ($element) {
                        $element.addClass("success");
                    },
                    onHide : function ($element) {
                        $(".success").removeClass("success");
                    }
                });
                $(".clickable").contextMenu({
                    items  : {
                        header : {
                            label  : "Acciones",
                            header : true
                        },
                        ver    : {
                            label  : "Ver",
                            icon   : "fa fa-search",
                            action : function ($element) {
                                var id = $element.data("id");
                                var $tr = $element.parents("tr");
                                var index = $element.index();

                                var $mes = $("#trMeses").children().eq(index);
                                var mes = $mes.attr("title");
                                $('#modalCronoVer').modal("show");
                                $("#modalTitleVer").text("Cronograma - " + mes);

                                var $actividad = $tr.find(".actividad");
                                var $asignado = $tr.find(".asignado");
                                var $sinAsignar = $tr.find(".sinAsignar");
                                var $total = $tr.find(".total");

                                var actividad = $actividad.attr("title");
                                var asignado = $asignado.data("val");
                                var sinAsignar = $sinAsignar.data("val");
                                var total = $total.data("val");

                                $("#divActividadVer").text(actividad);
                                $("#divInfoVer").html("<ul>" +
                                                      "<li><strong>Monto total:</strong> $" + number_format(total, 2, ".", ",") + "</li>" +
                                                      "<li><strong>Asignado:</strong> $" + number_format(asignado, 2, ".", ",") + "</li>" +
                                                      "<li><strong>Por asignar:</strong> $" + number_format(sinAsignar, 2, ".", ",") + "</li>" +
                                                      "</ul>").data({
                                    total      : total,
                                    asignado   : asignado,
                                    sinAsignar : sinAsignar,
                                    crono      : id,
                                    mes        : $mes.data("id"),
                                    actividad  : $tr.data("id")
                                });
                                setDivs($element);
                            }
                        }
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