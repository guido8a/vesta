<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 14/01/15
  Time: 04:03 PM
--%>
<%@ page import="vesta.proyectos.MarcoLogico; vesta.proyectos.Cronograma; vesta.parametros.poaPac.Mes; vesta.parametros.poaPac.Anio" contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <meta name="layout" content="main">
        <title>Cronograma del proyecto</title>
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

        tr:hover .disabled {
            background : #ccc !important;
        }
        </style>
    </head>

    <body>

        <!-- botones -->
        <div class="btn-toolbar toolbar">
            <div class="btn-group">
                <g:link controller="proyecto" action="list" params="${params}" class="btn btn-sm btn-default">
                    <i class="fa fa-list"></i> Lista de proyectos
                </g:link>
            </div>

            <div class="btn-group">
                <a href="#" class="btn btn-sm btn-default" id="btnGenerar">
                    <i class="fa fa-briefcase"></i> Generar asignaciones del proyecto
                </a>
                <g:link controller="asignacion" action="asignacionProyectov2" id="${proyecto.id}" class="btn btn-sm btn-default">
                    <i class="fa fa-money"></i> Asignaciones
                </g:link>
            </div>
        </div>

        <elm:container tipo="horizontal" titulo="Modificar cronograma del proyecto ${proyecto?.toStringMedio()}, para el año ${anio}" color="black">
            <div class="divIndice ">
                <g:each in="${componentes}" var="comp">
                    <a href="#comp${comp.id}" class="scrollComp ">
                        <strong>Componente ${comp.numeroComp}</strong>:
                    ${(comp.objeto.length() > 100) ? comp.objeto.substring(0, 100) + "..." : comp.objeto}
                    </a>
                </g:each>
            </div>

            <g:each in="${totAnios}" var="ta">
                <input type="hidden" id="fuente_${ta.key}" value="${ta.value}">
            </g:each>

            <div class="divTabla">
                <table class="table table-condensed table-bordered table-hover table-striped" id="tblCrono">
                    <thead>
                        <tr>
                            <th></th>
                            <th colspan="16">
                                <g:select from="${Anio.list()}" optionKey="id" optionValue="anio" class="form-control input-sm"
                                          style="width: 100px; display: inline" name="anio" id="anio" value="${anio.id}"/>
                            </th>
                        </tr>

                        <tr>
                            <th style="width: 300px;">Componentes/Rubros</th>
                            <g:each in="${Mes.list()}" var="mes">
                                <th style="width:100px;">${mes.descripcion[0..2]}.</th>
                            </g:each>
                            <th>Asignado</th>
                            <th>Sin asignar</th>
                            <th>Total</th>
                        </tr>
                    </thead>
                    <tbody>
                        <g:set var="indice" value="${0}"/>
                        <g:set var="totProy" value="${0}"/>
                        <g:set var="totProyAsig" value="${0}"/>
                        <g:set var="totalMetas" value="${0}"/>
                        <g:set var="totalMetasCronograma" value="${0}"/>

                        <g:each in="${componentes}" var="comp" status="j">
                            <g:set var="totComp" value="${0}"/>
                            <g:set var="totCompAsig" value="${0}"/>
                            <tr id="comp${comp.id}" class="success">
                                <th colspan="17">
                                    <strong>Componente ${comp.numeroComp}</strong>:
                                ${(comp.objeto.length() > 80) ? comp.objeto.substring(0, 80) + "..." : comp.objeto}
                                </th>
                            </tr>
                            <g:each in="${MarcoLogico.findAllByMarcoLogicoAndEstado(comp, 0, [sort: 'id'])}" var="act" status="i">
                                <g:if test="${!actSel}">
                                    <g:set var="monto" value="${act.monto}"/>
                                    <g:set var="totComp" value="${totComp.toDouble() + monto}"/>
                                    <g:set var="tot" value="${0}"/>
                                    <g:set var="totAct" value="${monto}"/>
                                    <g:set var="tot" value="${act.getTotalCronograma()}"/>
                                    <g:set var="totCompAsig" value="${totCompAsig.toDouble() + tot}"/>
                                    <g:set var="totalMetas" value="${totalMetas.toDouble() + monto}"/>

                                    <tr>
                                        <th class="success" title="${act.responsable} - ${act.objeto}" style="width:300px;">
                                            ${(act.objeto.length() > 100) ? act.objeto.substring(0, 100) + "..." : act.objeto}
                                        </th>
                                        <g:each in="${Mes.list()}" var="mes" status="k">
                                            <g:set var="crga" value='${Cronograma.findAllByMarcoLogicoAndMes(act, mes)}'/>
                                            <g:set var="val" value="${0}"/>
                                            <g:set var="clase" value="disabled"/>

                                            <g:if test="${crga.size() > 0}">
                                                <g:each in="${crga}" var="c">
                                                    <g:if test="${c?.anio == anio && c?.cronograma == null}">
                                                        <g:set var="crg" value='${c}'/>
                                                    </g:if>
                                                </g:each>

                                                <g:if test="${crg}">
                                                    <g:set var="val" value="${crg.valor + crg.valor2}"/>
                                                    <g:set var="crg" value="${null}"/>
                                                    <g:set var="clase" value=""/>
                                                </g:if>
                                            </g:if>
                                            <g:if test="${monto.toDouble() > 0}">
                                                <g:set var="clase" value=""/>
                                            </g:if>
                                            <td class="text-right ${clase}">
                                                <g:formatNumber number="${val}" type="currency"/>
                                            </td>
                                        </g:each>
                                        <td class="disabled text-right" id="tot_${j}${i}">
                                            <g:formatNumber number="${tot}" type="currency"/>
                                        </td>
                                        <td class="disabled text-right" id="tot_${j}${i}a">
                                            <g:formatNumber number="${act.monto - tot}" type="currency"/>
                                        </td>
                                        <td class="disabled text-right">
                                            <g:formatNumber number="${monto}" type="currency"/>
                                        </td>

                                    </tr>
                                </g:if>
                                <g:else>
                                    <g:if test="${actSel.id == act.id}">
                                        <g:set var="monto" value="${act.monto}"/>
                                        <g:set var="totComp" value="${totComp.toDouble() + monto}"/>
                                        <tr>

                                            <td class="colGrande" style="width: 220px;font-weight: bold" title="${act.responsable} - ${act.objeto}">
                                                ${(act.objeto.length() > 100) ? act.objeto.substring(0, 100) + "..." : act.objeto}
                                            </td>
                                            <g:set var="tot" value="${0}"/>
                                            <g:set var="totAct" value="${monto}"/>
                                            <g:each in="${Mes.list()}" var="mes" status="k">
                                                <g:set var="crga" value='${Cronograma.findAllByMarcoLogicoAndMes(act, mes)}'/>
                                                <g:if test="${crga.size() > 0}">
                                                    <g:each in="${crga}" var="c">
                                                        <g:if test="${c?.anio == anio && c?.cronograma == null}">
                                                            <g:set var="crg" value='${c}'/>
                                                        </g:if>
                                                    </g:each>
                                                    <g:if test="${crg}">
                                                        <g:if test="${true}">
                                                            <td style="width: 60px">

                                                                <input type="text" id="crg_${crg.id}" value='${formatNumber(number: crg.valor + crg.valor2, minFractionDigits: 2, maxFractionDigits: 2)}'
                                                                       class="num fa_${crg.fuente.id}" mes="${mes.id} " identificador="${crg.id}"
                                                                       actividad="${act.id}" tot="${monto}"
                                                                       div="tot_${j}${i}"
                                                                       mt="${mes.descripcion}" style="width: 60px"
                                                                       prsp_desc="${crg.presupuesto.descripcion}" prsp="${crg.presupuesto.id}" prsp_num="${crg.presupuesto.numero}"
                                                                       fuente="${crg.fuente.id}"
                                                                       prsp2="${crg.presupuesto2?.id}" prsp_num2="${crg.presupuesto2?.numero}" prsp_desc2="${crg.presupuesto2?.descripcion}"
                                                                       valor1="${formatNumber(number: crg.valor, minFractionDigits: 2, maxFractionDigits: 2)}"
                                                                       valor2="${formatNumber(number: crg.valor2, minFractionDigits: 2, maxFractionDigits: 2)}">

                                                            </td>
                                                        </g:if>
                                                        <g:else>
                                                            <td class="disabled" style="width: 60px">0,00</td>
                                                        </g:else>
                                                        <g:set var="crg" value="${null}"/>
                                                    </g:if>
                                                    <g:else>
                                                        <g:if test="${monto.toDouble() > 0}">
                                                            <td style="width: 60px">
                                                                <input type="text" id="crg_0${j}${i}${k}" value="0,00" class="num"
                                                                       mes="${mes.id} " actividad="${act.id}" identificador="0"
                                                                       tot="${monto}" div="tot_${j}${i}"
                                                                       mt="${mes.descripcion}" style="width: 60px" valor1="0,00" valor2="0,00">
                                                            </td>
                                                        </g:if>
                                                        <g:else>
                                                            <td class="disabled">0,00</td>
                                                        </g:else>
                                                    </g:else>
                                                </g:if>
                                                <g:else>
                                                    <g:if test="${monto.toDouble() > 0}">
                                                        <td style="width: 60px">
                                                            <input type="text" id="crg_0${j}${i}${k}" value="0,00" class="num"
                                                                   mes="${mes.id} " actividad="${act.id}" identificador="0"
                                                                   tot="${monto}" div="tot_${j}${i}"
                                                                   mt="${mes.descripcion}" style="width: 60px" valor1="0,00" valor2="0,00">
                                                        </td>
                                                    </g:if>
                                                    <g:else>
                                                        <td class="disabled">0,00</td>
                                                    </g:else>
                                                </g:else>
                                            </g:each>
                                        %{--<<----------------<<<<<<<< >>>>>>>>>>>>> <br>--}%
                                            <td class="disabled text-right" id="tot_${j}${i}" div="totComp_${j}">
                                                <g:set var="tot" value="${act.getTotalCronograma()}"/>
                                                <g:set var="totCompAsig" value="${totCompAsig.toDouble() + act.getTotalCronograma()}"/>
                                                <g:formatNumber number="${tot}" type="currency"/>
                                            </td>
                                            <td class="disabled text-right" id="tot_${j}${i}a" div="totComp_${j}a">
                                                <g:formatNumber number="${totAct.toDouble() - (tot.toDouble() + 0)}" type="currency"/>

                                            </td>
                                            <td class="disabled text-right">
                                                <g:formatNumber number="${monto}" type="currency"/>
                                                <g:set var="totalMetas" value="${totalMetas.toDouble() + monto}"/>
                                            </td>

                                        </tr>
                                    </g:if>
                                </g:else>

                            </g:each>
                        %{--<<----------------<<<<<<<< <br>--}%
                            <tr>
                                <td class="colGrande " colspan="13"><b>TOTAL</b>
                                </td>
                                <td class="text-center">
                                    <b><div id="totComp_${j}a" class="totCompsa text-right">
                                        <g:formatNumber number="${totCompAsig}" type="currency"/>
                                    </div></b>
                                </td>
                                <td class="text-center">
                                    <b>
                                        <div id="totComp_${j}" class="totComps text-right">
                                            <g:formatNumber number="${(totComp.toDouble() - totCompAsig.toDouble())}" type="currency"/>
                                        </div>
                                    </b>
                                </td>
                                <td class="text-right">
                                    <g:formatNumber number="${totalMetas}" type="currency"/>

                                    <g:set var="totalMetasCronograma" value="${totalMetasCronograma.toDouble() + totalMetas}"/>
                                    <g:set var="totalMetas" value="${0}"/>
                                </td>
                                <g:set var="totProyAsig"
                                       value="${totProyAsig.toDouble() + totCompAsig.toDouble()}"/>
                                <g:set var="totProy" value="${totProy.toDouble() + totComp.toDouble()}"/>
                                <g:set var="indice" value="${indice.toInteger() + 1}"/>
                                <g:if test="${indice > 4}">
                                    <g:set var="indice" value="${0}"/>
                                </g:if>
                            </tr>
                        </g:each>
                        <tr>
                            <td class="colGrande " style="background: #e8e8e8" colspan="13"><b>TOTAL DEL PROYECTO</b>
                            </td>
                            <td class="text-right">
                                <b>
                                    <div id="totGeneralAsignado">
                                        <g:formatNumber number="${totProyAsig}" type="currency"/>
                                        %{--${totProyAsig.toFloat().round(2)}--}%
                                    </div>
                                </b>
                            </td>
                            <td class="text-right">
                                <b>
                                    <div id="totGeneral">
                                        <g:formatNumber number="${(totProy.toDouble() - (totProyAsig.toDouble()))}" type="currency"/>
                                        %{--${(totProy.toDouble() - (totProyAsig.toDouble()+totOtroAnioProyecto.toDouble())).toFloat().round(2)}--}%
                                    </div>
                                </b>
                            </td>
                            <td class="text-right">
                                <g:formatNumber number="${(totalMetasCronograma)}" type="currency"/>
                            </td>
                        </tr>
                    </tbody>
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

            $(function () {
                var $container = $(".divTabla");
                $container.scrollTop(0 - $container.offset().top + $container.scrollTop());
                $("#anio").change(function () {
                    openLoader();
                    location.href = "${createLink(controller: 'cronograma', action: 'form', id: proyecto.id)}?anio=" + $("#anio").val() +
                                    armaParams() + "&act=${actSel?.id}";
                });

                $(".scrollComp").click(function () {
                    var $scrollTo = $($(this).attr("href"));
                    $container.animate({
                        scrollTop : $scrollTo.offset().top - $container.offset().top + $container.scrollTop()
                    });
                    return false;
                });

                $("#btnGenerar").click(function () {
                    var msg = "<i class='fa fa-warning fa-5x pull-left text-danger text-shadow'></i><p>" +
                              "<p class='lead'>¿Está seguro que desea generar las asignaciones del P.A.I. del año señalado?</p>" +
                              "<p class='lead'>Las asignaciones generadas anteriormente serán <span class='text-danger'><strong>ELIMINADAS</strong></span> " +
                              "así como su PAC y programación.</p>" +
                              "<p class='lead'>Los datos borrados no podrán ser recuperados.</p> " +
                              "<p class='lead text-warning'>Esta acción será registrada en log del sistema junto con su usuario</p>";
                    bootbox.confirm(msg, function (result) {
                        if (result) {
                            openLoader();
                            $.ajax({
                                type    : "POST",
                                url     : "${createLink(action:'calcularAsignaciones_ajax')}",
                                data    : {
                                    anio     : "${anio.id}",
                                    proyecto : "${proyecto.id}"
                                },
                                success : function (msg) {
                                    var parts = msg.split("*");
                                    log(parts[1], parts[0] == "SUCCESS" ? "success" : "error"); // log(msg, type, title, hide)
                                    setTimeout(function () {
                                        if (parts[0] == "SUCCESS") {
                                            if (id) {
                                                location.href = "${createLink(controller: 'asignacion', action: 'asignacionProyectov2', params:[id:proyecto.id, anio:anio.id])}";
                                            }
                                        }
                                        closeLoader();
                                    }, 1000);
                                }
                            });
                        }
                    });
                });

            });
        </script>

    </body>
</html>