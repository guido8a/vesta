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
    <link rel="stylesheet" href="${resource(dir: 'js/jquery/css/start', file: 'jquery-ui-1.8.16.custom.css')}"/>
    <title>
        Reporte de distribuciones
    </title>

    <style type="text/css">
    @page {
        size   : 29.7cm 21cm;  /*width height */
        margin : 2cm;
    }

    .hoja {
        width : 25.7cm;
    }

    .titulo {
        width : 800px;
        text-align: center;
        font-size: 14px;
        font-weight: bold;
        height: 30px;
    }

    .hoja {
        /*background  : #e6e6fa;*/
        height      : 17cm; /*29.7-(1.5*2)*/
        font-family : arial;
        font-size   : 10pt;
    }

    th {
        background : #cccccc;
    }

   .odd{
        background : none repeat scroll 0 0 #E1F1F7;
    }

    .even {
        background : none repeat scroll 0 0 #F5F5F5;
    }
    </style>
</head>

<body>
<div class="hoja" style="font-size: 12px">

    <div class="titulo" style="margin-bottom: 5px;">Reporte del total de asignaciones para el año: ${actual}</div>
    <table width="800">
        <thead>
        <th class="ui-state-default" style="width: 460px">Unidad</th>
        <th class="ui-state-default" style="width: 60px;">Código</th>
        <th class="ui-state-default">Inversión</th>
        <th class="ui-state-default">Corriente</th>

        </thead>
        <tbody>
        <g:set var="totC" value="${0}"></g:set>
        <g:set var="totI" value="${0}"></g:set>
        <g:each in="${mapa}" var="mp" status="i">
            <tr class="${(i%2)==0?'even':'odd'}">
                <td>
                    ${mp.key}
                </td>
                <td style="text-align: center">
                    ${mp.value.getAt(0)}
                </td>
                <td style="text-align: right">
                    <g:formatNumber number="${mp.value.getAt(1)}" format="###,##0" minFractionDigits="2" maxFractionDigits="2"/>
                    <g:set var="totI" value="${totI.toDouble()+mp.value.getAt(1).toDouble()}"></g:set>
                </td>
                <td style="text-align: right">
                    <g:formatNumber number="${mp.value.getAt(2)}" format="###,##0" minFractionDigits="2" maxFractionDigits="2"/>
                    <g:set var="totC" value="${totC.toDouble()+mp.value.getAt(2).toDouble()}"></g:set>
                </td>
            </tr>
        </g:each>
        <tr>
            <td style="font-weight: bold" colspan="2">
                TOTAL
            </td>
            <td style="text-align: right;font-weight: bold">
                <g:formatNumber number="${totI}" format="###,##0" minFractionDigits="2" maxFractionDigits="2"/>
            </td>
            <td style="text-align: right;font-weight: bold">
                <g:formatNumber number="${totC}" format="###,##0" minFractionDigits="2" maxFractionDigits="2"/>
            </td>
        </tr>
        </tbody>
    </table>



</div>
</body>
</html>