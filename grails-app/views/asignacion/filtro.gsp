
<div class="form-group keeptogether">
    <span class="grupo">
        <label class="col-md-2 control-label">
            <g:if test="${camp == 'Componente'}">
                Componente
            </g:if>
            <g:else>
                Responsable
            </g:else>
        </label>
        <div class="col-md-7">
            <g:if test="${camp == 'Componente'}">
                <g:select from="${componentes.unique()}" name="comp" noSelection="['-1':'Seleccione']" class="form-control input-sm" />
            </g:if>
            <g:else>
                <g:select from="${responsables.unique()}" name="resp" noSelection="['-1':'Seleccione']" class="form-control input-sm"/>
            </g:else>

        </div>

    </span>
</div>

<script type="text/javascript">

    $("#resp").change(function () {
        if($("#resp").val()){
            location.href = "${createLink(controller:'asignacion',action:'asignacionProyectov2')}?id=${proyecto.id}&anio=" + ${anio} +"&resp=" + $(this).val()
        }

    });
    $("#comp").change(function () {
        if($("#comp").val()){
            location.href = "${createLink(controller:'asignacion',action:'asignacionProyectov2')}?id=${proyecto.id}&anio=" + ${anio} +"&comp=" + $(this).val()
        }

    })


</script>



