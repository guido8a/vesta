
<%@ page import="vesta.contratacion.DetalleMontoSolicitud" %>

<g:if test="${!detalleMontoSolicitudInstance}">
    <elm:notFound elem="DetalleMontoSolicitud" genero="o" />
</g:if>
<g:else>

    <g:if test="${detalleMontoSolicitudInstance?.anio}">
        <div class="row">
            <div class="col-md-2">
                Anio
            </div>
            
            <div class="col-md-3">
                ${detalleMontoSolicitudInstance?.anio?.encodeAsHTML()}
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${detalleMontoSolicitudInstance?.monto}">
        <div class="row">
            <div class="col-md-2">
                Monto
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${detalleMontoSolicitudInstance}" field="monto"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${detalleMontoSolicitudInstance?.solicitud}">
        <div class="row">
            <div class="col-md-2">
                Solicitud
            </div>
            
            <div class="col-md-3">
                ${detalleMontoSolicitudInstance?.solicitud?.encodeAsHTML()}
            </div>
            
        </div>
    </g:if>
    
</g:else>