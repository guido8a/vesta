<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 10/10/11
  Time: 3:50 PM
  To change this template use File | Settings | File Templates.
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <title>
            Ejecución presupuestaria
        </title>

        <style type="text/css">
        @page {
            size   : 29.7cm 21cm;  /*width height */
            margin : 2cm;
        }

        .hoja {
            width : 24.7cm;
        }

        .titulo {
            width : 24.7cm;
        }

        .hoja {
            /*background  : #e6e6fa;*/
            height      : 17cm; /*29.7-(1.5*2)*/
            font-family : arial;
            font-size   : 10pt;
        }

        table {
            border-collapse : collapse;
            border          : solid 1px #000000;
        }

        th {
            background : #cccccc;
        }

        </style>
    </head>

    <body>
        <div class="hoja">
           ${tabla}
        </div>
    </body>
</html>