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

<div style="margin-top: 15px;">

    <table class="table table-condensed table-bordered table-striped table-hover" style="width: auto;">
        <thead>
        <tr>
            <th style="width: 250px">Objetivo gasto corriente</th>
            <th style="width: 250px;">Macro Actividad</th>
            <th style="width: 250px">Actividad gasto corriente</th>
            <th style="width: 250px">Tarea</th>
        </tr>
        </thead>

        <tr>
            <td><g:select from="${objetivos}" id="objetivo" name="objetivo_name" optionKey="id" optionValue="descripcion" class="many-to-one form-control input-sm" noSelection="['-1':'Seleccione...']"/></td>

            <td id="tdMacro"></td>

            <td id="tdActividad"></td>

            <td id="tdTarea"></td>

        </tr>
    </table>
</div>


<fieldset class="ui-corner-all" style="min-height: 110px;font-size: 11px;">
    <legend>
        Ingreso de datos
    </legend>
    %{--<g:if test="${max}">--}%
    %{--<g:if test="${max?.aprobadoCorrientes==0}">--}%
    <table class="table table-condensed table-bordered table-striped table-hover" style="width: auto;">
        <thead>
        <th style="width: 200px">Responsable</th>
        <th style="width: 220px">Asignación</th>
        <th style="width: 210px;">Partida</th>
        <th style="width: 150px;">Fuente</th>
        <th style="width: 90px;">Presupuesto</th>
        <th style="width: 50px;"></th>
        </thead>
        <tbody>

        <tr class="odd">
            <g:hiddenField name="asignacionId" value=""/>
            <td>
                <g:select name="responsable" from="${vesta.parametros.UnidadEjecutora.list()}" optionKey="id" optionValue="nombre" style="width: 200px" class="many-to-one form-control input-sm"/>
            </td>
            <td class="actividad">
                %{--<textarea style="width: 220px;height: 40px;resize: none;" id="asignacion_txt" maxlength="100" class="form-control input-sm"></textarea>--}%
                <g:textField name="asignacion_name" style="width: 220px; height: 40px" id="asignacion_txt" maxlength="100" class="form-control input-sm"/>

            </td>

            <td class="prsp">
                <bsc:buscador name="partida" id="prsp_id" controlador="asignacion" accion="buscarPresupuesto" tipo="search"
                              titulo="Busque una partida" campos="${campos}" clase="required" style="width:100%;"/>
            </td>
            <td class="fuente">
                <g:select from="${fuentes}" id="fuente" optionKey="id" optionValue="descripcion" name="fuente" class="fuente many-to-one form-control input-sm" value="" style="width: 150px;"/>
            </td>

            <td class="valor">
                <g:textField name="valor_name" id="valor" class="form-control input-sm number money" style="width: 90px" value=""/>

            </td>
            <td style="width: 50px">
                <a href="#" id="btnGuardar" class="btn btn-sm btn-success"><i class="fa fa-plus"></i> Agregar</a>
                <a href="#" id="guardarEditar" class="btn btn-sm btn-success hide" ><i class="fa fa-save"></i> Editar</a>
            </td>
        </tr>

        </tbody>
    </table>

    %{--</g:if>--}%
    %{--<g:else>--}%
    %{--Las asignaciones para este año ya han sido aprobadas--}%
    %{--</g:else>--}%
    %{--</g:if>--}%
    %{--<g:else>--}%
    %{--La unidad ejecutora no tiene asignado presupuesto para este año--}%
    %{--</g:else>--}%
</fieldset>

<fieldset class="ui-corner-all" style="min-height: 100px;font-size: 11px">

    <legend>
        Detalle asignaciones gasto corriente
    </legend>
    <g:set var="total" value="0"/>
    <table class="table table-condensed table-bordered table-striped table-hover" style="width: auto;">
        <thead>
        <th style="width: 300px">Asignación</th>
        <th style="width: 300px;">Partida</th>
        <th style="width: 200px">Fuente</th>
        <th style="width: 150px">Presupuesto</th>
        <th>Acciones</th>
        </thead>
        <tbody id="tdDetalles">

        </tbody>
    </table>
</fieldset>

<script type="text/javascript">

    cargarDetalles();


    function cargarDetalles () {

        $.ajax({
            type    : "POST",
            url     : "${createLink(controller: 'asignacion', action:'tablaDetalles_ajax')}",
            data    : {
                anio : $("#anio").val()
            },
            success : function (msg) {
                $("#tdDetalles").html(msg);
            }
        });
    }

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
    });

    $(function () {

        $("#btnGuardar").click(function () {

            var objetivo = $("#objetivo").val();
            var macro = $("#mac").val();
            var actividad = $("#act").val();
            var tarea = $("#tar").val();
            var anio = $("#anio").val();
            var responsable = $("#responsable").val();
            var asignacion = $("#asignacion_txt").val();
            var parti = $("#prsp_id").val();
            var fuente = $("#fuente").val();
            var valor = $("#valor").val();

            if(tarea && tarea != -1 ){
                if(asignacion != ''){
                    if(parti != null && parti != 'null'){
                        if(fuente != null){
                            if(valor != ''){
                                $.ajax({
                                    type:"POST",
                                    url:"${createLink(action:'guardarAsignacion',controller:'asignacion')}",
                                    data:"anio=" + anio + "&objetivo=" + objetivo + "&macro=" + macro + "&actividad=" + actividad + "&tarea=" + tarea + "&responsable=" + responsable +
                                    "&asignacion=" + asignacion + "&partida=" + parti + "&fuente=" + fuente + "&valor=" + valor,
                                    success:function (msg) {
                                        var parts = msg.split("*");
                                        log(parts[1], parts[0] == "SUCCESS" ? "success" : "error");
                                        if (parts[0] == "SUCCESS") {
                                            setTimeout(function() {
                                                location.reload(true);
                                            }, 1500);
                                        }
                                    }
                                });
                            }else{
                                log("Debe ingresar un valor", "error")
                            }
                        }else{
                            log("Debe seleccionar una fuente", "error")
                        }
                    }else{
                        log("Debe seleccionar una partida", "error")
                    }
                }else{
                    log("Ingrese el nombre de la asignación", "error")
                }
            }else{
                log("Debe seleccionar una tarea", "error")
            }
        });

        $("#guardarEditar").click (function () {

            var responsable = $("#responsable").val();
            var asignacion = $("#asignacion_txt").val();
            var parti = $("#prsp_id").val();
            var fuente = $("#fuente").val();
            var valor = $("#valor").val();
            var asigId = $("#asignacionId").val();

                if(asignacion != ''){
                    if(parti != null && parti != 'null'){
                        if(fuente != null){
                            if(valor != ''){
                                $.ajax({
                                    type:"POST",
                                    url:"${createLink(action:'guardarAsignacion',controller:'asignacion')}",
                                    data:"&responsable=" + responsable +"&asignacion=" + asignacion + "&partida=" + parti + "&fuente=" + fuente + "&valor=" + valor + "&id=" + asigId,
                                    success:function (msg) {
                                        var parts = msg.split("*");
                                        log(parts[1], parts[0] == "SUCCESS" ? "success" : "error");
                                        if (parts[0] == "SUCCESS") {
                                            setTimeout(function() {
                                                location.reload(true);
                                            }, 1500);
                                        }
                                    }
                                });
                            }else{
                                log("Debe ingresar un valor", "error")
                            }
                        }else{
                            log("Debe seleccionar una fuente", "error")
                        }
                    }else{
                        log("Debe seleccionar una partida", "error")
                    }
                }else{
                    log("Ingrese el nombre de la asignación", "error")
                }

        });

    });
</script>

</body>
</html>