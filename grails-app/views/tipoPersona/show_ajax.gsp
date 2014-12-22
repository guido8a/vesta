
<%@ page import="vesta.parametros.TipoPersona" %>

<g:if test="${!tipoPersonaInstance}">
    <elm:notFound elem="TipoPersona" genero="o" />
</g:if>
<g:else>

    <g:if test="${tipoPersonaInstance?.descripcion}">
        <div class="row">
            <div class="col-md-2">
                Descripcion
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${tipoPersonaInstance}" field="descripcion"/>
            </div>
            
        </div>
    </g:if>
    
</g:else>