<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 14/04/15
  Time: 03:31 PM
--%>

<%@ page import="vesta.seguridad.Persona; vesta.parametros.poaPac.Anio" contentType="text/html;charset=UTF-8" %>
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

        <g:if test="${reforma &&
                reforma.estado.codigo == "D01" &&
                reforma.firmaSolicitud.observaciones && reforma.firmaSolicitud.observaciones != '' && reforma.firmaSolicitud.observaciones != 'S'}">
            <div class="alert alert-warning">
                <h4>Observaciones de ${reforma.firmaSolicitud.usuario}</h4>
                ${reforma.firmaSolicitud.observaciones}
            </div>
        </g:if>


        <elm:container tipo="horizontal" titulo="Modificación a asignación existente">
            <div class="row">
                <div class="col-md-1">
                    <label for="anio">
                        POA Año
                    </label>
                </div>

                <div class="col-md-2">
                    <g:if test="${editable}">
                        <g:select from="${Anio.findAllByEstado(1, [sort: 'anio'])}" value="${reforma ? reforma.anioId : actual?.id}" optionKey="id" optionValue="anio" name="anio"
                                  class="form-control input-sm required requiredCombo"/>
                    </g:if>
                    <g:else>
                        ${reforma.anio.anio}
                    </g:else>
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

            <g:if test="${editable}">
                <form id="frmReforma">
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
                                <td colspan="7">Asignación de origen</td>
                            </tr>
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
                                        <g:textField type="text" name="monto"
                                                     class="form-control required input-sm number money"/>
                                        <span class="input-group-addon"><i class="fa fa-usd"></i></span>
                                    </div>
                                </td>
                                <td id="max">

                                </td>
                                <td>
                                </td>
                            </tr>
                            <tr class="success">
                                <td colspan="7">Asignación de destino</td>
                            </tr>
                            <tr class="success">
                                <td class="grupo">
                                    <g:select from="${proyectos2}" optionKey="id" optionValue="nombre" name="proyecto_dest" id="proyectoDest" style="width:100%"
                                              class="form-control required requiredCombo input-sm" noSelection="['-1': 'Seleccione...']"/>
                                </td>
                                <td class="grupo" id="divComp_dest">
                                </td>
                                <td class="grupo" id="divAct_dest">
                                </td>
                                <td class="grupo" id="divAsg_dest">
                                </td>
                                <td class="grupo" id="divMonto_dest">
                                </td>
                                <td>
                                </td>
                                <td>
                                    <a href="#" class="btn btn-sm btn-success" id="btnAddReforma" title="Agregar reforma">
                                        <i class="fa fa-plus"></i>
                                    </a>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </form>
            </g:if>

            <div id="detallesExistentes">
                <g:each in="${detalles}" var="detalle" status="i">
                    <table class='table table-bordered table-hover table-condensed tableReforma tableReformaExistente'
                           data-monto="${detalle.valor}"
                           data-aso="${detalle.asignacionOrigenId}"
                           data-asd="${detalle.asignacionDestinoId}">
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
                                    ${detalle.asignacionDestino.marcoLogico.proyecto.toStringCompleto()}
                                </td>
                                <td>
                                    ${detalle.asignacionDestino.marcoLogico.marcoLogico.toStringCompleto()}
                                </td>
                                <td>
                                    ${detalle.asignacionDestino.marcoLogico.numero} - ${detalle.asignacionDestino.marcoLogico.toStringCompleto()}
                                </td>
                                <td>
                                    ${detalle.asignacionDestino}
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
                    <label>Concepto</label>
                </div>

                <div class="col-md-11 grupo">
                    <g:if test="${editable}">
                        <g:textArea name="concepto" class="form-control required" style="height: 100px;" value="${reforma?.concepto}"/>
                    </g:if>
                    <g:else>
                        ${reforma.concepto}
                    </g:else>
                </div>
            </div>

            <div class="row" style="margin-bottom: 100px">
                <div class="col-md-1">
                    <label>Firma</label>
                </div>

                <div class="col-md-3 grupo">
                    <g:if test="${!reforma}">
                        <g:select from="${Persona.findAllByUnidad(session.usuario.unidad, [sort: 'nombre'])}" optionKey="id" optionValue="" id="firma" name="firma"
                                  class="form-control input-sm required" noSelection="['': '- Seleccione -']" value="${reforma ? reforma.firmaSolicitud.usuarioId : ''}"/>
                    </g:if>
                    <g:else>
                        ${reforma.firmaSolicitud.usuario}
                    </g:else>
                </div>

                <div class="col-md-2 col-md-offset-6">
                    <g:if test="${editable}">
                        <a href="#" class="btn btn-success pull-right ${!reforma ? 'disabled' : ''}" id="btnSave">
                            <i class="fa fa-floppy-o"></i> Guardar
                        </a>
                    </g:if>
                </div>
            </div>
        </form>

        <script type="text/javascript">
            var cont = 1;

            function addData() {
                $(".tableReformaExistente").each(function () {
                    var d = $(this).data();
                    var data = {
                        origen  : {
                            monto         : d.monto,
                            asignacion_id : d.aso
                        },
                        destino : {
                            asignacion_id : d.asd
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
                $("#divAct_dest").html("");
                $("#divAsg_dest").html("");
                $("#monto_dest").val("");
                $("#tdTotalDestino").html("");
            }

            function validarPar(dataOrigen, dataDestino) {
                var ok = true;
                $(".tableReforma").each(function () {
                    var d = $(this).data();
                    if (d.origen.asignacion_id == dataOrigen.asignacion_id && d.destino.asignacion_id == dataDestino.asignacion_id) {
                        ok = false;
                        bootbox.alert("No puede seleccionar un par de asignaciones ya ingresados");
                    } else {
                        if (d.origen.asignacion_id == dataDestino.asignacion_id || d.destino.asignacion_id == dataOrigen.asignacion_id) {
                            ok = false;
                            bootbox.alert("No puede seleccionar una asignación de origen que está listada como destino ni vice versa");
                        }
                    }
                });
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
                    rules          : {
                        asg_dest : {
                            notEqualTo : "#asignacion"
                        }
                    },
                    messages       : {
                        asg_dest : {
                            notEqualTo : "Ingrese una asignación diferente a la de origen"
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
                        dataOrigen.actividad_nombre = $("#actividad").find("option:selected").text();
                        dataOrigen.asignacion_nombre = $("#asignacion").find("option:selected").text();
                        dataOrigen.asignacion_id = $("#asignacion").val();
                        dataOrigen.monto = $("#monto").val();

                        var dataDestino = {};
                        dataDestino.proyecto_nombre = $("#proyectoDest").find("option:selected").text();
                        dataDestino.componente_nombre = $("#compDest").find("option:selected").text();
                        dataDestino.actividad_nombre = $("#actividad_dest").find("option:selected").text();
                        dataDestino.asignacion_nombre = $("#asignacion_dest").find("option:selected").text();
                        dataDestino.asignacion_id = $("#asignacion_dest").val();
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

                $("#btnSave").click(function () {
                    if ($(this).hasClass("disabled")) {
                        bootbox.alert("Por favor seleccione al menos un grupo de asignaciones para la modificación")
                    } else {
                        if ($("#frmFirma").valid()) {
                            openLoader();
                            var data = {};
                            var c = 0;
                            $(".tableReformaNueva").each(function () {
                                var d = $(this).data();
                                data["r" + c] = d.origen.asignacion_id + "_" + d.destino.asignacion_id + "_" + d.origen.monto;
                                c++;
                            });
                            data.firma = $("#firma").val();
                            data.anio = $("#anio").val();
                            data.concepto = $("#concepto").val();
                            data.id = "${reforma?.id}";
                            $.ajax({
                                type    : "POST",
                                url     : "${createLink(action:'saveExistente_ajax')}",
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
                    }
                    return false;
                });
            });

        </script>

    </body>
</html>