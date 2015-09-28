<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 07/04/15
  Time: 01:15 PM
--%>

<script type="text/javascript" src="${resource(dir: 'js', file: 'ui.js')}"></script>
<script type="text/javascript" src="${resource(dir: 'js/plugins/bootstrap-select-1.6.3/dist/js', file: 'bootstrap-select.js')}"></script>
<link href="${resource(dir: 'js/plugins/bootstrap-select-1.6.3/dist/css', file: 'bootstrap-select.min.css')}" rel="stylesheet">
<g:select from="${acts}" optionKey="id" id="actividadRf" name="actividad_name" optionValue='${{
    "" + it.numero + " - " + it.objeto
}}' noSelection="['-1': 'Seleccione']" class="form-control input-sm required requiredCombo"/>
<script type="text/javascript">
    $('#actividadRf').change(function () {
        $("#${div?:'divAsg'}").html(spinner);
        console.log('actividad++++')

        $.ajax({
            type    : "POST",
            url     : "${createLink(action:'cargarAsignaciones_ajax',controller: 'avales')}",
            data    : {
                id   : $("#actividadRf").val(),
                anio : $("#anio").val()
            },
            success : function (msg) {
                $("#${div?:'divAsg'}").html(msg);
                $("#max").html("").data("max", 0);
            }
        });
    })
</script>