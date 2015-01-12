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
                            Entidades proyecto
                        </li>
                    </ul>
                </div>
            </div>

            <div id="" class="toolbar ui-widget-header ui-corner-all" style="margin-bottom: 5px;">
                <g:link class="button edit" action="editarEntidades" id="${proyecto.id}">
                    Editar
                </g:link>
            </div> <!-- toolbar -->

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
