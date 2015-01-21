<%--
  Created by IntelliJ IDEA.
  User: fabricio
  Date: 21/01/15
  Time: 02:17 PM
--%>

<%@ page import="vesta.parametros.TipoElemento" contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta name="layout" content="main"/>
    <title>Avales</title>
</head>

<body>
<g:if test="${flash.message}">
    <div class="message ui-state-highlight ui-corner-all">
        ${flash.message}
    </div>
</g:if>
<div class="fila">
    <g:link controller="avales" action="listaProcesos" class="btn">Procesos</g:link>
    <g:link controller="avales" action="solicitarAval" class="btn" id="${proceso.id}">Nueva solicitud</g:link>
</div>

<div id="tabs" style="width: 1050px;margin-top: 10px;">
    <ul>
        <li><a href="#lista">Avales</a></li>
        <li><a href="#solicitudes">Solicitudes</a></li>
    </ul>

    <div id="lista" style="width: 960px;">
        <g:if test="${avales.size() > 0}">
            <table style="width: 95%;margin-top: 10px">
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
                            <g:formatNumber number="${p.monto}" format="###,##0" minFractionDigits="2" maxFractionDigits="2"></g:formatNumber>
                        </td>
                        <td style="text-align: center" class="${p.estado?.codigo}">${p.estado?.descripcion}</td>
                        <td style="text-align: center">
                            <a href="#" class="imprimiAval" iden="${p.id}">Imprimir</a>
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

    <div id="solicitudes" style="width: 960px;">
        <g:if test="${solicitudes.size() > 0}">
            <table style="width: 95%;margin-top: 10px">
                <thead>
                <tr>
                    <th>Fecha</th>
                    <th>Proceso</th>
                    <th>Tipo</th>
                    <th>Concepto</th>
                    <th>Monto</th>
                    <th>Estado</th>
                    <th>Doc. Respaldo</th>
                    <th>Solicitud</th>
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
                        <td style="text-align: center" class="${p.estado?.codigo}">${p.estado?.descripcion}</td>
                        <td style="text-align: center">
                            <g:if test="${p.path}">
                                <a href="#" class="btn descRespaldo" iden="${p.id}">Ver</a>
                            </g:if>
                        </td>
                        <td style="text-align: center">
                            <g:if test="${p.tipo != 'A'}">
                                <a href="#" class="imprimiSolicitud" iden="${p.id}">Imprimir</a>
                            </g:if>
                        </td>
                    </tr>
                </g:each>

                </tbody>
            </table>
        </g:if>
    </div>

</div>

<script>
    $(".btn").button()
    $(".imprimiAval").button({icons : { primary : "ui-icon-print"}, text : false}).click(function () {
        location.href = "${createLink(controller:'avales',action:'descargaAval')}/" + $(this).attr("iden")
    })
    $(".imprimiSolicitud").button({icons : { primary : "ui-icon-print"}, text : false}).click(function () {
        var url = "${g.createLink(controller: 'reporteSolicitud',action: 'imprimirSolicitudAval')}/?id=" + $(this).attr("iden")
        location.href = "${createLink(controller:'pdf',action:'pdfLink')}?url=" + url + "&filename=solicitud.pdf"
    })
    $(".descRespaldo").click(function () {
        location.href = "${createLink(controller:'avales',action:'descargaSolicitud')}/" + $(this).attr("iden")

    });
    $(".solAnulacion").button({icons : { primary : "ui-icon-document-b"}, text : false}).click(function () {
        location.href = '${g.createLink(action: "solicitarAnulacion")}/' + $(this).attr("iden")
    })
    $("#tabs").tabs()
</script>
</body>
</html>