<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 25/06/15
  Time: 12:21 PM
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <meta name="layout" content="main"/>
        <title>Nueva solicitud de aval: 2-Asignaciones</title>

        <link href="${resource(dir: 'css/custom', file: 'wizard.css')}" rel="stylesheet"/>

        <script type="text/javascript" src="${resource(dir: 'js/plugins/bootstrap-select-1.6.3/dist/js', file: 'bootstrap-select.js')}"></script>
        <link rel="stylesheet" href="${resource(dir: 'js/plugins/bootstrap-select-1.6.3/dist/css', file: 'bootstrap-select.css')}">
    </head>

    <body>
        <elm:message tipo="${flash.tipo}" clase="${flash.clase}">${flash.message}</elm:message>

        <div class="btn-toolbar" role="toolbar">
            <div class="btn-group" role="group">
                <g:link action="listaProcesos" class="btn btn-default">
                    <i class="fa fa-bars"></i> Regresar a lista de procesos de avales
                </g:link>
            </div>
        </div>

        <elm:wizardAvalesCorrientes paso="2" proceso="${proceso}" a="${a}"/>

        <g:form action="" class="form-horizontal wizard-form corner-bottom" role="form" method="POST">
            <g:if test="${!readOnly}">
                <div class="row grupo">
                    <label class="col-md-2 control-label">
                        Año
                    </label>

                    <div class="col-md-3">
                        <g:select name="anio" from="${anios}" value="${actual?.id}"
                                  class="form-control input-sm" id="anio" optionKey="id" optionValue="anio" style="width: 80px;"/>
                    </div>

                    <label class="col-md-2 control-label">
                        Tarea
                    </label>

                    <div class="col-md-3" id="tdTarea">
                    </div>
                </div>

                <div class="row grupo">
                    <label class="col-md-2 control-label">
                        Objetivo gasto corriente
                    </label>

                    <div class="col-md-3" id="tdObj">
                    </div>

                    <label class="col-md-2 control-label">
                        Asignación
                    </label>

                    <div class="col-md-3" id="tdAsignacion">
                    </div>
                </div>

                <div class="row grupo">
                    <label class="col-md-2 control-label">
                        MacroActividad
                    </label>

                    <div class="col-md-3" id="tdMacro">
                    </div>

                    <label class="col-md-2 control-label">
                        Monto
                    </label>

                    <div class="col-md-2">
                        <div class="input-group">
                            <g:textField class="form-control input-sm number money" name="montoName" style="text-align: right; margin-right: 10px" id="monto" title="Colocar monto de la asignación"/>
                            <span class="input-group-addon"><i class="fa fa-usd"></i></span>
                        </div>
                    </div>

                    <div class="col-md-3">
                        <p class="form-control-static">
                            <label>Máximo <span id="max" style="display: inline-block"></span> $</label>
                        </p>
                    </div>
                </div>

                <div class="row grupo">
                    <label class="col-md-2 control-label">
                        Actividad
                    </label>

                    <div class="col-md-3" id="tdActividad">
                    </div>

                    <label class="col-md-2 control-label">
                    </label>

                    <div class="col-md-2 text-right">
                        <a href="#" class="btn btn-success" id="agregar" title="Agregar la asignación a la solicitud">
                            <i class="fa fa-plus"></i> Agregar asignación
                        </a>
                    </div>
                </div>

            </g:if>
            <div class="row">
                <div class="col-md-10 col-md-offset-1" id="detalle">

                </div>
            </div>

            <g:if test="${!readOnly}">
                <div class="row">
                    <div class="col-md-11 text-right">
                        %{--<g:link action="solicitudProceso" id="${proceso.id}" class="btn btn-success" title="Guardar y pasar a la solicitud">--}%
                        %{--<i class="fa fa-save"></i> Guardar y Continuar <i class="fa fa-chevron-right"></i>--}%
                        %{--</g:link>--}%
                        <div class="btn-group" role="group">
                            <a href="#" id="btnPreview" class="btn btn-default ${proceso ? '' : 'disabled'}" title="Previsualizar">
                                <i class="fa fa-search"></i> Previsualizar
                            </a>
                            <a href="#" id="btnGuardar" class="btn btn-info" title="Guardar y seguir editando">
                                <i class="fa fa-save"></i> Guardar
                            </a>
                            <a href="#" id="btnEnviar" class="btn btn-success" title="Guardar y solicitar revisión">
                                <i class="fa fa-save"></i> Guardar y Enviar <i class="fa fa-paper-plane-o"></i>
                            </a>
                        </div>
                    </div>
                </div>
            </g:if>
        </g:form>

        <script type="text/javascript">
            var total = ${total};

            function getMaximo(asg) {
                if ($("#asignacion").val() != "-1") {
                    $.ajax({
                        type    : "POST",
                        url     : "${createLink(action:'getMaximoAsg')}",
                        data    : {
                            id : asg
                        },
                        success : function (msg) {
                            var valor = parseFloat(msg);
                            var tot = 0;
//                            $(".tableReformaNueva").each(function () {
//                                var d = $(this).data();
//                                if ("" + d.origen.asignacion_id == "" + asg) {
//                                    tot += parseFloat(d.origen.monto);
//                                }
//                            });
                            var ok = valor - tot;

                            $("#max").html("$" + number_format(ok, 2, ".", ","))
                                    .attr("valor", ok);
                            $("#monto").attr("tdnMax", ok);
                        }
                    });
                }
            }

            function getDetalle() {
                $('.qtip').qtip('hide');
                $.ajax({
                    type    : "POST",
                    url     : "${createLink(action:'getDetalle_ajax')}",
                    data    : {
                        id       : "${proceso?.id}",
                        readOnly : "${readOnly}"
                    },
                    success : function (msg) {
                        $("#detalle").html(msg)
                    }
                });
            }

            function vaciar() {
                $("#monto").val("");
                $("#max").html("");
                $("#asignacion").val("-1");
            }

            function cargarObjAnio() {
                $("#tdObj").html(spinner);
                $.ajax({
                    type    : "POST",
                    url     : "${createLink(action:'cargaObjetivosAnio_ajax')}",
                    data    : {
                        anio : $("#anio").val()
                    },
                    success : function (msg) {
                        $("#tdObj").html(msg);
                    }
                });
            }

            $(function () {
                <g:if test="${proceso}">
                getDetalle();
                </g:if>
                cargarObjAnio();

                $("#anio").change(function () {
                    $("#max").html("");
                    cargarObjAnio();
                });

                $("#comp").val("-1").change(function () {
                    $.ajax({
                        type    : "POST",
                        url     : "${createLink(action:'cargarActividades_ajax')}",
                        data    : {
                            id     : $("#comp").val(),
                            anio   : $("#anio").val(),
                            unidad : "${unidad?.id}"
                        },
                        success : function (msg) {
                            $("#divAct").html(msg)
                        }
                    });
                });

                $("#agregar").click(function () {
                    var id = $("#idAgregar").val();
                    var $monto = $("#monto");
                    var monto = $monto.val();
                    var max = $monto.attr("tdnmax");
                    monto = monto.replace(new RegExp(",", 'g'), "");
                    var asg = $("#asg").val();
                    var proceso = "${proceso?.id}";

                    var msg = "";
                    if (asg == "-1" || isNaN(asg)) {
                        msg += "<br>Debe seleccionar una asignación.";
                    } else {
                        if (isNaN(monto) || monto == "") {
                            msg += "<br>El monto tiene que ser un número positivo.";
                        } else {
                            if (monto * 1 < 0)
                                msg += "<br>El monto tiene que ser un número positivo.";
                            if (monto * 1 > max * 1)
                                msg += "<br>El monto no puede ser mayor al máximo.";
                        }
                    }

                    if (msg == "") {
                        $.ajax({
                            type    : "POST",
                            url     : "${createLink(action:'agregarAsignacion_ajax')}",
                            data    : {
                                id    : "${proceso.id}",
                                monto : monto,
                                asg   : asg
                            },
                            success : function (msg) {
                                var parts = msg.split("*");
                                log(parts[1], parts[0]);
                                vaciar();
                                getDetalle();
                                total += monto;
                            }
                        });
                    } else {
                        bootbox.dialog({
                            title   : "Error",
                            message : msg,
                            buttons : {
                                cancelar : {
                                    label     : "Cancelar",
                                    className : "btn-primary",
                                    callback  : function () {
                                    }
                                }
                            }
                        });
                    }
                });

                $("#btnEnviar").click(function () {
                    if (total > 0) {
                        bootbox.confirm("<strong>¿Está seguro de querer enviar la solicitud?</strong><br/><br/>" +
                                        "Una vez enviada ya no se podrá modificar los datos de la Solicitud", function (res) {
                            if (res) {
                                openLoader("Por favor espere");
                                location.href = "${createLink(action: 'guardarSolicitud', id: proceso.id)}"
                            }
                        });
                    }
                    else {
                        bootbox.alert("No ha seleccionado asignaciones, por lo que no puede enviar esta solicitud.");
                    }
                });

                $("#btnGuardar").click(function () {
                    openLoader();
                    setTimeout(function () {
                        location.reload(true);
                    }, 500);
                });

                $("#btnPreview").click(function () {
                    var url = "${g.createLink(controller: 'reporteSolicitud',action: 'solicitudAvalCorriente')}/?id=${proceso?.id}";
                    location.href = "${createLink(controller:'pdf',action:'pdfLink')}?url=" + url + "&filename=solicitud_aval_corriente.pdf"
                });
            });
        </script>

    </body>
</html>