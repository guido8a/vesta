
<%@ page import="vesta.parametros.ItemCatalogo" %>

<g:if test="${!itemCatalogoInstance}">
    <elm:notFound elem="ItemCatalogo" genero="o" />
</g:if>
<g:else>

    <g:if test="${itemCatalogoInstance?.nombre}">
        <div class="row">
            <div class="col-md-2 show-label">
                Nombre
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${itemCatalogoInstance}" field="nombre"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${itemCatalogoInstance?.catalogo}">
        <div class="row">
            <div class="col-md-2 show-label">
                Catalogo
            </div>
            
            <div class="col-md-3">
                ${itemCatalogoInstance?.catalogo?.encodeAsHTML()}
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${itemCatalogoInstance?.codigo}">
        <div class="row">
            <div class="col-md-2 show-label">
                Codigo
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${itemCatalogoInstance}" field="codigo"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${itemCatalogoInstance?.descripcion}">
        <div class="row">
            <div class="col-md-2 show-label">
                Descripcion
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${itemCatalogoInstance}" field="descripcion"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${itemCatalogoInstance?.estado}">
        <div class="row">
            <div class="col-md-2 show-label">
                Estado
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${itemCatalogoInstance}" field="estado"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${itemCatalogoInstance?.orden}">
        <div class="row">
            <div class="col-md-2 show-label">
                Orden
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${itemCatalogoInstance}" field="orden"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${itemCatalogoInstance?.original}">
        <div class="row">
            <div class="col-md-2 show-label">
                Original
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${itemCatalogoInstance}" field="original"/>
            </div>
            
        </div>
    </g:if>
    
</g:else>