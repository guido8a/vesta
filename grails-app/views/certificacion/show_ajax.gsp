
<%@ page import="vesta.avales.Certificacion" %>

<g:if test="${!certificacionInstance}">
    <elm:notFound elem="Certificacion" genero="o" />
</g:if>
<g:else>

    <g:if test="${certificacionInstance?.usuario}">
        <div class="row">
            <div class="col-md-2 show-label">
                Usuario
            </div>
            
            <div class="col-md-3">
                ${certificacionInstance?.usuario?.encodeAsHTML()}
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${certificacionInstance?.asignacion}">
        <div class="row">
            <div class="col-md-2 show-label">
                Asignacion
            </div>
            
            <div class="col-md-3">
                ${certificacionInstance?.asignacion?.encodeAsHTML()}
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${certificacionInstance?.fecha}">
        <div class="row">
            <div class="col-md-2 show-label">
                Fecha
            </div>
            
            <div class="col-md-3">
                <g:formatDate date="${certificacionInstance?.fecha}" format="dd-MM-yyyy" />
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${certificacionInstance?.fechaRevision}">
        <div class="row">
            <div class="col-md-2 show-label">
                Fecha Revision
            </div>
            
            <div class="col-md-3">
                <g:formatDate date="${certificacionInstance?.fechaRevision}" format="dd-MM-yyyy" />
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${certificacionInstance?.monto}">
        <div class="row">
            <div class="col-md-2 show-label">
                Monto
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${certificacionInstance}" field="monto"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${certificacionInstance?.concepto}">
        <div class="row">
            <div class="col-md-2 show-label">
                Concepto
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${certificacionInstance}" field="concepto"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${certificacionInstance?.observaciones}">
        <div class="row">
            <div class="col-md-2 show-label">
                Observaciones
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${certificacionInstance}" field="observaciones"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${certificacionInstance?.estado}">
        <div class="row">
            <div class="col-md-2 show-label">
                Estado
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${certificacionInstance}" field="estado"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${certificacionInstance?.memorandoSolicitud}">
        <div class="row">
            <div class="col-md-2 show-label">
                Memorando Solicitud
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${certificacionInstance}" field="memorandoSolicitud"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${certificacionInstance?.memorandoCertificado}">
        <div class="row">
            <div class="col-md-2 show-label">
                Memorando Certificado
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${certificacionInstance}" field="memorandoCertificado"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${certificacionInstance?.acuerdo}">
        <div class="row">
            <div class="col-md-2 show-label">
                Acuerdo
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${certificacionInstance}" field="acuerdo"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${certificacionInstance?.archivo}">
        <div class="row">
            <div class="col-md-2 show-label">
                Archivo
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${certificacionInstance}" field="archivo"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${certificacionInstance?.pathSolicitud}">
        <div class="row">
            <div class="col-md-2 show-label">
                Path Solicitud
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${certificacionInstance}" field="pathSolicitud"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${certificacionInstance?.pathAnulacion}">
        <div class="row">
            <div class="col-md-2 show-label">
                Path Anulacion
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${certificacionInstance}" field="pathAnulacion"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${certificacionInstance?.fechaAnulacion}">
        <div class="row">
            <div class="col-md-2 show-label">
                Fecha Anulacion
            </div>
            
            <div class="col-md-3">
                <g:formatDate date="${certificacionInstance?.fechaAnulacion}" format="dd-MM-yyyy" />
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${certificacionInstance?.fechaLiberacion}">
        <div class="row">
            <div class="col-md-2 show-label">
                Fecha Liberacion
            </div>
            
            <div class="col-md-3">
                <g:formatDate date="${certificacionInstance?.fechaLiberacion}" format="dd-MM-yyyy" />
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${certificacionInstance?.conceptoAnulacion}">
        <div class="row">
            <div class="col-md-2 show-label">
                Concepto Anulacion
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${certificacionInstance}" field="conceptoAnulacion"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${certificacionInstance?.pathSolicitudAnulacion}">
        <div class="row">
            <div class="col-md-2 show-label">
                Path Solicitud Anulacion
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${certificacionInstance}" field="pathSolicitudAnulacion"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${certificacionInstance?.pathLiberacion}">
        <div class="row">
            <div class="col-md-2 show-label">
                Path Liberacion
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${certificacionInstance}" field="pathLiberacion"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${certificacionInstance?.numeroContrato}">
        <div class="row">
            <div class="col-md-2 show-label">
                Numero Contrato
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${certificacionInstance}" field="numeroContrato"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${certificacionInstance?.fechaRevisionAnulacion}">
        <div class="row">
            <div class="col-md-2 show-label">
                Fecha Revision Anulacion
            </div>
            
            <div class="col-md-3">
                <g:formatDate date="${certificacionInstance?.fechaRevisionAnulacion}" format="dd-MM-yyyy" />
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${certificacionInstance?.montoLiberacion}">
        <div class="row">
            <div class="col-md-2 show-label">
                Monto Liberacion
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${certificacionInstance}" field="montoLiberacion"/>
            </div>
            
        </div>
    </g:if>
    
</g:else>