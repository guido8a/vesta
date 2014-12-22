
<%@ page import="vesta.parametros.FormaPago" %>

<g:if test="${!formaPagoInstance}">
    <elm:notFound elem="FormaPago" genero="o" />
</g:if>
<g:else>

    <g:if test="${formaPagoInstance?.descripcion}">
        <div class="row">
            <div class="col-md-2">
                Descripcion
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${formaPagoInstance}" field="descripcion"/>
            </div>
            
        </div>
    </g:if>
    
</g:else>