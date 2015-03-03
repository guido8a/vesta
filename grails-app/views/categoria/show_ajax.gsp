
<%@ page import="vesta.proyectos.Categoria" %>

<g:if test="${!categoriaInstance}">
    <elm:notFound elem="Categoria" genero="o" />
</g:if>
<g:else>
    <div class="modal-contenido">

        <g:if test="${categoriaInstance?.descripcion}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Descripcion
                </div>
                
                <div class="col-md-4">
                    <g:fieldValue bean="${categoriaInstance}" field="descripcion"/>
                </div>
                
            </div>
        </g:if>
    
        <g:if test="${categoriaInstance?.codigo}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Codigo
                </div>
                
                <div class="col-md-4">
                    <g:fieldValue bean="${categoriaInstance}" field="codigo"/>
                </div>
                
            </div>
        </g:if>
    
    </div>
</g:else>