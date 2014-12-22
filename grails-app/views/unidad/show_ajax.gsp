
<%@ page import="vesta.parametros.Unidad" %>

<g:if test="${!unidadInstance}">
    <elm:notFound elem="Unidad" genero="o" />
</g:if>
<g:else>

    <g:if test="${unidadInstance?.codigo}">
        <div class="row">
            <div class="col-md-2">
                Codigo
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${unidadInstance}" field="codigo"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${unidadInstance?.descripcion}">
        <div class="row">
            <div class="col-md-2">
                Descripcion
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${unidadInstance}" field="descripcion"/>
            </div>
            
        </div>
    </g:if>
    
</g:else>