<%--
  Created by IntelliJ IDEA.
  User: fabricio
  Date: 28/08/15
  Time: 11:52 AM
--%>

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
    <title>REPORTE DE GASTO PERMANENTE </title>

    <rep:estilos orientacion="l" pagTitle="REPORTE DE GASTO PERMANENTE"/>

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
    <rep:headerFooter title="REPORTE DE GASTO PERMANENTE" estilo="right"/>

    <p>
        Fecha del reporte: ${new java.util.Date().format("dd-MM-yyyy HH:mm")}
    </p>


    <table class="table table-bordered table-hover table-condensed table-bordered">
        <thead>
        <tr>
            <th style="width: 200px">Responsable</th>
            <th style="width: 250px">Objetivo</th>
            <th style="width: 150px">Macro Actividad</th>
            <th style="width: 150px">Actividad</th>
            <th style="width: 100px">Tarea</th>
            <th style="width: 80px">#</th>
            <th style="width: 100px;">Partida</th>
            <th style="width: 80px">Fuente</th>
            <th style="width: 100px">Presupuesto</th>
        </tr>
        </thead>
        <tbody>


        <g:each in="${asignaciones}" var="asg">
            <g:set var="objTitle" value="${asg.tarea.actividad.macroActividad.objetivoGastoCorriente.descripcion}"/>
            <g:set var="obj" value="${objTitle.size() > 80 ? objTitle[0..79] + '…' : objTitle}"/>
            <tr data-res="${asg?.unidad?.id}" data-asi="${asg?.actividad}" data-par="${asg?.presupuesto?.descripcion}"
                data-parId="${asg?.presupuesto?.id}" data-fue="${asg?.fuente?.id}" data-val="${asg?.planificado}" data-id="${asg?.id}" data-obj="${asg?.tarea?.actividad?.macroActividad?.objetivoGastoCorriente?.id}"
                data-mac="${asg?.tarea?.actividad?.macroActividad?.id}" data-act="${asg?.tarea?.actividad?.id}" data-tar="${asg?.tarea?.id}">
                <td style="width: 200px">${asg?.unidad?.nombre}</td>
                <td style="width: 200px" title="${objTitle}">${obj}</td>
                <td style="width: 150px">${asg?.tarea?.actividad?.macroActividad?.descripcion}</td>
                <td style="width: 150px">${asg?.tarea?.actividad?.descripcion}</td>
                <td style="width: 100px">${asg?.tarea?.descripcion}</td>
                %{--<td style="width: 250px">${asg?.actividad}</td>--}%
                <td style="width: 80px;">${asg?.presupuesto?.numero}</td>
                <td style="width: 100px;">${asg?.presupuesto?.descripcion}</td>
                <td style="width: 80px">${asg?.fuente?.codigo}</td>
                %{--<td style="width: 100px">${asg?.planificado}</td>--}%
                <td style="width: 100px"><g:formatNumber number="${asg?.planificado.toDouble()}"
                                                         format="###,##0"
                                                         minFractionDigits="2" maxFractionDigits="2"/></td>
            </tr>
        </g:each>

        </tbody>
        <tfoot>
        <tr>
        </tr>
        </tfoot>
    </table>
</div>
</body>
</html>