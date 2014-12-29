
<%@ page import="vesta.parametros.TipoProcedencia" %>

<g:if test="${!tipoProcedenciaInstance}">
    <elm:notFound elem="TipoProcedencia" genero="o" />
</g:if>
<g:else>

    <g:if test="${tipoProcedenciaInstance?.descripcion}">
        <div class="row">
            <div class="col-md-2 show-label">
                Descripcion
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${tipoProcedenciaInstance}" field="descripcion"/>
            </div>
            
        </div>
    </g:if>
    
</g:else>