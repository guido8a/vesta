<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 19/03/15
  Time: 12:45 PM
--%>

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
                    <i class="fa fa-bars"></i> Lista de Procesos
                </g:link>
            </div>
        </div>

        <input type="hidden" name="id" value="${proceso?.id}">

        <div class="wizard-container row">
            <div class="col-md-4 wizard-step wizard-next-step corner-left wizard-completed">
                <span class="badge wizard-badge">1</span>
                <g:link action="nuevaSolicitud" id="${proceso.id}">Proceso de aval</g:link>
            </div>

            <div class="col-md-4 wizard-step wizard-next-step wizard-current">
                <span class="badge wizard-badge">2</span> Asignaciones
            </div>

            <g:if test="${monto > 0}">
                <div class="col-md-4 wizard-step corner-right wizard-available">
                    <span class="badge wizard-badge">3</span>
                    <g:link action="solicitudProceso" id="${proceso.id}" title="Continuar sin guardar cambios">
                        Solicitud
                    </g:link>
                </div>
            </g:if>
            <g:else>
                <div class="col-md-4 wizard-step corner-right wizard-not-completed">
                    <span class="badge wizard-badge">3</span> Solicitud
                </div>
            </g:else>
        </div>

        <g:form action="" class="form-horizontal wizard-form corner-bottom" name="frmProceso" role="form" method="POST">
            <g:if test="${!readOnly}">
                <div class="row">
                    <span class="grupo">
                        <label class="col-md-2 control-label">
                            Año
                        </label>

                        <div class="col-md-2">
                            <g:select name="anio" from="${Anio.list([sort: 'anio'])}" value="${actual?.id}" class="form-control input-sm" id="anio" optionKey="id" optionValue="anio"/>
                        </div>
                    </span>

                    <div class="col-md-2"></div>

                    <span class="grupo">
                        <label class="col-md-1 control-label">
                            Asignación
                        </label>

                        <div class="col-md-4" id="divAsg">
                            <g:select name="asignacion" from="${[]}" class="form-control input-sm" id="asignacion" noSelection="['-1': 'Seleccione...']"/>
                        </div>
                    </span>
                </div>

                <div class="row">
                    <span class="grupo">
                        <label class="col-md-2 offset-md-1 control-label">
                            Componente
                        </label>

                        <div class="col-md-4" id="div_comp">
                            <g:if test="${!readOnly}">
                                <g:select name="comp" from="${MarcoLogico.findAllByProyectoAndTipoElemento(proceso?.proyecto, TipoElemento.get(2))}" class="form-control input-sm" optionKey="id" optionValue="objeto" id="comp" noSelection="['-1': 'Seleccione...']"/>
                            </g:if>
                            <g:else>
                                <p class="form-control-static">
                                    ${actual}
                                </p>
                            </g:else>
                        </div>
                    </span>

                    <span class="grupo">
                        <label for="monto" class="col-md-1 control-label">
                            Monto
                        </label>

                        <div class="col-md-2">
                            <div class="input-group">
                                <g:textField class="form-control input-sm number money" name="montoName" style="text-align: right; margin-right: 10px" id="monto"/>
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
                        <label class="col-md-2 control-label">
                            Actividad
                        </label>

                        <div class="col-md-4" id="divAct">
                            <g:select name="actividad" from="${[]}" class="form-control input-sm" id="actividad" noSelection="['-1': 'Seleccione...']"/>
                        </div>
                    </span>

                    <div class="col-md-4 text-right">
                        <a href="#" class="btn btn-success" id="agregar">
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
                        <g:link action="solicitudProceso" id="${proceso.id}" class="btn btn-success">
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
                    url     : "${createLink(action:'getMaximoAsg')}",
                    data    : {
                        id : asg
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
                $("#max").html("");
                $("#asignacion").val("-1");
            }

            %{--function editarAsg(id, max) {--}%
            %{--$.ajax({--}%
            %{--type    : "POST",--}%
            %{--url     : "${createLink(action:'editarAsignacion_ajax')}",--}%
            %{--data    : {--}%
            %{--band : ${band},--}%
            %{--id   : id,--}%
            %{--max  : max--}%
            %{--},--}%
            %{--success : function (msg) {--}%
            %{--var b = bootbox.dialog({--}%
            %{--id    : "dlgCreateEdit",--}%
            %{--title : "Editar asignación",--}%

            %{--class : "modal-lg",--}%

            %{--message : msg,--}%
            %{--buttons : {--}%
            %{--cancelar : {--}%
            %{--label     : "Cancelar",--}%
            %{--className : "btn-primary",--}%
            %{--callback  : function () {--}%
            %{--}--}%
            %{--},--}%
            %{--guardar  : {--}%
            %{--id        : "btnSave",--}%
            %{--label     : "<i class='fa fa-save'></i> Guardar",--}%
            %{--className : "btn-success",--}%
            %{--callback  : function () {--}%

            %{--} //callback--}%
            %{--} //guardar--}%
            %{--} //buttons--}%
            %{--}); //dialog--}%
            %{--setTimeout(function () {--}%
            %{--b.find(".form-control").first().focus()--}%
            %{--}, 500);--}%
            %{--}--}%
            %{--});--}%
            %{--}--}%

            $(function () {
                <g:if test="${proceso}">
                getDetalle();
                </g:if>

                $("#anio").change(function () {
                    $("#comp").val("-1");
                    $("#actividad").val("-1");
                    $("#asignacion").val("-1");
                    $("#monto").val("");
                    $("#max").html("");
                });

                $("#comp").change(function () {
                    $.ajax({
                        type    : "POST",
                        url     : "${createLink(action:'cargarActividades_ajax')}",
                        data    : {
                            id     : $("#comp").val(),
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
                    var max = $("#max").html();
                    max = max.replace(new RegExp(",", 'g'), "");
                    var asg = $("#asignacion").val();
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
                            url     : "${createLink(action:'agregarAsignacion')}",
                            data    : {
                                id      : id,
                                proceso : proceso,
                                monto   : monto,
                                asg     : asg
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