
<%@ page import="vesta.avales.EstadoAval" %>

<g:if test="${!estadoAvalInstance}">
    <elm:notFound elem="EstadoAval" genero="o" />
</g:if>
<g:else>

    <g:if test="${estadoAvalInstance?.descripcion}">
        <div class="row">
            <div class="col-md-2 show-label">
                Descripcion
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${estadoAvalInstance}" field="descripcion"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${estadoAvalInstance?.codigo}">
        <div class="row">
            <div class="col-md-2 show-label">
                Codigo
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${estadoAvalInstance}" field="codigo"/>
            </div>
            
        </div>
    </g:if>
    
</g:else>