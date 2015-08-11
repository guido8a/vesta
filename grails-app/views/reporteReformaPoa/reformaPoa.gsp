<%--
  Created by IntelliJ IDEA.
  User: fabricio
  Date: 03/03/15
  Time: 11:36 AM
--%>

<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 21/10/14
  Time: 03:10 PM
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
            border     : solid 1px #000000;
        }

        .center {
            text-align : center;
        }

        .right {
            text-align : right;
        }

        .justificacion {
            border     : solid 1px #000000;
            margin-top : 5px;
            padding    : 10px;
        }

        .firma {
            margin-left : 4cm;
            float       : left;
        }

        .negro {
            background : #000000;
            color      : #f5f5f5;
        }

        .numeracion {
            height : 35px;
        }

        .fright {
            float : right;
        }

        .firmas {
            margin-top : 2cm;
            width      : 100%;
            height     : 3cm;
        }

        .valor {
            text-align : right;
        }

        .formato {
            font-weight: bold;
            background: #008080;
            color: #ffffff;
        }

        td {
            border: solid 1px #000000;

        }
        th {
            border: solid 1px #000000;
        }


        </style>
    </head>

    <body>
        <rep:headerFooter title="REFORMA AL POA" unidad="${anio}-GP"
                          numero="${elm.imprimeNumero(solicitud: sol.id)}" estilo="right"/>
        <div style="margin-left: 10px;">
            <div>
                <ol>
                    <li>
                        <strong>Unidad responsable (Gerencia-Dirección):</strong> ${sol.usuario.unidad}
                    </li>
                    <li>
                        <strong>Matriz de la reforma:</strong>
                        <g:set var="ti" value="${0}"/>
                        <g:set var="tvi" value="${0}"/>
                        <g:set var="tvf" value="${0}"/>
                        <g:set var="tf" value="${0}"/>
                        <table style="width:100%;margin-top: 15px" class="table " border="1">
                            <thead>
                                <tr>
                                    <th style="background: #9dbfdb; text-align: center">Proyecto:</th>
                                    <th style="background: #9dbfdb; text-align: center">Componente:</th>
                                    <th style="background: #9dbfdb; text-align: center">No</th>
                                    <th style="background: #9dbfdb; text-align: center">Nombre de la actividad:</th>
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
                                <tr>
                                    <td>${sol.origen.marcoLogico.proyecto.toStringCompleto()}</td>
                                    <td>${sol.origen.marcoLogico.marcoLogico.toStringCompleto()}</td>
                                    <td>${sol.fecha.format("yyyy") + '-' + sol.origen.marcoLogico.numero}</td>
                                    <td>${sol.origen.marcoLogico.toStringCompleto()}</td>
                                    <td>${sol.origen.presupuesto.numero}</td>
                                    <g:if test="${sol.tipo != 'A'}">
                                        <td class="valor">
                                            <g:formatNumber number="${sol.valorOrigenSolicitado}" format="###,##0" minFractionDigits="2" maxFractionDigits="2"/>
                                            <g:set var="ti" value="${ti + sol.valorOrigenSolicitado}"/>
                                        </td>
                                        <g:if test="${sol.tipo != 'E'}">
                                            <td class="valor"><g:formatNumber number="${sol.valor}" format="###,##0" minFractionDigits="2" maxFractionDigits="2"/></td>
                                            <g:set var="tvi" value="${tvi + sol.valor}"/>
                                        </g:if>
                                        <g:else>
                                            <td class="valor"><g:formatNumber number="${sol.valorOrigenSolicitado}" format="###,##0" minFractionDigits="2" maxFractionDigits="2"/></td>
                                        </g:else>
                                        <td class="valor">
                                            <g:formatNumber number="${0}" format="###,##0" minFractionDigits="2" maxFractionDigits="2"/>
                                        </td>
                                        <td class="valor">
                                            <g:if test="${sol.tipo != 'E'}">
                                                <g:formatNumber number="${sol.valorOrigenSolicitado - sol.valor}" format="###,##0" minFractionDigits="2" maxFractionDigits="2"/>
                                                <g:set var="tf" value="${tvf + (sol.valorOrigenSolicitado - sol.valor)}"/>
                                            </g:if>
                                            <g:else>
                                                <g:formatNumber number="${0}" format="###,##0" minFractionDigits="2" maxFractionDigits="2"/>
                                            %{--<g:set var="tf" value="${tf}"/>--}%
                                            </g:else>
                                        </td>
                                    </g:if>
                                    <g:else>
                                        <td class="valor">
                                            <g:formatNumber number="${sol.valorOrigenSolicitado}" format="###,##0" minFractionDigits="2" maxFractionDigits="2"/>
                                            <g:set var="ti" value="${ti + sol.valorOrigenSolicitado}"/>
                                        </td>
                                        <td class="valor">
                                            <g:formatNumber number="${0}" format="###,##0" minFractionDigits="2" maxFractionDigits="2"/>
                                        </td>
                                        <td class="valor">
                                            <g:formatNumber number="${sol.valor}" format="###,##0" minFractionDigits="2" maxFractionDigits="2"/>
                                            <g:set var="tvf" value="${tvf + sol.valor}"/>
                                        </td>

                                        <td class="valor">
                                            <g:formatNumber number="${sol.valorOrigenSolicitado + sol.valor}" format="###,##0" minFractionDigits="2" maxFractionDigits="2"/>
                                            <g:set var="tf" value="${tf + sol.valorOrigenSolicitado}"/>
                                        </td>
                                    </g:else>
                                </tr>
                                <g:if test="${sol.tipo != 'A'}">
                                    <tr>
                                        <g:if test="${sol.destino}">
                                            <td>${sol.destino.marcoLogico.proyecto.toStringCompleto()}</td>
                                            <td>${sol.destino.marcoLogico.marcoLogico.toStringCompleto()}</td>
                                            <td>${sol.fecha.format("yyyy") + '-' + sol.destino.marcoLogico.numero}</td>
                                            <td>${sol.destino.marcoLogico.toStringCompleto()}</td>
                                            <td>${sol.destino.presupuesto.numero}</td>
                                            <td class="valor">
                                                <g:formatNumber number="${sol.valorDestinoSolicitado}" format="###,##0" minFractionDigits="2" maxFractionDigits="2"/>
                                                <g:set var="ti" value="${ti + sol.valorDestinoSolicitado}"/>
                                            </td>
                                            <td class="valor">
                                                <g:formatNumber number="${0}" format="###,##0" minFractionDigits="2" maxFractionDigits="2"/>
                                            </td>
                                            <td class="valor">
                                                <g:formatNumber number="${sol.valor}" format="###,##0" minFractionDigits="2" maxFractionDigits="2"/>
                                                <g:set var="tvf" value="${tvf + sol.valor}"/>
                                            </td>
                                            <td class="valor">
                                                <g:formatNumber number="${sol.valorDestinoSolicitado + sol.valor}" format="###,##0" minFractionDigits="2" maxFractionDigits="2"/>
                                                <g:set var="tf" value="${tf + (sol.valorDestinoSolicitado + sol.valor)}"/>
                                            </td>
                                        </g:if>
                                        <g:else>
                                            <g:if test="${sol.tipo == 'N'}">
                                                <td>${sol.origen.marcoLogico.proyecto.toStringCompleto()}</td>
                                                <td>${sol.origen.marcoLogico.marcoLogico.toStringCompleto()}</td>
                                                <td>${sol.fecha.format("yyyy") + '-' + sol.origen.marcoLogico.numero}</td>
                                                <td>${sol.actividad}</td>
                                                <td>${sol.presupuesto.numero}</td>
                                                <td class="valor">
                                                    <g:formatNumber number="${0}" format="###,##0" minFractionDigits="2" maxFractionDigits="2"/>
                                                </td>
                                                <td class="valor">
                                                    <g:formatNumber number="${0}" format="###,##0" minFractionDigits="2" maxFractionDigits="2"/>
                                                </td>
                                                <td class="valor">
                                                    <g:formatNumber number="${sol.valor}" format="###,##0" minFractionDigits="2" maxFractionDigits="2"/>
                                                    <g:set var="tvf" value="${tvf + sol.valor}"/>
                                                </td>
                                                <td class="valor">
                                                    <g:formatNumber number="${sol.valor}" format="###,##0" minFractionDigits="2" maxFractionDigits="2"/>
                                                </td>
                                                <g:set var="tf" value="${tf + sol.valor}"/>
                                            </g:if>
                                            <g:else>
                                                <td>${sol.origen.marcoLogico.proyecto.toStringCompleto()}</td>
                                                <td>${sol.origen.marcoLogico.marcoLogico.toStringCompleto()}</td>
                                                <td>${sol.fecha.format("yyyy") + '-' + sol.origen.marcoLogico.numero}</td>
                                                <td>${sol.origen.marcoLogico.toStringCompleto()}</td>
                                                <td>${sol.origen.presupuesto.numero}</td>
                                                <td class="valor">
                                                    <g:formatNumber number="${0}" format="###,##0" minFractionDigits="2" maxFractionDigits="2"/>
                                                </td>
                                                <td class="valor">
                                                    <g:formatNumber number="${0}" format="###,##0" minFractionDigits="2" maxFractionDigits="2"/>
                                                </td>
                                                <td class="valor">
                                                    <g:formatNumber number="${sol.valor}" format="###,##0" minFractionDigits="2" maxFractionDigits="2"/>
                                                    <g:set var="tvf" value="${tvf + sol.valor}"/>
                                                </td>
                                                <td class="valor">
                                                    <g:formatNumber number="${sol.valor}" format="###,##0" minFractionDigits="2" maxFractionDigits="2"/>
                                                    <g:set var="tf" value="${tf + sol.valor}"/>
                                                </td>
                                            </g:else>
                                        </g:else>

                                    </tr>
                                </g:if>
                                <g:else>
                                    <tr>
                                        <td colspan="5">
                                            Redistribución de fondos
                                        </td>
                                        <td class="valor">
                                            <g:set var="ti" value="${ti + sol.valor}"/>
                                            <g:formatNumber number="${sol.valor}" format="###,##0" minFractionDigits="2" maxFractionDigits="2"/>
                                        </td>
                                        <td class="valor">
                                            <g:formatNumber number="${sol.valor}" format="###,##0" minFractionDigits="2" maxFractionDigits="2"/>
                                            <g:set var="tvi" value="${tvi + sol.valor}"/>
                                        </td>
                                        <td class="valor">
                                            <g:formatNumber number="${0}" format="###,##0" minFractionDigits="2" maxFractionDigits="2"/>
                                        </td>
                                        <td class="valor">
                                            <g:formatNumber number="${0}" format="###,##0" minFractionDigits="2" maxFractionDigits="2"/>
                                            <g:set var="tf" value="${tf + sol.valor}"/>
                                        </td>
                                    </tr>
                                </g:else>
                                <tr style="background: #008080">
                                    <td colspan="4"></td>
                                    <td class="formato">TOTAL</td>
                                    <td class="valor formato"><g:formatNumber number="${ti}" format="###,##0" minFractionDigits="2" maxFractionDigits="2"/></td>
                                    <td class="valor formato"><g:formatNumber number="${tvi}" format="###,##0" minFractionDigits="2" maxFractionDigits="2"/></td>
                                    <td class="valor formato"><g:formatNumber number="${tvf}" format="###,##0" minFractionDigits="2" maxFractionDigits="2"/></td>
                                    <td class="valor formato"><g:formatNumber number="${tf}" format="###,##0" minFractionDigits="2" maxFractionDigits="2"/></td>
                                </tr>
                            </tbody>
                        </table>
                    </li>
                </ol>

                <div style="margin-bottom: 10px">
                    %{--<strong>Observación:</strong>  La reforma efectuada corresponde al tipo " ${sol?.tipo} "; es importante señalar que la reforma no implicó modificación al monto aprobado--}%
                    <strong>Observación:</strong>  ${sol.observaciones}
                </div>
                <div>
                    <strong>Elaborado por:</strong> ${sol.revisor?.sigla}
                </div>
                <div class="fright">
                    <strong>FECHA:</strong> ${sol.fechaRevision?.format("dd-MM-yyyy")}
                </div>

                <div class="no-break">
                <table width="100%" style="margin-top: 0.5cm; border: none" border="none">
                    <tr>
                        <g:if test="${sol.firma1?.estado == 'F' && sol.firma2?.estado == 'F'}">
                            <td width="25%" style="text-align: center; border: none"><b>Revisado por:</b></td>
                            <td width="25%" style="border: none"></td>
                            <td width="25%" style="text-align: center; border: none"><b>Aprobado por:</b></td>
                            <td width="25%" style="border: none"></td>
                        </g:if>

                        <g:if test="${sol.firma1?.estado == 'F' && sol.firma2?.estado != 'F' }">
                            <td width="25%" style="text-align: center; border: none"><b>Revisado por:</b></td>
                            <td width="25%" style="border: none"></td>
                            <td width="25%" style="border: none"></td>
                            <td width="25%" style="border: none"></td>
                        </g:if>
                        <g:if test="${sol.firma2?.estado == 'F' && sol.firma1?.estado != 'F'}">
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
                            <g:if test="${sol?.firma1?.estado == 'F'}">
                                <g:if test="${resource(dir: 'firmas', file: sol.firma1.path)}">
                                    <img src="${resource(dir: 'firmas', file: sol.firma1.path)}" style="width: 150px;"/><br/>
                                    <div style="width: 150px; border-bottom: solid 1px; margin-left: 170px"></div>
                                    <b style="text-align: center">${sol.firma1.usuario.nombre} ${sol.firma1.usuario.apellido}<br/>
                                    </b>
                                    %{--<b style="text-align: center;">${sol.firma1.usuario.cargoPersonal?.toString()?.toUpperCase()}<br/>--}%
                                    <b style="text-align: center;">${sol.firma1.usuario.cargo?.toString()?.toUpperCase()}<br/>
                                    </b>
                                </g:if>
                                <g:else>
                                    <img src="${resource(dir: 'firmas', file: sol.firma1.path)}" style="width: 150px;"/><br/>
                                    <div style="width: 150px; border-bottom: solid 1px; margin-left: 170px; margin-top: 150px"></div>
                                    <b style="text-align: center">${sol.firma1.usuario.nombre} ${sol.firma1.usuario.apellido}<br/>
                                    </b>
                                    %{--<b style="text-align: center;">${sol.firma1.usuario.cargoPersonal?.toString()?.toUpperCase()}<br/>--}%
                                    <b style="text-align: center;">${sol.firma1.usuario.cargo?.toString()?.toUpperCase()}<br/>
                                    </b>
                                </g:else>

                            </g:if>
                        </td>
                        <td width="50%" style=" text-align: center;;border: none">
                            <g:if test="${sol?.firma2?.estado == 'F'}">
                                <g:if test="${resource(dir: 'firmas', file: sol.firma2.path)}">
                                    <img src="${resource(dir: 'firmas', file: sol.firma2.path)}" style="width: 150px;"/><br/>
                                    <div style="width: 150px; border-bottom: solid 1px; margin-left: 170px;"></div>
                                    <b class="center">${sol.firma2.usuario.nombre} ${sol.firma2.usuario.apellido}<br/>
                                    </b>
                                    %{--<b class="center">${sol.firma2.usuario.cargoPersonal?.toString()?.toUpperCase()}<br/>--}%
                                    <b class="center">${sol.firma2.usuario.cargo?.toString()?.toUpperCase()}<br/>
                                    </b>

                                </g:if>
                                <g:else>
                                    <img src="${resource(dir: 'firmas', file: sol.firma2.path)}" style="width: 150px;"/><br/>
                                    <div style="width: 150px; border-bottom: solid 1px; margin-left: 170px; margin-top: 150px"></div>
                                    <b class="center">${sol.firma2.usuario.nombre} ${sol.firma2.usuario.apellido}<br/>
                                    </b>
                                    %{--<b class="center">${sol.firma2.usuario.cargoPersonal?.toString()?.toUpperCase()}<br/>--}%
                                    <b class="center">${sol.firma2.usuario.cargo?.toString()?.toUpperCase()}<br/>
                                    </b>
                                </g:else>

                            </g:if>
                        </td>
                    </tr>
                </table>
</div>

                %{--<div class="no-break" style="border: solid 1px; width: 300px; height: 100px; margin-left: 220px">--}%
                    %{--<b>Recepción:</b>--}%
                %{--</div>--}%
            </div>
        </div>
    </body>
</html>