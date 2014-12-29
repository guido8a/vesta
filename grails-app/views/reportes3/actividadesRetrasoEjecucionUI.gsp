<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 26/11/14
  Time: 12:01 PM
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main"/>
        <title>Actividades con retraso de ejecución</title>

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

        <h2>Actividades con retraso de ejecución</h2>

        <div class="fila">
            Fecha: <g:textField name="fecha" class="datepicker ui-widget-content ui-corner-all"
                                value="${new Date().format('dd-MM-yyyy')}" readonly="readonly"/>
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
                        var url = "${createLink(controller: 'reportes3', action: 'actividadesRetrasoEjecucion')}?fecha=" + fecha;
                        location.href = "${createLink(controller:'pdf',action:'pdfLink')}?url=" + url
                    }
                });

            });
        </script>
    </body>
</html>