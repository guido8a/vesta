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
        <style type="text/css">
        @font-face {
            font-family : 'Arial';
            src         : url('${resource(dir:"fontPdf", file: "arial.ttf")}');
        }

        @page {
            size   : 21cm 29.7cm;  /*width height */
            margin : 2cm;
        }

        body {
            font-family : Arial, arial, arial-black, sans-serif;
            font-size   : 10pt;
        }

        .hoja {
            width     : 15cm;
            font-size : 12pt;
        }

        .titulo {
            width : 15.5cm;
        }

        .hoja {
            /*background  : #fedcba;*/
            height      : 24.7cm; /*29.7-(1.5*2)*/
            font-family : arial;
            font-size   : 12pt;
        }

        .titulo {
            height        : 130px;
            font-size     : 12pt;
            /*font-weight   : bold;*/
            text-align    : center;
            margin-bottom : 5px;
            width         : 95%;
        }

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
        <div class="hoja">
            <slc:headerReporte title="Solicitud de contratación"/>
            <slc:infoReporte solicitud="${solicitud}"/>
            <div class="fecha">
                Quito, ${solicitud.fecha?.format("dd-MM-yyyy")}
            </div>
            <slc:firmasReporte firmas="${firmas}"/>
        </div>
    </body>
</html>