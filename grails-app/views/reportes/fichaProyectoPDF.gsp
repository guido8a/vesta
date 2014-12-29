<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 9/16/11
  Time: 11:35 AM
  To change this template use File | Settings | File Templates.
--%>

<html>
    <head>
        <title>Ficha de proyecto</title>

        <style type="text/css">
        @page {
            size   : 29.7cm 21cm;  /*width height */
            margin : 2cm;
        }

        .hoja {
            width : 25.2cm;
        }

        .titulo, .proyecto, .componente {
            width : 25.2cm;
        }

        .hoja {
            /*background  : #e6e6fa;*/
            height      : 17cm; /*29.7-(1.5*2)*/
            font-family : arial;
            font-size   : 10pt;
        }

        .titulo {
            height        : .5cm;
            font-size     : 16pt;
            font-weight   : bold;
            text-align    : center;
            margin-bottom : .5cm;
        }

        .tabla {
            /*border-collapse : collapse;*/
            /*border-color    : #8a8a8a;*/
        }

        .proyecto {
            /*background    : #fffacd;*/
            margin-bottom : .35cm;
            border        : solid 1px #404040;
            /*padding       : .25cm;*/
        }

        .nombreArea {
            background  : #d0d0d0;
            font-weight : bold;
            font-size   : 12pt;
            /*padding     : 3px;*/
        }

        tbody tr:nth-child(even) {
            background : #f5f5f5;
        }

        tbody tr:nth-child(odd) {
            background : #e5e5e5;
        }

        </style>
    </head>

    <body>
        <div class="hoja">
            <g:render template="fichaProyecto" collection="${proyectos}"/>
        </div>
    </body>
</html>