<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 08/04/15
  Time: 11:25 AM
--%>

<script type="text/javascript" src="${resource(dir: 'js', file: 'ui.js')}"></script>

<g:each in="${ajustes}" var="ajuste">

    <g:set var="urlPdf" value="${createLink(controller: 'reporteReformaPoa', action: 'ajustePOA', id: ajuste.id)}"/>

    <g:set var="firma1" value="${ajuste.firma1.estado == 'F'}"/>
    <g:set var="firma2" value="${ajuste.firma2.estado == 'F'}"/>

    <g:set var="origenAnterior" value="${ajuste.desde.priorizado}"/>
    <g:set var="destinoAnterior" value="${ajuste.recibe.priorizado}"/>
    <g:set var="origenNuevo" value="${ajuste.desde.priorizado - ajuste.valor}"/>
    <g:set var="destinoNuevo" value="${ajuste.recibe.priorizado + ajuste.valor}"/>

    <g:set var="estado" value="info"/>
    <g:if test="${firma1 && firma2}">
        <g:set var="estado" value="success"/>

        <g:set var="origenNuevo" value="${ajuste.desde.priorizado}"/>
        <g:set var="destinonuevo" value="${ajuste.recibe.priorizado}"/>
        <g:set var="origenAnterior" value="${ajuste.desde.priorizado + ajuste.valor}"/>
        <g:set var="destinoAnterior" value="${ajuste.recibe.priorizado - ajuste.valor}"/>
    </g:if>
    <g:elseif test="${firma1 && !firma2 || firma2 && !firma1}">
        <g:set var="estado" value="warning"/>
    </g:elseif>

    <div class="panel panel-${estado}">
        <div class="panel-heading">
            <h1 class="panel-title">
                Ajuste realizado el ${ajuste.fecha.format("dd-MM-yyyy")}
                por un valor de <g:formatNumber number="${ajuste.valor}" type="currency"/>
                <smalll>
                    <g:link controller="pdf" action="pdfLink" class="btn btn-xs btn-default btnPdf" params="[url: urlPdf, filename: 'ajustePoa.pdf']" title="Impirimir">
                        <i class="fa fa-print"></i>
                    </g:link>
                </smalll>
            </h1>
        </div>

        <div class="panel-body">
            <div class="asignacion">
                <table class="table table-bordered table-condensed table-hover">
                    <thead>
                        <tr>
                            <th>Proyecto</th>
                            <th>Componente</th>
                            <th>Actividad</th>
                            <th>Partida</th>
                            <th>Desc. Presupuestaria</th>
                            <th>Fuente</th>
                            <th>Valor anterior</th>
                            <th>Valor nuevo</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td colspan="8" class="titulo">
                                Asignación de origen
                            </td>
                        </tr>
                        <tr>
                            <td title="${ajuste.desde.marcoLogico.proyecto.toStringCompleto()}">
                                ${ajuste.desde.marcoLogico.proyecto}
                            </td>
                            <td>
                                ${ajuste.desde.marcoLogico.marcoLogico.numeroComp} - ${ajuste.desde.marcoLogico.marcoLogico}
                            </td>
                            <td>
                                ${ajuste.desde.marcoLogico.numero} - ${ajuste.desde.marcoLogico}
                            </td>
                            <td>
                                ${ajuste.desde.presupuesto.numero}
                            </td>
                            <td>
                                ${ajuste.desde.presupuesto.descripcion}
                            </td>
                            <td>
                                ${ajuste.desde.fuente?.descripcion}
                            </td>
                            <td>
                                <g:formatNumber number="${origenAnterior}" type="currency" currencySymbol=""/>
                            </td>
                            <td>
                                <g:formatNumber number="${origenNuevo}" type="currency" currencySymbol=""/>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="8" class="titulo">
                                Asignación de destino
                            </td>
                        </tr>
                        <tr>
                            <td title="${ajuste.recibe.marcoLogico.proyecto.toStringCompleto()}">
                                ${ajuste.recibe.marcoLogico.proyecto}
                            </td>
                            <td>
                                ${ajuste.recibe.marcoLogico.marcoLogico.numeroComp} - ${ajuste.recibe.marcoLogico.marcoLogico}
                            </td>
                            <td>
                                ${ajuste.recibe.marcoLogico.numero} - ${ajuste.recibe.marcoLogico}
                            </td>
                            <td>
                                ${ajuste.recibe.presupuesto.numero}
                            </td>
                            <td>
                                ${ajuste.recibe.presupuesto.descripcion}
                            </td>
                            <td>
                                ${ajuste.recibe.fuente?.descripcion}
                            </td>
                            <td>
                                <g:formatNumber number="${destinoAnterior}" type="currency" currencySymbol=""/>
                            </td>
                            <td>
                                <g:formatNumber number="${destinoNuevo}" type="currency" currencySymbol=""/>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>

            <div class="asignacion">
                <div class="titulo-azul">Autorizaciones electrónicas</div>

                <div class="row">
                    <div class="col-md-2">${ajuste.firma1.usuario}</div>

                    <div class="col-md-4">
                        <g:if test="${firma1}">
                            Firmado el ${ajuste.firma1.fecha.format("dd-MM-yyyy")}
                        </g:if>
                        <g:else>
                        %{--<g:if test="${ajuste.firma1.usuarioId.toString() == params.firma}">--}%
                        %{--<a href="#" class="btn btn-success btnFirmar" data-id="${ajuste.id}">--}%
                        %{--<i class="fa fa-pencil"></i> Firmar--}%
                        %{--</a>--}%
                        %{--</g:if>--}%
                        %{--<g:else>--}%
                            Sin firma
                        %{--</g:else>--}%
                        </g:else>
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-2">${ajuste.firma2.usuario}</div>

                    <div class="col-md-4">
                        <g:if test="${firma2}">
                            Firmado el ${ajuste.firma2.fecha.format("dd-MM-yyyy")}
                        </g:if>
                        <g:else>
                        %{--<g:if test="${ajuste.firma2.usuarioId.toString() == params.firma}">--}%
                        %{--<a href="#" class="btn btn-success btnFirmar" data-id="${ajuste.id}">--}%
                        %{--<i class="fa fa-pencil"></i> Firmar--}%
                        %{--</a>--}%
                        %{--</g:if>--}%
                        %{--<g:else>--}%
                            Sin firma
                        %{--</g:else>--}%
                        </g:else>
                    </div>
                </div>
            </div>
        </div>
    </div>
</g:each>

<script type="text/javascript">
    $(function () {

        %{--$(".btnFirmar").click(function () {--}%
        %{--var id = $(this).data("id");--}%
        %{--bootbox.confirm("¿Está seguro? Esta acción no puede revertirse", function (res) {--}%
        %{--if (res) {--}%

        %{--var msg = $("<div>Ingrese su clave de autorización</div>");--}%
        %{--var $txt = $("<input type='password' class='form-control input-sm'/>");--}%

        %{--var $group = $('<div class="input-group">');--}%
        %{--var $span = $('<span class="input-group-addon"><i class="fa fa-lock"></i> </span>');--}%
        %{--$group.append($txt).append($span);--}%

        %{--msg.append($group);--}%

        %{--var bAuth = bootbox.dialog({--}%
        %{--title   : "Autorización electrónica",--}%
        %{--message : msg,--}%
        %{--class   : "modal-sm",--}%
        %{--buttons : {--}%
        %{--cancelar : {--}%
        %{--label     : "Cancelar",--}%
        %{--className : "btn-primary",--}%
        %{--callback  : function () {--}%
        %{--}--}%
        %{--},--}%
        %{--eliminar : {--}%
        %{--label     : "<i class='fa fa-pencil'></i> Firmar",--}%
        %{--className : "btn-success",--}%
        %{--callback  : function () {--}%
        %{--openLoader("Firmando ajuste");--}%

        %{--$.ajax({--}%
        %{--type    : "POST",--}%
        %{--url     : '${createLink( action:'firmarAjuste_ajax')}',--}%
        %{--data    : {--}%
        %{--id   : id,--}%
        %{--pass : $txt.val()--}%
        %{--},--}%
        %{--success : function (msg) {--}%
        %{--closeLoader();--}%
        %{--if (msg == "error") {--}%
        %{--bootbox.alert({--}%
        %{--message : "Clave incorrecta",--}%
        %{--title   : "Error",--}%
        %{--class   : "modal-error"--}%
        %{--}--}%
        %{--);--}%
        %{--} else {--}%
        %{--log("Documento firmado correctamente", "success");--}%
        %{--setTimeout(function () {--}%
        %{--location.reload(true)--}%
        %{--}, 3000);--}%
        %{--//                                                    location.href = msg--}%
        %{--closeLoader();--}%

        %{--}--}%
        %{--},--}%
        %{--error   : function () {--}%
        %{--log("Ha ocurrido un error interno", "error");--}%

        %{--closeLoader();--}%
        %{--}--}%
        %{--});--}%
        %{--}--}%
        %{--}--}%
        %{--}--}%
        %{--});--}%
        %{--setTimeout(function () {--}%
        %{--bAuth.find(".form-control").first().focus();--}%
        %{--}, 500);--}%
        %{--}--}%
        %{--});--}%
        %{--return false;--}%
        %{--});--}%
    });
</script>