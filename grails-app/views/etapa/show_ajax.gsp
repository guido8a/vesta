
<%@ page import="vesta.parametros.Etapa" %>

<g:if test="${!etapaInstance}">
    <elm:notFound elem="Etapa" genero="o" />
</g:if>
<g:else>

    <g:if test="${etapaInstance?.descripcion}">
        <div class="row">
            <div class="col-md-2">
                Descripcion
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${etapaInstance}" field="descripcion"/>
            </div>
            
        </div>
    </g:if>
    
</g:else>