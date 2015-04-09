<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 07/04/15
  Time: 12:23 PM
--%>
<%@ page import="vesta.seguridad.Persona; vesta.proyectos.Proyecto; vesta.parametros.poaPac.Anio" contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main"/>
        <title>Ajustes del POA</title>
    </head>

    <body>

        <elm:message tipo="${flash.tipo}" clase="${flash.clase}">${flash.message}</elm:message>

        <g:form controller="modificacionesPoa" action="guardarAjuste" name="frmAjuste">
            <elm:container tipo="horizontal" titulo="Asignación de origen">
                <div class="row">
                    <div class="col-md-1">
                        <label>POA año</label>
                    </div>

                    <div class="col-md-2" id="">
                        <g:select from="${Anio.list([sort: 'anio'])}" value="${actual?.id}" optionKey="id" optionValue="anio" id="anio" name="anio"
                                  class="form-control input-sm required requiredCombo"/>
                    </div>

                    <div class="col-md-1 col-md-offset-3">
                        <label>Actividad</label>
                    </div>

                    <div class="col-md-5 grupo" id="divAct">
                        <g:select from="${[]}" id="actividad" name="actividad" style="width:100%" noSelection="['-1': 'Seleccione']"
                                  class="form-control input-sm required requiredCombo"/>
                    </div>
                </div>

                <div class="row">

                    <div class="col-md-1">
                        <label>Proyecto</label>
                    </div>

                    <div class="col-md-5 grupo">
                        <g:select from="${proyectos}" optionKey="id" optionValue="nombre" name="proyecto" id="proyecto"
                                  style="width:100%" class="form-control input-sm required requiredCombo"
                                  noSelection="['-1': 'Seleccione...']"/>
                    </div>

                    <div class="col-md-1">
                        <label>Asignación</label>
                    </div>

                    <div class="col-md-5 grupo" id="divAsg">
                        <g:select from="${[]}" id="asignacion" name="origen.id" style="width:100%" noSelection="['-1': 'Seleccione']" class="form-control input-sm required requiredCombo"/>
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-1">
                        <label>Componente</label>
                    </div>

                    <div class="col-md-5 grupo" id="div_comp">
                        <g:select from="${[]}" name="comp" id="comp" noSelection="['-1': 'Seleccione...']" style="width: 100%" class="form-control input-sm required requiredCombo"/>
                    </div>

                    <div class="col-md-1">
                        <label>Monto</label>
                    </div>
                    <input type="hidden" id="valor">

                    <div class="col-md-2 grupo">
                        <div class="input-group">
                            <g:textField type="text" name="monto"
                                         class="form-control required input-sm number money"/>
                            <span class="input-group-addon"><i class="fa fa-usd"></i></span>
                        </div>
                    </div>

                    <div class="col-md-2">
                        Máximo: <span id="max" style="display: inline-block"></span> $
                    </div>
                </div>

            </elm:container>

            <elm:container tipo="horizontal" titulo="Asignación de destino" style="">
                <div class="row">
                    <div class="col-md-1"><label>Proyecto</label></div>

                    <div class="col-md-5 grupo">
                        <g:select from="${proyectos2}" optionKey="id" optionValue="nombre" name="proyecto_dest" id="proyectoDest" style="width:100%"
                                  class="form-control required requiredCombo input-sm" noSelection="['-1': 'Seleccione...']"/>
                    </div>

                    <div class="col-md-1"><label>Actividad</label></div>

                    <div class="col-md-5 grupo" id="divAct_dest">
                        <g:select from="${[]}" id="actividad_dest" name="actividad" style="width:100%" noSelection="['-1': 'Seleccione']" class="form-control input-sm required requiredCombo"/>
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-1"><label>Componente</label></div>

                    <div class="col-md-5" id="div_comp_dest">
                        <g:select from="${[]}" name="comp" id="compDest" noSelection="['-1': 'Seleccione...']" style="width: 100%" class="form-control input-sm required requiredCombo"/>
                    </div>

                    <div class="col-md-1"><label>Asignación</label></div>

                    <div class="col-md-5 grupo" id="divAsg_dest">
                        <g:select from="${[]}" id="asignacion_dest" name="origen.id" style="width:100%" noSelection="['-1': 'Seleccione']" class="form-control input-sm required requiredCombo"/>
                    </div>
                </div>
            </elm:container>

            <elm:container tipo="horizontal" titulo="Texto para el PDF" style="">
                <div class="row">
                    <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
                        <g:textArea name="texto" cols="5" rows="5" class="form-control required editor"/>
                    </div>
                </div>
            </elm:container>

            <elm:container tipo="horizontal" titulo="Autorizaciones electrónicas" style="">
                <div class="row" style="margin-bottom: 10px">
                    <div class="col-md-3 grupo">
                        <g:select from="${personas}" optionKey="id" optionValue="${{
                            it.nombre + ' ' + it.apellido
                        }}" noSelection="['-1': '- Seleccione -']" name="firma2" class="form-control required requiredCombo input-sm"/>
                    </div>

                    <div class="col-md-3 grupo">
                        <g:select from="${personasGerente}" optionKey="id" optionValue="${{
                            it.nombre + ' ' + it.apellido
                        }}" noSelection="['-1': '- Seleccione -']" name="firma3" class="form-control required requiredCombo input-sm"/>
                    </div>
                </div>
            </elm:container>
        </g:form>

        <div class="row">
            <div class="col-md-1">
                <a href="#" id="guardar1" class="btn btn-success">
                    <i class="fa fa-floppy-o"></i> Guardar
                </a>
            </div>
        </div>

        <script>

            function getMaximo(asg) {
                $.ajax({
                    type    : "POST",
                    url     : "${createLink(action:'getMaximoAsg',controller: 'avales')}",
                    data    : {
                        id : asg
                    },
                    success : function (msg) {
                        getValor(asg);
                        if ($("#asignacion").val() != "-1") {
                            $("#max").html(number_format(msg, 2, ".", ","))
                                    .attr("valor", msg);
                            $("#monto").attr("max", msg);
                        } else {
                            var valor = parseFloat(msg);
                            var monto = $("#dlgMonto").val();
                            monto = monto.replace(new RegExp(",", 'g'), "");
                            monto = parseFloat(monto);
                            $("#dlgMax").html(number_format(valor + monto, 2, ".", ","));
                        }
                    }
                });
            }
            function getValor(asg) {
                $.ajax({
                    type    : "POST",
                    url     : "${createLink(action:'getValor',controller: 'modificacionesPoa')}",
                    data    : {
                        id : asg
                    },
                    success : function (msg) {
                        $("#valor").val(msg);
                    }
                });
            }

            $(function () {
                $("#frmAjuste").validate({
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

                $("#guardar1").click(function () {

                    if ($("#frmAjuste").valid()) {
                        openLoader();
                        $.ajax({
                            type    : "POST",
                            url     : $("#frmAjuste").attr("action"),
                            data    : $("#frmAjuste").serialize(),
                            success : function (msg) {
                                var parts = msg.split("*");
                                log(parts[1], parts[0]); //log(msg, type, title, hide)
                                if (parts[0] == "SUCCESS") {
                                    setTimeout(function () {
                                        location.href = "${createLink(action:'listaAjustes')}";
                                    }, 1000);
                                } else {
                                    closeLoader();
                                }
                            }
                        });
                    } else {
                        bootbox.alert({
                            title   : "Error",
                            message : msg,
                            class   : "modal-error"
                        });
                    }

                    %{--var asgDest = $("#asignacion_dest").val();--}%
                    %{--var asgOrigen = $("#asignacion").val();--}%

                    %{--var firma1 = $("#firma2").val();--}%
                    %{--var firma2 = $("#firma3").val();--}%

                    %{--var monto = $("#monto").val();--}%
                    %{--monto = monto.replace(new RegExp(",", 'g'), "");--}%
                    %{--var max = $("#max").attr("valor");--}%
                    %{--var msg = "";--}%
                    %{--if (asgOrigen == "-1") {--}%
                    %{--msg += "<br>Por favor, seleccione una asignación de origen"--}%
                    %{--}--}%
                    %{--if (asgDest == "-1") {--}%
                    %{--msg += "<br>Por favor, seleccione una asignación de destino"--}%
                    %{--}--}%
                    %{--if (monto == "") {--}%
                    %{--msg += "<br>Por favor, ingrese un monto válido"--}%
                    %{--}--}%
                    %{--//console.log(monto,max)--}%
                    %{--if (isNaN(monto)) {--}%
                    %{--msg += "<br>Por favor, ingrese un monto válido"--}%
                    %{--} else {--}%
                    %{--if (monto * 1 <= 0) {--}%
                    %{--msg += "<br>El monto debe ser un número positivo mayor a cero"--}%
                    %{--}--}%
                    %{--if (monto * 1 > max * 1) {--}%
                    %{--msg += "<br>El monto no puede superar al máximo"--}%
                    %{--}--}%
                    %{--}--}%
                    %{--if (asgDest == asgOrigen) {--}%
                    %{--msg += "<br>La asignación de destino debe ser diferente a la de origen"--}%
                    %{--}--}%

                    %{--if (firma1 == '-1' || firma2 == '-1') {--}%
                    %{--msg += "<br>Debe seleccionar dos personas para las autorizaciones electrónicas"--}%
                    %{--}--}%

                    %{--if (msg == "") {--}%
                    %{--console.log("MONTO??? ", monto);--}%
                    %{--openLoader();--}%
                    %{--$.ajax({--}%
                    %{--type    : "POST",--}%
                    %{--url     : "${createLink(action:'guardarAjuste',controller:'modificacionesPoa')}",--}%
                    %{--data    : {--}%
                    %{--origen  : asgOrigen,--}%
                    %{--destino : asgDest,--}%
                    %{--monto   : monto,--}%
                    %{--firma1  : firma1,--}%
                    %{--firma2  : firma2--}%
                    %{--},--}%
                    %{--success : function (msg) {--}%
                    %{--var parts = msg.split("*");--}%
                    %{--log(parts[1], parts[0]); //log(msg, type, title, hide)--}%
                    %{--if (parts[0] == "SUCCESS") {--}%
                    %{--setTimeout(function () {--}%
                    %{--location.href = "${createLink(action:'listaAjustes')}";--}%
                    %{--}, 1000);--}%
                    %{--} else {--}%
                    %{--closeLoader();--}%
                    %{--}--}%
                    %{--}--}%
                    %{--});--}%
                    %{--} else {--}%
                    %{--bootbox.alert({--}%
                    %{--title   : "Error",--}%
                    %{--message : msg,--}%
                    %{--class   : "modal-error"--}%
                    %{--});--}%
                    %{--}--}%

                });

                $("#proyecto").val("-1").change(function () {
                    $.ajax({
                        type    : "POST",
                        url     : "${createLink(action:'componentesProyectoAjuste_ajax')}",
                        data    : {
                            id : $("#proyecto").val()
                        },
                        success : function (msg) {
                            $("#div_comp").html(msg)
                        }
                    });
                });

                $("#proyectoDest").val("-1").change(function () {
                    $.ajax({
                        type    : "POST",
                        url     : "${createLink(action:'componentesProyectoAjuste2_ajax')}",
                        data    : {
                            id      : $("#proyectoDest").val(),
                            idCombo : "compDest",
                            div     : "divAct_dest"
                        },
                        success : function (msg) {
                            $("#div_comp_dest").html(msg)
                        }
                    });
                });
            });
        </script>
    </body>
</html>