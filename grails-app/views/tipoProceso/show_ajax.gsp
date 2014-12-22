
<%@ page import="vesta.parametros.TipoProceso" %>

<g:if test="${!tipoProcesoInstance}">
    <elm:notFound elem="TipoProceso" genero="o" />
</g:if>
<g:else>

    <g:if test="${tipoProcesoInstance?.descripcion}">
        <div class="row">
            <div class="col-md-2">
                Descripcion
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${tipoProcesoInstance}" field="descripcion"/>
            </div>
            
        </div>
    </g:if>
    
</g:else>