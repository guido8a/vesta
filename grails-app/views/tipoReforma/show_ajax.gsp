
<%@ page import="vesta.modificaciones.TipoReforma" %>

<g:if test="${!tipoReformaInstance}">
    <elm:notFound elem="TipoReforma" genero="o" />
</g:if>
<g:else>
    <div class="modal-contenido">

        <g:if test="${tipoReformaInstance?.codigo}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Código
                </div>
                
                <div class="col-md-4">
                    <g:fieldValue bean="${tipoReformaInstance}" field="codigo"/>
                </div>
                
            </div>
        </g:if>
    
        <g:if test="${tipoReformaInstance?.descripcion}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Descripción
                </div>
                
                <div class="col-md-4">
                    <g:fieldValue bean="${tipoReformaInstance}" field="descripcion"/>
                </div>
                
            </div>
        </g:if>
    
    </div>
</g:else>