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
        Reasignacion del año:${anio}
    </div>


    <table style="width: 14cm;font:11px" border="1">
        <thead>
        <th>Código</th>
        <th>Nombre</th>
        <th>Asignado</th>
        <th>Original</th>
        <th>PAPP</th>
        <th>Diferencia</th>
        </thead>
        <tbdoy>
            <tr>
                <td>GG</td>
                <td>Viceministerio</td>
                <td class="num"><g:formatNumber number="${asignado99}" format="###,##0" minFractionDigits="2" maxFractionDigits="2"/></td>
                <td class="num"><g:formatNumber number="${original99}" format="###,##0" minFractionDigits="2" maxFractionDigits="2"/></td>
                <td class="num"><g:formatNumber number="${poa99}" format="###,##0" minFractionDigits="2" maxFractionDigits="2"/></td>
                <td class="num"><g:formatNumber number="${asignado99-original99}" format="###,##0" minFractionDigits="2" maxFractionDigits="2"/></td>
            </tr>
            <g:each in="${datos}" var="u">
                <tr>
                    <td >${u[0]}</td>
                    <td>${u[1]}</td>
                    <td class="num"><g:formatNumber number="${u[2]}" format="###,##0" minFractionDigits="2" maxFractionDigits="2"/></td>
                    <td class="num"><g:formatNumber number="${u[3]}" format="###,##0" minFractionDigits="2" maxFractionDigits="2"/></td>
                    <td class="num"><g:formatNumber number="${u[4]}" format="###,##0" minFractionDigits="2" maxFractionDigits="2"/></td>
                    <td class="num"><g:formatNumber number="${u[2]-u[3]}" format="###,##0" minFractionDigits="2" maxFractionDigits="2"/></td>
                </tr>
            </g:each>
            <tr>
                <td><b>TOTAL</b></td>
                <td></td>
                <td><g:formatNumber number="${totalAsg}" format="###,##0" minFractionDigits="2" maxFractionDigits="2"/></td>
                <td><g:formatNumber number="${totalOrg}" format="###,##0" minFractionDigits="2" maxFractionDigits="2"/></td>
                <td><g:formatNumber number="${totalPoa}" format="###,##0" minFractionDigits="2" maxFractionDigits="2"/></td>
                <td><g:formatNumber number="${totalAsg-totalOrg}" format="###,##0" minFractionDigits="2" maxFractionDigits="2"/></td>
            </tr>
        </tbdoy>
    </table>

</div>

</body>
</html>