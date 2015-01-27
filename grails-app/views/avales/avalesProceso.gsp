<%@ page import="vesta.parametros.TipoElemento" contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta name="layout" content="main"/>
    <title>Avales</title>
</head>

<body>

<elm:message tipo="${flash.tipo}" clase="${flash.clase}">${flash.message}</elm:message>

<div class="btn-toolbar toolbar">
    <div class="btn-group">
        <g:link controller="avales" action="listaProcesos" class="btn btn-default"> <i class="fa fa-bars"></i> Lista de Procesos</g:link>
        <g:link controller="avales" action="solicitarAval" class="btn btn-default" id="${proceso.id}"> <i class="fa fa-file-o"></i> Nueva solicitud</g:link>
    </div>
</div>


<div role="tabpanel" style="width: 1050px;margin-top: 10px;">

    <ul class="nav nav-tabs" role="tablist">
        <li role="presentation" class="active"><a href="#lista" class="btn-default active" role="tab" data-toggle="tab">Avales</a></li>
        <li role="presentation"><a href="#solicitudes" class="btn-default" role="tab" data-toggle="tab">Solicitudes</a></li>
    </ul>

    <div class="tab-content">
        <div class="tab-pane fade in active" id="lista">
            <g:if test="${avales.size() > 0}">
                <table class="table table-condensed table-bordered table-striped table-hover" >
                    <thead>
                    <tr>
                        <th>Proceso</th>
                        <th>Concepto</th>
                        <th>Fecha</th>
                        <th>Número</th>
                        <th>Monto</th>
                        <th>Estado</th>
                        <th>Aval</th>
                        <th></th>
                    </tr>
                    </thead>
                    <tbody>
                    <g:each in="${avales}" var="p">
                        <tr>
                            <td>${p.proceso.nombre}</td>
                            <td>${p.concepto}</td>
                            <td style="text-align: center">${p.fechaAprobacion?.format("dd-MM-yyyy")}</td>
                            <td style="text-align: center">${p.numero}</td>
                            <td style="text-align: right">
                                <g:formatNumber number="${p.monto}" format="###,##0" minFractionDigits="2" maxFractionDigits="2"/>
                            </td>
                           <g:set var="avalEstado" value="${p?.estado?.codigo}"/>
                            <td style="text-align: center" class="${avalEstado == 'E05' ? 'amarillo' : avalEstado == 'E04' ? 'rojo' : 'verde'}">
                            ${p.estado?.descripcion}
                            </td>

                            <td style="text-align: center">
                                <a href="#" class="imprimiAval btn btn-info btn-sm" title="Imprimir" iden="${p.id}"><i class="fa fa-print "></i></a>
                            </td>
                            <td style="text-align: center">
                                <g:if test="${p.estado.codigo == 'E02'}">
                                    <a href="#" class="solAnulacion" iden="${p.id}">Solicitar anulación</a>
                                </g:if>
                            </td>
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </g:if>
        </div>

        <div class="tab-pane fade" role="tabpanel" id="solicitudes">
            <g:if test="${solicitudes.size() > 0}">
                <table class="table table-condensed table-bordered table-striped table-hover">
                    <thead>
                    <tr>
                        <th>Fecha</th>
                        <th>Proceso</th>
                        <th>Tipo</th>
                        <th>Concepto</th>
                        <th>Monto</th>
                        <th>Estado</th>
                        <th>Doc. <br>Respaldo</th>
                        <th>Solicitud</th>
                        <th>Observaciones</th>
                    </tr>
                    </thead>
                    <tbody>
                    <g:each in="${solicitudes}" var="p">
                        <tr>
                            <td>${p.fecha.format("dd-MM-yyyy")}</td>
                            <td>${p.proceso.nombre}</td>
                            <td class="${(p.tipo == 'A') ? 'E03' : 'E02'}">${(p.tipo == "A") ? 'Anulación' : 'Aprobación'}</td>
                            <td>${p.concepto}</td>
                            <td style="text-align: right">
                                <g:formatNumber number="${p.monto}" type="currency"/>
                            </td>
                            <g:set var="avalEstado" value="${p?.estado?.codigo}"/>
                            <td style="text-align: center" class="${avalEstado == 'E05' ? 'amarillo' : avalEstado == 'E04' ? 'rojo' : avalEstado == 'E02' ? 'verde' : 'rojo'}">
                            ${p.estado?.descripcion}
                            ${p.estado?.codigo}
                            </td>

                            <td style="text-align: center">
                                <g:if test="${p.path}">
                                    <a href="#" class="btn descRespaldo btn-info btn-sm" iden="${p.id}"><i class="fa fa-search"></i> Ver</a>
                                </g:if>
                            </td>
                            <td style="text-align: center">
                                <g:if test="${p.tipo != 'A'}">
                                    <a href="#" class="imprimiSolicitud btn btn-info btn-sm" iden="${p.id}" title="Imprimir"><i class="fa fa-print "></i> </a>
                                </g:if>
                            </td>
                            <td>
                                <g:if test="${p.estado?.codigo=='E03'}">
                                    ${p.observaciones}
                                </g:if>
                            </td>
                        </tr>
                    </g:each>

                    </tbody>
                </table>
            </g:if>
        </div>
    </div>
</div>


<script>

    $(".imprimiAval").click(function () {
        location.href = "${createLink(controller:'avales',action:'descargaAval')}/" + $(this).attr("iden")
    })
    $(".imprimiSolicitud").click(function () {
        var url = "${g.createLink(controller: 'reporteSolicitud',action: 'imprimirSolicitudAval')}/?id=" + $(this).attr("iden")
        location.href = "${createLink(controller:'pdf',action:'pdfLink')}?url=" + url + "&filename=solicitud.pdf"
    })
    $(".descRespaldo").click(function () {
        location.href = "${createLink(controller:'avales',action:'descargaSolicitud')}/" + $(this).attr("iden")

    });
    $(".solAnulacion").click(function () {
        location.href = '${g.createLink(action: "solicitarAnulacion")}/' + $(this).attr("iden")
    })

</script>
</body>
</html>