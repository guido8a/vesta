<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 13/01/15
  Time: 04:40 PM
--%>

<%@ page import="vesta.proyectos.MarcoLogico; vesta.proyectos.Cronograma; vesta.parametros.poaPac.Mes; vesta.parametros.poaPac.Anio" contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <meta name="layout" content="main">
        <title>Cronograma del proyecto</title>

        <script type="text/javascript" src="${resource(dir: 'js/plugins/jquery-get-input-type', file: 'jquery.get-input-type.min.js')}"></script>

        %{--<link rel="stylesheet" type="text/css" href="${resource(dir: 'js/plugins/DataTables-1.10.4/media/css', file: 'jquery.dataTables.min.css')}">--}%
        %{--<script type="text/javascript" charset="utf8" src="${resource(dir: 'js/plugins/DataTables-1.10.4/media/js', file: 'jquery.dataTables.min.js')}"></script>--}%

        %{--<script src="${resource(dir: 'js/plugins/fixed-header-table-1.3', file: 'jquery.fixedheadertable.js')}"></script>--}%
        %{--<link rel="stylesheet" type="text/css" href="${resource(dir: 'js/plugins/fixed-header-table-1.3/css', file: 'defaultTheme.css')}"/>--}%

        <style type="text/css">
        table {
            font-size : 9pt;
        }

        td, th {
            vertical-align : middle !important;
        }

        .divTabla {
            max-height : 450px;
            overflow-y : auto;
            overflow-x : hidden;
        }

        tr:hover .disabled {
            background : #ccc !important;
        }

        tfoot {
            font-size : larger;
        }
        </style>

    </head>

    <body>
        <!-- botones -->
        <div class="btn-toolbar toolbar">
            <div class="btn-group">
                <g:link controller="proyecto" action="list" params="${params}" class="btn btn-sm btn-default">
                    <i class="fa fa-list"></i> Lista de proyectos
                </g:link>
            </div>

            <div class="btn-group">
                <a href="#" class="btn btn-sm btn-default" id="btnGenerar">
                    <i class="fa fa-briefcase"></i> Generar asignaciones del proyecto
                </a>
                <g:link controller="asignacion" action="asignacionProyectov2" id="${proyecto.id}" class="btn btn-sm btn-default">
                    <i class="fa fa-money"></i> Asignaciones
                </g:link>
            </div>
            <g:if test="${params.act}">
                <div class="btn-group">
                    <g:link controller="marcoLogico" action="marcoLogicoProyecto" id="${proyecto.id}" class="btn btn-sm btn-default"
                            params="[list: params.list]">
                        <i class="fa fa-calendar-o"></i> Plan de proyecto
                    </g:link>
                </div>
            </g:if>
        </div>

        <g:if test="${proyecto.aprobado == 'a'}">
            <div class="alert alert-info">
                El proyecto está aprobado, no puede modificar el cronograma
            </div>
        </g:if>

        <elm:container tipo="horizontal" titulo="Modificar cronograma del proyecto ${proyecto?.toStringMedio()}, para el año ${anio}" color="black">
            <div class="divIndice ">
                <g:each in="${componentes}" var="comp">
                    <a href="#comp${comp.id}" class="scrollComp ">
                        <strong>Componente ${comp.numeroComp}</strong>:
                    ${(comp.objeto.length() > 100) ? comp.objeto.substring(0, 100) + "..." : comp.objeto}
                    </a>
                </g:each>
            </div>

            <div class="divTabla">
                <table class="table table-condensed table-bordered table-hover table-striped" id="tblCrono">
                    <thead>
                        <tr>
                            <th></th>
                            <th colspan="15">
                                <g:select from="${Anio.list([sort: 'anio'])}" optionKey="id" optionValue="anio" class="form-control input-sm"
                                          style="width: 100px; display: inline" name="anio" id="anio" value="${anio.id}"/>
                            </th>
                        </tr>

                        <tr id="trMeses">
                            <th style="width:300px;">Componentes/Rubros</th>
                            <g:each in="${Mes.list()}" var="mes">
                                <th style="width:100px;" data-id="${mes.id}" title="${mes.descripcion} ${anio.anio}">
                                    ${mes.descripcion[0..2]}.
                                </th>
                            </g:each>
                            <th>Tot. Asignado</th>
                            <th>Sin asignar</th>
                            <th>Total</th>
                        </tr>
                    </thead>
                    <tbody>
                        <g:set var="totProy" value="${0}"/>
                        <g:set var="totProyAsig" value="${0}"/>
                        <g:set var="totalMetas" value="${0}"/>
                        <g:set var="totalMetasCronograma" value="${0}"/>

                        <g:each in="${componentes}" var="comp" status="j">
                            <g:set var="totComp" value="${0}"/>
                            <g:set var="totCompAsig" value="${0}"/>
                            <tr id="comp${comp.id}">
                                <th colspan="16" class="success">
                                    <strong>Componente ${comp.numeroComp}</strong>:
                                ${(comp.objeto.length() > 80) ? comp.objeto.substring(0, 80) + "..." : comp.objeto}
                                </th>
                            </tr>
                            <g:each in="${MarcoLogico.findAllByMarcoLogicoAndEstado(comp, 0, [sort: 'id'])}" var="act" status="i">
                                <g:if test="${!actSel || (actSel && actSel.id == act.id)}">
                                    <g:set var="monto" value="${act.monto}"/>
                                    <g:set var="totComp" value="${totComp.toDouble() + monto}"/>
                                    <g:set var="tot" value="${0}"/>
                                    <g:set var="totAct" value="${monto}"/>
                                    <g:set var="tot" value="${act.getTotalCronograma()}"/>
                                    <g:set var="totCompAsig" value="${totCompAsig + act.getTotalCronograma()}"/>
                                    <g:set var="totalMetas" value="${totalMetas.toDouble() + monto}"/>
                                    <g:set var="totalMetasCronograma" value="${totalMetasCronograma.toDouble() + totalMetas}"/>
                                    <g:set var="totalMetas" value="${0}"/>
                                    <g:set var="totProyAsig" value="${totProyAsig.toDouble() + totCompAsig.toDouble()}"/>
                                    <g:set var="totProy" value="${totProy.toDouble() + totComp.toDouble()}"/>

                                    <tr data-id="${act.id}">
                                        <th class="success actividad" title="${act.responsable} - ${act.objeto}" style="width:300px;">
                                            ${(act.objeto.length() > 100) ? act.objeto.substring(0, 100) + "..." : act.objeto}
                                        </th>
                                        <g:each in="${Mes.list()}" var="mes" status="k">
                                            <g:set var="crga" value='${Cronograma.findAllByMarcoLogicoAndMes(act, mes)}'/>
                                            <g:set var="valor" value="${0}"/>
                                            <g:set var="clase" value="disabled"/>

                                            <g:if test="${crga.size() > 0}">
                                                <g:each in="${crga}" var="c">
                                                    <g:if test="${c?.anio == anio}">
                                                        <g:set var="crg" value='${c}'/>
                                                    </g:if>
                                                </g:each>
                                                <g:if test="${crg}">
                                                    <g:set var="valor" value="${crg.valor + crg.valor2}"/>
                                                    <g:set var="clase" value="clickable"/>
                                                </g:if>
                                            </g:if>
                                            <g:if test="${monto.toDouble() > 0}">
                                                <g:set var="clase" value="clickable"/>
                                            </g:if>
                                            <td style="width:100px;" class="text-right ${clase} ${crg && crg.fuente ? 'fnte_' + crg.fuente.id : ''} ${crg && crg.fuente2 ? 'fnte_' + crg.fuente2.id : ''}"
                                                data-id="${crg?.id}" data-val="${valor}"
                                                data-presupuesto1="${crg?.valor}" data-bsc-desc-partida1="${crg?.presupuesto?.toString()}"
                                                data-partida1="${crg?.presupuesto?.id}" data-fuente1="${crg?.fuente?.id}"
                                                data-presupuesto2="${crg?.valor2}" data-bsc-desc-partida2="${crg?.presupuesto2?.toString()}"
                                                data-partida2="${crg?.presupuesto2?.id}" data-fuente2="${crg?.fuente2?.id}">
                                                <g:formatNumber number="${valor}" type="currency" currencySymbol=""/>
                                            </td>
                                            <g:if test="${crg}">
                                                <g:set var="crg" value="${null}"/>
                                            </g:if>
                                        </g:each>
                                        <th class="disabled text-right asignado" data-val="${tot}">
                                            <g:formatNumber number="${tot}" type="currency" currencySymbol=""/>
                                        </th>
                                        <th class="disabled text-right sinAsignar" data-val="${act.monto - tot}">
                                            <g:formatNumber number="${act.monto - tot.toDouble()}" type="currency" currencySymbol=""/>
                                        </th>
                                        <th class="disabled text-right total" data-val="${monto}">
                                            <g:formatNumber number="${monto}" type="currency" currencySymbol=""/>
                                        </th>
                                    </tr>
                                </g:if>
                            </g:each>
                            <tr class="warning">
                                <th colspan="13">TOTAL</th>
                                <th class="text-right">
                                    <g:formatNumber number="${totCompAsig}" type="currency" currencySymbol=""/>
                                </th>
                                <th class="text-right">
                                    <g:formatNumber number="${(totComp.toDouble() - totCompAsig.toDouble())}" type="currency" currencySymbol=""/>
                                </th>
                                <th class="text-right">
                                    <g:formatNumber number="${totalMetas}" type="currency" currencySymbol=""/>
                                </th>
                            </tr>
                        </g:each>
                    </tbody>
                    <tfoot>
                        <tr class="danger">
                            <th colspan="13">TOTAL DEL PROYECTO</th>
                            <th class="text-right">
                                <g:formatNumber number="${totProyAsig}" type="currency" currencySymbol=""/>
                            </th>
                            <th class="text-right">
                                <g:formatNumber number="${(totProy.toDouble() - totProyAsig.toDouble())}" type="currency" currencySymbol=""/>
                            </th>
                            <th class="text-right">
                                <g:formatNumber number="${(totalMetasCronograma)}" type="currency" currencySymbol=""/>
                            </th>
                        </tr>
                    </tfoot>
                </table>
            </div>
        </elm:container>
        <div class="modal fade" id="modalCrono">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span>
                        </button>
                        <h4 class="modal-title" id="modalTitle">Cronograma</h4>
                    </div>

                    <div class="modal-body">
                        <div id="noFuentes" class="alert alert-danger ${fuentes.size() == 0 ? '' : 'hidden'}">
                            <span class="fa-stack fa-lg">
                                <i class="fa fa-money text-success fa-stack-1x"></i>
                                <i class="fa fa-ban fa-stack-2x"></i>
                            </span> No se encontraron fuentes! Debe asignar al menos una para poder modificar el cronograma.
                        </div>

                        <div id="divOk" class="${fuentes.size() == 0 ? 'hidden' : ''}">
                            <div class="alert alert-info">
                                <div id="divActividad"></div>

                                <div id="divInfo" class="text-warning"></div>
                            </div>

                            <g:form action="save_ajax" class="form-horizontal frmCrono" style="height: 300px; overflow:auto;">
                                <elm:fieldRapido label="Presupuesto (1)" claseLabel="col-md-3" claseField="col-md-4">
                                    <div class="input-group input-group-sm">
                                        <g:textField name="presupuesto1" class="form-control required number money"/>
                                        <span class="input-group-addon"><i class="fa fa-usd"></i></span>
                                    </div>
                                </elm:fieldRapido>
                                <elm:fieldRapido label="Partida (1)" claseLabel="col-md-3" claseField="col-md-4">
                                    <bsc:buscador name="partida1" id="partida1" controlador="asignacion"
                                                  accion="buscarPresupuesto" tipo="search" titulo="Busque una partida"
                                                  campos="${campos}" clase="required"/>
                                </elm:fieldRapido>
                                <elm:fieldRapido label="Fuente (1)" claseLabel="col-md-3" claseField="col-md-7">
                                    <elm:select name="fuente1" from="${fuentes}" id="fuente1"
                                                optionKey="${{ it.fuente.id }}"
                                                optionValue="${{
                                                    it.fuente.descripcion + ' (' + g.formatNumber(number: it.monto, type: 'currency') + ')'
                                                }}"
                                                optionClass="${{
                                                    g.formatNumber(number: it.monto, minFractionDigits: 2, maxFractionDigits: 8)
                                                }}"
                                                class="form-control input-sm"/>
                                </elm:fieldRapido>
                                <hr/>
                                <elm:fieldRapido label="Presupuesto (2)" claseLabel="col-md-3" claseField="col-md-4">
                                    <div class="input-group input-group-sm">
                                        <g:textField name="presupuesto2" class="form-control number money"/>
                                        <span class="input-group-addon"><i class="fa fa-usd"></i></span>
                                    </div>
                                </elm:fieldRapido>
                                <elm:fieldRapido label="Partida (2)" claseLabel="col-md-3" claseField="col-md-4">
                                %{--<bsc:buscador name="partida2" id="partida2" controlador="asignacion"--}%
                                %{--accion="buscarPresupuesto" tipo="search" titulo="Busque una partida"--}%
                                %{--campos="${campos}" clase=""/>--}%
                                    <span class="grupo">
                                        <div class="input-group input-group-sm" style="width:294px;">
                                            <input type="text" class="form-control bsc_desc-2 buscador-2 " id="bsc-desc-partida2" name="bsc-desc-partida2">
                                            <span class="input-group-btn">
                                                <a href="#" id="btn-abrir-2" class="btn btn-info buscador-2" title="Buscar"><span class="glyphicon glyphicon-search" aria-hidden="true"></span>
                                                </a>
                                            </span>
                                        </div>
                                    </span>
                                    <input type="hidden" id="partida2" class="bsc_id " name="partida2" value="">
                                </elm:fieldRapido>
                                <elm:fieldRapido label="Fuente (2)" claseLabel="col-md-3" claseField="col-md-7">
                                    <elm:select name="fuente2" from="${fuentes}" id="fuente2"
                                                optionKey="${{ it.fuente.id }}"
                                                optionValue="${{
                                                    it.fuente.descripcion + ' (' + g.formatNumber(number: it.monto, type: 'currency') + ')'
                                                }}"
                                                optionClass="${{
                                                    g.formatNumber(number: it.monto, minFractionDigits: 2, maxFractionDigits: 8)
                                                }}"
                                                class="form-control input-sm"/>
                                </elm:fieldRapido>
                            </g:form>
                        </div>
                    </div>

                    <div class="modal-footer">
                        <a href="#" class="btn btn-default" id="btnModalCancel">${fuentes.size() == 0 ? 'Cerrar' : 'Cancelar'}</a>
                        <g:if test="${fuentes.size() > 0}">
                            <a href="#" class="btn btn-success" id="btnModalSave"><i class="fa fa-save"></i> Guardar</a>
                        </g:if>
                    </div>
                </div><!-- /.modal-content -->
            </div><!-- /.modal-dialog -->
        </div><!-- /.modal -->

        <script type="text/javascript">
            function armaParams() {
                var params = "";
                if ("${params.search_programa}" != "") {
                    params += "search_programa=${params.search_programa}";
                }
                if ("${params.search_nombre}" != "") {
                    if (params != "") {
                        params += "&";
                    }
                    params += "search_nombre=${params.search_nombre}";
                }
                if ("${params.search_desde}" != "") {
                    if (params != "") {
                        params += "&";
                    }
                    params += "search_desde=${params.search_desde}";
                }
                if ("${params.search_hasta}" != "") {
                    if (params != "") {
                        params += "&";
                    }
                    params += "search_hasta=${params.search_hasta}";
                }
                if (params != "") {
                    params = "&" + params;
                }
                return params;
            }

            function enviarDos() {
                var data = "";
                openLoader();
                $(".crit").each(function () {
                    data += "&campos=" + $(this).attr("campo");
                    data += "&operadores=" + $(this).attr("operador");
                    data += "&criterios=" + $(this).attr("criterio");
                });
                if (data.length < 2) {
                    data = "tc=" + $("#tipoCampo").val() + "&campos=" + $("#campo :selected").val() + "&operadores=" + $("#operador :selected").val() + "&criterios=" + $("#criterio").val()
                }
                data += "&ordenado=" + $("#campoOrdn :selected").val() + "&orden=" + $("#orden :selected").val();
                $.ajax({
                    type    : "POST", url : "${g.createLink(controller: "cronograma",action: "buscarPresupuesto")}",
                    data    : data,
                    success : function (msg) {
                        $(".contenidoBuscador").html(msg).show("slide");
                        closeLoader();
                    }
                });
            }

            function resetForm() {
                $("#presupuesto1").val("");
                $("#bsc-desc-partida1").val("");
                $("#partida1").val("");
                $("#fuente1").find("option").first().attr("selected");

                $("#presupuesto2").val("");
                $("#bsc-desc-2").val("");
                $("#partida2").val("");
                $("#fuente2").find("option").first().attr("selected");
            }

            function setForm($td) {
                $.each($td.data(), function (key, val) {
                    var id = key.replace(/([a-z])([A-Z])/g, '$1-$2').toLowerCase();
                    var $field = $("#" + id);
                    if ($field.length > 0) {
                        var type = $field.getInputType();
                        if (type == "select") {
                            if (val == "") {
                                $field.find("option").first().prop("selected");
                            } else {
                                $field.val(val);
                            }
                        } else {
                            $field.val(val);
                        }
                    }
                });
                var $ntd = $td;
                var partida1 = $ntd.data("partida1");
                var descPartida1 = $ntd.data("bsc-desc-partida1");
//                var partida2 = $ntd.data("partida2");
//                var descPartida2 = $ntd.data("bsc-desc-partida2");

                if (!partida1 /*&& !partida2*/) {
                    while (!partida1) {
                        $ntd = $ntd.prev();
                        partida1 = $ntd.data("partida1");
                        descPartida1 = $ntd.data("bsc-desc-partida1");
//                        partida2 = $ntd.data("partida2");
//                        descPartida2 = $ntd.data("bsc-desc-partida2");
                    }
                    $("#partida1").val(partida1);
//                    $("#partida2").val(partida2);
                    $("#bsc-desc-partida1").val(descPartida1);
//                    $("#bsc-desc-partida2").val(descPartida2);
                }
            }

            $(function () {

                var validator = $(".frmCrono").validate({
                    errorClass     : "help-block",
                    rules          : {
                        presupuesto1 : {
                            tdnMax     : function () {
                                var $fuente = $("#fuente1");
                                var id = $fuente.val();
                                var valor = parseFloat($fuente.find("option:selected").attr("class"));
                                var usado = 0;
                                $(".fnte_" + id).each(function () {
                                    usado += parseFloat($(this).data("val"));
                                });
                                return valor - usado;
                            },
                            tdnMaxSuma : {
                                params : ["#presupuesto2", "#divInfo", "sinAsignar"]
                            }
                        },
                        presupuesto2 : {
                            tdnMax     : function () {
                                var $fuente = $("#fuente2");
                                var id = $fuente.val();
                                var valor = parseFloat($fuente.find("option:selected").attr("class"));
                                var usado = 0;
                                $(".fnte_" + id).each(function () {
                                    usado += parseFloat($(this).data("val"));
                                });
                                return valor - usado;
                            },
                            required   : {
                                depends : function (element) {
                                    var v1 = $.trim($("#bsc-desc-2").val());
                                    return v1 != "";
                                }
                            },
                            tdnMaxSuma : {
                                params : ["#presupuesto1", "#divInfo", "sinAsignar"]
                            }
                        },
                        "bsc-desc-2" : {
                            required : {
                                depends : function (element) {
                                    var v1 = $.trim($("#presupuesto2").val());
                                    return v1 != "";
                                }
                            }
                        }
                    },
                    messages       : {
                        presupuesto1 : {
                            tdnMaxSuma : "Por favor ingrese un valor inferior al por asignar"
                        },
                        presupuesto2 : {
                            tdnMaxSuma : "Por favor ingrese un valor inferior al por asignar"
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

                $("#btnModalCancel").click(function () {
                    validator.resetForm();
                    resetForm();
                    $(".has-error").removeClass("has-error");
                    $('#modalCrono').modal("hide");
                    return false;
                });

                $("#btnModalSave").click(function () {
                    var $frm = $(".frmCrono");
                    if ($frm.valid()) {
                        var $div = $("#divInfo");
                        var data = $frm.serialize();
                        data += "&id=" + $div.data("crono") + "&mes=" + $div.data("mes") + "&anio=${anio.id}" + "&act=" + $div.data("actividad");
                        openLoader();
                        $.ajax({
                            type    : "POST",
                            url     : $frm.attr("action"),
                            data    : data,
                            success : function (msg) {
                                var parts = msg.split("*");
                                log(parts[1], parts[0] == "SUCCESS" ? "success" : "error"); // log(msg, type, title, hide)
                                if (parts[0] == "SUCCESS") {
                                    setTimeout(function () {
                                        if (parts[0] == "SUCCESS") {
                                            location.reload(true);
                                        }
                                    }, 1000);
                                } else {
                                    closeLoader();
                                }
                            }
                        });
                    }
                    return false;
                });

                $(".clickable").click(function () {
                    var $this = $(this);
                    var $tr = $this.parents("tr");
                    var $mes = $("#trMeses").children().eq($this.index());
                    var mes = $mes.attr("title");
                    $('#modalCrono').modal("show");
                    $("#modalTitle").text("Cronograma - " + mes);

                    if (!$("#divOk").hasClass("hidden")) {
                        var $actividad = $tr.find(".actividad");
                        var $asignado = $tr.find(".asignado");
                        var $sinAsignar = $tr.find(".sinAsignar");
                        var $total = $tr.find(".total");

                        var actividad = $actividad.attr("title");
                        var asignado = $asignado.data("val");
                        var sinAsignar = $sinAsignar.data("val");
                        var total = $total.data("val");

                        $("#divActividad").text(actividad);
                        $("#divInfo").html("<ul>" +
                                           "<li><strong>Monto total:</strong> $" + number_format(total, 2, ".", ",") + "</li>" +
                                           "<li><strong>Asignado:</strong> $" + number_format(asignado, 2, ".", ",") + "</li>" +
                                           "<li><strong>Por asignar:</strong> $" + number_format(sinAsignar, 2, ".", ",") + "</li>" +
                                           "</ul>").data({
                            total      : total,
                            asignado   : asignado,
                            sinAsignar : sinAsignar,
                            crono      : $this.data("id"),
                            mes        : $mes.data("id"),
                            actividad  : $tr.data("id")
                        });
//                        if (parseFloat(sinAsignar) <= 0) {
//                            $(".frmCrono").addClass("hidden");
//                            $("#btnModalSave").addClass("hidden");
//                            $("#btnModalCancel").text("Cerrar");
//                        } else {
                        $(".frmCrono").removeClass("hidden");
                        $("#btnModalSave").removeClass("hidden");
                        $("#btnModalCancel").text("Cancelar");
//                        }
                        setForm($this);
                    }
                });

                var $container = $(".divTabla");
                $container.scrollTop(0 - $container.offset().top + $container.scrollTop());
                $("#anio").change(function () {
                    openLoader();
                    location.href = "${createLink(controller: 'cronograma', action: 'form', id: proyecto.id)}?anio=" + $("#anio").val() +
                                    armaParams() + "&act=${actSel?.id}";
                });

                $(".scrollComp").click(function () {
                    var $scrollTo = $($(this).attr("href"));
                    $container.animate({
                        scrollTop : $scrollTo.offset().top - $container.offset().top + $container.scrollTop()
                    });
                    return false;
                });

                $("#btnGenerar").click(function () {
                    var msg = "<i class='fa fa-warning fa-5x pull-left text-danger text-shadow'></i><p>" +
                              "<p class='lead'>¿Está seguro que desea generar las asignaciones del P.A.I. del año señalado?</p>" +
                              "<p class='lead'>Las asignaciones generadas anteriormente serán <span class='text-danger'><strong>ELIMINADAS</strong></span> " +
                              "así como su PAC y programación.</p>" +
                              "<p class='lead'>Los datos borrados no podrán ser recuperados.</p> " +
                              "<p class='lead text-warning'>Esta acción será registrada en log del sistema junto con su usuario</p>";
                    bootbox.confirm(msg, function (result) {
                        if (result) {
                            openLoader();
                            $.ajax({
                                type    : "POST",
                                url     : "${createLink(action:'calcularAsignaciones_ajax')}",
                                data    : {
                                    anio     : "${anio.id}",
                                    proyecto : "${proyecto.id}"
                                },
                                success : function (msg) {
                                    var parts = msg.split("*");
                                    log(parts[1], parts[0] == "SUCCESS" ? "success" : "error"); // log(msg, type, title, hide)
                                    setTimeout(function () {
                                        if (parts[0] == "SUCCESS") {
//                                            if (id) {
                                                location.href = "${createLink(controller: 'asignacion', action: 'asignacionProyectov2', params:[id:proyecto.id, anio:anio.id])}";
//                                            }
                                        }
                                        closeLoader();
                                    }, 1000);
                                }
                            });
                        }
                    });
                });

                /* **************** AQUI LO DEL BUSCADOR *********************************/

                var $btnDlg = $("#buscarDialog");

                $(".bsc_desc").click(function () {
                    $("#" + $(this).attr("dialog")).modal("show");
                    $(".contenidoBuscador").html("");
                    $btnDlg.unbind("click");
                    $btnDlg.bind("click", function () {
                        enviar();
                    });
                }).focus(function () {
                    $("#" + $(this).attr("dialog")).modal("show");
                    $(".contenidoBuscador").html("");
                    $btnDlg.unbind("click");
                    $btnDlg.bind("click", function () {
                        enviar();
                    });
                });
                $(".bsc_desc-2").click(function () {
                    $("#" + $(this).attr("dialog")).modal("show");
                    $(".contenidoBuscador").html("");
                    $btnDlg.unbind("click");
                    $btnDlg.bind("click", function () {
                        enviar();
                    });
                }).focus(function () {
                    $("#" + $(this).attr("dialog")).modal("show");
                    $(".contenidoBuscador").html("");
                    $btnDlg.unbind("click");
                    $btnDlg.bind("click", function () {
                        enviarDos();
                    });
                });
                $("#btn-abrir-partida1").unbind("click").bind("click", function () {
                    $(".contenidoBuscador").html("");
                    $btnDlg.unbind("click");
                    $btnDlg.bind("click", function () {
                        enviar();
                    });
                    $("#modal-partida1").modal("show")
                });

                $(".buscador-2").click(function () {
                    $(".contenidoBuscador").html("");
                    $btnDlg.unbind("click");
                    $btnDlg.bind("click", function () {
                        enviarDos();
                    });
                    $(".modal-search").modal("show")
                });
            });
        </script>

    </body>
</html>