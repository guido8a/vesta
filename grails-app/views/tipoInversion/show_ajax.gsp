
<%@ page import="vesta.parametros.TipoInversion" %>

<g:if test="${!tipoInversionInstance}">
    <elm:notFound elem="TipoInversion" genero="o" />
</g:if>
<g:else>

    <g:if test="${tipoInversionInstance?.descripcion}">
        <div class="row">
            <div class="col-md-2">
                Descripcion
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${tipoInversionInstance}" field="descripcion"/>
            </div>
            
        </div>
    </g:if>
    
</g:else>