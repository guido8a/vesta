<%@ page import="vesta.parametros.Unidad; vesta.parametros.proyectos.TipoMeta; vesta.proyectos.MarcoLogico" contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main"/>
        <title>Asignaciones gasto permanente</title>

        <script type="text/javascript" src="${resource(dir: 'js/plugins/bootstrap-select-1.6.3/dist/js', file: 'bootstrap-select.js')}"></script>
        <link rel="stylesheet" href="${resource(dir: 'js/plugins/bootstrap-select-1.6.3/dist/css', file: 'bootstrap-select.css')}">
 </head>

    <body>

        <div class="btn-group btn-group-sm" role="group" style="width: 850px;">
            <a href="#" id="btnProgramacion" class="btn btn-success" title="Programación"><i class="fa fa-gear"></i> Programación</a>
            <a href="#" id="btnVerTodos" class="btn btn-success" title="Ver todas"><i class="fa fa-search"></i> Ver todas</a>
            <a href="#" id="btnCopiar" class="btn btn-success" title="Copiar asignaciones"><i class="fa fa-copy"></i> Copiar asignaciones</a>
            <a href="#" id="btnReporte" class="btn btn-success" title="Reporte"><i class="fa fa-print"></i> Reporte</a>
            <a href="#" id="btnReporteUnidad" class="btn btn-success" title="Reporte Unidad"><i class="fa fa-print"></i> Reporte por Área</a>
            <a href="#" id="btnReporteExcel" class="btn btn-success" title="Reporte Excel"><i class="fa fa-print"></i> Reporte Excel</a>
            <a href="#" id="btnReporteCompleto" class="btn btn-success" title="Reporte POA Completo"><i class="fa fa-print"></i> Reporte Completo</a>
            <g:if test="${actual?.estadoGp == 0}">
                <a href="#" id="btnAprobar" class="btn btn-success" title="Aprobar POA"><i class="fa fa-check"></i> Aprobar POA</a>
            </g:if>
        </div>

        <div style="margin-top: 15px;">
            <table class="table table-condensed table-bordered table-striped table-hover" style="width: auto;">
                <thead>
                    <tr>
                        <th style="width: 120px;">Año</th>
                        <th style="width: 380px">Objetivo gasto permanente</th>
                        <th style="width: 380px;">Macro Actividad</th>
                    </tr>
                </thead>

                <tr>
                    <td style="width: 120px"><g:select from="${vesta.parametros.poaPac.Anio.list([sort: 'anio'])}" name="anio" optionKey="id" optionValue="anio" class="many-to-one form-control input-sm" value="${actual.id}"/></td>
                    <td style="width: 380px"><g:select from="${objetivos}" id="objetivo" name="objetivo_name" optionKey="id"
                                                       optionValue="descripcion" class="many-to-one form-control input-sm selectpicker "
                                                       noSelection="['-1': 'Seleccione...']" value=""/></td>
                    <td id="tdMacro" style="width: 380px"></td>
                </tr>
            </table>

            <div id="divTotales">

            </div>

        </div>

    <div id="divActividadesTareas">
    <fieldset class="ui-corner-all" style="min-height: 10px;font-size: 11px; align-content: center">
        <legend>
            Actividades y Tareas
            <div class="hidden" style="color: #5cb74c" id="divColor1">
                Editando...
            </div>
        </legend>

        <table class="table table-condensed table-bordered table-striped table-hover" style="width: 100%">
            <thead>
            <tr>
                <th style="width: 450px">Actividad gasto permanente</th>
                <th style="width: 450px">Tarea</th>
                <th style="width: 240px">Acciones</th>
            </tr>
            </thead>
            <tr>
                <td id="tdActividad"></td>
                <td id="tdTarea"></td>
                <td>
                    <div class="btn-group btn-group-sm" role="group" style="width: 240px; align-items: center" id="grupoBotones">
                        <a href="#" id="crearActividad" class="btn btn-primary" title="Crear Actvidad"><i class="fa fa-plus"></i> Crear Actividad</a>
                        <a href="#" id="editarActividad" class="btn btn-success hide" title="Editar Actvidad"><i class="fa fa-pencil"></i> Editar Actividad</a>
                        <a href="#" id="crearTarea" class="btn btn-info" title="Crear Tarea"><i class="fa fa-plus"></i> Crear Tarea</a>
                        <a href="#" id="editarTarea" class="btn btn-success hide" title="Editar Tarea"><i class="fa fa-pencil"></i> Editar Tarea</a>
                    </div>
                </td>
            </tr>
        </table>
    </fieldset>
    </div>


    <fieldset class="ui-corner-all" style="min-height: 10px;font-size: 11px;">
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
                    <th style="width: 350px">Responsable</th>
                    <th style="width: 300px;">Fuente</th>
                    <th style="width: 210px;">Partida</th>
                    <th style="width: 150px;">Presupuesto</th>
                    <th style="width: 100px;"></th>
                </thead>
                <tbody>
                    <tr class="odd">
                        <g:hiddenField name="asignacionId" value=""/>
                        <td>
                            <g:select name="responsable" id="idResponsable" from="${vesta.parametros.UnidadEjecutora.list([sort: 'nombre'])}" optionKey="id" optionValue="nombre" style="width: 350px" class="many-to-one form-control input-sm"/>
                        </td>
                        <td class="fuente">
                            <g:select from="${fuentes}" id="fuente" optionKey="id" optionValue="descripcion" name="fuente" class="fuente many-to-one form-control input-sm" value="" style="width: 300px;"/>
                        </td>
                        <td class="prsp">
                            <g:hiddenField name="partidaHide" id="prsp_hide" value=""/>
                            <g:textField name="partida" id="prsp_id" class="fuente many-to-one form-control input-sm" value=""/>
                        </td>
                        <td class="valor">
                            <g:textField name="valor_name" id="valor" class="form-control input-sm number" style="width: 150px" value=""/>
                        </td>
                        <td>
                            <a href="#" id="btnGuardar" class="btn btn-sm btn-success"><i class="fa fa-plus"></i> Agregar</a>
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
                Detalle asignaciones gasto permanente
            </legend>
            <g:set var="total" value="0"/>
            <table class="table table-condensed table-bordered table-striped table-hover" style="width: auto;">
                <thead>
                    <th style="width: 200px">Responsable</th>
                    <th style="width: 250px">Objetivo</th>
                    <th style="width: 150px">Macro Actividad</th>
                    <th style="width: 150px">Actividad</th>
                    <th style="width: 100px">Tarea</th>
                    <th style="width: 80px">#</th>
                    <th style="width: 100px;">Partida</th>
                    <th style="width: 80px">Fuente</th>
                    <th style="width: 100px">Presupuesto</th>
                    <th style="width: 100px">Acciones</th>
                </thead>
                <tbody id="tdDetalles">

                </tbody>
            </table>
        </fieldset>

        <script type="text/javascript">

            $("#btnAprobar").click(function () {
                bootbox.confirm("Está seguro que desea aprobar el POA?", function (res){
                   if(res){
                           openLoader();
                           $.ajax({
                               type    : "POST",
                               url     : "${createLink(controller: 'anio', action:'aprobarAnioGp')}",
                               data    : {
                                   anio : $("#anio").val()
                               },
                               success : function (msg) {
                                   if (msg != "no") {
                                       log("POA aprobado correctamente","success");
                                       setTimeout(function () {
                                           location.href = "${createLink(action:'asignacionesCorrientesv2')}"
                                       }, 2000);
                                   } else {
                                       log("Ocurrió un error al aprobar el POA","error")
                                   }
                               }
                           });
              }

                });
            });


            $("#prsp_id").click(function(){

                $.ajax({type : "POST", url : "${g.createLink(controller: 'asignacion',action:'buscadorPartidas')}",
                    data     : {
                        tipo: 'corrientes'
                    },
                    success  : function (msg) {
                        var b = bootbox.dialog({
                            id: "dlgPartidas",
                            title: "Buscador Partidas",
                            class   : "modal-lg",
                            message: msg,
                            buttons : {
                                cancelar : {
                                    label : "Cancelar",
                                    className : "btn-primary",
                                    callback  : function () {
                                    }
                                }
                            }
                        })
                    }
                });
            });



            totales($("#objetivo").val(), $("#idResponsable").val());

//            $("#objetivo").selectpicker('val', ['-1']);

            function cargarDetalles(objetivo, unidad) {

                $.ajax({
                    type    : "POST",
                    url     : "${createLink(controller: 'asignacion', action:'tablaDetalles_ajax')}",
                    data    : {
                        anio     : $("#anio").val(),
                        objetivo : objetivo,
                        unidad   : unidad
                    },
                    success : function (msg) {
                        $("#tdDetalles").html(msg);
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

                $("#objetivo").prop('disabled', false);

                $('.selectpicker').selectpicker({
                    width      : "350px",
                    limitWidth : true,
                    style      : "btn-sm"
                });

                function crearProgramacion (id) {
                    $.ajax({
                        type    : "POST",
                        url     : "${createLink(action:'crearProgramacionCorriente',controller:'asignacion')}",
                        data    : {id: id},

                        success : function (msg) {
//                            var parts = msg.split("*");
//                            log(parts[1], parts[0] == "SUCCESS" ? "success" : "error");

                        }
                    });

                }

                $("#objetivo").val("-1");
                $("#objetivo").selectpicker('render');

                $("#idResponsable").change(function () {
                    var unidad = $(this).val();
                    var idObjetivo = $("#objetivo").val();
                    totales(idObjetivo, unidad);
                });

                $("#objetivo").change(function () {
                    $("#tdMacro").html(spinner);
                    var idObjetivo = $("#objetivo").val();
                    var idUnidad = $("#idResponsable").val();
                    cargarDetalles(idObjetivo, idUnidad);
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
//                            $("#crearActividad").removeClass('show').addClass('hide');
                            $("#crearTarea").removeClass('show').addClass('hide');
                            $("#editarActividad").removeClass('show').addClass('hide');
                            $("#editarTarea").removeClass('show').addClass('hide');
                            $("#divActividadesTareas").removeClass("hidden");
                        }
                    });
                    totales(idObjetivo, idUnidad);
                });

                $("#idResponsable").change(function () {
                    var idObjetivo = $("#objetivo").val();
                    var idUnidad = $("#idResponsable").val();
                    cargarDetalles(idObjetivo, idUnidad);
                });

                $("#btnVerTodos").click(function () {
                    $("#objetivo").val(-1);
                    $("#tdMacro").html("");
                    $("#tdActividad").html("");
                    $("#tdTarea").html("");
                    $("#crearActividad").removeClass('show').addClass('hide');
                    $("#crearTarea").removeClass('show').addClass('hide');
                    cargarDetalles("T","U");
                    var idObjetivo = $("#objetivo").val();
                    var idUnidad = $("#idResponsable").val();
                    totales(idObjetivo, idUnidad);
                });

                $("#anio").change(function () {
                    location.href = "${createLink(action: 'asignacionesCorrientesv2')}?anio=" + $(this).val();
                });

                $("#btnGuardar").click(function () {

//                    var rest = parseFloat($("#divRestante").data("res"))
                    var rest = 10000000
                    var objetivo = $("#objetivo").val();
                    var macro = $("#mac").val();
                    var actividad = $("#act").val();
                    var tarea = $("#tar").val();
                    var anio = $("#anio").val();
                    var responsable = $("#idResponsable").val();
                    var asignacion = $("#asignacion_txt").val();
                    var parti = $("#prsp_hide").val();
                    var fuente = $("#fuente").val();
                    var valor = parseFloat($("#valor").val());
                    var prsp_hide = $("#prsp_hide").val();

//                    console.log("restante", rest, "valor: ", valor)

                    if (valor >= rest) {
                        log("Ingrese un valor menor al restante!", "error")
                    } else {
                        if (tarea && tarea != -1) {
//                            if (asignacion != '') {

                                if (prsp_hide != null && prsp_hide != 'null' && prsp_hide != '') {
                                    if (fuente != null) {
                                        if (valor != '') {
                                            $.ajax({
                                                type    : "POST",
                                                url     : "${createLink(action:'guardarAsignacion',controller:'asignacion')}",
                                                data    : "anio=" + anio + "&objetivo=" + objetivo + "&macro=" + macro +
                                                    "&actividad=" + actividad + "&tarea=" + tarea + "&responsable=" + responsable +
                                                    "&asignacion=" + asignacion + "&partida=" + prsp_hide + "&fuente=" + fuente + "&valor=" + valor,
                                                success : function (msg) {
                                                    var parts = msg.split("*");
                                                    log(parts[1], parts[0] == "SUCCESS" ? "success" : "error");
                                                    if (parts[0] == "SUCCESS") {
                                                        $("#asignacion_txt").val('');
                                                        $("#valor").val('');
                                                        cargarDetalles(objetivo,responsable);
                                                        totales(objetivo, responsable);
                                                        crearProgramacion(parts[2]);
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
//                            } else {
//                                log("Ingrese el nombre de la asignación", "error")
//                            }
                        } else {
                            log("Debe seleccionar una tarea", "error")
                        }
                    }

                });

                $("#guardarEditar").click(function () {

//                    var rest = parseFloat($("#divRestante").data("res"))
                    var rest = 10000000

                    //guardar
                    var responsable = $("#idResponsable").val();
                    var asignacion = $("#asignacion_txt").val();
                    var parti = $("#prsp_id").val();
                    var fuente = $("#fuente").val();
                    var valor = parseFloat($("#valor").val());
                    var asigId = $("#asignacionId").val();
                    var actId = $("#act").val();
                    var tarId = $("#tar").val();
                    var objetivo = $("#objetivo").val();
                    var prsp_hide = $("#prsp_hide").val();
//                    alert(valor)
//                    console.log("valor:", valor, "restante:", rest)

                    if (valor >= rest) {
                        log("Ingrese un valor menor al restante!!", "error")
                    } else {

                        if (actId && actId != -1) {
                            if (tarId && tarId != -1) {
//                                if (asignacion != '') {
                                    if (prsp_hide != null && prsp_hide != 'null' && prsp_hide != '') {
                                        if (fuente != null) {
                                            if (valor != '') {
                                                $.ajax({
                                                    type    : "POST",
                                                    url     : "${createLink(action:'guardarAsignacion',controller:'asignacion')}",
                                                    data    : "&responsable=" + responsable + "&asignacion=" + asignacion + "&partida=" + prsp_hide + "&fuente=" + fuente + "&valor=" + valor + "&id=" + asigId
                                                              + "&actividad=" + actId + "&tarea=" + tarId,
                                                    success : function (msg) {
                                                        var parts = msg.split("*");
                                                        log(parts[1], parts[0] == "SUCCESS" ? "success" : "error");
                                                        if (parts[0] == "SUCCESS") {
                                                            estadoAnterior();
                                                            cargarDetalles(objetivo, responsable);
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
//                                } else {
//                                    log("Ingrese el nombre de la asignación", "error")
//                                }
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

                $("#btnCopiar").click(function () {
                    location.href = "${createLink(controller: 'poaCorriente', action: 'copiarPoa')}"
                });


                $("#btnProgramacion").click(function () {
                    location.href = "${createLink(controller: 'asignacion', action: 'programacionAsignacionesCorrientes')}?id=" + $("#idResponsable").val() + "&anio=" + ${actual?.id};
                });

                $("#btnReporte").click(function () {
                    var idObjetivo = $("#objetivo").val();
                    var idUnidad = $("#idResponsable").val();
                    var urlPdf = "${createLink(controller: 'reportes5', action: 'reporteGastoPermanentePdf')}?objetivo=" + idObjetivo + "Wunidad=" + idUnidad + "Wanio=" + ${actual?.id};
                    var pdfFileName = "ReporteGastoPermanente";
                    location.href = "${createLink(controller:'pdf',action:'pdfLink')}?url=" + urlPdf + "&filename=" + pdfFileName;
                });

                $("#btnReporteUnidad").click(function () {
                    var idObjetivo = $("#objetivo").val();
                    var idUnidad = $("#idResponsable").val();
                    var urlPdf = "${createLink(controller: 'reportes5', action: 'reporteGastoPermanenteUnidad')}?objetivo=" + idObjetivo + "Wunidad=" + idUnidad + "Wanio=" + ${actual?.id};
                    var pdfFileName = "reportePoaxArea";
                    location.href = "${createLink(controller:'pdf',action:'pdfLink')}?url=" + urlPdf + "&filename=" + pdfFileName;
                });

                $("#btnReporteExcel").click(function () {
                    var idObjetivo = $("#objetivo").val();
                    var idUnidad = $("#idResponsable").val();
                    location.href =   "${createLink(controller: 'reportes6', action: 'reporteAvalesPermanentesExcel')}?objetivo=" + idObjetivo + "&unidad=" + idUnidad + "&anio=" + ${actual?.id};
                });

                $("#btnReporteCompleto").click(function () {
                    var idObjetivo = $("#objetivo").val();
                    var idUnidad = $("#idResponsable").val();
                    location.href =   "${createLink(controller: 'reportes6', action: 'reporteCompletoPermanente')}?objetivo=" + idObjetivo + "&unidad=" + idUnidad + "&anio=" + ${actual?.id};
                });

            });


            // --- actividades y tareas ---
            $("#editarActividad").click(function () {
                $.ajax({
                    type: "POST",
                    url     : "${createLink(controller: 'asignacion', action:'actividadCreacion_ajax')}",
                    data    : {
                        anio : $("#anio").val(),
                        objetivo: $("#objetivo").val(),
                        macro   : $("#mac").val(),
                        actividad : $("#act").val()

                    },
                    success: function(msg) {
                        bootbox.dialog ({
                            id: "dlgEditarActividad",
                            title: "Editar Actividad",
//                        class: "modal-lg",
                            message: msg,
                            buttons : {
                                cancelar : {
                                    label     : "Cancelar",
                                    className : "btn-primary",
                                    callback  : function () {
                                    }
                                },
                                guardar : {
                                    label     : "Guardar",
                                    className : "btn-success",
                                    callback  : function () {
                                        if($("#creacionActividad").val()){
                                            if($("#metaActividad").val()){
                                                $.ajax({
                                                    type: "POST",
                                                    url     : "${createLink(controller: 'asignacion', action:'guardarActividad_ajax')}",
                                                    data    : {
                                                        id: $("#act").val(),
                                                        anio : $("#anio").val(),
                                                        macro: $("#mac").val(),
                                                        obj: $("#objetivo").val(),
                                                        desc: $("#creacionActividad").val(),
                                                        meta :$("#metaActividad").val()
                                                    },
                                                    success: function(msg) {
                                                        var parts = msg.split("*");
                                                        log(parts[1], parts[0] == "SUCCESS" ? "success" : "error");
                                                        if (parts[0] == "SUCCESS") {
                                                            $("#divColor1").removeClass("show").addClass("hide");
                                                            $("#divColor2").removeClass("show").addClass("hide");
                                                            $("#anio").prop('disabled', false);
                                                            $("#mac").prop('disabled',false);
                                                            $("#objetivo").prop('disabled',false);
                                                            estadoAnterior();
                                                            $.ajax({
                                                                type    : "POST",
                                                                url     : "${createLink(action:'actividad_ajax',controller: 'asignacion')}",
                                                                data    : {
                                                                    id   : $("#mac").val(),
                                                                    anio : $("#anio").val()

                                                                },
                                                                success : function (msg) {
                                                                    $("#tdActividad").html(msg);

                                                                    $("#tdTarea").html("");
                                                                }
                                                            });
                                                        }
                                                    }
                                                })
                                            } else{
                                                log("Ingrese una meta!", "error");
                                                return
                                            }
                                        }else{
                                            log("Ingrese una descripción!", "error");
                                            return
                                        }
                                    }
                                }
                            }
                        })
                    }
                });
            });

            $("#editarTarea").click(function () {
                $.ajax({
                    type: "POST",
                    url     : "${createLink(controller: 'asignacion', action:'tareaCreacion_ajax')}",
                    data    : {
                        anio : $("#anio").val(),
                        objetivo: $("#objetivo").val(),
                        macro   : $("#mac").val(),
                        acti:   $("#act").val(),
                        id : $("#tar").val()
                    },
                    success: function(msg) {
                        bootbox.dialog ({
                            id: "dlgCreartarea",
                            title: "Editar Tarea",
//                        class: "modal-lg",
                            message: msg,
                            buttons : {
                                cancelar : {
                                    label     : "Cancelar",
                                    className : "btn-primary",
                                    callback  : function () {
                                    }
                                },
                                guardar : {
                                    label     : "Guardar",
                                    className : "btn-success",
                                    callback  : function () {
                                        if($("#creacionTarea").val()){
                                            $.ajax({
                                                type: "POST",
                                                url     : "${createLink(controller: 'asignacion', action:'guardarTarea_ajax')}",
                                                data    : {
                                                    actividad: $("#act").val(),
                                                    desc: $("#creacionTarea").val(),
                                                    id: $("#tar").val()

                                                },
                                                success: function(msg) {
                                                    var parts = msg.split("*");
                                                    log(parts[1], parts[0] == "SUCCESS" ? "success" : "error");
                                                    if (parts[0] == "SUCCESS") {
                                                        estadoAnterior();
                                                        $.ajax({
                                                            type    : "POST",
                                                            url     : "${createLink(action:'actividad_ajax',controller: 'asignacion')}",
                                                            data    : {
                                                                id   : $("#mac").val(),
                                                                anio : $("#anio").val()

                                                            },
                                                            success : function (msg) {
                                                                $("#tdActividad").html(msg);
//                                                                $("#tdTarea").html("");
                                                                $.ajax({
                                                                    type    : "POST",
                                                                    url     : "${createLink(action:'tarea_ajax',controller: 'asignacion')}",
                                                                    data    : {
                                                                        id   : $("#act").val()

                                                                    },
                                                                    success : function (msg) {
                                                                        $("#tdTarea").html(msg);
                                                                    }
                                                                });
                                                            }
                                                        });

                                                    }
                                                }
                                            })
                                        }else{
                                            log("Ingrese un nombre!", "error")
                                            return
                                        }
                                    }
                                }
                            }
                        })
                    }
                });

            });

            $("#crearActividad").click(function () {
                if($("#mac").val() != -1){
                    $.ajax({
                        type: "POST",
                        url     : "${createLink(controller: 'asignacion', action:'actividadCreacion_ajax')}",
                        data    : {
                            anio : $("#anio").val(),
                            objetivo: $("#objetivo").val(),
                            macro   : $("#mac").val()

                        },
                        success: function(msg) {
                            bootbox.dialog ({
                                id: "dlgCrearActividad",
                                title: "Crear Actividad",
//                        class: "modal-lg",
                                message: msg,
                                buttons : {
                                    cancelar : {
                                        label     : "Cancelar",
                                        className : "btn-primary",
                                        callback  : function () {
                                        }
                                    },
                                    guardar : {
                                        label     : "Guardar",
                                        className : "btn-success",
                                        callback  : function () {
                                            if($("#creacionActividad").val()){
                                                if($("#metaActividad").val()){
                                                    $.ajax({
                                                        type: "POST",
                                                        url     : "${createLink(controller: 'asignacion', action:'guardarActividad_ajax')}",
                                                        data    : {
                                                            anio : $("#anio").val(),
                                                            macro: $("#mac").val(),
                                                            obj: $("#objetivo").val(),
                                                            desc: $("#creacionActividad").val(),
                                                            meta :$("#metaActividad").val()
                                                        },
                                                        success: function(msg) {
                                                            var parts = msg.split("*");
                                                            log(parts[1], parts[0] == "SUCCESS" ? "success" : "error");
                                                            if (parts[0] == "SUCCESS") {
                                                                $("#divColor1").removeClass("show").addClass("hide");
                                                                $("#divColor2").removeClass("show").addClass("hide");
                                                                $("#anio").prop('disabled', false);
                                                                $("#mac").prop('disabled',false);
                                                                $("#objetivo").prop('disabled',false);
                                                                estadoAnterior();
                                                                $.ajax({
                                                                    type    : "POST",
                                                                    url     : "${createLink(action:'actividad_ajax',controller: 'asignacion')}",
                                                                    data    : {
                                                                        id   : $("#mac").val(),
                                                                        anio : $("#anio").val()

                                                                    },
                                                                    success : function (msg) {
                                                                        $("#tdActividad").html(msg);

                                                                        $("#tdTarea").html("");
                                                                    }
                                                                });
                                                            }
                                                        }
                                                    })
                                                } else{
                                                    log("Ingrese una meta!", "error");
                                                    return
                                                }
                                            }else{
                                                log("Ingrese una descripción!", "error");
                                                return
                                            }


                                        }
                                    }
                                }
                            })
                        }
                    });
                }else{
                    log("Elija una macro actividad!", "error")
                    return
                }

            });


            $("#crearTarea").click(function () {
                if($("#act").val() != -1 || $("#act").val() != '-1'){
                    $.ajax({
                        type: "POST",
                        url     : "${createLink(controller: 'asignacion', action:'tareaCreacion_ajax')}",
                        data    : {
                            anio : $("#anio").val(),
                            objetivo: $("#objetivo").val(),
                            macro   : $("#mac").val(),
                            acti:   $("#act").val()
                        },
                        success: function(msg) {
                            bootbox.dialog ({
                                id: "dlgCreartarea",
                                title: "Crear Tarea",
//                        class: "modal-lg",
                                message: msg,
                                buttons : {
                                    cancelar : {
                                        label     : "Cancelar",
                                        className : "btn-primary",
                                        callback  : function () {
                                        }
                                    },
                                    guardar : {
                                        label     : "Guardar",
                                        className : "btn-success",
                                        callback  : function () {
                                            if($("#creacionTarea").val()){
                                                $.ajax({
                                                    type: "POST",
                                                    url     : "${createLink(controller: 'asignacion', action:'guardarTarea_ajax')}",
                                                    data    : {
                                                        actividad: $("#act").val(),
                                                        desc: $("#creacionTarea").val()

                                                    },
                                                    success: function(msg) {
                                                        var parts = msg.split("*");
                                                        log(parts[1], parts[0] == "SUCCESS" ? "success" : "error");
                                                        if (parts[0] == "SUCCESS") {
                                                            estadoAnterior();
                                                            $.ajax({
                                                                type    : "POST",
                                                                url     : "${createLink(action:'actividad_ajax',controller: 'asignacion')}",
                                                                data    : {
                                                                    id   : $("#mac").val(),
                                                                    anio : $("#anio").val()

                                                                },
                                                                success : function (msg) {
                                                                    $("#tdActividad").html(msg);
//                                                                $("#tdTarea").html("");
                                                                    $.ajax({
                                                                        type    : "POST",
                                                                        url     : "${createLink(action:'tarea_ajax',controller: 'asignacion')}",
                                                                        data    : {
                                                                            id   : $("#act").val()

                                                                        },
                                                                        success : function (msg) {
                                                                            $("#tdTarea").html(msg);
                                                                        }
                                                                    });
                                                                }
                                                            });

                                                        }
                                                    }
                                                })
                                            }else{
                                                log("Ingrese un nombre!", "error")
                                                return
                                            }
                                        }
                                    }
                                }
                            })
                        }
                    });
                }else{
                    log("Seleccione una actividad!", "error");
                    return
                }
            });


            $("#ocultaActv").click(function(){
                $("#divActividadesTareas").toggleClass("hidden")
            });


        </script>

    </body>
</html>