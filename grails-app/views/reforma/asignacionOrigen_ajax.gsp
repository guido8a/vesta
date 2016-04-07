<%@ page import="vesta.poa.Asignacion" %>
<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 03/12/15
  Time: 11:47 AM
--%>

%{--//origen--}%
<form id="frmAsignacion">
    <div class="row">
        <div class="col-md-2">
            <label>Proyecto: </label>
        </div>
        <div  class="col-md-8">
            <g:select from="${proyectos}" optionKey="id" optionValue="nombre" name="proyecto" class="form-control input-sm required requiredCombo"
                      noSelection="['-1': 'Seleccione...']"/>

        </div>
    </div>

    <div class="row">
        <div class="col-md-2">
            <label>Componente:</label>
        </div>
        <div  class="col-md-8" id="divComp">

        </div>
    </div>

    <div class="row">
        <div class="col-md-2">
            <label>Actividad:</label>
        </div>
        <div  class="col-md-8" id="divAct">

        </div>
    </div>

    <div class="row">
        <div class="col-md-2">
            <label>Asignación:</label>
        </div>
        <div  class="col-md-5" id="divAsg">

        </div>
    </div>

    <div class="row">
        <div class="col-md-2">
            <label>Monto:</label>
        </div>

        <div  class="col-md-5">
            <div class="input-group">
                <g:textField type="text" name="monto" style="float: right" class="form-control required input-sm number money" value="${detalle?.valor}"/>
                <span class="input-group-addon"><i class="fa fa-usd"></i></span>
            </div>
        </div>

        <div class="col-md-2">
            <label>Saldo:</label>
        </div>

        <div id="max">

        </div>
    </div>
</form>

<script type="text/javascript">

    $("#proyecto").change(function () {
        $("#divComp").html(spinner);
        $.ajax({
            type    : "POST",
            url     : "${createLink(controller: 'modificacionesPoa', action:'componentesProyectoAjuste_ajax')}",
            data    : {
                id   : $("#proyecto").val(),
//                anio : $("#anio").val()
                anio : ${anio?.id}
            },
            success : function (msg) {
                $("#divComp").html(msg);
                $("#divAct").html("");
                $("#divAsg").html("");
            }
        });
    });

    <g:if test="${detalle}">
    $("#proyecto").val("${detalle?.componente?.proyecto?.id}").change();
    setTimeout(function () {
        $("#comp").val("${detalle?.componente?.id}").change();
        setTimeout(function () {
            $("#actividadRf").val("${ detalle?.asignacionOrigen?.marcoLogicoId}").change();
            setTimeout(function () {
                $("#asignacion").val("${detalle?.asignacionOrigenId}").change();
            }, 500);
        }, 500);
    }, 500);
    </g:if>

    function getMaximo(asg) {
        if ($("#asignacion").val() != "-1") {
            $.ajax({
                type    : "POST",
                url     : "${createLink(action:'getMaximoAsg', controller: 'avales')}",
                data    : {
                    id : asg
                },
                success : function (msg) {
                    var valor = parseFloat(msg);
//                    console.log("valor " + valor)
                    var tot = 0;
                    $(".tableReformaNueva").each(function () {

                        var d = $(this).children().children().data("cod")
                        var parId = $(this).children().children().data("par")
                        var valorP = $(this).children().children().data("val")
//                        if(d == 'O'){
//                            if(parId == asg){
//                            tot += parseFloat(valorP)
//                            }
//                        }
                    });
//                    console.log("total " + tot)
                    var ok = valor - tot;
                    $("#max").html("$" + number_format(ok, 2, ".", ","))
                            .attr("valor", ok);
                    $("#monto").attr("tdnMax", ok);
                }
            });
        }
    }


    $("#frmAsignacion").validate({
        errorClass: "help-block",
        onfocusout: false,
        errorPlacement: function (error, element) {
            if (element.parent().hasClass("input-group")) {
                error.insertAfter(element.parent());
            } else {
                error.insertAfter(element);
            }
            element.parents(".grupo").addClass('has-error');
        },
        success: function (label) {
            label.parents(".grupo").removeClass('has-error');
            label.remove();
        }
    });



</script>