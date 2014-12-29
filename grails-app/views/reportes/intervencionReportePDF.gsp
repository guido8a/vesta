<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 9/16/11
  Time: 11:35 AM
  To change this template use File | Settings | File Templates.
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <title>Intervención e inversión en el año ${anio}</title>

        <style type="text/css">
        @page {
            size   : 21cm 29.7cm;  /*width height */
            margin : 2cm;
        }

        .hoja {
            width : 17cm;
        }

        .titulo {
            width : 15.5cm;
        }

        .hoja {
            /*background  : #e6e6fa;*/
            height      : 24.7cm; /*29.7-(1.5*2)*/
            font-family : arial;
            font-size   : 9.5pt;
        }

        .titulo {
            height        : .5cm;
            font-size     : 16pt;
            font-weight   : bold;
            text-align    : center;
            margin-bottom : .5cm;
        }

        .totales {
            font-weight : bold;
        }

        .num {
            text-align : right;
        }

        .fila_0 {
            background : #6985AE !important;
        }

        .fila_1 {
            background : #8C6AB1 !important;
        }

        .fila_2 {
            background : #E7E083 !important;
        }

        .fila_3 {
            background : #E7C283 !important;
        }

        .total_0 {
            background : #475F81 !important;
        }

        .total_1 {
            background : #654884 !important;
        }

        .total_2 {
            background : #C3BD64 !important;
        }

        .total_3 {
            background : #C3A064 !important;
        }

        .header {
            background : #333333 !important;
            color      : #AAAAAA;
        }

        .total {
            background : #000000 !important;
            color      : #FFFFFF !important;
        }
        </style>

    </head>

    <body>
        <div class="hoja">
            <div class="titulo">
                Intervención e inversión en el año ${anio}
            </div>

            ${tabla}

        </div>

    </body>
</html>