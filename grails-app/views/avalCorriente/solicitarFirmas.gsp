<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 26/06/15
  Time: 12:58 PM
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <meta name="layout" content="main"/>
        <title>Solicitar firmas de aval permanente</title>

        <script type="text/javascript" src="${resource(dir: 'js/plugins/ckeditor-4.4.6', file: 'ckeditor.js')}"></script>
        <script type="text/javascript" src="${resource(dir: 'js/plugins/ckeditor-4.4.6', file: 'adapters/jquery.js')}"></script>

        <style type="text/css">
        .horizontal-container {
            border-bottom : none;
        }

        .table {
            margin-top : 15px;
        }

        </style>
    </head>

    <body>
        <div class="btn-toolbar toolbar">
            <div class="btn-group">
                <g:link controller="avalCorriente" action="pendientes" class="btn btn-default">
                    <i class="fa fa-chevron-left"></i> Regresar
                </g:link>
            </div>
        </div>

        <g:if test="${proceso.firma1 && proceso.estado.codigo != 'D03'}">
            <div class="alert alert-danger">
                <i class="fa fa-exclamation-triangle fa-2x"></i> Ya ha solicitado la firma para esta solicitud, no puede hacerlo nuevamente
            </div>
        </g:if>
        <g:else>
            <g:if test="${proceso.estado.codigo == "D03"}">
                <div class="alert alert-warning">
                    <g:if test="${proceso.firma1.observaciones && proceso.firma1.observaciones != '' && proceso.firma1.observaciones != 'S'}">
                        <h4>Devuelto por ${proceso.firma1.usuario}</h4>
                        ${proceso.firma1.observaciones}
                    </g:if>
                    <g:if test="${proceso.firma2.observaciones && proceso.firma2.observaciones != '' && proceso.firma2.observaciones != 'S'}">
                        <h4>Devuelto por ${proceso.firma2.usuario}</h4>
                        ${proceso.firma2.observaciones}
                    </g:if>
                </div>
            </g:if>

            <elm:container tipo="horizontal" titulo="Solicitud a aprobar - Gasto Permanente">
                <table class="table table-condensed table-bordered">
                    <thead>
                        <tr>
                            <th>Proceso</th>
                            <th>Concepto</th>
                            <th>Monto</th>
                            <th>Estado</th>
                            <th>Doc. Respaldo</th>
                            <th>Solicitud</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>${proceso.nombreProceso}</td>
                            <td>${proceso.concepto}</td>
                            <td class="text-right">
                                <g:formatNumber number="${proceso.monto}" type="currency" currencySymbol=""/>
                            </td>
                            <td>${proceso.estado?.descripcion}</td>
                            <td style="text-align: center">
                                <g:if test="${proceso.path}">
                                    <a href="#" class="btn btn-default btn-sm descRespaldo" title="Ver" iden="${proceso.id}">
                                        <i class="fa fa-search"></i>
                                    </a>
                                </g:if>
                                <g:else>
                                </g:else>
                            </td>
                            <td style="text-align: center">
                                <a href="#" class="btn btn-default btn-sm imprimirSolicitud " iden="${proceso.id}">
                                    <i class="fa fa-print"></i>
                                </a>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </elm:container>


            <elm:container tipo="horizontal" titulo="Detalle informativo de las asignaciones del Aval" style="margin-top: -20px; width: 80%">
            %{--<h3>Detalle de asignaciones del Aval</h3>--}%
                <table class="table table-condensed table-bordered">
                    <thead>
                    <tr>
                        <th># Partida</th>
                        <th>Partida</th>
                        <th>Fuente</th>
                        <th>Asignado</th>
                        <th>Solicitado</th>
                        <th>Avalado</th>
                        <th>Saldo</th>
                        <th>Disponible</th>
                    </tr>
                    </thead>
                    <tbody>
                        <g:each in="${poas}" var="asig">
                            <tr>
                            <td>${asig?.numero}</td>
                            <td>${asig?.partida}</td>
                            <td>${asig?.fuente}</td>
                            <td class="text-right"><g:formatNumber number="${asig?.priorizado.toDouble()}" format="###,##0" minFractionDigits="2" maxFractionDigits="2"/></td>
                            <td class="text-right"><g:formatNumber number="${asig?.solicitado.toDouble()}" format="###,##0" minFractionDigits="2" maxFractionDigits="2"/></td>
                            <td class="text-right"><g:formatNumber number="${asig?.avalado.toDouble()}" format="###,##0" minFractionDigits="2" maxFractionDigits="2"/></td>
                            <td class="text-right"><g:formatNumber number="${asig?.saldo.toDouble()}" format="###,##0" minFractionDigits="2" maxFractionDigits="2"/></td>
                            <td class="text-right"><g:formatNumber number="${(asig?.saldo - asig.solicitado).toDouble()}" format="###,##0" minFractionDigits="2" maxFractionDigits="2"/></td>
                            </tr>
                        </g:each>
                    </tbody>
                </table>
            </elm:container>


            <elm:container tipo="horizontal" titulo="Datos para la generación del documento">
                <g:set var="val" value='El aval se otorga en base al Oficio Nro. MINFIN-SRF-2014-0512 de 08 de diciembre
                 de 2014, el Ministerio de Finanzas informa que el monto asignado a la Empresa Pública Yachay E .P.,
                 dentro del Presupuesto General del Estado 2015, en la partida "Trasferencia desde Gobierno Central",
                 asciende a un monto de USD9.543.697,00 para recursos fiscales permanentes y de
                 USD.76.000.000,00 para recursos fiscales no permanentes; con Memorando Nro.YACHAY-GAF-2014-0015 de 24
                 de diciembre de 2014, la Gerencia Administrativa Financiera remitió al Gerente General el POA de gasto
                 permanente para su aprobación; con Acta Nro.009-2014-DIR-YACHAY-EP y Resolución Nro.YACHAY.EP-GG-2014-0037
                 de 29 de diciembre de 2014, los miembros del Directorio aprueban la asignación presupuestaria de gasto
                 permanente por el mon to de USD9’543.697,00 y el Gerente General, aprobó el Plan Operativo Anual (POA)
                 de gasto permanente de la Empresa Pública Yachay EP para el ejercicio fiscal 2015.'/>
                <g:if test="${proceso.observacionesPdf && proceso.observacionesPdf.trim() != ''}">
                    <g:set var="val" value="${proceso.observacionesPdf}"/>
                </g:if>

                <div class="row" style="width: 100%">
                    <div class="col-md-1 show-label">Número:</div>

                    <div class="col-md-3">
                        ${proceso.fechaSolicitud.format("yyyy")}-GP No. ${proceso.numeroSolicitud.toString().padLeft(3, '0')}
                    </div>

                    <span class="col-md-8">
                        <a href="#" class="btn btn-success" id="guardarDatosDoc" style="float:right">
                                <i class="fa fa-save"></i> Guardar texto
                        </a>
                    </span>

                </div>

                <div class="row">
                    <div class="col-md-1 show-label">Observaciones:</div>

                    <div class="col-md-11">
                        <g:textArea name="richText" value="${val}"/>
                    </div>
                </div>

            </elm:container>

            <elm:container tipo="horizontal" titulo="Autorizaciones electrónicas">
                <form id="frmFirmas">
                    <div class="row">
                        <div class="col-md-3 grupo">
                            <g:if test="${proceso.estado.codigo == "D03"}">
                                ${proceso.firma1.usuario}
                            </g:if>
                            <g:else>
                                <g:select from="${personas}" optionKey="id" optionValue="${{
                                    it.nombre + ' ' + it.apellido
                                }}" noSelection="['': '- Seleccione -']" name="firma2" class="form-control required input-sm"/>
                            </g:else>
                        </div>

                        <div class="col-md-3 grupo">
                            <g:if test="${proceso.estado.codigo == "D03"}">
                                ${proceso.firma2.usuario}
                            </g:if>
                            <g:else>
                                <g:select from="${personasGerente}" optionKey="id" optionValue="${{
                                    it.nombre + ' ' + it.apellido
                                }}" noSelection="['': '- Seleccione -']" name="firma3" class="form-control required input-sm"/>
                            </g:else>
                        </div>
                    </div>
                </form>
            </elm:container>

            <div class="row">
                <div class="col-md-5">
                    <div class="btn-group" role="group" aria-label="...">
                        <a href="#" class="btn btn-default" id="btnPreview" title="Previsualizar">
                            <i class="fa fa-search"></i> Previsualizar
                        </a>
                        <a href="#" class="btn btn-success" id="btnSolicitar" title="Aprobar y solicitar firmas">
                            <i class="fa fa-pencil"></i> Solicitar firmas
                        </a>
                        <a href="#" class="btn btn-danger" id="btnNegar" title="Negar definitivamente el aval">
                            <i class="fa fa-thumbs-down"></i> Negar
                        </a>
                    </div>
                </div>
            </div>

            <script type="text/javascript">
                $(function () {

                    $("#frmFirmas").validate({
                        errorClass     : "help-block",
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

                    $('#richText').ckeditor(function () { /* callback code */
                            },
                            {
                                customConfig : '${resource(dir: 'js/plugins/ckeditor-4.4.6', file: 'config_bullets_only.js')}'
                            });

                    $("#btnPreview").click(function () {
                        var url = "${createLink(controller: 'reporteSolicitud', action: 'avalCorriente')}/?id=${proceso.id}";
                        location.href = "${createLink(controller:'pdf',action:'pdfLink')}?url=" + url + "&filename=aval_permanente.pdf";
                        return false;
                    });

                    $("#btnSolicitar").click(function () {
                        if ($("#frmFirmas").valid()) {
                            bootbox.confirm(
                                    "<div class='alert alert-danger'>¿Está seguro? Una vez solicitada la firma no podrá modificar el documento</div>",
                                    function (res) {
                                        if (res) {
                                            openLoader("Solicitando");
                                            var aval = $("#numero").val();
                                            var obs = $("#richText").val();
                                            $.ajax({
                                                type    : "POST",
                                                url     : "${createLink(controller: 'avalCorriente', action:'solicitarFirmas_ajax')}",
                                                data    : {
                                                    id     : "${proceso.id}",
                                                    aval   : aval,
                                                    obs    : obs,
                                                    firma2 : $("#firma2").val(),
                                                    firma3 : $("#firma3").val(),
                                                    enviar : "true"
                                                },
                                                success : function (msg) {
                                                    var parts = msg.split("*");
                                                    log(parts[1], parts[0]); // log(msg, type, title, hide)
                                                    if (parts[0] == "SUCCESS") {
                                                        setTimeout(function () {
                                                            location.href = "${createLink(action: 'pendientes')}";
                                                        }, 1000);
                                                    } else {
                                                        closeLoader();
                                                    }
                                                }
                                            });
                                        }
                                    });
                        }
                        return false;
                    });

                    $("#btnNegar").click(function () {
                        bootbox.confirm(
                                "<div class='alert alert-danger'>¿Está seguro de querer negar este aval?</div>",
                                function (res) {
                                    if (res) {
                                        openLoader("Negando");
                                        var aval = $("#numero").val();
                                        var obs = $("#richText").val();
                                        $.ajax({
                                            type    : "POST",
                                            url     : "${createLink(controller: 'avalCorriente', action:'negarAval_ajax')}",
                                            data    : {
                                                id   : "${proceso.id}",
                                                aval : aval,
                                                obs  : obs
                                            },
                                            success : function (msg) {
                                                var parts = msg.split("*");
                                                log(parts[1], parts[0]); // log(msg, type, title, hide)
                                                if (parts[0] == "SUCCESS") {
                                                    setTimeout(function () {
                                                        location.href = "${createLink(action: 'pendientes')}";
                                                    }, 1000);
                                                } else {
                                                    closeLoader();
                                                }
                                            }
                                        });
                                    }
                                });
                        return false;
                    });

                    $("#guardarDatosDoc").click(function () {
                        var aval = $("#numero").val();
                        var obs = $("#richText").val();
                        $.ajax({
                            type    : "POST",
                            url     : "${createLink(controller: 'avalCorriente',action:'solicitarFirmas_ajax')}",
                            data    : {
                                id     : "${proceso.id}",
                                aval   : aval,
                                obs    : obs,
                                firma2 : $("#firma2").val(),
                                firma3 : $("#firma3").val()
                            },
                            success : function (msg) {
                                var parts = msg.split("*");
                                log(parts[1], parts[0] == "SUCCESS" ? "success" : "error"); // log(msg, type, title, hide)
                            }
                        });
                        return false;
                    });

                    $(".imprimirSolicitud").click(function () {
                        var url = "${g.createLink(controller: 'reporteSolicitud',action: 'solicitudAvalCorriente')}/?id=" + $(this).attr("iden");
                        location.href = "${createLink(controller:'pdf',action:'pdfLink')}?url=" + url + "&filename=solicitud_aval_permanente.pdf";
                        return false;
                    });

                    $(".descRespaldo").click(function () {
                        var id = $(this).attr("iden");
                        $.ajax({
                            type    : "POST",
                            url     : "${createLink(controller: 'avales', action: 'validarSolicitud_ajax')}",
                            data    : {
                                id : id
                            },
                            success : function (msg) {
                                var parts = msg.split("*");
                                if (parts[0] == "SUCCESS") {
                                    location.href = "${createLink(controller:'avales',action:'descargaSolicitud')}/" + $(this).attr("iden");
                                } else {
                                    log(parts[1], parts[0] == "SUCCESS" ? "success" : "error"); // log(msg, type, title, hide)
                                }
                            }
                        });
                        return false;
                    });
                });
            </script>
        </g:else>
    </body>
</html>