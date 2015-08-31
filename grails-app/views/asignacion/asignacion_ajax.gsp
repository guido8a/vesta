<g:select from="${asignaciones}" optionKey="id" name="asg${params.mod}" noSelection="['-1': 'Seleccione...']"
          optionValue='${{
              (it.presupuesto.numero + " " + it.presupuesto.descripcion) + " Monto: " +
              g.formatNumber(number: it.priorizado, type: "currency", currencySymbol: " ")
          }}'
          style="width: 100%" class="form-control input-sm selectpicker"/>

<script>

    $('.selectpicker').selectpicker({
        width      : "${params.width?:'350px'}",
        limitWidth : true,
        style      : "btn-sm"
    });

    $("#asg${params.mod}").change(function () {
        $("#max${params.mod}").html(spinner);
        getMaximo($(this).val(), "${params.mod}");
    })

</script>