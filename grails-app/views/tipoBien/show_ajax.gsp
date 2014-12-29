
<%@ page import="vesta.parametros.TipoBien" %>

<g:if test="${!tipoBienInstance}">
    <elm:notFound elem="TipoBien" genero="o" />
</g:if>
<g:else>

    <g:if test="${tipoBienInstance?.descripcion}">
        <div class="row">
            <div class="col-md-2 show-label">
                Descripcion
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${tipoBienInstance}" field="descripcion"/>
            </div>
            
        </div>
    </g:if>
    
</g:else>