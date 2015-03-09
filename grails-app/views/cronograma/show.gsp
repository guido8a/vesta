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

        td, th {
            vertical-align : middle !important;
        }

        .divTabla {
            max-height : 450px;
            overflow-y : auto;
            overflow-x : auto;
        }

        tfoot {
            font-size : larger;
        }
        </style>

    </head>

    <body>
        <g:set var="editable" value="${anio.estado == 0 && proyecto.aprobado != 'a'}"/>
        <g:if test="${params.list != 'list'}">
            <g:set var="editable" value="${false}"/>
        </g:if>

        <!-- botones -->
        <div class="btn-toolbar toolbar">
            <div class="btn-group">
                <g:link controller="proyecto" action="${params.list}" params="${params}" class="btn btn-sm btn-default">
                    <i class="fa fa-list"></i> Lista de proyectos
                </g:link>
            </div>
            <g:if test="${editable}">
                <div class="btn-group">
                    <g:link controller="cronograma" action="form" params="${params}" class="btn btn-sm btn-info btn-edit">
                        <i class="fa fa-pencil"></i> Editar
                    </g:link>
                </div>
            </g:if>
            <div class="btn-group">
                <g:link controller="asignacion" action="asignacionProyectov2" id="${proyecto.id}" class="btn btn-sm btn-default">
                    <i class="fa fa-money"></i> Asignaciones
                </g:link>
            </div>
            <g:if test="${params.act}">
                <div class="btn-group">
                    <g:link controller="marcoLogico" action="marcoLogicoProyecto" id="${proyecto.id}" class="btn btn-sm btn-default"
                            params="[list: params.list]">
                        <i class="fa fa-calendar-o"></i> Plan de proyecto
                    </g:link>
                </div>
            </g:if>
        </div>

        <g:if test="${proyecto.aprobado == 'a'}">
            <div class="alert alert-info">
                El proyecto está aprobado, no puede modificar el cronograma
            </div>
        </g:if>

        <elm:container tipo="horizontal" titulo="Cronograma del proyecto ${proyecto?.toStringMedio()}, para el año ${anio}" color="black">
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
                            <th colspan="15">
                                <g:select from="${Anio.list([sort: 'anio'])}" optionKey="id" optionValue="anio" class="form-control input-sm"
                                          style="width: 100px; display: inline" name="anio" id="anio" value="${anio.id}"/>
                            </th>
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
                    <tbody>
                        <g:set var="asignadoAct" value="${0}"/> %{-- / --}%
                        <g:set var="sinAsignarAct" value="${0}"/> %{-- * --}%
                        <g:set var="totalAct" value="${0}"/> %{-- - --}%

                        <g:set var="asignadoComp" value="${0}"/> %{-- // --}%
                        <g:set var="sinAsignarComp" value="${0}"/> %{-- ** --}%
                        <g:set var="totalComp" value="${0}"/> %{-- -- --}%

                        <g:set var="asignadoTotal" value="${0}"/> %{-- /// --}%
                        <g:set var="sinAsignarTotal" value="${0}"/> %{-- *** --}%
                        <g:set var="totalTotal" value="${0}"/> %{-- --- --}%

                        <g:each in="${componentes}" var="comp" status="j">
                            <g:set var="asignadoComp" value="${0}"/> %{-- // --}%
                            <g:set var="sinAsignarComp" value="${0}"/> %{-- ** --}%
                            <g:set var="totalComp" value="${0}"/> %{-- -- --}%
                            <tr id="comp${comp.id}">
                                <th colspan="16" class="success">
                                    <strong>Componente ${comp.numeroComp}</strong>:
                                ${(comp.objeto.length() > 80) ? comp.objeto.substring(0, 80) + "..." : comp.objeto}
                                </th>
                            </tr>
                            <g:each in="${MarcoLogico.findAllByMarcoLogicoAndEstado(comp, 0, [sort: 'id'])}" var="act" status="i">
                                <g:if test="${!actSel || (actSel && actSel.id == act.id)}">
                                    <g:set var="asignadoAct" value="${act.getTotalCronograma()}"/> %{-- / --}%
                                    <g:set var="totalAct" value="${act.monto}"/> %{-- - --}%
                                    <g:set var="sinAsignarAct" value="${totalAct - asignadoAct}"/> %{-- * --}%

                                    <g:set var="asignadoComp" value="${asignadoComp + asignadoAct}"/> %{-- // --}%
                                    <g:set var="totalComp" value="${totalComp + totalAct}"/> %{-- -- --}%
                                    <g:set var="sinAsignarComp" value="${sinAsignarComp + sinAsignarAct}"/> %{-- ** --}%

                                    <g:set var="asignadoTotal" value="${asignadoTotal + asignadoAct}"/> %{-- /// --}%
                                    <g:set var="totalTotal" value="${totalTotal + totalAct}"/> %{-- --- --}%
                                    <g:set var="sinAsignarTotal" value="${sinAsignarTotal + sinAsignarAct}"/> %{-- *** --}%
                                    <tr>
                                        <th class="success" title="${act.responsable} - ${act.objeto}" style="width:300px;">
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
                                                <g:formatNumber number="${valor}" type="currency" currencySymbol=""/>
                                            </td>
                                        </g:each>
                                        <th class="text-right">
                                            %{-- / --}%
                                            <g:formatNumber number="${asignadoAct}" type="currency" currencySymbol=""/>
                                        </th>
                                        <th class="text-right">
                                            %{-- * --}%
                                            <g:formatNumber number="${sinAsignarAct}" type="currency" currencySymbol=""/>
                                        </th>
                                        <th class="text-right">
                                            %{-- - --}%
                                            <g:formatNumber number="${totalAct}" type="currency" currencySymbol=""/>
                                        </th>
                                    </tr>
                                </g:if>
                            </g:each>
                            <tr class="warning">
                                <th colspan="13">TOTAL</th>
                                <th class="text-right">
                                    %{-- // --}%
                                    <g:formatNumber number="${asignadoComp}" type="currency" currencySymbol=""/>
                                </th>
                                <th class="text-right">
                                    %{-- ** --}%
                                    <g:formatNumber number="${sinAsignarComp}" type="currency" currencySymbol=""/>
                                </th>
                                <th class="text-right">
                                    %{-- -- --}%
                                    <g:formatNumber number="${totalComp}" type="currency" currencySymbol=""/>
                                </th>
                            </tr>
                        </g:each>
                    </tbody>
                    <tfoot>
                        <tr class="danger">
                            <th colspan="13">TOTAL DEL PROYECTO</th>
                            <th class="text-right">
                                %{-- /// --}%
                                <g:formatNumber number="${asignadoTotal}" type="currency" currencySymbol=""/>
                            </th>
                            <th class="text-right">
                                %{-- *** --}%
                                <g:formatNumber number="${sinAsignarTotal}" type="currency" currencySymbol=""/>
                            </th>
                            <th class="text-right">
                                %{-- --- --}%
                                <g:formatNumber number="${totalTotal}" type="currency" currencySymbol=""/>
                            </th>
                        </tr>
                    </tfoot>
                </table>
            </div>
        </elm:container>

        <script type="text/javascript">
            function armaParams() {
                var params = "";
                if ("${params.search_programa}" != "") {
                    params += "search_programa=${params.search_programa}";
                }
                if ("${params.search_nombre}" != "") {
                    if (params != "") {
                        params += "&";
                    }
                    params += "search_nombre=${params.search_nombre}";
                }
                if ("${params.search_desde}" != "") {
                    if (params != "") {
                        params += "&";
                    }
                    params += "search_desde=${params.search_desde}";
                }
                if ("${params.search_hasta}" != "") {
                    if (params != "") {
                        params += "&";
                    }
                    params += "search_hasta=${params.search_hasta}";
                }
                if (params != "") {
                    params = "&" + params;
                }
                return params;
            }

            var $container = $(".divTabla");
            $container.scrollTop(0 - $container.offset().top + $container.scrollTop());
            $(function () {
                $(".btn-edit").click(function () {
                    openLoader();
                });
                $("#anio").val(${anio.id}).change(function () {
                    openLoader();
                    location.href = "${createLink(controller: 'cronograma', action: 'show', id: proyecto.id)}?anio=" +
                                    $("#anio").val() + armaParams() + "&act=${actSel?.id}&list=${params.list}";
                });

                $(".scrollComp").click(function () {
                    var $scrollTo = $($(this).attr("href"));
                    $container.animate({
                        scrollTop : $scrollTo.offset().top - $container.offset().top + $container.scrollTop()
                    });
                    return false;
                });

            });
        </script>

    </body>
</html>