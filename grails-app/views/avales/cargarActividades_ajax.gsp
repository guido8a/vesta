<%--
  Created by IntelliJ IDEA.
  User: fabricio
  Date: 20/01/15
  Time: 03:56 PM
--%>

<script type="text/javascript" src="${resource(dir: 'js', file: 'ui.js')}"></script>
<script type="text/javascript" src="${resource(dir: 'js/plugins/bootstrap-select-1.6.3/dist/js', file: 'bootstrap-select.js')}"></script>
<link href="${resource(dir: 'js/plugins/bootstrap-select-1.6.3/dist/css', file: 'bootstrap-select.min.css')}" rel="stylesheet">

<g:select from="${acts}" optionKey="id" id="actividad" name="actividad" optionValue='${{
    "" + it.numero + " - " + it.objeto
}}' noSelection="['-1': 'Seleccione']" class="form-control input-sm"/>
<script>
    $("#actividad").change(function () {
        $.ajax({
            type    : "POST",
            url     : "${createLink(action:'cargarAsignaciones_ajax',controller: 'avales')}",
            data    : {
                id : $("#actividad").val(),
                anio : $("#anio").val()
            },
            success : function (msg) {

                $("#divAsg").html(msg)
            }
        });
    })
</script>