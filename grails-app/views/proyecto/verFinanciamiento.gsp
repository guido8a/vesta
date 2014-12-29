<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 10/21/11
  Time: 11:25 AM
  To change this template use File | Settings | File Templates.
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
    <head>
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

        <title>
            Ver Presupuesto/Fuentes
        </title>
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
                            Presupuesto/Fuentes
                        </li>
                    </ul>
                </div>
            </div>

            <div id="" class="toolbar ui-widget-header ui-corner-all" style="margin-bottom: 5px;">
                <g:link class="button edit" action="editarFinanciamiento" id="${proyecto.id}">
                    Editar
                </g:link>
            </div> <!-- toolbar -->

            <table width="1040px" class="ui-widget-content ui-corner-all" id="financiamiento">
                <thead>
                    <tr style="padding: 5px;">
                        <th style="padding: 5px;" class="ui-widget-header ui-corner-tl" width="320px;">
                            Fuente
                        </th>
                        <th style="padding: 5px;" class="ui-widget-header " width="120px;">
                            Monto
                        </th>
                        <th style="padding: 5px;" class="ui-widget-header" width="120px;">
                            Porcentaje
                        </th>
                        <th style="padding: 5px;" class="ui-widget-header  ui-corner-tr" width="80px;">
                            A&ntilde;o
                        </th>
                    </tr>
                </thead>
                <tbody>
                    <g:set var="suma" value="${0}"/>
                    <g:set var="prct" value="${0}"/>
                    <g:each in="${financiamientos}" status="i" var="fin">
                        <tr class="${i % 2 == 0 ? 'even' : 'odd'}">
                            <td fuente="${fin?.fuente.id}" tipo="descripcion">
                                ${fin?.fuente.descripcion}
                            </td>
                            <td style="text-align: right;" fuente="${fin?.fuente.id}" tipo="monto">

                                <g:formatNumber number="${fin?.monto}" format="###,##0"
                                                minFractionDigits="2" maxFractionDigits="2"/>

                                <g:set var="suma" value="${suma + fin?.monto}"/>
                            </td>
                            <td style="text-align: right;" fuente="${fin?.fuente.id}" tipo="porcentaje">

                                <g:set var="finPorcentaje"
                                       value="${(fin?.monto * 100) / proyecto?.monto}"/>
                                <g:formatNumber number="${finPorcentaje/100}" type="percent"
                                                minFractionDigits="2"
                                                maxFractionDigits="2"/>

                                <g:set var="prct" value="${prct+ finPorcentaje}"/>
                            </td>
                            <td>
                                ${fin.anio?.anio}
                            </td>
                        </tr>
                    </g:each>
                </tbody>
                <tfoot>
                    <tr>
                        <th class="ui-state-active ui-corner-bl" style="font-weight: bold;">
                            TOTAL
                        </th>
                        <th class="ui-state-active" style="text-align: right; font-weight: bold;">
                            <span id="spanSuma">
                                <g:formatNumber number="${suma}" format="###,##0"
                                                minFractionDigits="2" maxFractionDigits="2"/>
                            </span>
                        </th>
                        <th class="ui-state-active" style="text-align: right; font-weight: bold;">
                            <span id="spanPrct">
                                <g:formatNumber number="${prct/100}" type="percent" minFractionDigits="2"
                                                maxFractionDigits="2"/>
                            </span>
                        </th>
                        <th class="ui-state-active ui-corner-br"></th>
                    </tr>
                </tfoot>
            </table>
        </div>

        <script type="text/javascript">
            $(function () {
                $("#breadCrumb").jBreadCrumb({
                    beginingElementsToLeaveOpen:10
                });

                $(".button").button();
                $(".edit").button("option", "icons", {primary:'ui-icon-pencil'});
            });
        </script>

    </body>
</html>