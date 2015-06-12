<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 22/04/15
  Time: 09:06 AM
--%>

<%@ page import="vesta.proyectos.Categoria; vesta.modificaciones.DetalleReforma; vesta.parametros.poaPac.Fuente; vesta.seguridad.Persona; vesta.parametros.poaPac.Anio" contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <meta name="layout" content="main">
        <title><elm:tipoReformaStr tipo="Ajuste" tipoSolicitud="T"/></title>

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

    <!-- botones -->
        <div class="btn-toolbar toolbar">
            <div class="btn-group">
                <g:link action="ajustes" class="btn btn-default btnCrear">
                    <i class="fa fa-file-o"></i> Solicitar nuevo
                </g:link>
            </div>
        </div>


        <elm:container tipo="horizontal" titulo="${elm.tipoReformaStr(tipo: "Ajuste", tipoSolicitud: "T")}">
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
                <h3 class="text-info">Asignación existente</h3>
                <table class="table table-bordered table-hover table-condensed" style="margin-top: 10px;">
                    <thead>
                        <tr>
                            <th style="width:234px;">Proyecto</th>
                            <th style="width:234px;">Componente</th>
                            <th style="width:234px;">Actividad</th>
                            <th style="width:234px;">Asignación</th>
                            <th style="width:135px;">Tipo</th>
                            <th style="width:195px;">Monto</th>
                            <th></th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
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
                            <td>
                                <p>
                                    <label for="inc">
                                        <input id="inc" class="tipo" data-max="#maxAumento" data-lbl="Incremento" type="radio" name="tipo" value="+" checked/>
                                        Incremento <span id="maxAumento"></span>
                                    </label>
                                </p>

                                <p>
                                    <label for="dec">
                                        <input id="dec" class="tipo" data-max="#max" data-lbl="Decremento" type="radio" name="tipo" value="-"/>
                                        Decremento <span id="max"></span>
                                    </label>
                                </p>
                            </td>
                            <td class="grupo">
                                <div class="input-group">
                                    <g:textField type="text" name="monto"
                                                 class="form-control required input-sm number money"/>
                                    <span class="input-group-addon"><i class="fa fa-usd"></i></span>
                                </div>
                            </td>
                            <td>
                                <a href="#" id="btnAdd" class="btn btn-success pull-right">
                                    <i class="fa fa-plus"></i> Agregar
                                </a>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </form>

            <form id="frmReforma2">
                <h3 class="text-info">Nueva asignación</h3>

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

                    <div class="col-md-5 grupo" id="divAct_dest">

                    </div>

                    <div class="col-md-1">
                        <label>Partida</label>
                    </div>

                    <div class="col-md-3">
                        <bsc:buscador name="partida" id="prsp_id" controlador="asignacion" accion="buscarPresupuesto" tipo="search"
                                      titulo="Busque una partida" campos="${campos}" clase="required"/>
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-1">
                        <label>Fuente</label>
                    </div>

                    <div class="col-md-2 grupo">
                        <g:select name="fuente" from="${Fuente.list([sort: 'descripcion'])}" optionKey="id"
                                  class="form-control required requiredCmb"/>
                    </div>

                    <div class="col-md-1">
                        <label>Monto a aumentar</label>
                    </div>

                    <div class="col-md-2 grupo">
                        <div class="input-group">
                            <g:textField type="text" name="monto_dest"
                                         class="form-control required input-sm number money"/>
                            <span class="input-group-addon"><i class="fa fa-usd"></i></span>
                        </div>
                    </div>

                    <div class="col-md-1">
                        <label>Máximo</label>
                    </div>

                    <div class="col-md-2" id="maxAumento2">

                    </div>

                    <div class="col-md-2">
                        <a href="#" id="btnAdd2" class="btn btn-success pull-right">
                            <i class="fa fa-plus"></i> Agregar
                        </a>
                    </div>
                </div>
            </form>

            <div id="detallesExistentes">
                <g:each in="${detalles}" var="detalle" status="i">
                    <g:set var="det" value="${detalle.value}"/>
                    <g:set var="monto" value="${det.desde.dism > 0 ? det.desde.dism * -1 : det.desde.aum}"/>
                    <table class='table table-bordered table-hover table-condensed tableReforma tableReformaExistente'>
                        <thead>
                            <tr>
                                <th colspan="6">
                                    Detalle existente ${i + 1}
                                    <a href='' class='btn btn-danger btn-xs pull-right btnDeleteDetalle' data-id="${det.desde.id}">
                                        <i class='fa fa-trash-o'></i>
                                    </a>
                                </th>
                            </tr>
                            <tr>
                                <th style="width: 200px;">Proyecto</th>
                                <th style="width: 150px;">Componente</th>
                                <th>Actividad</th>
                                <th style="width: 150px;">Asignación</th>
                                <th style="width: 100px;">Tipo</th>
                                <th style="width: 150px;">Monto</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr
                                    data-monto="${monto}">
                                <td>${det.desde.proyecto}</td>
                                <td>${det.desde.componente}</td>
                                <td>${det.desde.actividad}</td>
                                <td>Monto: ${g.formatNumber(number: det.desde.inicial, type: 'currency', currencySymbol: '')}, Partida: ${det.desde.partida}</td>
                                <td>${det.desde.dism > 0 ? "Disminución" : "Aumento"}</td>
                                <td class="text-right"><g:formatNumber number="${Math.abs(monto)}" type="currency" currencySymbol=""/></td>
                            </tr>
                        </tbody>
                    </table>

                </g:each>
            </div>

            <div style="margin-top: 15px;">
                <table class="table table-bordered table-hover table-condensed">
                    <thead>
                        <tr>
                            <th>Proyecto</th>
                            <th>Componente</th>
                            <th>Actividad</th>
                            <th>Asignación</th>
                            <th>Tipo</th>
                            <th>Monto</th>
                            <th></th>
                        </tr>
                    </thead>
                    <tbody id="divReformas">

                    </tbody>
                </table>
            </div>
        </elm:container>

        <form id="frmFirma">
            <div class="row">
                <div class="col-md-1">
                    <label>Concepto</label>
                </div>

                <div class="col-md-11 grupo">
                    <g:textArea name="concepto" class="form-control required" style="height: 100px;" value="${reforma?.concepto}"/>
                </div>
            </div>

            <div class="row">
                <div class="col-md-1">
                    <label>Firmas</label>
                </div>

                <div class="col-md-3 grupo">
                    <g:if test="${reforma && reforma.estado.codigo == 'D03'}">
                        ${reforma.firma1.usuario}
                    </g:if>
                    <g:else>
                        <g:select from="${personas}" optionKey="id" optionValue="${{
                            it.nombre + ' ' + it.apellido
                        }}" noSelection="['': '- Seleccione -']" name="firma1" class="form-control required input-sm"
                                  value="${reforma ? reforma.firma1?.usuarioId : ''}"/>
                    </g:else>
                </div>

                <div class="col-md-3 grupo">
                    <g:if test="${reforma && reforma.estado.codigo == 'D03'}">
                        ${reforma.firma2.usuario}
                    </g:if>
                    <g:else>
                        <g:select from="${gerentes}" optionKey="id" optionValue="${{
                            it.nombre + ' ' + it.apellido
                        }}" noSelection="['': '- Seleccione -']" name="firma2" class="form-control required input-sm"
                                  value="${reforma ? reforma.firma2?.usuarioId : ''}"/>
                    </g:else>
                </div>

                <div class="col-md-4 col-md-offset-1">
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
                calcularTotal();
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
                            $(".tableReforma").each(function () {
                                var d = $(this).data();
                                if ("" + d.origen.asignacion_id == "" + asg) {
                                    tot += parseFloat(d.origen.monto);
                                }
                            });
                            var ok = valor - tot;
//                            console.log("tot=", tot);
//                            console.log("utilizable= ", ok);

                            $("#max").html("$" + number_format(ok, 2, ".", ","))
                                    .attr("valor", ok).data("max", ok);
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
                $("#maxAumento").html("");
                $("#inc").prop('checked', true);
                $("#dec").prop('checked', false);
            }

            function resetForm2() {
                $("#proyectoDest").val("-1");
                $("#divComp_dest").html("");
                $("#divAct_dest").html("");
                $("#bsc-desc-prsp_id").val("");
                $("#prsp_id").val("");
                $("#monto_dest").val("");
                $("#maxAumento2").html("");
            }

            function validar(dataOrigen) {
                var ok = true;
                var max = parseFloat($("#max").data("max"));
                var total = 0;
                $(".tableReforma").each(function () {
                    var d = $(this).data();
                    var v = str_replace(",", "", d.origen.monto);
                    total += parseFloat(v);
                    if (dataOrigen.asignacion_id == d.origen.asignacion_id) {
                        ok = false;
                    }
                });
                if (!ok) {
                    bootbox.alert("No puede seleccionar 2 veces la misma asignación");
                }
                return ok;
            }

            function validar2(dataOrigen) {
                var ok = true;
//                var max = parseFloat($("#max").data("max"));
//                var total = 0;
//                $(".tableReforma").each(function () {
//                    var d = $(this).data();
//                    var v = str_replace(",", "", d.origen.monto);
//                    total += parseFloat(v);
//                    if (dataOrigen.asignacion_id == d.origen.asignacion_id) {
//                        ok = false;
//                    }
//                });
//                if (!ok) {
//                    bootbox.alert("No puede seleccionar 2 veces la misma asignación");
//                }
                return ok;
            }

            function calcularTotal() {
                var tot = 0;
                $(".tableReforma").each(function () {
                    tot += parseFloat($(this).data().origen.monto);
                });
                if (tot > 0) {
                    $("#btnSave").removeClass("disabled");
                } else {
                    $("#btnSave").addClass("disabled");
                }
                $("#divTotal").data("valor", tot).text("$" + number_format(tot, 2, ".", ","));
            }

            function addReforma(dataOrigen) {
//                console.log(dataOrigen);
                var data = {origen : dataOrigen};

                var $rowDestino = $("<tr class='tableReforma tableReformaNueva'>");

                var $btn = $("<a href='' class='btn btn-danger btn-xs pull-right'><i class='fa fa-trash-o'></i></a>");
                $btn.click(function () {
                    $(this).parents("tr").remove();
                    cont--;
                    calcularTotal();
                    return false;
                });

                var $tdP = $("<td>");
                var $tdC = $("<td>");
                var $tdA = $("<td>");
                var $tdS = $("<td>");
                var $tdT = $("<td>");
                var $tdM = $("<td class='text-right'>");
                var $tdB = $("<td>");

                $tdP.text(dataOrigen.proyecto_nombre);
                $tdC.text(dataOrigen.componente_nombre);
                $tdA.text(dataOrigen.actividad_nombre);
                $tdS.text(dataOrigen.asignacion_nombre);
                $tdT.text(dataOrigen.tipo_nombre);
                $tdM.text(number_format(dataOrigen.monto, 2, ".", ","));
                $tdB.append($btn);

                $rowDestino.data(data).append($tdP).append($tdC).append($tdA).append($tdS).append($tdT).append($tdM).append($tdB);

                $("#divReformas").prepend($rowDestino);
                calcularTotal();
            }

            function addReforma2(dataOrigen) {
//                console.log(dataOrigen);
                var data = {origen : dataOrigen};

                var $rowDestino = $("<tr class='tableReforma tableReformaNueva'>");

                var $btn = $("<a href='' class='btn btn-danger btn-xs pull-right'><i class='fa fa-trash-o'></i></a>");
                $btn.click(function () {
                    $(this).parents("tr").remove();
                    cont--;
                    calcularTotal();
                    return false;
                });

                var $tdP = $("<td>");
                var $tdC = $("<td>");
                var $tdA = $("<td>");
                var $tdS = $("<td>");
                var $tdT = $("<td>");
                var $tdM = $("<td class='text-right'>");
                var $tdB = $("<td>");

                $tdP.text(dataOrigen.proyecto_nombre);
                $tdC.text(dataOrigen.componente_nombre);
                $tdA.text(dataOrigen.actividad_nombre);
                $tdS.text(dataOrigen.partida_nombre);
                $tdT.text(dataOrigen.tipo_nombre);
                $tdM.text(number_format(dataOrigen.monto, 2, ".", ","));
                $tdB.append($btn);

                $rowDestino.data(data).append($tdP).append($tdC).append($tdA).append($tdS).append($tdT).append($tdM).append($tdB);

                $("#divReformas").prepend($rowDestino);
                calcularTotal();
            }

            $(function () {

                addData();

                $("#frmReforma").validate({
                    errorClass     : "help-block",
                    onfocusout     : false,
                    rules          : {
                        monto : {
                            tdnMax : function () {
                                var $checked = $(".tipo:checked");
                                var $max = $($checked.data("max"));
                                var max = $max.data("max");
//                                console.log($checked, $max, max);
//                                console.log($("#monto"), $(".tipo"), $(".tipo:checked"), $("#max").data("max"), $("#maxAumento").data("max"));
                                return max;
                            }
                        }
                    },
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

                $("#frmReforma2, #frmFirma").validate({
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
                    var $tabla = $(this).parents("tr");
                    bootbox.confirm("¿Está seguro de querer eliminar este detalle? Se eliminará permantente de esta reforma.", function (res) {
                        if (res) {
                            $.ajax({
                                type    : "POST",
                                url     : "${createLink(controller:'reforma',action:'deleteDetalle_ajax')}",
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

                $("#btnAdd").click(function () {
                    if ($("#frmReforma").valid()) {
                        var dataOrigen = {};
                        dataOrigen.proyecto_nombre = $("#proyecto").find("option:selected").text();
                        dataOrigen.componente_nombre = $("#comp").find("option:selected").text();
                        dataOrigen.actividad_nombre = $("#actividad").find("option:selected").text();
                        dataOrigen.asignacion_nombre = $("#asignacion").find("option:selected").text();
                        dataOrigen.asignacion_id = $("#asignacion").val();
                        dataOrigen.monto = str_replace(",", "", $("#monto").val());
                        dataOrigen.tipo_nombre = $(".tipo:checked").data("lbl");
                        dataOrigen.tipo_id = $(".tipo:checked").val();

                        if (dataOrigen.tipo_id == "-") {
                            dataOrigen.monto = "-" + dataOrigen.monto;
                        }

                        if (validar(dataOrigen)) {
                            addReforma(dataOrigen);
                            resetForm();
                        }
                    }
                    return false;
                });

                $("#btnAdd2").click(function () {
                    if ($("#frmReforma2").valid()) {
                        var dataOrigen = {};
                        dataOrigen.proyecto_nombre = $("#proyectoDest").find("option:selected").text();
                        dataOrigen.componente_nombre = $("#compDest").find("option:selected").text();
                        dataOrigen.actividad_nombre = $("#actividad_dest").find("option:selected").text();
                        dataOrigen.actividad_id = $("#actividad_dest").val();
                        dataOrigen.partida_nombre = $("#bsc-desc-prsp_id").val();
                        dataOrigen.partida_id = $("#prsp_id").val();
                        dataOrigen.monto = str_replace(",", "", $("#monto_dest").val());
                        dataOrigen.tipo_nombre = "Incremento";
                        dataOrigen.tipo_id = "+";
                        dataOrigen.fuente_nombre = $("#fuente").find("option:selected").text();
                        dataOrigen.fuente_id = $("#fuente").val();

                        if (validar2(dataOrigen)) {
                            addReforma2(dataOrigen);
                            resetForm2();
                        }
                    }
                    return false;
                });

                $("#proyecto").val("-1").change(function () {
                    var id = $("#proyecto").val();
                    $("#divComp").html(spinner);
                    $.ajax({
                        type    : "POST",
                        url     : "${createLink(controller: 'modificacionesPoa', action:'componentesProyectoAjuste_ajax')}",
                        data    : {
                            id   : id,
                            anio : $("#anio").val()
                        },
                        success : function (msg) {
                            $("#divComp").html(msg);
                            $("#divAct").html("");
                            $("#divAsg").html("");
                            $("#max").html("").data("max", 0);
                        }
                    });
                    $.ajax({
                        type    : "POST",
                        url     : "${createLink( action:'validarTecho_ajax')}",
                        data    : {
                            id   : id,
                            anio : $("#anio").val()
                        },
                        success : function (msg) {
                            var parts = msg.split("|");
                            var valor = parseFloat(parts[0]);
                            var priorizado = parseFloat(parts[1]);
                            var maxAumento = valor - priorizado;

                            $(".tableReforma").each(function () {
                                var data = $(this).data();
                                if (data.origen.tipo_id == "+") {
                                    maxAumento -= parseFloat(data.origen.monto);
                                } else {
                                    if (maxAumento > 0) {
                                        maxAumento -= parseFloat(data.origen.monto); //este es negativo asiq suma
                                    }
                                }
                            });
                            $("#maxAumento").text("$" + number_format(maxAumento, 2, ".", ",")).data("max", maxAumento);
                        }
                    });
                });

                $("#proyectoDest").val("-1").change(function () {
                    $("#divComp_dest").html(spinner);
                    var id = $("#proyectoDest").val();
                    $.ajax({
                        type    : "POST",
                        url     : "${createLink(controller: 'modificacionesPoa', action:'componentesProyectoAjuste2_ajax')}",
                        data    : {
                            id      : id,
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
                    $.ajax({
                        type    : "POST",
                        url     : "${createLink( action:'validarTecho_ajax')}",
                        data    : {
                            id   : id,
                            anio : $("#anio").val()
                        },
                        success : function (msg) {
                            var parts = msg.split("|");
                            var valor = parseFloat(parts[0]);
                            var priorizado = parseFloat(parts[1]);
                            var maxAumento = valor - priorizado;

                            $(".tableReforma").each(function () {
                                var data = $(this).data();
                                if (data.origen.tipo_id == "+") {
                                    maxAumento -= parseFloat(data.origen.monto);
                                } else {
                                    if (maxAumento > 0) {
                                        maxAumento -= parseFloat(data.origen.monto); //este es negativo asiq suma
                                        console.log("2", maxAumento);
                                    }
                                }
                            });
                            $("#maxAumento2").text("$" + number_format(maxAumento, 2, ".", ","));
                            $("#monto_dest").attr("tdnMax", maxAumento);
                        }
                    });
                });

                $("#btnGuardar").click(function () {
                    openLoader();
                    var data = {};
                    var c = 0;
                    $(".tableReformaNueva").each(function () {
                        var d = $(this).data();
                        data["r" + c] = {};
                        data["r" + c].asignacion = d.origen.asignacion_id;
                        data["r" + c].monto = d.origen.monto;
                        data["r" + c].tipo = d.origen.tipo_id;
                        data["r" + c].actividad = d.origen.actividad_id;
                        data["r" + c].partida = d.origen.partida_id;
                        data["r" + c].fuente = d.origen.fuente_id;

                        c++;
                    });
                    data.firma1 = $("#firma1").val();
                    data.firma2 = $("#firma2").val();
                    data.anio = $("#anio").val();
                    data.concepto = $("#concepto").val();
                    data.id = "${reforma?.id}";
                    data.send = "N";
                    $.ajax({
                        type    : "POST",
                        url     : "${createLink(action:'saveTecho_ajax')}",
                        data    : data,
                        success : function (msg) {
                            var parts = msg.split("*");
                            log(parts[1], parts[0]);
                            if (parts[0] == "SUCCESS") {
                                setTimeout(function () {
                                    location.href = "${createLink(action:'techo')}/" + parts[2];
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
                    return false;
                });

                $("#btnEnviar").click(function () {
                    if ($(this).hasClass("disabled")) {
                        bootbox.alert("Por favor seleccione al menos un grupo de asignaciones para la modificación")
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
                                                data["r" + c].asignacion = d.origen.asignacion_id;
                                                data["r" + c].monto = d.origen.monto;
                                                data["r" + c].tipo = d.origen.tipo_id;
                                                data["r" + c].actividad = d.origen.actividad_id;
                                                data["r" + c].partida = d.origen.partida_id;
                                                data["r" + c].fuente = d.origen.fuente_id;

                                                c++;
                                            });
                                            data.firma1 = $("#firma1").val();
                                            data.firma2 = $("#firma2").val();
                                            data.anio = $("#anio").val();
                                            data.concepto = $("#concepto").val();
                                            data.id = "${reforma?.id}";
                                            data.send = "S";
                                            $.ajax({
                                                type    : "POST",
                                                url     : "${createLink(action:'saveTecho_ajax')}",
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