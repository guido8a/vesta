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
                Año
            </th>
            <th class="text-center">
                #
            </th>
            <th class="text-center">
                ACTIVIDAD
            </th>
            <th class="text-center">
                PARTIDA
            </th>
            <th class="text-center">
                REF.
            </th>
            <th class="text-center">
                AJS.
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
                <td>${m?.anio}</td>
                <td>${m?.nmro}</td>
                <td>${m?.actv}</td>
                <td>${m?.prsp}</td>
                <td>${m?.rfrm}</td>
                <td>${m?.ajst}</td>
                <td>${m?.vlin}</td>
                <td>${m?.incr}</td>
                <td>${m?.decr}</td>
                <td>${m?.prcl}</td>
            </tr>
        </g:each>
        </tbody>
        <tfoot>
        <tr>
            <th></th>
            <th></th>
            <th></th>
            <th>TOTAL</th>
            <th></th>
            <th></th>
            <th></th>
            <th><g:formatNumber number="${totalInicial}" maxFractionDigits="2" minFractionDigits="2"/></th>
            <th><g:formatNumber number="${totalFinal}" maxFractionDigits="2" minFractionDigits="2"/></th>
            <th></th>
        </tr>
        </tfoot>
    </table>
</div>
</body>
</html>