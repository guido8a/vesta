<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 23/06/15
  Time: 12:39 PM
--%>

<g:select from="${asignaciones}" optionKey="id" name="asg${params.mod}" noSelection="['-1': 'Seleccione...']"
          optionValue='${{
              (it.actividad ? ("Asignación: " + it.actividad + ", ") : "") + "Monto: " + g.formatNumber(number: it.priorizado, type: "currency", currencySymbol: " ") + ", Partida: " + it.presupuesto.numero + ", Fuente: " + it.fuente.codigo
          }}'
          style="width: 100%" class="form-control input-sm"/>

<script>
    $("#asg${params.mod}").change(function () {
        $("#max${params.mod}").html(spinner);
        getMaximo($(this).val(), "${params.mod}");
    })

</script>