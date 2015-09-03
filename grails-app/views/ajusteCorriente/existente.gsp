
<%@ page import="vesta.seguridad.Persona; vesta.parametros.poaPac.Anio" contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <meta name="layout" content="main">
        <title><elm:tipoReformaStr tipo="Ajuste al POA de gasto permanente" tipoSolicitud="E"/></title>

        <script type="text/javascript" src="${resource(dir: 'js/plugins/bootstrap-select-1.6.3/dist/js', file: 'bootstrap-select.js')}"></script>
        <link rel="stylesheet" href="${resource(dir: 'js/plugins/bootstrap-select-1.6.3/dist/css', file: 'bootstrap-select.css')}">

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

        <elm:container tipo="horizontal" titulo="${elm.tipoReformaStr(tipo: "Ajuste al POA de gasto permanente", tipoSolicitud: "E")}">
            <div class="row">
                <div class="col-md-1">
                    <label for="anio">
                        POA Año
                    </label>
                </div>

                <div class="col-md-2" style="width: 120px">
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

            <form id="frmReforma">
                <table class="table table-bordered table-hover table-condensed" style="margin-top: 10px;">
                    <thead>
                        <tr>
                            <th style="width:234px;">Objetivo gasto permanente</th>
                            <th style="width:234px;">MacroActividad</th>
                            <th style="width:234px;">Actividad</th>
                            <th style="width:234px;">Tarea</th>
                            <th style="width:234px;">Asignación</th>
                            <th style="width:195px;">Monto</th>
                            <th style="width:135px;">Máximo</th>
                            <th></th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr class="info">
                            <td colspan="8">Asignación de origen</td>
                        </tr>
                        <tr class="info">
                            <td class="grupo">
                                <g:select from="${objetivos}" optionKey="id" optionValue="descripcion" name="objetivo" class="form-control input-sm required requiredCombo selectpicker"
                                          noSelection="['-1': 'Seleccione...']"/>
                            </td>
                            <td class="grupo" id="tdMacro">
                            </td>
                            <td class="grupo" id="tdActividad">
                            </td>
                            <td class="grupo" id="tdTarea">
                            </td>
                            <td class="grupo" id="tdAsignacion">
                            </td>
                            <td class="grupo">
                                <div class="input-group">
                                    <g:textField type="text" name="monto"
                                                 class="form-control required input-sm number money"/>
                                    %{--<span class="input-group-addon"><i class="fa fa-usd"></i></span>--}%
                                </div>
                            </td>
                            <td id="max">

                            </td>
                            <td>
                            </td>
                        </tr>
                        <tr class="success">
                            <td colspan="8">Asignación de destino</td>
                        </tr>
                        <tr class="success">
                            <td class="grupo">
                                <g:select from="${objetivos2}" optionKey="id" optionValue="descripcion" name="objetivo_dest"
                                          class="form-control required requiredCombo input-sm selectpicker" noSelection="['-1': 'Seleccione...']"/>
                            </td>
                            <td class="grupo" id="tdMacro_dest">
                            </td>
                            <td class="grupo" id="tdActividad_dest">
                            </td>
                            <td class="grupo" id="tdTarea_dest">
                            </td>
                            <td class="grupo" id="tdAsignacion_dest">
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

            <div id="detallesExistentes">
                <g:each in="${detalles}" var="detalle" status="i">
                    <table class='table table-bordered table-hover table-condensed tableReforma tableReformaExistente'
                           data-monto="${detalle.valor}"
                           data-aso="${detalle.asignacionOrigenId}"
                           data-asd="${detalle.asignacionDestinoId}">
                        <thead>
                            <tr>
                                <th colspan='6'>
                                    Detalle existente ${i + 1}
                                    <a href='' class='btn btn-danger btn-xs pull-right btnDeleteDetalle' data-id="${detalle.id}">
                                        <i class='fa fa-trash-o'></i>
                                    </a>
                                </th>
                            </tr>
                            <tr>
                                <th style='width:260px;'>Objetivo gasto permanente</th>
                                <th style='width:200px;'>MacroActividad</th>
                                <th style='width:200px;'>Actividad</th>
                                <th style='width:200px;'>Tarea</th>
                                <th>Asignación</th>
                                <th style='width:100px;'>Monto</th>
                            </tr>
                        </thead>

                        <g:set var="objt" value="${detalle.asignacionOrigen.tarea.actividad.macroActividad.objetivoGastoCorriente.descripcion}"/>
                        <tbody>
                            <tr class="info">
                                <td>
                                    %{--${detalle.asignacionOrigen.tarea.actividad.macroActividad.objetivoGastoCorriente.descripcion}--}%
                                   "${objt.size() > 70 ? objt[0..70] + "..." : objt}"
                                </td>
                                <td>
                                    ${detalle.asignacionOrigen.tarea.actividad.macroActividad.descripcion}
                                </td>
                                <td>
                                    ${detalle.asignacionOrigen.tarea.actividad.descripcion}
                                </td>
                                <td>
                                    ${detalle.asignacionOrigen.tarea.descripcion}
                                </td>
                                <td>
                                    ${detalle.asignacionOrigen.presupuesto.descripcion + ': ' + detalle.asignacionOrigen.presupuesto.numero}
                                </td>
                                <td class="text-right">
                                    -<g:formatNumber number="${detalle.valor}" type="currency" currencySymbol=""/>
                                </td>
                            </tr>
                            <g:set var="objt_ds" value="${detalle.asignacionDestino.tarea.actividad.macroActividad.objetivoGastoCorriente.descripcion}"/>
                            <tr class="success">
                                <td>
                                    "${objt.size() > 70 ? objt[0..70] + "..." : objt}"
                                </td>
                                <td>
                                    ${detalle.asignacionDestino.tarea.actividad.macroActividad.descripcion}
                                </td>
                                <td>
                                    ${detalle.asignacionDestino.tarea.actividad.descripcion}
                                </td>
                                <td>
                                    ${detalle.asignacionDestino.tarea.descripcion}
                                </td>
                                <td>
                                    ${detalle.asignacionDestino.presupuesto.descripcion + ': ' + detalle.asignacionDestino.presupuesto.numero}
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
        </elm:container>

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

            function getMaximo(asg, mod) {
                if (asg != "-1") {
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

                            $("#max" + mod).html("$" + number_format(ok, 2, ".", ","))
                                    .attr("valor", ok);
                            $("#monto" + mod).attr("tdnMax", ok);
                        }
                    });
                }
            }

            function resetForm() {
                $("#objetivo").val("-1");
                $("#tdMacro").html("");
                $("#tdActividad").html("");
                $("#tdTarea").html("");
                $("#tdAsignacion").html("");
                $("#monto").val("");
                $("#max").html("");

                $("#objetivo_dest").val("-1");
                $("#tdMacro_dest").html("");
                $("#tdActividad_dest").html("");
                $("#tdTarea_dest").html("");
                $("#tdAsignacion_dest").html("");
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
                var $thTitulo = $("<th colspan='6'>Detalle " + cont + "</th>");
                $thTitulo.append($btn);
                $thTitulo.appendTo($trTitulo);
                cont++;
                $thead.append($trTitulo);

                var $trHead = $("<tr>");
                $("<th style='width:260px;'>Objetivo gasto permanente</th>").appendTo($trHead);
                $("<th style='width:200px;'>MacroActividad</th>").appendTo($trHead);
                $("<th style='width:200px;'>Actividad</th>").appendTo($trHead);
                $("<th style='width:200px;'>Tarea</th>").appendTo($trHead);
                $("<th>Asignación</th>").appendTo($trHead);
                $("<th style='width:100px;'>Monto</th>").appendTo($trHead);
                $thead.append($trHead);

                var $tdObjO = $("<td>");
                var $tdMcaO = $("<td>");
                var $tdActO = $("<td>");
                var $tdTarO = $("<td>");
                var $tdAsgO = $("<td>");
                var $tdMnO = $("<td class='text-right'>");

                var $tdObjD = $("<td>");
                var $tdMcaD = $("<td>");
                var $tdActD = $("<td>");
                var $tdTarD = $("<td>");
                var $tdAsgD = $("<td>");
                var $tdMnD = $("<td class='text-right'>");

                $tdObjO.text(dataOrigen.objetivo_nombre);
                $tdMcaO.text(dataOrigen.macro_nombre);
                $tdActO.text(dataOrigen.actividad_nombre);
                $tdTarO.text(dataOrigen.tarea_nombre);
                $tdAsgO.text(dataOrigen.asignacion_nombre);
                $tdMnO.text("-" + number_format(dataOrigen.monto, 2, ".", ","));

                $tdObjD.text(dataDestino.objetivo_nombre);
                $tdMcaD.text(dataDestino.macro_nombre);
                $tdActD.text(dataDestino.actividad_nombre);
                $tdTarD.text(dataDestino.tarea_nombre);
                $tdAsgD.text(dataDestino.asignacion_nombre);
                $tdMnD.text(number_format(dataOrigen.monto, 2, ".", ","));

                $rowOrigen.data(dataOrigen).append($tdObjO).append($tdMcaO).append($tdActO).append($tdTarO).append($tdAsgO).append($tdMnO);
                $rowDestino.data(dataDestino).append($tdObjD).append($tdMcaD).append($tdActD).append($tdTarD).append($tdAsgD).append($tdMnD);

                $tbody.append($rowOrigen).append($rowDestino);

                $tabla.data(data).append($thead).append($tbody);
                $("#divReformas").prepend($tabla);
                calcularTotal();
            }

            $(function () {
                addData();

                $('.selectpicker').selectpicker({
                    width      : "200px",
                    limitWidth : true,
                    style      : "btn-sm"
                });

                $("#frmReforma").validate({
                    errorClass     : "help-block",
                    onfocusout     : false,
                    rules          : {
                        asg_dest : {
                            notEqualTo : "#asg"
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
//                    console.log($("#asg"), $("#asg_dest"));
//                    console.log($("#asg").val(), $("#asg_dest").val());
                    if ($("#frmReforma").valid()) {
                        var dataOrigen = {};
                        var objt_og = $("#objetivo").find("option:selected").text();
                        if(objt_og.length > 70) {
                            dataOrigen.objetivo_nombre = objt_og.substring(1,70) + "...";
                        } else {
                            dataOrigen.objetivo_nombre = objt_og;
                        }
                        dataOrigen.macro_nombre = $("#mac").find("option:selected").text();
                        dataOrigen.actividad_nombre = $("#act").find("option:selected").text();
                        dataOrigen.tarea_nombre = $("#tar").find("option:selected").text();
                        dataOrigen.asignacion_nombre = $("#asg").find("option:selected").text();
                        dataOrigen.asignacion_id = $("#asg").val();
                        dataOrigen.monto = $("#monto").val();

                        var dataDestino = {};
                        var objt_ds = $("#objetivo_dest").find("option:selected").text();
                        if(objt_ds.length > 70) {
                            dataDestino.objetivo_nombre = objt_ds.substring(1,70) + "...";
                        } else {
                            dataDestino.objetivo_nombre = objt_ds;
                        }
//                        dataDestino.objetivo_nombre = $("#objetivo_dest").find("option:selected").text();
                        dataDestino.macro_nombre = $("#mac_dest").find("option:selected").text();
                        dataDestino.actividad_nombre = $("#act_dest").find("option:selected").text();
                        dataDestino.tarea_nombre = $("#tar_dest").find("option:selected").text();
                        dataDestino.asignacion_nombre = $("#asg_dest").find("option:selected").text();
                        dataDestino.asignacion_id = $("#asg_dest").val();
                        if (validarPar(dataOrigen, dataDestino)) {
                            addReforma(dataOrigen, dataDestino);
                            resetForm();
                        }
                    }
                    return false;
                });

                $("#objetivo").val("-1").change(function () {
                    $("#tdMacro").html(spinner);
                    $.ajax({
                        type    : "POST",
                        url     : "${createLink(controller: 'asignacion', action:'macro_ajax')}",
                        data    : {
                            objetivo : $(this).val(),
                            width    : "140px"
                        },
                        success : function (msg) {
                            $("#tdMacro").html(msg);
                            $("#tdActividad").html("");
                            $("#tdTarea").html("");
                            $("#tdAsignacion").html("");
                            $("#max").html("");
                        }
                    });
                });

                $("#objetivo_dest").val("-1").change(function () {
                    $("#tdMacro_dest").html(spinner);
                    $.ajax({
                        type    : "POST",
                        url     : "${createLink(controller: 'asignacion', action:'macro_ajax')}",
                        data    : {
                            objetivo : $("#objetivo_dest").val(),
                            mod      : "_dest",
                            width    : "140px"
                        },
                        success : function (msg) {
                            $("#tdMacro_dest").html(msg);
                            $("#tdActividad_dest").html("");
                            $("#tdTarea_dest").html("");
                            $("#tdAsignacion_dest").html("");
                        }
                    });
                });

                $("#btnGuardar").click(function () {
                    openLoader();
                    var data = {};
                    var c = 0;
                    $(".tableReformaNueva").each(function () {
                        var d = $(this).data();
                        data["r" + c] = d.origen.asignacion_id + "_" + d.destino.asignacion_id + "_" + d.origen.monto;
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
                        url     : "${createLink(action:'saveExistente_ajax')}",
                        data    : data,
                        success : function (msg) {
                            var parts = msg.split("*");
                            log(parts[1], parts[0]);
                            if (parts[0] == "SUCCESS") {
                                setTimeout(function () {
                                    location.href = "${createLink(action:'existente')}/" + parts[2];
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
                                                data["r" + c] = d.origen.asignacion_id + "_" + d.destino.asignacion_id + "_" + d.origen.monto;
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
                                    });
                        }
                    }
                    return false;
                });
            });

        </script>

    </body>
</html>