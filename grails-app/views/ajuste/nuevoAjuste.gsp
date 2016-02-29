<%@ page import="vesta.proyectos.MarcoLogico; vesta.poa.Asignacion; vesta.seguridad.Persona; vesta.parametros.poaPac.Anio" contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main">
    %{--<title><elm:tipoReformaStr tipo="Reforma" tipoSolicitud="E"/></title>--}%
    <title>Nuevo Ajuste</title>

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

        <div class="btn-group">
            <a href="#" id="btnAddD" class="btn botonD pull-right ${reforma?.id ?: 'disabled'} botones">
                <i class="fa fa-plus"></i> Actividad
            </a>
        </div>

        <div class="btn-group">
            <a href="#" id="btnAddE" class="btn botonE pull-right ${reforma?.id ?: 'disabled'} botones">
                <i class="fa fa-plus"></i> Techo
            </a>
        </div>
    </div>
</div>


<form id="frmReforma">
    <table class="table table-bordered table-hover table-condensed" style="margin-top: 10px;">
        <thead>
        <tr>
            <th style="width:15%;">Proyecto</th>
            <th style="width:12%;">Componente</th>
            <th style="width:22%;">Actividad</th>
            <th style="width:6%;">Partida</th>
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
                        <td style=width:15%>${det?.componente?.proyecto?.nombre}</td>
                        <td style=width:12%>${det?.componente?.objeto}</td>
                        <td style=width:22%>${det?.asignacionOrigen?.marcoLogico?.numero} - ${det?.asignacionOrigen?.marcoLogico?.objeto}</td>
                        <td style='width:6%' class='text-center'>${det?.asignacionOrigen?.presupuesto?.numero}</td>
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

                        <td style=width:15%>${det?.componente?.proyecto?.nombre}</td>
                        <td style=width:12%>${det?.componente?.objeto}</td>
                        <td style=width:22%>${det?.asignacionOrigen?.marcoLogico?.numero} - ${det?.asignacionOrigen?.marcoLogico?.objeto}</td>
                        <g:if test="${det?.tipoReforma?.codigo == 'P'}">
                            <td style='width:6%' class='text-center'>${det?.presupuesto?.numero}</td>
                        </g:if>
                        <g:else>
                            <td style='width:6%' class='text-center'>${det?.asignacionOrigen?.presupuesto?.numero}</td>
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
                        <td style=width:15%>${det?.componente?.proyecto?.nombre}</td>
                        <td style=width:12%>${det?.componente?.marcoLogico?.objeto}</td>
                        <td style=width:22%>${det?.componente?.numero} - ${det?.componente?.objeto}</td>
                        <td style='width:6%' class='text-center'>${det?.presupuesto?.numero}</td>
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
                <g:if test="${det?.tipoReforma?.codigo == 'A'}" >
                    <tr class="rowD" data-id="${det?.id}" id="detr" data-cod="${det?.tipoReforma?.codigo}" data-par="${det?.asignacionOrigen?.presupuesto?.id}">
                        <td style=width:15%>${det?.componente?.proyecto?.nombre}</td>
                        <td style=width:12%>${det?.componente?.objeto}</td>
                        <td style=width:22%>${det?.descripcionNuevaActividad}</td>
                        <td style='width:6%' class='text-center'>${det?.presupuesto?.numero}</td>
                        <td style='width:8%' class='text-center'>${det?.responsable?.codigo}</td>
                        <td style='width:8%' class='text-center'>${' --- '}</td>
                        <td style='width:9%' class='text-center'>${' --- '}</td>
                        <td style='width:9%' class='text-right'><g:formatNumber number="${det?.valor}" maxFractionDigits="2" minFractionDigits="2" format="##,###"/></td>
                        <td style='width:8%' class='text-right'><g:formatNumber number="${det?.valor}" maxFractionDigits="2" minFractionDigits="2" format="##,###"/></td>
                        <td style=width:3%>
                            <a href='#' class='btn btn-danger btn-xs pull-right borrarTr' title="Borrar"><i class='fa fa-trash-o'></i></a>
                            <a href='#' class='btn btn-success btn-xs pull-right editarTr' title="Editar"><i class='fa fa-pencil'></i></a>
                        </td>
                    </tr>
                    <g:set var="incremento" value="${incremento += det?.valor}"/>
                    <g:set var="montoFinal" value="${montoFinal += det?.valor}"/>
                </g:if>
                <g:if test="${det?.tipoReforma?.codigo == 'N'}">
                    <tr class="rowE" data-id="${det?.id}" id="detr" data-cod="${det?.tipoReforma?.codigo}" data-par="${det?.asignacionOrigen?.presupuesto?.id}">
                        <td style=width:15%>${det?.componente?.proyecto?.nombre}</td>
                        <td style=width:12%>${det?.componente?.marcoLogico?.objeto}</td>
                        <td style=width:22%>${det?.asignacionOrigen?.marcoLogico?.numero} - ${det?.componente?.objeto}</td>
                        <td style='width:6%' class='text-center'>${det?.presupuesto?.numero}</td>
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


<g:if test="${detalle}">
    <table class="table table-bordered table-hover table-condensed" style="margin-top: 10px;">
        <thead>
        <tr>
            <th style="width: 63%;">TOTAL: </th>
            <th style="width: 8%;"><g:formatNumber number="${totalOrigen}" maxFractionDigits="2" minFractionDigits="2" format="##,###"/></th>
            <th style="width: 9%;"><g:formatNumber number="${disminucion}" maxFractionDigits="2" minFractionDigits="2" format="##,###"/></th>
            <th style="width: 9%;"><g:formatNumber number="${incremento}" maxFractionDigits="2" minFractionDigits="2" format="##,###"/></th>
            <g:if test="${totalOrigen != montoFinal}">
                <g:if test="${detalle?.tipoReforma?.codigo?.contains("E") || detalle?.tipoReforma?.codigo?.contains("A") || detalle?.tipoReforma?.codigo?.contains("N") }">
                    <th style="width: 8%;"><g:formatNumber number="${montoFinal}" maxFractionDigits="2" minFractionDigits="2" format="##,###"/></th>
                </g:if>
                <g:else>
                    <th style="width: 8%; color: #ff180a"><g:formatNumber number="${montoFinal}" maxFractionDigits="2" minFractionDigits="2" format="##,###"/></th>
                </g:else>
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

    //guardar reforma

    $("#btnGuardar").click(function () {

        var vacio = $("#concepto").val();
        var anio = $("#anio").val();
        var data = {};

        data.texto = vacio;
        data.anio = anio;
        data.id = '${reforma?.id}';

        if(vacio == '' || vacio == null){
            log("Debe ingresar una justificación para el ajuste!","error")
        }else{
            $.ajax({
                type: 'POST',
                url :"${createLink(controller: 'ajuste', action: 'guardarNuevoAjuste')}",
                data : data,
                success: function (msg){
                    var parts =  msg.split("_");
                    if(parts[0] == 'ok'){
                        log("Ajuste guardado correctamente!","success");

                        setTimeout(function () {
                            location.href = "${createLink(controller:'ajuste',action:'nuevoAjuste')}/" + parts[1];
                        }, 500);

                        $(".botones").removeClass("disabled")
                    } else {
                        log("Ocurrió un error al guardar el ajuste!","error")
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
                                location.href = "${createLink(controller:'ajuste',action:'nuevoAjuste')}/" + '${reforma?.id}';
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
                url     : "${createLink(controller: 'ajuste', action: 'asignacionOrigenAjuste_ajax')}",
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
                                            url: "${createLink(controller: 'reforma', action: 'grabarDetalleA')}",
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
                                                        location.href = "${createLink(controller:'ajuste',action:'nuevoAjuste')}/" + '${reforma?.id}';
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
                url     : "${createLink(controller: 'ajuste', action: 'incrementoAjuste_ajax')}",
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
                                            url: "${createLink(controller: 'reforma', action: 'grabarDetalleB')}",
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
                                                        location.href = "${createLink(controller:'ajuste',action:'nuevoAjuste')}/" + '${reforma?.id}';
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
                url     : "${createLink(controller: 'ajuste', action: 'partidaAjuste_ajax')}",
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
                                            url: "${createLink(controller: 'reforma', action: 'grabarDetalleC')}",
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
                                                        location.href = "${createLink(controller:'ajuste',action:'nuevoAjuste')}/" + '${reforma?.id}';
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
                    }); //dialo
                }
            });
        }
        if(codigoDt == 'A'){
            $.ajax({
                type: 'POST',
                url     : "${createLink(controller: 'ajuste', action: 'actividadAjuste_ajax')}",
                data: {
                    id: detalleId
                },
                success : function (msg) {
                    var b = bootbox.dialog({
                        id    : "dlgPartida",
                        title : '<h3 class="text-info">Actividad de Destino</h3>',
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
                                    if($("#frmNuevaActividad").valid()){

                                        var dataOrigen = {};
                                        dataOrigen.monto = str_replace(",", "", $("#monto").val());
                                        var dataDestino = {};
                                        dataDestino.proyecto_nombre = $("#proyectoDest").find("option:selected").text();
                                        dataDestino.componente_nombre = $("#compDest").find("option:selected").text();
                                        dataDestino.componente_id = $("#compDest").val();
                                        dataDestino.actividad_nombre = $("#actividad_dest").val();
                                        var nume = $("#prsp_id").val().split("-");
                                        dataDestino.partida = nume[0];
                                        dataDestino.partida_id = $("#prsp_hide").val();
                                        dataDestino.responsable = $("#responsable").find("option:selected").text()
                                        dataDestino.responsable_id = $("#responsable").val()
                                        dataDestino.categoria = $("#categoria").val();
                                        dataDestino.fuente = $("#fuente").val()
                                        dataDestino.fi = $("#inicio").val()
                                        dataDestino.ff = $("#fin").val()
                                        resetForm();

                                        $.ajax({
                                            type: 'POST',
                                            url: "${createLink(controller: 'reforma', action: 'grabarDetalleD')}",
                                            data:{
                                                monto: dataOrigen.monto,
                                                componente: dataDestino.componente_id,
                                                actividad: dataDestino.actividad_nombre,
                                                tipoReforma: "A",
                                                reforma: '${reforma?.id}',
                                                partida: dataDestino.partida_id,
                                                categoria: dataDestino.categoria,
                                                fuente: dataDestino.fuente,
                                                inicio: dataDestino.fi,
                                                fin: dataDestino.ff,
                                                responsable: dataDestino.responsable_id,
                                                id: detalleId
                                            },
                                            success: function (msg){
                                                if(msg == 'ok'){
                                                    log("Detalle del ajuste guardado correctamente!","success");
                                                    setTimeout(function () {
                                                        location.href = "${createLink(controller:'ajuste',action:'nuevoAjuste')}/" + '${reforma?.id}';
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
                    }); //dialo
                }
            });
        }
        if(codigoDt == 'N'){
            $.ajax({
                type: 'POST',
                url     : "${createLink(controller: 'ajuste', action: 'techoAjuste_ajax')}",
                data: {
                    id: detalleId
                },
                success : function (msg) {
                    var b = bootbox.dialog({
                        id    : "dlgPartida",
                        title : '<h3 class="text-info">Techo</h3>',
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
                                            url: "${createLink(controller: 'ajuste', action: 'grabarDetalleE')}",
                                            data:{
                                                monto: dataOrigen.monto,
                                                componente: dataDestino.componente_id,
                                                actividad: dataDestino.actividad_id,
//                                                asignacion: dataDestino.asignacion_id,
                                                tipoReforma: "N",
                                                reforma: '${reforma?.id}',
                                                partida: dataDestino.partida_id,
                                                id: detalleId
                                            },
                                            success: function (msg){
                                                if(msg == 'ok'){
                                                    log("Detalle del ajuste guardado correctamente!","success");
                                                    setTimeout(function () {
                                                        location.href = "${createLink(controller:'ajuste',action:'nuevoAjuste')}/" + '${reforma?.id}';
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
                    }); //dialo
                }
            });
        }
    });

    //agregar y guardar asignacion de origen

    $("#btnAddA").click(function () {
        $.ajax({
            type: 'POST',
            url     : "${createLink(controller: 'ajuste', action: 'asignacionOrigenAjuste_ajax')}",
            data    : {
                anio: $("#anio").val()
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
                                    addAsignacionOrigen(dataOrigen, dataDestino);
                                    resetForm();

                                    //grabar detalle reforma

                                    $.ajax({
                                        type: 'POST',
                                        url: "${createLink(controller: 'reforma', action: 'grabarDetalleA')}",
                                        data:{
                                            monto: dataOrigen.monto,
                                            componente: dataDestino.componente_id,
                                            actividad: dataDestino.actividad_id,
                                            asignacion: dataDestino.asignacion_id,
                                            tipoReforma: "O",
                                            reforma: '${reforma?.id}'
                                        },
                                        success: function (msg){
                                            if(msg == 'ok'){
                                                log("Detalle del ajuste guardado correctamente!","success");
                                                setTimeout(function () {
                                                    location.href = "${createLink(controller:'ajuste',action:'nuevoAjuste')}/" + '${reforma?.id}';
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
    });

    //agragar y guardar existente

    $("#btIncremento").click(function () {
        $.ajax({
            type: 'POST',
            url     : "${createLink(controller: 'ajuste', action: 'incrementoAjuste_ajax')}",
            data    : {
                anio: $("#anio").val()
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
                                    addIncremento(dataOrigen, dataDestino);
                                    resetForm();

                                    $.ajax({
                                        type: 'POST',
                                        url: "${createLink(controller: 'reforma', action: 'grabarDetalleB')}",
                                        data:{
                                            monto: dataOrigen.monto,
                                            componente: dataDestino.componente_id,
                                            actividad: dataDestino.actividad_id,
                                            asignacion: dataDestino.asignacion_id,
                                            tipoReforma: "E",
                                            reforma: '${reforma?.id}'
                                        },
                                        success: function (msg){
                                            if(msg == 'ok'){
                                                log("Detalle del ajuste guardado correctamente!","success");
                                                setTimeout(function () {
                                                    location.href = "${createLink(controller:'ajuste',action:'nuevoAjuste')}/" + '${reforma?.id}';
                                                }, 500);
                                            }else{
                                                log("Error al guardar el detalle de ajuste!","error");
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
            url     : "${createLink(controller: 'ajuste', action: 'partidaAjuste_ajax')}",
            data    : {
                anio: $("#anio").val()
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
                                    dataDestino.fuente = $("#fuente").val();
                                    resetForm();

                                    $.ajax({
                                        type: 'POST',
                                        url: "${createLink(controller: 'reforma', action: 'grabarDetalleC')}",
                                        data:{
                                            monto: dataOrigen.monto,
                                            componente: dataDestino.componente_id,
                                            actividad: dataDestino.actividad_id,
                                            tipoReforma: "P",
                                            reforma: '${reforma?.id}',
                                            partida: dataDestino.partida_id,
                                            fuente: dataDestino.fuente,
                                            anio: $("#anio").val()
                                        },
                                        success: function (msg){
                                            if(msg == 'ok'){
                                                log("Detalle del ajuste guardado correctamente!","success");
                                                setTimeout(function () {
                                                    location.href = "${createLink(controller:'ajuste',action:'nuevoAjuste')}/" + '${reforma?.id}';
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
                }); //dialo
            }
        });
    });

    //agregar y guardar actividad
    $("#btnAddD").click(function () {
        $.ajax({
            type: 'POST',
            url     : "${createLink(controller: 'ajuste', action: 'actividadAjuste_ajax')}",
            data    : {
                anio: $("#anio").val()
            },
            success : function (msg) {
                var b = bootbox.dialog({
                    id    : "dlgPartida",
                    title : '<h3 class="text-info">Actividad de Destino</h3>',
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
                                if($("#frmNuevaActividad").valid()){

                                    var dataOrigen = {};
                                    dataOrigen.monto = str_replace(",", "", $("#monto").val());
                                    var dataDestino = {};
                                    dataDestino.proyecto_nombre = $("#proyectoDest").find("option:selected").text();
                                    dataDestino.componente_nombre = $("#compDest").find("option:selected").text();
                                    dataDestino.componente_id = $("#compDest").val();
                                    dataDestino.actividad_nombre = $("#actividad_dest").val();
                                    var nume = $("#prsp_id").val().split("-");
                                    dataDestino.partida = nume[0];
                                    dataDestino.partida_id = $("#prsp_hide").val();
                                    dataDestino.responsable = $("#responsable").find("option:selected").text()
                                    dataDestino.responsable_id = $("#responsable").val()
                                    dataDestino.categoria = $("#categoria").val();
                                    dataDestino.fuente = $("#fuente").val()
                                    dataDestino.fi = $("#inicio").val()
                                    dataDestino.ff = $("#fin").val()
                                    addActividad(dataOrigen, dataDestino);
                                    resetForm();

                                    $.ajax({
                                        type: 'POST',
                                        url: "${createLink(controller: 'reforma', action: 'grabarDetalleD')}",
                                        data:{
                                            monto: dataOrigen.monto,
                                            componente: dataDestino.componente_id,
                                            actividad: dataDestino.actividad_nombre,
                                            tipoReforma: 'A',
                                            reforma: '${reforma?.id}',
                                            partida: dataDestino.partida_id,
                                            categoria: dataDestino.categoria,
                                            fuente: dataDestino.fuente,
                                            inicio: dataDestino.fi,
                                            fin: dataDestino.ff,
                                            responsable: dataDestino.responsable_id,
                                            anio: $("#anio").val()
                                        },
                                        success: function (msg){
                                            if(msg == 'ok'){
                                                log("Detalle del ajuste guardado correctamente!","success");
                                                setTimeout(function () {
                                                    location.href = "${createLink(controller:'ajuste',action:'nuevoAjuste')}/" + '${reforma?.id}';
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
                }); //dialo
            }
        });
    });

    //techo

    $("#btnAddE").click(function () {
        $.ajax({
            type: 'POST',
            url     : "${createLink(controller: 'ajuste', action: 'techoAjuste_ajax')}",
            data    : {
                anio: $("#anio").val()
            },
            success : function (msg) {
                var b = bootbox.dialog({
                    id    : "dlgPartida",
                    title : '<h3 class="text-info">Ajuste por Modificación de Techo</h3> </br> * Dinero sale directamente del proyecto. No necesariamente debe cuadrar.',
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
                                    dataDestino.fuente = $("#fuente").val();
                                    resetForm();

                                    $.ajax({
                                        type: 'POST',
                                        url: "${createLink(controller: 'ajuste', action: 'grabarDetalleE')}",
                                        data:{
                                            monto: dataOrigen.monto,
                                            componente: dataDestino.componente_id,
                                            actividad: dataDestino.actividad_id,
                                            tipoReforma: "N",
                                            reforma: '${reforma?.id}',
                                            partida: dataDestino.partida_id,
                                            fuente: dataDestino.fuente,
                                            anio: $("#anio").val()
                                        },
                                        success: function (msg){
                                            if(msg == 'ok'){
                                                log("Detalle del ajuste guardado correctamente!","success");
                                                setTimeout(function () {
                                                    location.href = "${createLink(controller:'ajuste',action:'nuevoAjuste')}/" + '${reforma?.id}';
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
                }); //dialo
            }
        });
    });

    var cont = 0

    function addAsignacionOrigen(dataOrigen, dataDestino) {
        var data = {origen : dataOrigen, destino : dataDestino};

        var $tabla = $("<table class='table table-bordered table-hover table-condensed tableReforma tableReformaNueva'>");
        var $thead = $("<thead>");
        var $tbody = $("<tbody>");
        var $rowDestino = $("<tr class='info'>");

        var $btn = $("<a href='' class='btn btn-danger btn-xs pull-right'><i class='fa fa-trash-o'></i></a>");
        $btn.click(function () {
            $(this).parents("tr").remove();
            cont--;
//            calcularTotal();
            return false;
        });

        var $tdPrD = $("<td style=width:15%>");
        var $tdCmD = $("<td style=width:16%>");
        var $tdAcD = $("<td style=width:15%>");
        var $tdAsD = $("<td style=width:8% class='text-center'>");
        var $tdReD = $("<td style=width:8%>");
        var $tdViD = $("<td style=width:8% class='text-right'>");
        var $tdDiD = $("<td style=width:9% class='text-right'>");
        var $tdInD = $("<td style=width:9% class='text-center'>");
        var $tdMnD = $("<td style=width:8% class='text-right'>");
        var $tdBtD = $("<td style=width:3% class='text-right'>");

        var total = (parseFloat(dataDestino.inicial.replace(",","")) - parseFloat(dataOrigen.monto));

        $tdPrD.text(dataDestino.proyecto_nombre);
        $tdCmD.text(dataDestino.componente_nombre);
        $tdAcD.text(dataDestino.actividad_nombre);
        $tdAsD.text(dataDestino.partida);
        $tdReD.text('');
        $tdViD.text(number_format(dataDestino.inicial,2,".",","));
        $tdDiD.text(number_format(dataOrigen.monto,2,".",","));
        $tdInD.text(' --- ');
        $tdMnD.text(number_format(total,2,".",","));
        $tdBtD.append($btn);

        $rowDestino.append($tdPrD).append($tdCmD).append($tdAcD).append($tdAsD).append($tdReD).append($tdViD).append($tdDiD).append($tdInD).append($tdMnD).append($tdBtD);
        $tabla.data(data).append($thead).append($tbody).append($rowDestino);
        $("#divReformas").append($tabla);
//        calcularTotal();
    }

    function addIncremento(dataOrigen, dataDestino) {
        var data = {origen : dataOrigen, destino : dataDestino};

        var $tabla = $("<table class='table table-bordered table-hover table-condensed tableReforma tableReformaNueva'>");
        var $thead = $("<thead>");
        var $tbody = $("<tbody>");
        var $rowDestino = $("<tr class='success'>");

        var $btn = $("<a href='' class='btn btn-danger btn-xs pull-right'><i class='fa fa-trash-o'></i></a>");
        $btn.click(function () {
            $(this).parents("tr").remove();
            cont--;
//            calcularTotal();
            return false;
        });

        var $tdPrD = $("<td style=width:15%>");
        var $tdCmD = $("<td style=width:16%>");
        var $tdAcD = $("<td style=width:15%>");
        var $tdAsD = $("<td style=width:8% class='text-center'>");
        var $tdReD = $("<td style=width:8%>");
        var $tdViD = $("<td style=width:8% class='text-right'>");
        var $tdDiD = $("<td style=width:9% class='text-center'>");
        var $tdInD = $("<td style=width:9% class='text-right'>");
        var $tdMnD = $("<td style=width:8% class='text-right'>");
        var $tdBtD = $("<td style=width:3% class='text-center'>");


        var total = (parseFloat(dataDestino.inicial.replace(",","")) + parseFloat(dataOrigen.monto));

        $tdPrD.text(dataDestino.proyecto_nombre);
        $tdCmD.text(dataDestino.componente_nombre);
        $tdAcD.text(dataDestino.actividad_nombre);
        $tdAsD.text(dataDestino.partida);
        $tdReD.text('');
        $tdViD.text(number_format(dataDestino.inicial,2,".",","));
        $tdDiD.text(' --- ');
        $tdInD.text(number_format(dataOrigen.monto,2,".",","));
        $tdMnD.text(number_format(total,2,".",","));
        $tdBtD.append($btn);

        $rowDestino.append($tdPrD).append($tdCmD).append($tdAcD).append($tdAsD).append($tdReD).append($tdViD).append($tdDiD).append($tdInD).append($tdMnD).append($tdBtD);
        $tabla.data(data).append($thead).append($tbody).append($rowDestino);
        $("#divReformas").append($tabla);
//        calcularTotal();
    }

    function addPartida(dataOrigen, dataDestino) {
        var data = {origen : dataOrigen, destino : dataDestino};

        var $tabla = $("<table class='table table-bordered table-hover table-condensed tableReforma tableReformaNueva'>");
        var $thead = $("<thead>");
        var $tbody = $("<tbody>");

        var $rowDestino = $("<tr class='success'>");

        var $btn = $("<a href='' class='btn btn-danger btn-xs pull-right'><i class='fa fa-trash-o'></i></a>");
        $btn.click(function () {
            $(this).parents("tr").remove();
            cont--;
//            calcularTotal();
            return false;
        });

        var $tdPrD = $("<td style=width:15%>");
        var $tdCmD = $("<td style=width:16%>");
        var $tdAcD = $("<td style=width:15%>");
        var $tdAsD = $("<td style=width:8% class='text-center'>");
        var $tdReD = $("<td style=width:8%>");
        var $tdViD = $("<td style=width:8% class='text-right'>");
        var $tdDiD = $("<td style=width:9% class='text-center'>");
        var $tdInD = $("<td style=width:9% class='text-right'>");
        var $tdMnD = $("<td style=width:8% class='text-right'>");
        var $tdBtD = $("<td style=width:3% class='text-right'>");


        var total = (parseFloat(dataDestino.inicial.replace(",","")) + parseFloat(dataOrigen.monto));

        $tdPrD.text(dataDestino.proyecto_nombre);
        $tdCmD.text(dataDestino.componente_nombre);
        $tdAcD.text(dataDestino.actividad_nombre);
        $tdAsD.text(dataDestino.partida);
        $tdReD.text('');
        $tdViD.text(number_format(dataDestino.inicial,2,".",","));
        $tdDiD.text(' --- ');
        $tdInD.text(number_format(dataOrigen.monto,2,".",","));
        $tdMnD.text(number_format(total,2,".",","));
        $tdBtD.append($btn);

        $rowDestino.append($tdPrD).append($tdCmD).append($tdAcD).append($tdAsD).append($tdReD).append($tdViD).append($tdDiD).append($tdInD).append($tdMnD).append($tdBtD);
        $tabla.data(data).append($thead).append($tbody).append($rowDestino);
        $("#divReformas").append($tabla);
//        calcularTotal();
    }

    function addActividad(dataOrigen, dataDestino) {

        var data = {origen : dataOrigen, destino : dataDestino};
        var $tabla = $("<table class='table table-bordered table-hover table-condensed tableReforma tableReformaNueva'>");
        var $thead = $("<thead>");
        var $tbody = $("<tbody>");
        var $rowDestino = $("<tr class='success'>");
        var $btn = $("<a href='' class='btn btn-danger btn-xs pull-right'><i class='fa fa-trash-o'></i></a>");
        $btn.click(function () {
            $(this).parents("tr").remove();
            cont--;
//            calcularTotal();
            return false;
        });

        var $tdPrD = $("<td style='width:15%'>");
        var $tdCmD = $("<td style=width:16%>");
        var $tdAcD = $("<td style=width:15%>");
        var $tdAsD = $("<td style=width:8% class='text-center'>");
        var $tdReD = $("<td style=width:8% class='text-center'>");
        var $tdViD = $("<td style=width:8% class='text-center'>");
        var $tdDiD = $("<td style=width:9% class='text-center'>");
        var $tdInD = $("<td style=width:9% class='text-right'>");
        var $tdMnD = $("<td style=width:8% class='text-right'>");
        var $tdBtD = $("<td style=width:3% class='text-right'>");

        $tdPrD.text(dataDestino.proyecto_nombre);
        $tdCmD.text(dataDestino.componente_nombre);
        $tdAcD.text(dataDestino.actividad_nombre);
        $tdAsD.text(dataDestino.partida);
        $tdReD.text(dataDestino.responsable);
        $tdViD.text(' --- ');
        $tdDiD.text(' --- ');
        $tdInD.text(number_format(dataOrigen.monto,2,".",","));
        $tdMnD.text(number_format(dataOrigen.monto,2,".",","));
        $tdBtD.append($btn);

        $rowDestino.append($tdPrD).append($tdCmD).append($tdAcD).append($tdAsD).append($tdReD).append($tdViD).append($tdDiD).append($tdInD).append($tdMnD).append($tdBtD);
        $tabla.data(data).append($thead).append($tbody).append($rowDestino);
        $("#divReformas").append($tabla);
//        calcularTotal();
    }


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
            if ($("#frmFirmas").valid()) {
                bootbox.confirm("¿Está seguro de querer enviar esta solicitud de ajuste?<br/>Ya no podrá modificar su contenido.",
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
                                    url     : "${createLink(action:'saveNuevoAjuste_ajax')}",
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
    //    });


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