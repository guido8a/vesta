<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 26/11/14
  Time: 12:01 PM
--%>

<%@ page import="vesta.avales.ProcesoAval; vesta.avales.ProcesoAval; vesta.avales.ProcesoAval; vesta.avales.ProcesoAval; vesta.avales.ProcesoAval; vesta.avales.ProcesoAval" contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main"/>
        <title>Subactividades por proceso</title>

        <style type="text/css">
        .datepicker {
            width : 90px;
        }
        </style>
    </head>

    <body>
        <g:if test="${flash.message}">
            <div class="message ui-state-highlight ui-corner-all">
                ${flash.message}
            </div>
        </g:if>

        <h2>Subactividades por proceso</h2>

        <div class="fila" style="margin-bottom: 15px;">
            Fecha: <g:textField name="fecha" class="datepicker ui-widget-content ui-corner-all"
                                value="${new Date().format('dd-MM-yyyy')}" readonly="readonly"/>
        </div>

        <div class="fila">
            Proceso: <g:select from="${vesta.avales.ProcesoAval.list([sort: 'nombre'])}" class="ui-widget-content ui-corner-all"
                               optionKey="id" optionValue="nombre" name="proc"/>
        </div>

        <div class="fila" style="margin-top: 20px;">
            <a href="#" class="btn">Ver</a>
        </div>

        <script type="text/javascript">
            $(function () {
                $(".datepicker").datepicker({
                    changeMonth : true,
                    changeYear  : true,
                    dateFormat  : 'dd-mm-yy',
                    maxDate     : "+0"
                });

                $(".btn").button({
                    icons : {
                        primary : "ui-icon-print"
                    }
                }).click(function () {
                    var fecha = $.trim($("#fecha").val());
                    if (fecha.trim() == "") {
                        $.box({
                            imageClass : "box_info",
                            text       : "Por favor ingrese una fecha",
                            title      : "Alerta",
                            iconClose  : false,
                            dialog     : {
                                resizable     : false,
                                draggable     : false,
                                closeOnEscape : false,
                                buttons       : {
                                    "Aceptar" : function () {
                                    }
                                }
                            }
                        });
                    } else {
                        var url = "${createLink(controller: 'reportes3', action: 'subactividadesPorProceso')}?fecha=" + fecha + "Wid=" + $("#proc").val();
                        location.href = "${createLink(controller:'pdf',action:'pdfLink')}?url=" + url
                    }
                });

            });
        </script>
    </body>
</html>