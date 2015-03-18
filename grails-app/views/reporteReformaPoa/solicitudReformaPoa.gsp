<%--
  Created by IntelliJ IDEA.
  User: fabricio
  Date: 02/03/15
  Time: 03:24 PM
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
    <title>Solicitud de reforma al POA</title>

    <rep:estilos orientacion="l" pagTitle="Solicitud de reforma al POA"/>

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

    /*th {*/
        /*background : #cccccc;*/
    /*}*/

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
        margin-bottom : 15px;
    }

    ol li:before {
        content           : counter(item) ". ";
        counter-increment : item;
        font-weight       : bold;
    }

    .table {
        border-collapse : collapse;
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
        margin-top  : 2cm;
        margin-left : 10cm;
    }
    .valor{
        text-align: right;
    }
    .ttl {
        text-align  : center;
        font-weight : bold;
    }

    </style>

</head>

<body>
    <rep:headerFooter title="SOLICITUD DE REFORMA AL POA" unidad="${anio}-GP"
                      numero="${ sol.id}" estilo="right"/>
<div style="margin-left: 10px;">
        <div>
            <ol>
                <li>
                    <strong>Unidad responsable (Gerencia - Dirección):</strong>${sol.usuario.unidad}
                </li>
                <li>
                    <strong>Tipo de reforma:</strong>
                    <table class="table " border="1" style="margin-left: 280px">
                        <thead>
                        <tr>
                            <th style="text-align: center">Detalle</th>
                            <th>(Marcar X)</th>
                        </tr>
                        </thead>
                        <tbody>
                        <tr>
                            <td>Reforma entre actividades por reasignación de recursos o saldos</td>
                            <td class="center">
                                ${sol.tipo=='R'?'X':''}
                            </td>
                        </tr>
                        <tr>
                            <td>Reforma por creación de una nueva actividad</td>
                            <td class="center">
                                ${sol.tipo=='N'?'X':''}
                            </td>
                        </tr>
                        <tr>
                            <td>Reforma por creación de una actividad derivada</td>
                            <td class="center">
                                ${sol.tipo=='D'?'X':''}
                            </td>
                        </tr>
                        <tr>
                            <td>Reforma por Incremento</td>
                            <td class="center">
                                ${sol.tipo=='A'?'X':''}
                            </td>
                        </tr>

                        </tbody>
                    </table>
                </li>
                <li style="margin-left: 20px">
                    <strong>Matriz de la reforma:</strong>
                    <g:set var="ti" value="${0}"/>
                    <g:set var="tvi" value="${0}"/>
                    <g:set var="tvf" value="${0}"/>
                    <g:set var="tf" value="${0}"/>

                    <table style="width:100%;" class="table " border="1">
                         <thead>
                        <tr>
                            <th style="background: #9dbfdb; text-align: center">Proyecto:</th>
                            <th style="background: #9dbfdb; text-align: center">Componente:</th>
                            <th style="background: #9dbfdb; text-align: center">Número <br/> de la <br/> actividad <br/> del POA</th>
                            <th style="background: #9dbfdb; text-align: center">Nueva <br/> actividad <br/> (Marcar x)</th>
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
                        <tr>
                            <td>${sol.origen.marcoLogico.proyecto.toStringCompleto()}</td>
                            <td>${sol.origen.marcoLogico.marcoLogico.toStringCompleto()}</td>
                            <td>
                                ${sol.fecha.format("yyyy")+'-'+sol.origen.marcoLogico.numero}
                                %{--*${sol.origen.marcoLogico.numero}*${sol.origen.marcoLogico.numeroComp}*${sol.origen.marcoLogico.marcoLogico.numero}*${sol.origen.marcoLogico.marcoLogico.numeroComp}*--}%
                            </td>
                            <td></td>
                            <td>${sol.origen.marcoLogico.toStringCompleto()}</td>
                            <td>${sol.origen.presupuesto.numero}</td>

                            <g:if test="${sol.tipo!='A'}">
                                <td class="valor">
                                    <g:formatNumber number="${sol.valorOrigenSolicitado}" format="###,##0" minFractionDigits="2" maxFractionDigits="2" />
                                    <g:set var="ti" value="${ti+sol.valorOrigenSolicitado}"/>
                                </td>
                                <td class="valor">
                                <g:if test="${sol.tipo!='E'}">
                                     <g:formatNumber number="${sol.valor}" format="###,##0" minFractionDigits="2" maxFractionDigits="2" />
                                    <g:set var="tvi" value="${tvi+sol.valor}"/>
                                </g:if>
                                <g:else>
                                    <g:formatNumber number="${sol.valorOrigenSolicitado}" format="###,##0" minFractionDigits="2" maxFractionDigits="2" />
                                </g:else>
                                </td>
                                <td  class="valor">
                                    <g:formatNumber number="${0}" format="###,##0" minFractionDigits="2" maxFractionDigits="2" />
                                </td>
                                <td class="valor">
                                    <g:if test="${sol.tipo!='E'}">
                                        <g:formatNumber number="${sol.valorOrigenSolicitado-sol.valor}" format="###,##0" minFractionDigits="2" maxFractionDigits="2" />
                                        <g:set var="tf" value="${tvf+(sol.valorOrigenSolicitado-sol.valor)}"/>
                                    </g:if>
                                    <g:else>
                                        <g:formatNumber number="${0}" format="###,##0" minFractionDigits="2" maxFractionDigits="2" />
                                    %{--<g:set var="tf" value="${tf}"></g:set>--}%
                                    </g:else>
                                </td>
                            </g:if>
                            <g:else>
                                <td class="valor">
                                 <g:formatNumber number="${sol.valorOrigenSolicitado}" format="###,##0" minFractionDigits="2" maxFractionDigits="2" />
                                    <g:set var="ti" value="${ti+sol.valorOrigenSolicitado}"/>
                                </td>
                                <td class="valor">
                                    <g:formatNumber number="${0}" format="###,##0" minFractionDigits="2" maxFractionDigits="2" />
                                </td>
                                <td class="valor">
                                    <g:formatNumber number="${sol.valor}" format="###,##0" minFractionDigits="2" maxFractionDigits="2" />
                                    <g:set var="tvf" value="${tvf+sol.valor}"/>
                                </td>

                                <td class="valor">
                                    <g:formatNumber number="${sol.valorOrigenSolicitado+sol.valor}" format="###,##0" minFractionDigits="2" maxFractionDigits="2" />
                                    <g:set var="tf" value="${tf+sol.valorOrigenSolicitado}"/>
                                </td>
                            </g:else>
                        </tr>
                        <g:if test="${sol.tipo!='A'}">
                            <tr>
                                <g:if test="${sol.destino}">
                                    <td>${sol.destino.marcoLogico.proyecto.toStringCompleto()}</td>
                                    <td>${sol.destino.marcoLogico.marcoLogico.toStringCompleto()}</td>
                                    <td>${sol.fecha.format("yyyy")+'-'+sol.destino.marcoLogico.numero}</td>
                                    <td></td>
                                    <td>${sol.destino.marcoLogico.toStringCompleto()}</td>
                                    <td>${sol.destino.presupuesto.numero}</td>

                                    <td class="valor">
                                      <g:formatNumber number="${sol.valorDestinoSolicitado}" format="###,##0" minFractionDigits="2" maxFractionDigits="2" />
                                        <g:set var="ti" value="${ti+sol.valorDestinoSolicitado}"/>
                                    </td>
                                    <td class="valor">
                                        <g:formatNumber number="${0}" format="###,##0" minFractionDigits="2" maxFractionDigits="2" />
                                    </td>
                                    <td class="valor">
                                        <g:formatNumber number="${sol.valor}" format="###,##0" minFractionDigits="2" maxFractionDigits="2"/>
                                        <g:set var="tvf" value="${tvf+sol.valor}"/>
                                    </td>
                                    <td class="valor">
                                        <g:formatNumber number="${sol.valorDestinoSolicitado+sol.valor}" format="###,##0" minFractionDigits="2" maxFractionDigits="2" />
                                        <g:set var="tf" value="${tf+(sol.valorDestinoSolicitado+sol.valor)}"/>
                                    </td>
                                </g:if>
                                <g:else>
                                    <g:if test="${sol.tipo=='N'}">
                                        <td>${sol.origen.marcoLogico.proyecto.toStringCompleto()}</td>
                                        <td>${sol.origen.marcoLogico.marcoLogico.toStringCompleto()}</td>
                                        <td>${sol.fecha.format("yyyy")+'-'+sol.origen.marcoLogico.numero}</td>
                                        <td></td>
                                        <td>${sol.actividad}</td>
                                        <td>${sol.presupuesto.numero}</td>

                                        <td class="valor">
                                           <g:formatNumber number="${0}" format="###,##0" minFractionDigits="2" maxFractionDigits="2" ></g:formatNumber>
                                        </td>
                                        <td class="valor">
                                            <g:formatNumber number="${0}" format="###,##0" minFractionDigits="2" maxFractionDigits="2" ></g:formatNumber>
                                        </td>
                                        <td class="valor">
                                            <g:formatNumber number="${sol.valor}" format="###,##0" minFractionDigits="2" maxFractionDigits="2" ></g:formatNumber>
                                            <g:set var="tvf" value="${tvf+sol.valor}"></g:set>
                                        </td>
                                        <td class="valor">
                                            <g:formatNumber number="${sol.valor}" format="###,##0" minFractionDigits="2" maxFractionDigits="2" ></g:formatNumber>
                                        </td>
                                        <g:set var="tf" value="${tf+sol.valor}"></g:set>
                                    </g:if>
                                    <g:else>
                                        <td>${sol.origen.marcoLogico.proyecto.toStringCompleto()}</td>
                                        <td>${sol.origen.marcoLogico.marcoLogico.toStringCompleto()}</td>
                                        <td>${sol.fecha.format("yyyy")+'-'+sol.origen.marcoLogico.numero}</td>
                                         <td></td>
                                        <td>${sol.origen.marcoLogico.toStringCompleto()}</td>
                                        <td>${sol.origen.presupuesto.numero}</td>
                                        <td class="valor">
                                          <g:formatNumber number="${0}" format="###,##0" minFractionDigits="2" maxFractionDigits="2" ></g:formatNumber>
                                        </td>
                                        <td class="valor">
                                            <g:formatNumber number="${0}" format="###,##0" minFractionDigits="2" maxFractionDigits="2" ></g:formatNumber>
                                        </td>
                                        <td class="valor">
                                            <g:formatNumber number="${sol.valor}" format="###,##0" minFractionDigits="2" maxFractionDigits="2" ></g:formatNumber>
                                            <g:set var="tvf" value="${tvf+sol.valor}"></g:set>
                                        </td>
                                        <td class="valor">
                                            <g:formatNumber number="${sol.valor}" format="###,##0" minFractionDigits="2" maxFractionDigits="2" ></g:formatNumber>
                                            <g:set var="tf" value="${tf+sol.valor}"></g:set>
                                        </td>
                                    </g:else>
                                </g:else>

                            </tr>
                        </g:if>
                        <g:else>
                            <tr>
                                <td colspan="6">
                                    Redistribución de fondos
                                </td>
                                <td class="valor">
                                    <g:set var="ti" value="${ti+sol.valor}"></g:set>
                                    <g:formatNumber number="${sol.valor}" format="###,##0" minFractionDigits="2" maxFractionDigits="2" ></g:formatNumber>
                                </td>
                                <td class="valor">
                                    <g:formatNumber number="${sol.valor}" format="###,##0" minFractionDigits="2" maxFractionDigits="2" ></g:formatNumber>
                                    <g:set var="tvi" value="${tvi+sol.valor}"></g:set>
                                </td>
                                <td class="valor">
                                    <g:formatNumber number="${0}" format="###,##0" minFractionDigits="2" maxFractionDigits="2" ></g:formatNumber>
                                </td>
                                <td class="valor">
                                    <g:formatNumber number="${0}" format="###,##0" minFractionDigits="2" maxFractionDigits="2" ></g:formatNumber>
                                    <g:set var="tf" value="${tf+sol.valor}"></g:set>
                                </td>
                            </tr>
                        </g:else>
                        <tr>
                            <td colspan="5"></td>
                            <td style="font-weight: bold; background: #008080">TOTAL</td>
                            <td style="font-weight: bold; background: #008080" class="valor"> <g:formatNumber number="${ti}" format="###,##0" minFractionDigits="2" maxFractionDigits="2" ></g:formatNumber></td>
                            <td  style="font-weight: bold; background: #008080" class="valor"> <g:formatNumber number="${tvi}" format="###,##0" minFractionDigits="2" maxFractionDigits="2" ></g:formatNumber></td>
                            <td style="font-weight: bold; background: #008080" class="valor"> <g:formatNumber number="${tvf}" format="###,##0" minFractionDigits="2" maxFractionDigits="2" ></g:formatNumber></td>
                            <td style="font-weight: bold; background: #008080" class="valor"> <g:formatNumber number="${tf}" format="###,##0" minFractionDigits="2" maxFractionDigits="2" ></g:formatNumber></td>
                        </tr>
                        </tbody>
                    </table>
                </li>
                <li style="margin-left: 20px">
                    <strong>Justificación de la reforma al POA solicitada:</strong>

                    <div class="justificacion" style="margin-left: 20px">
                        ${sol.concepto}
                    </div>
                </li>

            </ol>
            <div style="margin-left: 20px">
                Es importante señalar que la reforma no implica un incremento en el techo del presupuesto programado y que el impacto
                causado por la modificación de POA no afecta a los objetivos institucionales
            </div>
            <div class="firma ">
                <div>
                    <span class="spanFirma">
                        <g:if test="${sol?.firmaSol?.estado=='F'}">
                            <img src="${resource(dir: 'firmas',file: sol.firmaSol.path)}"/><br/>
                            f) <div style="border-bottom: solid; width: 150px"> </div>
                            ${sol.firmaSol.usuario.nombre} ${sol.firmaSol.usuario.apellido}<br/>
                            <b>GERENTE DE ${sol.firmaSol.usuario.cargoPersonal?.toString()?.toUpperCase()}<br/></b>
                        </g:if>
                    </span>
                </div>
            </div>
        </div>
</div>
</body>
</html>