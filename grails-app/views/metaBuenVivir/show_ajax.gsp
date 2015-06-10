
<%@ page import="vesta.proyectos.MetaBuenVivir" %>

<g:if test="${!metaBuenVivirInstance}">
    <elm:notFound elem="MetaBuenVivir" genero="o" />
</g:if>
<g:else>
    <div class="modal-contenido">

        <g:if test="${metaBuenVivirInstance?.politica}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Politica
                </div>
                
                <div class="col-md-4">
                    ${metaBuenVivirInstance?.politica?.encodeAsHTML()}
                </div>
                
            </div>
        </g:if>
    
        <g:if test="${metaBuenVivirInstance?.codigo}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Codigo
                </div>
                
                <div class="col-md-4">
                    <g:fieldValue bean="${metaBuenVivirInstance}" field="codigo"/>
                </div>
                
            </div>
        </g:if>
    
        <g:if test="${metaBuenVivirInstance?.descripcion}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Descripcion
                </div>
                
                <div class="col-md-4">
                    <g:fieldValue bean="${metaBuenVivirInstance}" field="descripcion"/>
                </div>
                
            </div>
        </g:if>
    
    </div>
</g:else>