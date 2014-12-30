<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 12/08/14
  Time: 01:25 PM
--%>

<%@ page import="vesta.contratacion.DetalleMontoSolicitud; vesta.seguridad.Prfl; vesta.proyectos.Proyecto" contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Ver detalles de la solicitud</title>
</head>

<body>
<elm:message tipo="${flash.tipo}" clase="${flash.clase}">${flash.message}</elm:message>

<div class="dialog" title="${title}">


        <div class="btn-toolbar toolbar">
           <div class="btn-group">

        <g:link class="btn btn-default button list" action="list">
            <i class="fa fa-list"></i> Lista de solicitudes
        </g:link>
        <g:link class="btn btn-default button create" action="ingreso">
            <i class="fa fa-file-o"></i> Nueva solicitud
        </g:link>
        <a href="#" id="btnPrint" class="btn btn-default button" style="float: right;">
            <i class="fa fa-print"></i> Imprimir</a>
            </div>
        </div>



    <div class="body">
        <g:if test="${flash.message}">
            <div class="message ui-state-highlight ui-corner-all">${flash.message}</div>
        </g:if>
          <table class="table table-condensed table-bordered table-striped">
            <thead>
            <tr class="info">
                <td style="font-weight: bold; text-align: center">
                    Detalles de la Solicitud
                </td>
            </tr>
            </thead>
            <tbody>
            <g:if test="${solicitud}">
                <tr class="warning">
                    <td colspan="4" style="font-size: larger; font-weight: bold;">
                        <g:if test="${vesta.contratacion.DetalleMontoSolicitud.countBySolicitud(solicitud) == 0}">
                            <div class="ui-widget-content ui-corner-all ui-state-error" style="padding: 10px 10px 10px 10px; ">
                                No ha detallado los montos anuales de la solicitud
                            </div>
                        </g:if>
                        <g:else>
                            <g:if test="${solicitud.incluirReunion == 'S'}">
                                <div style="padding: 10px 10px 5px 10px; ">
                                    Se incluirá en la próxima reunión de aprobación
                                </div>
                            </g:if>
                            <g:else>
                                <div style="padding: 10px 10px 5px 10px; ">
                                    No se incluirá en la próxima reunión de aprobación
                                </div>
                            </g:else>
                        </g:else>
                    </td>
                </tr>
                <tr class="info">
                    <td>
                        <slc:showSolicitud solicitud="${solicitud}" perfil="${session.perfil}"/>
                    </td>
                </tr>
            </g:if>
            </tbody>
            <tfoot>
            <tr>
                <td colspan="4" class="buttons" style="text-align: right;">
                    <g:if test="${solicitud.estado == 'P'}">
                        <g:if test="${session.perfil.codigo == 'RQ' || session.perfil.codigo == 'DRRQ'}">
                            <g:link class="button edit" action="ingreso" id="${solicitud?.id}">
                                Actualizar
                            </g:link>
                        </g:if>
                    </g:if>
                </td>
            </tr>
            </tfoot>
        </table>
    </div> <!-- body -->
</div> <!-- dialog -->

<script type="text/javascript">
    $(function () {
        $("#btnPrint").button("option", "icons", {primary : 'ui-icon-print'}).click(function () {
            var url = "${createLink(controller: 'reporteSolicitud', action: 'imprimirSolicitud')}/?id=${solicitud.id}";
//                    console.log(url);
            location.href = "${createLink(controller:'pdf',action:'pdfLink')}?url=" + url + "&filename=solicitud.pdf";
            return false;
        });

        $(".button").button();
        $(".home").button("option", "icons", {primary : 'ui-icon-home'});
        $(".list").button("option", "icons", {primary : 'ui-icon-clipboard'});
        $(".create").button("option", "icons", {primary : 'ui-icon-document'});

        $(".edit").button("option", "icons", {primary : 'ui-icon-pencil'});
        $(".revision").button("option", "icons", {primary : 'ui-icon-check'});
    });
</script>
</body>
</html>