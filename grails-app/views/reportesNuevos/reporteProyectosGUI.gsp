<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 12/03/15
  Time: 01:10 PM
--%>

<%@ page import="vesta.parametros.poaPac.Fuente; vesta.parametros.poaPac.Anio" contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <meta name="layout" content="main">
        <title>Reporte de proyectos</title>

        <style type="text/css">
        .anio, .fuente {
            border  : solid 1px #555;
            padding : 3px;
            cursor  : pointer;
        }

        .anio {
            text-align : center;
        }

        .highlight {
            background-color : yellow
        }
        </style>

    </head>

    <body>

        <div class="btn-toolbar" role="toolbar">
            <div class="btn-group" role="group">
                %{--<a href="#" class="btn btn-default" id="btnVer">--}%
                %{--<i class="fa fa-search"></i> Ver reporte--}%
                %{--</a>--}%
                <a href="#" class="btn btn-default" id="btnPrint">
                    <i class="fa fa-print"></i> Imprimir reporte
                </a>
            </div>

        </div>

        <g:set var="selectedAnio" value="bg-success"/>
        <g:set var="selectedFuente" value="bg-warning"/>

        <g:set var="anio" value="${Anio.findByAnio(new Date().format('yyyy'))}"/>

        <elm:container tipo="horizontal" titulo="Configurar reporte">
            <div class="alert alert-info">
                Seleccione %{--el año y --}%al menos una fuente (haciendo clic sobre su nombre) para generar el reporte
                <div>
                    Mostrar reporte de
                    %{--<span id="spAnios" class="text-success">0 años</span>,--}%
                    %{--de--}% <span id="spFuentes" class="text-warning">0 fuentes</span>
                </div>
            </div>

        %{--<div class="alert alert-primary">--}%
        %{--<h4>Año <a href="#" id="btnAllAnio" class="btn btn-default" data-status="off">Seleccionar todos los años</a></h4>--}%
        %{--<g:each in="${Anio.list([sort: 'anio'])}" var="an" status="i">--}%
        %{--<g:if test="${i % 12 == 0}">--}%
        %{--<g:if test="${i > 0}">--}%
        %{--</div>--}%
        %{--</g:if>--}%
        %{--<div class="row">--}%
        %{--</g:if>--}%
        %{--<div class="col-md-1">--}%
        %{--<div class="anio corner-all" id="${an.id}">--}%
        %{--${an.anio}--}%
        %{--</div>--}%
        %{--</div>--}%
        %{--</g:each>--}%
        %{--</div>--}%
        %{--</div>--}%

            <div class="alert alert-primary">
                <h4>Fuente <a href="#" id="btnAllFuente" class="btn btn-default" data-status="off">Seleccionar todas las fuentes</a></h4>
            <g:each in="${Fuente.list([sort: 'descripcion'])}" var="fuente" status="i">
                <g:if test="${i % 3 == 0}">
                    <g:if test="${i > 0}">
                        </div>
                    </g:if>
                    <div class="row">
                </g:if>
                <div class="col-md-4">
                    <div class="fuente corner-all" id="${fuente.id}">
                        ${fuente.descripcion}
                    </div>
                </div>
            </g:each>
            </div>
            </div>

        </elm:container>

        <script type="text/javascript">

            function reset() {
                $(".search").val("");
                $(".fuente").removeHighlight();
            }

            function reporte(print) {

                var anios = "", fuentes = "", url = "";

                $("." + "${selectedAnio}").each(function () {
                    anios += $(this).attr("id") + ",";
                });
                $("." + "${selectedFuente}").each(function () {
                    fuentes += $(this).attr("id") + ",";
                });

                if (/*anios == "" || */fuentes == "") {
                    bootbox.alert("Escoja al menos una fuente para generar el reporte.");
                    return false;
                } else {
                    if (!print) {
                        url = "${createLink(action: 'reporteProyectosWeb')}";
                        url += "?anios=" + anios + "&fuentes=" + fuentes;
                        window.open(url, "_blank");
                    } else {
                        url = "${createLink(action: 'reporteProyectosPdf')}";
                        url += "?anios=" + anios + "Wfuentes=" + fuentes;
                        location.href = "${createLink(controller:'pdf',action:'pdfLink')}?url=" + url;
                    }
                }
            }

            function selectAll($btn, tipo) {
                var btn1Txt, btn2Txt, spanId, spanTxt, clase, claseSelected;
                switch (tipo) {
                    case "anio":
                        btn1Txt = "todos los años";
                        btn2Txt = "de año";
                        spanId = "spAnios";
                        spanTxt = "año";
                        clase = "anio";
                        claseSelected = "${selectedAnio}";
                        break;
                    case "fuente" :
                        btn1Txt = "todas las fuentes";
                        btn2Txt = "de fuente";
                        spanId = "spFuentes";
                        spanTxt = "fuente";
                        clase = "fuente";
                        claseSelected = "${selectedFuente}";
                        break;
                }
                if ($btn.data("status") == "on") {
                    $("." + clase).removeClass(claseSelected);
                    $btn.text("Seleccionar " + btn1Txt);
                    $btn.data("status", "off");
                } else {
                    $("." + clase).addClass(claseSelected);
                    $btn.text("Quitar selección " + btn2Txt);
                    $btn.data("status", "on");
                }
                count(tipo);
                return false;
            }

            function count(tipo) {
                var spanId, spanTxt, clase, claseSelected;
                switch (tipo) {
                    case "anio":
                        spanId = "spAnios";
                        spanTxt = "año";
                        clase = "anio";
                        claseSelected = "${selectedAnio}";
                        break;
                    case "fuente" :
                        spanId = "spFuentes";
                        spanTxt = "fuente";
                        clase = "fuente";
                        claseSelected = "${selectedFuente}";
                        break;
                }
                var c = $("." + claseSelected).length;
                $("#" + spanId).text(c + " " + spanTxt + (c == 1 ? '' : 's'));
            }

            $(function () {

                $("#btnAllAnio").click(function () {
                    selectAll($(this), "anio");
                    return false;
                });
                $("#btnAllFuente").click(function () {
                    selectAll($(this), "fuente");
                    return false;
                });

                $(".anio").click(function () {
                    $(this).toggleClass("${selectedAnio}");
                    count("anio");
                });
                $(".fuente").click(function () {
                    $(this).toggleClass("${selectedFuente}");
                    count("fuente");
                });

                $("#buscar").keyup(function (evt) {
                    var elm = $(this);
                    var txt = elm.val();
                    if ($.trim(txt) != "") {
                        $(".proyecto").removeHighlight().highlight(txt);
                        var h = $(".highlight");
                        var c = h.length;
                        $("#found").text("Se encontr" + (c == 1 ? "ó " : "aron ") + c + " coincidencia" + (c == 1 ? "" : "s"));
                    } else {
                        reset();
                    }
                });

                $("#btnVer").click(function () {
                    reporte(false);
                });
                $("#btnPrint").click(function () {
                    reporte(true);
                });

            });
        </script>

    </body>
</html>