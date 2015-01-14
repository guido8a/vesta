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
        </div>

        <div class="divTabla">
            <table class="table table-condensed table-bordered table-hover table-striped" id="tblCrono">
                %{--<thead style="background: rgba(110, 182, 213,0.2)">--}%
                %{--<thead style="background: #595292">--}%
                <thead style="background: #d0d0d0">
                    <tr>
                        <th style="width: 220px">&nbsp;</th>
                        <g:form action="nuevoCronograma" method="post" class="frm_anio">
                            <input type="hidden" name="id" value="${proyecto.id}">
                            <input type="hidden" name="act" value="${actSel?.id}">
                            <g:each in="${totAnios}" var="ta">
                                <input type="hidden" id="fuente_${ta.key}" value="${ta.value}">
                            </g:each>
                            <th colspan="16">
                                <g:select from="${Anio.list([sort: 'anio'])}" optionKey="id" optionValue="anio"
                                          name="anio" id="anio" value="${anio.id}"
                                          style="width: 80px"/>
                            </th>
                        </g:form>
                    </tr>

                    <tr>
                        <th class="colGrande" style="width: 220px;">Componentes/Rubros</th>
                        <g:each in="${Mes.list()}" var="mes">
                            <th class="col" style="width: 60px;">${(mes.descripcion.size() > 5) ? mes.descripcion.substring(0, 5) + "." : mes.descripcion}</th>
                        </g:each>
                        <th style="width: 90px;">Asignado</th>
                        %{--<th style="width: 90px;">Asignado <br> otros años</th>--}%
                        <th style="width: 90px;">Sin<br> asignar</th>
                        <th style="width: 90px;">Monto</th>
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
                        <tr>
                            <td class="colGrande componente""
                                colspan="17"><b>Componente ${j + 1}</b>: ${(comp.objeto.length() > 80) ? comp.objeto.substring(0, 80) + "..." : comp.objeto}
                        </td>
                    </tr>
                        <g:each in="${MarcoLogico.findAllByMarcoLogicoAndEstado(comp, 0, [sort: 'id'])}" var="act" status="i">
                            <g:if test="${!actSel}">
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
                                                               fuente="${crg.fuente.id}" fuente2="${crg.fuente2?.id}"
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
                                    <g:set var="tot" value="${act.getTotalCronograma()}"/>
                                    <g:set var="totCompAsig" value="${totCompAsig.toDouble() + tot}"/>
                                    <td class="disabled text-right" id="tot_${j}${i}" div="totComp_${j}">
                                        <g:formatNumber number="${tot}" type="currency"/>
                                    </td>
                                    <td class="disabled text-right" id="tot_${j}${i}a" div="totComp_${j}a">
                                        <g:formatNumber number="${act.monto - tot}" type="currency"/>

                                    </td>
                                    <td class="disabled text-right">
                                        <g:formatNumber number="${monto}" type="currency"/>
                                        <g:set var="totalMetas" value="${totalMetas.toDouble() + monto}"/>
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

    </body>
</html>