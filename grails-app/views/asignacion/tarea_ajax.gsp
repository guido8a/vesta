<%--
  Created by IntelliJ IDEA.
  User: fabricio
  Date: 23/06/15
  Time: 12:06 PM
--%>

<g:select from="${tareas}" optionValue="descripcion" optionKey="id" name="tar${params.mod}" noSelection="['-1': 'Seleccione...']"
          style="width: 100%" class="form-control input-sm" value="${valor}"/>

<script>

    $("#tar${params.mod}").change(function () {
       $("#tdAsignacion${params.mod}").html(spinner);


        if($("#tar").val() != -1){
            $("#editarTarea").removeClass('hide').addClass('show');
            $("#crearTarea").removeClass('show').addClass('hide');
        }else{
            $("#crearTarea").removeClass('hide').addClass('show');
            $("#editarTarea").removeClass('show').addClass('hide');
        }

        var tareaValor = $(".tar").val();

        console.log(tareaValor)

        $.ajax({
            type    : "POST",
            url     : "${createLink(action:'asignacion_ajax',controller: 'asignacion')}",
            data    : {
                id  : $(this).val(),
                mod : "${params.mod}"
            },
            success : function (msg) {
                $("#tdAsignacion${params.mod}").html(msg);
                $("#max${params.mod}").html("");

            }
        });
    })

</script>