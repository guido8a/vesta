<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 26/06/15
  Time: 10:57 AM
--%>

<script src="${resource(dir: 'js', file: 'ui.js')}"></script>

<table class="table table-bordered table-hover table-striped table-condensed">
    <thead>
        <tr>
            <th>Solicita</th>
            <th>Nombre del proceso</th>
            <th>Concepto</th>
            <th>Estado</th>
            <th style="width: 85px">Fecha</th>
            <th style="width: 85px">Inicio</th>
            <th style="width: 85px">Fin</th>
            <th>Monto</th>
        </tr>
    </thead>
    <tbody>
        <g:each in="${procesos}" var="proc">
            <tr>
                <td>${proc.usuario.unidad} - ${proc.usuario}</td>
                <td>${proc.nombreProceso}</td>
                <td>${proc.concepto}</td>
                <td>${proc.estado.descripcion}</td>
                <td>${proc.fechaSolicitud.format("dd-MM-yyyy")}</td>
                <td>${proc.fechaInicioProceso.format("dd-MM-yyyy")}</td>
                <td>${proc.fechaFinProceso.format("dd-MM-yyyy")}</td>
                <td class="text-right"><g:formatNumber number="${proc.monto}" type="currency" currencySymbol=""/></td>
            </tr>
        </g:each>
    </tbody>
</table>