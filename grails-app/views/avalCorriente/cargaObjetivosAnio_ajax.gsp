<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 25/06/15
  Time: 01:21 PM
--%>

<g:select name="objetivo" from="${objetivos}" optionKey="id" optionValue="descripcion" class="form-control" noSelection="['': '- Seleccione -']"/>

<script type="text/javascript">
    $("#objetivo").change(function () {
        $("#tdMacro").html(spinner);
        $.ajax({
            type    : "POST",
            url     : "${createLink(controller: 'asignacion', action:'macro_ajax')}",
            data    : {
                objetivo     : $(this).val(),
                copiar       : "${params.copiar}",
                asignaciones : "${params.asignaciones}"
            },
            success : function (msg) {
                $("#tdMacro").html(msg);
                $("#tdActividad").html("");
                $("#tdTarea").html("");
                $("#tdAsignacion").html("");
                $("#max").html("");

                $("#actividadesDisponibles").html("");
                $("#actividadesActuales").html("");
            }
        });
    });
</script>