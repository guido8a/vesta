<%--
  Created by IntelliJ IDEA.
  User: fabricio
  Date: 08/06/15
  Time: 12:45 PM
--%>

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
    <title>PROFORMA PRESUPUESTARIA DE RECURSOS NO PERMANENTES </title>

    <rep:estilos orientacion="l" pagTitle="PROFORMA PRESUPUESTARIA DE RECURSOS NO PERMANENTES"/>

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
    <rep:headerFooter title="PROFORMA PRESUPUESTARIA DE RECURSOS NO PERMANENTES" estilo="right"/>

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
            <th class="text-center">
                FUENTE
            </th>
            <th class="text-center">
                PRESUPUESTO CODIFICADO
            </th>
            <th class="text-center">
               PROFORMA AÑO
            </th>
            <th class="text-center">
                PARTICIPACIÓN
            </th>
            <th class="text-center">
                ABSOLUTA
            </th>
            <th class="text-center">
               %
            </th>

        </tr>
        </thead>
        <tbody>
        <g:each in="${data}" var="v">
            <g:set var="anterior" value="${v.valores["" + (anio.anio.toInteger() -1)]?:0}"/>
            <g:set var="actual" value="${v.valores[anio.anio]?:0}"/>
            <g:set var="totalActual" value="${totales[anio.anio]?:0}"/>
            <g:set var="totalResta" value="${totales.resta}"/>
            <g:set var="porcentaje1" value="${(actual*100)/totalActual}"/>
            <g:set var="resta" value="${actual -anterior}"/>
            <g:set var="porcentaje2" value="${(resta*100)/totalResta}"/>
            <tr>
                <td class="text-center">${v.partida.numero.replaceAll("0", "")}</td>
                <td>${v.partida.descripcion}</td>
                <td>${v.fuente.descripcion}</td>
                <td>${anterior}</td>
                <td>${actual}</td>
                <td>${porcentaje1}</td>
                <td>${resta}</td>
                <td>${porcentaje2}</td>
            </tr>
        </g:each>
        </tbody>
        <tfoot>
        <tr>
            <th>TOTAL</th>
            <th></th>
            <th></th>
            <th>${totales["" + (anio.anio.toInteger() -1)] ?: 0}</th>
            <th>${totales[anio.anio] ?: 0}</th>
            <th>${100}</th>
            <th>${totales.resta}</th>
            <th>${100}</th>

        </tr>
        </tfoot>
    </table>

</div>


</body>
</html>