<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 10/04/15
  Time: 03:25 PM
--%>

<%@ page import="vesta.parametros.poaPac.Fuente; vesta.parametros.poaPac.Anio" contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <meta name="layout" content="main">
        <title>POA Por Grupo de Gasto</title>
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
                <a href="#" class="btn btn-default" id="btnPrint">
                    <i class="fa fa-file-pdf-o text-danger"></i> Exportar a PDF
                </a>
                <a href="#" class="btn btn-default" id="btnXls">
                    <i class="fa fa-file-excel-o text-success"></i> Exportar a Excel
                </a>
            </div>

            <div class="btn-group" role="group">
                <g:link action="poaAreaGestionGUI" class="btn btn-default">POA por Área de gestión</g:link>
                <g:link action="poaProyectoGUI" class="btn btn-default">POA por proyecto</g:link>
                <g:link action="poaFuenteGUI" class="btn btn-default">POA por fuente de financiamiento</g:link>
            </div>
        </div>

        <g:set var="anio" value="${Anio.findByAnio(new Date().format('yyyy'))}"/>

        <elm:container tipo="horizontal" titulo="Reporte de POA Resumen por Grupo de Gasto">

            <div class="row" style="margin-bottom: 10px;">
                <div class="col-md-1">
                    <label>Fuente</label>
                </div>

                <div class="col-md-3">
                    <g:select name="fuente" from="${Fuente.list([sort: 'descripcion'])}" optionKey="id" optionValue="descripcion"
                              class="form-control" value="${fuente?.id}" id="idFuente"/>
                </div>

                <div class="col-md-2">
                    <a href="#" id="btnCambiarFuente" class="btn btn-info">
                        <i class="fa fa-refresh"></i> Cambiar
                    </a>
                </div>
            </div>

            <table class="table table-bordered table-hover table-condensed table-bordered">
                <thead>
                    <tr>
                        <th>Grupo de gasto</th>
                        <th>Descripción</th>
                        <th>Arrastre año ${anio.anio.toInteger() - 1}</th>
                        <th>Requerimiento año ${anio.anio}</th>
                        <th>Presupuesto codificado año ${anio.anio}</th>
                        <g:each in="${anios}" var="a">
                            <th>Año${a}</th>
                        </g:each>
                        <th>Total Plurianual</th>
                    </tr>
                </thead>
                <tbody>
                    <g:each in="${data}" var="v">
                        <tr>
                            <td class="text-center">${v.partida.numero.replaceAll("0", "")}</td>
                            <td>${v.partida.descripcion}</td>
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
                        <th></th>
                        <th class="text-right">TOTAL</th>
                        <th class="text-right"><g:formatNumber number="${totales["" + (anio.anio.toInteger() - 1)]}" type="currency" currencySymbol=""/></th>
                        <th class="text-right"><g:formatNumber number="${totales["" + anio.anio]}" type="currency" currencySymbol=""/></th>
                        <th class="text-right"><g:formatNumber number="${totales['T' + anio.anio]}" type="currency" currencySymbol=""/></th>
                        <g:each in="${anios}" var="a">
                            <th class="text-right"><g:formatNumber number="${totales[a] ?: 0}" type="currency" currencySymbol=""/></th>
                        </g:each>
                        <th class="text-right"><g:formatNumber number="${totales['T']}" type="currency" currencySymbol=""/></th>
                    </tr>
                </tfoot>
            </table>
        </elm:container>

        <script type="text/javascript">
            function reporte(tipo) {
                var url;
                if (tipo == "pdf") {
                    %{--url = "${createLink(action: 'poaGrupoGastoPdf')}?fnt=" + $("#fuente").val();--}%
                    url = "${createLink(action: 'poaGrupoGastoPdf')}?fnt=" + $("#idFuente").val();
//                    url += "?anio=" + $("#anio").val();
                    url += "&anio=" + ${anio};
                    location.href = "${createLink(controller:'pdf',action:'pdfLink')}?url=" + url + "&filename=POA_grupo_gasto.pdf";
                } else if (tipo == "xls") {
                    url = "${createLink(controller: 'reportesNuevosExcel', action: 'poaGrupoGastoXls')}?fnt=" + $("#idFuente").val();
//                    url += "?anio=" + $("#anio").val();
                    url += "&anio=" + ${anio};
                    location.href = url;
                }
            }

            $(function () {
                $("#btnCambiarFuente").click(function () {
                    location.href = "${createLink(action:'poaGrupoGastoGUI')}/" + $("#idFuente").val();
                });

                $("#btnXls").click(function () {
                    if($("#idFuente").val() != ''){
                        reporte("xls");
                    }else{
                        log("Seleccione una fuente!","Error")
                    }

                });
                $("#btnPrint").click(function () {
                    if($("#idFuente").val() != ''){
                        reporte("pdf");
                    }else{
                        log("Seleccione una fuente!","Error")
                    }
                });
            });
        </script>
    </body>
</html>