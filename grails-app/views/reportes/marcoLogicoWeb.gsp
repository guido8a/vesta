<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 1/30/12
  Time: 11:04 AM
  To change this template use File | Settings | File Templates.
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <meta name="layout" content="main"/>
        <title>Marco l&oacute;gico de proyecto</title>
        <style type="text/css">
        @page {
            size   : 29.7cm 21cm;  /*width height */
            margin : 2cm;
        }

        .hoja {
            width : 25.7cm;
        }

        .titulo {
            width : 25.7cm;
        }

        .hoja {
            /*background  : #e6e6fa;*/
            height      : 17cm; /*29.7-(1.5*2)*/
            font-family : arial;
            font-size   : 10pt;
        }

        .titulo {
            font-size     : 16pt;
            font-weight   : bold;
            text-align    : center;
            margin-bottom : .5cm;
            /*background    : #7fffd4;*/
        }

        tbody tr:nth-child(2n+1), tbody tr:nth-child(2n) {
            background : none;
        }
        </style>
    </head>

    <body>
        %{--<g:render template="marcoLogico"/>--}%

        ${tabla}

    </body>
</html>