<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 9/22/11
  Time: 11:26 AM
  To change this template use File | Settings | File Templates.
--%>

<%@ page import="vesta.proyectos.Proyecto" contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Componentes de proyecto</title>

    <script type="text/javascript"
            src="${resource(dir: 'js/jquery/plugins', file: 'jquery.highlight-3.js')}"></script>

    <style type="text/css">
    .highlight {
        background-color : yellow
    }

    .area {
        width    : 520px;
        height   : 640px;
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

    .proyecto {
        border  : solid 2px;
        margin  : 3px;
        padding : 3px;
        cursor  : pointer;
    }

    .proyecto.disp {
        background : #FFFAF7;
    }

    .proyecto.sel {
        background : #EEF7EA;
    }

    .disp {
        border-color : #EAD2C2;
    }

    .sel {
        border-color : #CDEAC2;
    }

    .toolbar {
        padding : 5px 4px;
    }

    .connectedSortable {
        /*background : #eee;*/
        height     : 600px;
        overflow-y : auto;
        overflow-x : hidden;
    }
    </style>

</head>

<body>

    <div class="toolbar ui-widget-header ui-corner-all" style="margin-bottom: 10px;">
        <a href="#" id="btnOk">Ver reporte</a>
        <a href="#" id="btnPrint">Imprimir reporte</a>
        <a href="#" id="btnExport">Exportar a CSV</a>
    </div>

    <div class="ui-widget-content ui-corner-all area disp">
        <div class="toolbar ui-widget-header ui-corner-all">
            Proyectos disponibles
            <div class="right">
                Buscar
                <input type="text" id="dispo" class="search ui-widget-content ui-corner-all"/>
            </div>
        </div>

        <div name="disponibles" class="connectedSortable">
            <g:each in="${Proyecto.list([sort:'nombre'])}" var="proyecto">
                <div class="proyecto disp dispo ui-corner-all" id="${proyecto.id}">
                    ${proyecto.nombre}
                </div>
            </g:each>
        </div>

    </div>

    <div class="ui-widget-content ui-corner-all area sel">
        <div class="toolbar ui-widget-header ui-corner-all">
            Proyectos para el reporte
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
            $(".proyecto").removeHighlight();
            $(".proyecto").show();
        }

        function reporte(print) {
            var elems = "";
            $(".sele").each(function() {
                elems += $(this).attr("id") + ",";
            });
            if (elems != "") {
                if (print == "web") {
                    var url = "${createLink(action: 'componentesWeb')}?id=" + elems;
                    window.open(url, "_blank");
                } else if(print == "pdf") {
                    var url = "${createLink(action: 'componentesPdf')}?id=" + elems;
                    location.href = "${createLink(controller:'pdf',action:'pdfLink')}?url=" + url;
                } else if(print == "csv") {
                    location.href = "${createLink(action:'componentesCsv')}?id=" + elems;
                }
            } else {
                $("#spnAlert").html("Escoja al menos un proyecto para generar el reporte.");
                $("#dlgAlert").dialog("open");
                return false;
            }
        }

        $(function() {

            reset();

            $("#btnOk").button({
                icons: {
                    primary: "ui-icon-zoomin"
                }
            }).click(function() {
                        reporte("web");
                    });

            $("#btnPrint").button({
                icons: {
                    primary: "ui-icon-print"
                }
            }).click(function() {
                        reporte("pdf");
                    });

            $("#btnExport").button({
                icons: {
                    primary: "ui-icon-calculator"
                }
            }).click(function() {
                        reporte("csv");
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