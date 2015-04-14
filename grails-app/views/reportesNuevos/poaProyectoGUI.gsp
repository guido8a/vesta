<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 13/04/15
  Time: 03:25 PM
--%>

<%@ page import="vesta.parametros.poaPac.Anio" contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <meta name="layout" content="main">
        <title>POA Por Proyecto</title>
        <style type="text/css">
        .actual {
            background : #c7daed;
        }

        tr:hover .actual {
            background : #a3c2e0;
        }
        </style>
    </head>

    <body>

        <div class="btn-toolbar" role="toolbar">
            <div class="btn-group" role="group">
                %{--<a href="#" class="btn btn-default" id="btnVer">--}%
                %{--<i class="fa fa-search"></i> Ver reporte--}%
                %{--</a>--}%
                <a href="#" class="btn btn-default" id="btnPrint">
                    <i class="fa fa-print"></i> Imprimir reporte
                </a>
            </div>

            <div class="btn-group" role="group">
                <g:link action="poaAreaGestionGUI" class="btn btn-default">POA por área de gestión</g:link>
                <g:link action="poaGrupoGastoGUI" class="btn btn-default">POA por grupo de gasto</g:link>
            </div>
        </div>

        <g:set var="anio" value="${Anio.findByAnio(new Date().format('yyyy'))}"/>

        <elm:container tipo="horizontal" titulo="Reporte de POA Resumen por Proyecto">
            <table class="table table-bordered table-hover table-condensed table-bordered">
                <thead>
                    <tr>
                        <th></th>
                        <th>Proyecto</th>
                        <th>Arrastre ${anio.anio.toInteger() - 1}</th>
                        <th>Requerimientos ${anio.anio}</th>
                        <th>Total ${anio.anio}</th>
                        <g:each in="${anios}" var="a">
                            <th>${a}</th>
                        </g:each>
                        <th>Total Plurianual</th>
                    </tr>
                </thead>
                <tbody>
                    <g:each in="${data}" var="v" status="i">
                        <tr>
                            <td>${i + 1}</td>
                            <td>${v.proyecto.toStringCompleto()}</td>
                            <td class="text-right actual">
                                <g:if test="${v.valores["" + (anio.anio.toInteger() - 1)] > 0}">
                                    <g:formatNumber number="${v.valores["" + (anio.anio.toInteger() - 1)]}" type="currency" currencySymbol=""/>
                                </g:if>
                                <g:else>
                                    -&nbsp;&nbsp;&nbsp;&nbsp;
                                </g:else>
                            </td>
                            <td class="text-right actual">
                                <g:if test="${v.valores[anio.anio] > 0}">
                                    <g:formatNumber number="${v.valores[anio.anio]}" type="currency" currencySymbol=""/>
                                </g:if>
                                <g:else>
                                    -&nbsp;&nbsp;&nbsp;&nbsp;
                                </g:else>
                            </td>
                            <td class="text-right info">
                                <g:if test="${v.valores["T" + anio.anio] > 0}">
                                    <g:formatNumber number="${v.valores["T" + anio.anio]}" type="currency" currencySymbol=""/>
                                </g:if>
                                <g:else>
                                    -&nbsp;&nbsp;&nbsp;&nbsp;
                                </g:else>
                            </td>
                            <g:each in="${anios}" var="a">
                                <td class="text-right">
                                    <g:if test="${v.valores[a] > 0}">
                                        <g:formatNumber number="${v.valores[a] ?: 0}" type="currency" currencySymbol=""/>
                                    </g:if>
                                    <g:else>
                                        -&nbsp;&nbsp;&nbsp;&nbsp;
                                    </g:else>
                                </td>
                            </g:each>
                            <td class="text-right">
                                <g:formatNumber number="${v.valores['T']}" type="currency" currencySymbol=""/>
                            </td>
                        </tr>
                    </g:each>
                </tbody>
                <tfoot>
                    <tr>
                        <th class="text-right" colspan="2">TOTAL</th>
                        <th class="text-right"><g:formatNumber number="${totales['2014']}" type="currency" currencySymbol=""/></th>
                        <th class="text-right"><g:formatNumber number="${totales['2015']}" type="currency" currencySymbol=""/></th>
                        <th class="text-right"><g:formatNumber number="${totales['T2015']}" type="currency" currencySymbol=""/></th>
                        <g:each in="${anios}" var="a">
                            <th class="text-right"><g:formatNumber number="${totales[a] ?: 0}" type="currency" currencySymbol=""/></th>
                        </g:each>
                        <th class="text-right"><g:formatNumber number="${totales['T']}" type="currency" currencySymbol=""/></th>
                    </tr>
                </tfoot>
            </table>
        </elm:container>

        <script type="text/javascript">
            function reporte(print) {
//                var detalle = $("#detallar").is(":checked");
                var url;
                %{--if (!print) {--}%
                %{--if (detalle) {--}%
                %{--url = "${createLink(action: 'poaGrupoGastoWebDetallado')}";--}%
                %{--} else {--}%
                %{--url = "${createLink(action: 'poaGrupoGastoWeb')}";--}%
                %{--}--}%
                %{--url += "?anio=" + $("#anio").val();--}%
                %{--window.open(url, "_blank");--}%
                %{--} else {--}%
                %{--if (detalle) {--}%
                %{--url = "${createLink(action: 'poaGrupoGastoPdfDetallado')}";--}%
                %{--} else {--}%
                url = "${createLink(action: 'poaProyectoPdf')}";
//                    }
                url += "?anio=" + $("#anio").val();
                location.href = "${createLink(controller:'pdf',action:'pdfLink')}?url=" + url + "&filename=POA_proyecto.pdf";
//                }
            }

            $(function () {
                $("#btnVer").click(function () {
                    reporte(false);
                });
                $("#btnPrint").click(function () {
                    reporte(true);
                });
            });
        </script>

    </body>
</html>