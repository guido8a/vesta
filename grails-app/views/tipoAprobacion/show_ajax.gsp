
<%@ page import="vesta.parametros.TipoAprobacion" %>

<g:if test="${!tipoAprobacionInstance}">
    <elm:notFound elem="TipoAprobacion" genero="o" />
</g:if>
<g:else>

    <g:if test="${tipoAprobacionInstance?.codigo}">
        <div class="row">
            <div class="col-md-2 show-label">
                Codigo
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${tipoAprobacionInstance}" field="codigo"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${tipoAprobacionInstance?.descripcion}">
        <div class="row">
            <div class="col-md-2 show-label">
                Descripcion
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${tipoAprobacionInstance}" field="descripcion"/>
            </div>
            
        </div>
    </g:if>
    
</g:else>