<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 07/04/15
  Time: 01:27 PM
--%>

<g:select from="${comps}" optionValue="objeto" optionKey="id" name="compDest" id="compDest" noSelection="['-1': 'Seleccione...']"
          style="width: 100%" class="form-control input-sm required requiredCombo"/>
<script>
    $("#compDest").change(function () {
        $.ajax({
            type    : "POST",
            url     : "${createLink(action:'cargarActividadesAjuste2_ajax',controller: 'avales')}",
            data    : {
                id  : $("#compDest").val(),
                div : "divAsg_dest"
            },
            success : function (msg) {
                $("#divAct_dest").html(msg)
            }
        });
    })

</script>