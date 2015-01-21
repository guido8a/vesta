<%--
  Created by IntelliJ IDEA.
  User: fabricio
  Date: 20/01/15
  Time: 03:57 PM
--%>

<script type="text/javascript" src="${resource(dir: 'js', file: 'ui.js')}"></script>
<script type="text/javascript" src="${resource(dir: 'js/plugins/bootstrap-select-1.6.3/dist/js', file: 'bootstrap-select.js')}"></script>
<link href="${resource(dir: 'js/plugins/bootstrap-select-1.6.3/dist/css', file: 'bootstrap-select.min.css')}" rel="stylesheet">

<g:select name="asg" from="${asgs}" optionKey="id" id="asignacion" optionValue='${{
    "<b>Responsable:</b> " + it.unidad + " <b>Partida:</b> " + it.presupuesto.numero + " <b>Monto:</b> " + g.formatNumber(number: it.priorizado, type: "currency")
}}' style="width: 100%" noSelection="['-1': 'Seleccione..']" class="form-control input-sm"/>
<script>
    $("#asignacion").change(function () {
        getMaximo($("#asignacion").val())
    }).selectpicker({
        width      : "200px",
        limitWidth : true,
        style      : "btn-sm"
    });
</script>