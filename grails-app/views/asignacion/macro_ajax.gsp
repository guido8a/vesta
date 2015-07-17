<%--
  Created by IntelliJ IDEA.
  User: fabricio
  Date: 22/06/15
  Time: 03:30 PM
--%>

<g:select from="${macro}" optionValue="descripcion" optionKey="id" name="mac${params.mod}" noSelection="['-1': 'Seleccione...']"
          style="width: 100%" class="form-control input-sm" value="${valor}"/>

<script>
    $("#mac${params.mod}").change(function () {

        $("#tdActividad${params.mod}").html(spinner);
        <g:if test="${params.copiar == 'S'}">
        cargarActividadesAnio();
        cargarActividadesCopiadas();
        </g:if>
        <g:else>
        <g:if test="${params.asignaciones == 'S'}">
        cargarActividadesTareas($("#mac").val());
        </g:if>
        $.ajax({
            type    : "POST",
            url     : "${createLink(action:'actividad_ajax',controller: 'asignacion')}",
            data    : {
                id   : $(this).val(),
                anio : $("#anio").val(),
                mod  : "${params.mod}"
            },
            success : function (msg) {
                $("#tdActividad${params.mod}").html(msg);
                $("#tdTarea${params.mod}").html("");
                $("#tdAsignacion${params.mod}").html("");
                $("#max${params.mod}").html("");
                $("#crearTarea").removeClass('show').addClass('hide');
                $("#divColor1").removeClass("show").addClass("hide");
            }
        });
        </g:else>
    })

</script>