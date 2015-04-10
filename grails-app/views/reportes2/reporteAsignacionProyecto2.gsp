<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 09/04/15
  Time: 03:50 PM
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <title>Reporte de Asignaciones del Proyecto</title>
        <rep:estilos orientacion="l" pagTitle="Proyecto: ${proyecto.nombre}"/>
        <style type="text/css">
        .titulo2 {
            min-height : 15px;
            font-size  : 14pt;
            text-align : left;
            width      : 100%;
        }

        th {
            background : #cccccc;
            text-align : center;
        }

        ol {
            counter-reset : item;
            padding       : 0;
        }

        ol li {
            display       : block;
            margin-bottom : 15px;
        }

        ol li:before {
            content           : counter(item) ". ";
            counter-increment : item;
            font-weight       : bold;
        }

        .valor {
            text-align : right;
        }

        td {
            text-align : center;
        }

        table {
            border-collapse : collapse;
            font-size       : 9pt;
        !important;
            width           : 100%;
        }

        table, table td, table th {
            border    : solid 1px #444;
            font-size : 10pt;
        !important;
        }


        </style>
    </head>

    <body>

        <rep:headerFooter titulo="Proyecto: ${proyecto.nombre}"/>

        <div class="titulo2" style="margin-top: 2px">Plan Operativo: ${actual?.anio}<span style="margin-left: 2cm">CÓDIGO DE PROYECTO: ${proyecto.codigo}</span>
        </div>

        <table style="width: 25.4cm;">
            <thead>
                <tr>
                    <th rowspan="2" style="width: 3.0cm">Componente</th>
                    <th rowspan="2" style="text-align: center;width: 0.6cm">#</th>
                    <th rowspan="2" style="width: 10.2cm">Actividad</th>
                    <th rowspan="2" style="width: 4.0cm">Responsable</th>
                    <th rowspan="2" style="width: 1.8cm">Fecha Inicio / Fecha Fin</th>
                    <th rowspan="2">Partida</th>
                    <th colspan="${anios.size()}">Planificado</th>
                    <th rowspan="2">Priorización</th>
                </tr>
                <tr>
                    <g:each in="${anios}" var="anio">
                        <th>${anio}</th>
                    </g:each>
                </tr>
            </thead>
            <tbody>
                <g:set var="total" value="${0}"/>
                <g:set var="totalP" value="${0}"/>
                <g:each in="${data}" var="asg" status="i">
                    <g:each in="${asg.value}" var="v1">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                            <td class="dscr" style="text-align: left">
                                ${v1.value.ml.marcoLogico.toStringCompleto()}
                            </td>
                            <td>
                                ${v1.value.ml.numero}
                            </td>
                            <td class="dscr" style="text-align: left">
                                ${v1.value.ml.toStringCompleto()}
                            </td>
                            <td style="text-align: left">
                                ${v1.value.un.toString()}
                            </td>
                            <td style="text-align: left">
                                ${v1.value.ml.fechaInicio?.format("dd-MM-yyyy")} / ${v1.value.ml.fechaFin?.format("dd-MM-yyyy")}
                            </td>
                            <td>
                                ${v1.value.pa}
                            </td>
                            <g:each in="${anios}" var="anio">
                                <td class="valor" style="text-align: right">
                                    <g:formatNumber number="${v1.value.anios[anio] ? v1.value.anios[anio].getValorReal() : '0'}" type="currency" currencySymbol=""/>
                                </td>
                            </g:each>
                            <td class="agr" style="text-align: right">
                                <g:formatNumber number="${v1.value.prio}" type="currency" currencySymbol=""/>
                            </td>
                        </tr>
                    </g:each>
                </g:each>
            </tbody>
            <tfoot>
                <tr>
                    <th colspan="6"><b>TOTAL</b></th>
                    <g:each in="${anios}" var="anio">
                        <th class="valor" style="text-align: center; font-weight: bold; border-top : solid 1px #000000;">
                            <g:formatNumber number="${totalesAnios[anio]}" type="currency" currencySymbol=""/>
                        </th>
                    </g:each>
                    <th class="valor" style="text-align: right; font-weight: bold; border-top : solid 1px #000000;">
                        <g:formatNumber number="${totalPriorizado}" type="currency" currencySymbol=""/>
                    </th>
                </tr>
            </tfoot>

        </table>
    </body>
</html>