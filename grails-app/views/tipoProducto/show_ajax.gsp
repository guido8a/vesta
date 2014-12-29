
<%@ page import="vesta.parametros.TipoProducto" %>

<g:if test="${!tipoProductoInstance}">
    <elm:notFound elem="TipoProducto" genero="o" />
</g:if>
<g:else>

    <g:if test="${tipoProductoInstance?.tipoProducto}">
        <div class="row">
            <div class="col-md-2 show-label">
                Tipo Producto
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${tipoProductoInstance}" field="tipoProducto"/>
            </div>
            
        </div>
    </g:if>
    
</g:else>