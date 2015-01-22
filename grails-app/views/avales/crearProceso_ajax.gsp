<%--
  Created by IntelliJ IDEA.
  User: fabricio
  Date: 20/01/15
  Time: 02:29 PM
--%>

<%@ page import="vesta.parametros.TipoElemento" contentType="text/html;charset=UTF-8" %>
%{--<html>--}%
%{--<head>--}%
%{--<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>--}%
%{--<meta name="layout" content="main"/>--}%
%{--<title>Crear proceso</title>--}%
%{--</head>--}%

%{--<body>--}%
<g:if test="${flash.message}">
    <div class="message ui-state-highlight ui-corner-all">
        ${flash.message}
    </div>
</g:if>


%{--<div class="btn-toolbar toolbar">--}%
%{--<div class="btn-group">--}%
%{--<g:link controller="avales" action="listaProcesos" class="btn btn-default"><i class="fa fa-bars"></i> Lista de procesos</g:link>--}%
%{--<g:link controller="avales" action="crearProceso" class="btn btn-default"><i class="fa fa-file-o"></i> Crear nuevo</g:link>--}%
%{--<g:if test="${proceso?.id}">--}%
%{--<g:link controller="avales" action="solicitarAval" class="btn" id="${proceso?.id}">Solicitar Aval</g:link>--}%
%{--</g:if>--}%
%{--</div>--}%
%{--</div>--}%

%{--<fieldset style="width: 95%;height: 170px;" class="ui-corner-all">--}%
    <g:form action="saveProceso" class="frmProceso">
        <input type="hidden" name="id" value="${proceso?.id}">

    %{--<div class="fila">--}%
    %{--<div class="labelSvt">Proyecto:</div>--}%
    %{--<div class="fieldSvt-xxxl">--}%
    %{--<g:select from="${proyectos}" optionKey="id" optionValue="nombre" name="proyecto.id" id="proyecto" style="width:100%" class="ui-corner-all ui-widget-content" value="${proceso?.proyecto?.id}" />--}%
    %{--</div>--}%
    %{--</div>--}%

    %{--<div class="fila">--}%

    %{--<div class="labelSvt">Fecha inicio:</div>--}%

    %{--<div class="fieldSvt-small">--}%
    %{--<g:textField class="datepicker field ui-widget-content ui-corner-all fechaFin"--}%
    %{--name="fechaInicio"--}%
    %{--style="width: 100%"--}%
    %{--title="Fecha de inicio"--}%
    %{--value="${proceso?.fechaInicio?.format('dd-MM-yyyy')}"--}%
    %{--id="fechaInicio" autocomplete="off"/>--}%
    %{--</div>--}%

    %{--<div class="labelSvt" style="margin-left: 25px">Fecha fin:</div>--}%

    %{--<div class="fieldSvt-small">--}%
    %{--<g:textField class="datepicker field ui-widget-content ui-corner-all fechaFin"--}%
    %{--name="fechaFin"--}%
    %{--style="width: 100%"--}%
    %{--title="Fecha de finalización"--}%
    %{--value="${proceso?.fechaFin?.format('dd-MM-yyyy')}"--}%
    %{--id="fechaFin" autocomplete="off"/>--}%
    %{--</div>--}%


        <div class="form-group keeptogether">
            <span class="grupo">
                <label class="col-md-2 control-label">
                    Proyecto
                </label>
                <div class="col-md-4">
                    <g:select name="proyecto.id" from="${proyectos}" class="form-control input-sm" value="${proceso?.proyecto?.id}" optionKey="id" optionValue="descripcion" id="proyecto"/>
                </div>
            </span>
        </div>


        <div class="form-group keeptogether">
            <span class="grupo">
                <label for="fechaInicio" class="col-md-2 control-label">
                    Fecha Inicio
                </label>
                <div class="col-md-3">
                    <elm:datepicker name="fechaInicio"  class="datepicker form-control input-sm" value="${proceso?.fechaInicio}"/>
                </div>
            </span>
        </div>


        <div class="form-group keeptogether">
            <span class="grupo">
                <label for="fechaFin" class="col-md-2 control-label">
                    Fecha Fin
                </label>
                <div class="col-md-3">
                    <elm:datepicker name="fechaFin"  class="datepicker form-control input-sm" value="${proceso?.fechaFin}"/>
                </div>
            </span>
        </div>

        <div class="form-group keeptogether">
            <span class="grupo">
                <label for="informar" class="col-md-2 control-label">
                    Informar cada:
                </label>
                <div class="col-md-3">
                    <g:textField class="form-control input-sm"
                                 name="informar" title="Plazo de Ejecución" value="${proceso?.informar}" id="informar"/>
                </div>
                <div>
                    <label>Días</label>
                </div>
            </span>
        </div>

        <div class="form-group keeptogether">
            <span class="grupo">
                <label for="nombre" class="col-md-2 control-label">
                    Nombre:
                </label>
                <div class="col-md-3">
                    <g:textField class="form-control input-sm"
                                 name="nombre" value="${proceso?.nombre}" id="nombre"/>
                </div>
            </span>
        </div>

    %{--<div class="labelSvt" style="margin-left: 25px">Informar cada:</div>--}%
    %{--<div class="fieldSvt-medium">--}%
    %{--<input type="text" name="informar" id="informar" value="${proceso?.informar}" class="ui-corner-all ui-widget-content" style="width: 80px;text-align: right"> Días--}%
    %{--</div>--}%
    %{--</div>--}%

        %{--<div class="fila">--}%
            %{--<div class="labelSvt">Nombre:</div>--}%

            %{--<div class="fieldSvt-xxxl">--}%
                %{--<input type="text" class="ui-corner-all" name="nombre" id="nombre" style="width: 100%" value="${proceso?.nombre}">--}%
            %{--</div>--}%

            %{--<div class="fieldSvt-small" style="margin-left: 30px;">--}%
            %{--<g:if test="${band}">--}%
            %{--<a href="#" id="guardar">Guardar</a>--}%
            %{--</g:if>--}%
            %{--</div>--}%
        %{--</div>--}%
    </g:form>
%{--</fieldset>--}%
<g:if test="${proceso && band}">
    <fieldset style="width: 95%;height: 260px;" class="ui-corner-all">
        <legend>Agregar asignaciones</legend>
        <input type="hidden" id="idAgregar">

        <div class="form-group keeptogether">
            <span class="grupo">
                <label class="col-md-2 control-label">
                    Año:
                </label>
                <div class="col-md-2">
                    <g:select name="anio" from="${vesta.parametros.poaPac.Anio.list([sort: 'anio'])}" value="${actual?.id}" class="form-control input-sm" id="anio" optionKey="id" optionValue="anio"/>
                </div>
            </span>
        </div>

        <div class="form-group keeptogether">
            <span class="grupo">
                <label class="col-md-2 control-label">
                    Componente
                </label>
                <div class="col-md-4" id="div_comp">
                    <g:select name="comp" from="${vesta.proyectos.MarcoLogico.findAllByProyectoAndTipoElemento(proceso?.proyecto, TipoElemento.get(2))}" class="form-control input-sm" optionKey="id" optionValue="objeto" id="comp" noSelection="['-1': 'Seleccione...']"/>
                </div>
            </span>
        </div>

        <div class="form-group keeptogether">
            <span class="grupo">
                <label class="col-md-2 control-label">
                    Actividad
                </label>
                <div class="col-md-4" id="divAct">
                    <g:select name="actividad" from="${[]}" class="form-control input-sm" id="actividad" noSelection="['-1': 'Seleccione...']"/>
                </div>
            </span>
        </div>

        <div class="form-group keeptogether">
            <span class="grupo">
                <label class="col-md-2 control-label">
                    Asignación
                </label>
                <div class="col-md-4" id="divAsg">
                    <g:select name="asignacion" from="${[]}" class="form-control input-sm" id="asignacion" noSelection="['-1': 'Seleccione...']"/>
                </div>
            </span>
        </div>


        <div class="form-group keeptogether">
            <span class="grupo">
                <label for="monto" class="col-md-2 control-label">
                    Monto:
                </label>
                <div class="col-md-3">
                    <g:textField class="form-control input-sm number money" name="montoName" style="text-align: right; margin-right: 10px" id="monto"/>
                </div>
                <div class="col-md-3">
                   <label> Máximo <span id="max" style="display: inline-block"></span> $ </label>
                </div>
                <div class="col-md-1">
                    <a href="#" class="btn btn-success" id="agregar"><i class="fa fa-plus"></i> </a>
                </div>

            </span>
        </div>


    </fieldset>
</g:if>

<fieldset style="width: 95%;height: 300px;overflow: auto; margin-top: 30px" class="ui-corner-all">
    <legend>Asignaciones</legend>

    <div id="detalle" style="width: 95%"></div>
</fieldset>

<div id="dlgEditar">
    <g:if test="${band}">
        <input type="hidden" id="dlgId">

        <div class="fila">
            <div class="labelSvt">Monto:</div>
            <input class="decimal" type="text" style="width: 100px;text-align: right;display: inline-block" id="dlgMonto">
        </div>

        <div class="fila">
            <div class="labelSvt">Máximo:</div> <span id="dlgMax" style="display: inline-block"></span> $
        </div>
    </g:if>
    <g:else>
        <div class="fila">
            No puede editar este proceso porque ya tiene un aval o una solicitud pendiente
        </div>
    </g:else>
</div>

<script>
    function getMaximo(asg) {
        $.ajax({
            type    : "POST",
            url     : "${createLink(action:'getMaximoAsg')}",
            data    : {
                id : asg
            },
            success : function (msg) {
                if ($("#asignacion").val() != "-1")
                    $("#max").html(number_format(msg, 2, ",", "."));
                else {
                    var valor = parseFloat(msg);
                    var monto = $("#dlgMonto").val();
                    monto = monto.replace(new RegExp(",", 'g'), ".");
                    monto = parseFloat(monto);
                    $("#dlgMax").html(number_format(valor + monto, 2, ",", "."));
                }
            }
        });
    }
    function getDetalle() {
        $.ajax({
            type    : "POST",
            url     : "${createLink(action:'getDetalle')}",
            data    : {
                id : "${proceso?.id}"
            },
            success : function (msg) {
                $("#detalle").html(msg)
            }
        });
    };

    function vaciar() {
        $("#monto").val("");
        $("#max").html("");
        $("#asignacion").val("-1");
    }
    <g:if test="${proceso}">
    getDetalle();
    </g:if>

    $("#anio").change(function () {
        $("#comp").val("-1");
        $("#actividad").val("-1");
        $("#asignacion").val("-1");
        $("#monto").val("");
        $("#max").html("");
    });


    $("#guardar").button().click(function () {
        var dias = $("#informar").val()
        var nombre =$("#nombre").val()
        var inicio = $("#fechaInicio").val()
        var fin = $("#fechaFin").val()
        var msg =""
        if(dias==""){
            msg+="<br>Ingrese un número entero positivo en el campo informar"
        }else{
            if(isNaN(dias)){
                msg+="<br>Ingrese un número entero positivo en el campo informar"
            }else{
                if(dias*1<0)
                    msg+="<br>Ingrese un número entero positivo en el campo informar"
            }
        }

        if(inicio==""){
            msg+="<br>Ingrese la fecha de inicio"
        }
        if(fin==""){
            msg+="<br>Ingrese la fecha de fin"
        }
        if(nombre==""){
            msg+="<br>Ingrese el nombre del proceso"
        }
        if(msg=="")
            $(".frmProceso").submit()
        else{
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


    $("#agregar").click(function () {
        var id = $("#idAgregar").val();
        var monto = $("#monto").val();
        monto = monto.replace(new RegExp(",", 'g'), ".");
        var max = $("#max").html();
        max = max.replace(new RegExp(",", 'g'), ".");
        var asg = $("#asignacion").val();
        var proceso = "${proceso?.id}";

        var msg = "";
        if (asg == "-1" || isNaN(asg)) {
            msg += "<br>Debe seleccionar una asignación.";
        } else {

            if (isNaN(monto) || monto == "") {
                msg += "<br>El monto tiene que ser un número positivo.";
            } else {
                if (monto * 1 < 0)
                    msg += "<br>El monto tiene que ser un número positivo.";
                if (monto * 1 > max * 1)
                    msg += "<br>El monto no puede ser mayor al máximo.";
            }
        }

        if (msg == "") {
            $.ajax({
                type    : "POST",
                url     : "${createLink(action:'agregarAsignacion')}",
                data    : {
                    id      : id,
                    proceso : proceso,
                    monto   : monto,
                    asg     : asg
                },
                success : function (msg) {
                    getDetalle();
                    vaciar();
                }
            });
        } else {
            bootbox.dialog({
                title : "Error",
                message : msg,
                buttons : {
                    cancelar : {
                        label     : "Cancelar",
                        className : "btn-primary",
                        callback  : function () {
                        }
                    }
                }
            });
        }
    });


    $("#dlgEditar").dialog({
        width     : 300,
        height    : 300,
        position  : [450, 300],
        title     : "Editar",
        modal     : true,
        autoOpen  : false,
        resizable : false,
        buttons   : {
            "Aceptar" : function () {
                var monto = $("#dlgMonto").val();
                monto = monto.replace(new RegExp(",", 'g'), ".");
                var id = $("#dlgId").val();
                var max = $("#dlgMax").html();
                var msg = "";
                if (isNaN(monto) || monto == "") {
                    msg += "<br>El monto tiene que ser un número positivo.";
                } else {
                    if (monto * 1 < 0)
                        msg += "<br>El monto tiene que ser un número positivo.";
                    if (monto * 1 > max * 1)
                        msg += "<br>El monto no puede ser mayor al máximo.";
                }
                if (msg == "") {
                    $.ajax({
                        type    : "POST",
                        url     : "${createLink(action:'editarDetalle')}",
                        data    : {
                            id    : id,
                            monto : monto
                        },
                        success : function (msg) {
                            getDetalle();
                            vaciar();
//                            $("#dlgEditar").dialog("close");

                        }
                    });
                } else {
                    bootbox.dialog({
                        title  : "Error",
                        message   : msg,
                        buttons : {
                            label     : "Cancelar",
                            className : "btn-primary",
                            callback  : function () {
                            }
                        }

                    });

                }

            },
            "Cerrar"  : function () {
                $("#dlgEditar").dialog("close")
            }
        }
    });

    $("#comp").change(function () {
        $.ajax({
            type    : "POST",
            url     : "${createLink(action:'cargarActividades')}",
            data    : {
                id     : $("#comp").val(),
                unidad : "${unidad?.id}"
            },
            success : function (msg) {
                $("#divAct").html(msg)
            }
        });
    });

</script>
