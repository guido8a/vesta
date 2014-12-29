<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 11/23/11
  Time: 3:40 PM
  To change this template use File | Settings | File Templates.
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <meta name="layout" content="main"/>
        <title>Ejecuci&oacute;n presupuestaria de proyectos</title>

        <style type="text/css">
        .toolbar {
            padding : 5px 4px;
        }
        </style>

    </head>

    <body>

        <div class="toolbar ui-widget-header ui-corner-all" style="margin-bottom: 10px;">
            <a href="#" id="btnOk">Ver reporte</a>

            <a href="#" id="btnPrint">Imprimir reporte</a>
        </div>

        <div>
            <div>
                Mes:
                <g:select from="${meses}" class="sele" name="mes" optionKey="key" optionValue="value"/>
            </div>
        </div>


        <script type="text/javascript">

            function reporte(print) {
                var elems = "";
                $(".sele").each(function () {
                    elems += $(this).val();
                });
                if (elems != "") {
                    if (!print) {
                        var url = "${createLink(action: 'ejecucionProyectosWeb')}?id=" + elems;
                        window.open(url, "_blank");
                    } else {
                        var url = "${createLink(action: 'ejecucionProyectosPDF')}?id=" + elems;
                        location.href = "${createLink(controller:'pdf',action:'pdfLink')}?url=" + url
                    }
                } else {
                    $("#spnAlert").html("Escoja al menos un proyecto para generar el reporte.");
                    $("#dlgAlert").dialog("open");
                }
                return false;
            }

            $(function () {
                $("#btnOk").button({
                    icons:{
                        primary:"ui-icon-zoomin"
                    }
                }).click(function () {
                            reporte(false);
                        });

                $("#btnPrint").button({
                    icons:{
                        primary:"ui-icon-print"
                    }
                }).click(function () {
                            reporte(true);
                        });

            });
        </script>

    </body>
</html>