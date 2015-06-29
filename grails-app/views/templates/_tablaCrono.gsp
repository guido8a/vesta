<%@ page import="vesta.proyectos.Cronograma; vesta.proyectos.MarcoLogico; vesta.parametros.poaPac.Mes; vesta.parametros.poaPac.Anio" %>
<table class="table table-condensed table-bordered table-hover table-striped" id="tblCrono">
    <thead>
        <tr>
            <th></th>
            <th colspan="16">
                <g:select from="${Anio.list([sort: 'anio'])}" optionKey="id" optionValue="anio" class="form-control input-sm"
                          style="width: 100px; display: inline" name="anio" id="anio" value="${anio.id}"/>
            </th>
        </tr>

        <tr id="trMeses">
            <th colspan="2" style="width:300px;">Componentes/Rubros</th>
            <g:each in="${Mes.list()}" var="mes">
                <th style="width:100px;" data-id="${mes.id}" title="${mes.descripcion} ${anio.anio}">
                    ${mes.descripcion[0..2]}.
                </th>
            </g:each>
            <th>Total<br/>Año</th>
            <th>Sin<br/>asignar</th>
            <th>Total<br/>Asignado</th>
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
            <tr id="comp${comp.id}" class="comp">
                <th colspan="17" class="success">
                    <strong>Componente ${comp.numeroComp}</strong>:
                ${(comp.objeto.length() > 80) ? comp.objeto.substring(0, 80) + "..." : comp.objeto}
                </th>
            </tr>
            <g:each in="${MarcoLogico.findAllByMarcoLogicoAndEstado(comp, 0, [sort: 'id'])}" var="act" status="i">
                <g:if test="${!actSel || (actSel && actSel.id == act.id)}">
                    <g:set var="asignadoAct" value="${act.getTotalCronograma()}"/> %{-- / --}%
                    <g:set var="asignadoActAnio" value="${act.getTotalCronogramaAnio(anio)}"/> %{-- / --}%
                    <g:set var="totalAct" value="${act.monto}"/> %{-- - --}%
                    <g:set var="sinAsignarAct" value="${totalAct - asignadoAct}"/> %{-- * --}%

                    <g:set var="asignadoComp" value="${asignadoComp + asignadoActAnio}"/> %{-- // --}%
                    <g:set var="totalComp" value="${totalComp + totalAct}"/> %{-- -- --}%
                    <g:set var="sinAsignarComp" value="${sinAsignarComp + sinAsignarAct}"/> %{-- ** --}%

                    <g:set var="asignadoTotal" value="${asignadoTotal + asignadoActAnio}"/> %{-- /// --}%
                    <g:set var="totalTotal" value="${totalTotal + totalAct}"/> %{-- --- --}%
                    <g:set var="sinAsignarTotal" value="${sinAsignarTotal + sinAsignarAct}"/> %{-- *** --}%
                    <tr data-id="${act.id}" class="act comp${comp.id}">
                        <th class="success">
                            ${act.numero}
                        </th>
                        <th class="success actividad" title="${act.responsable} - ${act.objeto}" style="width:300px;">
                            ${(act.objeto.length() > 100) ? act.objeto.substring(0, 100) + "..." : act.objeto}
                        </th>
                        <g:each in="${Mes.list()}" var="mes" status="k">
                            <g:set var="crga" value='${Cronograma.findAllByMarcoLogicoAndMes(act, mes)}'/>
                            <g:set var="valor" value="${0}"/>
                            <g:set var="clase" value="disabled"/>

                            <g:if test="${crga.size() > 0}">
                                <g:each in="${crga}" var="c">
                                    <g:if test="${c?.anio == anio}">
                                        <g:set var="crg" value='${c}'/>
                                    </g:if>
                                </g:each>
                                <g:if test="${crg}">
                                    <g:set var="valor" value="${crg.valor + crg.valor2}"/>
                                    <g:set var="clase" value="clickable"/>
                                </g:if>
                            </g:if>
                            <g:if test="${totalAct > 0}">
                                <g:set var="clase" value="clickable"/>
                            </g:if>
                            <g:else>
                                <g:set var="clase" value="nop"/>
                            </g:else>
                            <td style="width:100px;" class="text-right ${clase} ${crg && crg.fuente ? 'fnte_' + crg.fuente.id : ''} ${crg && crg.fuente2 ? 'fnte_' + crg.fuente2.id : ''}"
                                data-id="${crg?.id}" data-val="${valor}"
                                data-presupuesto1="${crg?.valor}" data-bsc-desc-partida1="${crg?.presupuesto?.toString()}"
                                data-partida1="${crg?.presupuesto?.id}"
                                data-fuente1="${crg?.fuente?.id}" data-desc-fuente1="${crg?.fuente?.descripcion}"
                                data-presupuesto2="${crg?.valor2}" data-bsc-desc-partida2="${crg?.presupuesto2?.toString()}"
                                data-partida2="${crg?.presupuesto2?.id}"
                                data-fuente2="${crg?.fuente2?.id}" data-desc-fuente2="${crg?.fuente2?.descripcion}">
                                %{--id: ${crg?.id}*${crg?.valor}*${crg?.valor2}--}%
                                <g:formatNumber number="${valor}" type="currency" currencySymbol=""/>
                            </td>
                            <g:if test="${crg}">
                                <g:set var="crg" value="${null}"/>
                            </g:if>
                        </g:each>
                        <th class="disabled text-right asignado nop" data-val="${asignadoAct}">
                            %{--1/--}%
                            <g:formatNumber number="${asignadoActAnio}" type="currency" currencySymbol=""/>
                        </th>
                        <th class="disabled text-right sinAsignar nop" data-val="${sinAsignarAct}">
                            %{--1*--}%
                            <g:formatNumber number="${sinAsignarAct}" type="currency" currencySymbol=""/>
                        </th>
                        <th class="disabled text-right total nop" data-val="${totalAct}">
                            %{--1---}%
                            %{--${act.id}*${act.monto}--}%
                            <g:formatNumber number="${totalAct}" type="currency" currencySymbol=""/>
                        </th>
                    </tr>
                </g:if>
            </g:each>
            <tr class="warning total comp${comp.id}">
                <th colspan="14">TOTAL</th>
                <th class="text-right nop">
                    %{-- // --}%
                    <g:formatNumber number="${asignadoComp}" type="currency" currencySymbol=""/>
                </th>
                <th class="text-right nop">
                    %{-- ** --}%
                    <g:formatNumber number="${sinAsignarComp}" type="currency" currencySymbol=""/>
                </th>
                <th class="text-right nop">
                    %{-- -- --}%
                    <g:formatNumber number="${totalComp}" type="currency" currencySymbol=""/>
                </th>
            </tr>
        </g:each>
    </tbody>
    <tfoot>
        <tr class="danger">
            <th colspan="14">TOTAL DEL PROYECTO</th>
            <th class="text-right nop">
                %{-- /// --}%
                <g:formatNumber number="${asignadoTotal}" type="currency" currencySymbol=""/><g:formatNumber number="${totProyAsig}" type="currency" currencySymbol=""/>
            </th>
            <th class="text-right nop">
                %{-- *** --}%
                <g:formatNumber number="${sinAsignarTotal}" type="currency" currencySymbol=""/>
            </th>
            <th class="text-right nop">
                %{-- --- --}%
                <g:formatNumber number="${totalTotal}" type="currency" currencySymbol=""/>
            </th>
        </tr>
    </tfoot>
</table>