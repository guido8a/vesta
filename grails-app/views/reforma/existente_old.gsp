<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 14/04/15
  Time: 03:31 PM
--%>

<%@ page import="vesta.parametros.poaPac.Anio" contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <meta name="layout" content="main">
        <title>Modificación a asignación existente</title>

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

        <elm:container tipo="horizontal" titulo="Modificación a asignación existente">

            <div class="row">
                <div class="col-md-1">
                    <label for="anio">
                        POA Año
                    </label>
                </div>

                <div class="col-md-2">
                    <g:select from="${Anio.list([sort: 'anio'])}" value="${actual?.id}" optionKey="id" optionValue="anio" name="anio"
                              class="form-control input-sm required requiredCombo"/>
                </div>

                <div class="col-md-1">
                    <label>
                        T. origen
                    </label>
                </div>

                <div class="col-md-2" id="divTotalOrigen" data-valor="${totalOrigen}">
                    <g:formatNumber number="${totalOrigen}" type="currency"/>
                </div>

                <div class="col-md-1">
                    <label>
                        T. destino
                    </label>
                </div>

                <div class="col-md-2" id="divTotalDestino" data-valor="${totalDestino}">
                    <g:formatNumber number="${totalDestino}" type="currency"/>
                </div>

                <div class="col-md-1">
                    <label>
                        Restante
                    </label>
                </div>

                <div class="col-md-2" id="divRestante" data-valor="${totalOrigen - totalDestino}">
                    <g:formatNumber number="${totalOrigen - totalDestino}" type="currency"/>
                </div>
            </div>

            <form id="frmOrigen">
                <div class="titulo-azul subtitulo text-info">Agregar asignación de origen</div>
                <table class="table table-bordered table-hover table-condensed" style="margin-top: 10px;">
                    <thead>
                        <tr>
                            <th style="width:234px;">Proyecto</th>
                            <th style="width:234px;">Componente</th>
                            <th style="width:234px;">Actividad</th>
                            <th style="width:234px;">Asignación</th>
                            <th style="width:195px;">Monto</th>
                            <th style="width:135px;">Máximo</th>
                            <th></th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr class="info">
                            <td>
                                <g:select from="${proyectos}" optionKey="id" optionValue="nombre" name="proyecto" class="form-control input-sm required requiredCombo"
                                          noSelection="['-1': 'Seleccione...']"/>
                            </td>
                            <td id="divComp">
                            </td>
                            <td id="divAct">
                            </td>
                            <td id="divAsg">
                            </td>
                            <td>
                                <div class="input-group">
                                    <g:textField type="text" name="monto"
                                                 class="form-control required input-sm number money"/>
                                    <span class="input-group-addon"><i class="fa fa-usd"></i></span>
                                </div>
                            </td>
                            <td id="max">

                            </td>
                            <td>
                                <a href="#" class="btn btn-sm btn-info" id="btnAddOrigen" title="Agregar asignación de origen">
                                    <i class="fa fa-plus"></i>
                                </a>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </form>

            <form id="frmDestino">
                <div class="titulo-azul subtitulo text-success">Agregar asignación de destino</div>
                <table class="table table-bordered table-hover table-condensed" style="margin-top: 10px;">
                    <thead>
                        <tr>
                            <th style="width:234px;">Proyecto</th>
                            <th style="width:234px;">Componente</th>
                            <th style="width:234px;">Actividad</th>
                            <th style="width:234px;">Asignación</th>
                            <th style="width:195px;">Monto</th>
                            <th style="width:135px;">Máximo</th>
                            <th></th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr class="success">
                            <td>
                                <g:select from="${proyectos2}" optionKey="id" optionValue="nombre" name="proyecto_dest" id="proyectoDest" style="width:100%"
                                          class="form-control required requiredCombo input-sm" noSelection="['-1': 'Seleccione...']"/>
                            </td>
                            <td id="divComp_dest">
                            </td>
                            <td id="divAct_dest">
                            </td>
                            <td id="divAsg_dest">
                            </td>
                            <td>
                                <div class="input-group">
                                    <g:textField type="text" name="monto_dest" class="form-control required input-sm number money" max="${totalOrigen}"/>
                                    <span class="input-group-addon"><i class="fa fa-usd"></i></span>
                                </div>
                            </td>
                            <td id="tdTotalDestino">
                                <g:formatNumber number="${totalDestino}" type="currency"/>
                            </td>
                            <td>
                                <a href="#" class="btn btn-sm btn-success" id="btnAddDestino" title="Agregar asignación de destino">
                                    <i class="fa fa-plus"></i>
                                </a>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </form>

            <div class="titulo-azul subtitulo text-info">Asignaciones de origen</div>
            <table class="table table-bordered table-hover table-condensed" style="margin-top: 10px;">
                <thead>
                    <tr>
                        <th style="width:234px;">Proyecto</th>
                        <th style="width:234px;">Componente</th>
                        <th style="width:234px;">Actividad</th>
                        <th style="width:234px;">Asignación</th>
                        <th style="width:195px;">Monto</th>
                        <th></th>
                    </tr>
                </thead>
                <tbody id="tbOrigen">
                </tbody>
                <tfoot>
                    <tr>
                        <th colspan="4">TOTAL</th>
                        <th id="totalTablaOrigen"></th>
                        <th></th>
                    </tr>
                </tfoot>
            </table>

            <div class="titulo-azul subtitulo text-success">Asignaciones de destino</div>
            <table class="table table-bordered table-hover table-condensed" style="margin-top: 10px;">
                <thead>
                    <tr>
                        <th style="width:234px;">Proyecto</th>
                        <th style="width:234px;">Componente</th>
                        <th style="width:234px;">Actividad</th>
                        <th style="width:234px;">Asignación</th>
                        <th style="width:195px;">Monto</th>
                        <th></th>
                    </tr>
                </thead>
                <tbody id="tbDestino">
                </tbody>
                <tfoot>
                    <tr>
                        <th colspan="4">TOTAL</th>
                        <th id="totalTablaDestino"></th>
                        <th></th>
                    </tr>
                </tfoot>
            </table>
        </elm:container>

        <script type="text/javascript">
            function getMaximo(asg) {
                $.ajax({
                    type    : "POST",
                    url     : "${createLink(action:'getMaximoAsg',controller: 'avales')}",
                    data    : {
                        id : asg
                    },
                    success : function (msg) {
                        getValor(asg);
                        if ($("#asignacion").val() != "-1") {
                            $("#max").html("$" + number_format(msg, 2, ".", ","))
                                    .attr("valor", msg);
                            $("#monto").attr("max", msg);
                        } else {
                            var valor = parseFloat(msg);
                            var monto = $("#dlgMonto").val();
                            monto = monto.replace(new RegExp(",", 'g'), "");
                            monto = parseFloat(monto);
                            $("#dlgMax").html(number_format(valor + monto, 2, ".", ","));
                        }
                    }
                });
            }
            function getValor(asg) {
                $.ajax({
                    type    : "POST",
                    url     : "${createLink(action:'getValor',controller: 'modificacionesPoa')}",
                    data    : {
                        id : asg
                    },
                    success : function (msg) {
                        $("#valor").val(msg);
                    }
                });
            }

            function resetForm(tipo) {
                if (tipo == "Origen") {
                    $("#proyecto").val("-1");
                    $("#divComp").html("");
                    $("#divAct").html("");
                    $("#divAsg").html("");
                    $("#monto").val("");
                    $("#max").html("");
                } else if (tipo == "Destino") {
                    $("#proyectoDest").val("-1");
                    $("#divComp_dest").html("");
                    $("#divAct_dest").html("");
                    $("#divAsg_dest").html("");
                    $("#monto_dest").val("");
                    $("#tdTotalDestino").html("");
                }
            }

            function addRow(data) {
                var $tr = $("<tr>");
                var $tdProy = $("<td>");
                var $tdComp = $("<td>");
                var $tdActi = $("<td>");
                var $tdAsig = $("<td>");
                var $tdMont = $("<td>");
                var $tdBtn = $("<td>");

                var $btn = $("<a href='#' class='btn btn-sm btn-danger'><i class='fa fa-trash-o'></i></a>");
                $btn.click(function () {
                    $tr.remove();
                    actualizarTotales();
                });

                $tdProy.html(data.proyecto_nombre);
                $tdComp.html(data.componente_nombre);
                $tdActi.html(data.actividad_nombre);
                $tdAsig.html(data.asignacion_nombre);
                $tdMont.html(number_format(data.monto, 2, ".", ",")).addClass("text-right");
                $tdBtn.append($btn);

                $tr.append($tdProy);
                $tr.append($tdComp);
                $tr.append($tdActi);
                $tr.append($tdAsig);
                $tr.append($tdMont);
                $tr.append($tdBtn);
                $tr.data(data).addClass(data.clase);

                $("#tb" + data.tipo).prepend($tr);
                resetForm(data.tipo);
            }

            function calcularTotal(tipo) {
                var total = 0;
                $("#tb" + tipo).find("tr").each(function () {
                    total += parseFloat($(this).data("monto"));
                });
                return total;
            }

            function actualizarTotales() {
                var totalOrigen = calcularTotal("Origen");
                var totalDestino = calcularTotal("Destino");
                var maxDestino = totalOrigen - totalDestino;

                $("#divTotalOrigen").text("$" + number_format(totalOrigen, 2, ".", ","));
                $("#totalTablaOrigen").text(number_format(totalOrigen, 2, ".", ","));
                $("#divTotalDestino").text("$" + number_format(totalDestino, 2, ".", ","));
                $("#totalTablaDestino").text(number_format(totalDestino, 2, ".", ","));
                $("#divRestante").text("$" + number_format(maxDestino, 2, ".", ","));
                $("#tdTotalDestino").text("$" + number_format(maxDestino, 2, ".", ","));

                $("#monto_dest").attr("max", maxDestino);
            }

            $(function () {
                $("#btnAddOrigen").click(function () {
                    if ($("#frmOrigen").valid()) {
                        var data = {};
                        data.tipo = "Origen";
                        data.clase = "info";
                        data.proyecto_nombre = $("#proyecto").find("option:selected").text();
                        data.componente_nombre = $("#comp").find("option:selected").text();
                        data.actividad_nombre = $("#actividad").find("option:selected").text();
                        data.asignacion_nombre = $("#asignacion").find("option:selected").text();
                        data.asignacion_id = $("#asignacion").val();
                        data.monto = $("#monto").val();
                        addRow(data);
                        actualizarTotales();
                    }
                    return false;
                });
                $("#btnAddDestino").click(function () {
                    if ($("#frmDestino").valid()) {
                        var data = {};
                        data.tipo = "Destino";
                        data.clase = "success";
                        data.proyecto_nombre = $("#proyectoDest").find("option:selected").text();
                        data.componente_nombre = $("#compDest").find("option:selected").text();
                        data.actividad_nombre = $("#actividad_dest").find("option:selected").text();
                        data.asignacion_nombre = $("#asignacion_dest").find("option:selected").text();
                        data.asignacion_id = $("#asignacion_dest").val();
                        data.monto = $("#monto_dest").val();
                        addRow(data);
                        actualizarTotales();
                    }
                    return false;
                });

                $("#frmOrigen").validate({
                    errorClass     : "help-block",
                    onfocusout     : false,
                    rules          : {
                        asg : {
                            uniqueTableBody : ["#tbOrigen, #tbDestino", "asignacion_id"]
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

                $("#frmDestino").validate({
                    errorClass     : "help-block",
                    onfocusout     : false,
                    rules          : {
                        asg_dest : {
                            uniqueTableBody : ["#tbOrigen, #tbDestino", "asignacion_id"]
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

                $("#proyecto").val("-1").change(function () {
                    $("#divComp").html(spinner);
                    $.ajax({
                        type    : "POST",
                        url     : "${createLink(controller: 'modificacionesPoa', action:'componentesProyectoAjuste_ajax')}",
                        data    : {
                            id : $("#proyecto").val()
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
            });
        </script>

    </body>
</html>