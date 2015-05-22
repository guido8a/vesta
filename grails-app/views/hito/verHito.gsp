<%@ page import="vesta.parametros.TipoElemento" contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta name="layout" content="main"/>
    <title>Ver Ejecución</title>

</head>
<body>
<g:if test="${flash.message}">
    <div class="message ui-state-highlight ui-corner-all">
        ${flash.message}
    </div>
</g:if>
<div class="fila">
    <g:link controller="hito" action="lista" class="btn btn-default btn-sm">Lista de hitos</g:link>
</div>
<fieldset style="width: 95%;height: 240px; margin-top: 20px" class="ui-corner-all">
    <legend>Hito</legend>
    <g:form action="saveHito" class="frmHito">
        <input type="hidden" name="id" value="${hito?.id}">


        <div class="row">
         <div class="col-md-7 alert alert-info sh" style="height: 100%;">
         <div class="row no-margin-top">
                        <label class="col-md-5 control-label">
                          Fecha planificada de cumplimiento:
                        </label>
                        <div class="col-md-5">
        ${hito?.fechaPlanificada?.format('dd-MM-yyyy')}
        </div>
        </div>
        <div class="row no-margin-top">
            <label class="col-md-5 control-label">
                Descripción:
            </label>
            <div class="col-md-5">
                ${hito?.descripcion}
            </div>
        </div>
        </div>

    </g:form>
</fieldset>

<fieldset style="width: 95%;height: 300px;overflow: auto" class="ui-corner-all">
    <legend>Composición</legend>
    <div id="detalle" style="width: 95%"></div>
</fieldset>
<script>
    function detalle(){
        $.ajax({
            type    : "POST",
            url     : "${createLink(action:'composicion')}",
            data    : {
                id : "${hito?.id}",
                ver: "true"
            },
            success : function (msg) {
                $("#detalle").html(msg)
            }
        });
    }
    <g:if test="${hito}">
    detalle()
    </g:if>
    $(".btn").button()
    $(".cmb").selectmenu({width : 600});
    $("#guardar").click(function(){
        var msg =""
        if($("#descripcion").val().length==0){
            msg+="<br>Por favor, ingrese una descripción"
        }
        if(msg==""){
            $(".frmHito").submit()
        }else{
            $.box({
                title  : "Error",
                text   : msg,
                dialog : {
                    resizable : false,
                    buttons   : {
                        "Cerrar" : function () {

                        }
                    }
                }
            });
        }
    })
    $("#ag_proy").click(function(){
        var  msg =""
        if($("#proy").val()=="-1"){
            msg="Seleccione un proyecto"
        }
        if(msg==""){
            $.ajax({
                type    : "POST",
                url     : "${createLink(action:'agregarComp')}",
                data    : {
                    id : "${hito?.id}",
                    tipo: "proy",
                    componente:$("#proy").val()
                },
                success : function (msg) {
                    $("#detalle").html(msg)
                }
            });
        }else{
            $.box({
                title  : "Error",
                text   : msg,
                dialog : {
                    resizable : false,
                    buttons   : {
                        "Cerrar" : function () {

                        }
                    }
                }
            });
        }
    });
    $("#ag_comp").click(function(){
        var  msg =""
        if($("#comp").val()=="-1"){
            msg="Seleccione un componente"
        }
        if(msg==""){
            $.ajax({
                type    : "POST",
                url     : "${createLink(action:'agregarComp')}",
                data    : {
                    id : "${hito?.id}",
                    tipo: "ml",
                    componente:$("#comp").val()
                },
                success : function (msg) {
                    $("#detalle").html(msg)
                }
            });
        }else{
            $.box({
                title  : "Error",
                text   : msg,
                dialog : {
                    resizable : false,
                    buttons   : {
                        "Cerrar" : function () {

                        }
                    }
                }
            });
        }
    });
    $("#ag_act").click(function(){
        var  msg =""
        if($("#actividad").val()=="-1"){
            msg="Seleccione una actividad"
        }
        if(msg==""){
            $.ajax({
                type    : "POST",
                url     : "${createLink(action:'agregarComp')}",
                data    : {
                    id : "${hito?.id}",
                    tipo: "ml",
                    componente:$("#actividad").val()
                },
                success : function (msg) {
                    $("#detalle").html(msg)
                }
            });
        }else{
            $.box({
                title  : "Error",
                text   : msg,
                dialog : {
                    resizable : false,
                    buttons   : {
                        "Cerrar" : function () {

                        }
                    }
                }
            });
        }
    });
    $("#ag_proc").click(function(){
        var  msg =""
        if($("#proceso").val()=="-1"){
            msg="Seleccione un proceso"
        }
        if(msg==""){
            $.ajax({
                type    : "POST",
                url     : "${createLink(action:'agregarComp')}",
                data    : {
                    id : "${hito?.id}",
                    tipo: "proc",
                    componente:$("#proceso").val()
                },
                success : function (msg) {
                    $("#detalle").html(msg)
                }
            });
        }else{
            $.box({
                title  : "Error",
                text   : msg,
                dialog : {
                    resizable : false,
                    buttons   : {
                        "Cerrar" : function () {

                        }
                    }
                }
            });
        }
    });

    $("#proy").change(function(){
        $.ajax({
            type    : "POST",
            url     : "${createLink(action:'componentesProyecto')}",
            data    : {
                id     : $("#proy").val()
            },
            success : function (msg) {
                $("#div_comp").html(msg)
            }
        });
    });

</script>
</body>
</html>