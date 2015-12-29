<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 28/12/15
  Time: 11:23 AM
--%>

<%@ page import="vesta.parametros.poaPac.Fuente; vesta.proyectos.Categoria" %>
<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 07/12/15
  Time: 10:51 AM
--%>
<form id="frmNuevaActividad">
    <div class="row">
        <div class="col-md-2">
            <label>Proyecto</label>
        </div>

        <div class="col-md-8 grupo">
            <g:select from="${proyectos}" optionKey="id" optionValue="nombre" name="proyecto_dest" id="proyectoDest" style="width:100%"
                      class="form-control required requiredCombo input-sm" noSelection="['-1': 'Seleccione...']"/>
        </div>
    </div>

    <div class="row">

        <div class="col-md-2">
            <label>Componente</label>
        </div>

        <div class="col-md-8 grupo" id="divComp_dest">

        </div>
    </div>

    <div class="row">
        <div class="col-md-2">
            <label for="actividad_dest">Actividad</label>
        </div>

        <div class="col-md-8 grupo">
            <g:textField name="actividad_dest" class="form-control input-sm required" value="${detalle?.descripcionNuevaActividad}"/>
        </div>
    </div>

    <div class="row">
        <div class="col-md-2">
            <label>Partida</label>
        </div>

        <div class="col-md-4">
            <g:hiddenField name="partidaHide" id="prsp_hide" value="${detalle?.presupuesto?.id}" />
            <g:textField name="partida" id="prsp_id" class="fuente many-to-one form-control input-sm required" value="${detalle ? (detalle?.presupuesto?.numero + " - " + detalle?.presupuesto?.descripcion) : " "}"/>
        </div>
    </div>

    <div class="row">

        <div class="col-md-2">
            <label>Fuente</label>
        </div>

        <div class="col-md-4">
            <g:select from="${vesta.parametros.poaPac.Fuente.list()}" optionKey="id" optionValue="descripcion"
                      name="fuente" class="form-control input-sm required requiredCmb" value="${detalle?.fuente?.id}"/>
        </div>


        <div class="col-md-1">
            <label>Categoría</label>
        </div>

        <div class="col-md-3">
            <g:select from="${vesta.proyectos.Categoria.list([sort: 'descripcion'])}" optionKey="id" optionValue="descripcion" name="categoria"
                      class="form-control required requiredCombo input-sm" noSelection="['': 'Seleccione...']" value="${detalle?.categoria?.id}"/>
        </div>

    </div>

    <div class="row">
        <div class="col-md-2">
            <label>Fecha Incio</label>
        </div>

        <div class="col-md-2 grupo">
            <elm:datepicker class="form-control input-sm fechaInicio required"
                            name="fechaInicio"
                            title="Fecha de inicio de la actividad"
                            id="inicio" value="${detalle?.fechaInicioNuevaActividad?.format("dd-MM-yyyy")}"/>

        </div>

        <div class="col-md-1">
            <label>Fecha Fin</label>
        </div>

        <div class="col-md-2 grupo">
            <elm:datepicker class="form-control input-sm fechaFin required"
                            name="fechaFin"
                            title="Fecha fin de la actividad"
                            id="fin"
                            format="dd-MM-yyyy" value="${detalle?.fechaFinNuevaActividad?.format("dd-MM-yyyy")}"/>
        </div>

        <div class="col-md-1">
            <label>Monto</label>
        </div>

        <div class="col-md-2">
            <div class="input-group">
                <g:textField type="text" name="monto" class="form-control required input-sm number money" value="${detalle?.valor}"/>
                <span class="input-group-addon"><i class="fa fa-usd"></i></span>
            </div>
        </div>

    </div>

    %{--<div class="row">--}%

        %{--<div class="col-md-2">--}%
            %{--<label>Reponsable</label>--}%
        %{--</div>--}%

        %{--<div class="col-md-4 grupo">--}%
            %{--<g:select from="${gerencias}" name="responsable" optionKey="id" optionValue="codigo"--}%
                      %{--class="form-control required requiredCombo input-sm" noSelection="['': 'Seleccione...']" value="${detalle?.responsable?.id}"/>--}%
        %{--</div>--}%

    %{--</div>--}%
</form>

<script type="text/javascript">

    $("#prsp_id").click(function(){

        $.ajax({type : "POST", url : "${g.createLink(controller: 'asignacion',action:'buscadorPartidasFiltradas')}",
            data     : {

            },
            success  : function (msg) {
                var b = bootbox.dialog({
                    id: "dlgPartidas",
                    title: "Buscador Partidas",
                    class   : "modal-lg",
                    message: msg,
                    buttons : {
                        cancelar : {
                            label : "Cancelar",
                            className : "btn-primary",
                            callback  : function () {
                            }
                        }
                    }
                })
            }
        });
    });

    function getMaximo(asg) {
        if ($("#asignacion").val() != "-1") {
            $.ajax({
                type    : "POST",
                url     : "${createLink(action:'getMaximoAsg',controller: 'avales')}",
                data    : {
                    id : asg
                },
                success : function (msg) {
                    var valor = parseFloat(msg);
//                            console.log("valor=", valor);
                    var tot = 0;
                    $(".tableReformaNueva").each(function () {
                        var d = $(this).data();
                        if ("" + d.origen.asignacion_id == "" + asg) {
                            tot += parseFloat(d.origen.monto);
                        }
                    });
                    var ok = valor - tot;

                    $("#max").html("$" + number_format(ok, 2, ".", ","))
                            .attr("valor", ok);
                    $("#monto").attr("tdnMax", ok);
                }
            });
        }
    }


    $("#proyectoDest").change(function () {
        $("#divComp_dest").html(spinner);
        $.ajax({
            type    : "POST",
            url     : "${createLink(controller: 'modificacionesPoa', action:'componentesProyectoAjuste2_ajax')}",
            data    : {
                id      : $("#proyectoDest").val(),
                anio    : $("#anio").val(),
                idCombo : "compDest",
                div     : "divAct_dest"
            },
            success : function (msg) {
                $("#divComp_dest").html(msg);
                $("#divAct_dest").html("");
                $("#divAsg_dest").html("");
            }
        });
    });


    <g:if test="${detalle}">
    $("#proyectoDest").val("${detalle?.componente?.proyecto?.id}").change();
    setTimeout(function () {
        $("#compDest").val("${detalle?.componente?.id}").change();
    }, 500);
    </g:if>



</script>