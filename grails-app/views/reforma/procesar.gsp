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

        .table {
            margin-top : 15px;
        }
        </style>
    </head>

    <g:set var="btnSelect" value="${tipo == 'I' || tipo == 'C'}"/>

    <body>
        <g:hiddenField name="anio" value="${reforma.anioId}"/>
        <div class="btn-toolbar toolbar">
            <div class="btn-group">
                <g:link action="pendientes" class="btn btn-default">
                    <i class="fa fa-chevron-left"></i> Regresar
                </g:link>
            </div>
        </div>

        <g:if test="${reforma && reforma.estado.codigo == "D03"}">
            <div class="alert alert-warning">
                <g:if test="${reforma.firma1.observaciones && reforma.firma1.observaciones != '' && reforma.firma1.observaciones != 'S'}">
                    <h4>Devuelto por ${reforma.firma1.usuario}</h4>
                    ${reforma.firma1.observaciones}
                </g:if>
                <g:if test="${reforma.firma2.observaciones && reforma.firma2.observaciones != '' && reforma.firma2.observaciones != 'S'}">
                    <h4>Devuelto por ${reforma.firma2.usuario}</h4>
                    ${reforma.firma2.observaciones}
                </g:if>
            </div>
        </g:if>

        <elm:container tipo="horizontal" titulo="Solicitud de reforma a procesar:  ${elm.tipoReforma(reforma: reforma)}">
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

                <g:if test="${btnSelect}">
                    <div class="col-md-1 show-label">
                        Saldo
                    </div>

                    <div class="col-md-2" id="divTotal">
                        <g:formatNumber number="${totalSaldo}" type="currency"/>
                    </div>
                </g:if>

                <div class="col-md-1 show-label">
                    Fecha
                </div>

                <div class="col-md-2">
                    <g:formatDate date="${reforma.fecha}" format="dd-MM-yyyy"/>
                </div>
            </div>

            <div class="row">
                <div class="col-md-1 show-label">
                    Concepto
                </div>

                <div class="col-md-11">
                    ${reforma.concepto}
                </div>
            </div>

            <g:if test="${btnSelect}">
                <g:render template="/reportesReformaTemplates/tablaSolicitud"
                          model="[det: det2, tipo: tipo, btnSelect: btnSelect, btnDelete: false]"/>
                <g:if test="${detallado.size() > 0}">
                    <g:render template="/reportesReformaTemplates/tablaSolicitud"
                              model="[det: detallado, tipo: tipo, btnSelect: false, btnDelete: btnSelect]"/>
                </g:if>
            </g:if>
            <g:else>
                <g:render template="/reportesReformaTemplates/tablaSolicitud"
                          model="[det: det, tipo: tipo, btnSelect: false, btnDelete: false]"/>
            </g:else>
        </elm:container>

        <form id="frmFirmas">
            <elm:container tipo="horizontal" titulo="Datos para la generación del documento">
                <div class="row">
                    <div class="col-md-1 show-label">Observaciones</div>

                    <div class="col-md-11">
                        <g:textArea name="richText" value="${reforma.nota}"/>
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-1 show-label">&nbsp;</div>

                    <div class="btn-toolbar toolbar" style="margin-top: 15px;">
                        <div class="btn-group">
                            <a href="#" class="btn btn-success" id="btnGuardar">
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
                        <div class="btn-group" role="group" aria-label="...">
                            <elm:linkPdfReforma reforma="${reforma}" preview="${true}" class="btn-default" title="Previsualizar" label="true"/>
                            <a href="#" id="btnAprobar" class="btn btn-success ${btnSelect && totalSaldo > 0 ? 'disabled' : ''}" title="Aprobar y solicitar firmas">
                                <i class="fa fa-pencil"></i> Solicitar firmas
                            </a>
                            <a href="#" id="btnNegar" class="btn btn-danger" title="Negar definitivamente la solicitud de reforma">
                                <i class="fa fa-thumbs-down"></i> Negar
                            </a>
                        </div>
                    </div>
                </div>
            </elm:container>
        </form>

        <script type="text/javascript">

            function procesar(aprobado, mandar) {
                var url = "${createLink(action:'aprobar')}";
                var str = "Aprobando";
                var str2 = "aprobar";
                var str3 = "Aprobar";
                var clase = "success";
                var ico = "pencil";
                var data = {
                    id : "${reforma.id}"
                };
                if (!aprobado) {
                    url = "${createLink(action:'negar')}";
                    str = "Negando";
                    str2 = "negar";
                    str3 = "Negar";
                    clase = "danger";
                    ico = "thumbs-down";
                } else {
                    if (!mandar) {
                        url = "${createLink(action:'guardar')}";
                        str = "Guardando";
                        str2 = "guardar";
                        str3 = "Guardar";
                        clase = "success";
                        ico = "thumbs-save";
                    }
                    data.firma1 = $("#firma1").val();
                    data.firma2 = $("#firma2").val();
                    data.observaciones = $("#richText").val();
                }

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

                var dlg = function () {
                    openLoader(str);
                    $.ajax({
                        type    : "POST",
                        url     : url,
                        data    : data,
                        success : function (msg) {
                            var parts = msg.split("*");
                            log(parts[1], parts[0]);
                            if (parts[0] == "SUCCESS") {
                                if (mandar) {
                                    location.href = "${createLink(action:'pendientes')}";
                                } else {
                                    location.reload(true);
                                }
                            } else {
                                closeLoader();
                            }
                        }
                    });
                    %{--bootbox.dialog({--}%
                    %{--title   : str3,--}%
                    %{--message : $msg,--}%
                    %{--class   : "modal-sm",--}%
                    %{--buttons : {--}%
                    %{--devolver : {--}%
                    %{--label     : "<i class='fa fa-" + ico + "'></i> " + str3,--}%
                    %{--className : "btn-" + clase,--}%
                    %{--callback  : function () {--}%
                    %{--if ($form.valid()) {--}%
                    %{--data.auth = $auth.val();--}%
                    %{--openLoader(str);--}%
                    %{--$.ajax({--}%
                    %{--type    : "POST",--}%
                    %{--url     : url,--}%
                    %{--data    : data,--}%
                    %{--success : function (msg) {--}%
                    %{--var parts = msg.split("*");--}%
                    %{--log(parts[1], parts[0]);--}%
                    %{--if (parts[0] == "SUCCESS") {--}%
                    %{--if (mandar) {--}%
                    %{--location.href = "${createLink(action:'pendientes')}";--}%
                    %{--} else {--}%
                    %{--location.reload(true);--}%
                    %{--}--}%
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
                };
                if (mandar) {
                    bootbox.confirm("¿Está seguro de querer <strong class='text-" + clase + "'>" + str2 + "</strong> esta solicitud de reforma?<br/>Esta acción no puede revertirse.",
                            function (res) {
                                if (res) {
                                    dlg();
                                }
                            });
                } else {
                    dlg();
                }
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
//                    var ok = true;
                    %{--<g:if test="${reforma.tipoSolicitud == 'I'}">--}%
                    %{--var ti = parseFloat(number_format($("#totalInicial").data("valor"), 2, ".", ""));--}%
                    %{--var tf = parseFloat(number_format($("#totalFinal").data("valor"), 2, ".", ""));--}%
                    %{--if (ti != tf) {--}%
                    %{--bootbox.alert("Debe seleccionar las asignaciones de origen de tal manera que el total inicial sea igual al total final");--}%
                    %{--ok = false;--}%
                    %{--}--}%
                    %{--</g:if>--}%
//                    if (ok) {
                    if ($("#frmFirmas").valid()) {
                        procesar(true, true);
                    }
//                    }
                    return false;
                });
                $("#btnGuardar").click(function () {
                    procesar(true, false);
                    return false;
                });
                $("#btnNegar").click(function () {
                    procesar(false, true);
                    return false;
                });

                <g:if test="${btnSelect}">
                function validarPar(dataOrigen, dataDestino) {
//                    console.log(dataDestino);
                    var monto = parseFloat($.trim(str_replace(",", "", $("#monto").val())));
//                    console.log(dataOrigen.monto, monto, dataOrigen.max);
                    var ok = true;
                    if (monto > dataOrigen.max) {
                        ok = false;
                        bootbox.alert("No puede seleccionar una asignación cuyo máximo es menor que el valor de la asignación de destino");
                    }
                    if (ok) {
                        $(".tb").children().each(function () {
                            var d = $(this).data();
                            if (ok) {

                                var b1 = false, b2 = false;
                                if (d.aso) {
                                    b1 = d.aso == dataOrigen.asignacion_id;
                                    b2 = d.aso == dataDestino.asignacion_id
                                    if (d.asd) {
                                        b1 = b1 && d.asd == dataDestino.asignacion_id;
                                        b2 = b2 || d.asd == dataOrigen.asignacion_id
                                    }
                                } else {
                                    if (d.asd) {
//                                        b1 = d.asd == dataDestino.asignacion_id;
                                        b2 = d.asd == dataOrigen.asignacion_id
                                    }
                                }

//                                console.log($(this), d.aso, "==", dataOrigen.asignacion_id, "&&", d.asd, "==", dataDestino.asignacion_id, (d.aso == dataOrigen.asignacion_id && d.asd == dataDestino.asignacion_id), "b1:", b1);
                                if (b1) {
                                    ok = false;
                                    bootbox.alert("No puede seleccionar un par de asignaciones ya ingresados");
                                } else {
//                                    console.log(d.aso, dataDestino.asignacion_id, d.asd, dataOrigen.asignacion_id, d.aso == dataDestino.asignacion_id, d.asd == dataOrigen.asignacion_id, d.aso == dataDestino.asignacion_id || d.asd == dataOrigen.asignacion_id)
//                                    console.log(d.aso, "==", dataDestino.asignacion_id, "||", d.asd, "==", dataOrigen.asignacion_id, (d.aso == dataDestino.asignacion_id || d.asd == dataOrigen.asignacion_id), "b2: ", b2);
                                    if (b2) {
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
                                                    asignacion_id : $tr.data("asd")
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