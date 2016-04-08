<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 30/12/15
  Time: 11:22 AM
--%>

<%--
  Created by IntelliJ IDEA.
  User: fabricio
  Date: 23/06/15
  Time: 12:06 PM
--%>

<g:select from="${tareas}" optionValue="descripcion" optionKey="id" name="tar${params.mod}" noSelection="['-1': 'Seleccione...']"
          style="width: 100%" class="form-control input-sm selectpicker" value="${valor}"/>

<script>


    $("#tar${params.mod}").change(function () {

        $.ajax({
            type    : "POST",
            url     : "${createLink(action:'asignacion_ajax',controller: 'reformaPermanente')}",
            data    : {
                id    : $(this).val(),
                mod   : "${params.mod}",
                width : "${params.width}",
                tipo: '${incremento}'
            },
            success : function (msg) {
                $("#divAsg${params.mod}").html(msg);
                $("#max${params.mod}").html("");

            }
        });
    })

</script>