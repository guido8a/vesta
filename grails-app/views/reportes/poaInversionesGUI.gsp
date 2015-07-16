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

        <script type="text/javascript" src="${resource(dir: 'js/plugins/jquery-highlight', file: 'jquery-highlight1.js')}"></script>

        <title>PAPP</title>

        <style type="text/css">
        .unidad {
            padding : 3px;
            border  : solid 1px #555;
            cursor  : pointer;
        }

        .highlight {
            background-color : yellow
        }
        </style>
    </head>

    <body>
        <div class="btn-toolbar" role="toolbar">
            <div class="btn-group" role="group">
                <a href="#" class="btn btn-default" id="btnVer">
                    <i class="fa fa-search"></i> Ver reporte
                </a>
                <a href="#" class="btn btn-default" id="btnPrint">
                    <i class="fa fa-print"></i> Imprimir reporte
                </a>
            </div>
        </div>

        <elm:container tipo="horizontal" titulo="Reporte">
            <div class="alert alert-info">
                Seleccione el año y al menos una Área de gestión (haciendo clic sobre su nombre) para generar el reporte
            </div>

            <form class="form-inline">
                <div class="form-group">
                    <label for="anio">Año</label>
                    <g:select from="${Anio.list([sort: 'anio'])}" name="anio" class="form-control input-sm"
                              optionKey="id" optionValue="anio" value="${Anio.findByAnio(new Date().format('yyyy')).id}"/>
                </div>

                <div class="form-group" style="margin-left: 15px;">
                    <label for="buscar">Buscar</label>
                    <g:textField name="buscar" class="form-control input-sm"/>
                    <span id="found"></span>
                </div>
            </form>

            <g:each in="${UnidadEjecutora.list([sort: 'nombre'])}" var="unidad" status="i">
                <g:if test="${i % 3 == 0}">
                    <g:if test="${i > 0}">
                        </div>
                    </g:if>
                    <div class="row">
                </g:if>
                <div class="col-md-4" title="${unidad.nombre}">
                    <div class="unidad corner-all" id="${unidad.id}">
                        ${unidad.nombre.size() > 43 ? unidad.nombre[0..43] + '...' : unidad.nombre}
                    </div>
                </div>
            </g:each>
            </div>
        </elm:container>

        <script type="text/javascript">

            var selectedClass = "bg-info";

            function reset() {
                $(".search").val("");
                $(".unidad").removeHighlight();
            }

            function reporte(print) {
                var elems = "", url = "";
                $("." + selectedClass).each(function () {
                    elems += $(this).attr("id") + ",";
                });
                if (elems != "") {
                    if (!print) {
                        url = "${createLink(action: 'poaInversionesReporteWeb')}?anio=" + $("#anio").val() + "&id=" + elems;
                        window.open(url, "_blank");
                    } else {
                        url = "${createLink(action: 'poaInversionesReportePDF')}?anio=" + $("#anio").val() + "Wid=" + elems;
                        location.href = "${createLink(controller:'pdf',action:'pdfLink')}?url=" + url
                    }
                } else {
                    bootbox.alert("Escoja al menos una Área de gestión para generar el reporte.");
                    return false;
                }
            }

            $(function () {
                $(".unidad").click(function () {
                    $(this).toggleClass(selectedClass);
                });

                $("#buscar").keyup(function (evt) {
                    var elm = $(this);
                    var txt = elm.val();
                    if ($.trim(txt) != "") {
                        $(".unidad").removeHighlight().highlight(txt);
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