<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 08/04/16
  Time: 11:28 AM
--%>

<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 25/06/15
  Time: 01:21 PM
--%>

<g:select name="objetivo" from="${objetivos}" optionKey="id" optionValue="descripcion" class="form-control selectpicker" noSelection="['': '- Seleccione -']"/>

<script type="text/javascript">
    $('.selectpicker').selectpicker({
        width      : "${params.width?:'350px'}",
        limitWidth : true,
        style      : "btn-sm"
    });

    $("#objetivo").change(function () {
        var ob = $(this).val();
        $("#tdMacro").html(spinner);
        $.ajax({
            type    : "POST",
            url     : "${createLink(controller: 'poaCorriente', action:'cargarMacro_ajax')}",
            data    : {
                objetivo     : ob,
                asignaciones : "${params.asignaciones}",
                width        : "${params.width}"
            },
            success : function (msg) {
                $("#tdMacro").html(msg);
                $("#tdActividad").html("");
                $("#tdTarea").html("");
                $("#actividadesDisponibles").html("");
            }
        });
    });
</script>