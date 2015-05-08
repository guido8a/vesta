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

        <elm:container tipo="horizontal" titulo="Solicitud de reforma a procesar:  ${reforma.tipo == 'R' ? 'Reforma' : reforma.tipo == 'A' ? 'Ajuste' : '??'}
        ${reforma.tipoSolicitud == 'E' ? ' a asignaciones existentes' :
                reforma.tipoSolicitud == 'A' ? ' a nueva actividad' :
                        reforma.tipoSolicitud == 'C' ? ' de incremento a nueva actividad' :
                                reforma.tipoSolicitud == 'P' ? 'a nueva partida' :
                                        reforma.tipoSolicitud == 'I' ? ' de incremento' : '??'}">
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
                        %{--<a href="#" id="btnPreview" class="btn btn-info ${btnSelect && totalSaldo > 0 ? 'disabled' : ''}">--}%
                        %{--<i class="fa fa-search"></i> Previsualizar--}%
                        %{--</a>--}%

                        <g:set var="accion" value="${reforma.tipoSolicitud == 'E' ? 'existentePreviewReforma' :
                                reforma.tipoSolicitud == 'A' ? 'actividadPreviewReforma' :
                                        reforma.tipoSolicitud == 'C' ? 'incrementoActividadPreviewReforma' :
                                                reforma.tipoSolicitud == 'P' ? 'partidaPreviewReforma' :
                                                        reforma.tipoSolicitud == 'I' ? 'incrementoPreviewReforma' : ''}"/>
                        <g:set var="fileName" value="${reforma.tipoSolicitud == 'E' ? 'reforma_existente' :
                                reforma.tipoSolicitud == 'A' ? 'reforma_actividad' :
                                        reforma.tipoSolicitud == 'C' ? 'reforma_incremento_actividad' :
                                                reforma.tipoSolicitud == 'P' ? 'reforma_partida' :
                                                        reforma.tipoSolicitud == 'I' ? 'reforma_incremento' : ''}.pdf"/>
                        <a href="${g.createLink(controller: 'pdf', action: 'pdfLink')}?url=${g.createLink(controller: "reportesReforma", action: accion, id: reforma.id)}&filename=${fileName}"
                           class="btn btn-sm btn-info">
                            <i class="fa fa-search"></i> Previsualizar
                        </a>
                        <a href="#" id="btnAprobar" class="btn btn-success ${btnSelect && totalSaldo > 0 ? 'disabled' : ''}">
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