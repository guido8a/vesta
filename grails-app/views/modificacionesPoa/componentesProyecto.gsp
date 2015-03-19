<g:select from="${comps}" optionValue="objeto" optionKey="id" name="comp" id="${idCombo?idCombo:'comp'}" noSelection="['-1': 'Seleccione...']" style="width: 100%" class="form-control input-sm"></g:select>
<script>
    $("#${idCombo?idCombo:'comp'}").change(function () {
        <g:if test="${div}">
        $.ajax({
            type    : "POST",
            url     : "${createLink(action:'cargarActividades',controller: 'modificacionesPoa')}",
            data    : {
                id : $("#${idCombo?idCombo:'comp'}").val(),
                div : "divAsg_dest"
            },
            success : function (msg) {

                $("#divAct_dest").html(msg)

            }
        });
        </g:if>
        <g:else>
        $.ajax({
            type    : "POST",
            url     : "${createLink(action:'cargarActividades_ajax',controller: 'avales')}",
            data    : {
                id     : $("#${idCombo?idCombo:'comp'}").val(),
                unidad : "${session.usuario.unidad?.id}"
            },
            success : function (msg) {

                $("#${div?div:'divAct'}").html(msg)
            }
        });
        </g:else>

    })

</script>