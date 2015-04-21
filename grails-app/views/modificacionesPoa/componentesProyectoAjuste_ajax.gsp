<g:select from="${comps}" optionValue="objeto" optionKey="id" name="comp" id="${idCombo ? idCombo : 'comp'}" noSelection="['-1': 'Seleccione...']"
          style="width: 100%" class="form-control input-sm required requiredCombo"/>
<script>
    $("#${idCombo?idCombo:'comp'}").change(function () {
        $("#${div?div:'divAct'}").html(spinner);
        $.ajax({
            type    : "POST",
            url     : "${createLink(action:'cargarActividadesAjuste_ajax',controller: 'avales')}",
            data    : {
                id  : $("#${idCombo?idCombo:'comp'}").val()
                <g:if test="${div}">
                ,
                div : "divAsg_dest"
                </g:if>
            },
            success : function (msg) {
                $("#${div?div:'divAct'}").html(msg);
                $("#divAsg").html("");
                $("#max").text("");
            }
        });
    })

</script>