
<%@ page import="vesta.avales.ProcesoAsignacion" %>

<g:if test="${!procesoAsignacionInstance}">
    <elm:notFound elem="ProcesoAsignacion" genero="o" />
</g:if>
<g:else>

    <g:if test="${procesoAsignacionInstance?.asignacion}">
        <div class="row">
            <div class="col-md-2">
                Asignacion
            </div>
            
            <div class="col-md-3">
                ${procesoAsignacionInstance?.asignacion?.encodeAsHTML()}
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${procesoAsignacionInstance?.monto}">
        <div class="row">
            <div class="col-md-2">
                Monto
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${procesoAsignacionInstance}" field="monto"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${procesoAsignacionInstance?.proceso}">
        <div class="row">
            <div class="col-md-2">
                Proceso
            </div>
            
            <div class="col-md-3">
                ${procesoAsignacionInstance?.proceso?.encodeAsHTML()}
            </div>
            
        </div>
    </g:if>
    
</g:else>