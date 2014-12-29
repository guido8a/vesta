
<%@ page import="vesta.parametros.TipoSupuesto" %>

<g:if test="${!tipoSupuestoInstance}">
    <elm:notFound elem="TipoSupuesto" genero="o" />
</g:if>
<g:else>

    <g:if test="${tipoSupuestoInstance?.descripcion}">
        <div class="row">
            <div class="col-md-2 show-label">
                Descripcion
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${tipoSupuestoInstance}" field="descripcion"/>
            </div>
            
        </div>
    </g:if>
    
</g:else>