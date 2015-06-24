<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 22/04/15
  Time: 09:06 AM
--%>

<%@ page import="vesta.modificaciones.DetalleReforma; vesta.parametros.poaPac.Fuente; vesta.seguridad.Persona; vesta.parametros.poaPac.Anio" contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <meta name="layout" content="main">
        <title><elm:tipoReformaStr tipo="Ajuste" tipoSolicitud="P"/></title>

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

        <g:if test="${reforma && reforma.estado.codigo == "D03"}">
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

        <elm:container tipo="horizontal" titulo="${elm.tipoReformaStr(tipo: "Ajuste", tipoSolicitud: "P")}">
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
                            <th style="width:135px;">Saldo</th>
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
                            <td id="max" data-max="0">

                            </td>
                        </tr>
                    </tbody>
                </table>
            </form>

            <form id="frmPartida">
                <h3 class="text-info">Partidas de destino</h3>

                <div class="row">
                    %{--<div class="col-md-1">--}%
                    %{--<label for="fuente">Fuente</label>--}%
                    %{--</div>--}%

                    %{--<div class="col-md-2">--}%
                    %{--<g:select name="fuente" from="${Fuente.list([sort: 'descripcion'])}" optionKey="id" optionValue="descripcion"--}%
                    %{--class="form-control required"/>--}%
                    %{--</div>--}%

                    <div class="col-md-1">
                        <label>Partida</label>
                    </div>

                    <div class="col-md-3">
                        <bsc:buscador name="partida" id="prsp_id" controlador="asignacion" accion="buscarPresupuesto" tipo="search"
                                      titulo="Busque una partida" campos="${campos}" clase="required" style="width:100%;"/>
                    </div>

                    <div class="col-md-1">
                        <label for="monto">Monto a aumentar</label>
                    </div>

                    <div class="col-md-2">
                        <div class="input-group">
                            <g:textField type="text" name="monto"
                                         class="form-control required input-sm number money"/>
                            <span class="input-group-addon"><i class="fa fa-usd"></i></span>
                        </div>
                    </div>

                    <div class="col-md-1">
                        <a href="#" class="btn btn-success btn-sm " id="btnAddReforma">
                            <i class="fa fa-plus"></i> Agregar
                        </a>
                    </div>
                </div>
            </form>

            <g:if test="${reforma && detalles.size() > 0}">
                <div id="detallesExistentes" style="margin-top: 15px;">
                    <table class='table table-bordered table-hover table-condensed'>
                        <thead>
                            <tr>
                                <th colspan='5'>
                                    Detalles existentes
                                </th>
                            </tr>
                            <tr>
                                <th style="width: 300px;">Fuente</th>
                                <th>Partida</th>
                                <th style="width: 180px;">Monto a aumentar</th>
                                <th style="width: 40px;"></th>
                            </tr>
                        </thead>
                        <tbody>
                            <g:each in="${detalles}" var="detalle" status="i">
                                <tr class="success tableReforma tableReformaExistente"
                                    data-monto="${detalle.valor}"
                                    data-asignacion="${detalle.asignacionOrigenId}"
                                    data-fuente="${detalle.fuenteId}"
                                    data-presupuesto="${detalle.presupuestoId}">
                                    <td>
                                        ${detalle.fuente}
                                    </td>
                                    <td>
                                        ${detalle.presupuesto}
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
                <table class="table table-bordered table-hover table-condensed">
                    <thead>
                        <tr>
                            %{--<th style="width: 300px;">Fuente</th>--}%
                            <th>Partida</th>
                            <th style="width: 180px;">Monto a aumentar</th>
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
                        }}" noSelection="['': '- Seleccione -']" name="firma1" class="form-control required input-sm"/>
                    </g:else>
                </div>

                <div class="col-md-3 grupo">
                    <g:if test="${reforma && reforma.estado.codigo == 'D03'}">
                        ${reforma.firma2.usuario}
                    </g:if>
                    <g:else>
                        <g:select from="${gerentes}" optionKey="id" optionValue="${{
                            it.nombre + ' ' + it.apellido
                        }}" noSelection="['': '- Seleccione -']" name="firma2" class="form-control required input-sm"/>
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
                    var d = $(this).data();
                    var data = {
                        origen  : {
                            monto         : d.monto,
                            asignacion_id : d.asignacion
                        },
                        destino : {
                            fuente_id      : d.fuente,
                            presupuesto_id : d.presupuesto
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
                            $("#monto").attr("tdnMax", ok);
                        }
                    });
                }
            }

            function resetForm() {
                $("#bsc-desc-prsp_id").val("");
                $("#prsp_id").val("");
                $("#monto").val("");
            }

            function validarPar(dataOrigen, dataDestino) {
                var ok = true;
                var max = parseFloat($("#max").data("max"));
                var total = 0;
                $(".tableReforma").each(function () {
                    var d = $(this).data();
                    var v = str_replace(",", "", d.origen.monto);
                    total += parseFloat(v);
                    if (dataDestino.fuente_id == d.destino.fuente_id && dataDestino.partida_id == d.destino.partida_id) {
                        ok = false;
                    }
                });
                if (!ok) {
                    bootbox.alert("No puede seleccionar 2 veces la misma combinación de fuente y partida");
                } else {
                    if (dataDestino) {
                        total += parseFloat(dataOrigen.monto);
                    }
                    if (total > max) {
                        ok = false;
                        bootbox.alert("No puede sobrepasar el valor máximo de la asignación de origen");
                    }
                }
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
//                $("<th style='width:300px;'>Fuente</th>").appendTo($trHead);
//                $("<th>Partida</th>").appendTo($trHead);
//                $("<th style='width:180px;'>Monto</th>").appendTo($trHead);
//                $thead.append($trHead);

//                var $tdF = $("<td>");
                var $tdP = $("<td>");
                var $tdM = $("<td class='text-right'>");
                var $tdB = $("<td>");

//                $tdF.text(dataDestino.fuente_nombre);
                $tdP.text(dataDestino.partida_nombre);
                $tdM.text(number_format(dataOrigen.monto, 2, ".", ","));
                $tdB.append($btn);

//                $rowDestino.data(data).append($tdF).append($tdP).append($tdM).append($tdB);
                $rowDestino.data(data).append($tdP).append($tdM).append($tdB);

//                $tbody.append($rowDestino);
//
//                $tabla.data(data).append($thead).append($tbody);
                $("#divReformas").prepend($rowDestino);
                calcularTotal();
            }

            $(function () {

                addData();

                $("#frmReforma, #frmPartida, #frmFirma").validate({
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

                $("#btnAddReforma").click(function () {
                    if ($("#frmPartida").valid()) {
                        var dataOrigen = {};
//                        dataOrigen.proyecto_nombre = $("#proyecto").find("option:selected").text();
//                        dataOrigen.componente_nombre = $("#comp").find("option:selected").text();
//                        dataOrigen.actividad_nombre = $("#actividad").find("option:selected").text();
//                        dataOrigen.asignacion_nombre = $("#asignacion").find("option:selected").text();
                        dataOrigen.asignacion_id = $("#asignacion").val();
                        dataOrigen.monto = $("#monto").val();

                        var dataDestino = {};
                        dataDestino.fuente_nombre = $("#fuente").find("option:selected").text();
                        dataDestino.fuente_id = $("#fuente").val();
                        dataDestino.partida_nombre = $("#bsc-desc-prsp_id").val();
                        dataDestino.partida_id = $("#prsp_id").val();
//                        dataDestino.monto = $("#monto").val();

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
                            $("#max").html("").data("max", 0);
                        }
                    });
                });
                <g:if test="${reforma && reforma.id}">
                $("#proyecto").val("${DetalleReforma.findByReforma(reforma).asignacionOrigen.marcoLogico.proyectoId}").change();
                setTimeout(function () {
                    $("#comp").val("${DetalleReforma.findByReforma(reforma).asignacionOrigen.marcoLogico.marcoLogicoId}").change();
                    setTimeout(function () {
                        $("#actividad").val("${DetalleReforma.findByReforma(reforma).asignacionOrigen.marcoLogicoId}").change();
                        setTimeout(function () {
                            $("#asignacion").val("${DetalleReforma.findByReforma(reforma).asignacionOrigenId}").change();
                        }, 500);
                    }, 500);
                }, 500);
                </g:if>

                $("#btnGuardar").click(function () {
                    openLoader();
                    var data = {};
                    var c = 0;
                    $(".tableReformaNueva").each(function () {
                        var d = $(this).data();
                        data["r" + c] = {};
                        data["r" + c].origen = d.origen.asignacion_id;
                        data["r" + c].monto = d.origen.monto;
//                                data["r" + c].fuente = d.destino.fuente_id;
                        data["r" + c].partida = d.destino.partida_id;
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
                        url     : "${createLink(action:'savePartida_ajax')}",
                        data    : data,
                        success : function (msg) {
                            var parts = msg.split("*");
                            log(parts[1], parts[0]);
                            if (parts[0] == "SUCCESS") {
                                setTimeout(function () {
                                    location.href = "${createLink(action:'partida')}/" + parts[2];
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
                                                data["r" + c].origen = d.origen.asignacion_id;
                                                data["r" + c].monto = d.origen.monto;
//                                data["r" + c].fuente = d.destino.fuente_id;
                                                data["r" + c].partida = d.destino.partida_id;
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
                                                url     : "${createLink(action:'savePartida_ajax')}",
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