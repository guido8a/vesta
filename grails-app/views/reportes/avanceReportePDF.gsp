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
        <title>Avance de proyectos con indicadores y metas</title>

        <style type="text/css">
        @page {
            size   : 21cm 29.7cm;  /*width height */
            margin : 2cm;
        }

        .hoja {
            width : 16.5cm;
        }

        .titulo, .proyecto, .componente {
            width : 16cm;
        }

        .meta {
            width : 15.5cm;
        }

        .avance {
            width : 14.7cm;
        }

        .hoja {
            /*background  : #e6e6fa;*/
            height      : 24.7cm; /*29.7-(1.5*2)*/
            font-family : arial;
            font-size   : 11pt;
        }

        .titulo {
            height        : .5cm;
            font-size     : 16pt;
            font-weight   : bold;
            text-align    : center;
            margin-bottom : .5cm;
        }

        .proyecto {
            /*background    : #fffacd;*/
            margin-bottom : .35cm;
            border        : solid 1px #404040;
            padding       : .25cm;
        }

        .nombreProyecto {
            /*background  : #6495ed;*/
            font-weight   : bold;
            text-align    : center;
            font-size     : 13pt;
            border-bottom : solid 1px #d0d0d0;
        }

        .componente, .meta {
            margin-bottom : .15cm;
        }

        .nombreComponente {
            /*background : #7cfc00;*/
            font-size : 12pt;
        }

        .componente {
            /*background : #add8e6;*/
            margin-top : 0.5cm;
        }

        .meta {
            /*background  : #ffb6c1;*/
            margin-left : 0.5cm;
            margin-top  : 0.2cm;
        }

        .nombreMeta {
            /*background : #8b008b;*/
        }

        .avance {
            /*background  : #ff4500;*/
            font-size   : 10.5pt;
            margin-left : 0.8cm;
            margin-top  : 0.1cm;
        }
        </style>

    </head>

    <body>
        <div class="hoja">
            <g:render template="avance" collection="${resultados}"/>
        </div>
    </body>
</html>