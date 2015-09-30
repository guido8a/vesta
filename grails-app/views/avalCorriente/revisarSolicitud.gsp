<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 26/06/15
  Time: 11:14 AM
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <meta name="layout" content="main"/>
        <title>Revisión de solicitud de aval para gasto permanente</title>
    </head>

    <body>
        <h1>Revisar solicitud de aval para gasto permanente</h1>

        <g:if test="${proceso.estado.codigo == 'D02' && proceso.firmaGerente.observaciones && proceso.firmaGerente.observaciones != '' && proceso.firmaGerente.observaciones != 'S'}">
            <elm:message tipo="warning"><strong>Devuelto por ${proceso.firmaGerente.usuario}</strong>: ${proceso.firmaGerente.observaciones}</elm:message>
        </g:if>

        <table class="table table-bordered table-condensed">
            <tr>
                <th style="width: 200px">
                    UNIDAD REQUIRENTE
                </th>
                <td>${proceso.usuario.unidad}</td>
            </tr>
            <tr>
                <th>
                    NOMBRE PROCESO
                </th>
                <td>
                    ${proceso.nombreProceso}
                </td>
            </tr>
            <tr>
                <th>
                    JUSTIFICACIÓN
                </th>
                <td>
                    ${proceso.concepto}
                </td>
            </tr>
            <tr>
                <th>
                    FECHA DE INICIO
                </th>
                <td>
                    ${proceso.fechaInicioProceso.format("dd-MM-yyyy")}
                </td>
            </tr>
            <tr>
                <th>
                    FECHA DE FIN
                </th>
                <td>
                    ${proceso.fechaFinProceso.format("dd-MM-yyyy")}
                </td>
            </tr>
            <tr>
                <th>
                    MONTO TOTAL SOLICITADO
                </th>
                <td>
                    <g:formatNumber number="${proceso.monto}" type="currency" currencySymbol="USD "/>
                </td>
            </tr>
        </table>

        <g:each in="${detalles}" var="d">
            <g:set var="det" value="${d.value}"/>
            <table class="table table-bordered table-condensed">
                <tr>
                    <td style="width:200px; font-weight: bold">OBJETIVO GASTO PERMANENTE</td>
                    <td>${det.tarea.actividad.macroActividad.objetivoGastoCorriente.descripcion}</td>
                </tr>
                <tr>
                    <td style="font-weight: bold">MACROACTIVIDAD</td>
                    <td>${det.tarea.actividad.macroActividad.descripcion}</td>
                </tr>
                <tr>
                    <td style="font-weight: bold">ACTIVIDAD</td>
                    <td>${det.tarea.actividad.descripcion}</td>
                </tr>
                <tr>
                    <td style="font-weight: bold">TAREA</td>
                    <td>${det.tarea.descripcion}</td>
                </tr>
                <tr>
                    <td style="font-weight: bold">ASIGNACIONES</td>
                    <td>
                        <table class="table table-bordered table-condensed" style="width: auto">
                            <thead>
                                <tr>
                                    <th>Asignación</th>
                                    <th>Fuente</th>
                                    <th>Monto</th>
                                </tr>
                            </thead>
                            <g:set var="total" value="${0}"/>
                            <tbody>
                                <g:each in="${det.asignaciones}" var="a">
                                    <g:set var="total" value="${total + a.monto}"/>
                                    <tr>
                                        <td>${a.asg.actividad ? a.asg.actividad + " - " : ""}${a.asg.presupuesto}</td>
                                        <td>${a.asg.fuente}</td>
                                        <td class="text-right"><g:formatNumber number="${a.monto}" type="currency" currencySymbol=""/></td>
                                    </tr>
                                </g:each>
                            </tbody>
                            <tfoot>
                                <tr>
                                    <th colspan="2">TOTAL</th>
                                    <td class="text-right"><g:formatNumber number="${total}" type="currency" currencySymbol=""/></td>
                                </tr>
                            </tfoot>
                        </table>
                    </td>
                </tr>
            </table>
        </g:each>
        ${session.usuario}
        <form id="frmFirmas">
            <div class="row">
                <div class="col-md-2 show-label">Autorización electrónica</div>

                <div class="col-md-3 grupo">
                    <g:if test="${proceso.estado.codigo == 'D02'}">
                        <p class="static-control">
                            ${proceso.firmaGerente.usuario}
                        </p>
                    </g:if>
                    <g:else>
                        <g:if test="${session.usuario.unidad.codigo in ["DF", "DA", "DTH"]}">
                            <g:select from="${directores}" optionKey="id" optionValue="${{
                                it.nombre + ' ' + it.apellido
                            }}" noSelection="['': '- Seleccione -']" name="firma" class="form-control required input-sm"/>
                        </g:if>
                        <g:else>
                            <g:select from="${gerentes}" optionKey="id" optionValue="${{
                                it.nombre + ' ' + it.apellido
                            }}" noSelection="['': '- Seleccione -']" name="firma" class="form-control required input-sm"/>
                        </g:else>
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
                    var url = "${g.createLink(controller: 'reporteSolicitud',action: 'solicitudAvalCorriente', id: proceso.id)}";
                    location.href = "${createLink(controller:'pdf',action:'pdfLink')}?url=" + url + "&filename=solicitud_aval_corriente.pdf";
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
                                                    id    : "${proceso.id}",
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
                                                id   : "${proceso.id}",
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