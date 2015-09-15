<table style="width:100%;margin-top: 15px" class="table " border="1">
    <thead>
        <tr>
            <th style="background: #9dbfdb; text-align: center">Proyecto</th>
            <th style="background: #9dbfdb; text-align: center">Componente</th>
            <th style="background: #9dbfdb; text-align: center">No</th>
            <th style="background: #9dbfdb; text-align: center">Nombre de la actividad</th>
            <th style="background: #9dbfdb; text-align: center">
                Partida <br/>
                presupuestaria
            </th>
            <th>Responsable</th>
            <th style="background: #9dbfdb; text-align: center">Valor inicial</th>
            <th style="background: #9dbfdb; text-align: center">Disminución</th>
            <th style="background: #9dbfdb; text-align: center">Aumento</th>
            <th style="background: #9dbfdb; text-align: center">Valor final</th>
        </tr>
    </thead>
    <tbody>
        <g:set var="tInicial" value="${0}"/>
        <g:set var="tDism" value="${0}"/>
        <g:set var="tAum" value="${0}"/>
        <g:set var="tFinal" value="${0}"/>
        <g:each in="${det}" var="dd">
            <g:set var="d" value="${dd.value}"/>
            <g:set var="tInicial" value="${tInicial + d.desde.inicial}"/>
            <g:set var="tDism" value="${tDism + d.desde.dism}"/>
            <g:set var="tAum" value="${tAum + d.desde.aum}"/>
            <g:set var="tFinal" value="${tFinal + d.desde.final}"/>
            <tr class="info">
                <td>${d.desde.proyecto}</td>
                <td>${d.desde.componente}</td>
                <td>${d.desde.no}</td>
                <td>${d.desde.actividad}</td>
                <td>${d.desde.partida}</td>
                <td></td>
                <td class="text-right"><g:formatNumber number="${d.desde.inicial}" type="currency" currencySymbol=""/></td>
                <td class="text-right"><g:formatNumber number="${d.desde.dism}" type="currency" currencySymbol=""/></td>
                <td class="text-right"><g:formatNumber number="${d.desde.aum}" type="currency" currencySymbol=""/></td>
                <td class="text-right"><g:formatNumber number="${d.desde.final}" type="currency" currencySymbol=""/></td>
            </tr>
            <g:each in="${d.hasta}" var="h">
                <g:set var="tInicial" value="${tInicial + h.inicial}"/>
                <g:set var="tDism" value="${tDism + h.dism}"/>
                <g:set var="tAum" value="${tAum + h.aum}"/>
                <g:set var="tFinal" value="${tFinal + h.final}"/>
                <tr class="success">
                    <td>${h.proyecto}</td>
                    <td>${h.componente}</td>
                    <td>${h.no}</td>
                    <td>${h.actividad}</td>
                    <td>${h.partida}</td>
                    <td></td>
                    <td class="text-right"><g:formatNumber number="${h.inicial}" type="currency" currencySymbol=""/></td>
                    <td class="text-right"><g:formatNumber number="${h.dism}" type="currency" currencySymbol=""/></td>
                    <td class="text-right"><g:formatNumber number="${h.aum}" type="currency" currencySymbol=""/></td>
                    <td class="text-right"><g:formatNumber number="${h.final}" type="currency" currencySymbol=""/></td>
                </tr>
            </g:each>
        </g:each>
    </tbody>
    <tfoot>
        <tr>
            <th colspan="5" class="text-right formato">TOTAL</th>
            <th class="text-right formato"><g:formatNumber number="${tInicial}" type="currency" currencySymbol=""/></th>
            <th class="text-right formato"><g:formatNumber number="${tDism}" type="currency" currencySymbol=""/></th>
            <th class="text-right formato"><g:formatNumber number="${tAum}" type="currency" currencySymbol=""/></th>
            <th class="text-right formato"><g:formatNumber number="${tFinal}" type="currency" currencySymbol=""/></th>
        </tr>
    </tfoot>
</table>