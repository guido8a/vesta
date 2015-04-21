<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 21/04/15
  Time: 12:30 PM
--%>

<%@ page import="vesta.parametros.poaPac.Anio" contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <meta name="layout" content="main">
        <title>Procesar solicitud de reforma</title>

        <script type="text/javascript" src="${resource(dir: 'js/plugins/ckeditor-4.4.6', file: 'ckeditor.js')}"></script>
        <script type="text/javascript" src="${resource(dir: 'js/plugins/ckeditor-4.4.6', file: 'adapters/jquery.js')}"></script>

        <style type="text/css">
        .horizontal-container {
            border-bottom : none;
        }
        </style>
    </head>

    <body>

        <div class="btn-toolbar toolbar">
            <div class="btn-group">
                <g:link action="pendientes" class="btn btn-default">
                    <i class="fa fa-chevron-left"></i> Regresar
                </g:link>
            </div>
        </div>

        <g:if test="${reforma && reforma.estado.codigo == "D02"}">
            <div class="alert alert-warning">
                <g:if test="${reforma.firma1.observaciones && reforma.firma1.observaciones != '' && reforma.firma1.observaciones != 'S'}">
                    <h4>Observaciones de ${reforma.firma1.usuario}</h4>
                    ${reforma.firma1.observaciones}
                </g:if>
                <g:if test="${reforma.firma2.observaciones && reforma.firma2.observaciones != '' && reforma.firma2.observaciones != 'S'}">
                    <h4>Observaciones de ${reforma.firma2.usuario}</h4>
                    ${reforma.firma2.observaciones}
                </g:if>
            </div>
        </g:if>

        <elm:container tipo="horizontal" titulo="Solicitud de reforma a procesar">
            <div class="row">
                <div class="col-md-1 show-label">
                    POA Año
                </div>

                <div class="col-md-1">
                    ${reforma.anio.anio}
                </div>

                <div class="col-md-1 show-label">
                    Total
                </div>

                <div class="col-md-2">
                    <g:formatNumber number="${total}" type="currency"/>
                </div>

                <div class="col-md-1 show-label">
                    Fecha
                </div>

                <div class="col-md-2">
                    <g:formatDate date="${reforma.fecha}" format="dd-MM-yyyy"/>
                </div>
            </div>

            <table class="table table-bordered table-hover table-condensed">
                <thead>
                    <tr>
                        <th>Proyecto</th>
                        <th>Componente</th>
                        <th>Actividad</th>
                        <th>Asignación</th>
                        <th>Valor inicial</th>
                        <th>Disminución</th>
                        <th>Aumento</th>
                        <th>Valor final</th>
                    </tr>
                </thead>
                <tbody>
                    <g:set var="totalInicial" value="${0}"/>
                    <g:set var="totalDisminucion" value="${0}"/>
                    <g:set var="totalAumento" value="${0}"/>
                    <g:set var="totalFinal" value="${0}"/>
                    <g:each in="${detalles}" var="detalle">
                        <g:set var="totalInicial" value="${totalInicial + (detalle.asignacionOrigen.priorizado + detalle.asignacionDestino.priorizado)}"/>
                        <g:set var="totalDisminucion" value="${totalDisminucion + detalle.valor}"/>
                        <g:set var="totalAumento" value="${totalAumento + detalle.valor}"/>
                        <g:set var="totalFinal" value="${totalFinal + ((detalle.asignacionOrigen.priorizado - detalle.valor) + (detalle.asignacionDestino.priorizado + detalle.valor))}"/>
                        <tr class="info">
                            <td>
                                ${detalle.asignacionOrigen.marcoLogico.proyecto.toStringCompleto()}
                            </td>
                            <td>
                                ${detalle.asignacionOrigen.marcoLogico.marcoLogico.toStringCompleto()}
                            </td>
                            <td>
                                ${detalle.asignacionOrigen.marcoLogico.numero} - ${detalle.asignacionOrigen.marcoLogico.toStringCompleto()}
                            </td>
                            <td>
                                ${detalle.asignacionOrigen}
                            </td>
                            <td class="text-right">
                                <g:formatNumber number="${detalle.asignacionOrigen.priorizado}" type="currency" currencySymbol=""/>
                            </td>
                            <td class="text-right">
                                <g:formatNumber number="${detalle.valor}" type="currency" currencySymbol=""/>
                            </td>
                            <td></td>
                            <td class="text-right">
                                <g:formatNumber number="${detalle.asignacionOrigen.priorizado - detalle.valor}" type="currency" currencySymbol=""/>
                            </td>
                        </tr>
                        <tr class="success">
                            <td>
                                ${detalle.asignacionDestino.marcoLogico.proyecto.toStringCompleto()}
                            </td>
                            <td>
                                ${detalle.asignacionDestino.marcoLogico.marcoLogico.toStringCompleto()}
                            </td>
                            <td>
                                ${detalle.asignacionDestino.marcoLogico.numero} - ${detalle.asignacionDestino.marcoLogico.toStringCompleto()}
                            </td>
                            <td>
                                ${detalle.asignacionDestino}
                            </td>
                            <td class="text-right">
                                <g:formatNumber number="${detalle.asignacionDestino.priorizado}" type="currency" currencySymbol=""/>
                            </td>
                            <td></td>
                            <td class="text-right">
                                <g:formatNumber number="${detalle.valor}" type="currency" currencySymbol=""/>
                            </td>
                            <td class="text-right">
                                <g:formatNumber number="${detalle.asignacionDestino.priorizado + detalle.valor}" type="currency" currencySymbol=""/>
                            </td>
                        </tr>
                    </g:each>
                </tbody>
                <tfoot>
                    <tr>
                        <th class="text-right" colspan="4">TOTAL</th>
                        <th class="text-right">
                            <g:formatNumber number="${totalInicial}" type="currency" currencySymbol=""/>
                        </th>
                        <th class="text-right">
                            <g:formatNumber number="${totalDisminucion}" type="currency" currencySymbol=""/>
                        </th>
                        <th class="text-right">
                            <g:formatNumber number="${totalAumento}" type="currency" currencySymbol=""/>
                        </th>
                        <th class="text-right">
                            <g:formatNumber number="${totalFinal}" type="currency" currencySymbol=""/>
                        </th>
                    </tr>
                </tfoot>
            </table>
        </elm:container>

        <form id="frmFirmas">
            <elm:container tipo="horizontal" titulo="Datos para la generación del documento">
                <div class="row">
                    <div class="col-md-1 show-label">Observaciones</div>

                    <div class="col-md-11">
                        <g:textArea name="richText" value=""/>
                    </div>
                </div>
            </elm:container>

            <elm:container tipo="horizontal" titulo="Autorizaciones electrónicas">
                <div class="row">
                    <div class="col-md-3">
                        <g:select from="${personas}" optionKey="id" optionValue="${{
                            it.nombre + ' ' + it.apellido
                        }}" noSelection="['': '- Seleccione -']" name="firma1" class="form-control required input-sm"/>
                    </div>

                    <div class="col-md-3">

                        <g:select from="${gerentes}" optionKey="id" optionValue="${{
                            it.nombre + ' ' + it.apellido
                        }}" noSelection="['': '- Seleccione -']" name="firma2" class="form-control required input-sm"/>
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-12">
                        <a href="#" id="btnAprobar" class="btn btn-success">
                            <i class="fa fa-thumbs-up"></i> Aprobar
                        </a>
                        <a href="#" id="btnNegar" class="btn btn-danger">
                            <i class="fa fa-thumbs-down"></i> Negar
                        </a>
                    </div>
                </div>
            </elm:container>
        </form>

        <script type="text/javascript">

            function procesar(aprobado) {
                var url = "${createLink(action:'aprobar')}";
                var str = "Aprobando";
                var str2 = "aprobar";
                var clase = "success";
                var data = {
                    id : "${reforma.id}"
                };
                if (!aprobado) {
                    url = "${createLink(action:'negar')}";
                    str = "Negando";
                    str2 = "negar";
                    clase = "danger";
                } else {
                    data.firma1 = $("#firma1").val();
                    data.firma2 = $("#firma2").val();
                    data.observaciones = $("#richText").val();
                }
                bootbox.confirm("¿Está seguro de querer <strong class='text-" + clase + "'>" + str2 + "</strong> esta solicitud de reforma?<br/>Esta acción no puede revertirse.",
                        function (res) {
                            if (res) {
                                openLoader(str);
                                $.ajax({
                                    type    : "POST",
                                    url     : url,
                                    data    : data,
                                    success : function (msg) {
                                        var parts = msg.split("*");
                                        log(parts[1], parts[0]);
                                        if (parts[0] == "SUCCESS") {
                                            location.href = "${createLink(action:'pendientes')}";
                                        }
                                    }
                                });
                            }
                        });
            }

            $(function () {
                $('#richText').ckeditor(function () { /* callback code */
                        },
                        {
                            customConfig : '${resource(dir: 'js/plugins/ckeditor-4.4.6', file: 'config_bullets_only.js')}'
                        });
                $("#frmFirmas").validate({
                    errorClass     : "help-block",
                    onfocusout     : false,
                    errorPlacement : function (error, element) {
                        if (element.parent().hasClass("input-group")) {
                            error.insertAfter(element.parent());
                        } else {
                            error.insertAfter(element);
                        }
                        element.parents(".grupo").addClass('has-error');
                    },
                    success        : function (label) {
                        label.parents(".grupo").removeClass('has-error');
                        label.remove();
                    }
                });
                $("#btnAprobar").click(function () {
                    if ($("#frmFirmas").valid()) {
                        procesar(true);
                    }
                    return false;
                });
                $("#btnNegar").click(function () {
                    procesar(false);
                    return false;
                });
            });
        </script>

    </body>
</html>