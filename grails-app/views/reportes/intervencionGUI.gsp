<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 9/26/11
  Time: 10:54 AM
  To change this template use File | Settings | File Templates.
--%>

<%@ page import="vesta.parametros.poaPac.Anio" contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <meta name="layout" content="main"/>
        <title>Intervenci&oacute;n e inversi&oacute;n</title>

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
            A&ntilde;o: <g:select from="${Anio.list([sort:'anio'])}" name="anio"/>
            <g:radioGroup name="tipo" labels="['Nacional'/*,'Por provincias'*/]" values="['N'/*,'P'*/]" value="N">
                <p>
                    ${it.radio} ${it.label}
                </p>
            </g:radioGroup>
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
            function reporte(print) {
                var elems = $("[name=tipo]:checked").val();
                if (elems != "") {
                    if (!print) {
                        var url = "${createLink(action: 'intervencionReporteWeb')}?tipo=" + elems + "&anio=" + $("#anio").val();
                        window.open(url, "_blank");
                    } else {
                        var url = "${createLink(action: 'intervencionReportePDF')}?tipo=" + elems + "Wanio=" + $("#anio").val();
                        location.href = "${createLink(controller:'pdf',action:'pdfLink')}?url=" + url
                    }
                } else {
                    $("#spnAlert").html("Escoja una opción para generar el reporte.");
                    $("#dlgAlert").dialog("open");
                    return false;
                }
            }

            $(function() {

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
            });
        </script>
    </body>
</html>