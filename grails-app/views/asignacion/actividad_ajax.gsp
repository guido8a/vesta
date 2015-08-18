<%--
  Created by IntelliJ IDEA.
  User: fabricio
  Date: 23/06/15
  Time: 12:03 PM
--%>

<g:select from="${actividades}" optionValue="descripcion" optionKey="id" name="act${params.mod}" noSelection="['-1': 'Seleccione...']"
          style="width: 100%" class="form-control input-sm selectpicker" value="${valor}"/>

<script>
    $('.selectpicker').selectpicker({
        width      : "350px",
        limitWidth : true,
        style      : "btn-sm"
    });

    $("#act${params.mod}").change(function () {
        if($("#act").val() != -1){
            $("#editarActividad").removeClass('hide').addClass('show');
            $("#crearActividad").removeClass('show').addClass('hide');
        }else{
            $("#crearActividad").removeClass('hide').addClass('show');
            $("#editarActividad").removeClass('show').addClass('hide');
        }
        $("#crearTarea").addClass('show');

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
                $("#editarTarea").removeClass('show').addClass('hide');
             }
        });
    })

</script>