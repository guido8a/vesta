<%--
  Created by IntelliJ IDEA.
  User: fabricio
  Date: 23/06/15
  Time: 12:03 PM
--%>

<g:select from="${actividades}" optionValue="descripcion" optionKey="id" name="act${params.mod}" noSelection="['-1': 'Seleccione...']"
          style="width: 100%" class="form-control input-sm" value="${valor}"/>

<script>
    $("#act${params.mod}").change(function () {
        $("#crearTarea").addClass('show');
        $("#crearActividad").addClass('show');
        $("#tdTarea${params.mod}").html(spinner);
        $.ajax({
            type    : "POST",
            url     : "${createLink(action:'tarea_ajax',controller: 'asignacion')}",
            data    : {
                id   : $(this).val(),
                mod: "${params.mod}"
            },
            success : function (msg) {

                $("#tdTarea${params.mod}").html(msg);
                $("#tdAsignacion${params.mod}").html("");
                $("#max${params.mod}").html("");
            }
        });
    })

</script>