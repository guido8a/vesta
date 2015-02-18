<g:select name="asg" from="${asgs}" optionKey="id" id="asignacion_dest" optionValue='${{
    "Responsable: " + it.unidad + " Partida: " + it.presupuesto.numero + " Monto: " + g.formatNumber(number: it.priorizado, type: "currency")
}}' style="width: 100%" noSelection="['-1': 'Seleccione..']"
class="form-control input-sm"
></g:select>
<script>
    $("#asignacion_dest").change(function () {

    })
</script>