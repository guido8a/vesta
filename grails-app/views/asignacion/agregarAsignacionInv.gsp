<%@ page import="vesta.parametros.poaPac.Anio" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta name="layout" content="main"/>
    <title>Asignaciones del proyecto: ${proy}</title>


    <style type="text/css">
    .btnCambiarPrograma {
        width  : 16px;
        height : 16px;
    }
    </style>

</head>

<body>

<elm:message tipo="${flash.tipo}" clase="${flash.clase}">${flash.message}</elm:message>


<div class="btn-toolbar toolbar">
    <div class="btn-group">
        %{--<g:link class="btn btn-default btn-sm" controller="asignacion" action="programacionAsignacionesInversionPrio" params="[proyecto: proy.id, anio: actual.id]">Programación</g:link>--}%
        <g:link class="btn btn-default btn-sm " controller="asignacion" action="programacionAsignacionesInversion" params="[id:proy.id,anio:actual.id]" ><i class="fa fa-calendar"></i> Programación</g:link>

    </div>
</div>
<div class="row">
    <input type="hidden" id="programa" name="programa" class="cronograma" value="${proy?.programaPresupuestario?.id}">
    <div class="col-md-1">
        <label>
            Año
        </label>
    </div>
    <div class="col-md-2">
        <g:select from="${Anio.list([sort: 'anio'])}" id="anio_asg" name="anio" optionKey="id" optionValue="anio" value="${actual.id}" class="form-control input-sm"/>
    </div>
    <div class="col-md-1">
        <label>
            Componente
        </label>
    </div>
    <div class="col-md-2">
        <g:select from="${comp}" id="componente" optionKey="id" name="componente" class="componente" value="${cmp?.id}" class="form-control input-sm"/>
    </div>

</div>
<elm:container tipo="horizontal" titulo="Ingreso de datos" color="black" style="min-height: 110px;font-size: 11px;">
    <table  class="table table-stripped table-condensed ">
        <thead>
        <th style="width: 300px">Actividad</th>
        <th style="width: 200px;">Partida</th>
        <th style="width: 200px;">Fuente</th>
        <th style="width: 100px;">Presupuesto</th>
        <th style="width: 50px;"></th>
        </thead>
        <tbody>

        <tr >
            <td class="actividad">
                <g:select from="${acts}" id="actv" optionKey="id" name="activdad" class="actividad form-control input-sm" value=""/>
            </td>
            <td class="prsp" style="width: 210px !important;">
                <bsc:buscador name="partida" id="prsp_id" controlador="asignacion" accion="buscarPresupuesto" tipo="search" titulo="Busque una partida" campos="${campos}"  clase="required"  style="width: 200px" />
            </td>
            <td class="fuente" >
                <g:select from="${fuentes}" id="fuente" optionKey="id" optionValue="descripcion" name="fuente" class="fuente  form-control input-sm" />
            </td>
            <td class="valor">
                %{--<input type="text" style="width: 100px;color:black;text-align: right;padding-right: 5px" class="valor  form-control input-sm number money"  id="valor_txt" value="0">--}%
                <g:textField name="valorName" id="valor_txt" class="form-control input-sm number money" style="width: 100px;color:black;text-align: right;padding-right: 5px"/>
            </td>
            <td style="text-align: center">
                <a href="#" id="guardar_btn" class="btn guardar ajax btn-primary btn-sm" iden="" icono="ico_001" clase="act_" tr="" anio="${actual.id}">Guardar</a>
            </td>
        </tr>

        </tbody>
    </table>
</elm:container>
<elm:container tipo="horizontal" titulo="Detalle" color="black" style="min-height: 150px;font-size: 11px;">
    <g:set var="total" value="0"/>
    <table style=" margin-bottom: 10px;" class="table table-stripped table-condensed table-bordered">
        <thead>
        %{--<th style="width: 40px;">ID</th>--}%
        %{--<th style="width: 220px">Programa</th>--}%
        <th style="width: 120px">Componente</th>
        <th style="width: 240px">Actividad</th>
        <th style="width: 60px;">Partida</th>
        <th style="width: 200px">Desc. Presupuestaria</th>
        <th>Fuente</th>
        <th>Presupuesto</th>
        <th></th>
        </thead>
        <tbody>
        <g:each in="${asgn}" var="asg" status="i">
            <tr class="${(i % 2) == 0 ? 'odd' : 'even'}" id="det_${i}">
                %{--<td>--}%
                %{--${asg.id}--}%
                %{--</td>--}%
                %{--<td class="programa">--}%
                %{--${asg.marcoLogico.proyecto.programaPresupuestario}--}%
                %{--</td>--}%

                <td>
                    ${asg.marcoLogico.marcoLogico}
                </td>

                <td class="actividad">
                    ${asg.marcoLogico}
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
                    <g:if test="${actual.estado==1}">
                        <g:formatNumber number="${asg.priorizado}" type="currency" currencySymbol=""/>
                        <g:set var="total" value="${total.toDouble().round(2) + asg.priorizado}"></g:set>
                    </g:if>
                    <g:else>
                        <g:formatNumber number="${asg.planificado}" type="currency" currencySymbol=""/>
                         <g:set var="total" value="${total.toDouble().round(2) + asg.planificado}"></g:set>
                    </g:else>

                </td>

                %{--<td style="text-align: center">--}%
                %{--<g:if test="${max?.aprobadoCorrientes==0}">--}%
                %{--<a href="#" class="btn editar ajax" iden="${asg.id}" icono="ico_001" clase="act_" band="0" tr="#det_${i}" prog="${asg.programa.id}" prsp_id="${asg.presupuesto.id}" prsp_num="${asg.presupuesto.numero}" desc="${asg.presupuesto.descripcion}" fuente="${asg.fuente.id}" valor="${(asg.redistribucion == 0) ? asg.planificado.toDouble().round(2) : asg.redistribucion.toDouble().round(2)}" actv="${asg.actividad}" meta="${asg.meta}" indi="${asg.indicador}" comp="${asg?.componente?.id}">Editar</a>--}%
                %{--</g:if>--}%
                %{--</td>--}%

                <td style="text-align: center">

                    <a href="#" class="btn btn-danger btn-sm eliminar ajax" iden="${asg.id}" icono="ico_001" clase="act_" band="0" tr="#det_${i}"
                       prog="${asg?.marcoLogico?.proyecto?.programaPresupuestario?.id}" prsp_id="${asg.presupuesto.id}" prsp_num="${asg.presupuesto.numero}" desc="${asg.presupuesto.descripcion}"
                       fuente="${asg.fuente.id}" valor="${asg.planificado}" actv="${asg.marcoLogico}" title="Eliminar">
                        <i class="fa fa-trash"></i>
                    </a>
                </td>
            </tr>

        </g:each>
        <tr>
            <td colspan="5" style="font-weight: bold;text-align: right">
                TOTAL
            </td>
            <td style="text-align: right;font-weight: bold">
                <g:formatNumber number="${total.toDouble()}" type="currency" currencySymbol=""/>
            </td>
        </tr>
        </tbody>
    </table>

</elm:container>


<div style="position: absolute;top:25px;right:25px;font-size: 15px;">
    <b>Total Priorizado:</b>
    <g:formatNumber number="${totalPriorizado}"
                    format="###,##0"
                    minFractionDigits="2" maxFractionDigits="2"/>
</div>

<div style="position: absolute;top:45px;right:25px;font-size: 15px;">
    <b>Total ${actual.anio}:</b>
    <g:formatNumber number="${totalAnio}"
                    format="###,##0"
                    minFractionDigits="2" maxFractionDigits="2"/>
</div>

<script type="text/javascript">

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
        var reemplazado = 0

//        console.log("valor original " + valor)

//        valor = str_replace(".", "", valor);
        valor = str_replace(",", "", valor);

//        console.log("despues " + valor)

        var max = 111111111111;
        max = (max * 1 + valorEditar * 1);

        var mensaje, error;
        if (isNaN(valor)) {
//            mensaje = "Error: El valor de la asignación debe ser un número";
            bootbox.alert("Error: El valor de la asignación debe ser un número")
            band = false;
            error = valorTxt;
        } else {

            valor = parseFloat(valor);
            valorTxt.val(valor)
//            valorTxt.val(number_format(valor, 2, ",", ""));
//            console.log(valorTxt)
//            console.log(valor)
            if (valor > max) {
//                mensaje = "Error: El valor de la asignación debe ser un número menor a " + number_format(max, 2, ",", ".");
                bootbox.alert("Error: El valor de la asignación debe ser un número menor a " + number_format(max, 2, ",", ""))
                band = false;
                error = valorTxt;
            }
            if (tipo == 0) {
                if (valor <= 0) {
                    bootbox.alert("Error: El valor de la asignación debe ser un número mayor a cero")
                    band = false;
                    error = valorTxt;
                }
                if (isNaN(prsp)) {
                    prsp = 0
                }
                if (prsp * 1 == 0) {
//                    mensaje = "Error: Seleccione una partida presupuestaria";
                    bootbox.alert("Error: Seleccione una partida presupuestaria")
                    band = false;
                    error = prspField;
                }

            }
        }

//        if (!band) {
//            alert(mensaje);
//            error.addClass("error").show("pulsate");
//        }
        return band;
    }

    $(function () {

//        $("#valor_txt").blur(function () {
//            validar(1);
//        });

        $("#btnReporte").click(function () {
            var url = "${createLink(controller: 'reportes', action: 'poaReporteWeb', id: unidad?.id)}?anio=" + $("#anio_asg").val();
            window.open(url);
        });

        $("#dlg_desc_obs").dialog({
            title    : "Editar descripción y observaciones",
            width    : 400,
            height   : 400,
            autoOpen : false,
            modal    : true,
            buttons  : {
                "Aceptar" : function () {
                    if ($("#dlg_desc").val().length < 255) {
                        if ($("#dlg_obs").val().length < 127) {
                            $("#" + $("#hid_desc").val()).val($("#dlg_desc").val());
                            $("#dlg_desc").val("");
                            $("#" + $("#hid_obs").val()).val($("#dlg_obs").val());
                            $("#dlg_obs").val("");
                            $("#dlg_desc_obs").dialog("close")
                        } else {
                            $("#dlg_error").html("El campo meta no puede contener mas de 255 caracteres. Actual(" + $("#dlg_obs").val().length + ")");
                            $("#dlg_error").addClass("error");
                            $("#dlg_error").show("pulsate");
                        }
                    } else {
                        $("#dlg_error").html("El campo indicador no puede contener mas de 255 caracteres. Actual(" + $("#dlg_dscr").val().length + ")");
                        $("#dlg_error").addClass("error");
                        $("#dlg_error").show("pulsate");
                    }
                }

            }
        });

        $("#programa-button").css("height", "40px");

        $(".eliminar").button({
            icons : {
                primary : "ui-icon-trash"
            },
            text  : false
        }).click(function () {
            if (confirm("Está seguro de querer eliminar esta asignación?\nSe eliminarán las asignaciones hijas, y la programación asociadas.")) {
                var id = $(this).attr("iden");
                var btn = $(this);
                $.ajax({
                    type    : "POST",
                    url     : "${createLink(action:'eliminarAsignacion')}",
                    data    : {
                        id : id
                    },
                    success : function (msg) {
                        if (msg == "OK") {
                            window.location.reload(true);
                        } else {
                            alert("Esta asginación no puede ser eliminada porque tiene certificaciones, modificaciones u otras asignaciones dependientes.")
                        }
                    }
                });
            }
        });

        $("#anio_asg, #programa").change(function () {
            location.href = "${createLink(controller:'asignacion',action:'agregarAsignacionInv')}?id=${proy.id}&anio=" + $("#anio_asg").val() + "&programa=" + $("#programa").val();
        });

        $("#guardar_btn").click(function () {
            var prsp = $("#prsp_id").val();
            var valorTxt = $("#valor_txt");
            var prspField = $("#prsp_num");
            var valor = valorTxt.val();
            var actField = $("#actv");
            var actividad = actField.val();
            var band = true;
            var proyec = ${proy?.id};
            var comp = $("#componente").val();
            var boton = $(this);
            console.log("--->" + valor)
            if (validar(0)) {
                var anio = boton.attr("anio");
                console.log(validar(0))
                $.ajax({
                    type    : "POST",
                    url     : "${createLink(controller:'asignacion', action:'validarCronograma_ajax')}",
                    data    : {
                        anio        : anio,
                        planificado : valor,
                        marco       : actividad,
                        proyecto    : proyec
                    },
                    success : function (msg) {
                        if (msg == "true") {
                            var fuente = $("#fuente").val();
                            var programa = $("#programa").val();
                            $.ajax({
                                type    : "POST",
                                url     : "${createLink(action:'guardarAsignacion',controller:'asignacion')}",
                                data    : "anio.id=" + anio + "&fuente.id=" + fuente + "&planificado=" + valor + "&presupuesto.id=" + prsp + "&marcoLogico.id=" + actividad + ((isNaN(boton.attr("iden"))) ? "" : "&id=" + boton.attr("iden")),
                                success : function (msg) {
                                    if (msg * 1 >= 0) {
                                        location.reload(true);
                                    } else {
                                        alert("Error al guardar los datos")
                                    }
                                }
                            });
                        } else {
                            bootbox.alert(msg)
                        }
                    }
                });
            }
        });

        $(".buscar").click(function () {
            $("#id_txt").val($(this).attr("id"));
            $("#buscar").dialog("open")
        });
        $(".buscarAct").click(function () {
            $("#id_txt_act").val($(this).attr("id"));
            $("#dlg_buscar_act").dialog("open")
        });
        $("#btn_buscar").click(function () {
            $.ajax({
                type    : "POST",
                url     : "${createLink(action:'buscarPresupuesto',controller:'asignacion')}",
                data    : "parametro=" + $("#par").val() + "&tipo=" + $("#tipo").val(),
                success : function (msg) {
                    $("#resultado").html(msg)
                }
            });
        });
        $("#buscar").dialog({
            title    : "Cuentas presupuestarias",
            width    : 520,
            height   : 500,
            autoOpen : false,
            modal    : true
        });
        $("#dlg_buscar_act").dialog({
            title    : "Actividades corrientes",
            width    : 480,
            height   : 500,
            autoOpen : false,
            modal    : true
        });
        $("#btn_buscar_act").click(function () {
            $.ajax({
                type    : "POST",
                url     : "${createLink(action:'buscarActividad',controller:'asignacion')}",
                data    : "parametro=" + $("#par_act").val() + "&tipo=" + $("#tipo").val(),
                success : function (msg) {
                    $("#resultado_act").html(msg)
                }
            });
        });
    });
</script>

</body>
</html>