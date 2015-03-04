<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 13/08/14
  Time: 04:23 PM
--%>

<%@ page import="vesta.poa.Asignacion; vesta.contratacion.DetalleMontoSolicitud; vesta.contratacion.Aprobacion" contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <title>Imprimir solicitudes</title>
        <rep:estilos orientacion="l" pagTitle="Lista de Solicitudes"/>

        <style type="text/css">

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

        .tabla {
            border-collapse : collapse;
            font-size       : 10pt;
        }

        td, th {
            padding : 5px;

        }

        th {

            background: #9dbfdb;
            text-align: center;
        }

        </style>
    </head>

    <body>

            <rep:headerFooter title="Lista de Solicitudes de contratación"/>

            <div class="divTabla">
                <table style="width: 100%;font-size: 10px; margin-top: 20px" border="1" class="tabla">
                    <thead>
                        <tr>
                            <th>Proyecto</th>
                            <th>Componente</th>
                            <th>N.Poa</th>
                            <th>Nombre</th>
                            <th>Objetivo</th>
                            <th>TDR's</th>
                            <th>Responsable</th>
                            <g:each in="${anios}" var="a">
                                <th>Valor ${a.anio}</th>
                            </g:each>
                            <th>Monto</th>
                            <th>Aprobacion</th>
                            <th>
                                Fecha<br/>
                                Solicitud
                            </th>

                        </tr>
                    </thead>
                    <tbody>
                        <g:each in="${solicitudInstanceList}" status="i" var="solicitudInstance">
                            <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                                <td>${solicitudInstance.actividad.proyecto}</td>
                                <td>${solicitudInstance.actividad.marcoLogico}</td>
                                <td>${vesta.poa.Asignacion.findByMarcoLogico(solicitudInstance.actividad)?.presupuesto?.numero}</td>
                                <td>${solicitudInstance.nombreProceso}</td>
                                <td>${solicitudInstance.objetoContrato}</td>
                                <td>X</td>
                                <td>
                                    ${solicitudInstance.unidadEjecutora?.codigo}
                                </td>
                                <g:each in="${anios}" var="a">
                                    <g:set var="valor" value="${DetalleMontoSolicitud.findByAnioAndSolicitud(a, solicitudInstance)}"/>
                                    <g:if test="${valor}">
                                        <td><g:formatNumber number="${valor.monto}" type="currency" currencySymbol=" "/></td>
                                    </g:if>
                                    <g:else>
                                        <td></td>
                                    </g:else>

                                </g:each>
                                <td><g:formatNumber number="${solicitudInstance.montoSolicitado}" type="currency" currencySymbol=" "/></td>
                                <g:set var="estado" value="${solicitudInstance.aprobacion}"/>
                                <g:if test="${estado}">
                                    <td>${solicitudInstance.tipoAprobacion?.descripcion}<br/>${estado.fecha}
                                    </td>
                                %{--<td>Acta</td>--}%
                                </g:if>
                                <g:else>
                                    <td>Pendiente</td>
                                %{--<td></td>--}%
                                </g:else>
                                <td>${solicitudInstance.fecha}</td>
                            </tr>
                        </g:each>
                    </tbody>
                </table>
            </div>
    </body>
</html>