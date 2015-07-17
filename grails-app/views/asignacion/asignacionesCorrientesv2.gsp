<%--
  Created by IntelliJ IDEA.
  User: fabricio
  Date: 19/06/15
  Time: 03:23 PM
--%>

<%@ page import="vesta.parametros.Unidad; vesta.parametros.proyectos.TipoMeta; vesta.proyectos.MarcoLogico" contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main"/>
        <title>Asignaciones gastos corrientes</title>
    </head>

    <body>

        <div class="btn-group btn-group-sm" role="group" style="width: 300px;">
            <a href="#" id="btnProgramacion" class="btn btn-success" title="Programación"><i class="fa fa-gear"></i> Programación
            </a>
            <a href="#" id="btnVerTodos" class="btn btn-success" title="Ver todas"><i class="fa fa-search"></i> Ver todas
            </a>
            <a href="#" id="btnReporte" class="btn btn-success" title="Reporte"><i class="fa fa-print"></i> Reporte</a>
        </div>

        <div style="margin-top: 15px;">
            <table class="table table-condensed table-bordered table-striped table-hover" style="width: auto;">
                <thead>
                    <tr>
                        <th style="width: 120px;">Año</th>
                        <th style="width: 380px">Objetivo gasto corriente</th>
                        <th style="width: 380px;">Macro Actividad</th>
                    </tr>
                </thead>

                <tr>
                    <td style="width: 120px"><g:select from="${vesta.parametros.poaPac.Anio.list([sort: 'anio'])}" name="anio" optionKey="id" optionValue="anio" class="many-to-one form-control input-sm" value="${actual.id}"/></td>

                    <td style="width: 380px"><g:select from="${objetivos}" id="objetivo" name="objetivo_name" optionKey="id" optionValue="descripcion" class="many-to-one form-control input-sm " noSelection="['-1': 'Seleccione...']"/></td>

                    <td id="tdMacro" style="width: 380px"></td>
                </tr>
            </table>

            <div id="divTotales">

            </div>

        </div>

        <div id="divActividadesTareas"></div>



        <fieldset class="ui-corner-all" style="min-height: 110px;font-size: 11px;">
            <legend id="titulo2">
                Ingreso de datos
                <div class="hide" style="color: #5cb74c" id="divColor2">
                    Editando...
                </div>
            </legend>

            <div id="divIngreso">

            </div>

            <table class="table table-condensed table-bordered table-striped table-hover" style="width: auto;">
                <thead>
                    <th style="width: 250px">Responsable</th>
                    <th style="width: 270px">Asignación</th>
                    <th style="width: 210px;">Partida</th>
                    <th style="width: 150px;">Fuente</th>
                    <th style="width: 100px;">Presupuesto</th>
                    <th style="width: 100px;"></th>
                </thead>
                <tbody>

                    <tr class="odd">
                        <g:hiddenField name="asignacionId" value=""/>
                        <td>
                            <g:select name="responsable" id="idResponsable" from="${vesta.parametros.UnidadEjecutora.list()}" optionKey="id" optionValue="nombre" style="width: 250px" class="many-to-one form-control input-sm"/>
                        </td>
                        <td class="actividad">
                            <g:textArea name="asignacion_name" style="width: 270px;height: 60px; resize: none" id="asignacion_txt" maxlength="150" class="form-control input-sm"/>
                        </td>

                        <td class="prsp">
                            <bsc:buscador name="partida" id="prsp_id" controlador="asignacion" accion="buscarPresupuesto" tipo="search"
                                          titulo="Busque una partida" campos="${campos}" clase="required" style="width:100%;"/>
                        </td>
                        <td class="fuente">
                            <g:select from="${fuentes}" id="fuente" optionKey="id" optionValue="descripcion" name="fuente" class="fuente many-to-one form-control input-sm" value="" style="width: 150px;"/>
                        </td>

                        <td class="valor">
                            <g:textField name="valor_name" id="valor" class="form-control input-sm number" style="width: 100px" value=""/>
                        </td>
                        <td>
                            <a href="#" id="btnGuardar" class="btn btn-sm btn-success"><i class="fa fa-plus"></i> Agregar
                            </a>

                            <div class="btn-group btn-group-xs" role="group" style="width: 100px;">
                                <a href="#" id="guardarEditar" class="btn btn-success hide" title="Guardar"><i class="fa fa-save"></i>
                                </a>
                                <a href="#" id="cancelarEditar" class="btn btn-danger hide" title="Cancelar edición"><i class="fa fa-remove"></i>Cancelar
                                </a>
                            </div>

                        </td>
                    </tr>
                </tbody>
            </table>

        </fieldset>

        <fieldset class="ui-corner-all" style="min-height: 100px;font-size: 11px">

            <legend>
                Detalle asignaciones gasto corriente
            </legend>
            <g:set var="total" value="0"/>
            <table class="table table-condensed table-bordered table-striped table-hover" style="width: auto;">
                <thead>
                    <th style="width: 200px">Responsable</th>
                    <th style="width: 250px">Objetivo</th>
                    <th style="width: 250px">Macro Actividad</th>
                    <th style="width: 250px">Asignación</th>
                    <th style="width: 250px;">Partida</th>
                    <th style="width: 80px">Fuente</th>
                    <th style="width: 100px">Presupuesto</th>
                    <th style="width: 100px">Acciones</th>
                </thead>
                <tbody id="tdDetalles">

                </tbody>
            </table>
        </fieldset>

        <script type="text/javascript">

            totales($("#objetivo").val(), $("#idResponsable").val());

            function cargarDetalles(objetivo) {

                $.ajax({
                    type    : "POST",
                    url     : "${createLink(controller: 'asignacion', action:'tablaDetalles_ajax')}",
                    data    : {
                        anio     : $("#anio").val(),
                        objetivo : objetivo
                    },
                    success : function (msg) {
                        $("#tdDetalles").html(msg);
                    }
                });
            }

            function cargarActividadesTareas(macro) {
                $.ajax({
                    type    : "POST",
                    url     : "${createLink(controller: 'asignacion', action:'actividadesTareas_ajax')}",
                    data    : {
                        anio  : $("#anio").val(),
                        macro : macro
                    },
                    success : function (msg) {
                        $("#divActividadesTareas").html(msg);
                    }
                });
            }

            function totales(objetivo, unidad) {
                $.ajax({
                    type    : "POST",
                    url     : "${createLink(controller: 'asignacion', action:'totalObjetivo_ajax')}",
                    data    : {
                        objetivo : objetivo,
                        anio     : $("#anio").val(),
                        unidad   : unidad

                    },
                    success : function (msg) {
                        $("#divTotales").html(msg);

                    }
                });
            }

            function estadoAnterior() {
                //estado anterior
                $("#btnVerTodos").addClass('show');
                $("#divColor1").removeClass("show").addClass("hide");
                $("#divColor2").removeClass("show").addClass("hide");
                $("#guardarEditar").removeClass("show").addClass('hide');
                $("#cancelarEditar").removeClass("show").addClass('hide');
                $("#btnGuardar").addClass('show');
                $("#anio").prop('disabled', false);
                $("#mac").prop('disabled', false);
                $("#objetivo").prop('disabled', false);
                $("#crearActividad").removeClass('hide').addClass('show');
                $("#crearTarea").removeClass('hide').addClass('show');
                $("#asignacion_txt").val('');
                $("#valor").val('');
                $("#editarActividad").removeClass('show').addClass('hide')
                $("#editarTarea").removeClass('show').addClass('hide')
            }

            $(function () {

                $("#idResponsable").change(function () {
                    var unidad = $(this).val();
                    var idObjetivo = $("#objetivo").val();
                    totales(idObjetivo, unidad);
                });

                $("#objetivo").change(function () {
                    $("#tdMacro").html(spinner);
                    var idObjetivo = $("#objetivo").val();
                    var idUnidad = $("#idResponsable").val();
                    cargarDetalles(idObjetivo);
                    $.ajax({
                        type    : "POST",
                        url     : "${createLink(controller: 'asignacion', action:'macro_ajax')}",
                        data    : {
                            objetivo     : $("#objetivo").val(),
                            asignaciones : "S"
                        },
                        success : function (msg) {
                            $("#tdMacro").html(msg);
                            $("#tdActividad").html("");
                            $("#tdTarea").html("");
                            $("#crearActividad").removeClass('show').addClass('hide');
                            $("#crearTarea").removeClass('show').addClass('hide');
                            $("#editarActividad").removeClass('show').addClass('hide');
                            $("#editarTarea").removeClass('show').addClass('hide');
                        }
                    });
                    totales(idObjetivo, idUnidad);
                });

                $("#btnVerTodos").click(function () {
                    $("#objetivo").val(-1);
                    $("#tdMacro").html("");
                    $("#tdActividad").html("");
                    $("#tdTarea").html("");
                    $("#crearActividad").removeClass('show').addClass('hide');
                    $("#crearTarea").removeClass('show').addClass('hide');
                    cargarDetalles("T");
                    var idObjetivo = $("#objetivo").val();
                    var idUnidad = $("#idResponsable").val();
                    totales(idObjetivo, idUnidad);
                });

                $("#anio").change(function () {
                    location.href = "${createLink(action: 'asignacionesCorrientesv2')}?anio=" + $(this).val();
                });

                $("#btnGuardar").click(function () {

                    var rest = $("#divRestante").data("res")
                    var objetivo = $("#objetivo").val();
                    var macro = $("#mac").val();
                    var actividad = $("#act").val();
                    var tarea = $("#tar").val();
                    var anio = $("#anio").val();
                    var responsable = $("#idResponsable").val();
                    var asignacion = $("#asignacion_txt").val();
                    var parti = $("#prsp_id").val();
                    var fuente = $("#fuente").val();
                    var valor = $("#valor").val();

                    if (valor >= rest) {
                        log("Ingrese un valor menor al restante!", "error")
                    } else {
                        if (tarea && tarea != -1) {
                            if (asignacion != '') {
                                if (parti != null && parti != 'null') {
                                    if (fuente != null) {
                                        if (valor != '') {
                                            $.ajax({
                                                type    : "POST",
                                                url     : "${createLink(action:'guardarAsignacion',controller:'asignacion')}",
                                                data    : "anio=" + anio + "&objetivo=" + objetivo + "&macro=" + macro + "&actividad=" + actividad + "&tarea=" + tarea + "&responsable=" + responsable +
                                                          "&asignacion=" + asignacion + "&partida=" + parti + "&fuente=" + fuente + "&valor=" + valor,
                                                success : function (msg) {
                                                    var parts = msg.split("*");
                                                    log(parts[1], parts[0] == "SUCCESS" ? "success" : "error");
                                                    if (parts[0] == "SUCCESS") {
                                                        $("#asignacion_txt").val('');
                                                        $("#valor").val('');
                                                        cargarDetalles(objetivo);
                                                        totales(objetivo, responsable);
                                                    }
                                                }
                                            });
                                        } else {
                                            log("Debe ingresar un valor", "error")
                                        }
                                    } else {
                                        log("Debe seleccionar una fuente", "error")
                                    }
                                } else {
                                    log("Debe seleccionar una partida", "error")
                                }
                            } else {
                                log("Ingrese el nombre de la asignación", "error")
                            }
                        } else {
                            log("Debe seleccionar una tarea", "error")
                        }
                    }

                });

                $("#guardarEditar").click(function () {

                    var rest = $("#divRestante").data("res")

                    //guardar
                    var responsable = $("#idResponsable").val();
                    var asignacion = $("#asignacion_txt").val();
                    var parti = $("#prsp_id").val();
                    var fuente = $("#fuente").val();
                    var valor = $("#valor").val();
                    var asigId = $("#asignacionId").val();
                    var actId = $("#act").val();
                    var tarId = $("#tar").val();
                    var objetivo = $("#objetivo").val();

                    if (valor >= rest) {
                        log("Ingrese un valor menor al restante!", "error")
                    } else {

                        if (actId && actId != -1) {
                            if (tarId && tarId != -1) {
                                if (asignacion != '') {
                                    if (parti != null && parti != 'null') {
                                        if (fuente != null) {
                                            if (valor != '') {
                                                $.ajax({
                                                    type    : "POST",
                                                    url     : "${createLink(action:'guardarAsignacion',controller:'asignacion')}",
                                                    data    : "&responsable=" + responsable + "&asignacion=" + asignacion + "&partida=" + parti + "&fuente=" + fuente + "&valor=" + valor + "&id=" + asigId
                                                              + "&actividad=" + actId + "&tarea=" + tarId,
                                                    success : function (msg) {
                                                        var parts = msg.split("*");
                                                        log(parts[1], parts[0] == "SUCCESS" ? "success" : "error");
                                                        if (parts[0] == "SUCCESS") {
                                                            estadoAnterior();
                                                            cargarDetalles(objetivo);
                                                            totales(objetivo, responsable);
                                                        }
                                                    }
                                                });
                                            } else {
                                                log("Debe ingresar un valor", "error")
                                            }
                                        } else {
                                            log("Debe seleccionar una fuente", "error")
                                        }
                                    } else {
                                        log("Debe seleccionar una partida", "error")
                                    }
                                } else {
                                    log("Ingrese el nombre de la asignación", "error")
                                }
                            } else {
                                log("Debe seleccionar una tarea", "error")
                            }
                        } else {
                            log("Debe seleccionar una actividad", "error")
                        }

                    }
                });

                $("#cancelarEditar").click(function () {
                    estadoAnterior();

                });

            });
        </script>

    </body>
</html>