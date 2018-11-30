
<%@ page import="vesta.proyectos.Documento" %>

<g:if test="${!documentoInstance}">
    <elm:notFound elem="Documento" genero="o" />
</g:if>
<g:else>
    <div class="modal-contenido">

        <g:if test="${documentoInstance?.proyecto}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Proyecto
                </div>
                
                <div class="col-md-9">
                    ${documentoInstance?.proyecto?.nombre?.encodeAsHTML()}
                </div>
                
            </div>
        </g:if>
    
        <g:if test="${documentoInstance?.grupoProcesos}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Grupo Procesos
                </div>
                
                <div class="col-md-4">
                    ${documentoInstance?.grupoProcesos?.encodeAsHTML()}
                </div>
                
            </div>
        </g:if>
    
        <g:if test="${documentoInstance?.descripcion}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Descripcion
                </div>
                
                <div class="col-md-4">
                    <g:fieldValue bean="${documentoInstance}" field="descripcion"/>
                </div>
                
            </div>
        </g:if>
    
        <g:if test="${documentoInstance?.clave}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Clave
                </div>
                
                <div class="col-md-4">
                    <g:fieldValue bean="${documentoInstance}" field="clave"/>
                </div>
                
            </div>
        </g:if>
    
        <g:if test="${documentoInstance?.resumen}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Resumen
                </div>
                
                <div class="col-md-4">
                    <g:fieldValue bean="${documentoInstance}" field="resumen"/>
                </div>
                
            </div>
        </g:if>
    
        <g:if test="${documentoInstance?.documento}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Documento
                </div>
                
                <div class="col-md-4">
                    <g:fieldValue bean="${documentoInstance}" field="documento"/>
                </div>
                
            </div>
        </g:if>
    
        <g:if test="${documentoInstance?.unidadEjecutora}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Área de gestión
                </div>
                
                <div class="col-md-4">
                    ${documentoInstance?.unidadEjecutora?.encodeAsHTML()}
                </div>
                
            </div>
        </g:if>
    
    </div>
</g:else>