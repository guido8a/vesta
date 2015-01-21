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

        <div style="margin-left: 10px;">

            <g:link class="btn" controller="asignacion" action="programacionInversion" params="[proyecto: proy.id, anio: actual.id]">Programación</g:link>
            %{--<g:link class="btn" controller="asignacion" action="programacionInversion" params="[id:unidad.id,anio:actual.id]">Programación</g:link>--}%
            <div style="margin-top: 15px;">

                <table width="700">
                    <tr>
                        <th>Año</th>
                        %{--<th>Programa</th>--}%
                        <th>Componente</th>
                    </tr>

                    <tr>
                        <td><g:select from="${Anio.list([sort: 'anio'])}" id="anio_asg" name="anio" optionKey="id" optionValue="anio" value="${actual.id}"/></td>
                        <input type="hidden" id="programa" name="programa" class="cronograma" value="${proy.programaPresupuestario.id}">
                        %{--<td>--}%
                            %{----}%
                            %{--${proy.programaPresupuestario}--}%
                        %{--</td>--}%

                        <td>

                            <g:select from="${comp}" id="componente" optionKey="id" name="componente" class="componente" value="${cmp?.id}"/>
                        </td>
                    </tr>
                </table>

            </div>
        </div>

        <g:if test="${flash.message}">
            <div class="${flash.clase}">
                ${flash.message}
            </div>
        </g:if>

        <fieldset class="ui-corner-all" style="min-height: 110px;font-size: 11px;">
            <legend>
                Ingreso de datos
            </legend>

            <table style="width: 1000px;">
                <thead>
                    <th style="width: 300px">Actividad</th>
                    <th style="width: 60px;">Partida</th>
                    <th style="width: 190px">Desc. Presupuestaria</th>
                    <th style="width: 150px;">Fuente</th>
                    <th style="width: 50px;">Presupuesto</th>
                    <th style="width: 50px;"></th>
                </thead>
                <tbody>

                    <tr class="odd">
                        <td class="actividad">
                            <g:select from="${acts}" id="actv" optionKey="id" name="activdad" class="actividad" value=""/>

                        </td>

                        <td class="prsp">
                            <input type="hidden" class="prsp" value="" id="prsp_id">

                            <input type="text" id="prsp_num" class="buscar ui-corner-all" style="width: 60px;color:black">
                        </td>

                        <td class="desc" id="desc" style="width: 200"></td>

                        <td class="fuente">
                            <g:select from="${fuentes}" id="fuente" optionKey="id" optionValue="descripcion" name="fuente" class="fuente ui-corner-all" style="width: 160px;"/>
                        </td>

                        <td class="valor">
                            <input type="text" style="width: 70px;color:black;text-align: right;padding-right: 5px" class="valor ui-corner-all" id="valor_txt" value="0">

                        </td>

                        <td>
                            <a href="#" id="guardar_btn" class="btn guardar ajax" iden="" icono="ico_001" clase="act_" tr="" anio="${actual.id}">Guardar</a>
                        </td>
                    </tr>

                </tbody>
            </table>

        </fieldset>
        <fieldset class="ui-corner-all" style="min-height: 100px;font-size: 11px">
            <legend>
                Detalle
            </legend>
            <g:set var="total" value="0"/>
            <table style="width: 100%; margin-bottom: 10px;">
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

                            <td class="desc" style="width: 200">
                                ${asg.presupuesto.descripcion}
                            </td>

                            <td class="fuente">
                                ${asg.fuente.descripcion}
                            </td>

                            <td class="valor" style="text-align: right">
                                <g:formatNumber number="${(asg.redistribucion == 0) ? asg.planificado.toDouble() : asg.redistribucion.toDouble()}"
                                                format="###,##0"
                                                minFractionDigits="2" maxFractionDigits="2"/>
                                <g:set var="total" value="${total.toDouble().round(2) + ((asg.redistribucion == 0) ? asg.planificado.toDouble().round(2) : asg.redistribucion.toDouble().round(2))}"></g:set>
                            </td>

                            %{--<td style="text-align: center">--}%
                            %{--<g:if test="${max?.aprobadoCorrientes==0}">--}%
                            %{--<a href="#" class="btn editar ajax" iden="${asg.id}" icono="ico_001" clase="act_" band="0" tr="#det_${i}" prog="${asg.programa.id}" prsp_id="${asg.presupuesto.id}" prsp_num="${asg.presupuesto.numero}" desc="${asg.presupuesto.descripcion}" fuente="${asg.fuente.id}" valor="${(asg.redistribucion == 0) ? asg.planificado.toDouble().round(2) : asg.redistribucion.toDouble().round(2)}" actv="${asg.actividad}" meta="${asg.meta}" indi="${asg.indicador}" comp="${asg?.componente?.id}">Editar</a>--}%
                            %{--</g:if>--}%
                            %{--</td>--}%

                            <td style="text-align: center">

                                <a href="#" class="btn eliminar ajax" iden="${asg.id}" icono="ico_001" clase="act_" band="0" tr="#det_${i}"
                                   prog="${asg.marcoLogico.proyecto.programaPresupuestario.id}" prsp_id="${asg.presupuesto.id}" prsp_num="${asg.presupuesto.numero}" desc="${asg.presupuesto.descripcion}"
                                   fuente="${asg.fuente.id}" valor="${asg.planificado}" actv="${asg.marcoLogico}">Eliminar</a>

                            </td>
                        </tr>

                    </g:each>
                </tbody>
            </table>

        </fieldset>


        <div id="buscar">
            <input type="hidden" id="id_txt">

            <div>
                Buscar por:
                <select id="tipo">
                    <option value="1">Número</option>
                    <option value="2">Descripción</option>
                </select>

                <input type="text" id="par" style="width: 160px;">

                <a href="#" class="btn" id="btn_buscar">Buscar</a>
            </div>

            <div id="resultado" style="width: 450px;margin-top: 10px;" class="ui-corner-all"></div>
        </div>

        <div id="dlg_buscar_act">
            <input type="hidden" id="id_txt_act">

            <div>
                Buscar por:
                <select id="tipo_act">
                    <option value="1">Número</option>
                    <option value="2">Descripción</option>
                </select>

                <input type="text" id="par_act" style="width: 160px;">

                <a href="#" class="btn" id="btn_buscar_act">Buscar</a>
            </div>

            <div id="resultado_act" style="width: 450px;margin-top: 10px;" class="ui-corner-all"></div>
        </div>


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

        %{--<div style="position: absolute;top:25px;right:25px;font-size: 15px;">--}%
        %{--<b>Total Unidad:</b>--}%
        %{--<g:formatNumber number="${totalUnidad}"--}%
        %{--format="###,##0"--}%
        %{--minFractionDigits="2" maxFractionDigits="2"/>--}%
        %{--</div>--}%

        %{--<div style="position: absolute;top:45px;right:25px;font-size: 15px;">--}%
        %{--<b>M&aacute;ximo Inversiones:</b>--}%
        %{--<g:formatNumber number="${maxUnidad}"--}%
        %{--format="###,##0"--}%
        %{--minFractionDigits="2" maxFractionDigits="2"/>--}%
        %{--</div>--}%



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

                valor = str_replace(".", "", valor);
                valor = str_replace(",", ".", valor);

                var max = 111111111111;
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

//
//        $(".btn_editar").button({
//            icons:{
//                primary:"ui-icon-pencil"
//            },
//            text:false
//        }).click(function () {
//                    $("#hid_desc").val($(this).attr("desc"))
//                    $("#hid_obs").val($(this).attr("obs"))
//                    $("#dlg_desc").val($("#" + $(this).attr("desc")).val())
//                    $("#dlg_obs").val($("#" + $(this).attr("obs")).val())
//                    $("#dlg_error").hide().html("")
//                    $("#dlg_desc_obs").dialog("open")
//                });

                $("#btnReporte").click(function () {
                    var url = "${createLink(controller: 'reportes', action: 'poaReporteWeb', id: unidad.id)}?anio=" + $("#anio_asg").val();
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

                %{--$("#componente").selectmenu({width : 600, height : 50}).change(function () {--}%
                    %{--location.href = "${g.createLink(action: 'agregarAsignacionInv')}?id=${proy.id}&anio=" + $("#anio_asg").val() + "&comp=" + $("#componente").val();--}%
                %{--});--}%
                %{--$("#actv").selectmenu({width : 315, height : 50});--}%
                $("#programa-button").css("height", "40px");

//        $(".editar").button({
//            icons:{
//                primary:"ui-icon-pencil"
//            },
//            text:false
//        }).click(function () {
//
//                    valorEditar = $(this).attr("valor");
//                    if ($(this).attr("comp") * 1 > 0) {
//                        $("#componente").selectmenu("value", $(this).attr("comp"));
//                    } else {
//                        $("#componente").selectmenu("value", "-1");
//                    }
//                    $("#programa").selectmenu("value", $(this).attr("prog"));
//                    $("#fuente").val($(this).attr("fuente"));
//                    $("#valor_txt").val(number_format($(this).attr("valor"), 2, ",", "."));
//                    $("#prsp_id").val($(this).attr("prsp_id"));
//                    $("#prsp_num").val($(this).attr("prsp_num"));
//                    $("#desc").html($(this).attr("desc"));
//                    $("#guardar_btn").attr("iden", $(this).attr("iden"));
//                    $("#actv").val($(this).attr("actv"));
//                    $("#meta").val($(this).attr("meta"));
//                    $("#indi").val($(this).attr("indi"));
//                });

                $(".eliminar").button({
                    icons : {
                        primary : "ui-icon-trash"
                    },
                    text  : false
                }).click(function () {
                    if (confirm("Está seguro de querer eliminar esta asignación?\nSe eliminarán las asignaciones hijas, el PAC, y la programación asociadas.")) {
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

                $(".guardar").click(function () {
                    var prsp = $("#prsp_id").val();
                    var valorTxt = $("#valor_txt");
                    var prspField = $("#prsp_num");
                    var valor = valorTxt.val();
                    var actField = $("#actv");
                    var actividad = actField.val();
                    var band = true;
                    var comp = $("#componente").val();
                    var boton = $(this);
                    if (validar(0)) {
                        var anio = boton.attr("anio");

                        $.ajax({
                            type    : "POST",
                            url     : "${createLink(controller:'asignacion', action:'validarCronograma_ajax')}",
                            data    : {
                                anio        : anio,
                                planificado : valor,
                                marco       : actividad
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
                                    alert(msg);
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