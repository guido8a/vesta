<%--
  Created by IntelliJ IDEA.
  User: fabricio
  Date: 04/03/15
  Time: 12:39 PM
--%>

<style type="text/css">
.scrollable {
    max-height : 385px;
    overflow   : auto;
}
</style>

<p style="margin-left: 5px">
   <b>
     *  ${solicitudes.size()} solicitud${solicitudes.size() == 1 ? '' : 'es'} agendadas para la reunión del ${aprobacion.fecha.format("dd-MM-yyyy HH:mm")}
   </b>
</p>

<div class="scrollable">
    <table class="table table-condensed table-bordered table-striped table-hover">
        <thead>
        <th>N.</th>
        <th>Unidad Ejecutora</th>
        <th>Monto solicitado</th>
        <th>Nombre del proceso</th>
        </thead>
        <tbody>
        <g:each in="${solicitudes}" var="sol" status="i">
            <tr>
                <td>${i + 1}</td>
                <td>
                    ${sol.unidadEjecutora.nombre}
                </td>
                <td>
                    <g:formatNumber number="${sol.montoSolicitado}" type="currency"/>
                    <g:each in="${anios}" var="a">
                        <g:set var="valor" value="${vesta.contratacion.DetalleMontoSolicitud.findByAnioAndSolicitud(a, sol)}"/>
                        <br/>${a.anio} :
                        <g:if test="${valor}">
                            <g:formatNumber number="${valor.monto}" type="currency"/>
                        </g:if>
                    </g:each>
                </td>
                <td>
                    ${sol.nombreProceso}
                </td>
            </tr>
        </g:each>
        </tbody>
    </table>
</div>