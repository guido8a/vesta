<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 13/01/15
  Time: 04:40 PM
--%>

<%@ page import="vesta.proyectos.MarcoLogico; vesta.proyectos.Cronograma; vesta.parametros.poaPac.Mes; vesta.parametros.poaPac.Anio" contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <meta name="layout" content="main">
        <title>Cronograma del proyecto</title>

        %{--<link rel="stylesheet" type="text/css" href="${resource(dir: 'js/plugins/DataTables-1.10.4/media/css', file: 'jquery.dataTables.min.css')}">--}%
        %{--<script type="text/javascript" charset="utf8" src="${resource(dir: 'js/plugins/DataTables-1.10.4/media/js', file: 'jquery.dataTables.min.js')}"></script>--}%

        %{--<script src="${resource(dir: 'js/plugins/fixed-header-table-1.3', file: 'jquery.fixedheadertable.js')}"></script>--}%
        %{--<link rel="stylesheet" type="text/css" href="${resource(dir: 'js/plugins/fixed-header-table-1.3/css', file: 'defaultTheme.css')}"/>--}%

        <style type="text/css">
        table {
            font-size : 9pt;
        }

        td {
            vertical-align : middle !important;
        }

        .divTabla {
            max-height : 450px;
            overflow-y : auto;
            overflow-x : hidden;
        }
        </style>

    </head>

    <body>

        <g:set var="editable" value="${anio.estado == 0 && proyecto.aprobado != 'a'}"/>

        <!-- botones -->
        <div class="btn-toolbar toolbar">
            <div class="btn-group">
                <g:link controller="proyecto" action="list" params="${params}" class="btn btn-sm btn-default">
                    <i class="fa fa-list"></i> Lista de proyectos
                </g:link>
            </div>
            <g:if test="${editable}">
                <div class="btn-group">
                    <g:link controller="cronograma" action="form" params="${params}" class="btn btn-sm btn-info">
                        <i class="fa fa-pencil"></i> Editar
                    </g:link>
                </div>
            </g:if>
        </div>

        <div class="divIndice ">
            <g:each in="${componentes}" var="comp">
                <a href="#comp${comp.id}" class="scrollComp ">
                    <strong>Componente ${comp.numeroComp}</strong>:
                ${(comp.objeto.length() > 100) ? comp.objeto.substring(0, 100) + "..." : comp.objeto}
                </a>
            </g:each>
        </div>

        <div class="divTabla">
            <table class="table table-condensed table-bordered table-hover table-striped" id="tblCrono">
                <thead>
                    <tr>
                        <th></th>
                        <th colspan="15" class="text-center">
                            <g:form action="show" method="post" class="frm_anio">
                                <input type="hidden" name="id" value="${proyecto.id}">
                                <g:select from="${Anio.list()}" optionKey="id" optionValue="anio" class="form-control input-sm"
                                          style="width: 100px; display: inline" name="anio" id="anio" value="${anio.id}"/>
                            </g:form>
                        </th>
                        %{--<g:each in="${0..13}" var="lzmi">--}%
                        %{--<th>i= ${lzmi}</th>--}%
                        %{--</g:each>--}%
                    </tr>

                    <tr>
                        <th style="width:300px;">Componentes/Rubros</th>
                        <g:each in="${Mes.list()}" var="mes">
                            <th style="width:100px;">${mes.descripcion[0..2]}.</th>
                        </g:each>
                        <th>Tot. Asignado</th>
                        <th>Sin asignar</th>
                        <th>Total</th>
                    </tr>
                </thead>
                <tbody style="height: 400px; overflow-y: auto;">
                    <g:set var="totProy" value="0"/>
                    <g:set var="totProyAsig" value="0"/>
                    <g:set var="totalMetas" value="0"/>
                    <g:set var="totalMetasCronograma" value="${0}"/>

                    <g:each in="${componentes}" var="comp" status="j">
                        <g:set var="totComp" value="0"/>
                        <g:set var="totCompAsig" value="${0}"/>
                        <tr id="comp${comp.id}">
                            <th colspan="16" class="success">
                                <strong>Componente ${comp.numeroComp}</strong>:
                            ${(comp.objeto.length() > 100) ? comp.objeto.substring(0, 100) + "..." : comp.objeto}
                            </th>
                            %{--<g:each in="${0..14}" var="lzmj">--}%
                            %{--<th>j= ${lzmj}</th>--}%
                            %{--</g:each>--}%
                        </tr>
                        <g:each in="${MarcoLogico.findAllByMarcoLogicoAndEstado(comp, 0, [sort: 'id'])}" var="act" status="i">
                            <g:set var="monto" value="${act.monto}"/>
                            <g:set var="totComp" value="${totComp.toDouble() + monto}"/>
                            <g:set var="tot" value="0"/>
                            <g:set var="totAct" value="${monto}"/>
                            <g:set var="tot" value="${act.getTotalCronograma()}"/>
                            <g:set var="totCompAsig" value="${totCompAsig + act.getTotalCronograma()}"/>
                            <g:set var="totalMetas" value="${totalMetas.toDouble() + monto}"/>
                            <g:set var="totalMetasCronograma" value="${totalMetasCronograma.toDouble() + totalMetas}"/>
                            <g:set var="totalMetas" value="${0}"/>
                            <g:set var="totProyAsig" value="${totProyAsig.toDouble() + totCompAsig.toDouble()}"/>
                            <g:set var="totProy" value="${totProy.toDouble() + totComp.toDouble()}"/>
                            <tr>
                                <th class="success" title="${act.objeto}" style="width:300px;">
                                    ${(act.objeto.length() > 100) ? act.objeto.substring(0, 100) + "..." : act.objeto}
                                </th>
                                <g:each in="${Mes.list()}" var="mes" status="k">
                                    <g:set var="crga" value='${Cronograma.findAllByMarcoLogicoAndMes(act, mes)}'/>
                                    <g:set var="valor" value="${0}"/>
                                    <g:if test="${crga.size() > 0}">
                                        <g:each in="${crga}" var="c">
                                            <g:if test="${c?.anio == anio}">
                                                <g:set var="crg" value='${c}'/>
                                            </g:if>
                                        </g:each>
                                        <g:if test="${crg}">
                                            <g:set var="valor" value="${crg.valor + crg.valor2}"/>
                                            <g:set var="crg" value="${null}"/>
                                        </g:if>
                                    </g:if>
                                    <td style="width:100px;" class="text-right">
                                        <g:formatNumber number="${valor}" type="currency"/>
                                    </td>
                                </g:each>
                                <td class="text-right" id="tot_${j}${i}">
                                    <g:formatNumber number="${tot}" type="currency"/>
                                </td>
                                <td class="text-right" id="tot_${j}${i}a">
                                    <g:formatNumber number="${act.monto - tot.toDouble()}" type="currency"/>
                                </td>
                                <td class="text-right" id="tot_${j}${i}a">
                                    <g:formatNumber number="${monto}" type="currency"/>
                                </td>
                            </tr>
                        </g:each>
                        <tr class="warning">
                            %{--<g:each in="${0..11}" var="lzmk">--}%
                            %{--<th>k= ${lzmk}</th>--}%
                            %{--</g:each>--}%
                            <td colspan="13"><strong>TOTAL</strong></td>
                            <td class="text-right">
                                <g:formatNumber number="${totCompAsig}" type="currency"/>
                            </td>
                            <td class="text-right">
                                <g:formatNumber number="${(totComp.toDouble() - totCompAsig.toDouble())}" type="currency"/>
                            </td>
                            <td class="text-right">
                                <g:formatNumber number="${totalMetas}" type="currency"/>
                            </td>
                        </tr>
                    </g:each>
                </tbody>
                <tfoot>
                    <tr class="danger">
                        %{--<g:each in="${0..11}" var="lzml">--}%
                        %{--<th>l= ${lzml}</th>--}%
                        %{--</g:each>--}%
                        <td colspan="13"><b>TOTAL DEL PROYECTO</b>
                        </td>
                        <td class="text-right">
                            <g:formatNumber number="${totProyAsig}" type="currency"/>
                        </td>
                        <td class="text-right">
                            <g:formatNumber number="${(totProy.toDouble() - totProyAsig.toDouble())}" type="currency"/>
                        </td>
                        <td class="text-right">
                            <g:formatNumber number="${(totalMetasCronograma)}" type="currency"/>
                        </td>
                    </tr>
                </tfoot>
            </table>
        </div>

        <script type="text/javascript">

            //            function tabla($tabla) {
            //                var $thead = $tabla.find("thead");
            //                var $container = $("<div>");
            //
            //                var $tablaHeader = $tabla.clone(true);
            //                $tablaHeader.find("tbody, tfoot").remove();
            //
            //                var i = 0;
            //                $thead.children().each(function () {
            //                    var j = 0;
            //                    $(this).children().each(function () {
            ////                        $tablaHeader.children().eq(i).children().eq(j).
            //                        j++;
            //                    });
            //                    i++;
            //                });
            //
            //                $container.append($tablaHeader);
            //                $tabla.before($container);
            //            }

            $(function () {
                $("#anio").change(function () {
                    openLoader();
                    $(".frm_anio").submit()
                });

                $(".scrollComp").click(function () {
                    var $container = $(".divTabla");
                    var $scrollTo = $(this).attr("href");
//                    $container.animate({
//                        scrollTop : $scrollTo.offset().top
//                    }, 1000);
                    $container.scrollTop($scrollTo.offset().top - $container.offset().top + $container.scrollTop());
//                    $container.animate({
//                        scrollTop : $scrollTo.offset().top - $container.offset().top + $container.scrollTop()
//                    });
                    return false;
                });
//                tabla($("#tblCrono"));

//                var table = $("#tblCrono").DataTable({
//                    ordering  : false,
//                    searching : false,
//                    paging    : false,
//                    scrollY   : 300,
//                    scrollX   : "100%"
//                });
//                new $.fn.dataTable.FixedColumns(table);
//                $("#tblCrono").fixedHeaderTable({
//                    height      : 500,
//                    fixedColumn : true,
//                    autoResize  : true,
//                    footer      : true
//                });

            });
        </script>

    </body>
</html>