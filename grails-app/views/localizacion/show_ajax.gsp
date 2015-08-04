
<%@ page import="vesta.parametros.Localizacion" %>

<g:if test="${!localizacionInstance}">
    <elm:notFound elem="Localizacion" genero="o" />
</g:if>
<g:else>
    <div class="modal-contenido">

        <g:if test="${localizacionInstance?.codigo}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Código
                </div>
                
                <div class="col-md-4">
                    <g:fieldValue bean="${localizacionInstance}" field="codigo"/>
                </div>
                
            </div>
        </g:if>
    
        <g:if test="${localizacionInstance?.descripcion}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Descripción
                </div>
                
                <div class="col-md-4">
                    <g:fieldValue bean="${localizacionInstance}" field="descripcion"/>
                </div>
                
            </div>
        </g:if>
    
    </div>
</g:else>