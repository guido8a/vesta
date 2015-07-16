<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 11/06/15
  Time: 09:51 AM
--%>


<%@ page import="vesta.poa.ProgramacionAsignacion; vesta.poa.Asignacion; vesta.parametros.TipoElemento; vesta.proyectos.MarcoLogico; vesta.parametros.poaPac.Mes" contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <title>POA por Área de gestión</title>

        <rep:estilos orientacion="l" pagTitle="${titulo}"/>

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
        <rep:headerFooter title="${titulo}" subtitulo="${subtitulo}"/>

        <p>
            Fecha del reporte: ${new java.util.Date().format("dd-MM-yyyy HH:mm")}
        </p>

        <table class="table table-bordered table-hover table-condensed table-bordered">
            <thead>
                <tr>
                    <th>GG</th>
                    <th>#</th>
                    <th>ACTIVIDAD</th>
                    <th>RESPONSABLE</th>
                    <th>PRESUPUESTO CODIFICADO</th>
                    <th>MONTO AVALADO</th>
                    <th>RECURSOS DISPONIBLES</th>
                </tr>
            </thead>
            <tbody>
                <g:each in="${data}" var="val" status="i">
                    <g:set var="v" value="${val.value}"/>
                    <tr>
                        <td>
                            ${v?.partida?.numero[0..1]}
                        </td>
                        <td>
                            ${v?.actividad?.numero}
                        </td>
                        <td>
                            ${v?.actividad?.toStringCompleto()}
                        </td>
                        <td>
                            ${v?.actividad?.responsable?.gerencia?.nombre}
                        </td>
                        <td class="text-right">
                            <g:formatNumber number="${v?.valores['priorizado']}" type="currency" currencySymbol=""/>
                        </td>
                        <td class="text-right">
                            <g:formatNumber number="${v?.valores['avales']}" type="currency" currencySymbol=""/>
                        </td>
                        <td class="text-right">
                            <g:formatNumber number="${v?.valores['disponible']}" type="currency" currencySymbol=""/>
                        </td>
                    </tr>
                </g:each>
            </tbody>
            <tfoot>
                <tr>
                    <th class="text-right" colspan="4">TOTAL</th>
                    <th class="text-right"><g:formatNumber number="${totales.priorizado}" type="currency" currencySymbol=""/></th>
                    <th class="text-right"><g:formatNumber number="${totales.avales}" type="currency" currencySymbol=""/></th>
                    <th class="text-right"><g:formatNumber number="${totales.disponible}" type="currency" currencySymbol=""/></th>
                </tr>
            </tfoot>
        </table>
    </body>
</html>