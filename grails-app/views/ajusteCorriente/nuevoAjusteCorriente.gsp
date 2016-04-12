<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 04/04/16
  Time: 12:53 PM
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main">
    <title>Ajuste de gasto permanente</title>

    <style type="text/css">
    .titulo-azul.subtitulo {
        border    : none;
        font-size : 18px;
    }
    td {
        vertical-align : middle;
    }
    .botonC {
        background-color: #dd8404;
        color: seashell;
    }
    .rowC {
        background-color: #dd8404;
    }
    .botonD {
        background-color: #a47680;
        color: seashell;
    }
    .rowD {
        background-color: #a47680;
    }
    .botonE {
        background-color: #9f9edf;
        color: seashell;
    }
    .rowE {
        background-color: #9f9edf;
    }

    </style>

</head>

<body>

<div class="row" style="margin-bottom: 30px;">
    <div class="col-md-1">
        <label>Justificación del ajuste</label>
    </div>
    <div class="col-md-9 grupo">
        <g:textArea name="concepto" class="form-control required" style="height: 60px; resize: none"
                    value="${reforma?.concepto}" maxlength="255" />
    </div>
    <div class="col-md-2">
        <div class="btn-group pull-center" role="group" style="margin-top: 25px">
            <a href="#" id="btnGuardar" class="btn btn-success">
                <i class="fa fa-save"></i> Guardar Ajuste
            </a>
        </div>
    </div>
</div>

<div class="row" style="padding: 10px; background: #DDD; border-radius: 8px;">

    <div class="col-md-1">
        <label for="anio">
            POA Año
        </label>
    </div>
    <div class="col-md-2">
        <g:select from="${anios}" value="${actual.anio}" optionKey="id" optionValue="anio" name="anio"
                  class="form-control input-sm required requiredCombo"/>
    </div>

    <div class="col-md-1"></div>

    <div class="btn-toolbar toolbar">
        <div class="btn-group">
            <a href="#" id="btnAddA" class="btn btn-info pull-right ${reforma?.id ?: 'disabled'} botones">
                <i class="fa fa-plus"></i> Asignación Origen
            </a>
        </div>

        <div class="btn-group">
            <a href="#" id="btIncremento" class="btn btn-success pull-right ${reforma?.id ?: 'disabled'} botones">
                <i class="fa fa-plus"></i> Incremento
            </a>
        </div>

        <div class="btn-group">
            <a href="#" id="btnAddC" class="btn botonC pull-right  ${reforma?.id ?: 'disabled'} botones">
                <i class="fa fa-plus"></i> Partida
            </a>
        </div>
    </div>
</div>

<elm:message tipo="${flash.tipo}" clase="${flash.clase}">${flash.message}</elm:message>

<form id="frmReforma">
    <table class="table table-bordered table-hover table-condensed" style="margin-top: 10px;">
        <thead>
        <tr>
            %{--<th style="width:16%;">Objetivo Gasto Permanente</th>--}%
            <th style="width:16%;">MacroActividad</th>
            <th style="width:16%;">Actividad</th>
            <th style="width:8%;">Tarea</th>
            <th style="width:8%;">Partida</th>
            <th style="width:8%;">Responsable</th>
            <th style="width:8%;">Valor Inicial</th>
            <th style="width:9%;">Disminución</th>
            <th style="width:9%;">Incremento</th>
            <th style="width:8%;">Monto Final</th>
            <th style="width:3%;"></th>
        </tr>
        </thead>
        <tbody class="tablaA">

        </tbody>
    </table>
</form>

<g:set var="totalOrigen" value="${0}"/>
<g:set var="disminucion" value="${0}"/>
<g:set var="incremento" value="${0}"/>
<g:set var="montoFinal" value="${0}"/>

<g:if test="${detalle}">
    <div id="divReformas">
        <g:each in="${detalle}" var="det">
            <table class='table table-bordered table-condensed tableReforma tableReformaNueva'>
                <thead>
                </thead>
                <tbody>

                <g:if test="${det?.tipoReforma?.codigo == 'O'}">
                    <tr class="info" data-id="${det?.id}" id="detr" data-cod="${det?.tipoReforma?.codigo}" data-par="${det?.asignacionOrigen?.id}" data-val="${det?.valor}">
                        <td style=width:15% title="${det?.objetivoGastoCorriente?.descripcion}">${det?.macroActividad?.descripcion}</td>
                        <td style=width:16%>${vesta.poaCorrientes.Tarea.get(det?.tarea).actividad?.descripcion}</td>
                        <td style=width:15%>${vesta.poaCorrientes.Tarea.get(det?.tarea).descripcion}</td>
                        <td style='width:8%' class='text-center'>${det?.asignacionOrigen?.presupuesto?.numero}</td>
                        <td style='width:8%' class='text-center'>${det?.responsable?.codigo}</td>
                        <td style='width:8%' class='text-right'><g:formatNumber number="${det?.valorOrigenInicial}" maxFractionDigits="2" minFractionDigits="2" format="##,###"/></td>
                        <td style='width:9%' class='text-right'><g:formatNumber number="${det?.valor}" maxFractionDigits="2" minFractionDigits="2" format="##,###"/></td>
                        <td style='width:9%' class='text-center'>${' --- '}</td>
                        <td style='width:8%' class='text-right'><g:formatNumber number="${det?.valorOrigenInicial - det?.valor}" maxFractionDigits="2" minFractionDigits="2" format="##,###"/></td>
                        <td style=width:3%>
                            <a href='#' class='btn btn-danger btn-xs pull-right borrarTr' title="Borrar"><i class='fa fa-trash-o'></i></a>
                            <a href='#' class='btn btn-success btn-xs pull-right editarTr' title="Editar"><i class='fa fa-pencil'></i></a>
                        </td>
                    </tr>
                    <g:set var="disminucion" value="${disminucion += det?.valor}"/>
                    <g:set var="montoFinal" value="${montoFinal += (det?.valorOrigenInicial - det?.valor)}"/>
                </g:if>
                <g:if test="${det?.tipoReforma?.codigo == 'E'}">
                    <tr class="success" data-id="${det?.id}" id="detr" data-cod="${det?.tipoReforma?.codigo}" data-par="${det?.asignacionOrigen?.presupuesto?.id}">

                        <td style=width:15% title="${det?.objetivoGastoCorriente?.descripcion}">${det?.macroActividad?.descripcion}</td>
                        <td style=width:16%>${vesta.poaCorrientes.Tarea.get(det?.tarea).actividad?.descripcion}</td>
                        <td style=width:15%>${vesta.poaCorrientes.Tarea.get(det?.tarea).descripcion}</td>
                        <g:if test="${det?.tipoReforma?.codigo == 'P'}">
                            <td style='width:8%' class='text-center'>${det?.presupuesto?.numero}</td>
                        </g:if>
                        <g:else>
                            <td style='width:8%' class='text-center'>${det?.asignacionOrigen?.presupuesto?.numero}</td>
                        </g:else>
                        <td style='width:8%' class='text-center'>${det?.responsable?.codigo}</td>
                        <td style='width:8%' class='text-right'><g:formatNumber number="${det?.valorDestinoInicial}" maxFractionDigits="2" minFractionDigits="2" format="##,###"/></td>
                        <td style='width:9%' class='text-center'>${' --- '}</td>
                        <td style='width:9%' class='text-right'><g:formatNumber number="${det?.valor}" maxFractionDigits="2" minFractionDigits="2" format="##,###"/></td>
                        <td style='width:8%' class='text-right'><g:formatNumber number="${det?.valorDestinoInicial + det?.valor}" maxFractionDigits="2" minFractionDigits="2" format="##,###"/></td>
                        <td style=width:3%>
                            <a href='#' class='btn btn-danger btn-xs pull-right borrarTr' title="Borrar"><i class='fa fa-trash-o'></i></a>
                            <a href='#' class='btn btn-success btn-xs pull-right editarTr' title="Editar"><i class='fa fa-pencil'></i></a>
                        </td>
                    </tr>
                    <g:set var="incremento" value="${incremento += det?.valor}"/>
                    <g:set var="montoFinal" value="${montoFinal += (det?.valorDestinoInicial + det?.valor)}"/>
                </g:if>
                <g:if test="${det?.tipoReforma?.codigo == 'P'}">
                    <tr class="rowC" data-id="${det?.id}" id="detr" data-cod="${det?.tipoReforma?.codigo}" data-par="${det?.asignacionOrigen?.presupuesto?.id}">
                        <td style=width:15% title="${det?.objetivoGastoCorriente?.descripcion}">${det?.macroActividad?.descripcion}</td>
                        <td style=width:16%>${vesta.poaCorrientes.Tarea.get(det?.tarea).actividad?.descripcion}</td>
                        <td style=width:15%>${vesta.poaCorrientes.Tarea.get(det?.tarea).descripcion}</td>
                        <td style='width:8%' class='text-center'>${det?.presupuesto?.numero}</td>
                        <td style='width:8%' class='text-center'>${det?.responsable?.codigo}</td>
                        <td style='width:8%' class='text-right'><g:formatNumber number="${det?.valorDestinoInicial}" maxFractionDigits="2" minFractionDigits="2" format="##,###"/></td>
                        <td style='width:9%' class='text-center'>${' --- '}</td>
                        <td style='width:9%' class='text-right'><g:formatNumber number="${det?.valor}" maxFractionDigits="2" minFractionDigits="2" format="##,###"/></td>
                        <td style='width:8%' class='text-right'><g:formatNumber number="${det?.valorDestinoInicial + det?.valor}" maxFractionDigits="2" minFractionDigits="2" format="##,###"/></td>
                        <td style=width:3%>
                            <a href='#' class='btn btn-danger btn-xs pull-right borrarTr' title="Borrar"><i class='fa fa-trash-o'></i></a>
                            <a href='#' class='btn btn-success btn-xs pull-right editarTr' title="Editar"><i class='fa fa-pencil'></i></a>
                        </td>
                    </tr>
                    <g:set var="incremento" value="${incremento += det?.valor}"/>
                    <g:set var="montoFinal" value="${montoFinal += (det?.valorDestinoInicial + det?.valor)}"/>
                </g:if>
                <g:else>
                </g:else>
                </tbody>
            </table>
            <g:set var="totalOrigen" value="${totalOrigen += (det?.valorDestinoInicial + det?.valorOrigenInicial)}"/>
        </g:each>
    </div>
</g:if>
<g:else>
    <div id="divReformas">
    </div>
</g:else>

%{--</elm:container>--}%

<g:if test="${detalle}">
    <table class="table table-bordered table-hover table-condensed" style="margin-top: 10px;">
        <thead>
        <tr>
            <th style="width: 63%;">TOTAL: </th>
            <th style="width: 8%;"><g:formatNumber number="${totalOrigen}" maxFractionDigits="2" minFractionDigits="2" format="##,###"/></th>
            <th style="width: 9%;"><g:formatNumber number="${disminucion}" maxFractionDigits="2" minFractionDigits="2" format="##,###"/></th>
            <th style="width: 9%;"><g:formatNumber number="${incremento}" maxFractionDigits="2" minFractionDigits="2" format="##,###"/></th>
            %{--<g:if test="${totalOrigen != montoFinal}">--}%
                <g:if test="${Math.round(totalOrigen.toDouble()*100)/100 != Math.round(montoFinal.toDouble()*100)/100}">
            <th style="width: 8%; color: #ff180a"><g:formatNumber number="${montoFinal}" maxFractionDigits="2" minFractionDigits="2" format="##,###"/></th>
            </g:if>
            <g:else>
                <th style="width: 8%;"><g:formatNumber number="${montoFinal}" maxFractionDigits="2" minFractionDigits="2" format="##,###"/></th>
            </g:else>
            <th style="width: 3%;"></th>
        </tr>
        </thead>
    </table>
</g:if>
<g:else>
    <table class="table table-bordered table-hover table-condensed" style="margin-top: 10px;">
        <thead>
        <tr>
            <th style="width: 63%;">TOTAL: </th>
            <th style="width: 8%;"></th>
            <th style="width: 9%;"></th>
            <th style="width: 9%;"></th>
            <th style="width: 8%;"></th>
            <th style="width: 3%;"></th>
        </tr>
        </thead>
    </table>
</g:else>



<form id="frmFirmas">
    <div class="row" style="margin-bottom: 100px; margin-top: 50px">
        <div class="col-md-1">
            <label>Firmas</label>
        </div>

        <div class="col-md-3 grupo">
            <g:if test="${reforma && reforma.estado.codigo == 'D03'}">
                ${reforma.firma1.usuario}
            </g:if>
            <g:else>
                <g:select from="${personas}" optionKey="id" optionValue="${{it.nombre + ' ' + it.apellido}}"
                          noSelection="['': '- Seleccione -']" name="firma1" class="form-control required input-sm"
                          value="${reforma ? reforma.firma1?.usuarioId : ''}"/>
            </g:else>
        </div>

        <div class="col-md-3 grupo">
            <g:if test="${reforma && reforma.estado.codigo == 'D03'}">
                ${reforma.firma2.usuario}
            </g:if>
            <g:else>
                <g:select from="${gerentes}" optionKey="id" optionValue="${{it.nombre + ' ' + it.apellido}}"
                          noSelection="['': '- Seleccione -']" name="firma2" class="form-control required input-sm"
                          value="${reforma ? reforma.firma2?.usuarioId : ''}"/>
            </g:else>
        </div>

        <div class="col-md-5">
            <div class="btn-group pull-right" role="group">
                <elm:linkPdfReforma reforma="${reforma}" class="btn-default" title="Previsualizar" label="true" disabledIfNull="true"/>

                <a href="#" id="btnEnviar" class="btn btn-success ${(detalle?.size() == 0 || detalle == null ) ? 'disabled' : ''}" title="Guardar y enviar">
                    <i class="fa fa-save"></i> Guardar y Enviar <i class="fa fa-paper-plane-o"></i>
                </a>
            </div>
        </div>
    </div>
</form>



<script type="text/javascript">

    //guardar ajuste corriente

    $("#btnGuardar").click(function () {

        var vacio = $("#concepto").val();
        var anio = $("#anio").val();
        var data = {};

        data.texto = vacio;
        data.anio = anio;
        data.id = '${reforma?.id}';

        if(vacio == '' || vacio == null){
            log("Debe ingresar una justificación para el ajuste permanente!","error")
        }else{
            $.ajax({
                type: 'POST',
                url :"${createLink(controller: 'ajusteCorriente', action: 'guardarNuevoAjusteCorriente')}",
                data : data,
                success: function (msg){
                    var parts =  msg.split("_");
                    if(parts[0] == 'ok'){
                        log("Ajuste permanente guardado correctamente!","success");
                        setTimeout(function () {
                            location.href = "${createLink(controller:'ajusteCorriente',action:'nuevoAjusteCorriente')}/" + parts[1];
                        }, 500);
                        $(".botones").removeClass("disabled")
                    } else {
                        log("Ocurrió un error al guardar el ajuste permanente!","error")
                    }
                }
            });
        }
    });

    $(".borrarTr").click(function () {

        var detalleId = $(this).parent().parent().data("id");

        bootbox.confirm("Está seguro de borrar este detalle del ajuste?", function (res) {
            if(res){
                $.ajax({
                    type: 'POST',
                    url: "${createLink(controller: 'reforma', action: 'borrarDetalle')}",
                    data:{
                        detalle: detalleId
                    },
                    success: function (msg){
                        if(msg == 'ok'){
                            log("Detalle del ajuste borrado correctamente!","success");
                            setTimeout(function () {
                                location.href = "${createLink(controller:'ajusteCorriente',action:'nuevoAjusteCorriente')}/" + '${reforma?.id}';
                            }, 500);
                        }else{
                            log("Error al borrar el detalle del ajuste!","error");
                        }
                    }
                });
            }
        });
    });

    $(".editarTr").click(function () {
        var detalleId = $(this).parent().parent().data("id");
        var codigoDt = $(this).parent().parent().data("cod");


        if(codigoDt == 'O'){
            $.ajax({
                type: 'POST',
                url     : "${createLink(controller: 'ajusteCorriente', action: 'origen_ajax')}",
                data : {
                    id: detalleId
                },
                success : function (msg) {
                    var b = bootbox.dialog({
                        id    : "dlgOrigen",
                        title : '<h3 class="text-info">Asignación de Origen</h3>',
                        class : "modal-lg",
                        message : msg,
                        buttons : {
                            cancelar : {
                                label     : "Cancelar",
                                className : "btn-primary",
                                callback  : function () {
                                }
                            },
                            aceptar : {
                                label     : "<i class='fa fa-save'></i> Aceptar",
                                className : "btn-success",
                                callback  : function () {
                                    if($("#frmAsignacion").valid()){
                                        var dataOrigen = {};
                                        dataOrigen.monto = str_replace(",", "", $("#monto").val());
                                        var dataDestino = {};
                                        dataDestino.proyecto_nombre = $("#proyecto").find("option:selected").text();
                                        dataDestino.componente_nombre = $("#comp").find("option:selected").text();
                                        dataDestino.componente_id = $("#comp").val();
                                        dataDestino.actividad_nombre = $("#actividadRf").find("option:selected").text();
                                        dataDestino.actividad_id = $("#actividadRf").val();
                                        dataDestino.asignacion_nombre = $("#asignacion").find("option:selected").text();
                                        var part = $("#asignacion").find("option:selected").text().split(": ");
                                        var partid = part[2].split(",");
                                        var ini = part[1].split(", Partida");
                                        dataDestino.partida = partid[0];
                                        dataDestino.inicial = ini[0];
                                        dataDestino.asignacion_id = $("#asignacion").val();
                                        resetForm();

                                        //grabar detalle reforma
                                        $.ajax({
                                            type: 'POST',
                                            url: "${createLink(controller: 'ajusteCorriente', action: 'grabarDetalleA')}",
                                            data:{
                                                monto: dataOrigen.monto,
                                                componente: dataDestino.componente_id,
                                                actividad: dataDestino.actividad_id,
                                                asignacion: dataDestino.asignacion_id,
                                                tipoReforma: "O",
                                                reforma: '${reforma?.id}',
                                                id: detalleId
                                            },
                                            success: function (msg){
                                                if(msg == 'ok'){
                                                    log("Detalle del ajuste guardado correctamente!","success");
                                                    setTimeout(function () {
                                                        location.href = "${createLink(controller:'ajusteCorriente',action:'nuevoAjusteCorriente')}/" + '${reforma?.id}';
                                                    }, 500);
                                                }else{
                                                    log("Error al guardar el detalle del ajuste!","error");
                                                }
                                            }
                                        });
                                    }
                                    else{
                                        return false;
                                    }
                                }
                            }
                        } //buttons
                    }); //dialog
                }
            });

        }
        if(codigoDt == 'E'){
            $.ajax({
                type: 'POST',
                url     : "${createLink(controller: 'ajusteCorriente', action: 'incrementoCorriente_ajax')}",
                data : {
                    id : detalleId
                },
                success : function (msg) {

                    var b = bootbox.dialog({
                        id    : "dlgIncremento",
                        title : '<h3 class="text-info">Incremento</h3>',
                        class : "modal-lg",
                        message : msg,
                        buttons : {
                            cancelar : {
                                label     : "Cancelar",
                                className : "btn-primary",
                                callback  : function () {
                                }
                            },
                            aceptar : {
                                label     : "<i class='fa fa-save'></i> Aceptar",
                                className : "btn-success",
                                callback  : function () {
                                    if($("#frmIncremento").valid()){
                                        var dataOrigen = {};
                                        dataOrigen.monto = str_replace(",", "", $("#monto").val());
                                        var dataDestino = {};
                                        dataDestino.proyecto_nombre = $("#proyecto").find("option:selected").text();
                                        dataDestino.componente_nombre = $("#comp").find("option:selected").text();
                                        dataDestino.componente_id = $("#comp").val();
                                        dataDestino.actividad_nombre = $("#actividadRf").find("option:selected").text();
                                        dataDestino.actividad_id = $("#actividadRf").val();
                                        dataDestino.asignacion_nombre = $("#asignacion").find("option:selected").text();
                                        var part = $("#asignacion").find("option:selected").text().split(": ");
                                        var partid = part[2].split(",");
                                        var ini = part[1].split(", Partida");
                                        dataDestino.partida = partid[0];
                                        dataDestino.inicial = ini[0];
                                        dataDestino.asignacion_id = $("#asignacion").val();
                                        resetForm();

                                        $.ajax({
                                            type: 'POST',
                                            url: "${createLink(controller: 'ajusteCorriente', action: 'grabarDetalleB')}",
                                            data:{

                                                monto: dataOrigen.monto,
                                                componente: dataDestino.componente_id,
                                                actividad: dataDestino.actividad_id,
                                                asignacion: dataDestino.asignacion_id,
                                                tipoReforma: "E",
                                                reforma: '${reforma?.id}',
                                                id: detalleId

                                            },
                                            success: function (msg){
                                                if(msg == 'ok'){
                                                    log("Detalle del ajuste guardado correctamente!","success");
                                                    setTimeout(function () {
                                                        location.href = "${createLink(controller:'ajusteCorriente',action:'nuevoAjusteCorriente')}/" + '${reforma?.id}';
                                                    }, 500);
                                                }else{
                                                    log("Error al guardar el detalle del ajuste!","error");
                                                }
                                            }
                                        });


                                    }else{
                                        return false
                                    }
                                }
                            }
                        } //buttons
                    }); //dialog
                }
            });
        }
        if(codigoDt == 'P'){

            $.ajax({
                type: 'POST',
                url     : "${createLink(controller: 'ajusteCorriente', action: 'partidaCorriente_ajax')}",
                data: {
                    id: detalleId
                },
                success : function (msg) {
                    var b = bootbox.dialog({
                        id    : "dlgPartida",
                        title : '<h3 class="text-info">Partida de destino</h3>',
                        class : "modal-lg",
                        message : msg,
                        buttons : {
                            cancelar : {
                                label     : "Cancelar",
                                className : "btn-primary",
                                callback  : function () {
                                }
                            },
                            aceptar : {
                                label     : "<i class='fa fa-save'></i> Aceptar",
                                className : "btn-success",
                                callback  : function () {
                                    if($("#frmPartida").valid()){
                                        var dataOrigen = {};
                                        dataOrigen.monto = str_replace(",", "", $("#monto").val());
                                        var dataDestino = {};
                                        dataDestino.proyecto_nombre = $("#proyecto").find("option:selected").text();
                                        dataDestino.componente_nombre = $("#comp").find("option:selected").text();
                                        dataDestino.componente_id = $("#comp").val();
                                        dataDestino.actividad_nombre = $("#actividadRf").find("option:selected").text();
                                        dataDestino.actividad_id = $("#actividadRf").val();
                                        var nume = $("#prsp_id").val().split("-");
                                        dataDestino.partida = nume[0];
                                        dataDestino.partida_id = $("#prsp_hide").val();
                                        dataDestino.asignacion_id = $("#asignacion").val();
                                        resetForm();

                                        $.ajax({
                                            type: 'POST',
                                            url: "${createLink(controller: 'ajusteCorriente', action: 'grabarDetalleC')}",
                                            data:{
                                                monto: dataOrigen.monto,
                                                componente: dataDestino.componente_id,
                                                actividad: dataDestino.actividad_id,
//                                                asignacion: dataDestino.asignacion_id,
                                                tipoReforma: "P",
                                                reforma: '${reforma?.id}',
                                                partida: dataDestino.partida_id,
                                                id: detalleId
                                            },
                                            success: function (msg){
                                                if(msg == 'ok'){
                                                    log("Detalle del ajuste guardado correctamente!","success");
                                                    setTimeout(function () {
                                                        location.href = "${createLink(controller:'ajusteCorriente',action:'nuevoAjusteCorriente')}/" + '${reforma?.id}';
                                                    }, 500);
                                                }else{
                                                    log("Error al guardar el detalle del ajuste!","error");
                                                }
                                            }
                                        });
                                    }else{
                                        return false
                                    }
                                }
                            }
                        } //buttons
                    }); //dialog
                }
            });
        }
    });

    //agregar y guardar asignacion de origen

    $("#btnAddA").click(function () {
        $.ajax({
            type: 'POST',
            url     : "${createLink(controller: 'ajusteCorriente', action: 'origen_ajax')}",
            data    : {
                anio: $("#anio").val()
            },
            success : function (msg) {

                var b = bootbox.dialog({
                    id    : "dlgOrigen",
                    title : '<h3 class="text-info">Asignación de Origen de Gasto Permanente</h3>',
                    class : "modal-lg",
                    message : msg,
                    buttons : {
                        cancelar : {
                            label     : "Cancelar",
                            className : "btn-primary",
                            callback  : function () {
                            }
                        },
                        aceptar : {
                            label     : "<i class='fa fa-save'></i> Aceptar",
                            className : "btn-success",
                            callback  : function () {
                                if($("#frmAsignacion").valid()){
                                    var dataOrigen = {};
                                    dataOrigen.monto = str_replace(",", "", $("#monto").val());
                                    var dataDestino = {};
                                    dataDestino.objetivo_nombre = $("#objetivo").find("option:selected").text();
                                    dataDestino.objetivo_id = $("#objetivo").val();
                                    dataDestino.macro_nombre = $("#mac").find("option:selected").text();
                                    dataDestino.macro_id = $("#mac").val();
                                    dataDestino.actividad_nombre = $("#act").find("option:selected").text();
                                    dataDestino.actividad_id = $("#act").val();
                                    dataDestino.tarea_id = $("#tar").val();
                                    dataDestino.asignacion_id = $("#asg").val();
//                                    addAsignacionOrigen(dataOrigen, dataDestino);
                                    resetForm();

                                    //grabar detalle reforma

                                    $.ajax({
                                        type: 'POST',
                                        url: "${createLink(controller: 'ajusteCorriente', action: 'grabarDetalleA')}",
                                        data:{
                                            monto: dataOrigen.monto,
                                            objetivo: dataDestino.objetivo_id,
                                            macro: dataDestino.macro_id,
                                            actividad: dataDestino.actividad_id,
                                            asignacion: dataDestino.asignacion_id,
                                            tarea: dataDestino.tarea_id,
                                            tipoReforma: "O",
                                            reforma: '${reforma?.id}'
                                        },
                                        success: function (msg){
                                            if(msg == 'ok'){
                                                log("Detalle guardado correctamente!","success");
                                                setTimeout(function () {
                                                    location.href = "${createLink(controller:'ajusteCorriente',action:'nuevoAjusteCorriente')}/" + '${reforma?.id}';
                                                }, 500);
                                            }else{
                                                log("Error al guardar el detalle!","error");
                                            }
                                        }
                                    });
                                }
                                else{
                                    return false;
                                }
                            }
                        }
                    } //buttons
                }); //dialog
            }
        });
    });

    //agregar y guardar existente


    $("#btIncremento").click(function () {
        $.ajax({
            type: 'POST',
            url     : "${createLink(controller: 'ajusteCorriente', action: 'incrementoCorriente_ajax')}",
            data    : {
                anio: $("#anio").val(),
                tipo: "incremento"
            },
            success : function (msg) {

                var b = bootbox.dialog({
                    id    : "dlgIncremento",
                    title : '<h3 class="text-info">Incremento de Gasto Permanente</h3>',
                    class : "modal-lg",
                    message : msg,
                    buttons : {
                        cancelar : {
                            label     : "Cancelar",
                            className : "btn-primary",
                            callback  : function () {
                            }
                        },
                        aceptar : {
                            label     : "<i class='fa fa-save'></i> Aceptar",
                            className : "btn-success",
                            callback  : function () {
                                if($("#frmIncremento").valid()){
                                    var dataOrigen = {};
                                    dataOrigen.monto = str_replace(",", "", $("#monto").val());
                                    var dataDestino = {};
                                    dataDestino.objetivo_nombre = $("#objetivo").find("option:selected").text();
                                    dataDestino.objetivo_id = $("#objetivo").val();
                                    dataDestino.macro_nombre = $("#mac").find("option:selected").text();
                                    dataDestino.macro_id = $("#mac").val();
                                    dataDestino.actividad_nombre = $("#act").find("option:selected").text();
                                    dataDestino.actividad_id = $("#act").val();
                                    dataDestino.tarea_id = $("#tar").val();
                                    dataDestino.asignacion_id = $("#asg").val();

                                    resetForm();

                                    $.ajax({
                                        type: 'POST',
                                        url: "${createLink(controller: 'ajusteCorriente', action: 'grabarDetalleB')}",
                                        data:{
                                            monto: dataOrigen.monto,
                                            objetivo: dataDestino.objetivo_id,
                                            macro: dataDestino.macro_id,
                                            actividad: dataDestino.actividad_id,
                                            asignacion: dataDestino.asignacion_id,
                                            tarea: dataDestino.tarea_id,
                                            tipoReforma: "E",
                                            reforma: '${reforma?.id}'
                                        },
                                        success: function (msg){
                                            if(msg == 'ok'){
                                                log("Detalle guardado correctamente!","success");
                                                setTimeout(function () {
                                                    location.href = "${createLink(controller:'ajusteCorriente',action:'nuevoAjusteCorriente')}/" + '${reforma?.id}';
                                                }, 500);
                                            }else{
                                                log("Error al guardar el detalle!","error");
                                            }
                                        }
                                    });
                                }else{
                                    return false
                                }
                            }
                        }
                    } //buttons
                }); //dialog
            }
        });
    });

    //agregar y guardar partida


    $("#btnAddC").click(function () {
        $.ajax({
            type: 'POST',
            url     : "${createLink(controller: 'ajusteCorriente', action: 'partidaCorriente_ajax')}",
            data    : {
                anio: $("#anio").val()
            },
            success : function (msg) {
                var b = bootbox.dialog({
                    id    : "dlgPartida",
                    title : '<h3 class="text-info">Nueva Partida de Gasto Permanente</h3>',
                    class : "modal-lg",
                    message : msg,
                    buttons : {
                        cancelar : {
                            label     : "Cancelar",
                            className : "btn-primary",
                            callback  : function () {
                            }
                        },
                        aceptar : {
                            label     : "<i class='fa fa-save'></i> Aceptar",
                            className : "btn-success",
                            callback  : function () {
                                if($("#frmPartida").valid()){
                                    var dataOrigen = {};
                                    dataOrigen.monto = str_replace(",", "", $("#monto").val());
                                    var dataDestino = {};
                                    dataDestino.objetivo_nombre = $("#objetivo").find("option:selected").text();
                                    dataDestino.objetivo_id = $("#objetivo").val();
                                    dataDestino.macro_nombre = $("#mac").find("option:selected").text();
                                    dataDestino.macro_id = $("#mac").val();
                                    dataDestino.actividad_nombre = $("#act").find("option:selected").text();
                                    dataDestino.actividad_id = $("#act").val();
                                    dataDestino.tarea_id = $("#tar").val();
                                    dataDestino.asignacion_id = $("#asg").val();
                                    var nume = $("#prsp_id").val().split("-");
                                    dataDestino.partida = nume[0];
                                    dataDestino.partida_id = $("#prsp_hide").val();
                                    dataDestino.fuente = $("#fuente").val();
                                    resetForm();

                                    $.ajax({
                                        type: 'POST',
                                        url: "${createLink(controller: 'ajusteCorriente', action: 'grabarDetalleC')}",
                                        data:{

                                            monto: dataOrigen.monto,
                                            objetivo: dataDestino.objetivo_id,
                                            macro: dataDestino.macro_id,
                                            actividad: dataDestino.actividad_id,
                                            asignacion: dataDestino.asignacion_id,
                                            tarea: dataDestino.tarea_id,
                                            tipoReforma: "P",
                                            reforma: '${reforma?.id}',
                                            partida: dataDestino.partida_id,
                                            fuente: dataDestino.fuente,
                                            anio:  $("#anio").val()

                                        },
                                        success: function (msg){
                                            if(msg == 'ok'){
                                                log("Detalle guardado correctamente!","success");
                                                setTimeout(function () {
                                                    location.href = "${createLink(controller:'ajusteCorriente',action:'nuevoAjusteCorriente')}/" + '${reforma?.id}';
                                                }, 500);
                                            }else{
                                                log("Error al guardar el detalle!","error");
                                            }
                                        }
                                    });
                                }else{
                                    return false
                                }
                            }
                        }
                    } //buttons
                }); //dialo
            }
        });
    });

    function resetForm() {
        $("#proyecto").val("-1");
        $("#divComp").html("");
        $("#divAct").html("");
        $("#divAsg").html("");
        $("#monto").val("");
        $("#max").html("");
    }

    $("#btnEnviar").click(function () {
        if ($(this).hasClass("disabled")) {
            bootbox.alert("Debe agregar detalles antes de enviar la solicitud!")
        } else {
            <g:if test="${Math.round(totalOrigen.toDouble()*100)/100 != Math.round(montoFinal.toDouble()*100)/100}">
            bootbox.alert("La suma del valor inicial de las asignaciones es diferente al valor del monto final!");
            </g:if>
            <g:else>
            if ($("#frmFirmas").valid()) {
                bootbox.confirm("¿Está seguro de querer enviar esta solicitud de ajuste de gasto permanente?<br/>Ya no podrá modificar su contenido.",
                        function (res) {
                            if (res) {
                                openLoader();
                                var data = {};
                                var c = 0;
                                data.firma1 = $("#firma1").val();
                                data.firma2 = $("#firma2").val();
                                data.anio = $("#anio").val();
                                data.concepto = $("#concepto").val();
                                data.id = "${reforma?.id}";
                                data.send = "S";
                                $.ajax({
                                    type    : "POST",
                                    url     : "${createLink(action:'saveNuevoAjusteCorriente_ajax')}",
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
            </g:else>

        }
        return false;
    });

    //VALIDACIONES DE FORMULARIOS y firma

    $("#frmAsignacion #frmIncremento #frmPartida #frmNuevaActividad").validate({
        errorClass: "help-block",
        onfocusout: false,
        errorPlacement: function (error, element) {
            if (element.parent().hasClass("input-group")) {
                error.insertAfter(element.parent());
            } else {
                error.insertAfter(element);
            }
            element.parents(".grupo").addClass('has-error');
        },
        success: function (label) {
            label.parents(".grupo").removeClass('has-error');
            label.remove();
        }
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


</script>


</body>
</html>