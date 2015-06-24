<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 04/05/15
  Time: 10:24 AM
--%>

<table class="table table-hover table-condensed table-hover table-bordered">
    <thead>
        <tr>
            <th>Objetivo gasto corriente</th>
            <th>MacroActividad</th>
            <th>Actividad</th>
            <th>Tarea</th>
            <th>Responsable</th>
            <th>
                Partida <br/>
                presupuestaria
            </th>
            <th>Valor inicial<br/>USD</th>
            <th>Disminución<br/>USD</th>
            <th>Aumento<br/>USD</th>
            <th>Valor final<br/>USD</th>
            <g:if test="${btnSelect}">
                <th>Saldo<br/>USD</th>
                <th></th>
            </g:if>
            <g:elseif test="${btnDelete}">
                <th></th>
            </g:elseif>
        </tr>
    </thead>
    <tbody class="tb">
        <g:set var="tInicial" value="${0}"/>
        <g:set var="tDism" value="${0}"/>
        <g:set var="tAum" value="${0}"/>
        <g:set var="tFinal" value="${0}"/>
        <g:set var="tSaldo" value="${0}"/>
        <g:each in="${det}" var="dd">
            <g:set var="d" value="${dd.value}"/>
            <g:set var="tInicial" value="${tInicial + d.desde.inicial}"/>
            <g:set var="tDism" value="${tDism + d.desde.dism}"/>
            <g:set var="tAum" value="${tAum + d.desde.aum}"/>
            <g:set var="tFinal" value="${tFinal + d.desde.final}"/>
            <g:if test="${d.desde.objetivo}">
                <tr class="info"
                    data-aso="${d.desde.asignacion}"
                    data-asd="${d.hasta && d.hasta.size() > 0 ? d.hasta?.first()?.asignacion : ''}">
                    <td>${d.desde.objetivo}</td>
                    <td>${d.desde.macro}</td>
                    <td>${d.desde.actividad}</td>
                    <td>${d.desde.tarea}</td>
                    <td>${d.desde.responsable}</td>
                    <td class="text-center">${d.desde.partida}</td>
                    <td class="text-right"><g:formatNumber number="${d.desde.inicial}" type="currency" currencySymbol=""/></td>
                    <td class="text-right"><g:formatNumber number="${d.desde.dism}" type="currency" currencySymbol=""/></td>
                    <td class="text-right"><g:formatNumber number="${d.desde.aum}" type="currency" currencySymbol=""/></td>
                    <td class="text-right"><g:formatNumber number="${d.desde.final}" type="currency" currencySymbol=""/></td>
                    <g:if test="${btnDelete}">
                        <td rowspan="2" class="danger" style="vertical-align: middle;">
                            <a href="#" class="btn btn-xs btn-danger btnDeleteDetalle" title="Eliminar detalle" data-id="${d.desde.id}">
                                <i class="fa fa-trash-o"></i>
                            </a>
                        </td>
                    </g:if>
                </tr>
            </g:if>
            <g:each in="${d.hasta}" var="h">
                <g:set var="tInicial" value="${tInicial + h.inicial}"/>
                <g:set var="tDism" value="${tDism + h.dism}"/>
                <g:set var="tAum" value="${tAum + h.aum}"/>
                <g:set var="tFinal" value="${tFinal + h.final}"/>
                <g:if test="${btnSelect}">
                    <g:set var="tSaldo" value="${tSaldo + h.saldo}"/>
                </g:if>
                <tr class="success"
                    data-saldo="${h.saldo}"
                    data-asd="${h.asignacion}">
                    <td>${h.objetivo}</td>
                    <td>${h.macro}</td>
                    <td>${h.actividad}</td>
                    <td>${h.tarea}</td>
                    <td>${h.responsable}</td>
                    <td class="text-center">${h.partida}</td>
                    <td class="text-right"><g:formatNumber number="${h.inicial}" type="currency" currencySymbol=""/></td>
                    <td class="text-right"><g:formatNumber number="${h.dism}" type="currency" currencySymbol=""/></td>
                    <td class="text-right"><g:formatNumber number="${h.aum}" type="currency" currencySymbol=""/></td>
                    <td class="text-right"><g:formatNumber number="${h.final}" type="currency" currencySymbol=""/></td>
                    <g:if test="${btnSelect}">
                        <td class="text-right"><g:formatNumber number="${h.saldo}" type="currency" currencySymbol=""/></td>
                        <th>
                            <g:if test="${h.saldo > 0}">
                                <a href="#" class="btn btn-xs btn-success btnSelect" title="Seleccionar asignación de origen" data-id="${h.id}">
                                    <i class="fa fa-pencil-square"></i>
                                </a>
                            </g:if>
                        </th>
                    </g:if>
                </tr>
            </g:each>
        </g:each>
    </tbody>
    <tfoot>
        <tr>
            <th colspan="6" class="text-right formato">TOTAL</th>
            <th class="text-right formato"><g:formatNumber number="${tInicial}" type="currency" currencySymbol=""/></th>
            <th class="text-right formato"><g:formatNumber number="${tDism}" type="currency" currencySymbol=""/></th>
            <th class="text-right formato"><g:formatNumber number="${tAum}" type="currency" currencySymbol=""/></th>
            <th class="text-right formato"><g:formatNumber number="${tFinal}" type="currency" currencySymbol=""/></th>
            <g:if test="${btnSelect}">
                <th class="text-right"><g:formatNumber number="${tSaldo}" type="currency" currencySymbol=""/></th>
                <th></th>
            </g:if>
            <g:elseif test="${btnDelete}">
                <th></th>
            </g:elseif>
        </tr>
    </tfoot>
</table>