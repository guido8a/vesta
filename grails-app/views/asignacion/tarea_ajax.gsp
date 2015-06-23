<%--
  Created by IntelliJ IDEA.
  User: fabricio
  Date: 23/06/15
  Time: 12:06 PM
--%>

<g:select from="${tareas}" optionValue="descripcion" optionKey="id" id="tar${params.mod}" name="tar_name${params.mod}" noSelection="['-1': 'Seleccione...']"
          style="width: 100%" class="form-control input-sm"/>

<script>
    $("#tar${params.mod}").change(function () {
        $("#tdAsignacion${params.mod}").html(spinner);
        $.ajax({
            type    : "POST",
            url     : "${createLink(action:'asignacion_ajax',controller: 'asignacion')}",
            data    : {
                id   : $(this).val(),
                mod:"${params.mod}"
            },
            success : function (msg) {
                $("#tdAsignacion${params.mod}").html(msg);
            }
        });
    })

</script>