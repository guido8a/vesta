<%@ page import="vesta.parametros.TipoElemento" contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta name="layout" content="main"/>
    <title>Crear Hito</title>

    <style>
    .tipo{
        font-weight: bold;
    }
    </style>
</head>
<body>
<g:if test="${flash.message}">
    <div class="message ui-state-highlight ui-corner-all">
        ${flash.message}
    </div>
</g:if>
<div class="btn-toolbar toolbar" style="margin-top: 10px">
    <div class="btn-group">
        <g:link controller="hito" action="lista" class="btn btn-default">Lista de hitos</g:link>
    </div>
</div>
<elm:container titulo="Registrar nuevo hito" tipo="horizontal">
    <g:form action="saveHito" class="frmHito">
        <input type="hidden" name="id" value="${hito?.id}">
        <div class="row">
            <div class="col-md-2">
                <label>Tipo</label>
            </div>
            <div class="col-md-2">
                <g:select name="tipo" from="${tipos}" class="form-control input-sm required" optionKey="key" optionValue="value"></g:select>
            </div>
        </div>
        <div class="row" >
            <div class="col-md-2">
                <label> Fecha de Inicio</label>
            </div>
            <div class="col-md-2" >
                <elm:datepicker name="inicio" class=" form-control input-sm required"   style="width: 100px;" value="${hito?.inicio?.format('dd-MM-yyyy')}" />
                %{--<g:textField name="inicio" class="datepicker ui-widget-content ui-corner-all" style="width: 100px;" value="${hito?.inicio?.format('dd/MM/yyyy')}"/>--}%
            </div>
            <div class="col-md-2">
                <label> Fecha de fin</label>
            </div>
            <div class="col-md-2" >
                <elm:datepicker name="fin" class=" form-control input-sm required"   style="width: 100px;" value="${hito?.fechaPlanificada?.format('dd-MM-yyyy')}" />
            </div>
        </div>
        <div class="row" >
            <div class="col-md-2">
                <label>Descripción</label>
            </div>
            <div class="col-md-10" >
                <textarea name="descripcion" style="height: 100px" class="form-control input-sm required" id="descripcion">${hito?.descripcion}</textarea>
            </div>
        </div>
        <g:if test="${hito}">
            <g:set var="componente" value="${vesta.hitos.ComposicionHito.findByHito(hito)}"></g:set>
        </g:if>
        <div class="row">
            <div class="col-md-2">
                <label>Proyecto</label>
            </div>
            <div class="col-md-8">
                <g:select from="${proyectos}" optionKey="id" optionValue="nombre" name="proyecto.id" id="proy" style="width:100%" class="form-control input-sm cmb" value="${componente?.marcoLogico?.proyecto?.id}" noSelection="['-1': 'Seleccione...']"></g:select>
            </div>
        </div>
        <div class="row">
            <div class="col-md-2">
                <label>Componente</label>
            </div>
            <div class="col-md-8" id="div_comp">
                <g:select  class="form-control input-sm required" from="${[]}" optionValue="objeto" optionKey="id" name="comp" id="comp" noSelection="['-1': 'Seleccione...']" style="width: 100%" value="${componente?.marcoLogico?.id}"></g:select>
            </div>
        </div>
        <div class="row" >
            <div class="col-md-1">
                <a href="#" id="guardar" class="btn btn-primary btn-sm">Guardar</a>
            </div>
        </div>
    </g:form>
</elm:container>

<script>
    %{--function detalle(){--}%
    %{--$.ajax({--}%
    %{--type    : "POST",--}%
    %{--url     : "${createLink(action:'composicion')}",--}%
    %{--data    : {--}%
    %{--id : "${hito?.id}"--}%
    %{--},--}%
    %{--success : function (msg) {--}%
    %{--$("#detalle").html(msg)--}%
    %{--}--}%
    %{--});--}%
    %{--}--}%
    %{--<g:if test="${hito}">--}%
    %{--detalle()--}%
    %{--</g:if>--}%

    var validator = $(".frmHito").validate({
        errorClass     : "help-block",
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

    $("#guardar").click(function(){
        if($("#comp").val()!="-1"){
            $(".frmHito").submit()
        }else{
            bootbox.alert({
                        message : "Por favor seleccione un componente",
                        title   : "Error",
                        class   : "modal-error"
                    }
            );
        }

    })


    $("#proy").change(function(){
        $.ajax({
            type    : "POST",
            url     : "${createLink(action:'componentesProyecto')}",
            async : false,
            data    : {
                id     : $("#proy").val()
            },
            success : function (msg) {
                $("#div_comp").html(msg)
            }
        });
    });
    <g:if test="${hito}">
    $("#proy").change()
    $("#comp").val(${componente.marcoLogico.id})
    </g:if>
</script>
</body>
</html>