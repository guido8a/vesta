<%--
  Created by IntelliJ IDEA.
  User: fabricio
  Date: 23/06/15
  Time: 12:03 PM
--%>

<g:select from="${actividades}" optionValue="descripcion" optionKey="id" id="act" name="act_name" noSelection="['-1': 'Seleccione...']"
          style="width: 100%" class="form-control input-sm"/>

<script>
    $("#act").change(function () {
        $("#tdTarea").html(spinner);
        $.ajax({
            type    : "POST",
            url     : "${createLink(action:'tarea_ajax',controller: 'asignacion')}",
            data    : {
                id   : $(this).val()
            },
            success : function (msg) {
                $("#tdTarea").html(msg);
                $("#tdAsignacion").html("");
            }
        });
    })

</script>