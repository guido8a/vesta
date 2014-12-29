
<%@ page import="vesta.parametros.TipoResponsable" %>

<g:if test="${!tipoResponsableInstance}">
    <elm:notFound elem="TipoResponsable" genero="o" />
</g:if>
<g:else>

    <g:if test="${tipoResponsableInstance?.codigo}">
        <div class="row">
            <div class="col-md-2 show-label">
                Codigo
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${tipoResponsableInstance}" field="codigo"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${tipoResponsableInstance?.descripcion}">
        <div class="row">
            <div class="col-md-2 show-label">
                Descripcion
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${tipoResponsableInstance}" field="descripcion"/>
            </div>
            
        </div>
    </g:if>
    
</g:else>