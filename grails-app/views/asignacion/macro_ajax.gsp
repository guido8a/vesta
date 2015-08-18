<%--
  Created by IntelliJ IDEA.
  User: fabricio
  Date: 22/06/15
  Time: 03:30 PM
--%>

<g:select from="${macro}" optionValue="descripcion" optionKey="id" name="mac${params.mod}" noSelection="['-1': 'Seleccione...']"
          style="width: 100%" class="form-control input-sm selectpicker" value="${valor}"/>

<script>
    $('.selectpicker').selectpicker({
        width      : "${params.width?:'350px'}",
        limitWidth : true,
        style      : "btn-sm",
        backgroundColor: 'red'
    });

    $("#mac${params.mod}").change(function () {

        $("#divColor1").removeClass("show").addClass("hide");

        $("#tdActividad${params.mod}").html(spinner);
        <g:if test="${params.copiar == 'S'}">
        cargarActividadesAnio();
        cargarActividadesCopiadas();
        $("#divColor1").removeClass("show").addClass("hide");
        </g:if>
        <g:else>
        <g:if test="${params.asignaciones == 'S'}">
        cargarActividadesTareas($("#mac").val(), true);
        $("#divColor1").removeClass("show").addClass("hide");
        </g:if>
//        console.log("-->")
        $.ajax({
            type    : "POST",
async: false,
            url     : "${createLink(action:'actividad_ajax',controller: 'asignacion')}",
            data    : {
                id   : $(this).val(),
                anio : $("#anio").val(),
                mod  : "${params.mod}"
            },
            success : function (msg) {
//                console.log("success -->", msg)
                $("#divColor1").removeClass("show").addClass("hide");
                $("#tdActividad${params.mod}").html(msg);
                $("#tdTarea${params.mod}").html("");
                $("#tdAsignacion${params.mod}").html("");
                $("#max${params.mod}").html("");
                $("#crearTarea").removeClass('show').addClass('hide');

                $("#editarActividad").removeClass('show').addClass('hide');
            }
        });
        </g:else>
    })

</script>