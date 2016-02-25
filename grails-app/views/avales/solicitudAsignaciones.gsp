<%@ page import="vesta.parametros.TipoElemento; vesta.proyectos.MarcoLogico; vesta.parametros.poaPac.Anio" contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main"/>
        <title>Nueva solicitud de aval: 2-Asignaciones</title>

        <link href="${resource(dir: 'css/custom', file: 'wizard.css')}" rel="stylesheet"/>

    </head>

    <body>
        <g:set var="monto" value="${proceso?.getMonto() ?: 0}"/>
        <elm:message tipo="${flash.tipo}" clase="${flash.clase}">${flash.message}</elm:message>

        <div class="btn-toolbar" role="toolbar">
            <div class="btn-group" role="group">
                <g:link controller="avales" action="listaProcesos" class="btn btn-default">
                    <i class="fa fa-bars"></i>Regresar a lista de procesos de avales
                </g:link>
                <g:if test="${proceso}">
                    <g:link controller="avales" action="avalesProceso" id="${proceso?.id}" class="btn btn-default">
                        <i class="fa fa-bars"></i> Solicitudes y avales del proceso
                    </g:link>
                </g:if>
            </div>
        </div>

        <g:if test="${solicitud && solicitud.estado.codigo == 'D01' && solicitud.observaciones}">
            <div class="row">
                <div class="col-md-12">
                    <elm:message tipo="warning" close="false">${solicitud?.observaciones}</elm:message>
                </div>
            </div>
        </g:if>

        <input type="hidden" name="id" value="${proceso?.id}">

    %{--****************************************************************************************************************************************--}%
        <elm:wizardAvales paso="2" proceso="${proceso}"/>
    %{--****************************************************************************************************************************************--}%

        <g:form action="" class="form-horizontal wizard-form corner-bottom" name="frmProceso" role="form" method="POST">
            <g:if test="${!readOnly}">
                <div class="row">
                    <span class="grupo">
                        <label class="col-md-1 control-label">
                            Año
                        </label>

                        <div class="col-md-2">
                            <g:select name="anio" from="${anios}" value="${actual?.id}"
                                      class="form-control input-sm" id="anio" optionKey="id" optionValue="anio" style="width: 80px;"/>
                        </div>
                    </span>

                    <div class="col-md-2"></div>

                    <span class="grupo">
                        <label class="col-md-2 control-label">
                            Asignación
                        </label>

                        <div class="col-md-4" id="divAsg">
                            %{--<g:select name="asignacion" from="${[]}" class="form-control input-sm" id="asignacion" noSelection="['-1': 'Seleccione...']"/>--}%
                        </div>
                    </span>
                </div>

                <div class="row">
                    <span class="grupo">
                        <label class="col-md-1 offset-md-1 control-label">
                            Componente
                        </label>

                        <div class="col-md-4" id="div_comp">
                            <g:if test="${!readOnly}">
                            %{--<g:select name="comp" from="${componentes}" class="form-control input-sm" optionKey="id" optionValue="objeto" id="comp" noSelection="['-1': 'Seleccione...']"/>--}%
                            </g:if>
                            <g:else>
                                <p class="form-control-static">
                                    ${actual}
                                </p>
                            </g:else>
                        </div>
                    </span>

                    <span class="grupo">
                        <label for="monto" class="col-md-2 control-label">
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
                    </span>
                </div>

                <div class="row">
                    <span class="grupo">
                        <label class="col-md-1 control-label">
                            Actividad
                        </label>

                        <div class="col-md-5" id="divAct">
                            %{--<g:select name="actividad" from="${[]}" class="form-control input-sm" id="actividad" noSelection="['-1': 'Seleccione...']"/>--}%
                        </div>
                    </span>

                    <span class="grupo" id="spanDevengado">
                        <label class="col-md-1 control-label text-success">
                            Devengado
                        </label>

                        <div class="col-md-2">
                            <div class="input-group">
                                <g:textField class="form-control input-sm number money" name="devengado"
                                             style="text-align: right; margin-right: 10px" title="Valor devengado años anteriores, en caso de existir"/>
                                <span class="input-group-addon"><i class="fa fa-usd"></i></span>
                            </div>
                        </div>
                    </span>

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
                        <g:link action="solicitudProceso" id="${proceso.id}" class="btn btn-success" title="Guardar y pasar a la solicitud">
                            <i class="fa fa-save"></i> Guardar y Continuar <i class="fa fa-chevron-right"></i>
                        </g:link>
                    </div>
                </div>
            </g:if>
        </g:form>

        <script type="text/javascript">
            function getMaximo(asg, monto) {
                var maximof;
                $.ajax({
                    type    : "POST",
                    async   : false,
                    url     : "${createLink(action: 'getMaximoAsg')}",
                    data    : {
                        id  : asg,
                        prco: ${proceso.id}
                    },
                    success : function (msg) {
                        if ($("#asignacion").val() != "-1")
                            maximof = msg;
                        else {
                            var valor = parseFloat(msg);
                            monto = parseFloat(monto);
                            maximof = valor + monto
                        }
                    },
                    error   : function () {
                        maximof = monto
                    }
                });
                return maximof;
            }

            function getDetalle() {
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
                $("#devengado").val("");
                $("#max").html("");
                $("#asignacion").val("-1");
            }

            function cargarCompAnio() {
                $("#div_comp").html(spinner);
                $.ajax({
                    type    : "POST",
                    url     : "${createLink(action:'cargarComponentes_ajax')}",
                    data    : {
                        id   : "${proceso.proyectoId}",
                        anio : $("#anio").val()
                    },
                    success : function (msg) {
                        $("#div_comp").html(msg);
                        $("#divAct").html("");
                        $("#divAsg").html("");
//                        $("#spanDevengado").addClass("hidden");
                    }
                });
            }

            $(function () {
                <g:if test="${proceso}">
                getDetalle();
                </g:if>
                cargarCompAnio();

                $("#anio").change(function () {
//                    $("#comp").val("-1");
//                    $("#actividad").val("-1");
//                    $("#asignacion").val("-1");
//                    $("#monto").val("");
//                    $("#devengado").val("");
                    $("#max").html("");

                    cargarCompAnio();
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
                    var monto = $("#monto").val();
                    monto = monto.replace(new RegExp(",", 'g'), "");
                    var devengado = $("#devengado").val();
                    devengado = devengado.replace(new RegExp(",", 'g'), "");
                    var max = $("#max").html();
                    max = max.replace(new RegExp(",", 'g'), "");
                    var asg = $("#asignacion").val();
                    var proceso = "${proceso?.id}";

                    if (isNaN(devengado) || devengado == "") devengado = 0;

                    var msg = "";
                    if (asg == "-1" || isNaN(asg)) {
                        msg += "<br>Debe seleccionar una asignación.";
                    } else {
//                        console.log(devengado)
                        if (isNaN(monto) || monto == "") {
                            msg += "<br>El monto tiene que ser un número positivo.";
                        } else {
                            if (monto * 1 < 0)
                                msg += "<br>El monto tiene que ser un número positivo.";
                            if (monto * 1 > max * 1)
                                msg += "<br>El monto no puede ser mayor al máximo.";
                        }
//                        if (isNaN(devengado) || devengado == "") {
//                            msg += "<br>El monto devengado tiene que ser un número positivo.";
//                        } else {
                        if (devengado * 1 < 0)
                            msg += "<br>El monto devengado tiene que ser un número positivo.";
//                        }
                    }

                    if (msg == "") {
                        $.ajax({
                            type    : "POST",
                            url     : "${createLink(action:'agregarAsignacion')}",
                            data    : {
                                id        : id,
                                proceso   : proceso,
                                monto     : monto,
                                asg       : asg,
                                devengado : devengado
                            },
                            success : function (msg) {
                                getDetalle();
                                vaciar();
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

            });
        </script>

    </body>
</html>