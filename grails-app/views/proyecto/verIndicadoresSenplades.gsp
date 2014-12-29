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
                            Indicadores Senplades
                        </li>
                    </ul>
                </div>
            </div>

            <div id="" class="toolbar ui-widget-header ui-corner-all" style="margin-bottom: 5px;">
                <g:link class="button edit" action="editarIndicadoresSenplades" id="${proyecto.id}">
                    Editar
                </g:link>
            </div> <!-- toolbar -->

            <div id="tabs-1">
                <table width="100%" class="ui-widget-content ui-corner-all">
                    <tbody>
                        <tr class="prop ">
                            <td class="label  mandatory" valign="middle">
                                Tasa de An&aacute;lisis
                            </td>
                            <td class="mandatory" valign="middle">
                                <g:formatNumber
                                        number="${indicadores.indicadoresSempladesInstance?.tasaAnalisisFinanciero}"
                                        minFractionDigits="2" maxFractionDigits="2"/>%
                            </td>

                            <td class="label  mandatory" valign="middle">
                                Valor Actual Neto
                            </td>
                            <td class="mandatory" valign="middle">
                                <g:formatNumber
                                        number="${indicadores.indicadoresSempladesInstance?.valorActualNeto}"
                                        minFractionDigits="2" maxFractionDigits="2"/>
                            </td>
                        </tr>

                        <tr class="prop">
                            <td class="label  mandatory" valign="middle">
                                Tasa Interna de Retorno
                            </td>
                            <td class="mandatory" valign="middle">
                                <g:formatNumber
                                        number="${indicadores.indicadoresSempladesInstance?.tasaInternaDeRetorno}"
                                        minFractionDigits="2" maxFractionDigits="2"/>%
                            </td>

                            <td class="label " valign="middle">
                                Metodolog&iacute;a de c&aacute;lculo
                            </td>
                            <td valign="middle">
                                ${indicadores.indicadoresSempladesInstance?.metodologia}
                            </td>
                        </tr>

                        <tr class="prop ">

                            <td class="label  mandatory" valign="middle">
                                Costo Beneficio
                            </td>
                            <td class="mandatory" valign="middle">
                                <g:formatNumber
                                        number="${indicadores.indicadoresSempladesInstance?.costoBeneficio}"
                                        minFractionDigits="2" maxFractionDigits="2"/>
                            </td>
                        </tr>

                        <tr class="prop">

                            <td class="label " valign="middle">
                                Indicadores de resultado
                            </td>
                            <td valign="middle" colspan="3">
                                ${indicadores.indicadoresSempladesInstance?.impactos}
                            </td>
                        </tr>

                    </tbody>
                </table>
            </div>

        </div> <!-- dialog -->

        <script type="text/javascript">
            $(function() {
                $("#breadCrumb").jBreadCrumb({
                    beginingElementsToLeaveOpen: 10
                });
                $(".button").button();
                $(".edit").button("option", "icons", {primary:'ui-icon-pencil'});
            });
        </script>

    </body>
</html>
