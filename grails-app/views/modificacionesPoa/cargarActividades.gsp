<g:select from="${acts}" optionKey="id"  id="${(comboId)?comboId:'actividad_dest'}" name="actividad"
          optionValue='${{""+it.numero+" - "+it.objeto}}' style="width:100%" noSelection="['-1':'Seleccione']" class="form-control input-sm"></g:select>
<script>
    $("#"+"${(comboId)?comboId:'actividad_dest'}").change(function(){
        <g:if test="${!comboId}">
        $.ajax({
            type: "POST",
            url: "${createLink(action:'cargarAsignaciones',controller: 'modificacionesPoa')}",
            data: {
                id:$("#actividad_dest").val(),
                anio:$("#anio_dest").val()
            },
            success: function(msg) {

                $("#"+"${div}").html(msg)
            }
        });
        </g:if>
    });
</script>