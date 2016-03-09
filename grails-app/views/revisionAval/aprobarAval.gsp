<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 29/01/15
  Time: 12:43 PM
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <meta name="layout" content="main"/>
        <title>Procesar aval</title>

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
                <g:link controller="revisionAval" action="pendientes" class="btn btn-default">
                    <i class="fa fa-chevron-left"></i> Regresar
                </g:link>
            </div>
        </div>

        <g:if test="${solicitud.aval && solicitud.estado.codigo != 'D03'}">
            <div class="alert alert-danger">
                <i class="fa fa-exclamation-triangle fa-2x"></i> Ya ha solicitado la firma para esta solicitud, no puede hacerlo nuevamente
            </div>
        </g:if>
        <g:else>
            <g:if test="${solicitud.estado.codigo == "D03"}">
                <div class="alert alert-warning">
                    <g:if test="${solicitud.aval.firma1.observaciones && solicitud.aval.firma1.observaciones != '' && solicitud.aval.firma1.observaciones != 'S'}">
                        <h4>Devuelto por ${solicitud.aval.firma1.usuario}</h4>
                        ${solicitud.aval.firma1.observaciones}
                    </g:if>
                    <g:if test="${solicitud.aval.firma2.observaciones && solicitud.aval.firma2.observaciones != '' && solicitud.aval.firma2.observaciones != 'S'}">
                        <h4>Devuelto por ${solicitud.aval.firma2.usuario}</h4>
                        ${solicitud.aval.firma2.observaciones}
                    </g:if>
                </div>
            </g:if>

            <elm:container tipo="horizontal" titulo="Solicitud a aprobar">
                <table class="table table-condensed table-bordered">
                    <thead>
                        <tr>
                            <th>Proyecto</th>
                            <th>Proceso</th>
                            <th>Justificación</th>
                            <th>Monto</th>
                            <th>Estado</th>
                            <th>Doc. Respaldo</th>
                            <th>Solicitud</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>${solicitud.proceso.proyecto.nombre}</td>
                            <td>${solicitud.proceso.nombre}</td>
                            <td>${solicitud.concepto}</td>
                            <td class="text-right">
                                <g:formatNumber number="${solicitud.monto}" type="currency" currencySymbol=""/>
                            </td>
                            <td>${solicitud.estado?.descripcion}</td>
                            <td style="text-align: center">
                                <g:if test="${solicitud.path}">
                                    <a href="#" class="btn btn-default btn-sm descRespaldo" title="Ver" iden="${solicitud.id}">
                                        <i class="fa fa-search"></i>
                                    </a>
                                </g:if>
                                <g:else>
                                </g:else>
                            </td>
                            <td style="text-align: center">
                                <a href="#" class="btn btn-default btn-sm imprimirSolicitud " iden="${solicitud.id}">
                                    <i class="fa fa-print"></i>
                                </a>
                                <a href="#" class="btn btn-success btn-sm btnTexto " iden="${solicitud.id}" title="Editar texto">
                                    <i class="fa fa-pencil"></i>
                                </a>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </elm:container>

            <elm:container tipo="horizontal" titulo="Datos para la generación del documento">
                <g:hiddenField name="numero" value="${numero}"/>
                <g:set var="val" value='El aval se otorga en base a los oficios No. SENPLADES-SZ1N-2012-0110-OF, de 12 de septiembre de 2012, con el cual se actualiza el dictamen de prioridad del proyecto "Ciudad del Conocimiento Yachay", CUP: 30400000.680.6990, para el periodo 2012-2017; No. MINFIN-DM-2013-0016, de 11 de enero de 2013, con el cual el Ministerio de Finanzas certifica asignará plurianualmente los recursos por hasta 206 millones de dólares para la ejecución del proyecto "Ciudad del Conocimiento Yachay"; y No. MINFIN-DM-2013-1018, de 27 de diciembre de 2013, con el cual el Ministerio finanzas asignará al proyecto Ciudad del Conocimiento en el año 2014 para gasto no permanente USD 80 millones. Con Oficio Nro. MINFIN-DM-2014-0479 de 19 de junio de 2014 con el cual el Ministerio de Finanzas certifica que en el Presupuesto General del Estado del presente ejercicio fiscal asignará el valor de 10.5 millones incrementales para gasto no permanente. Con fecha 01 de julio de 2014 se firma el Convenio Específico de Cooperación Interinstitucional Yachay - SENESCYT, recibiendo la transferencia de USD. 4.972.949,95. Mediante oficio No. SENPLADES-SGPBV-2014-0651-OF, de 03 de julio de 2014 la SENPLADES, emite dictamen favorable a la reducción del techo presupuestario por el monto de USD. 2.032.225,00 por la transferencia realizada por Yachay E.P. a la Universidad de Investigación de Tecnología Experimental Yachay. Mediante Oficio Nro. MINIFIN-SRF-2014-0517-M, de 12 de septiembre de 2014 se realiza el incremento al techo presupuestario por el valor de USD. 12.670.853,00.'/>
                <g:if test="${solicitud.observacionesPdf && solicitud.observacionesPdf.trim() != ''}">
                    <g:set var="val" value="${solicitud.observacionesPdf}"/>
                </g:if>

                <div class="row">
                    <div class="col-md-1 show-label">Número:</div>

                    <div class="col-md-3">
                        ${solicitud.fecha.format("yyyy")}-GP No. <elm:imprimeNumero solicitud="${solicitud.id}"/>
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-1 show-label">Observaciones:</div>

                    <div class="col-md-11">
                        <g:textArea name="richText" value="${val}"/>
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-1 show-label">&nbsp;</div>

                    <div class="btn-toolbar toolbar" style="margin-top: 15px;">
                        <div class="btn-group">
                            <a href="#" class="btn btn-success" id="guardarDatosDoc">
                                <i class="fa fa-save"></i> Guardar texto
                            </a>
                            %{--<a href="#" class="btn btn-default" id="descargaForm">--}%
                            %{--<i class="fa fa-search-plus"></i> Previzualizar--}%
                            %{--</a>--}%
                        </div>
                    </div>
                </div>
            </elm:container>

            <elm:container tipo="horizontal" titulo="Autorizaciones electrónicas">
                <form id="frmFirmas">
                    <div class="row">
                        <div class="col-md-3 grupo">
                            <g:if test="${solicitud.estado.codigo == "D03"}">
                                ${solicitud.aval.firma1.usuario}
                            </g:if>
                            <g:else>
                                <g:select from="${personas}" optionKey="id" optionValue="${{
                                    it.nombre + ' ' + it.apellido
                                }}" noSelection="['': '- Seleccione -']" name="firma2" class="form-control required input-sm"/>
                            </g:else>
                        </div>

                        <div class="col-md-3 grupo">
                            <g:if test="${solicitud.estado.codigo == "D03"}">
                                ${solicitud.aval.firma2.usuario}
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
                %{--<div class="btn-toolbar toolbar" style="margin-top: 15px;">--}%
                %{--<div class="btn-group">--}%
                %{--<a href="#" class="btn btn-default" id="solicitarFirma">--}%
                %{--Solicitar firma--}%
                %{--</a>--}%
                %{--</div>--}%
                %{--</div>--}%
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
                        var url = "${createLink(controller: 'reportes', action: 'certificacion')}/?id=${solicitud.id}Wusu=${session.usuario.id}";
                        location.href = "${createLink(controller:'pdf',action:'pdfLink')}?url=" + url + "&filename=aval_" + $("#numero").val() + ".pdf"
                        return false;
                    });

                    $("#btnSolicitar").click(function () {
                        if ($("#frmFirmas").valid()) {
//                            var $msg = $("<div>");
//                            var $form = $("<form class='form-horizontal'>");
//
//                            var $r2 = $("<div class='form-group'\"'>");
//                            $r2.append("<label class='col-sm-4 control-label' for='obs'>Autorización</label>");
//                            var $auth = $("<input type='password' class='form-control required'/>");
//                            var auth = $("<div class='col-sm-8 grupo'>");
//                            var authGrp = $("<div class='input-group'>");
//                            authGrp.append($auth);
//                            authGrp.append("<span class='input-group-addon'><i class='fa fa-unlock-alt'></i></span>");
//                            auth.append(authGrp);
//                            $r2.append(auth);
//                            $form.append($r2);
//
//                            $msg.append($form);
//
//                            $form.validate({
//                                errorClass     : "help-block",
//                                errorPlacement : function (error, element) {
//                                    if (element.parent().hasClass("input-group")) {
//                                        error.insertAfter(element.parent());
//                                    } else {
//                                        error.insertAfter(element);
//                                    }
//                                    element.parents(".grupo").addClass('has-error');
//                                },
//                                success        : function (label) {
//                                    label.parents(".grupo").removeClass('has-error');
//                                    label.remove();
//                                }
//
//                            });

                            bootbox.confirm(
                                    "<div class='alert alert-danger'>¿Está seguro? Una vez solicitada la firma no podrá modificar el documento</div>",
                                    function (res) {
                                        if (res) {
                                            openLoader("Solicitando");
                                            var aval = $("#numero").val();
                                            var obs = $("#richText").val();
                                            $.ajax({
                                                type    : "POST",
                                                url     : "${createLink(controller: 'revisionAval', action:'guarDatosDoc')}",
                                                data    : {
                                                    id     : "${solicitud.id}",
//                                                    auth   : $auth.val(),
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
                                                    %{--$("#guardarDatosDoc").remove();--}%
                                                    %{--var parts = msg.split("*");--}%
                                                    %{--closeLoader();--}%
                                                    %{--log(parts[1], parts[0] == "SUCCESS" ? "success" : "error"); // log(msg, type, title, hide)--}%
                                                    %{--if (parts[0] == "SUCCESS") {--}%
                                                    %{--setTimeout(function () {--}%
                                                    %{--location.href = "${createLink(controller: 'revisionAval', action: 'pendientes')}"--}%
                                                    %{--}, 2000);--}%
                                                    %{--}--}%
                                                }
                                            });
                                            %{--bootbox.dialog({--}%
                                            %{--title   : "Solicitar firmas",--}%
                                            %{--message : $msg,--}%
                                            %{--class   : "modal-sm",--}%
                                            %{--buttons : {--}%
                                            %{--devolver : {--}%
                                            %{--label     : "<i class='fa fa-pencil'></i> Solicitar firmas",--}%
                                            %{--className : "btn-success",--}%
                                            %{--callback  : function () {--}%
                                            %{--if ($form.valid()) {--}%
                                            %{--openLoader("Solicitando");--}%
                                            %{--var aval = $("#numero").val();--}%
                                            %{--var obs = $("#richText").val();--}%
                                            %{--$.ajax({--}%
                                            %{--type    : "POST",--}%
                                            %{--url     : "${createLink(controller: 'revisionAval', action:'guarDatosDoc')}",--}%
                                            %{--data    : {--}%
                                            %{--id     : "${solicitud.id}",--}%
                                            %{--auth   : $auth.val(),--}%
                                            %{--aval   : aval,--}%
                                            %{--obs    : obs,--}%
                                            %{--firma2 : $("#firma2").val(),--}%
                                            %{--firma3 : $("#firma3").val(),--}%
                                            %{--enviar : "true"--}%
                                            %{--},--}%
                                            %{--success : function (msg) {--}%
                                            %{--var parts = msg.split("*");--}%
                                            %{--log(parts[1], parts[0]); // log(msg, type, title, hide)--}%
                                            %{--if (parts[0] == "SUCCESS") {--}%
                                            %{--setTimeout(function () {--}%
                                            %{--location.href = "${createLink(action: 'pendientes')}";--}%
                                            %{--}, 1000);--}%
                                            %{--} else {--}%
                                            %{--closeLoader();--}%
                                            %{--}--}%
                                            %{--$("#guardarDatosDoc").remove();--}%
                                            %{--var parts = msg.split("*");--}%
                                            %{--closeLoader();--}%
                                            %{--log(parts[1], parts[0] == "SUCCESS" ? "success" : "error"); // log(msg, type, title, hide)--}%
                                            %{--if (parts[0] == "SUCCESS") {--}%
                                            %{--setTimeout(function () {--}%
                                            %{--location.href = "${createLink(controller: 'revisionAval', action: 'pendientes')}"--}%
                                            %{--}, 2000);--}%
                                            %{--}--}%
                                            %{--}--}%
                                            %{--});--}%
                                            %{--}--}%
                                            %{--return false;--}%
                                            %{--}--}%
                                            %{--},--}%
                                            %{--cancelar : {--}%
                                            %{--label     : "Cancelar",--}%
                                            %{--className : "btn-default",--}%
                                            %{--callback  : function () {--}%
                                            %{--}--}%
                                            %{--}--}%
                                            %{--}--}%
                                            %{--});--}%
                                        }
                                    });
                        }
                        return false;
                    });


                    $(".btnTexto").click(function () {
                        var idSol = $(this).attr('iden')
                        $.ajax({
                            type   : "POST",
                            url    : "${createLink(controller: 'revisionAval', action:'cambiarTexto_ajax')}",
                            data   : {id: idSol},
                            success: function (msg) {
                                var b = bootbox.dialog({
                                    id   : "dlgEditarTexto",
                                    title: "Editar Texto",
                                    message: msg,
                                    class   : "modal-lg",
                                    buttons: {
                                        cancelar: {
                                            label    : "Cancelar",
                                            className: "btn-primary",
                                            callback : function () {
                                            }
                                        },
                                        guardar : {
                                            id       : "btnSave",
                                            label    : "<i class='fa fa-save'></i> Guardar",
                                            className: "btn-success",
                                            callback : function () {
                                                $.ajax({
                                                  type: 'POST',
                                                  url: "${createLink(controller: 'revisionAval', action:'guardarTexto_ajax')}",
                                                  data: {nombre: $("#procesoNombre").val(),
                                                         concepto: $("#concepto").val(),
                                                  id: idSol},
                                                    success: function (msg){
                                                        if(msg == 'ok'){
                                                            log("Texto cambiado correctamente", "success")
                                                            setTimeout(function () {
                                                                location.href = "${createLink(controller:'revisionAval',action:'aprobarAval')}/" + idSol;
                                                            }, 1000);
                                                        }else{
                                                            log("Error al cambiar el texto", "error")
                                                        }
                                                    }
                                                });
                                            } //callback
                                        } //guardar
                                    } //buttons
                                }); //dialog
                                setTimeout(function () {
                                    b.find(".form-control").first().focus()
                                }, 500);
                            } //success
                        }); //ajax
                    });


                    $("#btnNegar").click(function () {
//                        var $msg = $("<div>");
//                        var $form = $("<form class='form-horizontal'>");
//
//                        var $r2 = $("<div class='form-group'\"'>");
//                        $r2.append("<label class='col-sm-4 control-label' for='obs'>Autorización</label>");
//                        var $auth = $("<input type='password' class='form-control required'/>");
//                        var auth = $("<div class='col-sm-8 grupo'>");
//                        var authGrp = $("<div class='input-group'>");
//                        authGrp.append($auth);
//                        authGrp.append("<span class='input-group-addon'><i class='fa fa-unlock-alt'></i></span>");
//                        auth.append(authGrp);
//                        $r2.append(auth);
//                        $form.append($r2);
//
//                        $msg.append($form);
//
//                        $form.validate({
//                            errorClass     : "help-block",
//                            errorPlacement : function (error, element) {
//                                if (element.parent().hasClass("input-group")) {
//                                    error.insertAfter(element.parent());
//                                } else {
//                                    error.insertAfter(element);
//                                }
//                                element.parents(".grupo").addClass('has-error');
//                            },
//                            success        : function (label) {
//                                label.parents(".grupo").removeClass('has-error');
//                                label.remove();
//                            }
//                        });

                        bootbox.confirm(
                                "<div class='alert alert-danger'>¿Está seguro de querer negar este aval?</div>",
                                function (res) {
                                    if (res) {
                                        openLoader("Negando");
                                        var aval = $("#numero").val();
                                        var obs = $("#richText").val();
                                        $.ajax({
                                            type    : "POST",
                                            url     : "${createLink(controller: 'revisionAval', action:'negarAval')}",
                                            data    : {
                                                id   : "${solicitud.id}",
//                                                auth : $auth.val(),
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
                                        %{--bootbox.dialog({--}%
                                            %{--title   : "Negar",--}%
                                            %{--message : $msg,--}%
                                            %{--class   : "modal-sm",--}%
                                            %{--buttons : {--}%
                                                %{--devolver : {--}%
                                                    %{--label     : "<i class='fa fa-thumbs-down'></i> Negar",--}%
                                                    %{--className : "btn-danger",--}%
                                                    %{--callback  : function () {--}%
                                                        %{--if ($form.valid()) {--}%
                                                            %{--openLoader("Negando");--}%
                                                            %{--var aval = $("#numero").val();--}%
                                                            %{--var obs = $("#richText").val();--}%
                                                            %{--$.ajax({--}%
                                                                %{--type    : "POST",--}%
                                                                %{--url     : "${createLink(controller: 'revisionAval', action:'negarAval')}",--}%
                                                                %{--data    : {--}%
                                                                    %{--id   : "${solicitud.id}",--}%
                                                                    %{--auth : $auth.val(),--}%
                                                                    %{--aval : aval,--}%
                                                                    %{--obs  : obs--}%
                                                                %{--},--}%
                                                                %{--success : function (msg) {--}%
                                                                    %{--var parts = msg.split("*");--}%
                                                                    %{--log(parts[1], parts[0]); // log(msg, type, title, hide)--}%
                                                                    %{--if (parts[0] == "SUCCESS") {--}%
                                                                        %{--setTimeout(function () {--}%
                                                                            %{--location.href = "${createLink(action: 'pendientes')}";--}%
                                                                        %{--}, 1000);--}%
                                                                    %{--} else {--}%
                                                                        %{--closeLoader();--}%
                                                                    %{--}--}%
                                                                %{--}--}%
                                                            %{--});--}%
                                                        %{--}--}%
                                                        %{--return false;--}%
                                                    %{--}--}%
                                                %{--},--}%
                                                %{--cancelar : {--}%
                                                    %{--label     : "Cancelar",--}%
                                                    %{--className : "btn-default",--}%
                                                    %{--callback  : function () {--}%
                                                    %{--}--}%
                                                %{--}--}%
                                            %{--}--}%
                                        %{--});--}%
                                    }
                                });
                        return false;
                    });

                    $("#guardarDatosDoc").click(function () {
                        var aval = $("#numero").val();
                        var obs = $("#richText").val();
                        $.ajax({
                            type    : "POST",
                            url     : "${createLink(controller: 'revisionAval',action:'guarDatosDoc')}",
                            data    : {
                                id     : "${solicitud.id}",
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
                    %{--$("#solicitarFirma").click(function () {--}%

                    %{--var f1 = $("#firma2").val();--}%
                    %{--var f2 = $("#firma3").val();--}%

                    %{--if (f1 == "" || f2 == "") {--}%
                    %{--bootbox.alert("Seleccione las personas para las autorizaciones electrónicas");--}%
                    %{--} else {--}%
                    %{--(bootbox.confirm(--}%
                    %{--"<div class='alert alert-danger'>¿Está seguro? Una vez solicitada la firma no podrá modificar el documento</div>",--}%
                    %{--function (res) {--}%
                    %{--if (res) {--}%
                    %{--openLoader();--}%
                    %{--var aval = $("#numero").val();--}%
                    %{--var obs = $("#richText").val();--}%
                    %{--$.ajax({--}%
                    %{--type    : "POST",--}%
                    %{--url     : "${createLink(controller: 'revisionAval', action:'guarDatosDoc')}",--}%
                    %{--data    : {--}%
                    %{--id     : "${solicitud.id}",--}%
                    %{--aval   : aval,--}%
                    %{--obs    : obs,--}%
                    %{--firma2 : $("#firma2").val(),--}%
                    %{--firma3 : $("#firma3").val(),--}%
                    %{--enviar : "true"--}%
                    %{--},--}%
                    %{--success : function (msg) {--}%
                    %{--$("#guardarDatosDoc").remove();--}%
                    %{--var parts = msg.split("*");--}%
                    %{--closeLoader();--}%
                    %{--log(parts[1], parts[0] == "SUCCESS" ? "success" : "error"); // log(msg, type, title, hide)--}%
                    %{--if (parts[0] == "SUCCESS") {--}%
                    %{--setTimeout(function () {--}%
                    %{--location.href = "${createLink(controller: 'revisionAval', action: 'pendientes')}"--}%
                    %{--}, 2000);--}%
                    %{--}--}%
                    %{--}--}%
                    %{--});--}%
                    %{--}--}%
                    %{--}));--}%
                    %{--}--}%

                    %{--return false;--}%
                    %{--});--}%
                    $(".imprimirSolicitud").click(function () {
                        var url = "${g.createLink(controller: 'reporteSolicitud',action: 'imprimirSolicitudAval')}/?id=" + $(this).attr("iden");
                        location.href = "${createLink(controller:'pdf',action:'pdfLink')}?url=" + url + "&filename=solicitud.pdf";
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