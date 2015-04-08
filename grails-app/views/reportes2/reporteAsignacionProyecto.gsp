<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 26/11/14
  Time: 11:59 AM
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <title>Reporte de Asignaciones del Proyecto</title>
        <rep:estilos orientacion="l" pagTitle="Proyecto: ${proyecto.nombre}"/>
        <style type="text/css">
        .titulo2 {
            min-height    : 15px;
            font-size     : 14pt;
            /*font-weight   : bold;*/
            text-align    : left;
            /*margin-bottom : 5px;*/
            width         : 100%;
            /*border-bottom : solid 1px #000000;*/
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
            font-size       : 9pt; !important;
            width           : 100%;
        }

        table, table td, table th {
            border : solid 1px #444;
            font-size       : 10pt; !important;
        }


        </style>
    </head>

    <body>

        <rep:headerFooter titulo="Proyecto: ${proyecto.nombre}"/>

        <div class="titulo2" style="margin-top: 2px">Plan Operativo: ${actual?.anio}<span style="margin-left: 2cm">CÓDIGO DE PROYECTO: ${proyecto.codigo}</span></div>

        <table style="width: 25.4cm;">
            <thead>
                <tr>
%{--
                    <th style="width: 2.5cm">Componente</th>
                    <th style="text-align: center; width: 1.5cm">#</th>
                    <th style="width: 9.0cm">Actividad</th>
                    <th style="width: 2.7cm">Responsable</th>
                    <th style="width: 2.5cm">Fecha Inicio / Fecha Fin</th>
                    <th style="width: 2.0cm">Partida</th>
                    <th style="width: 2.5cm">Planificado</th>
                    <th style="width: 2.5cm">Priorización</th>
--}%
                    <th style="width: 3.0cm">Componente</th>
                    <th style="text-align: center;width: 0.6cm">#</th>
                    <th style="width: 10.2cm">Actividad</th>
                    <th style="width: 4.0cm">Responsable</th>
                    <th style="width: 1.8cm">Fecha Inicio / Fecha Fin</th>
                    <th>Partida</th>
                    <th>Planificado</th>
                    <th>Priorización</th>
                </tr>
            </thead>
            <tbody>
                <g:set var="total" value="${0}"/>
                <g:set var="totalP" value="${0}"/>
                <g:each in="${asignaciones}" var="asg" status="i">
                    <g:if test="${asg.planificado > 0}">
                        <g:set var="total" value="${total.toDouble() + asg.getValorReal()}"/>
                        <g:set var="totalP" value="${totalP.toDouble() + asg.priorizado}"/>

                    </g:if>
                    <tr class="${(i % 2) == 0 ? 'odd' : 'even'}" style='${(asg.reubicada == 'S') ? "background: #d5f0d4" : ""}'>
                        <td class="dscr" style="text-align: left">
                            ${asg.marcoLogico.marcoLogico}
                        </td>
                        <td>
                            ${asg.marcoLogico.numero}
                        </td>
                        <td class="dscr" style="text-align: left">
                            ${asg.marcoLogico.toStringCompleto()}
                        </td>
                        <td style="text-align: left">
                            ${asg.unidad.toString()}
                            %{--${raw(asg.unidad)}--}%
                        </td>
                        <td style="text-align: left">
                            ${asg.marcoLogico.fechaInicio.format("dd-MM-yyyy")} / ${asg.marcoLogico.fechaFin.format("dd-MM-yyyy")}
                        </td>
                        <td>
                            ${asg.presupuesto.numero}
                        </td>
                        <td class="valor" style="text-align: right">
                            <g:formatNumber number="${asg.getValorReal()}" type="currency" currencySymbol=""/>
                        </td>
                        <td class="agr" style="text-align: right">
                            <g:formatNumber number="${asg.priorizado}" type="currency" currencySymbol=""/>
                        </td>
                    </tr>
                </g:each>
            </tbody>
            <tfoot>
                <tr>
                    <th colspan="6"><b>TOTAL</b></th>
                    <th class="valor" style="text-align: center; font-weight: bold; border-top : solid 1px #000000;">
                        <g:formatNumber number="${total.toDouble()}" type="currency" currencySymbol=""/>
                    </th>
                    <th class="valor" style="text-align: right; font-weight: bold; border-top : solid 1px #000000;">
                        <g:formatNumber number="${totalP.toDouble()}" type="currency" currencySymbol=""/>
                    </th>
                </tr>
            </tfoot>

        </table>
    </body>
</html>