<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 03/07/15
  Time: 12:31 PM
--%>

<%@ page import="vesta.parametros.poaPac.Anio" contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <meta name="layout" content="main">
        <title>Copiar actividades y tareas</title>

        <script type="text/javascript" src="${resource(dir: 'js/plugins/bootstrap-select-1.6.3/dist/js', file: 'bootstrap-select.js')}"></script>
        <link rel="stylesheet" href="${resource(dir: 'js/plugins/bootstrap-select-1.6.3/dist/css', file: 'bootstrap-select.css')}">

        <style type="text/css">
        .actividades {
            height   : 300px;
            overflow : auto;
        }

        .actDisp {
            border        : solid 1px floralwhite;
            margin-bottom : 5px;
            padding       : 5px;
        }

        .actTitleDisp {
            background    : #c6ddff;
            padding       : 2px 25px 2px 5px;
            position      : relative;
            margin-bottom : 5px;
            cursor        : pointer;
        }

        .actTitleDisp.selected {
            background : #80b26f;
            color      : whitesmoke;
        }

        .tareaDisp {
            border   : solid 1px slategrey;
            padding  : 2px 25px 2px 5px;
            position : relative;
            cursor   : pointer;
        }

        .tareaDisp.selected {
            background : #addda9;
        }

        .divSelectAllDisp {
            position : absolute;
            right    : 5px;
            top      : 0;
        }

        .divSelectDisp {
            position : absolute;
            right    : 5px;
            top      : 0;
        }

        .actCopiada {
            border        : solid 1px floralwhite;
            margin-bottom : 5px;
            padding       : 5px;
        }

        .actTitleCopiada {
            background    : #80b26f;
            padding       : 2px 25px 2px 5px;
            position      : relative;
            margin-bottom : 5px;
            cursor        : pointer;
            color         : white;
        }

        .actTitleCopiada.selected {
            background : #84474e;
            color      : whitesmoke;
        }

        .tareaCopiada {
            border   : solid 1px #567d46;
            padding  : 2px 25px 2px 5px;
            position : relative;
            cursor   : pointer;
            color    : white;
        }

        .tareaCopiada.selected {
            background : #ad6f6f;
        }

        .divSelectAllCopiada {
            position : absolute;
            right    : 5px;
            top      : 0;
        }

        .divSelectCopiada {
            position : absolute;
            right    : 5px;
            top      : 0;
        }
        </style>
    </head>

    <body>

        <div class="well">
            <p>
                En esta pantalla puede copiar actividades y tareas de un año a otro.
            </p>

            <p>
                Primero seleccione el objetivo de gasto corriente y la macro actividad para seleccionar actividades y tareas a copiar.
            </p>

            <p>
                Recuerde que si cambia la macro actividad seleccionada sin copiar las actividades primero perderá su selección.
            </p>
        </div>

        <div class="row">
            <div class="col-md-1">
                <label for="anioDesde">Año desde</label>
            </div>

            <div class="col-md-2">
                <g:select name="anioDesde" from="${aniosDesde}" class="form-control input-sm" optionKey="id" optionValue="anio" value="${Anio.findByAnio(new Date().format('yyyy')).id}"/>
            </div>

            <div class="col-md-1">
                <label>Año hasta</label>
            </div>

            <div class="col-md-2" id="tdAnioHasta">

            </div>
        </div>

        <div class="row">
            <div class="col-md-2">
                <label>Objetivo de gasto corriente</label>
            </div>

            <div class="col-md-10" id="tdObj">

            </div>
        </div>

        <div class="row">
            <div class="col-md-2">
                <label>MacroActividad</label>
            </div>

            <div class="col-md-10" id="tdMacro">

            </div>
        </div>

        <div class="row">
            <div class="col-md-6 alert alert-info">
                <h4>
                    Actividades y tareas <span id="spAnioDesde" class="spanAnio"></span>
                    <a href="#" class="btn btn-success btn-sm disabled" id="btnCopiar">
                        Copiar selección
                        <i class="fa fa-arrow-right"></i>
                    </a>
                </h4>

                <div class="actividades" id="actividadesDisponibles"></div>
            </div>

            <div class="col-md-6 alert alert-success">
                <h4>
                    Actividades y tareas  <span id="spAnioHasta" class="spanAnio"></span>
                    <a href="#" class="btn btn-danger btn-sm disabled" id="btnDelete">
                        <i class="fa fa-trash-o"></i>
                        Eliminar selección
                    </a>
                </h4>

                <div class="actividades" id="actividadesActuales"></div>
            </div>
        </div>

        <script type="text/javascript">
            function cargarObjAnio() {
                $("#tdObj").html(spinner);
                $.ajax({
                    type    : "POST",
                    url     : "${createLink(controller: 'avalCorriente', action:'cargaObjetivosAnio_ajax')}",
                    data    : {
                        anio   : $("#anioDesde").val(),
                        copiar : "S",
                        width  : "940px"
                    },
                    success : function (msg) {
                        $("#tdObj").html(msg);
                        $("#actividadesDisponibles").html("");
                    }
                });
                $("#spAnioDesde").text($("#anioDesde").find("option:selected").text());
                $("#tdAnioHasta").html(spinner);
                $.ajax({
                    type    : "POST",
                    url     : "${createLink( action:'cargarOtrosAnios_ajax')}",
                    data    : {
                        anio : $("#anioDesde").val()
                    },
                    success : function (msg) {
                        $("#tdAnioHasta").html(msg);
                        $("#spAnioHasta").text($("#anioHasta").find("option:selected").text());
                    }
                });
            }

            function cargarActividadesAnio() {
                $("#actividadesDisponibles").html(spinner);
                $.ajax({
                    type    : "POST",
                    url     : "${createLink( action:'cargaActividadesDisponibles_ajax')}",
                    data    : {
                        anio  : $("#anioDesde").val(),
                        macro : $("#mac").val()
                    },
                    success : function (msg) {
                        $("#actividadesDisponibles").html(msg);
                    }
                });
            }

            function cargarActividadesCopiadas() {
                $("#actividadesActuales").html(spinner);
                $.ajax({
                    type    : "POST",
                    url     : "${createLink( action:'cargaActividadesCopiadas_ajax')}",
                    data    : {
                        anio  : $("#anioHasta").val(),
                        macro : $("#mac").val()
                    },
                    success : function (msg) {
                        $("#actividadesActuales").html(msg);
                        closeLoader();
                    }
                });
            }

            function validarCopiar() {
                var acts = $(".actTitleDisp.selected").length;
                if (acts > 0) {
                    $("#btnCopiar").removeClass("disabled");
                } else {
                    $("#btnCopiar").addClass("disabled");
                }
            }

            function validarEliminar() {
                var acts = $(".actTitleCopiada.selected,.tareaCopiada.selected").length;
                if (acts > 0) {
                    $("#btnDelete").removeClass("disabled");
                } else {
                    $("#btnDelete").addClass("disabled");
                }
            }

            $(function () {
                cargarObjAnio();
                $("#anioDesde").change(function () {
                    cargarObjAnio();
                });

                $("#btnCopiar").click(function () {
                    var acts = "";
                    var tareas = "";
                    $(".actTitleDisp.selected").each(function () {
                        acts += $(this).data("id") + ",";
                    });
                    $(".tareaDisp.selected").each(function () {
                        tareas += $(this).data("id") + ",";
                    });
                    openLoader();
                    $.ajax({
                        type    : "POST",
                        url     : "${createLink( action:'copiarActividadesTareas_ajax')}",
                        data    : {
                            hasta  : $("#anioHasta").val(),
                            acts   : acts,
                            tareas : tareas
                        },
                        success : function (msg) {
                            var parts = msg.split("*");
                            log(parts[1], parts[0]);
                            cargarActividadesCopiadas();
                            desactivar($(".actTitleDisp.selected"));
                            desactivar($(".tareaDisp.selected"));
                        }
                    });
                    return false;
                });

                $("#btnDelete").click(function () {
                    bootbox.confirm("¿Está seguro de querer eliminar estas actividades/tareas?", function () {
                        var acts = "";
                        var tareas = "";
                        $(".actTitleCopiada.selected").each(function () {
                            acts += $(this).data("id") + ",";
                        });
                        $(".tareaCopiada.selected").each(function () {
                            tareas += $(this).data("id") + ",";
                        });
                        openLoader();
                        $.ajax({
                            type    : "POST",
                            url     : "${createLink( action:'eliminarActividadesTareas_ajax')}",
                            data    : {
                                acts   : acts,
                                tareas : tareas
                            },
                            success : function (msg) {
                                var parts = msg.split("*");
                                log(parts[1], parts[0]);
                                cargarActividadesCopiadas();
                            }
                        });
                    });
                    return false;
                });

            });
        </script>

    </body>
</html>