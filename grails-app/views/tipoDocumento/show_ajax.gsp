
<%@ page import="vesta.parametros.TipoDocumento" %>

<g:if test="${!tipoDocumentoInstance}">
    <elm:notFound elem="TipoDocumento" genero="o" />
</g:if>
<g:else>

    <g:if test="${tipoDocumentoInstance?.descripcion}">
        <div class="row">
            <div class="col-md-2">
                Descripcion
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${tipoDocumentoInstance}" field="descripcion"/>
            </div>
            
        </div>
    </g:if>
    
</g:else>