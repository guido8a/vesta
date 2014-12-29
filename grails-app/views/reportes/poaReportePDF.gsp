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
            Proyectos por unidad ejecutora
        </title>

        <style type="text/css">
        @page {
            size   : 29.7cm 21cm;  /*width height */
            margin : 2cm;
        }

        .hoja {
            width : 25cm;
        }

        .titulo {
            width : 25cm;
        }

        .hoja {
            /*background  : #e6e6fa;*/
            height      : 16cm; /*29.7-(1.5*2)*/
            font-family : arial;
            font-size   : 10pt;
        }

        table {
            border-collapse : collapse;
        }

        th {
            background : #cccccc;
            text-align : center;
        }

        tbody tr:nth-child(2n+1) {
            background : none repeat scroll 0 0 #E1F1F7;
        }

        tbody tr:nth-child(2n) {
            background : none repeat scroll 0 0 #F5F5F5;
        }
        </style>
    </head>

    <body>
        <div class="hoja">
            <g:render template="poa" collection="${unidades}"/>
        </div>
    </body>
</html>