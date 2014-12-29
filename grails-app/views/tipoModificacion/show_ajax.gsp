
<%@ page import="vesta.parametros.TipoModificacion" %>

<g:if test="${!tipoModificacionInstance}">
    <elm:notFound elem="TipoModificacion" genero="o" />
</g:if>
<g:else>

    <g:if test="${tipoModificacionInstance?.descripcion}">
        <div class="row">
            <div class="col-md-2 show-label">
                Descripcion
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${tipoModificacionInstance}" field="descripcion"/>
            </div>
            
        </div>
    </g:if>
    
</g:else>