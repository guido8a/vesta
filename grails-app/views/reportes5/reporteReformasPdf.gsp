<%--
  Created by IntelliJ IDEA.
  User: fabricio
  Date: 10/06/15
  Time: 03:18 PM
--%>

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
    <title>REPORTE DE REFORMAS Y AJUSTES </title>

    <rep:estilos orientacion="l" pagTitle="REPORTE DE REFORMAS Y AJUSTES"/>

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
    <rep:headerFooter title="REPORTE DE REFORMAS Y AJUSTES" estilo="right"/>

    <p>
        Fecha del reporte: ${new java.util.Date().format("dd-MM-yyyy HH:mm")}
    </p>


    <table class="table table-bordered table-hover table-condensed table-bordered">
        <thead>
        <tr>

            <th class="text-center">
               C
            </th>
            <th class="text-center">
               P
            </th>
            <th class="text-center">
                #
            </th>
            <th class="text-center">
                ACTIVIDAD
            </th>
            <th class="text-center">
                VALOR INICIAL
            </th>
            <th class="text-center">
                INCREMENTO
            </th>
            <th class="text-center">
                REDUCCIÓN
            </th>
            <th class="text-center">
                VALOR CODIFICADO
            </th>

        </tr>
        </thead>
        <tbody>
        <g:each in="${modificacion}" var="m">
            <tr>
                <td>${m?.desde?.componente?.descripcion}</td>
                <td>${m?.desde?.programa?.descripcion}</td>
                <td>${m?.desde?.marcoLogico?.numero}</td>
                <td>${m?.desde?.marcoLogico?.toStringCompleto()}</td>
                <td>${m?.originalOrigen}</td>
                <td>${m?.valor}</td>
                <td></td>
                <td>${m?.originalOrigen+m?.valor}</td>
            </tr>
            <tr>
                <td>${m?.recibe?.componente?.descripcion}</td>
                <td>${m?.recibe?.programa?.descripcion}</td>
                <td>${m?.recibe?.marcoLogico?.numero}</td>
                <td>${m?.recibe?.marcoLogico?.toStringCompleto()}</td>
                <td>${m?.originalDestino}</td>
                <td></td>
                <td>${m?.valor}</td>
                <td>${m?.originalDestino - m?.valor}</td>
            </tr>

        </g:each>
        </tbody>
        <tfoot>
        <tr>
            <th></th>
            <th></th>
            <th></th>
            <th>TOTAL</th>
            <th><g:formatNumber number="${totalInicial}" maxFractionDigits="2" minFractionDigits="2"/></th>
            <th></th>
            <th></th>
            <th><g:formatNumber number="${totalFinal}" maxFractionDigits="2" minFractionDigits="2"/></th>
        </tr>
        </tfoot>
    </table>
</div>
</body>
</html>