<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 09/10/14
  Time: 11:01 AM
--%>

<%@ page import="vesta.contratacion.DetalleMontoSolicitud" contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <title>Reunión de aprobación</title>

        <rep:estilosAlt orientacion="l" pagTitle="Reunión de aprobación"/>

        <style type="text/css">

        .tbl {
            width           : 100%;
            border-collapse : collapse;
        }

        .tbl, .tbl tr, .tbl th, .tbl td {
            border : solid 1px #555;
        }

        .tbl th {
            text-align : center;
        }

        .small {
            font-size : 9pt;
        }

        .txt {
            border        : solid 1px #333;
            padding       : 3px;
            margin-bottom : 10px;
        }
        </style>
    </head>

    <body>
        <div class="hoja">
            <rep:headerFooterAlt title="Acta de la Reunión de Planificación de Contrataciones" codigo="FR-PLA-AVAL-02"/>

            <div class="txt">
                Con el objetivo de ejecutar las actividades programadas en la Planificación Operativa Anual 2015, se pone a
                consideración de la Comisión de Planificación de Contrataciones la ejecución de las
                actividades detalladas a continuación:
            </div>


            <table class="tbl" border="1">
                <thead>
                    <tr>
                        <th rowspan="2">N.</th>
                        <th rowspan="2">Proyecto</th>
                        <th rowspan="2">Componente</th>
                        <th colspan="3">Actividad</th>
                        <th rowspan="2">TDR's</th>
                        <th colspan="${anios.size() + 1}">Monto solicitado (aval)</th>
                        <th rowspan="2">Revisión Dirección de Planificación e Inversión</th>
                        <th rowspan="2">Aprobación</th>
                        <th rowspan="2">Observaciones</th>
                    </tr>
                    <tr>
                        <th>N. POA</th>
                        <th>Nombre</th>
                        <th>Objetivo</th>

                        <g:each in="${anios}" var="a">
                            <th>Valor ${a.anio}</th>
                        </g:each>
                        <th>Total</th>
                    </tr>
                </thead>
                <tbody class="small">
                    <g:each in="${solicitudes}" var="solicitud" status="i">
                        <tr>
                            <td>${i + 1}</td>
                            <td>${solicitud.actividad.proyecto.nombre}</td>
                            <td>${solicitud.actividad.marcoLogico}</td>
                            <td>Nueva</td>
                            <td>${solicitud.actividad.objeto}</td>
                            <td>${solicitud.actividad.objeto}</td>
                            <td style="text-align: center;">X</td>
                            <g:set var="total" value="${0}"/>
                            <g:each in="${anios}" var="a">
                                <g:set var="valor" value="${DetalleMontoSolicitud.findByAnioAndSolicitud(a, solicitud)}"/>
                                <g:if test="${valor}">
                                    <td><g:formatNumber number="${valor.monto}" type="currency" currencySymbol=" "/></td>
                                    <g:set var="total" value="${total + valor.monto}"/>
                                </g:if>
                                <g:else>
                                    <td></td>
                                </g:else>
                            </g:each>
                            <td><g:formatNumber number="${total}" type="currency" currencySymbol=" "/></td>
                            <td>${solicitud.revisionDireccionPlanificacionInversion}</td>
                            <td>${solicitud.tipoAprobacion.descripcion}</td>
                            <td>${solicitud.observacionesAprobacion}</td>
                        </tr>
                    </g:each>
                </tbody>
            </table>

            <div class="fecha">
                <table width="100%">
                    <tr>
                        <td style="text-align: left">
                            Elaborado por: ${reunion.creadoPor?.sigla}
                        </td>
                        <td>
                            Quito, ${reunion.fecha?.format("dd-MM-yyyy")}
                        </td>
                    </tr>
                </table>

            </div>
            <slc:firmasReporte firmas="${firmas}"/>
        </div>
    </body>
</html>