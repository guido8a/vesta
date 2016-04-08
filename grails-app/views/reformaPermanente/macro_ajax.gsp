<g:select from="${macro}" optionValue="descripcion" optionKey="id" name="mac" noSelection="['-1': 'Seleccione...']"
          style="width: 100%" class="form-control input-sm selectpicker" value="${valor}"/>

<script>

    $("#mac").change(function () {

        $.ajax({
            type    : "POST",
            async   : false,
            url     : "${createLink(action:'actividad_ajax',controller: 'reformaPermanente')}",
            data    : {
                id    : $(this).val(),
                anio  : $("#anio").val(),
                mod   : "${params.mod}",
                width : "${params.width}",
                tipo: '${incremento}'
            },
            success : function (msg) {
                $("#divAct").html(msg);
                $("#divTarea${params.mod}").html("");
                $("#divAsg${params.mod}").html("");
                $("#max${params.mod}").html("");

            }
        });

    })

</script>