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
                width : "${params.width}",
                tipo: '${incremento}'
            },
            success : function (msg) {

                $("#divTarea").html(msg);
                $("#divAsg").html("");
                $("#max").html("");
            }
        });
    })

</script>