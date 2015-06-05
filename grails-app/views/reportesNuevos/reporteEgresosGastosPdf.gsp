<%--
  Created by IntelliJ IDEA.
  User: fabricio
  Date: 05/06/15
  Time: 11:24 AM
--%>
<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 9/16/11
  Time: 11:35 AM
  To change this template use File | Settings | File Templates.
--%>

<%@ page import="vesta.avales.ProcesoAsignacion" contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>REPORTE PROFORMA DE EGRESOS NO PERMANENTES - GRUPO DE GASTO </title>

    <rep:estilos orientacion="p" pagTitle="REPORTE PROFORMA DE EGRESOS NO PERMANENTES - GRUPO DE GASTO"/>

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
    <rep:headerFooter title="Egresos permanentes - grupo de gastos" estilo="right"/>

    <p>
        Fecha del reporte: ${new java.util.Date().format("dd-MM-yyyy HH:mm")}
    </p>


    <table class="table table-bordered table-hover table-condensed table-bordered">
        <thead>
        <tr>
            <th class="text-center">
                GRUPO PRESUPUESTARIO
            </th>
            <th class="text-center">
                GRUPO DE GASTOS
            </th>
            <g:each in="${anios}" var="a">
                <th>Año${a}</th>
            </g:each>
        </tr>
        </thead>
        <tbody>
        <g:each in="${data}" var="v">
            <tr>
                <td class="text-center">${v.partida.numero.replaceAll("0", "")}</td>
                <td>${v.partida.descripcion}</td>
                <g:each in="${anios}" var="a">
                    <td>
                        <g:formatNumber number="${v.valores[a] ?: 0}" type="currency" currencySymbol=""/>
                    </td>
                </g:each>
            </tr>
        </g:each>
        </tbody>
        <tfoot>
        <tr>
            <th></th>
            <th class="text-right">TOTAL</th>
            <g:each in="${anios}" var="a">
                <th class="text-right"><g:formatNumber number="${totales[a] ?: 0}" type="currency" currencySymbol=""/></th>
            </g:each>
        </tr>
        </tfoot>
    </table>

</div>


</body>
</html>