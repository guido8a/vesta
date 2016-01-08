<g:select from="${comps}" optionValue="objeto" optionKey="id" name="comp" id="comp" noSelection="['-1': 'Seleccione...']"
          style="width: 100%" class="form-control input-sm required requiredCombo"/>
<script>
    $("#comp").change(function () {
        $("#divAct").html(spinner);
        $.ajax({
            type    : "POST",
            url     : "${createLink(action:'cargarActividades2_ajax',controller: 'avales')}",
            data    : {
                id   : $("#comp").val(),
                anio : $("#anio").val()
            },
            success : function (msg) {
                $("#divAct").html(msg);
                $("#divAsg").html("");
//                $("#spanDevengado").addClass("hidden");
            }
        });
    })

</script>