
<%@ page import="vesta.parametros.Fase" %>

<g:if test="${!faseInstance}">
    <elm:notFound elem="Fase" genero="o" />
</g:if>
<g:else>

    <g:if test="${faseInstance?.descripcion}">
        <div class="row">
            <div class="col-md-2">
                Descripcion
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${faseInstance}" field="descripcion"/>
            </div>
            
        </div>
    </g:if>
    
</g:else>