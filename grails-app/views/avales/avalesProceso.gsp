<%@ page import="vesta.avales.SolicitudAval; vesta.parametros.TipoElemento" contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main"/>
        <title>Avales</title>

        <style type="text/css">
        .aprobacion {
            font-weight : bold;
            background  : #5faf56;
            color       : whitesmoke;
        }

        .anulacion {
            font-weight : bold;
            background  : #ad5656;
            color       : whitesmoke;
        }
        </style>

    </head>

    <body>

        <elm:message tipo="${flash.tipo}" clase="${flash.clase}">${flash.message}</elm:message>

        <div class="btn-toolbar toolbar">
            <div class="btn-group">
                <g:link controller="avales" action="listaProcesos" class="btn btn-default"><i class="fa fa-bars"></i> Lista de procesos de avales</g:link>
                <g:link controller="avales" action="solicitudProceso" class="btn btn-default" id="${proceso.id}">
                    <i class="fa fa-file-o"></i> Nueva solicitud
                </g:link>
            </div>
        </div>

        <h3 class="text-info">Avales y solicitudes de aval del proceso <em>${proceso.nombre}</em></h3>

        <div role="tabpanel">
            <!-- Nav tabs -->
            <ul class="nav nav-pills" role="tablist">
                <li role="presentation" class="active">
                    <a href="#avales" aria-controls="avales" role="tab" data-toggle="pill">Avales</a>
                </li>
                <li role="presentation">
                    <a href="#solicitudes" aria-controls="profile" role="tab" data-toggle="pill">Solicitudes</a>
                </li>
            </ul>

            <!-- Tab panes -->
            <div class="tab-content">
                <div role="tabpanel" class="tab-pane active" id="avales">
                    <g:if test="${avales.size() > 0}">
                        <table class="table table-condensed table-bordered table-striped table-hover" style="margin-top: 20px">
                            <thead>
                                <tr>
                                    <th>Proceso</th>
                                    <th>Concepto</th>
                                    <th>Fecha</th>
                                    <th>Número</th>
                                    <th>Monto</th>
                                    <th>Estado</th>
                                    <th>Aval</th>
                                    <th>Anulación</th>
                                </tr>
                            </thead>
                            <tbody>
                                <g:each in="${avales}" var="p">
                                    <tr>
                                        <td>${p.proceso.nombre}</td>
                                        <td>${p.concepto}</td>
                                        <td style="text-align: center">${p.fechaAprobacion?.format("dd-MM-yyyy")}</td>
                                        <td style="text-align: center">${p.numeroAval}</td>
                                        <td style="text-align: right">
                                            <g:formatNumber number="${p.monto}" format="###,##0" minFractionDigits="2" maxFractionDigits="2"/>
                                        </td>
                                        <g:set var="avalEstado" value="${p?.estado?.codigo}"/>
                                        <td style="text-align: center" class="${avalEstado == 'E05' ? 'amarillo' : avalEstado == 'E04' ? 'rojo' : 'verde'}">
                                            ${p.estado?.descripcion}
                                        </td>

                                        <td style="text-align: center">
                                            <a href="#" class="imprimiAval btn btn-info btn-sm" title="Imprimir" iden="${SolicitudAval.findByAval(p)?.id}">
                                                <i class="fa fa-print "></i>
                                            </a>
                                        </td>
                                        <td style="text-align: center">
                                            <g:if test="${p.estado.codigo == 'E02'}">
                                                <a href="#" class="solAnulacion btn btn-danger btn-sm" iden="${p.id}" title="Solicitar anulación">
                                                    <i class="fa fa-times"></i>
                                                </a>
                                            </g:if>
                                        </td>
                                    </tr>
                                </g:each>
                            </tbody>
                        </table>
                    </g:if>
                    <g:else>
                        <div class="alert alert-info" style="width: 450px;margin-top: 20px">No existen avales</div>
                    </g:else>
                </div>

                <div role="tabpanel" class="tab-pane" id="solicitudes">
                    <g:if test="${solicitudes.size() > 0}">
                        <table class="table table-condensed table-bordered table-striped table-hover" style="margin-top: 20px">
                            <thead>
                                <tr>
                                    <th style="width: 85px;">Fecha</th>
                                    <th>Proceso</th>
                                    <th>Tipo</th>
                                    <th>Justificación</th>
                                    <th>Monto</th>
                                    <th>Estado</th>
                                    <th>Revisor</th>
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
                                        <td class="${(p.tipo == 'A') ? 'anulacion' : 'aprobacion'}">${(p.tipo == "A") ? 'Anulación' : 'Aprobación'}</td>
                                        <td>${p.concepto}</td>
                                        <td style="text-align: right">
                                            <g:formatNumber number="${p.monto}" type="currency" currencySymbol=""/>
                                        </td>
                                        <g:set var="avalEstado" value="${p?.estado?.codigo}"/>
                                        <td style="text-align: center;font-weight: bold" class="${avalEstado == 'E05' ? 'amarillo' : avalEstado == 'E04' ? 'rojo' : avalEstado == 'E02' ? 'verde' : 'rojo'}">
                                            ${p.estado?.descripcion}
                                        </td>
                                        <td style="text-align: center">
                                                ${((p?.director?.nombre) ?: '') + " " + ((p?.director?.apellido) ?: '')}
                                        </td>

                                        <td style="text-align: center">
                                            <g:if test="${p.path}">
                                                <a href="#" class="btn descRespaldo btn-info btn-sm" iden="${p.id}"><i class="fa fa-search"></i> Ver
                                                </a>
                                            </g:if>
                                        </td>
                                        <td style="text-align: center">
                                            <g:if test="${p.tipo != 'A'}">
                                                <a href="#" class="imprimirSolicitud btn btn-info btn-sm" iden="${p.id}" title="Imprimir">
                                                    <i class="fa fa-print "></i>
                                                </a>
                                            </g:if>
                                            <g:else>
                                                <a href="#" class="imprimirNegacion btn btn-info btn-sm" iden="${p.id}" title="Imprimir">
                                                    <i class="fa fa-print "></i>
                                                </a>
                                            </g:else>
                                        </td>
                                        <td>
                                            <g:if test="${p.estado?.codigo == 'E03'}">
                                                ${p.observaciones}
                                            </g:if>
                                        </td>
                                    </tr>
                                </g:each>

                            </tbody>
                        </table>
                    </g:if>
                    <g:else>
                        <div class="alert alert-info" style="width: 450px;margin-top: 20px">No existen solicitudes</div>
                    </g:else>
                </div>
            </div>

        </div>


        <script type="text/javascript">
            $(".imprimiAval").click(function () {
                var url = "${g.createLink(controller: 'reportes',action: 'certificacion')}/?id=" + $(this).attr("iden")
                location.href = "${createLink(controller:'pdf',action:'pdfLink')}?url=" + url + "&filename=aval_" + $(this).attr("iden") + ".pdf"
            });
            $(".imprimirSolicitud").click(function () {
                var url = "${g.createLink(controller: 'reporteSolicitud',action: 'imprimirSolicitudAval')}/?id=" + $(this).attr("iden")
                location.href = "${createLink(controller:'pdf',action:'pdfLink')}?url=" + url + "&filename=solicitud.pdf"
            });
            $(".imprimirNegacion").click(function () {
                var url = "${g.createLink(controller: 'reporteSolicitud',action: 'imprimirSolicitudAnulacionAval')}/?id=" + $(this).attr("iden")
                location.href = "${createLink(controller:'pdf',action:'pdfLink')}?url=" + url + "&filename=negacion.pdf"
            });
            $(".descRespaldo").click(function () {
                location.href = "${createLink(controller:'avales',action:'descargaSolicitud')}/" + $(this).attr("iden")

            });
            $(".solAnulacion").click(function () {
                location.href = '${g.createLink(action: "solicitarAnulacion")}/' + $(this).attr("iden")
            });
        </script>
    </body>
</html>