
<%@ page import="vesta.avales.DistribucionAsignacion" %>

<g:if test="${!distribucionAsignacionInstance}">
    <elm:notFound elem="DistribucionAsignacion" genero="o" />
</g:if>
<g:else>

    <g:if test="${distribucionAsignacionInstance?.asignacion}">
        <div class="row">
            <div class="col-md-2 show-label">
                Asignacion
            </div>
            
            <div class="col-md-3">
                ${distribucionAsignacionInstance?.asignacion?.encodeAsHTML()}
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${distribucionAsignacionInstance?.unidadEjecutora}">
        <div class="row">
            <div class="col-md-2 show-label">
                Unidad Ejecutora
            </div>
            
            <div class="col-md-3">
                ${distribucionAsignacionInstance?.unidadEjecutora?.encodeAsHTML()}
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${distribucionAsignacionInstance?.valor}">
        <div class="row">
            <div class="col-md-2 show-label">
                Valor
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${distribucionAsignacionInstance}" field="valor"/>
            </div>
            
        </div>
    </g:if>
    
</g:else>