
<%@ page import="vesta.proyectos.PoliticaBuenVivir" %>

<g:if test="${!politicaBuenVivirInstance}">
    <elm:notFound elem="PoliticaBuenVivir" genero="o" />
</g:if>
<g:else>
    <div class="modal-contenido">

        <g:if test="${politicaBuenVivirInstance?.objetivo}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Objetivo
                </div>
                
                <div class="col-md-4">
                    ${politicaBuenVivirInstance?.objetivo?.encodeAsHTML()}
                </div>
                
            </div>
        </g:if>
    
        <g:if test="${politicaBuenVivirInstance?.codigo}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Codigo
                </div>
                
                <div class="col-md-4">
                    <g:fieldValue bean="${politicaBuenVivirInstance}" field="codigo"/>
                </div>
                
            </div>
        </g:if>
    
        <g:if test="${politicaBuenVivirInstance?.descripcion}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Descripcion
                </div>
                
                <div class="col-md-4">
                    <g:fieldValue bean="${politicaBuenVivirInstance}" field="descripcion"/>
                </div>
                
            </div>
        </g:if>
    
    </div>
</g:else>