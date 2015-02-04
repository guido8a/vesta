<%@ page import="vesta.parametros.proyectos.TipoMeta" contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main"/>
        <title>Metas</title>

        <style type="text/css">
        .errores {
            border     : solid 2px #dd0000 !important;
            background : #FFEFEF !important;
        }
        </style>

    </head>

    <body>

        <div class="body">
            <div class="dialog">
                <div class="toolbar ui-widget-header ui-corner-all" style="margin-bottom: 10px;">
                    <a href="#" id="btnOk">Ver reporte</a>

                    <a href="#" id="btnExport">Exportar a CSV</a>

                    <a href="#" onclick="window.location.reload(true)" id="" class="btn" style="float: right;">Resetear</a>
                </div>

                <div style="padding: 0.7em;" class="ui-state-error ui-corner-all ui-helper-hidden" id="divError">
                    <span style="float: left; margin-right: .3em;" class="ui-icon ui-icon-alert"></span>
                    <strong>Se encontraron los siguientes errores:</strong>

                    <div id="detalleErrores">
                    </div>
                </div>

                <fieldset class="ui-corner-all" style="width: 1010px;height: 55px;">
                    <legend>Parametros</legend>

                    <b>Indicador:</b>
                    <g:select class="ui-corner-all" from="${TipoMeta.list()}" optionKey="id" optionValue="descripcion" name="tipo" id="indicador" style="width: 110px;" noSelection="['-1': 'Todos']"/> &nbsp;&nbsp;

                    <span id="spanLbl" style="font-weight:bold;">Parroquia:</span>

                    <input class="ui-corner-all" type="text" style="width: 200px;" id="parr_nombre_txt">&nbsp;&nbsp;
                    <input type="hidden" id="parr_id" name="parroquia.id">

                    <b>Meta:</b>

                    <select id="tipoMeta" class="ui-corner-all">
                        <option value="3">Menor que</option>
                        <option value="1">Igual a</option>
                        <option value="2">Mayor que</option>
                    </select>

                    <input class="ui-corner-all" type="text" style="width: 75px;" id="meta"> &nbsp;&nbsp;

                    <b>Inversión:</b>

                    <select id="tipoInversion" class="ui-corner-all">
                        <option value="3">Menor que</option>
                        <option value="1">Igual a</option>
                        <option value="2">Mayor que</option>
                    </select>

                    <input class="ui-corner-all" type="text" style="width: 75px;" id="inversion">
                </fieldset>

            </div>
            <fieldset class="ui-corner-all" style="width: 1010px;min-height: 50px;">
                <legend>Resultados</legend>

                <div id="resultados" style="overflow-y: auto;"></div>
            </fieldset>
        </div>

        <div id="dlg_buscar">
            <div style="width: 90%;height: 30px;">
                <input type="text" id="txt_buscar">

                <a href="#" id="buscar_dlg" class="btn">Buscar</a>

                <a href="#" id="btnTodas">Todas las provincias</a>
            </div>

            <div id="parrs"
                 style="width: 95%;height: 340px;overflow-y: auto;margin: auto;margin-top: 10px;border: 1px solid black;"
                 class="ui-corner-all"></div>
        </div>

        <div id="load">
            <img src="${g.resource(dir: 'images', file: 'loading.gif')}" alt="Procesando">
            Procesando
        </div>
        <script type="text/javascript">

            function validar() {
                var parroquia = $("#parr_id").val();
                var meta = $("#meta").val();
                var inversion = $("#inversion").val();

                var err = "";

                if (trim(parroquia) == "") {
                    err += "<li>No ha seleccionado una parroquia.</li>";
                    $("#parr_nombre_txt").addClass("errores");
                } else {
                    $("#parr_nombre_txt").removeClass("errores");
                }
                if (trim(meta) == "") {
                    err += "<li>No ha ingresado una meta.</li>";
                    $("#meta").addClass("errores");
                } else {
                    $("#meta").removeClass("errores");
                    if (isNaN(meta)) {
                        err += "<li>La meta debe ser un valor numérico.</li>";
                        $("#meta").addClass("errores");
                    }
                }
                if (trim(inversion) == "") {
                    err += "<li>No ha ingresado una inversión.</li>";
                    $("#inversion").addClass("errores");
                } else {
                    $("#inversion").removeClass("errores");
                    if (isNaN(inversion)) {
                        err += "<li>La inversión debe ser un valor numérico.</li>";
                        $("#inversion").addClass("errores");
                    }
                }

                if (err != "") {
                    $("#detalleErrores").html("<ul>" + err + "</ul>");
                    $("#divError").show();
                    return false;
                } else {
                    $("#divError").hide();
                    return true;
                }
            }

            $("#btnOk").button({
                icons : {
                    primary : "ui-icon-zoomin"
                }
            }).click(function () {
                        if (validar()) {
                            $("#load").dialog("open");
                            $.ajax({
                                type    : "POST",
                                url     : "${createLink(action:'metasWeb')}",
                                data    : {
                                    indicador     : $("#indicador").val(),
                                    parroquia     : $("#parr_id").val(),
                                    meta          : $("#meta").val(),
                                    tipoMeta      : $("#tipoMeta").val(),
                                    inversion     : $("#inversion").val(),
                                    tipoInversion : $("#tipoInversion").val()
                                },
                                success : function (msg) {
                                    $("#resultados").html(msg)
                                    $("#load").dialog("close");
                                }
                            });
                        }
                    });

            $("#btnExport").button({
                icons : {
                    primary : "ui-icon-calculator"
                }
            }).click(function () {
                        if (validar()) {
                            var url = "${createLink(action:'metasXls')}";
                            var data = "indicador=" + $("#indicador").val() + "&parroquia=" + $("#parr_id").val() + "&meta=" + $("#meta").val();
                            data += "&tipoMeta=" + $("#tipoMeta").val() + "&inversion=" + $("#inversion").val() + "&tipoInversion=" + $("#tipoInversion").val();

                            url += "?" + data;

                            location.href = url;
                        }
                    });

            $("input").val("");
            $("select").prop("selectedIndex", 0);

            $(".btn").button()
            $("#parr_nombre_txt").click(function () {
                $("#dlg_buscar").dialog("open")
            });
            $("#buscar_dlg").click(function () {
                $.ajax({
                    type    : "POST",
                    url     : "${createLink(action:'buscarParroquias')}",
                    data    : "parametro=" + $("#txt_buscar").val(),
                    success : function (msg) {
                        $("#parrs").html(msg)

                    }
                });
                return false;
            });

            $("#btnTodas").click(
                    function () {
                        $("#spanLbl").text("Parroquia:");
                        $("#parr_id").val("all");
                        $("#parr_nombre_txt").val("Todas");

                        $("#dlg_buscar").dialog("close");

                        return false;
                    }).css({float : "right"}).button({

                    });

            $("#dlg_buscar").dialog({
                width    : 630,
                height   : 500,
                position : "center",
                modal    : true,
                autoOpen : false
            })
            $("#load").dialog({
                width     : 100,
                height    : 100,
                position  : "center",
                title     : "Procesando",
                modal     : true,
                autoOpen  : false,
                resizable : false,
                open      : function (event, ui) {
                    $(event.target).parent().find(".ui-dialog-titlebar-close").remove()
                }
            });

        </script>
    </body>
</html>