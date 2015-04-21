<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 07/04/15
  Time: 01:30 PM
--%>
<script type="text/javascript" src="${resource(dir: 'js', file: 'ui.js')}"></script>
<script type="text/javascript" src="${resource(dir: 'js/plugins/bootstrap-select-1.6.3/dist/js', file: 'bootstrap-select.js')}"></script>
<link href="${resource(dir: 'js/plugins/bootstrap-select-1.6.3/dist/css', file: 'bootstrap-select.min.css')}" rel="stylesheet">

<g:select from="${acts}" optionKey="id" id="actividad_dest" name="actividad_dest" optionValue='${{
    "" + it.numero + " - " + it.objeto
}}' noSelection="['-1': 'Seleccione']" class="form-control input-sm required requiredCombo"/>
<script>
    $("#actividad_dest").change(function () {
        $("#divAsg_dest").html(spinner);
        $.ajax({
            type    : "POST",
            url     : "${createLink(action:'cargarAsignaciones2_ajax',controller: 'avales')}",
            data    : {
                id   : $("#actividad_dest").val(),
                anio : $("#anio").val()
            },
            success : function (msg) {
                $("#divAsg_dest").html(msg)
            }
        });
    })
</script>