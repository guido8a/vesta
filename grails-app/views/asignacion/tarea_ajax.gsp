<%--
  Created by IntelliJ IDEA.
  User: fabricio
  Date: 23/06/15
  Time: 12:06 PM
--%>

<g:select from="${tareas}" optionValue="descripcion" optionKey="id" id="tar" name="tar_name" noSelection="['-1': 'Seleccione...']"
          style="width: 100%" class="form-control input-sm"/>

<script>
    $("#tar").change(function () {
        $("#tdAsignacion").html(spinner);
        $.ajax({
            type    : "POST",
            url     : "${createLink(action:'asignacion_ajax',controller: 'asignacion')}",
            data    : {
                id   : $(this).val()
            },
            success : function (msg) {
                $("#tdAsignacion").html(msg);
            }
        });
    })

</script>