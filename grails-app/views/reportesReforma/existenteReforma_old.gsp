<%--
  Created by IntelliJ IDEA.
  User: fabricio
  Date: 22/04/15
  Time: 11:10 AM
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <title>Reforma de POA</title>
        <rep:estilos orientacion="l" pagTitle="Reforma al POA"/>
        <style type="text/css">
        table {
            font-size : 9pt;
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

        .odd {
            background : none repeat scroll 0 0 #E1F1F7;
        }

        .even {
            background : none repeat scroll 0 0 #F5F5F5;
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

        .center {
            text-align : center;
        }

        .fright {
            float : right;
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
        <rep:headerFooter title="REFORMA AL POA" unidad="${reforma.fecha.format('yyyy')}-GP"
                          numero="${reforma.numero}" estilo="right"/>

        <div style="margin-left: 10px;">
            <div>
                <ol>
                    <li>
                        <strong>Unidad responsable (Gerencia-Dirección):</strong> ${reforma.persona.unidad}
                    </li>
                    <li>
                        <strong>Matriz de la reforma:</strong>
                        <table style="width:100%;margin-top: 15px" class="table " border="1">
                            <thead>
                                <tr>
                                    <th style="background: #9dbfdb; text-align: center">Proyecto</th>
                                    <th style="background: #9dbfdb; text-align: center">Componente</th>
                                    <th style="background: #9dbfdb; text-align: center">No</th>
                                    <th style="background: #9dbfdb; text-align: center">Nombre de la actividad</th>
                                    <th style="background: #9dbfdb; text-align: center">
                                        Partida <br/>
                                        presupuestaria
                                    </th>
                                    <th style="background: #9dbfdb; text-align: center">Valor inicial</th>
                                    <th style="background: #9dbfdb; text-align: center">Disminución</th>
                                    <th style="background: #9dbfdb; text-align: center">Aumento</th>
                                    <th style="background: #9dbfdb; text-align: center">Valor final</th>
                                </tr>
                            </thead>
                            <tbody>
                                <g:set var="tInicial" value="${0}"/>
                                <g:set var="tDism" value="${0}"/>
                                <g:set var="tAum" value="${0}"/>
                                <g:set var="tFinal" value="${0}"/>
                                <g:each in="${det}" var="dd">
                                    <g:set var="d" value="${dd.value}"/>
                                    <g:set var="tInicial" value="${tInicial + d.desde.inicial}"/>
                                    <g:set var="tDism" value="${tDism + d.desde.dism}"/>
                                    <g:set var="tAum" value="${tAum + d.desde.aum}"/>
                                    <g:set var="tFinal" value="${tFinal + d.desde.final}"/>
                                    <tr>
                                        <td>${d.desde.proyecto}</td>
                                        <td>${d.desde.componente}</td>
                                        <td>${d.desde.no}</td>
                                        <td>${d.desde.actividad}</td>
                                        <td>${d.desde.partida}</td>
                                        <td class="text-right"><g:formatNumber number="${d.desde.inicial}" type="currency" currencySymbol=""/></td>
                                        <td class="text-right"><g:formatNumber number="${d.desde.dism}" type="currency" currencySymbol=""/></td>
                                        <td class="text-right"><g:formatNumber number="${d.desde.aum}" type="currency" currencySymbol=""/></td>
                                        <td class="text-right"><g:formatNumber number="${d.desde.final}" type="currency" currencySymbol=""/></td>
                                    </tr>
                                    <g:each in="${d.hasta}" var="h">
                                        <g:set var="tInicial" value="${tInicial + h.inicial}"/>
                                        <g:set var="tDism" value="${tDism + h.dism}"/>
                                        <g:set var="tAum" value="${tAum + h.aum}"/>
                                        <g:set var="tFinal" value="${tFinal + h.final}"/>
                                        <tr>
                                            <td>${h.proyecto}</td>
                                            <td>${h.componente}</td>
                                            <td>${h.no}</td>
                                            <td>${h.actividad}</td>
                                            <td>${h.partida}</td>
                                            <td class="text-right"><g:formatNumber number="${h.inicial}" type="currency" currencySymbol=""/></td>
                                            <td class="text-right"><g:formatNumber number="${h.dism}" type="currency" currencySymbol=""/></td>
                                            <td class="text-right"><g:formatNumber number="${h.aum}" type="currency" currencySymbol=""/></td>
                                            <td class="text-right"><g:formatNumber number="${h.final}" type="currency" currencySymbol=""/></td>
                                        </tr>
                                    </g:each>
                                </g:each>
                            </tbody>
                            <tfoot>
                                <tr>
                                    <th colspan="5" class="text-right formato">TOTAL</th>
                                    <th class="text-right formato"><g:formatNumber number="${tInicial}" type="currency" currencySymbol=""/></th>
                                    <th class="text-right formato"><g:formatNumber number="${tDism}" type="currency" currencySymbol=""/></th>
                                    <th class="text-right formato"><g:formatNumber number="${tAum}" type="currency" currencySymbol=""/></th>
                                    <th class="text-right formato"><g:formatNumber number="${tFinal}" type="currency" currencySymbol=""/></th>
                                </tr>
                            </tfoot>
                        </table>
                        %{--<g:set var="ti" value="${0}"/>--}%
                        %{--<g:set var="tvi" value="${0}"/>--}%
                        %{--<g:set var="tvf" value="${0}"/>--}%
                        %{--<g:set var="tf" value="${0}"/>--}%
                        %{--<table style="width:100%;margin-top: 15px" class="table " border="1">--}%
                        %{--<thead>--}%
                        %{--<tr>--}%
                        %{--<th style="background: #9dbfdb; text-align: center">Proyecto</th>--}%
                        %{--<th style="background: #9dbfdb; text-align: center">Componente</th>--}%
                        %{--<th style="background: #9dbfdb; text-align: center">No</th>--}%
                        %{--<th style="background: #9dbfdb; text-align: center">Nombre de la actividad</th>--}%
                        %{--<th style="background: #9dbfdb; text-align: center">--}%
                        %{--Partida <br/>--}%
                        %{--presupuestaria--}%
                        %{--</th>--}%
                        %{--<th style="background: #9dbfdb; text-align: center">Valor inicial</th>--}%
                        %{--<th style="background: #9dbfdb; text-align: center">Disminución</th>--}%
                        %{--<th style="background: #9dbfdb; text-align: center">Aumento</th>--}%
                        %{--<th style="background: #9dbfdb; text-align: center">Valor final</th>--}%
                        %{--</tr>--}%
                        %{--</thead>--}%
                        %{--<tbody>--}%
                        %{--<g:set var="totalInicial" value="${0}"/>--}%
                        %{--<g:set var="totalDisminucion" value="${0}"/>--}%
                        %{--<g:set var="totalAumento" value="${0}"/>--}%
                        %{--<g:set var="totalFinal" value="${0}"/>--}%
                        %{--<g:each in="${modificaciones}" var="modificacion">--}%
                        %{--<g:set var="totalInicial" value="${totalInicial + (modificacion.originalOrigen + modificacion.originalDestino)}"/>--}%
                        %{--<g:set var="totalDisminucion" value="${totalDisminucion + modificacion.valor}"/>--}%
                        %{--<g:set var="totalAumento" value="${totalAumento + modificacion.valor}"/>--}%
                        %{--<g:set var="totalFinal" value="${totalFinal + ((modificacion.originalOrigen - modificacion.valor) + (modificacion.originalDestino + modificacion.valor))}"/>--}%
                        %{--<tr class="info">--}%
                        %{--<td>--}%
                        %{--${modificacion.desde.marcoLogico.proyecto.toStringCompleto()}--}%
                        %{--</td>--}%
                        %{--<td>--}%
                        %{--${modificacion.desde.marcoLogico.marcoLogico.toStringCompleto()}--}%
                        %{--</td>--}%
                        %{--<td>--}%
                        %{--${modificacion.desde.marcoLogico.numero}--}%
                        %{--</td>--}%
                        %{--<td>--}%
                        %{--${modificacion.desde.marcoLogico.toStringCompleto()}--}%
                        %{--</td>--}%
                        %{--<td>--}%
                        %{--${modificacion.desde}--}%
                        %{--</td>--}%
                        %{--<td class="text-right">--}%
                        %{--<g:formatNumber number="${modificacion.originalOrigen}" type="currency" currencySymbol=""/>--}%
                        %{--</td>--}%
                        %{--<td class="text-right">--}%
                        %{--<g:formatNumber number="${modificacion.valor}" type="currency" currencySymbol=""/>--}%
                        %{--</td>--}%
                        %{--<td></td>--}%
                        %{--<td class="text-right">--}%
                        %{--<g:formatNumber number="${modificacion.originalOrigen - modificacion.valor}" type="currency" currencySymbol=""/>--}%
                        %{--</td>--}%
                        %{--</tr>--}%
                        %{--<tr class="success">--}%
                        %{--<td>--}%
                        %{--${modificacion.recibe.marcoLogico.proyecto.toStringCompleto()}--}%
                        %{--</td>--}%
                        %{--<td>--}%
                        %{--${modificacion.recibe.marcoLogico.marcoLogico.toStringCompleto()}--}%
                        %{--</td>--}%
                        %{--<td>--}%
                        %{--${modificacion.recibe.marcoLogico.numero}--}%
                        %{--</td>--}%
                        %{--<td>--}%
                        %{--${modificacion.recibe.marcoLogico.toStringCompleto()}--}%
                        %{--</td>--}%
                        %{--<td>--}%
                        %{--${modificacion.recibe}--}%
                        %{--</td>--}%
                        %{--<td class="text-right">--}%
                        %{--<g:formatNumber number="${modificacion.originalDestino}" type="currency" currencySymbol=""/>--}%
                        %{--</td>--}%
                        %{--<td></td>--}%
                        %{--<td class="text-right">--}%
                        %{--<g:formatNumber number="${modificacion.valor}" type="currency" currencySymbol=""/>--}%
                        %{--</td>--}%
                        %{--<td class="text-right">--}%
                        %{--<g:formatNumber number="${modificacion.originalDestino + modificacion.valor}" type="currency" currencySymbol=""/>--}%
                        %{--</td>--}%
                        %{--</tr>--}%
                        %{--</g:each>--}%
                        %{--<tr>--}%
                        %{--<td colspan="4" style="background: #008080"></td>--}%
                        %{--<td class="formato">TOTAL</td>--}%
                        %{--<td class="valor formato"><g:formatNumber number="${totalInicial}" type="currency" currencySymbol=""/>--}%
                        %{--</td>--}%
                        %{--<td class="valor formato"><g:formatNumber number="${totalDisminucion}" type="currency" currencySymbol=""/>--}%
                        %{--</td>--}%
                        %{--<td class="valor formato"><g:formatNumber number="${totalAumento}" type="currency" currencySymbol=""/>--}%
                        %{--</td>--}%
                        %{--<td class="valor formato"><g:formatNumber number="${totalFinal}" type="currency" currencySymbol=""/>--}%
                        %{--</td>--}%
                        %{--</tr>--}%
                        %{--</tbody>--}%
                        %{--</table>--}%
                    </li>
                </ol>

                <div style="margin-bottom: 10px">
                    <strong>Observación:</strong>  ${reforma.concepto}
                </div>

                <div>
                    <strong>Elaborado por:</strong> ${reforma.persona.sigla}
                </div>

                <div class="fright">
                    <strong>FECHA:</strong> ${reforma.fecha?.format("dd-MM-yyyy")}
                </div>

                <div class="no-break">
                    <table width="100%" style="margin-top: 0.5cm; border: none" border="none">
                        <tr>
                            <g:if test="${reforma.firma1?.estado == 'F' && reforma.firma2?.estado == 'F'}">
                                <td width="25%" style="text-align: center; border: none"><b>Revisado por:</b></td>
                                <td width="25%" style="border: none"></td>
                                <td width="25%" style="text-align: center; border: none"><b>Aprobado por:</b></td>
                                <td width="25%" style="border: none"></td>
                            </g:if>

                            <g:if test="${reforma.firma1?.estado == 'F' && reforma.firma2?.estado != 'F'}">
                                <td width="25%" style="text-align: center; border: none"><b>Revisado por:</b></td>
                                <td width="25%" style="border: none"></td>
                                <td width="25%" style="border: none"></td>
                                <td width="25%" style="border: none"></td>
                            </g:if>
                            <g:if test="${reforma.firma2?.estado == 'F' && reforma.firma1?.estado != 'F'}">
                                <td width="25%" style="border: none"></td>
                                <td width="25%" style="border: none"></td>
                                <td width="25%" style="text-align: center; border: none"><b>Aprobado por:</b></td>
                                <td width="25%" style="border: none"></td>
                            </g:if>
                        </tr>
                    </table>

                    <table width="100%" style="border: none" border="none">
                        <tr>
                            <td width="50%" style=" text-align: center;border: none">
                                <g:if test="${reforma?.firma1?.estado == 'F'}">
                                    <g:if test="${resource(dir: 'firmas', file: reforma.firma1.path)}">
                                        <img src="${resource(dir: 'firmas', file: reforma.firma1.path)}" style="width: 150px;"/><br/>

                                        <div style="width: 150px; border-bottom: solid 1px; margin-left: 170px"></div>
                                        <b style="text-align: center">${reforma.firma1.usuario.nombre} ${reforma.firma1.usuario.apellido}<br/>
                                        </b>
                                        %{--<b style="text-align: center;">${reforma.firma1.usuario.cargoPersonal?.toString()?.toUpperCase()}<br/>--}%
                                        <b style="text-align: center;">${reforma.firma1.usuario.cargo?.toString()?.toUpperCase()}<br/>
                                        </b>
                                    </g:if>
                                    <g:else>
                                        <img src="${resource(dir: 'firmas', file: reforma.firma1.path)}" style="width: 150px;"/><br/>

                                        <div style="width: 150px; border-bottom: solid 1px; margin-left: 170px; margin-top: 150px"></div>
                                        <b style="text-align: center">${reforma.firma1.usuario.nombre} ${reforma.firma1.usuario.apellido}<br/>
                                        </b>
                                        %{--<b style="text-align: center;">${reforma.firma1.usuario.cargoPersonal?.toString()?.toUpperCase()}<br/>--}%
                                        <b style="text-align: center;">${reforma.firma1.usuario.cargo?.toString()?.toUpperCase()}<br/>
                                        </b>
                                    </g:else>

                                </g:if>
                            </td>
                            <td width="50%" style=" text-align: center;;border: none">
                                <g:if test="${reforma?.firma2?.estado == 'F'}">
                                    <g:if test="${resource(dir: 'firmas', file: reforma.firma2.path)}">
                                        <img src="${resource(dir: 'firmas', file: reforma.firma2.path)}" style="width: 150px;"/><br/>

                                        <div style="width: 150px; border-bottom: solid 1px; margin-left: 170px;"></div>
                                        <b class="center">${reforma.firma2.usuario.nombre} ${reforma.firma2.usuario.apellido}<br/>
                                        </b>
                                        %{--<b class="center">${reforma.firma2.usuario.cargoPersonal?.toString()?.toUpperCase()}<br/>--}%
                                        <b class="center">${reforma.firma2.usuario.cargo?.toString()?.toUpperCase()}<br/>
                                        </b>

                                    </g:if>
                                    <g:else>
                                        <img src="${resource(dir: 'firmas', file: reforma.firma2.path)}" style="width: 150px;"/><br/>

                                        <div style="width: 150px; border-bottom: solid 1px; margin-left: 170px; margin-top: 150px"></div>
                                        <b class="center">${reforma.firma2.usuario.nombre} ${reforma.firma2.usuario.apellido}<br/>
                                        </b>
                                        %{--<b class="center">${reforma.firma2.usuario.cargoPersonal?.toString()?.toUpperCase()}<br/>--}%
                                        <b class="center">${reforma.firma2.usuario.cargo?.toString()?.toUpperCase()}<br/>
                                        </b>
                                    </g:else>

                                </g:if>
                            </td>
                        </tr>
                    </table>
                </div>

            </div>
        </div>
    </body>
</html>