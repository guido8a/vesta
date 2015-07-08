<%--
  Created by IntelliJ IDEA.
  User: fabricio
  Date: 01/07/15
  Time: 11:44 AM
--%>

<g:select from="${macro}" optionValue="descripcion" optionKey="id" name="mac${params.mod}" noSelection="['-1': 'Seleccione...']"
          style="width: 100%" class="form-control input-sm" id="macroCrear"/>

<script>




$("#macroCrear").change(function (){
    var idMacro = $("#macroCrear").val()

    if(idMacro != -1 ||  idMacro!= '-1'){
        $.ajax({
            type    : "POST",
            url     : "${createLink(controller: 'asignacion', action:'actividadCreacion_ajax')}",
            data    : {
                objetivo : $("#objetivo_creacion").val(),
                macro: idMacro
            },
            success : function (msg) {
                $("#tdActividadCreacion").html(msg);

            }
        });
    }

});

</script>