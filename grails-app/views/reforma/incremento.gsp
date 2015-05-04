<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 23/04/15
  Time: 02:38 PM
--%>

<%@ page import="vesta.seguridad.Persona; vesta.parametros.poaPac.Anio" contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <meta name="layout" content="main">
        <title>Modificación de incremento</title>

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


    <!-- botones -->
        <div class="btn-toolbar toolbar">
            <div class="btn-group">
                <g:link action="reformas" class="btn btn-default btnCrear">
                    <i class="fa fa-file-o"></i> Solicitar nueva
                </g:link>
            </div>
        </div>

        <elm:container tipo="horizontal" titulo="Modificación de incremento">
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
                                <th>Asignación</th>
                                <th style="width:195px;">Monto a aumentar</th>
                                <th></th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr class="success">
                                <td colspan="7">Asignación de destino</td>
                            </tr>
                            <tr class="success">
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

            <g:if test="${reforma && detalles.size() > 0}">
                <div id="detallesExistentes">
                    <table class='table table-bordered table-hover table-condensed'>
                        <thead>
                            <tr>
                                <th colspan='6'>
                                    Detalles existentes
                                </th>
                            </tr>
                            <tr>
                                <th style='width:234px;'>Proyecto</th>
                                <th style='width:234px;'>Componente</th>
                                <th style='width:234px;'>Actividad</th>
                                <th>Asignación</th>
                                <th style='width:195px;'>Monto a aumentar</th>
                                <th style="width: 40px;"></th>
                            </tr>
                        </thead>
                        <tbody>
                            <g:each in="${detalles}" var="detalle" status="i">
                                <tr class="success tableReforma tableReformaExistente"
                                    data-monto="${detalle.valor}"
                                    data-aso="${detalle.asignacionOrigenId}"
                                    data-asd="${detalle.asignacionDestinoId}">
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
                                    <td>
                                        <a href='' class='btn btn-danger btn-xs pull-right btnDeleteDetalle' data-id="${detalle.id}">
                                            <i class='fa fa-trash-o'></i>
                                        </a>
                                    </td>
                                </tr>
                            </g:each>
                        </tbody>
                    </table>
                </div>
            </g:if>

            <div style="margin-top: 15px;">
                <table class='table table-bordered table-hover table-condensed'>
                    <thead>
                        <tr>
                            <th style='width:234px;'>Proyecto</th>
                            <th style='width:234px;'>Componente</th>
                            <th style='width:234px;'>Actividad</th>
                            <th>Asignación</th>
                            <th style='width:195px;'>Monto a aumentar</th>
                            <th style="width: 40px;"></th>
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
                            monto : d.monto
                        },
                        destino : {
                            asignacion_id : d.asd
                        }
                    };
                    $(this).data(data);
                });
            }

            function resetForm() {
                $("#proyecto").val("-1");
                $("#divComp").html("");
                $("#divAct").html("");
                $("#divAsg").html("");
                $("#monto").val("");
                $("#max").html("");
            }

            function validarPar(dataOrigen, dataDestino) {
                var ok = true;
                $(".tableReforma").each(function () {
                    var d = $(this).data();
                    if (d.destino.asignacion_id == dataDestino.asignacion_id) {
                        ok = false;
                        bootbox.alert("No puede seleccionar una asignación ya ingresada");
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

//                var $tabla = $("<table class='table table-bordered table-hover table-condensed tableReforma tableReformaNueva'>");
//                var $thead = $("<thead>");
//                var $tbody = $("<tbody>");
//                var $rowOrigen = $("<tr class='info'>");
                var $rowDestino = $("<tr class='success tableReforma tableReformaNueva'>");

                var $btn = $("<a href='' class='btn btn-danger btn-xs pull-right'><i class='fa fa-trash-o'></i></a>");
                $btn.click(function () {
                    $(this).parents("tr").remove();
                    cont--;
                    calcularTotal();
                    return false;
                });

//                var $trTitulo = $("<tr>");
//                var $thTitulo = $("<th colspan='5'>Detalle " + cont + "</th>");
//                $thTitulo.append($btn);
//                $thTitulo.appendTo($trTitulo);
//                cont++;
//                $thead.append($trTitulo);

//                var $trHead = $("<tr>");
//                $("<th style='width:234px;'>Proyecto</th>").appendTo($trHead);
//                $("<th style='width:234px;'>Componente</th>").appendTo($trHead);
//                $("<th style='width:234px;'>Actividad</th>").appendTo($trHead);
//                $("<th>Asignación</th>").appendTo($trHead);
//                $("<th style='width:195px;'>Monto</th>").appendTo($trHead);
//                $thead.append($trHead);

//                var $tdPrO = $("<td>");
//                var $tdCmO = $("<td>");
//                var $tdAcO = $("<td>");
//                var $tdAsO = $("<td>");
//                var $tdMnO = $("<td class='text-right'>");

                var $tdPrD = $("<td>");
                var $tdCmD = $("<td>");
                var $tdAcD = $("<td>");
                var $tdAsD = $("<td>");
                var $tdMnD = $("<td class='text-right'>");
                var $tdBtD = $("<td class='text-right'>");

//                $tdPrO.text(dataOrigen.proyecto_nombre);
//                $tdCmO.text(dataOrigen.componente_nombre);
//                $tdAcO.text(dataOrigen.actividad_nombre);
//                $tdAsO.text(dataOrigen.asignacion_nombre);
//                $tdMnO.text("-" + number_format(dataOrigen.monto, 2, ".", ","));

                $tdPrD.text(dataDestino.proyecto_nombre);
                $tdCmD.text(dataDestino.componente_nombre);
                $tdAcD.text(dataDestino.actividad_nombre);
                $tdAsD.text(dataDestino.asignacion_nombre);
                $tdMnD.text(number_format(dataOrigen.monto, 2, ".", ","));
                $tdBtD.append($btn);

//                $rowOrigen.data(dataOrigen).append($tdPrO).append($tdCmO).append($tdAcO).append($tdAsO).append($tdMnO);
                $rowDestino.data(data).append($tdPrD).append($tdCmD).append($tdAcD).append($tdAsD).append($tdMnD).append($tdBtD);

//                $tbody.append($rowOrigen).append($rowDestino);

//                $tabla.data(data).append($thead).append($tbody);
                $("#divReformas").prepend($rowDestino);
                calcularTotal();
            }

            $(function () {
                addData();
                $("#frmReforma, #frmFirma").validate({
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
//                        dataOrigen.proyecto_nombre = $("#proyecto").find("option:selected").text();
//                        dataOrigen.componente_nombre = $("#comp").find("option:selected").text();
//                        dataOrigen.actividad_nombre = $("#actividad").find("option:selected").text();
//                        dataOrigen.asignacion_nombre = $("#asignacion").find("option:selected").text();
//                        dataOrigen.asignacion_id = $("#asignacion").val();
//                        dataOrigen.monto = $("#monto").val();
                        dataOrigen.monto = str_replace(",", "", $("#monto").val());

                        var dataDestino = {};
                        dataDestino.proyecto_nombre = $("#proyecto").find("option:selected").text();
                        dataDestino.componente_nombre = $("#comp").find("option:selected").text();
                        dataDestino.actividad_nombre = $("#actividad").find("option:selected").text();
                        dataDestino.asignacion_nombre = $("#asignacion").find("option:selected").text();
                        dataDestino.asignacion_id = $("#asignacion").val();
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

                $("#btnSave").click(function () {
                    if ($(this).hasClass("disabled")) {
                        bootbox.alert("Por favor seleccione al menos una asignación para la modificación")
                    } else {
                        if ($("#frmFirma").valid()) {
                            openLoader();
                            var data = {};
                            var c = 0;
                            $(".tableReformaNueva").each(function () {
                                var d = $(this).data();
                                data["r" + c] = d.destino.asignacion_id + "_" + d.origen.monto;
                                c++;
                            });
                            data.firma = $("#firma").val();
                            data.anio = $("#anio").val();
                            data.concepto = $("#concepto").val();
                            data.id = "${reforma?.id}";
                            $.ajax({
                                type    : "POST",
                                url     : "${createLink(action:'saveIncremento_ajax')}",
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