<%--
  Created by IntelliJ IDEA.
  User: fabricio
  Date: 17/03/15
  Time: 12:18 PM
--%>

<div style="margin-bottom: 10px">
    <b>Unidad:</b><g:select from="${vesta.parametros.UnidadEjecutora.list([sort:'nombre'])}" optionKey="id" optionValue="nombre" name="unidad" id="unidadAsg" noSelection="['-1':'Todas']"/><br><br>
    <b>Partida:</b>  <input type="hidden" class="prsp" value="${asignacionInstance?.presupuesto?.id}" id="prsp2" name="presupuesto.id">

    <g:textField name="prsp" id="prsp_desc2" desc="desc2" style="width: 100px; text-align: center"/>
    %{--<input type="text" id="prsp_desc2" desc="desc2" style="width: 100px;border: 1px solid black;text-align: center" class="buscar ui-corner-all">--}%

    <span style="font-size: smaller;">Haga clic para consultar</span><br>
</div>
%{--<a href="#" class="btn" id="btn_buscarAsg">Buscar</a>--}%
<div id="resultadoAsg" style="width: 450px;margin-top: 10px;" class="ui-corner-all"></div>

<script type="text/javascript">


$("#prsp_desc2").click(function () {

//            $("#buscarAsg_dlg").dialog("open")
        $.ajax({
            type: "POST",
            url: "${createLink(controller:"modificacion", action: "buscarPartida_ajax")}",
            data: {
                id: ""
            },
            success: function (msg){
                bootbox.dialog ({
                    id: "dlgBuscarPartida",
                    title: "Buscar Partidas",
//                        class: "modal-lg",
                    message: msg,
                    buttons : {
                        cancelar : {
                            label     : "Cancelar",
                            className : "btn-primary",
                            callback  : function () {
                            }
                        },
                        guardar  : {
                            id        : "btnSave",
                            label     : "Buscar",
                            className : "btn-success",
                            callback  : function () {

                                    $.ajax({
                                        type:"POST",
                                        url:"${createLink(action:'buscarPresupuesto_ajax',controller:'asignacion')}",
                                        data:"parametro=" + $("#par").val() + "&tipo=" + $("#tipo").val(),
                                        success:function (msg) {
                                            $("#resultado").html(msg)
                                        }
                                    });

                            } //callback
                        } //guardar
                    }
                })
            }
        });
    });

</script>