<script type="text/javascript" src="${resource(dir: 'js', file: 'ui.js')}"></script>

<table class="table table-bordered table-condensed table-hover table-striped">
    <thead>
    <tr>
        <th style="width: 48px">Núm.</th>
        <th style="width: 62px">Fecha</th>
        <th style="width: 90px">Proyecto</th>
        <th style="width: 79px">Proceso</th>
        <th style="width: 60px">Tipo</th>
        <th style="width: 87px">Requirente</th>
        <th style="width: 87px">Concepto</th>
        <th style="width: 67px">Monto</th>
        <th style="width: 50px">Estado</th>
        <th style="width: 20px">Solicitud</th>
        <th style="width: 50px"># Aval</th>
        <th style="width: 45px">F. Emisión</th>
        <th style="width: 20px">Aval</th>
    </tr>
    </thead>
</table>


<div class="row-fluid"  style="width: 99.7%;height: 600px;overflow-y: auto;float: right; margin-top: -20px">
    <div class="span12">
        <div style="width: 1130px; height: 600px;">
            <table class="table table-bordered table-condensed table-hover table-striped">
                <tbody>
                <g:each in="${datos}" var="sol">
                    <tr>
                        <td style="width: 60px">${sol.numero}</td>
                        <td style="text-align: center; width: 50px">${sol.fecha.format("dd-MM-yyyy")}</td>
                        <td style="text-align: center; width: 50px" title="${sol.proceso.proyecto.toStringCompleto()}">${sol.proceso.proyecto}</td>
                        <td style="width: 60px">${sol.proceso.nombre}</td>
                        <td style="text-align: center; width: 50px" class="${(sol.tipo == 'A') ? 'E03' : 'E02'}">${(sol.tipo == "A") ? 'Anulación' : 'Aprobación'}</td>
                        <td style="width: 60px">${sol.unidad.getGerencia()}</td>
                        <td style="width: 60px">${sol.concepto}</td>
                        <td style="text-align: right; width: 44px">
                            <g:formatNumber number="${sol.monto}" type="currency" currencySymbol=""/>
                        </td>
                        <td style="text-align: center; width: 50px" class="${sol.estado?.codigo}">Solicitud ${sol.estado?.descripcion}</td>
                        <td style="text-align: center; width: 80px">
                            <g:if test="${sol.tipo != 'A'}">
                                <a href="#" class="btn btn-default btn-xs imprimirSolicitud" iden="${sol.id}">
                                    <i class="fa fa-search"></i>
                                </a>
                            </g:if>
                        </td>
                        <td style="width: 50px">
                            <g:if test="${sol.aval}">
                                <g:if test="${sol.aval.fechaAprobacion}">
                                    ${sol.aval.fechaAprobacion?.format("yyyy")}-GP No.<elm:imprimeNumero aval="${sol.aval.id}"/>
                                </g:if>
                                <g:else>
                                    ${sol.fecha.format("yyyy")}-GP No.<elm:imprimeNumero aval="${sol.aval.id}"/>
                                </g:else>
                            </g:if>
                        </td>
                        <td style="width: 50px">
                            <g:if test="${sol.aval}">
                                ${sol.aval.fechaAprobacion?.format("dd-MM-yyyy")}
                            </g:if>
                        </td>
                        <td style="text-align: center; width: 30px">
                            <g:if test="${sol.aval}">
                                <a href="#" class=" btn btn-xs btn-default imprimirAval" iden="${sol?.id}">
                                    <i class="fa fa-print"></i>
                                </a>
                            </g:if>
                        </td>
                    </tr>
                </g:each>
                </tbody>
            </table>
        </div>
    </div>
</div>




<script>
    $(".imprimirAval").click(function () {
        %{--location.href = "${createLink(controller:'avales',action:'descargaAval')}/"+$(this).attr("iden")--}%
        var url = "${g.createLink(controller: 'reportes',action: 'certificacion')}/?id=" + $(this).attr("iden");
        location.href = "${createLink(controller:'pdf',action:'pdfLink')}?url=" + url + "&filename=aval.pdf";
    });
    $(".imprimirSolicitud").click(function () {
        var url = "${g.createLink(controller: 'reporteSolicitud',action: 'imprimirSolicitudAval')}/?id=" + $(this).attr("iden");
        location.href = "${createLink(controller:'pdf',action:'pdfLink')}?url=" + url + "&filename=solicitud.pdf";
    });
</script>