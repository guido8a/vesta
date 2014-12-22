
<%@ page import="vesta.parametros.TipoGasto" %>

<g:if test="${!tipoGastoInstance}">
    <elm:notFound elem="TipoGasto" genero="o" />
</g:if>
<g:else>

    <g:if test="${tipoGastoInstance?.descripcion}">
        <div class="row">
            <div class="col-md-2">
                Descripcion
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${tipoGastoInstance}" field="descripcion"/>
            </div>
            
        </div>
    </g:if>
    
</g:else>