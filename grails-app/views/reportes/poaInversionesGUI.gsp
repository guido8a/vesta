<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 10/10/11
  Time: 3:29 PM
  To change this template use File | Settings | File Templates.
--%>

<%@ page import="vesta.parametros.poaPac.Anio; vesta.parametros.UnidadEjecutora" contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <meta name="layout" content="main"/>
        <title>PAPP</title>

        <script type="text/javascript"
                src="${resource(dir: 'js/jquery/plugins', file: 'jquery.highlight-3.js')}"></script>

        <style type="text/css">
        .highlight {
            background-color : yellow
        }

        .area {
            width    : 520px;
            height   : 600px;
            float    : left;
            position : absolute;
        }

        .area.sel {
            margin-left : 25px;
            left        : 540px;
        }

        .area.disp {
            left : 13px;
        }

        .unidad {
            border  : solid 2px;
            margin  : 3px;
            padding : 3px;
            cursor  : pointer;
        }

        .unidad.disp {
            background : #FFFAF7;
        }

        .unidad.sel {
            /*background : #EEF7EA;*/
            background : #7871BE;
        }

        .disp {
            /*border-color : #EAD2C2;*/
            border-color : #363636;
        }

        .sel {
            /*border-color : #CDEAC2;*/
            border-color : #7871BE;
        }

        .toolbar {
            padding : 5px 4px;
        }

        .connectedSortable {
            /*background : #eee;*/
            height     : 570px;
            overflow-y : auto;
            overflow-x : hidden;
        }
        </style>
    </head>

    <body>
        <div class="toolbar ui-widget-header ui-corner-all" style="margin-bottom: 10px;">
            <a href="#" id="btnOk">Ver reporte</a>
            <a href="#" id="btnPrint">Imprimir reporte</a>
        </div>

        <div style="margin-bottom: 10px;">
            <label>A&ntilde;o:</label>
            <g:select from="${Anio.list([sort:'anio'])}" name="anio" class="ui-widget-content ui-corner-all"
                      optionKey="id" optionValue="anio" value="${Anio.findByAnio(new Date().format('yyyy')).id}"/>
        </div>

        <div class="ui-widget-content ui-corner-all area disp">
            <div class="toolbar ui-widget-header ui-corner-all">
                Unidades Ejecutoras disponibles
                <div class="right">
                    Buscar
                    <input type="text" id="dispo" class="search ui-widget-content ui-corner-all"/>
                </div>
            </div>

            <div name="disponibles" class="connectedSortable">
                <g:each in="${UnidadEjecutora.list([sort:'nombre'])}" var="unidad">
                    <div class="unidad disp dispo ui-corner-all" id="${unidad.id}">
                        ${unidad.nombre}
                    </div>
                </g:each>
            </div>
        </div>

        <div class="ui-widget-content ui-corner-all area sel">
            <div class="toolbar ui-widget-header ui-corner-all">
                Unidades Ejecutoras para el reporte
                <div class="right">
                    Buscar
                    <input type="text" id="sele" class="search ui-widget-content ui-corner-all"/>
                </div>
            </div>

            <div name="seleccionados" class="connectedSortable">
            </div>
        </div>

        <div id="dlgAlert" title="Alerta" class="ui-helper-hidden">
            <div style="padding: 0 .7em;" class="ui-state-error ui-corner-all">
                <p>
                    <span style="float: left; margin-right: .3em;" class="ui-icon ui-icon-alert"></span>
                    <strong>Alerta:</strong>
                    <span id="spnAlert"></span>
                </p>
            </div>
        </div>

        <script type="text/javascript">
            function reset() {
                $(".search").val("");
                $(".unidad").removeHighlight();
                $(".unidad").show();
            }

            function reporte(print) {
                var elems = "";
                $(".sele").each(function() {
                    elems += $(this).attr("id") + ",";
                });
                if (elems != "") {
                    if (!print) {
                        var url = "${createLink(action: 'poaInversionesReporteWeb')}?anio=" + $("#anio").val() + "&id=" + elems;
                        window.open(url, "_blank");
                    } else {
                        var url = "${createLink(action: 'poaInversionesReportePDF')}?anio=" + $("#anio").val() + "Wid=" + elems;
                        location.href = "${createLink(controller:'pdf',action:'pdfLink')}?url=" + url
                    }
                } else {
                    $("#spnAlert").html("Escoja al menos una unidad ejecutora para generar el reporte.");
                    $("#dlgAlert").dialog("open");
                    return false;
                }
            }

            $(function() {
                $("#btnOk").button({
                    icons: {
                        primary: "ui-icon-zoomin"
                    }
                }).click(function() {
                            reporte(false);
                        });

                $("#btnPrint").button({
                    icons: {
                        primary: "ui-icon-print"
                    }
                }).click(function() {
                            reporte(true);
                        });

                $("#dlgAlert").dialog({
                    autoOpen: false,
                    modal: true,
                    width: 410,
                    resizable: false,
                    draggable: false,
                    buttons: {
                        "Aceptar": function() {
                            $(this).dialog("close");
                        }
                    }
                });

                $("[name=disponibles],[name=seleccionados]").sortable({
                    connectWith: ".connectedSortable",
                    forcePlaceholderSize: true,
                    placeholder: 'ui-state-highlight',
                    scroll: false,
                    start: function(event, ui) {
                        reset();
                    },
                    stop: function(event, ui) {
                        var elm = ui.item;
                        var pName = elm.parent().attr("name");
                        if (pName == "seleccionados") {
                            elm.removeClass("disp").removeClass("dispo").addClass("sel").addClass("sele");
                        } else {
                            elm.removeClass("sel").removeClass("sele").addClass("disp").addClass("dispo");
                        }
                    }
                }).disableSelection();

                $(".search").keyup(function(evt) {
                    var elm = $(this);
                    var txt = elm.val();
                    var tipo = elm.attr("id");
                    if (trim(txt) != "") {
                        $("." + tipo).hide();
                        $("." + tipo).removeHighlight();
                        $("." + tipo + ":icontains('" + txt + "')").show();
                        $("." + tipo).highlight(txt);
                    } else {
                        reset();
                    }
                });

            });
        </script>
    </body>
</html>