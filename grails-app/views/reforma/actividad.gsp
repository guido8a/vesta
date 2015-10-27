<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 22/04/15
  Time: 09:37 AM
--%>

<%@ page import="vesta.proyectos.Categoria; vesta.parametros.poaPac.Fuente; vesta.seguridad.Persona; vesta.parametros.poaPac.Anio" contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <meta name="layout" content="main">
        <title><elm:tipoReformaStr tipo="Reforma" tipoSolicitud="A"/></title>

        <style type="text/css">
        .titulo-azul.subtitulo {
            border    : none;
            font-size : 18px;
        }

        td {
            vertical-align : middle;
        }
        </style>
    </head>

    <body>

        <g:if test="${reforma &&
                reforma.estado.codigo == "D01" &&
                reforma.observacionesDirector && reforma.observacionesDirector != ''}">
            <div class="alert alert-warning">
                ${reforma.observacionesDirector}
            </div>
        </g:if>


    <!-- botones -->
        <div class="btn-toolbar toolbar">
            <div class="btn-group">
                <g:link action="reformas" class="btn btn-default btnCrear">
                    <i class="fa fa-file-o"></i> Solicitar nueva
                </g:link>
            </div>
        </div>

        <elm:container tipo="horizontal" titulo="${elm.tipoReformaStr(tipo: "Reforma", tipoSolicitud: "A")}">
            <div class="row">
                <div class="col-md-1">
                    <label for="anio">
                        POA Año
                    </label>
                </div>

                <div class="col-md-2">
                    <g:select from="${[actual]}" value="${reforma ? reforma.anioId : actual?.id}" optionKey="id" optionValue="anio" name="anio"
                              class="form-control input-sm required requiredCombo"/>
                </div>

                <div class="col-md-1">
                    <label>
                        Total
                    </label>
                </div>

                <div class="col-md-2" id="divTotal" data-valor="${total}">
                    <g:formatNumber number="${total}" type="currency"/>
                </div>
            </div>

            <form id="frmReforma" style="margin-bottom: 10px;">
                <h3 class="text-info">Asignación de origen</h3>
                <table class="table table-bordered table-hover table-condensed" style="margin-top: 10px;">
                    <thead>
                        <tr>
                            <th style="width:234px;">Proyecto</th>
                            <th style="width:234px;">Componente</th>
                            <th style="width:234px;">Actividad</th>
                            <th style="width:234px;">Asignación</th>
                            <th style="width:195px;">Monto a reducir</th>
                            <th style="width:135px;">Saldo</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr class="info">
                            <td class="grupo">
                                <g:select from="${proyectos}" optionKey="id" optionValue="nombre" name="proyecto" class="form-control input-sm required requiredCombo"
                                          noSelection="['-1': 'Seleccione...']"/>
                            </td>
                            <td class="grupo" id="divComp">
                            </td>
                            <td class="grupo" id="divAct">
                            </td>
                            <td class="grupo" id="divAsg">
                            </td>
                            <td class="grupo">
                                <div class="input-group">
                                    <g:textField type="text" name="monto" class="form-control required input-sm number money"/>
                                    <span class="input-group-addon"><i class="fa fa-usd"></i></span>
                                </div>
                            </td>
                            <td id="max">

                            </td>
                        </tr>
                    </tbody>
                </table>

                <h3 class="text-info">Nueva actividad de destino</h3>

                <div class="row">
                    <div class="col-md-1">
                        <label>Proyecto</label>
                    </div>

                    <div class="col-md-5 grupo">
                        <g:select from="${proyectos2}" optionKey="id" optionValue="nombre" name="proyecto_dest" id="proyectoDest" style="width:100%"
                                  class="form-control required requiredCombo input-sm" noSelection="['-1': 'Seleccione...']"/>
                    </div>

                    <div class="col-md-1">
                        <label>Componente</label>
                    </div>

                    <div class="col-md-5 grupo" id="divComp_dest">

                    </div>
                </div>

                <div class="row">
                    <div class="col-md-1">
                        <label for="actividad_dest">Actividad</label>
                    </div>

                    <div class="col-md-5 grupo">
                        <g:textField name="actividad_dest" class="form-control input-sm required"/>
                    </div>

                    <div class="col-md-1">
                        <label>Partida</label>
                    </div>

                    <div class="col-md-3">
                        %{--<bsc:buscador name="partida" id="prsp_id" controlador="asignacion" accion="buscarPresupuesto" tipo="search"--}%
                                      %{--titulo="Busque una partida" campos="${campos}" clase="required"/>--}%
                        <g:hiddenField name="partidaHide" id="prsp_hide" value="" />

                        <g:textField name="partida" id="prsp_id" class="fuente many-to-one form-control input-sm required" value=""/>
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-1">
                        <label>Fecha Incio</label>
                    </div>

                    <div class="col-md-2 grupo">
                        <elm:datepicker class="form-control input-sm fechaInicio required"
                                        name="fechaInicio"
                                        title="Fecha de inicio de la actividad"
                                        id="inicio"/>

                    </div>

                    <div class="col-md-1">
                        <label>Fecha Fin</label>
                    </div>

                    <div class="col-md-2 grupo">
                        <elm:datepicker class="form-control input-sm fechaFin required"
                                        name="fechaFin"
                                        title="Fecha fin de la actividad"
                                        id="fin"
                                        format="dd-MM-yyyy"/>
                    </div>

                    <div class="col-md-1">
                        <label>Categoría</label>
                    </div>

                    <div class="col-md-2">
                        <g:select from="${Categoria.list([sort: 'descripcion'])}" optionKey="id" optionValue="descripcion" name="categoria"
                                  class="form-control required requiredCombo input-sm" noSelection="['': 'Seleccione...']"/>
                    </div>

                    <div class="col-md-2">
                        <a href="#" id="btnAddReforma" class="btn btn-success pull-right">
                            <i class="fa fa-plus"></i> Agregar
                        </a>
                    </div>
                </div>
            </form>

            <div id="detallesExistentes">
                <g:each in="${detalles}" var="detalle" status="i">
                    <table class='table table-bordered table-hover table-condensed tableReforma tableReformaExistente'
                           data-monto="${detalle.valor}">
                        <thead>
                            <th colspan='5'>
                                Detalle existente ${i + 1}
                                <a href='' class='btn btn-danger btn-xs pull-right btnDeleteDetalle' data-id="${detalle.id}">
                                    <i class='fa fa-trash-o'></i>
                                </a>
                            </th>
                            <tr>
                                <th style='width:234px;'>Proyecto</th>
                                <th style='width:234px;'>Componente</th>
                                <th style='width:234px;'>Actividad</th>
                                <th>Asignación</th>
                                <th style='width:195px;'>Monto</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr class="info">
                                <td>
                                    ${detalle.asignacionOrigen.marcoLogico.proyecto.toStringCompleto()}
                                </td>
                                <td>
                                    ${detalle.asignacionOrigen.marcoLogico.marcoLogico.toStringCompleto()}
                                </td>
                                <td>
                                    ${detalle.asignacionOrigen.marcoLogico.numero} - ${detalle.asignacionOrigen.marcoLogico.toStringCompleto()}
                                </td>
                                <td>
                                    ${detalle.asignacionOrigen}
                                </td>
                                <td class="text-right">
                                    -<g:formatNumber number="${detalle.valor}" type="currency" currencySymbol=""/>
                                </td>
                            </tr>
                            <tr class="success">
                                <td>
                                    ${detalle.componente.proyecto.toStringCompleto()}
                                </td>
                                <td>
                                    ${detalle.componente.toStringCompleto()}
                                </td>
                                <td>
                                    ${detalle.descripcionNuevaActividad}
                                </td>
                                <td>
                                    <strong>Responsable:</strong> ${reforma.persona.unidad}
                                    <strong>Priorizado:</strong> ${detalle.valor}
                                    <strong>Partida Presupuestaria:</strong> ${detalle.presupuesto}
                                    <strong>Año:</strong> ${reforma.anio.anio}
                                </td>
                                <td class="text-right">
                                    <g:formatNumber number="${detalle.valor}" type="currency" currencySymbol=""/>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </g:each>
            </div>

            <div id="divReformas">
            </div>
        </elm:container>

        <form id="frmFirma">
            <div class="row">
                <div class="col-md-1">
                    <label>Justificación de la reforma al POA solicitada</label>
                </div>

                <div class="col-md-11 grupo">
                    <g:textArea name="concepto" class="form-control required" style="height: 100px;" value="${reforma?.concepto}"/>
                </div>
            </div>

            <div class="row" style="margin-bottom: 100px">
                <div class="col-md-1">
                    <label>Pedir revisión de</label>
                </div>

                <div class="col-md-3 grupo">
                    <g:if test="${reforma && reforma.estado.codigo == 'D01'}">
                        ${reforma.director}
                    </g:if>
                    <g:else>
                        <g:select from="${personas}" optionKey="id" optionValue="" id="firma" name="firma"
                                  class="form-control input-sm required" noSelection="['': '- Seleccione -']" value="${reforma ? reforma.directorId : ''}"/>
                    </g:else>
                </div>

                <div class="col-md-4 col-md-offset-4">
                    <div class="btn-group pull-right" role="group">
                        <elm:linkPdfReforma reforma="${reforma}" class="btn-default" title="Previsualizar" label="true" disabledIfNull="true"/>
                        <a href="#" id="btnGuardar" class="btn btn-info" title="Guardar y seguir editando">
                            <i class="fa fa-save"></i> Guardar
                        </a>
                        <a href="#" id="btnEnviar" class="btn btn-success ${detalles.size() == 0 ? 'disabled' : ''}" title="Guardar y solicitar revisión">
                            <i class="fa fa-save"></i> Guardar y Enviar <i class="fa fa-paper-plane-o"></i>
                        </a>
                    </div>
                </div>
            </div>
        </form>

        <script type="text/javascript">


            $("#prsp_id").click(function(){

                $.ajax({type : "POST", url : "${g.createLink(controller: 'asignacion',action:'buscadorPartidasFiltradas')}",
                    data     : {

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

            var cont = 1;

            function addData() {
                $(".tableReformaExistente").each(function () {
                    var data = {
                        origen : {
                            monto : $(this).data("monto")
                        }
                    };
                    $(this).data(data);
                });
            }

            function getMaximo(asg) {
                if ($("#asignacion").val() != "-1") {
                    $.ajax({
                        type    : "POST",
                        url     : "${createLink(action:'getMaximoAsg',controller: 'avales')}",
                        data    : {
                            id : asg
                        },
                        success : function (msg) {
                            var valor = parseFloat(msg);
//                            console.log("valor=", valor);
                            var tot = 0;
                            $(".tableReformaNueva").each(function () {
                                var d = $(this).data();
                                if ("" + d.origen.asignacion_id == "" + asg) {
                                    tot += parseFloat(d.origen.monto);
                                }
                            });
                            var ok = valor - tot;
//                            console.log("tot=", tot);
//                            console.log("utilizable= ", ok);

                            $("#max").html("$" + number_format(ok, 2, ".", ","))
                                    .attr("valor", ok);
                            $("#monto").attr("tdnMax", ok);
                        }
                    });
                }
            }

            function resetForm() {
                $("#proyecto").val("-1");
                $("#divComp").html("");
                $("#divAct").html("");
                $("#divAsg").html("");
                $("#monto").val("");
                $("#max").html("");

                $("#proyectoDest").val("-1");
                $("#divComp_dest").html("");
                $("#actividad_dest").val("");
                $("#bsc-desc-prsp_id").val("");
                $("#prsp_id").val("");
                $("#inicio").val("");
                $("#fin").val("");
                $("#categoria").val("");
            }

            function validarPar(dataOrigen, dataDestino) {
                var ok = true;
//                $(".tableReforma").each(function () {
//                    var d = $(this).data();
//                    if (d.origen.asignacion_id == dataOrigen.asignacion_id && d.destino.asignacion_id == dataDestino.asignacion_id) {
//                        ok = false;
//                        bootbox.alert("No puede seleccionar un par de asignaciones ya ingresados");
//                    } else {
//                        if (d.origen.asignacion_id == dataDestino.asignacion_id || d.destino.asignacion_id == dataOrigen.asignacion_id) {
//                            ok = false;
//                            bootbox.alert("No puede seleccionar una asignación de origen que está listada como destino ni vice versa");
//                        }
//                    }
//                });
                return ok;
            }

            function calcularTotal() {
                var tot = 0;
                $(".tableReforma").each(function () {
                    tot += parseFloat($(this).data().origen.monto);
                });
                if (tot > 0) {
                    $("#btnEnviar").removeClass("disabled");
                } else {
                    $("#btnEnviar").addClass("disabled");
                }
                $("#divTotal").data("valor", tot).text("$" + number_format(tot, 2, ".", ","));
            }

            function addReforma(dataOrigen, dataDestino) {
                var data = {origen : dataOrigen, destino : dataDestino};

                var $tabla = $("<table class='table table-bordered table-hover table-condensed tableReforma tableReformaNueva'>");
                var $thead = $("<thead>");
                var $tbody = $("<tbody>");
                var $rowOrigen = $("<tr class='info'>");
                var $rowDestino = $("<tr class='success'>");

                var $btn = $("<a href='' class='btn btn-danger btn-xs pull-right'><i class='fa fa-trash-o'></i></a>");
                $btn.click(function () {
                    $(this).parents("table").remove();
                    cont--;
                    calcularTotal();
                    return false;
                });

                var $trTitulo = $("<tr>");
                var $thTitulo = $("<th colspan='5'>Detalle " + cont + "</th>");
                $thTitulo.append($btn);
                $thTitulo.appendTo($trTitulo);
                cont++;
                $thead.append($trTitulo);

                var $trHead = $("<tr>");
                $("<th style='width:234px;'>Proyecto</th>").appendTo($trHead);
                $("<th style='width:234px;'>Componente</th>").appendTo($trHead);
                $("<th style='width:234px;'>Actividad</th>").appendTo($trHead);
                $("<th>Asignación</th>").appendTo($trHead);
                $("<th style='width:195px;'>Monto</th>").appendTo($trHead);
                $thead.append($trHead);

                var $tdPrO = $("<td>");
                var $tdCmO = $("<td>");
                var $tdAcO = $("<td>");
                var $tdAsO = $("<td>");
                var $tdMnO = $("<td class='text-right'>");

                var $tdPrD = $("<td>");
                var $tdCmD = $("<td>");
                var $tdAcD = $("<td>");
                var $tdAsD = $("<td>");
                var $tdMnD = $("<td class='text-right'>");

                $tdPrO.text(dataOrigen.proyecto_nombre);
                $tdCmO.text(dataOrigen.componente_nombre);
                $tdAcO.text(dataOrigen.actividad_nombre);
                $tdAsO.text(dataOrigen.asignacion_nombre);
                $tdMnO.text("-" + number_format(dataOrigen.monto, 2, ".", ","));

                $tdPrD.text(dataDestino.proyecto_nombre);
                $tdCmD.text(dataDestino.componente_nombre);
                $tdAcD.text(dataDestino.actividad_nombre);
                $tdAsD.text(dataDestino.asignacion_nombre);
                $tdMnD.text(number_format(dataOrigen.monto, 2, ".", ","));

                $rowOrigen.data(dataOrigen).append($tdPrO).append($tdCmO).append($tdAcO).append($tdAsO).append($tdMnO);
                $rowDestino.data(dataDestino).append($tdPrD).append($tdCmD).append($tdAcD).append($tdAsD).append($tdMnD);

                $tbody.append($rowOrigen).append($rowDestino);

                $tabla.data(data).append($thead).append($tbody);
                $("#divReformas").prepend($tabla);
                calcularTotal();
            }

            $(function () {

                addData();

                $("#frmReforma").validate({
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

                $("#frmFirma").validate({
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

                $(".btnDeleteDetalle").click(function () {
                    var id = $(this).data("id");
                    var $tabla = $(this).parents("table");
                    bootbox.confirm("¿Está seguro de querer eliminar este detalle? Se eliminará permanente de esta reforma.", function (res) {
                        if (res) {
                            $.ajax({
                                type    : "POST",
                                url     : "${createLink(action:'deleteDetalle_ajax')}",
                                data    : {
                                    id : id
                                },
                                success : function (msg) {
                                    var parts = msg.split("*");
                                    log(parts[1], parts[0]);
                                    if (parts[0] == "SUCCESS") {
                                        $tabla.remove();
                                    }
                                    calcularTotal();
                                }
                            });
                        }
                    });
                    return false;
                });

                $("#btnAddReforma").click(function () {
                    if ($("#frmReforma").valid()) {
                        var dataOrigen = {};
                        dataOrigen.proyecto_nombre = $("#proyecto").find("option:selected").text();
                        dataOrigen.componente_nombre = $("#comp").find("option:selected").text();
                        dataOrigen.actividad_nombre = $("#actividadRf").find("option:selected").text();
                        dataOrigen.asignacion_nombre = $("#asignacion").find("option:selected").text();
                        dataOrigen.asignacion_id = $("#asignacion").val();
//                        dataOrigen.monto = $("#monto").val();
                        dataOrigen.monto = str_replace(",", "", $("#monto").val());

                        var dataDestino = {};
                        dataDestino.proyecto_nombre = $("#proyectoDest").find("option:selected").text();
                        dataDestino.componente_nombre = $("#compDest").find("option:selected").text();
                        dataDestino.componente_id = $("#compDest").val();
                        dataDestino.actividad_nombre = $("#actividad_dest").val();
//                        dataDestino.partida_nombre = $("#bsc-desc-prsp_id").val();
                        dataDestino.partida_id = $("#prsp_hide").val();
                        var nombre = $("#prsp_id").val().split("-");
                        dataDestino.partida_nombre = nombre[1]
//                        dataDestino.partida_id = $("#prsp_id").val();

//                        var partidaNum = $.trim(dataDestino.partida_nombre.split("(")[0]);
                        var partidaNum = nombre[0];
                        dataDestino.asignacion_nombre = "Responsable: ${unidad}, Partida: " + partidaNum + ", Monto: " + number_format(dataOrigen.monto, 2, ".", ",");
                        dataDestino.inicio = $("#inicio").val();
                        dataDestino.fin = $("#fin").val();
                        dataDestino.categoria_id = $("#categoria").val();
                        if (validarPar(dataOrigen, dataDestino)) {
                            addReforma(dataOrigen, dataDestino);
                            resetForm();
                        }
                    }
                    return false;
                });

                $("#proyecto").val("-1").change(function () {
                    $("#divComp").html(spinner);
                    $.ajax({
                        type    : "POST",
                        url     : "${createLink(controller: 'modificacionesPoa', action:'componentesProyectoAjuste_ajax')}",
                        data    : {
                            id   : $("#proyecto").val(),
                            anio : $("#anio").val()
                        },
                        success : function (msg) {
                            $("#divComp").html(msg);
                            $("#divAct").html("");
                            $("#divAsg").html("");
                        }
                    });
                });

                $("#proyectoDest").val("-1").change(function () {
                    $("#divComp_dest").html(spinner);
                    $.ajax({
                        type    : "POST",
                        url     : "${createLink(controller: 'modificacionesPoa', action:'componentesProyectoAjuste2_ajax')}",
                        data    : {
                            id      : $("#proyectoDest").val(),
                            anio    : $("#anio").val(),
                            idCombo : "compDest",
                            div     : "divAct_dest"
                        },
                        success : function (msg) {
                            $("#divComp_dest").html(msg);
                            $("#divAct_dest").html("");
                            $("#divAsg_dest").html("");
                        }
                    });
                });

                $("#btnGuardar").click(function () {
                    if ($(this).hasClass("disabled")) {
                        bootbox.alert("Por favor seleccione al menos una asignación de origen y una nueva actividad de destino para la modificación")
                    } else {
                        if ($("#frmFirma").valid()) {
                            openLoader();
                            var data = {};
                            var c = 0;
                            $(".tableReformaNueva").each(function () {
                                var d = $(this).data();
                                data["r" + c] = {};
                                data["r" + c].origen = d.origen.asignacion_id;
                                data["r" + c].monto = d.origen.monto;
                                data["r" + c].componente = d.destino.componente_id;
                                data["r" + c].actividad = d.destino.actividad_nombre;
                                data["r" + c].partida = d.destino.partida_id;
                                data["r" + c].inicio = d.destino.inicio;
                                data["r" + c].fin = d.destino.fin;
                                data["r" + c].categoria = d.destino.categoria_id;
                                c++;
                            });
                            data.firma = $("#firma").val();
                            data.anio = $("#anio").val();
                            data.concepto = $("#concepto").val();
                            data.id = "${reforma?.id}";
                            data.send = "N";
                            $.ajax({
                                type    : "POST",
                                url     : "${createLink(action:'saveActividad_ajax')}",
                                data    : data,
                                success : function (msg) {
                                    var parts = msg.split("*");
                                    log(parts[1], parts[0]);
                                    if (parts[0] == "SUCCESS") {
                                        setTimeout(function () {
                                            location.href = "${createLink(action:'actividad')}/" + parts[2];
                                        }, 2000);
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
                    }
                    return false;
                });

                $("#btnEnviar").click(function () {
                    if ($(this).hasClass("disabled")) {
                        bootbox.alert("Por favor seleccione al menos una asignación de origen y una nueva actividad de destino para la modificación")
                    } else {
                        if ($("#frmFirma").valid()) {
                            bootbox.confirm("¿Está seguro de querer enviar esta solicitud de reforma?<br/>Ya no podrá modificar su contenido.",
                                    function (res) {
                                        if (res) {
                                            openLoader();
                                            var data = {};
                                            var c = 0;
                                            $(".tableReformaNueva").each(function () {
                                                var d = $(this).data();
                                                data["r" + c] = {};
                                                data["r" + c].origen = d.origen.asignacion_id;
                                                data["r" + c].monto = d.origen.monto;
                                                data["r" + c].componente = d.destino.componente_id;
                                                data["r" + c].actividad = d.destino.actividad_nombre;
                                                data["r" + c].partida = d.destino.partida_id;
                                                data["r" + c].inicio = d.destino.inicio;
                                                data["r" + c].fin = d.destino.fin;
                                                data["r" + c].categoria = d.destino.categoria_id;
                                                c++;
                                            });
                                            data.firma = $("#firma").val();
                                            data.anio = $("#anio").val();
                                            data.concepto = $("#concepto").val();
                                            data.id = "${reforma?.id}";
                                            data.send = "S";
                                            $.ajax({
                                                type    : "POST",
                                                url     : "${createLink(action:'saveActividad_ajax')}",
                                                data    : data,
                                                success : function (msg) {
                                                    var parts = msg.split("*");
                                                    log(parts[1], parts[0]);
                                                    if (parts[0] == "SUCCESS") {
                                                        setTimeout(function () {
                                                            location.href = "${createLink(action:'lista')}";
                                                        }, 2000);
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
                                    });
                        }
                    }
                    return false;
                });
            });

        </script>

    </body>
</html>