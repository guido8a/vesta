
<%@ page import="vesta.parametros.Sector" %>

<g:if test="${!sectorInstance}">
    <elm:notFound elem="Sector" genero="o" />
</g:if>
<g:else>

    <g:if test="${sectorInstance?.descripcion}">
        <div class="row">
            <div class="col-md-2 show-label">
                Descripcion
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${sectorInstance}" field="descripcion"/>
            </div>
            
        </div>
    </g:if>
    
</g:else>