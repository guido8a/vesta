<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 22/10/15
  Time: 11:58 AM
--%>

<%--
  Created by IntelliJ IDEA.
  User: fabricio
  Date: 23/06/15
  Time: 12:03 PM
--%>

<g:select from="${actividades}" optionValue="descripcion" optionKey="id" name="act${params.mod}" noSelection="['-1': 'Seleccione...']"
          style="width: 100%" class="form-control input-sm selectpicker" value="${valor}"/>

<script>

    $("#act${params.mod}").change(function () {

        $("#tdTarea${params.mod}").html(spinner);
        $.ajax({
            type    : "POST",
            url     : "${createLink(action:'tarea_ajax',controller: 'reformaPermanente')}",
            data    : {
                id    : $(this).val(),
                mod   : "${params.mod}",
                width : "${params.width}"
            },
            success : function (msg) {

                $("#divTarea${params.mod}").html(msg);
                $("#divAsg${params.mod}").html("");
                $("#max${params.mod}").html("");
            }
        });
    })

</script>