<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 13/08/14
  Time: 04:23 PM
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <title>Imprimir solicitud</title>

        <rep:estilos orientacion="p" pagTitle="Aval de POA"/>

        <style type="text/css">
        .totales {
            font-weight : bold;
        }

        .num {
            text-align : right;
        }

        .header {
            background : #333333 !important;
            color      : #AAAAAA;
        }

        .total {
            background : #000000 !important;
            color      : #FFFFFF !important;
        }

        th {
            background : #cccccc;
        }

        tbody tr:nth-child(2n+1) {
            background : none repeat scroll 0 0 #E1F1F7;
        }

        tbody tr:nth-child(2n) {
            background : none repeat scroll 0 0 #F5F5F5;
        }

        .label {
            font-weight : bold;
        }

        .ui-widget-header {
            font-weight : bold;
        }

        .ttl {
            text-align  : center;
            font-weight : bold;
        }

        .fecha {
            text-align : right;
            margin-top : 1cm;
        }
        </style>
    </head>

    <body>

        <rep:headerFooter title="Solicitud de contratación"/>
        <slc:infoReporte solicitud="${solicitud}"/>
        <div class="fecha">
            Quito, ${solicitud.fecha?.format("dd-MM-yyyy")}
        </div>
        <slc:firmasReporte firmas="${firmas}"/>

    </body>
</html>