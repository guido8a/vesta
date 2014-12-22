
<%@ page import="vesta.parametros.TipoGrupo" %>

<g:if test="${!tipoGrupoInstance}">
    <elm:notFound elem="TipoGrupo" genero="o" />
</g:if>
<g:else>

    <g:if test="${tipoGrupoInstance?.descripcion}">
        <div class="row">
            <div class="col-md-2">
                Descripcion
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${tipoGrupoInstance}" field="descripcion"/>
            </div>
            
        </div>
    </g:if>
    
</g:else>