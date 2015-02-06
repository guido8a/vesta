<%@ page import="vesta.parametros.TipoElemento" contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta name="layout" content="main"/>
    <title>Avances físicos</title>
    <link rel="stylesheet" href="${resource(dir: 'css/custom', file: 'semaforos.css')}" type="text/css"/>
</head>

<body>

<elm:message tipo="${flash.tipo}" clase="${flash.clase}">${flash.message}</elm:message>

<div class="fila">
    <div class="btn-toolbar toolbar">
        <div class="btn-group">
            <g:link controller="avales" action="listaProcesos" class="btn btn-default"><i class="fa fa-bars"></i> Lista de procesos</g:link>
        </div>
    </div>

    <div style="display: inline-block;margin-left: 45px;margin-bottom: 0px; float: right">
        Código de colores:
        <div class="semaforo green"></div>100% - 76%
        <div class="semaforo yellow"></div>75% - 51%
        <div class="semaforo orange"></div>50% - 26%
        <div class="semaforo red"></div>25% - 0%
    </div>

</div>
<fieldset style="width: 100%;height: 190px; margin-bottom: 20px" class="ui-corner-all">
    <legend>Proceso</legend>

    <div style="width: 65%;float: left;height: 110%" class="alert alert-info">

        <div class="form-group keeptogether">
            <span class="grupo">
                <label class="col-md-3 control-label">
                    Proyecto
                </label>

                <div class="col-md-2">
                    ${proceso.proyecto}
                </div>
            </span>
        </div>

        <div class="form-group keeptogether">
            <span class="grupo">
                <label class="col-md-3 control-label">
                    Fecha inicio:</label>
                <div class="col-md-2">
                    ${proceso.fechaInicio.format("dd-MM-yyyy")}
                </div>
                <label class="col-md-2 control-label">Fecha fin:</label>
                <div class="col-md-2">
                    ${proceso.fechaFin.format("dd-MM-yyyy")}
                </div>
            </span>
        </div>

        <div class="form-group keeptogether">
            <span class="grupo">
                <label class="col-md-3 control-label">Nombre:</label>
                <div class="col-md-6">
                    ${proceso.nombre}
                </div>
            </span>
        </div>

        <div class="form-group keeptogether">
            <span class="grupo">
                <label class="col-md-3 control-label">Reportar cada:</label>
                <div class="col-md-4">
                    ${proceso.informar} Días
                </div>
            </span>
        </div>
    </div>

    <div style="width: 34%;float: left;height: 110%;font-size: 11px" class="alert alert-success">
        <g:set var="dataProceso" value="${proceso.getColorSemaforo()}"/>
        <div class="form-group keeptogether">
            <span class="grupo">
                <label class="col-md-6 control-label">
                    Avance real al ${new java.util.Date().format("dd/MM/yyyy")}:
                </label>
                <div class="col-md-4">
                    ${dataProceso[1]}% (a)
                </div>
            </span>
        </div>

        <div class="form-group keeptogether">
            <span class="grupo">
                <label class="col-md-6 control-label">
                    Avance esperado:
                </label>
                <div class="col-md-4">
                    ${dataProceso[0].toDouble().round(2)}% (b)
                </div>
            </span>
        </div>

        <div class="form-group keeptogether" style="margin-left: 14px">
            <span class="grupo">
                <div class="semaforo ${dataProceso[2]}" title="Avance esperado al ${new Date().format('dd/MM/yyyy')}: ${dataProceso[0].toDouble().round(2)}%, avance registrado: ${dataProceso[1].toDouble().round(2)}%">
                </div>
                <b>Gestión:</b> <g:formatNumber number="${dataProceso[1]/dataProceso[0]*100}" format="###,##0" minFractionDigits="2" maxFractionDigits="2"/>% (a/b)
            </span>
        </div>

        <div class="form-group keeptogether" style="margin-top: 10px">
            <span class="grupo">
                <label class="col-md-6 control-label">
                    Último Avance:
                </label>
                <div class="col-md-6">
                    ${dataProceso[3]}
                </div>
            </span>
        </div>
    </div>

</fieldset>
<fieldset style="width: 100%;height: 350px;overflow: auto" class="ui-corner-all">
    <legend>Subactividades</legend>

    <div class="fila" style="margin-bottom: 10px;">
        <a href="#" class="btn btn-success btn-sm btnAgregar" id="btnOpenDlg"><i class="fa fa-plus"></i> Agregar</a>
    </div>

    <div id="detalle" style="width: 100%; overflow: auto;"></div>
</fieldset>

%{--<g:if test="${proceso}">--}%
%{--<div id="dlgNuevo">--}%
%{--<div class="fila">--}%
%{--<div class="labelSvt">Aporte:</div>--}%

%{--<div class="fieldSvt-small">--}%
%{--<g:textField name="avance" class="ui-widget-content ui-corner-all" style="width: 50px;"/> %--}%
%{--</div>--}%

%{--<div class="labelSvt" style="width: 75px;">Inicio:</div>--}%

%{--<div class="fieldSvt-small">--}%
%{--<g:textField name="inicio" class="datepickerR ui-widget-content ui-corner-all" id="inicio" style="width: 100%;padding-right: 0px;"/>--}%
%{--</div>--}%

%{--<div class="labelSvt" style="width: 75px;">Fin:</div>--}%

%{--<div class="fieldSvt-small">--}%
%{--<g:textField name="fin" class="datepickerR ui-widget-content ui-corner-all" id="fin" style="width: 100%;padding-right: 0px"/>--}%
%{--</div>--}%
%{--</div>--}%

%{--<div class="fila" style="height: 95px;">--}%
%{--<div class="labelSvt">Descripción:</div>--}%

%{--<div class="fieldSvt-xxl">--}%
%{--<g:if test="${proceso}">--}%
%{--<g:textArea name="observaciones" rows="5" cols="68" class="ui-widget-content ui-corner-all"/>--}%
%{--</g:if>--}%
%{--</div>--}%
%{--</div>--}%
%{--</div>--}%
%{--</g:if>--}%

<script type="text/javascript">
    var max = parseFloat("${maxAvance}");
    var min = parseFloat("${minAvance}");

    $(".btnAgregar").click(function () {
        agregarSub ();
    });

    function agregarSub() {

        $.ajax({
            type : "POST",
            url : "${createLink(action: 'agregarSubact', id: proceso?.id)}",
            %{--id : ${proceso?.id},--}%
            success : function (msg) {
                var b = bootbox.dialog ({
                    id: "dlgAgregarSub",
                    title: "Agregar Subactividad",
                    class : "modal-lg",
                    message: msg,
                    buttons : {
                        guardar : {
                            id: "btnGuardar",
                            label : "<i class='fa fa-save'></i> Guardar",
                            classname: "btn-success",
                            callback: function () {
                                var aporte = $.trim($("#aporte").val());
                                var inicio = $.trim($("#inicioSub_input").val());
                                var fin = $.trim($("#finSub_input").val());
                                var obs = $.trim($("#observaciones").val());
                                var id = "${proceso.id}";
                                if (aporte == "" || inicio == "" || fin == "" || obs.length < 1) {
                                    log("Por favor ingrese el porcentaje de aportación, las fechas y la descripción de la sub actividad","error")
                                    return false
                                }else{
                                    if (isNaN(aporte)) {
                                        log("Por favor ingrese un número válido en el porcentaje de avance","error")
                                        return false
                                    }else{
                                        aporte = parseFloat(aporte);
                                        if(aporte > max){
                                            log("El aporte ingresado debe ser un número menor a " + max, "error")
                                            return false
                                        }else{
                                            $.ajax({
                                                type    : "POST",
                                                url     : "${createLink(action:'addAvanceFisicoProceso_ajax')}",
                                                data    : {
                                                    id            : id,
                                                    avance        : aporte,
                                                    inicio        : inicio,
                                                    fin           : fin,
                                                    observaciones : obs
                                                },
                                                success : function (msg) {
                                                    updateAll(msg);
                                                    var $d = $('#detalle');
                                                    $d.animate({scrollTop: $d[0].scrollHeight}, 1000);
                                                    var parts = msg.split("*");
                                                    log(parts[1], parts[0] == "SUCCESS" ? "success" : "error"); // log(msg, type, title, hide)
                                                    if (parts[0] == "SUCCESS") {
                                                        setTimeout(function () {
                                                            location.reload(true);
                                                        }, 1000);
                                                    } else {
                                                        closeLoader();
                                                    }
                                                }
                                            });
                                        }
                                    }
                                }
                            }

                        },
                        cancelar : {
                            label : "Cancelar",
                            classname: "btn-primary",
                            callback: function () {

                            }

                        }
                    }
                })
            }
        });

    };

    function loadTabla() {
        $.ajax({
            type    : "POST",
            url     : "${createLink(action:'avanceFisicoProceso_ajax')}",
            data    : {
                id : "${proceso.id}"
            },
            success : function (msg) {
                $("#detalle").html(msg);
            }
        });
    }

    function setMinDate(minDate) {
//                var date = Date.parse(minDate, "dd-MM-yyyy");
//                if (minDate != "") {
//                    $(".datepicker").datepicker("option", "minDate", date);
//                } else {
//                    $(".datepicker").datepicker("option", "minDate", new Date(1900, 0, 1));
//                }
    }

    function updateAll(msg) {
        var parts = msg.split("_");
        if (parts[0] == "OK") {
            min = parseFloat(parts[1]);
            max = parseFloat(parts[2]);
            setMinDate(parts[3]);
            loadTabla();
        }
    }

    $(function () {
        $("#dlgNuevo").dialog({
            autoOpen : false,
            modal    : true,
            width    : 750,
            title    : "Nueva sub actividad",
            close    : function (event, ui) {
                $("#avance").val("");
                $("#inicio").val("");
                $("#fin").val("");
                $("#observaciones").val("");
            },
            buttons  : {
                "Guardar"  : function () {
                    var avance = $.trim($("#avance").val());
                    var inicio = $.trim($("#inicio").val());
                    var fin = $.trim($("#fin").val());
                    var obs = $.trim($("#observaciones").val());
                    var id = "${proceso.id}";
                    if (avance == "" || inicio == "" || fin == "" || obs.length < 1) {
                        $.box({
                            imageClass : "box_info",
                            text       : "Por favor ingrese el porcentaje de aportación, las fechas y la descripción de la sub actividad",
                            title      : "Alerta",
                            iconClose  : false,
                            dialog     : {
                                resizable     : false,
                                draggable     : false,
                                closeOnEscape : false,
                                buttons       : {
                                    "Aceptar" : function () {
                                    }
                                }
                            }
                        });
                    } else {
                        if (isNaN(avance)) {
                            $.box({
                                imageClass : "box_info",
                                text       : "Por favor ingrese un número válido en el porcentaje de avance",
                                title      : "Alerta",
                                iconClose  : false,
                                dialog     : {
                                    resizable     : false,
                                    draggable     : false,
                                    closeOnEscape : false,
                                    buttons       : {
                                        "Aceptar" : function () {
                                        }
                                    }
                                }
                            });
                        } else {
                            avance = parseFloat(avance);
//                                    if (avance > max || avance < min) {
                            if (avance > max) {
                                $.box({
                                    imageClass : "box_info",
                                    text       : "Por favor ingrese un número menor a " + max,
                                    title      : "Alerta",
                                    iconClose  : false,
                                    dialog     : {
                                        resizable     : false,
                                        draggable     : false,
                                        closeOnEscape : false,
                                        buttons       : {
                                            "Aceptar" : function () {
                                            }
                                        }
                                    }
                                });
                            } else {
                                $.ajax({
                                    type    : "POST",
                                    url     : "${createLink(action:'addAvanceFisicoProceso_ajax')}",
                                    data    : {
                                        id            : id,
                                        avance        : avance,
                                        inicio        : inicio,
                                        fin           : fin,
                                        observaciones : obs
                                    },
                                    success : function (msg) {
                                        updateAll(msg);
                                        var $d = $('#detalle');
                                        $d.animate({scrollTop : $d[0].scrollHeight}, 1000);
                                    }
                                });
                            }
                        }
                    }
                    $("#dlgNuevo").dialog("close");
                },
                "Cancelar" : function () {
                    $("#dlgNuevo").dialog("close");
                }
            }
        });

//        $("#btnOpenDlg").button({
//            icons : {
//                primary : "ui-icon-plusthick"
//            }
//        }).click(function () {
//            $("#dlgNuevo").dialog("open");
//            return false;
//        });


        $(".btn").button();
        $(".datepicker").datepicker();
        $(".datepickerR").datepicker({
            minDate : new Date(${proceso.fechaInicio.format("yyyy")}, ${proceso.fechaInicio.format("MM")}-1, ${proceso.fechaInicio.format("dd")})
        });
        loadTabla();
        setMinDate("${minDate}")
    });




</script>

</body>
</html>



%{--<%@ page import="vesta.hitos.AvanceFisico" %>--}%
%{--<!DOCTYPE html>--}%
%{--<html>--}%
%{--<head>--}%
%{--<meta name="layout" content="main">--}%
%{--<title>Lista de AvanceFisico</title>--}%
%{--</head>--}%
%{--<body>--}%

%{--<elm:message tipo="${flash.tipo}" clase="${flash.clase}">${flash.message}</elm:message>--}%

%{--<!-- botones -->--}%
%{--<div class="btn-toolbar toolbar">--}%
%{--<div class="btn-group">--}%
%{--<a href="#" class="btn btn-default btnCrear">--}%
%{--<i class="fa fa-file-o"></i> Crear--}%
%{--</a>--}%
%{--</div>--}%
%{--<div class="btn-group pull-right col-md-3">--}%
%{--<div class="input-group input-group-sm">--}%
%{--<input type="text" class="form-control input-sm input-search" placeholder="Buscar" value="${params.search}">--}%
%{--<span class="input-group-btn">--}%
%{--<g:link controller="avancefisico" action="list" class="btn btn-default btn-search">--}%
%{--<i class="fa fa-search"></i>&nbsp;--}%
%{--</g:link>--}%
%{--</span>--}%
%{--</div><!-- /input-group -->--}%
%{--</div>--}%
%{--</div>--}%

%{--<table class="table table-condensed table-bordered table-striped table-hover">--}%
%{--<thead>--}%
%{--<tr>--}%
%{----}%
%{--<th>Proceso</th>--}%
%{----}%
%{--<g:sortableColumn property="observaciones" title="Observaciones" />--}%
%{----}%
%{--<g:sortableColumn property="completado" title="Completado" />--}%
%{----}%
%{--<g:sortableColumn property="inicio" title="Inicio" />--}%
%{----}%
%{--<g:sortableColumn property="fin" title="Fin" />--}%
%{----}%
%{--<g:sortableColumn property="avance" title="Avance" />--}%
%{----}%
%{--<g:sortableColumn property="fecha" title="Fecha" />--}%
%{----}%
%{--</tr>--}%
%{--</thead>--}%
%{--<tbody>--}%
%{--<g:if test="${avanceFisicoInstanceCount > 0}">--}%
%{--<g:each in="${avanceFisicoInstanceList}" status="i" var="avanceFisicoInstance">--}%
%{--<tr data-id="${avanceFisicoInstance.id}">--}%
%{----}%
%{--<td>${avanceFisicoInstance.proceso}</td>--}%
%{----}%
%{--<td><elm:textoBusqueda busca="${params.search}"><g:fieldValue bean="${avanceFisicoInstance}" field="observaciones"/></elm:textoBusqueda></td>--}%
%{----}%
%{--<td><g:formatDate date="${avanceFisicoInstance.completado}" format="dd-MM-yyyy" /></td>--}%
%{----}%
%{--<td><g:formatDate date="${avanceFisicoInstance.inicio}" format="dd-MM-yyyy" /></td>--}%
%{----}%
%{--<td><g:formatDate date="${avanceFisicoInstance.fin}" format="dd-MM-yyyy" /></td>--}%
%{----}%
%{--<td><g:fieldValue bean="${avanceFisicoInstance}" field="avance"/></td>--}%
%{----}%
%{--<td><g:formatDate date="${avanceFisicoInstance.fecha}" format="dd-MM-yyyy" /></td>--}%
%{----}%
%{--</tr>--}%
%{--</g:each>--}%
%{--</g:if>--}%
%{--<g:else>--}%
%{--<tr class="danger">--}%
%{--<td class="text-center" colspan="7">--}%
%{--<g:if test="${params.search && params.search!= ''}">--}%
%{--No se encontraron resultados para su búsqueda--}%
%{--</g:if>--}%
%{--<g:else>--}%
%{--No se encontraron registros que mostrar--}%
%{--</g:else>--}%
%{--</td>--}%
%{--</tr>--}%
%{--</g:else>--}%
%{--</tbody>--}%
%{--</table>--}%

%{--<elm:pagination total="${avanceFisicoInstanceCount}" params="${params}"/>--}%

%{--<script type="text/javascript">--}%
%{--var id = null;--}%
%{--function submitForm() {--}%
%{--var $form = $("#frmAvanceFisico");--}%
%{--var $btn = $("#dlgCreateEdit").find("#btnSave");--}%
%{--if ($form.valid()) {--}%
%{--$btn.replaceWith(spinner);--}%
%{--openLoader("Guardando AvanceFisico");--}%
%{--$.ajax({--}%
%{--type    : "POST",--}%
%{--url     : $form.attr("action"),--}%
%{--data    : $form.serialize(),--}%
%{--success : function (msg) {--}%
%{--var parts = msg.split("*");--}%
%{--log(parts[1], parts[0] == "SUCCESS" ? "success" : "error"); // log(msg, type, title, hide)--}%
%{--setTimeout(function() {--}%
%{--if (parts[0] == "SUCCESS") {--}%
%{--location.reload(true);--}%
%{--} else {--}%
%{--spinner.replaceWith($btn);--}%
%{--return false;--}%
%{--}--}%
%{--}, 1000);--}%
%{--}--}%
%{--});--}%
%{--} else {--}%
%{--return false;--}%
%{--} //else--}%
%{--}--}%
%{--function deleteRow(itemId) {--}%
%{--bootbox.dialog({--}%
%{--title   : "Alerta",--}%
%{--message : "<i class='fa fa-trash-o fa-3x pull-left text-danger text-shadow'></i><p>" +--}%
%{--"¿Está seguro que desea eliminar el AvanceFisico seleccionado? Esta acción no se puede deshacer.</p>",--}%
%{--buttons : {--}%
%{--cancelar : {--}%
%{--label     : "Cancelar",--}%
%{--className : "btn-primary",--}%
%{--callback  : function () {--}%
%{--}--}%
%{--},--}%
%{--eliminar : {--}%
%{--label     : "<i class='fa fa-trash-o'></i> Eliminar",--}%
%{--className : "btn-danger",--}%
%{--callback  : function () {--}%
%{--openLoader("Eliminando AvanceFisico");--}%
%{--$.ajax({--}%
%{--type    : "POST",--}%
%{--url     : '${createLink(action:'delete_ajax')}',--}%
%{--data    : {--}%
%{--id : itemId--}%
%{--},--}%
%{--success : function (msg) {--}%
%{--var parts = msg.split("*");--}%
%{--log(parts[1], parts[0] == "SUCCESS" ? "success" : "error"); // log(msg, type, title, hide)--}%
%{--if (parts[0] == "SUCCESS") {--}%
%{--setTimeout(function() {--}%
%{--location.reload(true);--}%
%{--}, 1000);--}%
%{--} else {--}%
%{--closeLoader();--}%
%{--}--}%
%{--}--}%
%{--});--}%
%{--}--}%
%{--}--}%
%{--}--}%
%{--});--}%
%{--}--}%
%{--function createEditRow(id) {--}%
%{--var title = id ? "Editar" : "Crear";--}%
%{--var data = id ? { id: id } : {};--}%
%{--$.ajax({--}%
%{--type    : "POST",--}%
%{--url     : "${createLink(action:'form_ajax')}",--}%
%{--data    : data,--}%
%{--success : function (msg) {--}%
%{--var b = bootbox.dialog({--}%
%{--id      : "dlgCreateEdit",--}%
%{--title   : title + " AvanceFisico",--}%
%{----}%
%{--message : msg,--}%
%{--buttons : {--}%
%{--cancelar : {--}%
%{--label     : "Cancelar",--}%
%{--className : "btn-primary",--}%
%{--callback  : function () {--}%
%{--}--}%
%{--},--}%
%{--guardar  : {--}%
%{--id        : "btnSave",--}%
%{--label     : "<i class='fa fa-save'></i> Guardar",--}%
%{--className : "btn-success",--}%
%{--callback  : function () {--}%
%{--return submitForm();--}%
%{--} //callback--}%
%{--} //guardar--}%
%{--} //buttons--}%
%{--}); //dialog--}%
%{--setTimeout(function () {--}%
%{--b.find(".form-control").first().focus()--}%
%{--}, 500);--}%
%{--} //success--}%
%{--}); //ajax--}%
%{--} //createEdit--}%

%{--$(function () {--}%

%{--$(".btnCrear").click(function() {--}%
%{--createEditRow();--}%
%{--return false;--}%
%{--});--}%

%{--$("tbody>tr").contextMenu({--}%
%{--items  : {--}%
%{--header   : {--}%
%{--label  : "Acciones",--}%
%{--header : true--}%
%{--},--}%
%{--ver      : {--}%
%{--label  : "Ver",--}%
%{--icon   : "fa fa-search",--}%
%{--action : function ($element) {--}%
%{--var id = $element.data("id");--}%
%{--$.ajax({--}%
%{--type    : "POST",--}%
%{--url     : "${createLink(action:'show_ajax')}",--}%
%{--data    : {--}%
%{--id : id--}%
%{--},--}%
%{--success : function (msg) {--}%
%{--bootbox.dialog({--}%
%{--title   : "Ver AvanceFisico",--}%
%{--message : msg,--}%
%{--buttons : {--}%
%{--ok : {--}%
%{--label     : "Aceptar",--}%
%{--className : "btn-primary",--}%
%{--callback  : function () {--}%
%{--}--}%
%{--}--}%
%{--}--}%
%{--});--}%
%{--}--}%
%{--});--}%
%{--}--}%
%{--},--}%
%{--editar   : {--}%
%{--label  : "Editar",--}%
%{--icon   : "fa fa-pencil",--}%
%{--action : function ($element) {--}%
%{--var id = $element.data("id");--}%
%{--createEditRow(id);--}%
%{--}--}%
%{--},--}%
%{--eliminar : {--}%
%{--label            : "Eliminar",--}%
%{--icon             : "fa fa-trash-o",--}%
%{--separator_before : true,--}%
%{--action           : function ($element) {--}%
%{--var id = $element.data("id");--}%
%{--deleteRow(id);--}%
%{--}--}%
%{--}--}%
%{--},--}%
%{--onShow : function ($element) {--}%
%{--$element.addClass("success");--}%
%{--},--}%
%{--onHide : function ($element) {--}%
%{--$(".success").removeClass("success");--}%
%{--}--}%
%{--});--}%
%{--});--}%
%{--</script>--}%

%{--</body>--}%
%{--</html>--}%
