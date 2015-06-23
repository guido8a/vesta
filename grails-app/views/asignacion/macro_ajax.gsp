<%--
  Created by IntelliJ IDEA.
  User: fabricio
  Date: 22/06/15
  Time: 03:30 PM
--%>

<g:select from="${macro}" optionValue="descripcion" optionKey="id" id="mac" name="mac_name" noSelection="['-1': 'Seleccione...']"
          style="width: 100%" class="form-control input-sm"/>

<script>
    $("#mac").change(function () {
        $("#tdActividad").html(spinner);
        $.ajax({
            type    : "POST",
            url     : "${createLink(action:'actividad_ajax',controller: 'asignacion')}",
            data    : {
                id   : $(this).val(),
                anio : $("#anio").val()
            },
            success : function (msg) {
                $("#tdActividad").html(msg);
                $("#tdTarea").html("");
            }
        });
    })

</script>