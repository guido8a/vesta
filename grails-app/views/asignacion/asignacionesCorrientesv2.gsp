<%--
  Created by IntelliJ IDEA.
  User: fabricio
  Date: 19/06/15
  Time: 03:23 PM
--%>

<%@ page import="vesta.parametros.Unidad; vesta.parametros.proyectos.TipoMeta; vesta.proyectos.MarcoLogico" contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta name="layout" content="main"/>
    <title>Asignaciones gastos corrientes</title>

    <style type="text/css">
    .btnCambiarPrograma {
        width  : 16px;
        height : 16px;
    }
    </style>

</head>

<body>

<h1>
    <form class="form-inline">
        <div class="form-group">
            <label>Año</label>
            <g:select from="${vesta.parametros.poaPac.Anio.list([sort:'anio'])}" name="anio" optionKey="id" optionValue="anio" class="many-to-one form-control input-sm" value="${actual.id}" />
        </div>
    </form>
</h1>

<div style="margin-left: 10px;">

    <div style="margin-top: 15px;">

    <table class="table table-condensed table-bordered table-striped table-hover" style="width: auto;">
            <tr>
                <th>Objetivo gasto corriente</th>
                <th>Macro Actividad</th>
                <th>Actividad gasto corriente</th>
                <th>Tarea</th>
            </tr>

            <tr>
                <td><g:select from="${objetivos}" id="objetivo" name="objetivo_name" optionKey="id" optionValue="descripcion" class="many-to-one form-control input-sm" noSelection="['-1':'Seleccione...']"/></td>

                <td id="tdMacro"></td>

                <td id="tdActividad"></td>

                <td id="tdTarea"></td>

            </tr>
        </table>

    </div>
</div>

<fieldset class="ui-corner-all" style="min-height: 100px;font-size: 11px">
    <legend>
        Detalle
    </legend>
    <g:set var="total" value="0"/>
    <table class="table table-condensed table-bordered table-striped table-hover" style="width: auto;">
        <thead>
        %{--<th style="width: 220px">Programa</th>--}%
        <th style="width: 240px">Actividad</th>
        <th style="width: 60px;">Partida</th>
        <th style="width: 200px">Desc. Presupuestaria</th>

        <th>Fuente</th>
        <th>Presupuesto</th>
        <th></th>
        <th></th>
        <th></th>
        </thead>
        <tbody>
        <g:each in="${detalles}" var="asg" status="i">
            <tr class="${(i % 2) == 0 ? 'odd' : 'even'}" id="det_${i}">

                %{--<td class="programa">--}%
                %{--${asg.programa.descripcion}--}%
                %{--<g:if test="${actual.estado == 0}">--}%
                %{--<a href="#" class="btnCambiarPrograma" id="btn_${asg.id}">Cambiar</a>--}%
                %{--</g:if>--}%
                %{--</td>--}%

                <td class="actividad">
                    ${asg.actividad}
                </td>

                <td class="prsp" style="text-align: center">
                    ${asg.presupuesto.numero}
                </td>

                <td class="desc" style="width: 200px">
                    ${asg.presupuesto.descripcion}
                </td>

                <td class="fuente">
                    ${asg.fuente.descripcion}
                </td>

                <td class="valor" style="text-align: right">
                    %{--<g:formatNumber number="${(asg.redistribucion==0)?asg.planificado.toDouble():asg.redistribucion.toDouble()}"--}%
                    %{--format="###,##0"--}%
                    %{--minFractionDigits="2" maxFractionDigits="2"/>--}%
                    %{--<g:set var="total" value="${total.toDouble().round(2)+((asg.redistribucion==0)?asg.planificado.toDouble().round(2):asg.redistribucion.toDouble().round(2))}"></g:set>--}%
                </td>
                <td style="text-align: center">
                    <a href="#" class="btn metas ajax" iden="${asg.id}" icono="ico_001" clase="act_" band="0" tr="#det_${i}" >Metas</a>
                </td>

                <td style="text-align: center">
                    <g:if test="${max?.aprobadoCorrientes==0}">
                        <a href="#" class="btn editar ajax" iden="${asg.id}" icono="ico_001" clase="act_" band="0" tr="#det_${i}" prog="${asg.programa.id}" prsp_id="${asg.presupuesto.id}" prsp_num="${asg.presupuesto.numero}" desc="${asg.presupuesto.descripcion}" fuente="${asg.fuente.id}" valor="${(asg.redistribucion == 0) ? asg.planificado.toDouble().round(2) : asg.redistribucion.toDouble().round(2)}" actv="${asg.actividad}" meta="${asg.meta}" indi="${asg.indicador}" comp="${asg?.componente?.id}">Editar</a>
                    </g:if>
                </td>

                <td style="text-align: center">
                    <g:if test="${max?.aprobadoCorrientes==0}">
                    %{--<a href="#" class="btn eliminar ajax" iden="${asg.id}" icono="ico_001" clase="act_" band="0" tr="#det_${i}"--}%
                    %{--prog="${asg.programa.id}" prsp_id="${asg.presupuesto.id}" prsp_num="${asg.presupuesto.numero}" desc="${asg.presupuesto.descripcion}"--}%
                    %{--fuente="${asg.fuente.id}" valor="${(asg.redistribucion == 0) ? asg.planificado.toDouble().round(2) : asg.redistribucion.toDouble().round(2)}" actv="${asg.actividad}"--}%
                    %{--meta="${asg.meta}" indi="${asg.indicador}">Eliminar</a>--}%
                    </g:if>
                </td>
            </tr>

        </g:each>
        </tbody>
    </table>
</fieldset>


<fieldset class="ui-corner-all" style="min-height: 110px;font-size: 11px;">
    <legend>
        Ingreso de datos
    </legend>
    %{--<g:if test="${max}">--}%
        %{--<g:if test="${max?.aprobadoCorrientes==0}">--}%
    <table class="table table-condensed table-bordered table-striped table-hover" style="width: auto;">
                <thead>
                <th style="width: 300px">Actividad</th>
                <th style="width: 50px;">Partida</th>
                <th style="width: 190px">Desc. Presupuestaria</th>
                <th style="width: 150px;">Fuente</th>
                <th style="width: 50px;">Presupuesto</th>
                <th style="width: 50px;"></th>
                </thead>
                <tbody>

                <tr class="odd">
                    <td class="actividad">
                        <textarea style="width: 300px;height: 40px;resize: vertical;" id="actv"></textarea>
                    </td>

                    <td class="prsp">
                        <input type="hidden" class="prsp" value="" id="prsp_id">

                        <input type="text" id="prsp_num" class="buscar" style="width: 50px;color:black">
                    </td>

                    <td class="desc" id="desc" style="width: 200px"></td>

                    <td class="fuente">
                        <g:select from="${fuentes}" id="fuente" optionKey="id" optionValue="descripcion" name="fuente" class="fuente" style="width: 160px;"/>
                    </td>

                    <td class="valor">
                        <input type="text" style="width: 70px;color:black" class="valor" id="valor_txt" value="0">

                    </td>
                    <td>
                        <a href="#" id="guardar_btn" class="btn btn-sm btn-success guardar ajax" iden="" clase="act_" tr="" anio="${actual.id}"> <i class="fa fa-floppy"></i> Guardar</a>
                    </td>
                </tr>

                </tbody>
            </table>

            <div id="dlg_desc_obs" class="ui-helper-hidden">
                <input type="hidden" id="hid_desc">

                <input type="hidden" id="hid_obs">
                <b>Meta (255 caracteres):</b><br>

                <textArea name="desc" rows="6" cols="40" id="dlg_desc" ${(max?.aprobadoCorrientes!= 0) ? "disabled" : ""}
                          style="color: black"></textArea>
                <b>Indicador (255 caracteres):</b><br>

                <textArea name="desc" rows="6" cols="40" id="dlg_obs" ${(max?.aprobadoCorrientes!= 0) ? "disabled" : ""}
                          style="color: black"></textArea> <br>

                <div id="dlg_error"
                     style="width: 350px;height: 60px;margin-top: 5px;margin-left: 2px;display: none;padding: 3px;line-height: 24px;border:1px solid red;"
                     class="ui-corner-all"></div>
            </div>
        %{--</g:if>--}%
        %{--<g:else>--}%
            %{--Las asignaciones para este año ya han sido aprobadas--}%
        %{--</g:else>--}%
    %{--</g:if>--}%
    %{--<g:else>--}%
        %{--La unidad ejecutora no tiene asignado presupuesto para este año--}%
    %{--</g:else>--}%
</fieldset>



%{--<div id="buscar">--}%
    %{--<input type="hidden" id="id_txt">--}%

    %{--<div>--}%
        %{--Buscar por:--}%
        %{--<select id="tipo">--}%
            %{--<option value="1">Número</option>--}%
            %{--<option value="2">Descripción</option>--}%
        %{--</select>--}%

        %{--<input type="text" id="par" style="width: 160px;">--}%

        %{--<a href="#" class="btn" id="btn_buscar">Buscar</a>--}%
    %{--</div>--}%

    %{--<div id="resultado" style="width: 450px;margin-top: 10px;" class="ui-corner-all"></div>--}%
%{--</div>--}%

%{--<div id="dlg_buscar_act">--}%
    %{--<input type="hidden" id="id_txt_act">--}%

    %{--<div>--}%
        %{--Buscar por:--}%
        %{--<select id="tipo_act">--}%
            %{--<option value="1">Número</option>--}%
            %{--<option value="2">Descripción</option>--}%
        %{--</select>--}%

        %{--<input type="text" id="par_act" style="width: 160px;">--}%

        %{--<a href="#" class="btn" id="btn_buscar_act">Buscar</a>--}%
    %{--</div>--}%

    %{--<div id="resultado_act" style="width: 450px;margin-top: 10px;" class="ui-corner-all"></div>--}%
%{--</div>--}%


%{--<div id="dlgProg">--}%
    %{--<form id="frmCmbPrg">--}%
        %{--<input type="hidden" id="idAsg" name="idAsg"/>--}%

        %{--<p id="pTexto">--}%
            %{--Seleccione el nuevo programa--}%
        %{--</p>--}%
        %{--<g:select from="${programas}" name="progs" optionKey="id" value="${programa.id}"/>--}%
    %{--</form>--}%
%{--</div>--}%

%{--<div id="dlg_metas">--}%

    %{--<g:form action="guardarMeta" controller="meta" class="frm_meta">--}%
        %{--<div class="dialog">--}%
            %{--<table class="table table-condensed table-bordered table-striped table-hover" style="width: auto;">--}%

                %{--<tbody>--}%

                %{--<input type="hidden" id="asg_id">--}%
                %{--<input type="hidden" id="meta_id">--}%
                %{--<input type="hidden" id="indi_id">--}%

                %{--<tr class="prop">--}%

                    %{--<td valign="top" class="name">--}%
                        %{--Indicador--}%
                    %{--</td>--}%

                    %{--<td valign="top"--}%
                        %{--class="value ${hasErrors(bean: metaInstance, field: 'tipoMeta', 'errors')}">--}%
                        %{--<g:select class="field ui-widget-content ui-corner-all" name="tipoMeta.id"--}%
                                  %{--title="tipoMeta" from="${TipoMeta.list()}" optionKey="id"--}%
                                  %{--value="" noSelection="['null': '']" id="indicador"/>--}%
                    %{--</td>--}%
                %{--</tr>--}%

                %{--<tr class="prop">--}%
                    %{--<td valign="top" class="name">--}%
                        %{--Unidad--}%
                    %{--</td>--}%

                    %{--<td valign="top"--}%
                        %{--class="value ${hasErrors(bean: metaInstance, field: 'unidad', 'errors')}">--}%
                        %{--<g:select class="field ui-widget-content ui-corner-all" name="unidad.id"--}%
                                  %{--title="unidad"--}%
                                  %{--from="${Unidad.list()}" optionKey="id"--}%
                                  %{--value=""--}%
                                  %{--noSelection="['null': '']" id="unidad_meta"/>--}%
                    %{--</td>--}%
                %{--</tr>--}%

                %{--<tr class="prop">--}%
                    %{--<td valign="top" class="name">--}%
                        %{--Meta--}%
                    %{--</td>--}%

                    %{--<td valign="top"--}%
                        %{--class="value ${hasErrors(bean: metaInstance, field: 'indicador', 'errors')}">--}%
                        %{--<g:textField class="field number required ui-widget-content ui-corner-all"--}%
                                     %{--name="indicador"--}%
                                     %{--title="indicador" id="meta"--}%
                                     %{--value="${fieldValue(bean: metaInstance, field: 'indicador')}" style="width: 100px;" />--}%
                    %{--</td>--}%
                %{--</tr>--}%

                %{--<tr class="prop">--}%
                    %{--<td valign="top" class="name">--}%
                        %{--Parroquia--}%
                    %{--</td>--}%
                    %{--TODO cambiar por buscador o alguna molleja--}%
                    %{--<td valign="top"--}%
                        %{--class="value ${hasErrors(bean: metaInstance, field: 'parroquia', 'errors')}">--}%
                        %{--<a href="#" id="buscar_metas">Buscar</a>--}%

                        %{--<input type="hidden" id="parr_id" name="parroquia.id">--}%

                        %{--<div id="parr_nombre"></div>--}%
                    %{--</td>--}%
                %{--</tr>--}%
                %{--<tr class="prop">--}%
                    %{--<td valign="top" class="name">--}%
                        %{--Descripción--}%
                    %{--</td>--}%
                    %{--<td valign="top" class="value ">--}%
                        %{--<textarea style="width: 320px;height: 150px" id="desc_indi"></textarea>--}%
                    %{--</td>--}%
                %{--</tr>--}%

                %{--</tbody>--}%
            %{--</table>--}%
        %{--</div>--}%

        %{--<div id="dlg_buscar">--}%
            %{--<div style="width: 90%;height: 30px;">--}%
                %{--<input type="text" id="txt_buscar">--}%

                %{--<a href="#" id="buscar_dlgbtn" class="btn">Buscar</a>--}%
            %{--</div>--}%

            %{--<div id="parrs"--}%
                 %{--style="width: 95%;height: 340px;overflow-y: auto;margin: auto;margin-top: 10px;border: 1px solid black;"--}%
                 %{--class="ui-corner-all"></div>--}%
        %{--</div>--}%

        %{--<div style="width: 400px;height: 25px;display: none;margin-top: 10px;border: red 1px solid;background: rgba(255,0,0,0.5);padding: 5px" id="error_agr" class="ui-corner-all"></div>--}%
    %{--</g:form>--}%

%{--</div>--}%

<script type="text/javascript">


    $("#objetivo").change(function () {
//        console.log("entro " + $("#anio_asg").val())
        $("#tdMacro").html(spinner);
        $.ajax({
            type    : "POST",
            url     : "${createLink(controller: 'asignacion', action:'macro_ajax')}",
            data    : {
                objetivo : $("#objetivo").val()
            },
            success : function (msg) {
                $("#tdMacro").html(msg);
                $("#tdActividad").html("");
                $("#tdTarea").html("");

            }
        });
    });

    $("#anio").change(function () {

        location.href = "${createLink(action: 'asignacionesCorrientesv2')}?anio="+$(this).val();

//        console.log("entro " + $("#anio_asg").val())
//        $("#tdObjetivo").html(spinner);
        %{--$.ajax({--}%
            %{--type    : "POST",--}%
            %{--url     : "${createLink(controller: 'asignacion', action:'objetivos_ajax')}",--}%
            %{--data    : {--}%
                %{--anio : $("#anio_asg").val()--}%
            %{--},--}%
            %{--success : function (msg) {--}%
                %{--$("#tdObjetivo").html(msg);--}%
%{--//                $("#divAct").html("");--}%
%{--//                $("#divAsg").html("");--}%
            %{--}--}%
        %{--});--}%
    });



    var valorEditar = 0;

    function validar(tipo) {

        var prsp = $("#prsp_id").val();
        var valorTxt = $("#valor_txt");
        var prspField = $("#prsp_num");
        var valor = valorTxt.val();
        var actField = $("#actv");
        var actividad = actField.val();
        var band = true;

        valorTxt.removeClass("error");
        prspField.removeClass("error");

        valor = str_replace(".", "", valor);
        valor = str_replace(",", ".", valor);

        var max = parseFloat("${(maxUnidad - totalUnidad).toDouble().round(2)}");
        max = (max * 1 + valorEditar * 1);

        var mensaje, error;
        if (isNaN(valor)) {
            mensaje = "Error: El valor de la asignación debe ser un número";
            band = false;
            error = valorTxt;
        } else {
            valor = parseFloat(valor);
            valorTxt.val(number_format(valor, 2, ",", "."));
            if (valor > max) {
                mensaje = "Error: El valor de la asignación debe ser un número menor a " + number_format(max, 2, ",", ".");
                band = false;
                error = valorTxt;
            }
            if (tipo == 0) {
                if (valor <= 0) {
                    mensaje = "Error: El valor de la asignación debe ser un número mayor a cero";
                    band = false;
                    error = valorTxt;
                }
                if (isNaN(prsp)) {
                    prsp = 0
                }
                if (prsp * 1 == 0) {
                    mensaje = "Error: Seleccione una partida presupuestaria";
                    band = false;
                    error = prspField;
                }
                if (actividad.length == 0) {
                    mensaje = "Error: Debe llenar el campo actividad";
                    band = false;
                    error = actField;
                }

            }
        }

        if (!band) {
            alert(mensaje);
            error.addClass("error").show("pulsate");
        }
        return band;
    }

    $(function () {

        $("#valor_txt").blur(function () {
            validar(1);
        });

        $("#dlgProg").dialog({
            width:430,
            modal:true,
            title:"Cambiar el programa",
            autoOpen:false,
            open:function (event, ui) {
                $("#progs").val(${programa.id});
                $('select#progs').selectmenu("value", "${programa.id}");
            },
            buttons:{
                "Aceptar":function () {
                    %{--var data = $("#frmCmbPrg").serialize();--}%
                    %{--var url = "${createLink(action: 'cambiarPrograma')}?" + data + "&programa=${programa.id}&anio=${actual.id}&id=${unidad.id}";--}%
                    %{--location.href = url;--}%
                },
                "Cancelar":function () {
                    $(this).dialog("close");
                }
            }
        });
        $(".btnCambiarPrograma").button({
            icons:{
                primary:"ui-icon-shuffle"
            },
            text:false
        }).click(function () {
            var id = $(this).attr("id");
            var parts = id.split("_");
            var act = $(this).parents("tr").find(".actividad").text().trim();
            $("#idAsg").val(parts[1]);
            $("#pTexto").html("Seleccione el nuevo programa para la asignación:<br/> <b>" + act + "</b>");
            $("#dlgProg").dialog("open");
            return false;
        });

        $(".btn_editar").button({
            icons:{
                primary:"ui-icon-pencil"
            },
            text:false
        }).click(function () {
            $("#hid_desc").val($(this).attr("desc"))
            $("#hid_obs").val($(this).attr("obs"))
            $("#dlg_desc").val($("#" + $(this).attr("desc")).val())
            $("#dlg_obs").val($("#" + $(this).attr("obs")).val())
            $("#dlg_error").hide().html("")
            $("#dlg_desc_obs").dialog("open")
        });

        $("#btnReporte").button({
            icons:{
                primary:"ui-icon-calculator"
            }
        }).click(function () {
            %{--var url = "${createLink(controller: 'reportes', action: 'poaReporteWeb', id: unidad.id)}?anio=" + $("#anio_asg").val();--}%
            %{--window.open(url);--}%
        });


        $("#dlg_desc_obs").dialog({
            title:"Editar descripción y observaciones",
            width:400,
            height:400,
            autoOpen:false,
            modal:true,
            buttons:{
                "Aceptar":function () {
                    if ($("#dlg_desc").val().length < 255) {
                        if ($("#dlg_obs").val().length < 127) {
                            $("#" + $("#hid_desc").val()).val($("#dlg_desc").val())
                            $("#dlg_desc").val("")
                            $("#" + $("#hid_obs").val()).val($("#dlg_obs").val())
                            $("#dlg_obs").val("")
                            $("#dlg_desc_obs").dialog("close")
                        } else {
                            $("#dlg_error").html("El campo meta no puede contener mas de 255 caracteres. Actual(" + $("#dlg_obs").val().length + ")")
                            $("#dlg_error").addClass("error")
                            $("#dlg_error").show("pulsate")
                        }
                    } else {
                        $("#dlg_error").html("El campo indicador no puede contener mas de 255 caracteres. Actual(" + $("#dlg_dscr").val().length + ")")
                        $("#dlg_error").addClass("error")
                        $("#dlg_error").show("pulsate")
                    }
                }

            }
        });

//        $("#progs").selectmenu({width:380, height:50})
//        $("[name=programa]").selectmenu({width:380, height:50})
//        $("#componente").selectmenu({width:340, height:50})
        $("#programa-button").css("height", "40px")
        $(".btn_arbol").button({icons:{ primary:"ui-icon-bullet"}})
        $(".btn").button()
        $(".back").button("option", "icons", {primary:'ui-icon-arrowreturnthick-1-w'});


        $(".editar").button({
            icons:{
                primary:"ui-icon-pencil"
            },
            text:false
        }).click(function () {

            valorEditar = $(this).attr("valor");
            if ($(this).attr("comp") * 1 > 0) {
                $("#componente").selectmenu("value", $(this).attr("comp"));
            } else {
                $("#componente").selectmenu("value", "-1");
            }
            $("#programa").selectmenu("value", $(this).attr("prog"));
            $("#fuente").val($(this).attr("fuente"));
            $("#valor_txt").val(number_format($(this).attr("valor"), 2, ",", "."));
            $("#prsp_id").val($(this).attr("prsp_id"));
            $("#prsp_num").val($(this).attr("prsp_num"));
            $("#desc").html($(this).attr("desc"));
            $("#guardar_btn").attr("iden", $(this).attr("iden"));
            $("#actv").val($(this).attr("actv"));
            $("#meta").val($(this).attr("meta"));
            $("#indi").val($(this).attr("indi"));
        });

        $(".eliminar").button({
            icons:{
                primary:"ui-icon-trash"
            },
            text:false
        }).click(function () {
            if (confirm("Está seguro de querer eliminar esta asignación?\nSe eliminarán las asignaciones hijas, el PAC, y la programación asociadas.")) {
                var id = $(this).attr("iden");
                var btn = $(this);
                $.ajax({
                    type:"POST",
                    url:"${createLink(action:'eliminarAsignacion')}",
                    data:{
                        id:id
                    },
                    success:function (msg) {
                        if (msg == "OK") {
                            window.location.reload(true);
                        } else {
                            alert("Ha ocurrido un error.")
                        }
                    }
                });
            }
        });

        $("#anio_asg, #programa").change(function () {
            %{--location.href = "${createLink(controller:'asignacion',action:'asignacionesCorrientesv2')}?id=${unidad.id}&anio=" + $("#anio_asg").val() + "&programa=" + $("#programa").val();--}%
        });

        $(".guardar").click(function () {
            var prsp = $("#prsp_id").val();
            var valorTxt = $("#valor_txt");
            var prspField = $("#prsp_num");
            var valor = valorTxt.val();
            var actField = $("#actv");
            var actividad = actField.val();
            var band = true;
            var comp = $("#componente").val()

            var boton = $(this);
            if (validar(0)) {
                %{--var anio = boton.attr("anio")--}%
                %{--var fuente = $("#fuente").val()--}%
                %{--var programa = $("#programa").val()--}%
                %{--$.ajax({--}%
                    %{--type:"POST",--}%
                    %{--url:"${createLink(action:'guardarAsignacion',controller:'asignacion')}",--}%
                    %{--data:"anio.id=" + anio + "&fuente.id=" + fuente + "&programa.id=" + programa + "&planificado=" + valor + "&presupuesto.id=" + prsp + "&unidad.id=${unidad.id}" + "&actividad=" + actividad + /*"&meta=" + meta + "&indicador=" + indi + */"&componente.id=" + comp + ((isNaN(boton.attr("iden"))) ? "" : "&id=" + boton.attr("iden")),--}%
                    %{--success:function (msg) {--}%
                        %{--if (msg * 1 >= 0) {--}%
                            %{--location.reload(true);--}%
                        %{--} else {--}%
                            %{--alert("Error al guardar los datos")--}%
                        %{--}--}%

                    %{--}--}%
                %{--});--}%
            }
        });

        $(".buscar").click(function () {
            $("#id_txt").val($(this).attr("id"))
            $("#buscar").dialog("open")
        });
        $(".buscarAct").click(function () {
            $("#id_txt_act").val($(this).attr("id"))
            $("#dlg_buscar_act").dialog("open")
        });
        $("#btn_buscar").click(function () {
            $.ajax({
                type:"POST",
                url:"${createLink(action:'buscarPresupuesto',controller:'asignacion')}",
                data:"parametro=" + $("#par").val() + "&tipo=" + $("#tipo").val(),
                success:function (msg) {
                    $("#resultado").html(msg)
                }
            });
        });
        $("#buscar").dialog({
            title:"Cuentas presupuestarias",
            width:520,
            height:500,
            autoOpen:false,
            modal:true
        })
        $("#dlg_buscar_act").dialog({
            title:"Actividades corrientes",
            width:480,
            height:500,
            autoOpen:false,
            modal:true
        })
        $("#btn_buscar_act").click(function () {
            $.ajax({
                type:"POST",
                url:"${createLink(action:'buscarActividad',controller:'asignacion')}",
                data:"parametro=" + $("#par_act").val() + "&tipo=" + $("#tipo").val(),
                success:function (msg) {
                    $("#resultado_act").html(msg)
                }
            });
        });
        $("#buscar_metas").button().click(function () {
            $("#dlg_buscar").dialog("open")
        });
        $("#buscar_dlgbtn").click(function () {
            $.ajax({
                type:"POST",
                url:"${createLink(action:'buscarParroquias',controller:'meta')}",
                data:"parametro=" + $("#txt_buscar").val(),
                success:function (msg) {
                    $("#parrs").html(msg)

                }
            });
        });
        $("#dlg_buscar").dialog({
            width:630,
            height:500,
            position:"center",
            modal:true,
            autoOpen:false
        })


        $("#dlg_metas").dialog({
            title:"Meta e indicador",
            width:460,
            height:400,
            autoOpen:false,
            modal:true,
            buttons:{
                "Guardar":function () {

                    %{--var band = true;--}%
                    %{--if($("#indicador").val()=="null" || $("#unidad_meta").val()=="null")--}%
                        %{--band=false--}%
                    %{--if($("#meta").val()=="" || $("#desc_indi").val()=="")--}%
                        %{--band=false--}%
                    %{--if(isNaN($("#meta").val()))--}%
                        %{--band=false--}%
                    %{--if(isNaN($("#parr_id").val()) || $("#parr_id").val()=="")--}%
                        %{--band=false--}%
                    %{--if(band){--}%
                        %{--$.ajax({--}%
                            %{--type:"POST",--}%
                            %{--url:"${createLink(action:'guardaMetaIndicador',controller:'meta')}",--}%
                            %{--data:"anio.id=" + $("#anio_asg").val()+"&asignacion.id="+$("#asg_id").val()+"&tipoMeta.id="+$("#indicador").val()+"&indicador="+$("#meta").val()+"&unidad.id="+$("#unidad_meta").val()+"&parroquia.id="+$("#parr_id").val()+"&indi.descripcion="+$("#desc_indi").val()+"&indi.id="+$("#indi_id").val()+"&indi.asignacion.id="+$("#asg_id").val()+"&id="+$("#meta_id").val(),--}%
                            %{--success:function (msg) {--}%
                                %{--if(msg=="ok")--}%
                                    %{--$("#dlg_metas").dialog("close")--}%

                            %{--}--}%
                        %{--});--}%
                    %{--}else{--}%
                        %{--if(isNaN($("#meta").val()))--}%
                            %{--alert("El campo meta debe ser un número")--}%
                        %{--else--}%
                            %{--alert("Todos los campos son obligatorios")--}%
                    %{--}--}%
                },"Cerrar":function(){
                    $("#dlg_metas").dialog("close")
                }

            }
        })



        $(".metas").button({
            icons:{
                primary:"ui-icon-newwin"
            },
            text:false
        }).click(function () {
            $("#asg_id").val($(this).attr("iden"))
            $.ajax({
                type:"POST",
                url:"${createLink(action:'getDatosMeta',controller:'meta')}",
                data:"id=" + $("#asg_id").val(),
                success:function (msg) {
                    var a = new Array()
                    a = msg.split("&&")
                    if(a.length>2){
                        $("#meta_id").val(a[1])
                        $("#meta").val(a[2])
                        $("#parr_nombre").html(a[3])
                        $("#parr_id").val(a[4])
                        $("#indicador").val(a[5])
                        $("#unidad_meta").val(a[6])
                        if(a.length>7){
                            $("#indi_id").val(a[7])
                            $("#desc_indi").val(a[8])
                        }else{
                            $("#indi_id").val("")
                            $("#desc_indi").val("")
                        }


                    }else{
                        $("#indi_id").val("")
                        $("#desc_indi").val("")
                        $("#meta_id").val("")
                        $("#meta").val("")
                        $("#parr_nombre").html(" ")
                        $("#parr_id").val("")
                        $("#indicador").val("")
                        $("#unidad_meta").val("")
                    }

                    $("#dlg_metas").dialog("open")
                }
            });

        });


    });
</script>

</body>
</html>