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
    </style>

</head>

<body>
<div class="hoja">
    <div class="titulo">
        Asignaciones del año:${anio}
    </div>


    <table style="width: 700px;font:11px" border="1">
        <thead>
        <th></th>
        <th style="width: 200px;">Unidad</th>
        <th>Código</th>
        <th>Asignado</th>
        <th>Partida</th>
        </thead>
        <tbdoy>
            <g:each in="${resultados}" var="r">
                <tr>
                    <td>${r[0]}</td>
                    <td style="width: 200px;">${r[1]}</td>
                    <td>${r[4]}</td>
                    <td class="num"><g:formatNumber number="${r[3]}" format="###,##0" minFractionDigits="2" maxFractionDigits="2"/></td>
                    <td>${r[2]}</td>
                </tr>
            </g:each>
            <tr>
                <td></td>
                <td style="width: 200px;"><b>TOTAL</b></td>
                <td></td>
                <td><g:formatNumber number="${total}" format="###,##0" minFractionDigits="2" maxFractionDigits="2"/></td>
                <td></td>
            </tr>

        </tbdoy>
    </table>

</div>

</body>
</html>