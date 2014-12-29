<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 1/6/12
  Time: 3:25 PM
  To change this template use File | Settings | File Templates.
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <title>
            Usuarios
        </title>

        <style type="text/css">
        @page {
            size   : 21cm 29.7cm;  /*width height */
            margin : 2cm;
        }

        .hoja {
            width :630px;
        }

        .titulo {
            width : 16cm;
        }

        .hoja {
            /*background  : #e6e6fa;*/
            height      : 26cm; /*29.7-(1.5*2)*/
            font-family : arial;
            font-size   : 11px;
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

        table {
            border-collapse : collapse;
        }
        </style>
    </head>

    <body>
        <div class="hoja">
            <h1 style="text-align: center">Reporte de usuarios</h1>
            <g:render template="usuarios"/>
        </div>
    </body>
</html>