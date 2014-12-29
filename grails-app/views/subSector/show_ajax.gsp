
<%@ page import="vesta.parametros.SubSector" %>

<g:if test="${!subSectorInstance}">
    <elm:notFound elem="SubSector" genero="o" />
</g:if>
<g:else>

    <g:if test="${subSectorInstance?.descripcion}">
        <div class="row">
            <div class="col-md-2 show-label">
                Descripcion
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${subSectorInstance}" field="descripcion"/>
            </div>
            
        </div>
    </g:if>
    
</g:else>