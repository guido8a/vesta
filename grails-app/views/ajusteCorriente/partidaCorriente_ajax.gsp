<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 05/04/16
  Time: 11:56 AM
--%>

<form id="frmPartida">
    <div class="row">
        <div class="col-md-2">
            <label>Objetivo del gasto permanente:</label>
        </div>
        <div  class="col-md-8">
            <g:select from="${objetivos}" optionKey="id" optionValue="descripcion" name="objetivo" class="form-control input-sm required requiredCombo selectpicker"
                      noSelection="['-1': 'Seleccione...']"/>
        </div>
    </div>

    <div class="row">
        <div class="col-md-2">
            <label>Macro Actividad:</label>
        </div>
        <div  class="col-md-8" id="divMacro">

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
            <label>Tarea:</label>
        </div>
        <div  class="col-md-5" id="divTarea">

        </div>
    </div>


    <div class="row">
        <div class="col-md-2">
            <label>Partida</label>
        </div>

        <div class="col-md-4">
            <g:hiddenField name="partidaHide" id="prsp_hide" value="${detalle?.presupuesto?.id}"/>
            <g:textField name="partida" id="prsp_id" class="fuente many-to-one form-control input-sm required" value="${detalle ? (detalle?.presupuesto?.numero + " - " + detalle?.presupuesto?.descripcion) : " "}"/>
        </div>


        <div class="col-md-1">
            <label>Fuente</label>
        </div>

        <div class="col-md-4">
            <g:select from="${vesta.parametros.poaPac.Fuente.list()}" optionKey="id" optionValue="descripcion"
                      name="fuente" class="form-control input-sm required requiredCmb" value="${detalle?.fuente?.id}"/>
        </div>


    </div>

    <div class="row">

        <div class="col-md-2">
            <label for="monto">Monto a aumentar</label>
        </div>

        <div class="col-md-3">
            <div class="input-group">
                <g:textField type="text" name="monto"
                             class="form-control required input-sm number money" value="${detalle?.valor}"/>
                <span class="input-group-addon"><i class="fa fa-usd"></i></span>
            </div>
        </div>
    </div>

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

    $("#objetivo").val("-1").change(function () {
        $.ajax({
            type    : "POST",
            url     : "${createLink(controller: 'reformaPermanente', action:'macro_ajax')}",
            data    : {
                objetivo : $(this).val(),
                width    : "140px"
            },
            success : function (msg) {
                $("#divMacro").html(msg);
                $("#divAct").html("");
                $("#divTarea").html("");
                $("#divAsg").html("");
                $("#max").html("");
            }
        });
    });

    <g:if test="${detalle}">
    $("#objetivo").val("${detalle?.objetivoGastoCorriente?.id}").change();
    setTimeout(function () {
        $("#mac").val("${detalle?.macroActividad?.id}").change();
        setTimeout(function () {
            $("#act").val("${vesta.poaCorrientes.Tarea.get(detalle?.tarea).actividad.id}").change();
            setTimeout(function () {
                $("#tar").val("${vesta.poaCorrientes.Tarea.get(detalle?.tarea).id}").change();
                setTimeout(function () {
                    $("#asg").val("${detalle?.asignacionOrigenId}").change();
                }, 500);
            }, 500);
        }, 500);
    }, 500);
    </g:if>

</script>