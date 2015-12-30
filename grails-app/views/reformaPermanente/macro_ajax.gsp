<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 22/10/15
  Time: 11:19 AM
--%>

<%--
  Created by IntelliJ IDEA.
  User: fabricio
  Date: 22/06/15
  Time: 03:30 PM
--%>

<g:select from="${macro}" optionValue="descripcion" optionKey="id" name="mac${params.mod}" noSelection="['-1': 'Seleccione...']"
          style="width: 100%" class="form-control input-sm selectpicker" value="${valor}"/>

<script>
    %{--$('.selectpicker').selectpicker({--}%
        %{--width           : "${params.width?:'350px'}",--}%
        %{--limitWidth      : true,--}%
        %{--style           : "btn-sm",--}%
        %{--backgroundColor : 'red'--}%
    %{--});--}%

    $("#mac${params.mod}").change(function () {

        $.ajax({
            type    : "POST",
            async   : false,
            url     : "${createLink(action:'actividad_ajax',controller: 'reformaPermanente')}",
            data    : {
                id    : $(this).val(),
                anio  : $("#anio").val(),
                mod   : "${params.mod}",
                width : "${params.width}"
            },
            success : function (msg) {
                $("#divAct${params.mod}").html(msg);
                $("#divTarea${params.mod}").html("");
                $("#divAsg${params.mod}").html("");
                $("#max${params.mod}").html("");

            }
        });

    })

</script>