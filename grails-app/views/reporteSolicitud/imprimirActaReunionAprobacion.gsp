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
        <style type="text/css">
        @page {
            size   : 29.7cm 21cm ;  /*width height */
            margin : 2cm;
        }

        .hoja {
            width     : 24.7cm;
            font-size : 12pt;
        }

        .titulo {
            width : 15.5cm;
        }

        .hoja {
            /*background  : #fedcba;*/
            /*height      : 24.7cm; *//*29.7-(1.5*2)*/
            font-family : arial;
            font-size   : 10pt;
        }

        .titulo {
            height        : 130px;
            font-size     : 12pt;
            /*font-weight   : bold;*/
            text-align    : center;
            margin-bottom : 5px;
            width         : 95%;
        }

        .totales {
            font-weight : bold;
        }

        .num {
            text-align : right;
        }

        .header {
            background : #333333 !important;
            color      : #AAAAAA;
        }

        .total {
            background : #000000 !important;
            color      : #FFFFFF !important;
        }

        th {
            background : #cccccc;
        }

        tbody tr:nth-child(2n+1) {
            background : none repeat scroll 0 0 #E1F1F7;
        }

        tbody tr:nth-child(2n) {
            background : none repeat scroll 0 0 #F5F5F5;
        }

        .label {
            font-weight : bold;
        }

        .ui-widget-header {
            font-weight : bold;
        }

        .ttl {
            text-align  : center;
            font-weight : bold;
        }

        .fecha {
            text-align : right;
            margin-top : 1cm;
        }

        .tbl {
            border-collapse : collapse;
        }

        .tbl th {
            text-align : center;
        }

        .small {
            font-size : 9pt;
        }
        </style>
    </head>

    <body>
        <div class="hoja">
            <slc:headerReporte title="Acta de la Reunión de Planificación de Contrataciones" codigo="FR-PLA-AVAL-02"/>

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
                                    <td><g:formatNumber number="${valor.monto}" type="currency"/></td>
                                    <g:set var="total" value="${total + valor.monto}"/>
                                </g:if>
                                <g:else>
                                    <td></td>
                                </g:else>
                            </g:each>
                            <td><g:formatNumber number="${total}" type="currency"/></td>
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