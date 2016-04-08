<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 08/04/16
  Time: 11:29 AM
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
    $('.selectpicker').selectpicker({
        width           : "${params.width?:'350px'}",
        limitWidth      : true,
        style           : "btn-sm",
        backgroundColor : 'red'
    });

    $("#mac${params.mod}").change(function () {

        $("#tdActividad${params.mod}").html(spinner);
        cargarActividadesAnio();

    })

</script>