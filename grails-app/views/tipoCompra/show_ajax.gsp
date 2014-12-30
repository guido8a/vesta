
<%@ page import="vesta.parametros.poaPac.TipoCompra" %>

<g:if test="${!tipoCompraInstance}">
    <elm:notFound elem="TipoCompra" genero="o" />
</g:if>
<g:else>
    <div class="modal-contenido">

        <g:if test="${tipoCompraInstance?.descripcion}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Descripcion
                </div>
                
                <div class="col-md-4">
                    <g:fieldValue bean="${tipoCompraInstance}" field="descripcion"/>
                </div>
                
            </div>
        </g:if>
    
    </div>
</g:else>