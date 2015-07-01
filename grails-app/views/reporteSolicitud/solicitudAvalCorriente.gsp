<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 26/06/15
  Time: 11:46 AM
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <title>Solicitud aval corriente</title>
        <rep:estilos orientacion="p" pagTitle="Solicitud de Aval de POA corriente"/>
        <style type="text/css">
        .table {
            width           : 100%;
            border-collapse : collapse;
            border          : solid 1px #555;
            margin-top      : 10px;
        }

        .table td, .table th {
            border : solid 1px #555;
        }

        .tbl-small {
            margin : 5px;
            border : solid 1px #AAA;
        }

        .tbl-small td, .tbl-small th {
            border : solid 1px #AAA;
        }
        </style>
    </head>

    <body>
        <rep:headerFooter title="Solicitud de Aval de POA corriente" unidad="${proceso.fechaSolicitud.format('yyyy')}-${proceso.usuario.unidad?.codigo}"
                          numero="${proceso.numeroSolicitud.toString().padLeft(3, '0')}" estilo="right"/>

        <p style="margin-top: 40px">
            Con el propósito de ejecutar las actividades programadas en la planificación operativa institucional
            ${proceso.fechaInicioProceso?.format("yyyy")}, la ${proceso.usuario.unidad}
            solicita emitir el Aval de POA corriente correspondiente al proceso que se detalla a continuación:
        </p>

        <table class="table table-bordered table-condensed">
            <tr>
                <th style="width: 200px">
                    UNIDAD REQUIRENTE
                </th>
                <td>${proceso.usuario.unidad}</td>
            </tr>
            <tr>
                <th>
                    NOMBRE PROCESO
                </th>
                <td>
                    ${proceso.nombreProceso}
                </td>
            </tr>
            <tr>
                <th>
                    JUSTIFICACIÓN
                </th>
                <td>
                    ${proceso.concepto}
                </td>
            </tr>
            <tr>
                <th>
                    FECHA DE INICIO
                </th>
                <td>
                    ${proceso.fechaInicioProceso.format("dd-MM-yyyy")}
                </td>
            </tr>
            <tr>
                <th>
                    FECHA DE FIN
                </th>
                <td>
                    ${proceso.fechaFinProceso.format("dd-MM-yyyy")}
                </td>
            </tr>
            <tr>
                <th>
                    MONTO TOTAL SOLICITADO
                </th>
                <td>
                    <g:formatNumber number="${proceso.monto}" type="currency" currencySymbol="USD "/>
                </td>
            </tr>
        </table>

        <g:each in="${detalles}" var="d">
            <g:set var="det" value="${d.value}"/>
            <table class="table table-bordered table-condensed">
                <tr>
                    <td style="width:200px; font-weight: bold">OBJETIVO GASTO CORRIENTE</td>
                    <td>${det.tarea.actividad.macroActividad.objetivoGastoCorriente.descripcion}</td>
                </tr>
                <tr>
                    <td style="font-weight: bold">MACROACTIVIDAD</td>
                    <td>${det.tarea.actividad.macroActividad.descripcion}</td>
                </tr>
                <tr>
                    <td style="font-weight: bold">ACTIVIDAD</td>
                    <td>${det.tarea.actividad.descripcion}</td>
                </tr>
                <tr>
                    <td style="font-weight: bold">TAREA</td>
                    <td>${det.tarea.descripcion}</td>
                </tr>
                <tr>
                    <td style="font-weight: bold">ASIGNACIONES</td>
                    <td>
                        <table class="table table-bordered table-condensed tbl-small" style="width: auto">
                            <thead>
                                <tr>
                                    <th>Asignación</th>
                                    <th>Fuente</th>
                                    <th>Monto</th>
                                </tr>
                            </thead>
                            <g:set var="total" value="${0}"/>
                            <tbody>
                                <g:each in="${det.asignaciones}" var="a">
                                    <g:set var="total" value="${total + a.monto}"/>
                                    <tr>
                                        <td>${a.asg.actividad ? a.asg.actividad + " - " : ""}${a.asg.presupuesto}</td>
                                        <td>${a.asg.fuente}</td>
                                        <td class="text-right"><g:formatNumber number="${a.monto}" type="currency" currencySymbol=""/></td>
                                    </tr>
                                </g:each>
                            </tbody>
                            <tfoot>
                                <tr>
                                    <th colspan="2">TOTAL</th>
                                    <td class="text-right"><g:formatNumber number="${total}" type="currency" currencySymbol=""/></td>
                                </tr>
                            </tfoot>
                        </table>
                    </td>
                </tr>
            </table>
        </g:each>
    </body>
</html>