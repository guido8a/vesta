<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 9/21/11
  Time: 12:43 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page import="yachay.proyectos.EstudiosTecnicos; yachay.proyectos.BeneficioSenplades; yachay.proyectos.IndicadoresSenplades; yachay.proyectos.Proyecto" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main"/>

        <script type="text/javascript" src="${resource(dir: 'js/jquery/plugins', file: 'jquery.cookie.js')}"></script>

        <link rel="stylesheet" href="${resource(dir: 'js/jquery/plugins/jBreadCrumb/Styles', file: 'Base.css')}"
              type="text/css"/>
        <link rel="stylesheet" href="${resource(dir: 'js/jquery/plugins/jBreadCrumb/Styles', file: 'BreadCrumb.css')}"
              type="text/css"/>

        <script src="${resource(dir: 'js/jquery/plugins/', file: 'jquery.easing.1.3.js')}" type="text/javascript"
                language="JavaScript"></script>
        <script src="${resource(dir: 'js/jquery/plugins/jBreadCrumb/js', file: 'jquery.jBreadCrumb.1.1.js')}"
                type="text/javascript" language="JavaScript"></script>

        <title>Datos Senplades</title>
    </head>

    <body>

        <div class="dialog">

            <div class="breadCrumbHolder module">
                <div id="breadCrumb" class="breadCrumb module">
                    <ul>
                        <li>
                            <g:link class="bc" controller="proyecto" action="show"
                                    id="${proyecto.id}">
                                Proyecto
                            </g:link>
                        </li>
                        <li>
                            Datos Senplades
                        </li>
                    </ul>
                </div>
            </div>

            <div id="" class="toolbar ui-widget-header ui-corner-all" style="margin-bottom: 5px;">
                <g:link class="button edit" action="semplades" id="${proyecto.id}">
                    Editar
                </g:link>
            </div> <!-- toolbar -->

            <div id="tabs">
                <ul>
                    <li><a href="#tabs-1">Indicadores</a></li>
                    <li><a href="#tabs-2">Beneficios</a></li>
                    <li><a href="#tabs-3">Estudios T&eacute;cnicos</a></li>
                    <li><a href="#tabs-4">Objetivos Estrat&eacute;gicos</a></li>
                    <li><a href="#tabs-5">Grupos de Atenci&oacute;n</a></li>
                    <li><a href="#tabs-6">Entidades Proyecto</a></li>
                    <li><a href="#tabs-7">Adquisiciones</a></li>
                    <li><a href="#tabs-8">Intervenciones</a></li>
                </ul>

                <div id="tabs-1">
                    <table width="100%" class="ui-widget-content ui-corner-all">
                        <tbody>
                            <tr class="prop ">
                                <td class="label  mandatory" valign="middle">
                                    <g:message code="IndicadoresSenplades.tasaAnalisisFinanciero.label"
                                               default="Tasa de Análisis Financiero"/>
                                </td>
                                <td class="mandatory" valign="middle">
                                    ${indicadores.indicadoresSempladesInstance?.tasaAnalisisFinanciero}
                                </td>
                            </tr>

                            <tr class="prop ">
                                <td class="label  mandatory" valign="middle">
                                    <g:message code="IndicadoresSenplades.valorActualNeto.label"
                                               default="Valor Actual Neto"/>
                                </td>
                                <td class="mandatory" valign="middle">
                                    ${indicadores.indicadoresSempladesInstance?.valorActualNeto}
                                </td>

                                <td class="label  mandatory" valign="middle">
                                    <g:message code="IndicadoresSenplades.tasaInternaDeRetorno.label"
                                               default="Tasa Interna De Retorno"/>
                                </td>
                                <td class="mandatory" valign="middle">
                                    ${indicadores.indicadoresSempladesInstance?.tasaInternaDeRetorno}
                                </td>
                            </tr>

                            <tr class="prop ">
                                <td class="label  mandatory" valign="middle">
                                    <g:message code="IndicadoresSenplades.tasaAnalisisEconomico.label"
                                               default="Tasa de Análisis Económico"/>
                                </td>
                                <td class="mandatory" valign="middle">
                                    ${indicadores.indicadoresSempladesInstance?.tasaAnalisisEconomico}
                                </td>

                                <td class="label  mandatory" valign="middle">
                                    <g:message code="IndicadoresSenplades.valorActualNetoEconomico.label"
                                               default="Valor Actual Neto Económico"/>
                                </td>
                                <td class="mandatory" valign="middle">
                                    ${indicadores.indicadoresSempladesInstance?.valorActualNetoEconomico}
                                </td>
                            </tr>

                            <tr class="prop ">
                                <td class="label  mandatory" valign="middle">
                                    <g:message code="IndicadoresSenplades.tasaInternaDeRetornoEconomico.label"
                                               default="Tasa Interna De Retorno Económico"/>
                                </td>
                                <td class="mandatory" valign="middle">
                                    ${indicadores.indicadoresSempladesInstance?.tasaInternaDeRetornoEconomico}
                                </td>

                                <td class="label  mandatory" valign="middle">
                                    <g:message code="IndicadoresSenplades.costoBeneficio.label"
                                               default="Costo Beneficio"/>
                                </td>
                                <td class="mandatory" valign="middle">
                                    ${indicadores.indicadoresSempladesInstance?.costoBeneficio}
                                </td>
                            </tr>

                            <tr class="prop ">
                                <td class="label " valign="middle">
                                    <g:message code="IndicadoresSenplades.pierdePais.label" default="Pierde Pais"/>
                                </td>
                                <td valign="middle">
                                    ${indicadores.indicadoresSempladesInstance?.pierdePais}
                                </td>

                                <td class="label " valign="middle">
                                    <g:message code="IndicadoresSenplades.impactos.label" default="Impactos"/>
                                </td>
                                <td valign="middle">
                                    ${indicadores.indicadoresSempladesInstance?.impactos}
                                </td>
                            </tr>

                            <tr class="prop ">
                                <td class="label " valign="middle">
                                    <g:message code="IndicadoresSenplades.metodologia.label" default="Metodología"/>
                                </td>
                                <td valign="middle">
                                    ${indicadores.indicadoresSempladesInstance?.metodologia}
                                </td>

                                <td class="label " valign="middle">
                                    <g:message code="IndicadoresSenplades.observaciones.label" default="Observaciones"/>
                                </td>
                                <td valign="middle">
                                    ${indicadores.indicadoresSempladesInstance?.observaciones}
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>

                <div id="tabs-2">
                    <table width="100%" class="ui-widget-content ui-corner-all" style="margin-top: 10px;">
                        <tbody>
                            <tr class="prop ">

                                <td class="etiqueta" valign="middle">
                                    <g:message code="beneficioSemplades.beneficiariosDirectosHombres.label"
                                               default="Beneficiarios Directos Hombres"/>
                                </td>
                                <td class="campo" valign="middle">
                                    ${indicadores.beneficioSempladesInstance?.beneficiariosDirectosHombres}
                                </td>

                                <td class="etiqueta" valign="middle">
                                    <g:message code="beneficioSemplades.beneficiariosIndirectosHombres.label"
                                               default="Beneficiarios Indirectos Hombres"/>
                                </td>
                                <td class="campo" valign="middle">
                                    ${indicadores.beneficioSempladesInstance?.beneficiariosIndirectosHombres}
                                </td>
                            </tr>

                            <tr class="prop ">
                                <td class="etiqueta" valign="middle">
                                    <g:message code="beneficioSemplades.beneficiariosDirectosMujeres."
                                               default="Beneficiarios Directos Mujeres"/>
                                </td>
                                <td class="campo" valign="middle">
                                    ${indicadores.beneficioSempladesInstance?.beneficiariosDirectosMujeres}
                                </td>

                                <td class="etiqueta" valign="middle">
                                    <g:message code="beneficioSemplades.beneficiariosIndirectosMujeres.label"
                                               default="Beneficiarios Indirectos Mujeres"/>
                                </td>
                                <td class="campo" valign="middle">
                                    ${indicadores.beneficioSempladesInstance?.beneficiariosIndirectosMujeres}
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>

                <div id="tabs-3">
                    <table class="ui-widget-content ui-corner-all" width="100%" style="font-size: 13px;">
                        <thead style="font-size: 14px;">
                            <tr>
                                <g:each in="${headers.estudiosTecnicos}" var="titulo" status="i">
                                    <th class="ui-widget-header ${(i == 0) ? 'ui-corner-tl' : ''}">${titulo.text}</th>
                                </g:each>
                            </tr>
                        </thead>
                        <tbody>
                            <g:if test="${indicadores.estudioTecnicoInstance.size() == 0}">
                                <tr>
                                    <td colspan="${headers.estudiosTecnicos.size() + 1}"
                                        class="ui-state-active ui-corner-bottom"
                                        style="font-weight: bold; padding: 5px; font-size: larger; text-align: center;">
                                        No se encontraron Estudios T&eacute;cnicos para este proyecto
                                    </td>
                                </tr>
                            </g:if>
                            <g:else>
                                <g:each in="${indicadores.estudioTecnicoInstance}" var="elem" status="i">
                                    <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                                        <g:each in="${headers.estudiosTecnicos}" var="titulo">
                                            <td style="text-align: ${titulo.align};">
                                                <g:if test="${elem[titulo.name]?.class == java.sql.Timestamp}">
                                                    ${elem[titulo.name].format('dd-MM-yyyy')}
                                                </g:if>
                                                <g:else>
                                                    <g:if test="${elem[titulo.name]?.class == java.lang.Double}">
                                                        <g:formatNumber number="${elem[titulo.name]}"
                                                                        format="###,##0"
                                                                        minFractionDigits="2" maxFractionDigits="2"/>
                                                    </g:if>
                                                    <g:else>
                                                        <g:if test="${titulo.property && elem[titulo.name]}">
                                                            ${elem[titulo.name][titulo.property]}
                                                        </g:if>
                                                        <g:else>
                                                            ${elem[titulo.name]}
                                                        </g:else>
                                                    </g:else>
                                                </g:else>
                                            </td>
                                        </g:each>
                                    </tr>
                                </g:each>
                            </g:else>
                        </tbody>
                    </table>
                </div>

                <div id="tabs-4">
                    <table class="ui-widget-content ui-corner-all" width="100%" style="font-size: 13px;">
                        <thead style="font-size: 14px;">
                            <tr>
                                <g:each in="${headers.objetivosEstrategicos}" var="titulo" status="i">
                                    <th class="ui-widget-header ${(i == 0) ? 'ui-corner-tl' : ''}">${titulo.text}</th>
                                </g:each>
                            </tr>
                        </thead>
                        <tbody>
                            <g:if test="${indicadores.objetivoEstrategicoInstance.size() == 0}">
                                <tr>
                                    <td colspan="${headers.objetivosEstrategicos.size() + 1}"
                                        class="ui-state-active ui-corner-bottom"
                                        style="font-weight: bold; padding: 5px; font-size: larger; text-align: center;">
                                        No se encontraron Objetivos Estrat&eacute;gicos para este proyecto
                                    </td>
                                </tr>
                            </g:if>
                            <g:else>
                                <g:each in="${indicadores.objetivoEstrategicoInstance}" var="elem" status="i">
                                    <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                                        <g:each in="${headers.objetivosEstrategicos}" var="titulo">
                                            <td style="text-align: ${titulo.align};">
                                                <g:if test="${elem[titulo.name]?.class == java.sql.Timestamp}">
                                                    ${elem[titulo.name].format('dd-MM-yyyy')}
                                                </g:if>
                                                <g:else>
                                                    <g:if test="${elem[titulo.name]?.class == java.lang.Double}">
                                                        <g:formatNumber number="${elem[titulo.name]}"
                                                                        format="###,##0"
                                                                        minFractionDigits="2" maxFractionDigits="2"/>
                                                    </g:if>
                                                    <g:else>
                                                        <g:if test="${titulo.property && elem[titulo.name]}">
                                                            ${elem[titulo.name][titulo.property]}
                                                        </g:if>
                                                        <g:else>
                                                            ${elem[titulo.name]}
                                                        </g:else>
                                                    </g:else>
                                                </g:else>
                                            </td>
                                        </g:each>
                                    </tr>
                                </g:each>
                            </g:else>
                        </tbody>
                    </table>
                </div>

                <div id="tabs-5">
                    <table class="ui-widget-content ui-corner-all" width="100%" style="font-size: 13px;">
                        <thead style="font-size: 14px;">
                            <tr>
                                <g:each in="${headers.gruposDeAtencion}" var="titulo" status="i">
                                    <th class="ui-widget-header ${(i == 0) ? 'ui-corner-tl' : ''}">${titulo.text}</th>
                                </g:each>
                            </tr>
                        </thead>
                        <tbody>
                            <g:if test="${indicadores.grupoDeAtencionInstance.size() == 0}">
                                <tr>
                                    <td colspan="${headers.gruposDeAtencion.size() + 1}"
                                        class="ui-state-active ui-corner-bottom"
                                        style="font-weight: bold; padding: 5px; font-size: larger; text-align: center;">
                                        No se encontraron Grupos de Atenci&oacute;n para este proyecto
                                    </td>
                                </tr>
                            </g:if>
                            <g:else>
                                <g:each in="${indicadores.grupoDeAtencionInstance}" var="elem" status="i">
                                    <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                                        <g:each in="${headers.gruposDeAtencion}" var="titulo">
                                            <td style="text-align: ${titulo.align};">
                                                <g:if test="${elem[titulo.name]?.class == java.sql.Timestamp}">
                                                    ${elem[titulo.name].format('dd-MM-yyyy')}
                                                </g:if>
                                                <g:else>
                                                    <g:if test="${elem[titulo.name]?.class == java.lang.Double}">
                                                        <g:formatNumber number="${elem[titulo.name]}"
                                                                        format="###,##0"
                                                                        minFractionDigits="2" maxFractionDigits="2"/>
                                                    </g:if>
                                                    <g:else>
                                                        <g:if test="${titulo.property && elem[titulo.name]}">
                                                            ${elem[titulo.name][titulo.property]}
                                                        </g:if>
                                                        <g:else>
                                                            ${elem[titulo.name]}
                                                        </g:else>
                                                    </g:else>
                                                </g:else>
                                            </td>
                                        </g:each>
                                    </tr>
                                </g:each>
                            </g:else>
                        </tbody>
                    </table>
                </div>

                <div id="tabs-6">
                    <table class="ui-widget-content ui-corner-all" width="100%" style="font-size: 13px;">
                        <thead style="font-size: 14px;">
                            <tr>
                                <g:each in="${headers.entidadesProyecto}" var="titulo" status="i">
                                    <th class="ui-widget-header ${(i == 0) ? 'ui-corner-tl' : ''}">${titulo.text}</th>
                                </g:each>
                            </tr>
                        </thead>
                        <tbody>
                            <g:if test="${indicadores.entidadesProyectoInstance.size() == 0}">
                                <tr>
                                    <td colspan="${headers.entidadesProyecto.size() + 1}"
                                        class="ui-state-active ui-corner-bottom"
                                        style="font-weight: bold; padding: 5px; font-size: larger; text-align: center;">
                                        No se encontraron Entidades de Proyecto para este proyecto
                                    </td>
                                </tr>
                            </g:if>
                            <g:else>
                                <g:each in="${indicadores.entidadesProyectoInstance}" var="elem" status="i">
                                    <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                                        <g:each in="${headers.entidadesProyecto}" var="titulo">
                                            <td style="text-align: ${titulo.align};">
                                                <g:if test="${elem[titulo.name]?.class == java.sql.Timestamp}">
                                                    ${elem[titulo.name].format('dd-MM-yyyy')}
                                                </g:if>
                                                <g:else>
                                                    <g:if test="${elem[titulo.name]?.class == java.lang.Double}">
                                                        <g:formatNumber number="${elem[titulo.name]}"
                                                                        format="###,##0"
                                                                        minFractionDigits="2" maxFractionDigits="2"/>
                                                    </g:if>
                                                    <g:else>
                                                        <g:if test="${titulo.property && elem[titulo.name]}">
                                                            ${elem[titulo.name][titulo.property]}
                                                        </g:if>
                                                        <g:else>
                                                            ${elem[titulo.name]}
                                                        </g:else>
                                                    </g:else>
                                                </g:else>
                                            </td>
                                        </g:each>
                                    </tr>
                                </g:each>
                            </g:else>
                        </tbody>
                    </table>
                </div>

                <div id="tabs-7">
                    <table class="ui-widget-content ui-corner-all" width="100%" style="font-size: 13px;">
                        <thead style="font-size: 14px;">
                            <tr>
                                <g:each in="${headers.adquisiciones}" var="titulo" status="i">
                                    <th class="ui-widget-header ${(i == 0) ? 'ui-corner-tl' : ''}">${titulo.text}</th>
                                </g:each>
                            </tr>
                        </thead>
                        <tbody>
                            <g:if test="${headers.adquisiciones.size() == 0}">
                                <tr>
                                    <td colspan="${indicadores.adquisiciones.size() + 1}"
                                        class="ui-state-active ui-corner-bottom"
                                        style="font-weight: bold; padding: 5px; font-size: larger; text-align: center;">
                                        No se encontraron Adquisiciones para este proyecto
                                    </td>
                                </tr>
                            </g:if>
                            <g:else>
                                <g:each in="${indicadores.adquisiciones}" var="elem" status="i">
                                    <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                                        <g:each in="${headers.adquisiciones}" var="titulo">
                                            <td style="text-align: ${titulo.align};">
                                                <g:if test="${elem[titulo.name]?.class == java.sql.Timestamp}">
                                                    ${elem[titulo.name].format('dd-MM-yyyy')}
                                                </g:if>
                                                <g:else>
                                                    <g:if test="${elem[titulo.name]?.class == java.lang.Double}">
                                                        <g:formatNumber number="${elem[titulo.name]}"
                                                                        format="###,##0"
                                                                        minFractionDigits="2" maxFractionDigits="2"/>
                                                    </g:if>
                                                    <g:else>
                                                        <g:if test="${titulo.property && elem[titulo.name]}">
                                                            ${elem[titulo.name][titulo.property]}
                                                        </g:if>
                                                        <g:else>
                                                            ${elem[titulo.name]}
                                                        </g:else>
                                                    </g:else>
                                                </g:else>
                                            </td>
                                        </g:each>
                                    </tr>
                                </g:each>
                            </g:else>
                        </tbody>
                    </table>
                </div>

                <div id="tabs-8">
                    <table class="ui-widget-content ui-corner-all" width="100%" style="font-size: 13px;">
                        <thead style="font-size: 14px;">
                            <tr>
                                <g:each in="${headers.intervenciones}" var="titulo" status="i">
                                    <th class="ui-widget-header ${(i == 0) ? 'ui-corner-tl' : ''}">${titulo.text}</th>
                                </g:each>
                            </tr>
                        </thead>
                        <tbody>
                            <g:if test="${indicadores.intervenciones.size() == 0}">
                                <tr>
                                    <td colspan="${headers.intervenciones.size() + 1}"
                                        class="ui-state-active ui-corner-bottom"
                                        style="font-weight: bold; padding: 5px; font-size: larger; text-align: center;">
                                        No se encontraron Intervenciones para este proyecto
                                    </td>
                                </tr>
                            </g:if>
                            <g:else>
                                <g:each in="${indicadores.intervenciones}" var="elem" status="i">
                                    <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                                        <g:each in="${headers.intervenciones}" var="titulo">
                                            <td style="text-align: ${titulo.align};">
                                                <g:if test="${elem[titulo.name]?.class == java.sql.Timestamp}">
                                                    ${elem[titulo.name].format('dd-MM-yyyy')}
                                                </g:if>
                                                <g:else>
                                                    <g:if test="${elem[titulo.name]?.class == java.lang.Double}">
                                                        <g:formatNumber number="${elem[titulo.name]}"
                                                                        format="###,##0"
                                                                        minFractionDigits="2" maxFractionDigits="2"/>
                                                    </g:if>
                                                    <g:else>
                                                        <g:if test="${titulo.property && elem[titulo.name]}">
                                                            ${elem[titulo.name][titulo.property]}
                                                        </g:if>
                                                        <g:else>
                                                            ${elem[titulo.name]}
                                                        </g:else>
                                                    </g:else>
                                                </g:else>
                                            </td>
                                        </g:each>
                                    </tr>
                                </g:each>
                            </g:else>
                        </tbody>
                    </table>
                </div>
            </div>

        </div> <!-- dialog -->

        <script type="text/javascript">
            $(function() {

                $("#breadCrumb").jBreadCrumb({
                    beginingElementsToLeaveOpen: 10
                });


                $(".button").button();
                $(".edit").button("option", "icons", {primary:'ui-icon-pencil'});
                $(".back").button("option", "icons", {primary:'ui-icon-arrowreturnthick-1-w'});

                $("#tabs").tabs({
                    cookie: {
                        // store cookie for a day, without, it would be a session cookie
                        expires: 1
                    }
                });

            });
        </script>

    </body>
</html>
