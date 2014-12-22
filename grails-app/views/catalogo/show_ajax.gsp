
<%@ page import="vesta.parametros.Catalogo" %>

<g:if test="${!catalogoInstance}">
    <elm:notFound elem="Catalogo" genero="o" />
</g:if>
<g:else>

    <g:if test="${catalogoInstance?.nombre}">
        <div class="row">
            <div class="col-md-2">
                Nombre
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${catalogoInstance}" field="nombre"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${catalogoInstance?.codigo}">
        <div class="row">
            <div class="col-md-2">
                Codigo
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${catalogoInstance}" field="codigo"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${catalogoInstance?.estado}">
        <div class="row">
            <div class="col-md-2">
                Estado
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${catalogoInstance}" field="estado"/>
            </div>
            
        </div>
    </g:if>
    
</g:else>