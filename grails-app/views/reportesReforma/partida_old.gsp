<%--
  Created by IntelliJ IDEA.
  User: fabricio
  Date: 23/04/15
  Time: 01:08 PM
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <g:if test="${reforma?.tipo == 'R'}">
            <title>Ajuste al POA</title>
            <rep:estilos orientacion="l" pagTitle="Solicitud de reforma al POA"/>
        </g:if>
        <g:else>
            <title>Ajuste al POA</title>
            <rep:estilos orientacion="l" pagTitle="Ajuste al POA"/>
        </g:else>

        <style type="text/css">
        table {
            font-size : 9pt;
        }

        ol {
            counter-reset : item;
            padding       : 0;
        }

        ol li {
            display       : block;
            margin-bottom : 5px;
        }

        ol li:before {
            content           : counter(item) ". ";
            counter-increment : item;
            font-weight       : bold;
        }

        .table {
            border-collapse : collapse;
            border          : solid 1px #000000;
        }

        .justificacion {
            border     : solid 1px #000000;
            margin-top : 5px;
            padding    : 10px;
        }

        .firma {
            margin-top  : 2cm;
            margin-left : 10cm;
        }

        .valor {
            text-align : right;
        }

        .formato {
            font-weight : bold;
            background  : #008080;
            color       : #ffffff;
        }

        td {
            border : solid 1px #000000;

        }

        th {
            border : solid 1px #000000;
        }

        .text-right {
            text-align : right;
        }
        </style>

    </head>

    <body>
        <g:if test="${reforma?.tipo == 'R'}">
            <rep:headerFooter title="SOLICITUD DE REFORMA AL POA" unidad="${reforma.fecha.format('YYYY')}-GP"
                              numero="${reforma.id}" estilo="right"/>
        </g:if>
        <g:else>
            <rep:headerFooter title="AJUSTE AL POA" unidad="${anio}-GP"
                              numero="${reforma.id}" estilo="right"/>
        </g:else>

        <div style="margin-left: 10px;">
            <div>
                <ol>
                    <li class="no-break">
                        <strong>Unidad responsable (Gerencia - Dirección):</strong> ${reforma.persona.unidad}
                    </li>
                    <li class="no-break">
                        <g:if test="${reforma?.tipo == 'R'}">
                            <strong>Tipo de reforma:</strong> Reforma por creación de nueva partida
                        %{--<table class="table " border="1" style="margin-left: 280px">--}%
                        %{--<thead>--}%
                        %{--<tr>--}%
                        %{--<th style="text-align: center">Detalle</th>--}%
                        %{--<th>(Marcar X)</th>--}%
                        %{--</tr>--}%
                        %{--</thead>--}%
                        %{--<tbody>--}%
                        %{--<tr>--}%
                        %{--<td>Reforma entre actividades por reasignación de recursos o saldos</td>--}%
                        %{--<td class="center">--}%

                        %{--</td>--}%
                        %{--</tr>--}%
                        %{--<tr>--}%
                        %{--<td>Reforma por creación de una nueva actividad</td>--}%
                        %{--<td class="center">--}%
                        %{--</td>--}%
                        %{--</tr>--}%
                        %{--<tr>--}%
                        %{--<td>Reforma por creación de nueva partida</td>--}%
                        %{--<td class="center">--}%
                        %{--${'X'}--}%
                        %{--</td>--}%
                        %{--</tr>--}%
                        %{--<tr>--}%
                        %{--<td>Reforma por Incremento</td>--}%
                        %{--<td class="center">--}%
                        %{--</td>--}%
                        %{--</tr>--}%

                        %{--</tbody>--}%
                        %{--</table>--}%
                        </g:if>
                        <g:else>
                            <strong>Tipo de ajuste:</strong> Ajuste por creación de nueva partida
                        %{--<table class="table " border="1" style="margin-left: 280px">--}%
                        %{--<thead>--}%
                        %{--<tr>--}%
                        %{--<th style="text-align: center">Detalle</th>--}%
                        %{--<th>(Marcar X)</th>--}%
                        %{--</tr>--}%
                        %{--</thead>--}%
                        %{--<tbody>--}%
                        %{--<tr>--}%
                        %{--<td>Ajuste entre actividades por reasignación de recursos o saldos</td>--}%
                        %{--<td class="center">--}%

                        %{--</td>--}%
                        %{--</tr>--}%
                        %{--<tr>--}%
                        %{--<td>Ajuste por creación de una nueva actividad</td>--}%
                        %{--<td class="center">--}%
                        %{--</td>--}%
                        %{--</tr>--}%
                        %{--<tr>--}%
                        %{--<td>Ajuste por creación de nueva partida</td>--}%
                        %{--<td class="center">--}%
                        %{--${'X'}--}%
                        %{--</td>--}%
                        %{--</tr>--}%
                        %{--<tr>--}%
                        %{--<td>Ajuste por Incremento</td>--}%
                        %{--<td class="center">--}%
                        %{--</td>--}%
                        %{--</tr>--}%

                        %{--</tbody>--}%
                        %{--</table>--}%
                        </g:else>
                    </li>
                    %{--<li  class="no-break" style="margin-left: 20px">--}%
                    <li class="no-break">
                        <g:if test="${reforma?.tipo == 'R'}">
                            <strong>Matriz de la reforma:</strong>
                        </g:if>
                        <g:else>
                            <strong>Matriz del ajuste:</strong>
                        </g:else>
                        <g:set var="ti" value="${0}"/>
                        <g:set var="tvi" value="${0}"/>
                        <g:set var="tvf" value="${0}"/>
                        <g:set var="tf" value="${0}"/>

                        <table style="width:100%; border-color: #000099;margin-top: 15px" class="table " border="1">
                            <thead>
                                <tr>
                                    <th style="background: #9dbfdb; text-align: center">Proyecto</th>
                                    <th style="background: #9dbfdb; text-align: center">Componente</th>
                                    <th style="background: #9dbfdb; text-align: center">Número <br/> de la <br/> actividad <br/> del POA
                                    </th>
                                    %{--<th style="background: #9dbfdb; text-align: center">Nueva <br/> actividad <br/> (Marcar x)</th>--}%
                                    <th style="background: #9dbfdb; text-align: center">Nombre de la Actividad</th>
                                    <th style="background: #9dbfdb; text-align: center">
                                        Partida <br/>
                                        presupuestaria
                                    </th>
                                    <th style="background: #9dbfdb; text-align: center">Valor <br/> inicial USD</th>
                                    <th style="background: #9dbfdb; text-align: center">Disminución <br/> USD</th>
                                    <th style="background: #9dbfdb; text-align: center">Aumento <br/> USD</th>

                                    <th style="background: #9dbfdb; text-align: center">Valor <br/> final <br/> USD</th>
                                </tr>
                            </thead>
                            <tbody>
                                <g:set var="totalInicial" value="${detalles.first().asignacionOrigen.priorizado}"/>
                                <g:set var="totalDisminucion" value="${0}"/>
                                <g:set var="totalAumento" value="${0}"/>
                                <g:set var="menos" value="${detalles.sum {
                                    it.valor
                                }}"/>
                                <g:set var="totalFinal" value="${totalInicial - menos + menos}"/>
                                <tr class="info">
                                    <td>
                                        ${detalles.first().asignacionOrigen.marcoLogico.proyecto.toStringCompleto()}
                                    </td>
                                    <td>
                                        ${detalles.first().asignacionOrigen.marcoLogico.marcoLogico.toStringCompleto()}
                                    </td>
                                    <td>
                                        ${detalles.first().asignacionOrigen.marcoLogico.numero}
                                    </td>
                                    <td>
                                        ${detalles.first().asignacionOrigen.marcoLogico.toStringCompleto()}
                                    </td>
                                    <td>
                                        ${detalles.first().asignacionOrigen}
                                    </td>
                                    <td class="text-right">
                                        <g:formatNumber number="${detalles.first().asignacionOrigen.priorizado}" type="currency" currencySymbol=""/>
                                    </td>
                                    <td class="text-right">
                                        <g:formatNumber number="${menos}" type="currency" currencySymbol=""/>
                                    </td>
                                    <td></td>
                                    <td class="text-right">
                                        <g:formatNumber number="${detalles.first().asignacionOrigen.priorizado - menos}" type="currency" currencySymbol=""/>
                                    </td>
                                </tr>
                                <g:each in="${detalles}" var="detalle">
                                    <g:set var="totalDisminucion" value="${totalDisminucion + detalle.valor}"/>
                                    <g:set var="totalAumento" value="${totalAumento + detalle.valor}"/>
                                    <tr class="success">
                                        <td>
                                            ${detalle.asignacionOrigen.marcoLogico.proyecto.toStringCompleto()}
                                        </td>
                                        <td>
                                            ${detalle.asignacionOrigen.marcoLogico.marcoLogico.toStringCompleto()}
                                        </td>
                                        <td>
                                            ${detalle.asignacionOrigen.marcoLogico.numero}
                                        </td>
                                        <td>
                                            ${detalle.asignacionOrigen.marcoLogico.toStringCompleto()}
                                        </td>
                                        <td>
                                            <strong>Responsable:</strong> ${reforma.persona.unidad}
                                            <strong>Priorizado:</strong> 0.00
                                            <strong>Partida Presupuestaria:</strong> ${detalle.presupuesto}
                                            <strong>Año:</strong> ${reforma.anio.anio}
                                        </td>
                                        <td class="text-right">
                                            %{--<g:formatNumber number="${detalle.asignacionDestino.priorizado}" type="currency" currencySymbol=""/>--}%
                                        </td>
                                        <td></td>
                                        <td class="text-right">
                                            <g:formatNumber number="${detalle.valor}" type="currency" currencySymbol=""/>
                                        </td>
                                        <td class="text-right">
                                            <g:formatNumber number="${detalle.valor}" type="currency" currencySymbol=""/>
                                        </td>
                                    </tr>
                                </g:each>
                                <tr>
                                    <td colspan="4" style="background: #008080"></td>
                                    <td class="formato">TOTAL</td>
                                    <td class="valor formato"><g:formatNumber number="${totalInicial}" type="currency" currencySymbol=""/>
                                    </td>
                                    <td class="valor formato"><g:formatNumber number="${totalDisminucion}" type="currency" currencySymbol=""/>
                                    </td>
                                    <td class="valor formato"><g:formatNumber number="${totalAumento}" type="currency" currencySymbol=""/>
                                    </td>
                                    <td class="valor formato"><g:formatNumber number="${totalFinal}" type="currency" currencySymbol=""/>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </li>
                    <li class="no-break" style="margin-top: 15px">
                        <g:if test="${reforma?.tipo == 'R'}">
                            <strong>Justificación de la reforma al POA solicitada:</strong>
                        </g:if>
                        <g:else>
                            <strong>Justificación del ajuste al POA solicitada:</strong>
                        </g:else>
                        <div class="justificacion">
                            ${reforma.concepto}
                        </div>
                    </li>

                </ol>
                <g:if test="${reforma?.tipo == 'R'}">
                    <div>
                        Es importante señalar que la reforma no implica un incremento en el techo del presupuesto programado y que el impacto
                        causado por la modificación de POA no afecta a los objetivos institucionales
                    </div>
                </g:if>
                <g:else>
                    <div>
                        Es importante señalar que el ajuste no implica un incremento en el techo del presupuesto programado y que el impacto
                        causado por la modificación de POA no afecta a los objetivos institucionales
                    </div>
                </g:else>
                <div class="firma ">
                    <div>
                        <span class="spanFirma">
                            <g:if test="${reforma?.firmaSolicitud?.estado == 'F'}">
                                <img src="${resource(dir: 'firmas', file: reforma?.firmaSolicitud?.path)}" style="width: 150px;"/><br/>

                                <div style="border-bottom: solid; width: 150px"></div>
                                ${reforma?.firmaSolicitud?.usuario?.nombre} ${reforma?.firmaSolicitud?.usuario?.apellido}<br/>
                                <b>GERENTE DE ${reforma?.firmaSolicitud?.usuario?.cargoPersonal?.toString()?.toUpperCase()}<br/>
                                </b>
                            </g:if>
                        </span>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>