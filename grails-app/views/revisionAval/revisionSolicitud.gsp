<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 19/05/15
  Time: 01:11 PM
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <meta name="layout" content="main"/>
        <title>Revisar solicitud de${solicitud.tipo == "A" ? " anulación de" : ""} aval</title>
    </head>

    <body>

        <h1>Revisar solicitud de${solicitud.tipo == "A" ? " anulación de" : ""}  aval</h1>

        <g:if test="${solicitud.estado.codigo == 'D02' && solicitud.firma.observaciones && solicitud.firma.observaciones != '' && solicitud.firma.observaciones != 'S'}">
            <elm:message tipo="warning"><strong>Devuelto por ${solicitud.firma.usuario}</strong>: ${solicitud.firma.observaciones}</elm:message>
        </g:if>

        <table class="table table-bordered table-condensed">
            <tr>
                <th style="width: 200px">
                    UNIDAD REQUIRENTE
                </th>
                <td>
                    ${solicitud.usuario.unidad}
                </td>
            </tr>
            <tr>
                <th>
                    PROYECTO
                </th>
                <td>
                    ${solicitud.proceso.proyecto.nombre}
                </td>
            </tr>
            <tr>
                <th>
                    NOMBRE PROCESO
                </th>
                <td>
                    ${solicitud.proceso.nombre}
                </td>
            </tr>
            <tr>
                <th>
                    JUSTIFICACIÓN
                </th>
                <td>
                    ${solicitud.concepto}
                </td>
            </tr>
            <tr>
                <th>
                    FECHA DE INICIO
                </th>
                <td>
                    ${solicitud?.proceso?.fechaInicio?.format("dd-MM-yyyy")}
                </td>
            </tr>
            <tr>
                <th>
                    FECHA DE FIN
                </th>
                <td>
                    ${solicitud?.proceso?.fechaFin?.format("dd-MM-yyyy")}
                </td>
            </tr>
            <tr>
                <th>
                    MONTO TOTAL SOLICITADO
                </th>
                <td>
                    <g:formatNumber number="${solicitud.monto + devengado}" type="currency" currencySymbol="USD "/>
                </td>
            </tr>
        </table>

        <g:each in="${arr}" var="primero">

            <table class="table table-bordered table-condensed">
                <tr>
                    <td style="width:200px; font-weight: bold">COMPONENTE</td>
                    <td>${primero?.key?.marcoLogico}</td>
                </tr>
                <tr>
                    <td style="font-weight: bold">ACTIVIDAD</td>
                    <td>${anio} - ${primero?.key?.numero} - ${primero?.key?.objeto}</td>
                </tr>
                <tr>
                    <td style="font-weight: bold">CÓDIGO</td>
                    <td>
                        ${primero?.key?.marcoLogico?.proyecto?.codigoEsigef} ${primero?.key?.marcoLogico?.numeroComp} ${primero?.key.numero}
                    </td>
                </tr>
                <tr>
                    <td style="font-weight: bold">SUBTOTAL</td>
                    <td>
                        <g:formatNumber number="${primero.value.total}" type="currency" currencySymbol="USD "/>
                    </td>
                </tr>
                <tr>
                    <td style="font-weight: bold">EJERCICIO ANTERIOR</td>
                    <td>
                        <g:formatNumber number="${primero.value.devengado}" type="currency" currencySymbol="USD "/>
                    </td>
                </tr>

                <g:set var="total" value="${0}"/>

                <g:each in="${primero.value}" var="segundo">
                    <g:if test="${segundo.key.size() == 4}">
                        <g:set var="total2" value="${0}"/>
                        <tr>
                            <td style="font-weight: bold">
                                MONTO DE AVAL ${segundo.key}
                            </td>
                            <td>
                                <table class="tbl2">
                                    <g:each in="${segundo.value.asignaciones}" var="tercero">
                                        <tr>
                                            <td>
                                                <strong>
                                                    Fuente ${tercero.asignacion?.fuente?.codigo},
                                                    Partida ${tercero.asignacion.presupuesto.numero}
                                                </strong>
                                            </td>
                                            <td style="text-align: right;">
                                                <g:formatNumber number="${tercero.monto ?: 0}" type="currency" currencySymbol="USD "/>
                                            </td>
                                        </tr>
                                    </g:each>
                                    <tr>
                                        <td><strong>Total</strong></td>
                                        <td style="text-align: right; font-weight: bold">
                                            <g:formatNumber number="${segundo.value.total}" type="currency" currencySymbol="USD "/>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </g:if>
                </g:each>
            </table>
        </g:each>

        <form id="frmFirmas">
            <div class="row">
                <div class="col-md-2 show-label">Autorización electrónica</div>

                <div class="col-md-3 grupo">
                    <g:if test="${solicitud.estado.codigo == 'D02'}">
                        <p class="static-control">
                            ${solicitud.firma.usuario}
                        </p>
                    </g:if>
                    <g:else>
                        <g:select from="${gerentes}" optionKey="id" optionValue="${{
                            it.nombre + ' ' + it.apellido
                        }}" noSelection="['': '- Seleccione -']" name="firma" class="form-control required input-sm"/>
                    </g:else>
                </div>
            </div>
        </form>

        <div class="row">
            <div class="col-md-5">
                <div class="btn-group" role="group" aria-label="...">
                    <a href="#" class="btn btn-default" id="btnPreview" title="Previsualizar">
                        <i class="fa fa-search"></i> Previsualizar
                    </a>
                    <a href="#" class="btn btn-success" id="btnSolicitar" title="Solicitar firma del gerente">
                        <i class="fa fa-pencil"></i> Solicitar firma
                    </a>
                    <a href="#" class="btn btn-danger" id="btnDevolver" title="Devolver al requirente con observaciones">
                        <i class="fa fa-thumbs-down"></i> Devolver al requirente
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

                $("#btnPreview").click(function () {
                    var url = "${g.createLink(controller: 'reporteSolicitud',action: 'imprimirSolicitudAval')}/${solicitud.id}";
                    location.href = "${createLink(controller:'pdf',action:'pdfLink')}?url=" + url + "&filename=Solicitud.pdf"
                    return false;
                });

                $("#btnSolicitar").click(function () {
                    if ($("#frmFirmas").valid()) {
                        var $msg = $("<div>");
                        var $form = $("<form class='form-horizontal'>");

                        var $r2 = $("<div class='form-group'\"'>");
                        $r2.append("<label class='col-sm-4 control-label' for='obs'>Autorización</label>");
                        var $auth = $("<input type='password' class='form-control required'/>");
                        var auth = $("<div class='col-sm-8 grupo'>");
                        var authGrp = $("<div class='input-group'>");
                        authGrp.append($auth);
                        authGrp.append("<span class='input-group-addon'><i class='fa fa-unlock-alt'></i></span>");
                        auth.append(authGrp);
                        $r2.append(auth);
                        $form.append($r2);

                        $msg.append($form);

                        $form.validate({
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

                        bootbox.dialog({
                            title   : "Solicitar firma",
                            message : $msg,
                            class   : "modal-sm",
                            buttons : {
                                devolver : {
                                    label     : "<i class='fa fa-pencil'></i> Solicitar firma",
                                    className : "btn-success",
                                    callback  : function () {
                                        if ($form.valid()) {
                                            openLoader("Solicitando");
                                            $.ajax({
                                                type    : "POST",
                                                url     : "${createLink(action: 'enviarAGerente_ajax')}",
                                                data    : {
                                                    id    : "${solicitud.id}",
                                                    firma : $("#firma").val(),
                                                    auth  : $auth.val()
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
                                                },
                                                error   : function () {
                                                    log("Ha ocurrido un error interno", "error");
                                                    closeLoader();
                                                }
                                            });
                                        }
                                        return false;
                                    }
                                },
                                cancelar : {
                                    label     : "Cancelar",
                                    className : "btn-default",
                                    callback  : function () {
                                    }
                                }
                            }
                        });
                    }
                    return false;
                });

                $("#btnDevolver").click(function () {
                    var $msg = $("<div>");
                    var $form = $("<form class='form-horizontal'>");
                    var $r1 = $("<div class='form-group'\"'>");
                    $r1.append("<label class='col-sm-2 control-label' for='obs'>Observaciones</label>");
                    var $obs = $("<textarea name='obs' id='obs' class='form-control required'/>");
                    var obs = $("<div class='col-sm-10 grupo'>");
                    obs.append($obs);
                    $r1.append(obs);
                    $form.append($r1);

                    var $r2 = $("<div class='form-group'\"'>");
                    $r2.append("<label class='col-sm-2 control-label' for='obs'>Autorización</label>");
                    var $auth = $("<input type='password' name='auth' id='auth' class='form-control required'/>");
                    var auth = $("<div class='col-sm-5 grupo'>");
                    var authGrp = $("<div class='input-group'>");
                    authGrp.append($auth);
                    authGrp.append("<span class='input-group-addon'><i class='fa fa-unlock-alt'></i></span>");
                    auth.append(authGrp);
                    $r2.append(auth);
                    $form.append($r2);

                    $msg.append($form);

                    $form.validate({
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

                    bootbox.dialog({
                        title   : "Devolver al requirente",
                        message : $msg,
                        buttons : {
                            devolver : {
                                label     : "<i class='fa fa-thumbs-down'></i> Devolver al requirente",
                                className : "btn-danger",
                                callback  : function () {
                                    if ($form.valid()) {
                                        openLoader("Devolviendo");
                                        $.ajax({
                                            type    : "POST",
                                            url     : "${createLink(action: 'devolverARequirente_ajax')}",
                                            data    : {
                                                id   : "${solicitud.id}",
                                                obs  : $obs.val(),
                                                auth : $auth.val()
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
                                            },
                                            error   : function () {
                                                log("Ha ocurrido un error interno", "error");
                                                closeLoader();
                                            }
                                        });
                                    }
                                    return false;
                                }
                            },
                            cancelar : {
                                label     : "Cancelar",
                                className : "btn-default",
                                callback  : function () {
                                }
                            }
                        }
                    });
                    return false;
                });
            });
        </script>

    </body>
</html>