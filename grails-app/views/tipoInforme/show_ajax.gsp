
<%@ page import="vesta.parametros.TipoInforme" %>

<g:if test="${!tipoInformeInstance}">
    <elm:notFound elem="TipoInforme" genero="o" />
</g:if>
<g:else>

    <g:if test="${tipoInformeInstance?.descripcion}">
        <div class="row">
            <div class="col-md-2">
                Descripcion
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${tipoInformeInstance}" field="descripcion"/>
            </div>
            
        </div>
    </g:if>
    
</g:else>