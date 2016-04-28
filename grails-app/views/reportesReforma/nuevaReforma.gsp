<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="vesta.parametros.UnidadEjecutora; vesta.seguridad.FirmasService" %>
<%
    def firmasService = grailsApplication.classLoader.loadClass('vesta.seguridad.FirmasService').newInstance()
%>


<html>
<head>
    <meta name="layout" content="reportesReformaSolicitud"/>
    <title>
        ${reforma.tituloSolicitud}
    </title>

    <style type="text/css">

    .formato {
        font-weight : bold;
        background  : #008080;
        color       : #ffffff;
    }
    </style>


</head>

<body>

<rep:headerFooter title="${reforma.tituloSolicitud.toUpperCase()}"
                  form=" GPE-DPI-003"
                  unidad="${unidades.unidad}"
                  numero="${reforma.numero}" estilo="right"/>

<div style="margin-left: 10px;">
    <div>
        <ol>
            <li>
                <strong>Unidad responsable (Gerencia - Dirección):</strong>
                ${uni}
            </li>
            <li>
                <strong>Tipo de ${reforma.tipo == 'R' ? 'reforma' : 'ajuste'}:</strong>
                <elm:tipoReforma reforma="${reforma}"/>
            </li>
            <li>
                <strong>Matriz de la ${reforma.tipoString}:</strong>

                <g:set var="totalOrigen" value="${0}"/>
                <g:set var="disminucion" value="${0}"/>
                <g:set var="incremento" value="${0}"/>
                <g:set var="montoFinal" value="${0}"/>

                <table class="table table-hover table-condensed table-hover table-bordered">
                    <thead>
                    <tr>
                        <th>Año</th>
                        <th>Fuente</th>
                        <th>Proyecto</th>
                        <th>Componente</th>
                        <th>Actividad</th>
                        <th>Partida</th>
                        <th>Responsable</th>
                        <th>Valor inicial<br/>USD</th>
                        <th>Disminución<br/>USD</th>
                        <th>Aumento<br/>USD</th>
                        <th>Valor final<br/>USD</th>
                    </tr>
                    </thead>
                    <tbody class="tb">
                    <g:each in="${detallesReforma}" var="detallesNuevos">
                        <g:if test="${detallesNuevos?.tipoReforma?.codigo == 'O' && detallesNuevos?.solicitado != 'R'}">
                            <tr>
                                <td style="width: 4%">${detallesNuevos?.anio}</td>
                                <td style="width:4%">${detallesNuevos?.fuente?.codigo}</td>
                                <td style="width: 15%">${detallesNuevos?.componente?.proyecto?.nombre}</td>
                                <td style="width: 12%">${detallesNuevos?.componente?.objeto}</td>
                                <td style="width: 15%">${detallesNuevos?.asignacionOrigen?.marcoLogico?.numero} - ${detallesNuevos?.asignacionOrigen?.marcoLogico?.objeto}</td>
                                <td style="width: 6%; text-align: center">${detallesNuevos?.asignacionOrigen?.presupuesto?.numero}</td>
                                %{--<td style='width:8%; text-align: center'>${detallesNuevos?.responsable?.codigo}</td>--}%
                                <td style='width:8%; text-align: center'>${firmasService.requirentes(vesta.parametros.UnidadEjecutora.findByCodigo(detallesNuevos?.responsable?.codigo))?.codigo}</td>
                                <td style="width: 8%; text-align: right"><g:formatNumber number="${detallesNuevos?.valorOrigenInicial}" maxFractionDigits="2" minFractionDigits="2" format="##,###"/></td>
                                <td style="width: 9%; text-align: right;"><g:formatNumber number="${detallesNuevos?.valor}" maxFractionDigits="2" minFractionDigits="2" format="##,###"/></td>
                                <td style="width: 9%; text-align: center ">${' --- '}</td>
                                <td style="width: 8%; text-align: right"><g:formatNumber number="${detallesNuevos?.valorOrigenInicial - detallesNuevos?.valor}" maxFractionDigits="2" minFractionDigits="2" format="##,###"/></td>
                            </tr>
                            <g:set var="disminucion" value="${disminucion += detallesNuevos?.valor}"/>
                            <g:set var="montoFinal" value="${montoFinal += (detallesNuevos?.valorOrigenInicial - detallesNuevos?.valor)}"/>
                        </g:if>
                        <g:if test="${detallesNuevos?.tipoReforma?.codigo == 'E' || detallesNuevos?.tipoReforma?.codigo == 'P' }">
                            <tr>
                                <td style="width: 4%">${detallesNuevos?.anio}</td>
                                <td style="width:4%">${detallesNuevos?.fuente?.codigo}</td>
                                <td style="width: 15%">${detallesNuevos?.componente?.proyecto?.nombre}</td>
                            <g:if test="${detallesNuevos?.tipoReforma?.codigo == 'P'}">
                                <td style="width: 12%">${detallesNuevos?.componente?.marcoLogico?.objeto}</td>
                                <td style="width: 15%">${detallesNuevos?.componente?.numero} - ${detallesNuevos?.componente?.objeto}</td>
                            </g:if>
                            <g:else>
                                <td style="width: 12%">${detallesNuevos?.componente?.objeto}</td>
                                <td style="width: 15%">${detallesNuevos?.asignacionOrigen?.marcoLogico?.numero} - ${detallesNuevos?.asignacionOrigen?.marcoLogico?.objeto}</td>
                            </g:else>

                                <g:if test="${detallesNuevos?.tipoReforma?.codigo == 'P'}">
                                    <td style='width:6%; text-align: center'>${detallesNuevos?.presupuesto?.numero}</td>
                                </g:if>
                                <g:else>
                                    <td style='width:6%; text-align: center'>${detallesNuevos?.asignacionOrigen?.presupuesto?.numero}</td>
                                </g:else>
                                %{--<td style='width:8%; text-align: center'>${detallesNuevos?.responsable?.codigo}</td>--}%
                                <td style='width:8%; text-align: center'>${firmasService.requirentes(vesta.parametros.UnidadEjecutora.findByCodigo(detallesNuevos?.responsable?.codigo))?.codigo}</td>
                                <td style='width:8%; text-align: right'><g:formatNumber number="${detallesNuevos?.valorDestinoInicial}" maxFractionDigits="2" minFractionDigits="2" format="##,###"/></td>
                                <td style='width:9%; text-align: center'>${' --- '}</td>
                                <td style='width:9%; text-align: right'><g:formatNumber number="${detallesNuevos?.valor}" maxFractionDigits="2" minFractionDigits="2" format="##,###"/></td>
                                <td style='width:8%; text-align: right'><g:formatNumber number="${detallesNuevos?.valorDestinoInicial + detallesNuevos?.valor}" maxFractionDigits="2" minFractionDigits="2" format="##,###"/></td>
                            </tr>
                            <g:set var="incremento" value="${incremento += detallesNuevos?.valor}"/>
                            <g:set var="montoFinal" value="${montoFinal += (detallesNuevos?.valorDestinoInicial + detallesNuevos?.valor)}"/>
                        </g:if>
                        <g:if test="${detallesNuevos?.tipoReforma?.codigo == 'A'}" >
                            <tr>
                                <g:set var="nuevaActv" value="${vesta.proyectos.MarcoLogico.findByObjeto(detallesNuevos?.descripcionNuevaActividad)?.numero}"/>
                                <g:if test="${nuevaActv}">
                                    <g:set var="nuevaActvStr" value="${nuevaActv} - "/>
                                </g:if>
                                <g:else>
                                    <g:set var="nuevaActvStr" value="S/N - "/>
                                </g:else>
                                <td style="width: 4%">${detallesNuevos?.anio}</td>
                                <td style="width:4%">${detallesNuevos?.fuente?.codigo}</td>
                                <td style='width:15%'>${detallesNuevos?.componente?.proyecto?.nombre}</td>
                                <td style='width:12%'>${detallesNuevos?.componente?.objeto}</td>
                                <td style='width:15%'>${nuevaActvStr}${detallesNuevos?.descripcionNuevaActividad}</td>
                                <td style='width:6%; text-align: center'>${detallesNuevos?.presupuesto?.numero}</td>
                                %{--<td style='width:8%; text-align: center'>${detallesNuevos?.responsable?.codigo}</td>--}%
                                <td style='width:8%; text-align: center'>${firmasService.requirentes(vesta.parametros.UnidadEjecutora.findByCodigo(detallesNuevos?.responsable?.codigo))?.codigo}</td>

                                <td style='width:8%; text-align: center'>${' --- '}</td>
                                <td style='width:9%; text-align: center'>${' --- '}</td>
                                <td style='width:9%; text-align: right'><g:formatNumber number="${detallesNuevos?.valor}" maxFractionDigits="2" minFractionDigits="2" format="##,###"/></td>
                                <td style='width:8%; text-align: right'><g:formatNumber number="${detallesNuevos?.valor}" maxFractionDigits="2" minFractionDigits="2" format="##,###"/></td>
                            </tr>
                            <g:set var="incremento" value="${incremento += detallesNuevos?.valor}"/>
                            <g:set var="montoFinal" value="${montoFinal += detallesNuevos?.valor}"/>
                        </g:if>
                        <g:set var="totalOrigen" value="${totalOrigen += (detallesNuevos?.valorDestinoInicial + detallesNuevos?.valorOrigenInicial)}"/>
                    </g:each>
                    </tbody>
                    <tfoot>
                    <tr>
                        <th colspan="7" class="formato" style="text-align: center">TOTAL: </th>
                        <th style="width: 8%; text-align: right" class="formato"><g:formatNumber number="${totalOrigen}" maxFractionDigits="2" minFractionDigits="2" format="##,###"/></th>
                        <th style="width: 9%; text-align: right" class="formato"><g:formatNumber number="${disminucion}" maxFractionDigits="2" minFractionDigits="2" format="##,###"/></th>
                        <th style="width: 9%; text-align: right" class="formato"><g:formatNumber number="${incremento}" maxFractionDigits="2" minFractionDigits="2" format="##,###"/></th>
                        <th style="width: 8%; text-align: right" class="formato"><g:formatNumber number="${montoFinal}" maxFractionDigits="2" minFractionDigits="2" format="##,###"/></th>
                    </tr>
                    </tfoot>
                </table>

            </li>
            <li class="no-break" style="margin-top: 15px">
                <strong>Justificación ${reforma.tipo == 'R' ? 'de la reforma' : ('del ajuste' + reforma.tipo == 'C' ? ' corriente' : '')} al POA solicitada:</strong>

                <div class="justificacion">
                    ${reforma.concepto.decodeHTML()}
                </div>
            </li>
        </ol>

        <div>
            <strong>Elaborado por:</strong> ${reforma.persona.sigla ?: reforma.persona.nombre + ' ' + reforma.persona.apellido}
        </div>

        <div class="fright">
            <strong>FECHA:</strong> ${reforma?.firmaSolicitud?.fecha?.format("dd-MM-yyyy")}
        </div>

        <div style="margin-top: 10px;">
            Es importante señalar que ${reforma.tipo == 'R' ? 'la reforma' : 'el ajuste'} no implica un incremento en el techo del presupuesto programado y que el impacto
            causado por la modificación de POA no afecta a los objetivos institucionales
        </div>

        <div class="firma no-break" style="text-align: center;">
            <span class="spanFirma">
                <g:if test="${reforma?.firmaSolicitud?.estado == 'F'}">
                    <img src="${resource(dir: 'firmas', file: reforma?.firmaSolicitud?.path)}" style="width: 150px;"/><br/>
                    <b>
                        ${reforma?.firmaSolicitud?.usuario?.nombre} ${reforma?.firmaSolicitud?.usuario?.apellido}<br/>
                    </b>
                    <b>
                        ${reforma?.firmaSolicitud?.usuario?.cargo?.toString()?.toUpperCase()}<br/>
                    </b>
                </g:if>
            </span>
        </div>
    </div>
</div>



</body>
</html>

