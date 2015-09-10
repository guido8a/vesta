<%--
  Created by IntelliJ IDEA.
  User: fabricio
  Date: 31/08/15
  Time: 10:16 AM
--%>


<%@ page import="vesta.avales.ProcesoAsignacion" contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>POA GASTO PERMANENTE POR ÁREA ADMINISTRATIVA</title>

    <rep:estilos orientacion="l" pagTitle="POA GASTO PERMANENTE POR ÁREA DE GESTIÓN"/>

    <style type="text/css">
    .table {
        margin-top      : 0.5cm;
        width           : 100%;
        border-collapse : collapse;
    }

    .table, .table td, .table th {
        border : solid 1px #444;
    }

    .table td, .table th {
        padding : 3px;
    }

    .text-right {
        text-align : right;
    }

    h1.break {
        page-break-before : always;
    }

    small {
        font-size : 70%;
        color     : #777;
    }

    .table th {
        background     : #326090;
        color          : #fff;
        text-align     : center;
        text-transform : uppercase;
    }

    .actual {
        background : #c7daed;
    }

    .info {
        background : #6fa9ed;
    }

    .text-right {
        text-align : right !important;
    }

    .text-center {
        text-align : center;
    }
    </style>

</head>

<body>
<div class="hoja">
    <rep:headerFooter title="POA GASTO PERMANENTE POR ÁREA ADMINISTRATIVA" estilo="right" unidad="${unidad}"/>

    <p>
        Fecha del reporte: ${new java.util.Date().format("dd-MM-yyyy HH:mm")}
    </p>


    <table class="table table-bordered table-hover table-condensed table-bordered">
        <thead>
        <tr>
            <th style="width: 200px">Área Administrativa</th>
            <th style="width: 150px">Total Unidad</th>

        </tr>
        </thead>
        <tbody>

        <g:set var="totales" value="${0}"/>

        <g:each in="${mapa}" var="map">
            <tr>
                    <td style="width: 200px">${map.value.unidad}</td>

                    <td style="width: 100px; text-align: right"><g:formatNumber number="${map.value.total.toDouble()}"
                                                             format="###,##0"
                                                             minFractionDigits="2" maxFractionDigits="2"/></td>
                 <g:set var="totales" value="${totales += map.value.total.toDouble()}"/>
            </tr>
        </g:each>

        <tr>
            <td style="font-weight: bold; text-align: right">
                TOTAL:
            </td>

            <td style="width: 100px; text-align: right; font-weight: bold"><g:formatNumber number="${totales.toDouble()}"
                                                     format="###,##0"
                                                     minFractionDigits="2" maxFractionDigits="2"/>
            </td>
        </tr>

        </tbody>
    </table>
</div>
</body>
</html>