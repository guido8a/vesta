
<%@ page import="vesta.parametros.Auxiliar" %>

<g:if test="${!auxiliarInstance}">
    <elm:notFound elem="Auxiliar" genero="o" />
</g:if>
<g:else>

    <g:if test="${auxiliarInstance?.presupuesto}">
        <div class="row">
            <div class="col-md-2 show-label">
                Presupuesto
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${auxiliarInstance}" field="presupuesto"/>
            </div>
            
        </div>
    </g:if>
    
</g:else>