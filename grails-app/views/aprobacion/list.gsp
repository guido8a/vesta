<%@ page import="vesta.contratacion.Aprobacion" %>
<!DOCTYPE html>
<html>
<head>
    %{--<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>--}%
    <meta name="layout" content="main"/>
    %{--<g:set var="entityName"--}%
    %{--value="${message(code: 'aprobacion.label', default: 'Aprobacion')}"/>--}%
    <title>Reuniones de aprobación</title>

    %{--<style type="text/css">--}%
    %{--.btnSmall {--}%
    %{--font-size : 10px !important;--}%
    %{--}--}%

    %{--.btnSmall + .btnSmall {--}%
    %{--margin-top : 5px;--}%
    %{--}--}%

    %{--.ulSolicitudes {--}%
    %{--margin       : 0;--}%
    %{--padding-left : 20px;--}%
    %{--}--}%
    %{--</style>--}%
</head>

<body>

<elm:message tipo="${flash.tipo}" clase="${flash.clase}">${flash.message}</elm:message>


<g:set var="editables" value="${['ASPL', 'DP', 'GP']}"/> <!-- Asistente, Director, Gerente de Planificacion son los que pueden editar -->

<div class="dialog" >
    <div class="btn-toolbar toolbar">
        <g:if test="${editables.contains(session.perfil.codigo)}">

            <div class="btn-group">
                <g:link class="button create btn btn-default" action="prepararReunionAprobacion">
                    <i class="fa fa-file-o"></i> Nueva reunión
                </g:link>
                <a href="#" class="button print btn btn-default">
                    <i class="fa fa-print"></i> PDF aprobadas
                </a>
                <g:link controller="reporteSolicitud" action="aprobadasXLS" class="button xls btn btn-default">
                    <i class="fa fa-file-excel-o"></i> XLS aprobadas
                </g:link>
            </div> <!-- toolbar -->

        </g:if>
        <div class="btn-group pull-right col-md-3">
            <div class="input-group input-group-sm">
                <input type="text" class="form-control input-sm input-search" placeholder="Buscar" value="${params.search}">
                <span class="input-group-btn">
                    <g:link controller="aprobacion" action="list" class="btn btn-default btn-search">
                        <i class="fa fa-search"></i>&nbsp;
                    </g:link>
                </span>
            </div><!-- /input-group -->
        </div>
    </div>
    <div class="body">
        <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
        </g:if>
        %{--<div class="list">--}%
            <table class="table table-condensed table-bordered table-striped table-hover">
                <thead>
                <tr>
                    <th>N.</th>
                    <th style="width: 450px;">Solicitudes a tratar</th>
                    <g:sortableColumn property="fecha" title="Fecha" />
                    <g:sortableColumn property="observaciones" title="Observaciones" />
                    <g:sortableColumn property="asistentes" title="Asistentes" />
                    <th>Estado</th>
                    <th>Acciones</th>
                </tr>
                </thead>
                <tbody>
                <g:each in="${aprobacionInstanceList}" status="i" var="aprobacionInstance">
                    <tr class="${(i % 2) == 0 ? 'odd' : 'even'}" data-id="${aprobacionInstance.id}">
                        <td>${aprobacionInstance.numero}</td>
                        <td>
                            <g:set var="solicitudes" value="${vesta.contratacion.Solicitud.findAllByAprobacion(aprobacionInstance, [sort: 'nombreProceso'])}"/>
                            <g:if test="${solicitudes.size() > 0}">
                                <ul class="ulSolicitudes">
                                    <g:each in="${solicitudes}" var="sol">
                                        <li>
                                            <elm:textoBusqueda busca="${params.search}">
                                            ${sol.unidadEjecutora.nombre} - ${sol.nombreProceso}
                                            </elm:textoBusqueda>
                                        </li>
                                    </g:each>
                                </ul>
                            </g:if>
                            <g:else>
                                - Sin solicitudes -
                            </g:else>
                        </td>
                        <td>
                            <g:if test="${aprobacionInstance.fecha}">
                                ${aprobacionInstance.fecha.format("dd-MM-yyyy HH:mm")}
                            </g:if>
                            <g:else>
                                <a href="#" class="button btnSmall btnSetFecha" id="${aprobacionInstance.id}">
                                    Establecer
                                </a>
                            </g:else>
                        </td>
                        <td><${fieldValue(bean: aprobacionInstance, field: "observaciones")}</td>
                        <td>${fieldValue(bean: aprobacionInstance, field: "asistentes")}</td>
                        <td>${aprobacionInstance.aprobada == 'A' ? 'Aprobada' : 'Pendiente'}</td>
                        <td style="text-align: center;">
                            <g:if test="${aprobacionInstance.aprobada != 'A'}">
                                <g:if test="${aprobacionInstance.solicitudes.size() > 0}">
                                    <g:if test="${editables.contains(session.perfil.codigo)}">
                                        <g:link class="button btnSmall" action="reunion" id="${aprobacionInstance.id}">
                                            <g:if test="${!aprobacionInstance.numero}">
                                                Empezar
                                            </g:if>
                                            <g:else>
                                                Continuar
                                            </g:else>
                                        </g:link>
                                    </g:if>
                                    <g:if test="${!aprobacionInstance.numero}">
                                        <g:if test="${editables.contains(session.perfil.codigo)}">
                                            <g:link class="button btnSmall" action="prepararReunionAprobacion" id="${aprobacionInstance.id}">
                                                Preparar
                                            </g:link>
                                        </g:if>
                                    </g:if>
                                </g:if>
                                <g:else>
                                    <g:if test="${editables.contains(session.perfil.codigo)}">
                                        <g:if test="${!aprobacionInstance.numero}">
                                            <g:link class="button btnSmall" action="prepararReunionAprobacion" id="${aprobacionInstance.id}">
                                                Preparar
                                            </g:link>
                                        </g:if>
                                    </g:if>
                                </g:else>
                            </g:if>
                            <g:link class="button btnSmall" action="reunion" id="${aprobacionInstance.id}" params="[show: 1]">
                                Ver
                            </g:link>
                        </td>
                    </tr>
                </g:each>
                </tbody>
            </table>
        <elm:pagination total="${aprobacionInstanceCount}" params="${params}"/>
    </div> <!-- body -->
</div> <!-- dialog -->

<script type="text/javascript">
    $(function () {
        $(".button").button();
        $(".home").button("option", "icons", {primary : 'ui-icon-home'});
        $(".create").button("option", "icons", {primary : 'ui-icon-document'});
        $(".xls").button("option", "icons", {primary : 'ui-icon-note'});

        $("#btnBuscar").button({
            icons : {primary : 'ui-icon-search'},
            text  : false
        }).click(function () {
            var search = $.trim($("#txtBuscar").val());
            location.href = "${createLink(controller: 'aprobacion', action:'list')}?search=" + search;
            return false;
        });
        $("#txtBuscar").keyup(function (ev) {
            if (ev.keyCode == 13) {
                var search = $.trim($("#txtBuscar").val());
                location.href = "${createLink(controller: 'aprobacion', action:'list')}?search=" + search;
            }
        });

        $(".print").button("option", "icons", {primary : 'ui-icon-print'}).click(function () {
            var url = "${createLink(controller: 'reporteSolicitud', action: 'aprobadas')}";
            location.href = "${createLink(controller:'pdf',action:'pdfLink')}?url=" + url + "&filename=solicitudes.pdf";
            return false;
        });

        $(".btnSetFecha").click(function () {
            var id = $(this).attr("id");
            var $html = $("<div>");
            var $input = $("<input type='text' readonly='readonly' style='width: 80px;' value='${new Date().format('dd-MM-yyyy')}' " +
            "class='datepicker ui-widget-content ui-corner-all' name='fecha' id='fecha' />");
            $input.datepicker({
                dateFormat : 'dd-mm-yy',
                minDate    : "+0"
            });
            var $selH = $("<select name='horas' class='ui-widget-content ui-corner-all' style='margin-left: 10px;'>");
            for (var i = 7; i < 19; i++) {
                var str = "" + i;
                var pad = "00";
                str = pad.substring(0, pad.length - str.length) + str;
                var $opt = $("<option value='" + i + "'>" + str + "</option>");
                $selH.append($opt);
            }
            var $selM = $("<select name='minutos' class='ui-widget-content ui-corner-all'>");
            for (i = 0; i < 60; i += 5) {
                str = "" + i;
                pad = "00";
                str = pad.substring(0, pad.length - str.length) + str;
                $opt = $("<option value='" + i + "'>" + str + "</option>");
                $selM.append($opt);
            }
            $html.append($input).append($selH).append(":").append($selM);
            $.box({
                imageClass : "box_alert",
                input      : $html,
                type       : "prompt",
                title      : "Fecha",
                text       : "Ingrese la fecha deseada para la reunión seleccionada",
                dialog     : {
                    buttons : {
                        "Aceptar" : function () {
                            $.ajax({
                                type    : "POST",
                                url     : "${createLink(action:'setFechaReunion_ajax')}",
                                data    : {
                                    id      : id,
                                    fecha   : $input.val(),
                                    horas   : $selH.val(),
                                    minutos : $selM.val()
                                },
                                success : function (msg) {
                                    location.reload(true);
                                }
                            });
                        }
                    }
                }
            });
            return false;
        });

        $(".edit").button("option", "icons", {primary : 'ui-icon-pencil'});
        $(".delete").button("option", "icons", {primary : 'ui-icon-trash'}).click(function () {
            if (confirm("${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}")) {
                return true;
            }
            return false;
        });
    });




    function createContextMenu (node) {
        var $tr = $(node);

        var estado = $tr.data("estado");
        var incluir = $tr.data("incluir");
        var detalles = parseInt($tr.data("detalles"));

        var items = {
            header   : {
                label  : "Acciones",
                header : true
            },
            ver      : {
                label  : "Ver",
                icon   : "fa fa-search",
                action : function ($element) {
                    var id = $element.data("id");
                    location.href="${createLink(action: "reunion")}/?id=" + id
                }
            }
        };
        <g:if test="${session.perfil.codigo == 'RQ' || session.perfil.codigo == 'DRRQ'}">
        if(estado == 'P'){
            items.editar = {
                label  : "Editar Solicitud",
                icon   : "fa fa-pencil",
                action : function ($element) {
                    var id = $element.data("id");
                    createEditRow(id);
                }
            };
        }
        </g:if>
        <g:if test="${session.perfil.codigo == 'DRRQ'}">
        if(incluir == 'S'){
            items.quitar ={
                label  : "No incluir en la reunión",
                icon   : "fa fa-calendar-o",
                action : function ($element) {
                    var id = $element.data("id");

                }
            };
        }else{
            if(detalles > 0){
                items.incluir ={
                    label  : "Incluir en la reunión",
                    icon   : "fa fa-calendar-o",
                    action : function ($element) {
                        var id = $element.data("id");

                    }
                };
            }
        }
        </g:if>

        return items
    }

    $("tbody>tr").contextMenu({
        items  : createContextMenu,
        onShow : function ($element) {
            $element.addClass("success");
        },
        onHide : function ($element) {
            $(".success").removeClass("success");
        }
    });


</script>

</body>
</html>









%{--<%@ page import="vesta.contratacion.Aprobacion" %>--}%
%{--<!DOCTYPE html>--}%
%{--<html>--}%
%{--<head>--}%
%{--<meta name="layout" content="main">--}%
%{--<title>Lista de Aprobacion</title>--}%
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
%{--<g:link controller="aprobacion" action="list" class="btn btn-default btn-search">--}%
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
%{--<g:sortableColumn property="fecha" title="Fecha" />--}%
%{----}%
%{--<g:sortableColumn property="fechaRealizacion" title="Fecha Realizacion" />--}%
%{----}%
%{--<g:sortableColumn property="observaciones" title="Observaciones" />--}%
%{----}%
%{--<g:sortableColumn property="asistentes" title="Asistentes" />--}%
%{----}%
%{--<g:sortableColumn property="pathPdf" title="Path Pdf" />--}%
%{----}%
%{--<g:sortableColumn property="numero" title="Numero" />--}%
%{----}%
%{--<g:sortableColumn property="aprobada" title="Aprobada" />--}%
%{----}%
%{--<th>Creado Por</th>--}%
%{----}%
%{--<th>Firma Direccion Planificacion</th>--}%
%{----}%
%{--<th>Firma Gerencia Tecnica</th>--}%
%{----}%
%{--</tr>--}%
%{--</thead>--}%
%{--<tbody>--}%
%{--<g:if test="${aprobacionInstanceCount > 0}">--}%
%{--<g:each in="${aprobacionInstanceList}" status="i" var="aprobacionInstance">--}%
%{--<tr data-id="${aprobacionInstance.id}">--}%
%{----}%
%{--<td>${aprobacionInstance.fecha}</td>--}%
%{----}%
%{--<td><g:formatDate date="${aprobacionInstance.fechaRealizacion}" format="dd-MM-yyyy" /></td>--}%
%{----}%
%{--<td><elm:textoBusqueda busca="${params.search}"><g:fieldValue bean="${aprobacionInstance}" field="observaciones"/></elm:textoBusqueda></td>--}%
%{----}%
%{--<td><elm:textoBusqueda busca="${params.search}"><g:fieldValue bean="${aprobacionInstance}" field="asistentes"/></elm:textoBusqueda></td>--}%
%{----}%
%{--<td><elm:textoBusqueda busca="${params.search}"><g:fieldValue bean="${aprobacionInstance}" field="pathPdf"/></elm:textoBusqueda></td>--}%
%{----}%
%{--<td><elm:textoBusqueda busca="${params.search}"><g:fieldValue bean="${aprobacionInstance}" field="numero"/></elm:textoBusqueda></td>--}%
%{----}%
%{--<td><elm:textoBusqueda busca="${params.search}"><g:fieldValue bean="${aprobacionInstance}" field="aprobada"/></elm:textoBusqueda></td>--}%
%{----}%
%{--<td><elm:textoBusqueda busca="${params.search}"><g:fieldValue bean="${aprobacionInstance}" field="creadoPor"/></elm:textoBusqueda></td>--}%
%{----}%
%{--<td><elm:textoBusqueda busca="${params.search}"><g:fieldValue bean="${aprobacionInstance}" field="firmaDireccionPlanificacion"/></elm:textoBusqueda></td>--}%
%{----}%
%{--<td><elm:textoBusqueda busca="${params.search}"><g:fieldValue bean="${aprobacionInstance}" field="firmaGerenciaTecnica"/></elm:textoBusqueda></td>--}%
%{----}%
%{--</tr>--}%
%{--</g:each>--}%
%{--</g:if>--}%
%{--<g:else>--}%
%{--<tr class="danger">--}%
%{--<td class="text-center" colspan="11">--}%
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

%{--<elm:pagination total="${aprobacionInstanceCount}" params="${params}"/>--}%

%{--<script type="text/javascript">--}%
%{--var id = null;--}%
%{--function submitForm() {--}%
%{--var $form = $("#frmAprobacion");--}%
%{--var $btn = $("#dlgCreateEdit").find("#btnSave");--}%
%{--if ($form.valid()) {--}%
%{--$btn.replaceWith(spinner);--}%
%{--openLoader("Guardando Aprobacion");--}%
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
%{--"¿Está seguro que desea eliminar el Aprobacion seleccionado? Esta acción no se puede deshacer.</p>",--}%
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
%{--openLoader("Eliminando Aprobacion");--}%
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
%{--title   : title + " Aprobacion",--}%
%{----}%
%{--class   : "modal-lg",--}%
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
%{--title   : "Ver Aprobacion",--}%
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
