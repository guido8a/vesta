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
        <g:hiddenField name="anio" value="${reforma.anioId}"/>
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

                <div class="col-md-2" id="divTotal">
                    <g:formatNumber number="${total}" type="currency"/>
                </div>

                <div class="col-md-1 show-label">
                    Fecha
                </div>

                <div class="col-md-2">
                    <g:formatDate date="${reforma.fecha}" format="dd-MM-yyyy"/>
                </div>
            </div>

            <g:if test="${detalles2.size() > 0}">
                <table class="table table-bordered table-hover table-condensed">
                    <thead>
                        <tr>
                            <th style="width: 100px;">Proyecto</th>
                            <th style="width: 100px;">Componente</th>
                            <th>Actividad</th>
                            <th>Asignación</th>
                            <th style="width: 80px;">Valor inicial</th>
                            <th style="width: 80px;">Disminución</th>
                            <th style="width: 80px;">Aumento</th>
                            <th style="width: 80px;">Valor final</th>
                            <th style="width: 100px;">Saldo</th>
                            <th style="width: 30px;"></th>
                        </tr>
                    </thead>
                    <tbody class="tb">
                        <g:set var="totalInicial" value="${0}"/>
                        <g:set var="totalAumento" value="${0}"/>
                        <g:set var="totalFinal" value="${0}"/>
                        <g:set var="totalSaldo" value="${0}"/>
                        <g:each in="${detalles2}" var="detalle">
                            <g:set var="totalInicial" value="${totalInicial + (detalle.asignacionDestino.priorizado)}"/>
                            <g:set var="totalAumento" value="${totalAumento + detalle.valor}"/>
                            <g:set var="totalFinal" value="${totalFinal + (detalle.asignacionDestino.priorizado + detalle.valor)}"/>
                            <g:set var="totalSaldo" value="${totalSaldo + detalle.saldo}"/>
                            <tr class="success"
                                data-id="${detalle.id}"
                                data-asd="${detalle.asignacionDestinoId}"
                                data-aso=""
                                data-monto="${detalle.valor}"
                                data-saldo="${detalle.saldo}"
                                data-ti="${detalle.asignacionDestino.priorizado}"
                                data-ta="${detalle.valor}"
                                data-td="${0}"
                                data-tf="${detalle.asignacionDestino.priorizado + detalle.valor}">
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
                                <g:if test="${reforma.tipoSolicitud == 'I'}">
                                    <td class="text-right">
                                        <g:formatNumber number="${detalle.saldo}" type="currency" currencySymbol=""/>
                                    </td>
                                    <td>
                                        <g:if test="${detalle.saldo > 0}">
                                            <a href="#" class="btn btn-xs btn-success btnSelect" title="Seleccionar asignación de origen" data-id="${detalle.id}">
                                                <i class="fa fa-pencil-square"></i>
                                            </a>
                                        </g:if>
                                    </td>
                                </g:if>
                            </tr>
                        </g:each>
                    </tbody>
                    <tfoot>
                        <tr>
                            <th class="text-right" colspan="4">TOTAL</th>
                            <th class="text-right" data-valor="${totalInicial}">
                                <g:formatNumber number="${totalInicial}" type="currency" currencySymbol=""/>
                            </th>
                            <th class="text-right">
                                <g:formatNumber number="${0}" type="currency" currencySymbol=""/>
                            </th>
                            <th class="text-right">
                                <g:formatNumber number="${totalAumento}" type="currency" currencySymbol=""/>
                            </th>
                            <th class="text-right" data-valor="${totalFinal}">
                                <g:formatNumber number="${totalFinal}" type="currency" currencySymbol=""/>
                            </th>
                            <th class="text-right" data-valor="${totalSaldo}">
                                <g:formatNumber number="${totalSaldo}" type="currency" currencySymbol=""/>
                            </th>
                            <th></th>
                        </tr>
                    </tfoot>
                </table>
            </g:if>

            <g:if test="${detalles.size() > 0}">
                <g:if test="${reforma.tipoSolicitud != 'P'}">
                    <table class="table table-bordered table-hover table-condensed">
                        <thead>
                            <tr>
                                <th style="width: 100px;">Proyecto</th>
                                <th style="width: 100px;">Componente</th>
                                <th>Actividad</th>
                                <th>Asignación</th>
                                <th style="width: 80px;">Valor inicial</th>
                                <th style="width: 80px;">Disminución</th>
                                <th style="width: 80px;">Aumento</th>
                                <th style="width: 80px;">Valor final</th>
                                <g:if test="${reforma.tipoSolicitud == 'I'}">
                                    <th style="width: 30px;"></th>
                                </g:if>
                            </tr>
                        </thead>
                        <tbody class="tb">
                            <g:set var="totalInicial" value="${0}"/>
                            <g:set var="totalDisminucion" value="${0}"/>
                            <g:set var="totalAumento" value="${0}"/>
                            <g:set var="totalFinal" value="${0}"/>
                            <g:each in="${detalles}" var="detalle">
                                <g:if test="${reforma.tipoSolicitud == 'E' || reforma.tipoSolicitud == 'I'}">
                                    <g:set var="totalInicial" value="${totalInicial + (detalle.asignacionOrigen.priorizado + detalle.asignacionDestino.priorizado)}"/>
                                    <g:set var="totalDisminucion" value="${totalDisminucion + detalle.valor}"/>
                                    <g:set var="totalAumento" value="${totalAumento + detalle.valor}"/>
                                    <g:set var="totalFinal" value="${totalFinal + ((detalle.asignacionOrigen.priorizado - detalle.valor) + (detalle.asignacionDestino.priorizado + detalle.valor))}"/>
                                </g:if>
                                <g:elseif test="${reforma.tipoSolicitud == 'A'}">
                                    <g:set var="totalInicial" value="${totalInicial + (detalle.asignacionOrigen.priorizado)}"/>
                                    <g:set var="totalDisminucion" value="${totalDisminucion + detalle.valor}"/>
                                    <g:set var="totalAumento" value="${totalAumento + detalle.valor}"/>
                                    <g:set var="totalFinal" value="${totalFinal + ((detalle.asignacionOrigen.priorizado - detalle.valor) + (detalle.valor))}"/>
                                </g:elseif>
                                <tr class="info"
                                    data-id="${detalle.id}"
                                    data-asd="${detalle.asignacionDestinoId}"
                                    data-aso="${detalle.asignacionOrigenId}"
                                    data-monto="${detalle.valor}"
                                    data-ti="${detalle.asignacionDestino.priorizado}"
                                    data-ta="${detalle.valor}"
                                    data-td="${0}"
                                    data-tf="${detalle.asignacionDestino.priorizado + detalle.valor}">
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
                                    <g:if test="${reforma.tipoSolicitud == 'I'}">
                                        <td rowspan="2" class="danger" style="vertical-align: middle;">
                                            <a href="#" class="btn btn-xs btn-danger btnDeleteDetalle" title="Eliminar detalle" data-id="${detalle.id}">
                                                <i class="fa fa-trash-o"></i>
                                            </a>
                                        </td>
                                    </g:if>
                                </tr>
                                <tr class="success"
                                    data-id="${detalle.id}"
                                    data-asd="${detalle.asignacionDestinoId}"
                                    data-aso="${detalle.asignacionOrigenId}"
                                    data-monto="${detalle.valor}"
                                    data-ti="${detalle.asignacionDestino.priorizado}"
                                    data-ta="${detalle.valor}"
                                    data-td="${0}"
                                    data-tf="${detalle.asignacionDestino.priorizado + detalle.valor}">
                                    <g:if test="${reforma.tipoSolicitud == 'E' || reforma.tipoSolicitud == 'I'}">
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
                                    %{--<g:if test="${reforma.tipoSolicitud == 'I'}">--}%
                                    %{--<td>--}%
                                    %{--<a href="#" class="btn btn-xs btn-danger btnDelete" title="Eliminar detalle" data-id="${detalle.id}">--}%
                                    %{--<i class="fa fa-trash-o"></i>--}%
                                    %{--</a>--}%
                                    %{--</td>--}%
                                    %{--</g:if>--}%
                                    </g:if>
                                    <g:elseif test="${reforma.tipoSolicitud == 'A'}">
                                        <td>
                                            ${detalle.componente.proyecto.toStringCompleto()}
                                        </td>
                                        <td>
                                            ${detalle.componente.toStringCompleto()}
                                        </td>
                                        <td>
                                            ${detalle.descripcionNuevaActividad}
                                        </td>
                                        <td>
                                            <strong>Responsable:</strong> ${reforma.persona.unidad}
                                            <strong>Priorizado:</strong> ${detalle.valor}
                                            <strong>Partida Presupuestaria:</strong> ${detalle.presupuesto}
                                            <strong>Año:</strong> ${reforma.anio.anio}
                                        </td>
                                        <td class="text-right">
                                            <g:formatNumber number="${0}" type="currency" currencySymbol=""/>
                                        </td>
                                        <td></td>
                                        <td class="text-right">
                                            <g:formatNumber number="${detalle.valor}" type="currency" currencySymbol=""/>
                                        </td>
                                        <td class="text-right">
                                            <g:formatNumber number="${detalle.valor}" type="currency" currencySymbol=""/>
                                        </td>
                                    </g:elseif>
                                </tr>
                            </g:each>
                        </tbody>
                        <tfoot>
                            <tr>
                                <th class="text-right" colspan="4">TOTAL</th>
                                <th class="text-right" id="totalInicial" data-valor="${totalInicial}">
                                    <g:formatNumber number="${totalInicial}" type="currency" currencySymbol=""/>
                                </th>
                                <th class="text-right" id="totalDism">
                                    <g:formatNumber number="${totalDisminucion}" type="currency" currencySymbol=""/>
                                </th>
                                <th class="text-right" id="totalAum">
                                    <g:formatNumber number="${totalAumento}" type="currency" currencySymbol=""/>
                                </th>
                                <th class="text-right" id="totalFinal" data-valor="${totalFinal}">
                                    <g:formatNumber number="${totalFinal}" type="currency" currencySymbol=""/>
                                </th>
                                <g:if test="${reforma.tipoSolicitud == 'I'}">
                                    <th colspan="2"></th>
                                </g:if>
                            </tr>
                        </tfoot>
                    </table>
                </g:if>
                <g:else>
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
                            <g:set var="valorFinal" value="${detalles.sum { it.valor }}"/>
                            <tr class="info">
                                <td>
                                    ${detalles.first().asignacionOrigen.marcoLogico.proyecto.toStringCompleto()}
                                </td>
                                <td>
                                    ${detalles.first().asignacionOrigen.marcoLogico.marcoLogico.toStringCompleto()}
                                </td>
                                <td>
                                    ${detalles.first().asignacionOrigen.marcoLogico.numero} - ${detalles.first().asignacionOrigen.marcoLogico.toStringCompleto()}
                                </td>
                                <td>
                                    ${detalles.first().asignacionOrigen}
                                </td>
                                <td class="text-right">
                                    <g:formatNumber number="${detalles.first().asignacionOrigen.priorizado}" type="currency" currencySymbol=""/>
                                </td>
                                <td class="text-right">
                                    <g:formatNumber number="${valorFinal}" type="currency" currencySymbol=""/>
                                </td>
                                <td></td>
                                <td class="text-right">
                                    <g:formatNumber number="${detalles.first().asignacionOrigen.priorizado - valorFinal}" type="currency" currencySymbol=""/>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                    <table class="table table-bordered table-hover table-condensed">
                        <thead>
                            <tr>
                                <th style="width: 300px;">Fuente</th>
                                <th>Partida</th>
                                <th style="width: 180px;">Monto</th>
                            </tr>
                        </thead>
                        <tbody>
                            <g:set var="total" value="${0}"/>
                            <g:each in="${detalles}" var="detalle">
                                <g:set var="total" value="${total + detalle.valor}"/>
                                <tr class="success">
                                    <td>
                                        ${detalle.fuente}
                                    </td>
                                    <td>
                                        ${detalle.presupuesto}
                                    </td>
                                    <td class="text-right">
                                        <g:formatNumber number="${detalle.valor}" type="currency" currencySymbol=""/>
                                    </td>
                                </tr>
                            </g:each>
                        </tbody>
                        <tfoot>
                            <tr>
                                <th colspan="2" class="text-right">TOTAL</th>
                                <th class="text-right">
                                    <g:formatNumber number="${total}" type="currency" currencySymbol=""/>
                                </th>
                            </tr>
                        </tfoot>
                    </table>
                </g:else>
            </g:if>
        </elm:container>

        <form id="frmFirmas">
            <elm:container tipo="horizontal" titulo="Datos para la generación del documento">
                <div class="row">
                    <div class="col-md-1 show-label">Observaciones</div>

                    <div class="col-md-11">
                        <g:textArea name="richText" value="${reforma.nota}"/>
                    </div>
                </div>
            </elm:container>

            <elm:container tipo="horizontal" titulo="Autorizaciones electrónicas">
                <div class="row">
                    <div class="col-md-3 grupo">
                        <g:if test="${reforma.estado.codigo == "D02"}">
                            ${reforma.firma1.usuario}
                        </g:if>
                        <g:else>
                            <g:select from="${personas}" optionKey="id" optionValue="${{
                                it.nombre + ' ' + it.apellido
                            }}" noSelection="['': '- Seleccione -']" name="firma1" class="form-control required input-sm"/>
                        </g:else>
                    </div>

                    <div class="col-md-3 grupo">
                        <g:if test="${reforma.estado.codigo == "D02"}">
                            ${reforma.firma2.usuario}
                        </g:if>
                        <g:else>
                            <g:select from="${gerentes}" optionKey="id" optionValue="${{
                                it.nombre + ' ' + it.apellido
                            }}" noSelection="['': '- Seleccione -']" name="firma2" class="form-control required input-sm"/>
                        </g:else>
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-12">
                        <a href="#" id="btnAprobar" class="btn btn-success ${reforma.tipoSolicitud == 'I' && totalSaldo > 0 ? 'disabled' : ''}">
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
                    %{--var i = 0;--}%
                    %{--<g:if test="${reforma.tipoSolicitud == 'I'}">--}%
                    %{--$("#tb").children().each(function () {--}%
                    %{--var $tr = $(this);--}%
                    %{--if ($tr.hasClass("info")) {--}%
                    %{--data["r" + i] = $tr.next().data("id") + "_" + $tr.data("aso");--}%
                    %{--i++;--}%
                    %{--}--}%
                    %{--});--}%
                    %{--</g:if>--}%
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
                    var ok = true;
                    %{--<g:if test="${reforma.tipoSolicitud == 'I'}">--}%
                    %{--var ti = parseFloat(number_format($("#totalInicial").data("valor"), 2, ".", ""));--}%
                    %{--var tf = parseFloat(number_format($("#totalFinal").data("valor"), 2, ".", ""));--}%
                    %{--if (ti != tf) {--}%
                    %{--bootbox.alert("Debe seleccionar las asignaciones de origen de tal manera que el total inicial sea igual al total final");--}%
                    %{--ok = false;--}%
                    %{--}--}%
                    %{--</g:if>--}%
                    if (ok) {
                        if ($("#frmFirmas").valid()) {
                            procesar(true);
                        }
                    }
                    return false;
                });
                $("#btnNegar").click(function () {
                    procesar(false);
                    return false;
                });

                <g:if test="${reforma.tipoSolicitud == 'I'}">
                function validarPar(dataOrigen, dataDestino) {
                    var ok = true;
                    if (dataOrigen.monto > dataOrigen.max) {
                        ok = false;
                        bootbox.alert("No puede seleccionar una asignación cuyo máximo es menor que el valor de la asignación de destino");
                    }
                    if (ok) {
                        $(".tb").children().each(function () {
                            var d = $(this).data();
                            if (ok) {
                                if (d.aso == dataOrigen.asignacion_id && d.asd == dataDestino.asignacion_id) {
                                    ok = false;
                                    bootbox.alert("No puede seleccionar un par de asignaciones ya ingresados");
                                } else {
                                    console.log(d.aso, dataDestino.asignacion_id, d.asd, dataOrigen.asignacion_id, d.aso == dataDestino.asignacion_id, d.asd == dataOrigen.asignacion_id, d.aso == dataDestino.asignacion_id || d.asd == dataOrigen.asignacion_id)
                                    if (d.aso == dataDestino.asignacion_id || d.asd == dataOrigen.asignacion_id) {
                                        ok = false;
                                        bootbox.alert("No puede seleccionar una asignación de origen que está listada como destino");
                                    }
                                }
                            }
                        });
                    }
                    return ok;
                }

                $(".btnDeleteDetalle").click(function () {
                    var id = $(this).data("id");
                    bootbox.confirm("<i class='fa fa-trash-o fa-3x text-danger'></i> ¿Está seguro de querer eliminar este detalle?", function (res) {
                        if (res) {
                            openLoader();
                            $.ajax({
                                type    : "POST",
                                url     : "${createLink(action:'eliminarParAsignaciones_ajax')}",
                                data    : {
                                    id : id
                                },
                                success : function (msg) {
                                    var parts = msg.split("*");
                                    log(parts[1], parts[0]);
                                    if (parts[0] == "SUCCESS") {
                                        setTimeout(function () {
                                            location.reload(true);
                                        }, 1000);
                                    } else {
                                        closeLoader()
                                    }
                                }
                            });
                        }
                    });
                    return false;
                });

                $(".btnSelect").click(function () {
                    var $btn = $(this);
                    var $tr = $btn.parents("tr");
                    $.ajax({
                        type    : "POST",
                        url     : "${createLink(action:'asignarOrigen_ajax')}",
                        data    : {
                            id  : "${reforma.id}",
                            det : $btn.data("id")
                        },
                        success : function (msg) {
                            var b = bootbox.dialog({
                                id      : "dlgCreateEdit",
                                title   : "Asignación de origen",
                                class   : "modal-lg",
                                message : msg,
                                buttons : {
                                    cancelar : {
                                        label     : "Cancelar",
                                        className : "btn-primary",
                                        callback  : function () {
                                        }
                                    },
                                    guardar  : {
                                        id        : "btnSave",
                                        label     : "<i class='fa fa-save'></i> Guardar",
                                        className : "btn-success",
                                        callback  : function () {
                                            if ($("#frmReforma").valid()) {
                                                var dataDestino = {
                                                    asignacion_id : $tr.data("asignacion")
                                                };
                                                var dataOrigen = {
                                                    monto : $tr.data("saldo")
                                                };
                                                dataOrigen.proyecto_nombre = $("#proyecto").find("option:selected").text();
                                                dataOrigen.componente_nombre = $("#comp").find("option:selected").text();
                                                dataOrigen.actividad_nombre = $("#actividad").find("option:selected").text();
                                                dataOrigen.asignacion_nombre = $("#asignacion").find("option:selected").text();
                                                dataOrigen.asignacion_id = $("#asignacion").val();
                                                dataOrigen.inicial = $("#asignacion").find("option:selected").attr("class");
                                                dataOrigen.max = $("#max").data("max");
                                                if (validarPar(dataOrigen, dataDestino)) {
                                                    openLoader();
                                                    $.ajax({
                                                        type    : "POST",
                                                        url     : "${createLink(action:'asignarParAsignaciones_ajax')}",
                                                        data    : {
                                                            det : $btn.data("id"),
                                                            asg : $("#asignacion").val(),
                                                            mnt : $("#monto").val()
                                                        },
                                                        success : function (msg) {
                                                            var parts = msg.split("*");
                                                            log(parts[1], parts[0]);
                                                            if (parts[0] == "SUCCESS") {
                                                                setTimeout(function () {
                                                                    location.reload(true);
                                                                }, 1000);
                                                            } else {
                                                                closeLoader()
                                                            }
                                                        }
                                                    });
                                                }
                                            }
                                            return false;
                                        } //callback
                                    } //guardar
                                } //buttons
                            }); //dialog
                            setTimeout(function () {
                                b.find(".form-control").first().focus()
                            }, 500);
                        } //success
                    }); //ajax
                    return false;
                });
                </g:if>
            });
        </script>

    </body>
</html>