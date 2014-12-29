<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 1/6/12
  Time: 2:59 PM
  To change this template use File | Settings | File Templates.
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <meta name="layout" content="main"/>
        <title>Reporte de usuarios</title>
    </head>

    <body>
        <div class="toolbar ui-widget-header ui-corner-all" style="margin-bottom: 10px;">
            <a href="#" id="btnOk">Ver reporte</a>

            <a href="#" id="btnPrint">Imprimir reporte</a>

            <a href="#" id="btnExport">Exportar a CSV</a>
        </div>

        <script type="text/javascript">

            function reporte(print) {
                var elems = "ALL";
                if (elems != "") {
                    if (print == "web") {
                        var url = "${createLink(action: 'usuariosWeb')}?id=" + elems;
                        window.open(url, "_blank");
                    } else if (print == "pdf") {
                        var url = "${createLink(action: 'usuariosPdf')}?id=" + elems;
                        location.href = "${createLink(controller:'pdf',action:'pdfLink')}?url=" + url
                    } else if (print == "csv") {
                        location.href = "${createLink(action:'usuariosCsv')}?anio=" + $("#anio").val() + "&id=" + elems;
                    }
                } else {
                    $("#spnAlert").html("Escoja al menos una unidad ejecutora para generar el reporte.");
                    $("#dlgAlert").dialog("open");
                    return false;
                }
            }

            $(function () {

                $("#btnOk").button({
                    icons:{
                        primary:"ui-icon-zoomin"
                    }
                }).click(function () {
                            reporte("web");
                        });

                $("#btnPrint").button({
                    icons:{
                        primary:"ui-icon-print"
                    }
                }).click(function () {
                            reporte("pdf");
                        });

                $("#btnExport").button({
                    icons:{
                        primary:"ui-icon-calculator"
                    }
                }).click(function () {
                            reporte("csv");
                        });

            });
        </script>

    </body>
</html>