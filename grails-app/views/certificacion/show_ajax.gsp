
<%@ page import="vesta.avales.Certificacion" %>

<g:if test="${!certificacionInstance}">
    <elm:notFound elem="Certificacion" genero="o" />
</g:if>
<g:else>

    <g:if test="${certificacionInstance?.usuario}">
        <div class="row">
            <div class="col-md-2">
                Usuario
            </div>
            
            <div class="col-md-3">
                ${certificacionInstance?.usuario?.encodeAsHTML()}
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${certificacionInstance?.asignacion}">
        <div class="row">
            <div class="col-md-2">
                Asignacion
            </div>
            
            <div class="col-md-3">
                ${certificacionInstance?.asignacion?.encodeAsHTML()}
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${certificacionInstance?.fecha}">
        <div class="row">
            <div class="col-md-2">
                Fecha
            </div>
            
            <div class="col-md-3">
                <g:formatDate date="${certificacionInstance?.fecha}" format="dd-MM-yyyy" />
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${certificacionInstance?.fechaRevision}">
        <div class="row">
            <div class="col-md-2">
                Fecha Revision
            </div>
            
            <div class="col-md-3">
                <g:formatDate date="${certificacionInstance?.fechaRevision}" format="dd-MM-yyyy" />
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${certificacionInstance?.monto}">
        <div class="row">
            <div class="col-md-2">
                Monto
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${certificacionInstance}" field="monto"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${certificacionInstance?.concepto}">
        <div class="row">
            <div class="col-md-2">
                Concepto
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${certificacionInstance}" field="concepto"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${certificacionInstance?.observaciones}">
        <div class="row">
            <div class="col-md-2">
                Observaciones
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${certificacionInstance}" field="observaciones"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${certificacionInstance?.estado}">
        <div class="row">
            <div class="col-md-2">
                Estado
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${certificacionInstance}" field="estado"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${certificacionInstance?.memorandoSolicitud}">
        <div class="row">
            <div class="col-md-2">
                Memorando Solicitud
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${certificacionInstance}" field="memorandoSolicitud"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${certificacionInstance?.memorandoCertificado}">
        <div class="row">
            <div class="col-md-2">
                Memorando Certificado
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${certificacionInstance}" field="memorandoCertificado"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${certificacionInstance?.acuerdo}">
        <div class="row">
            <div class="col-md-2">
                Acuerdo
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${certificacionInstance}" field="acuerdo"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${certificacionInstance?.archivo}">
        <div class="row">
            <div class="col-md-2">
                Archivo
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${certificacionInstance}" field="archivo"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${certificacionInstance?.pathSolicitud}">
        <div class="row">
            <div class="col-md-2">
                Path Solicitud
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${certificacionInstance}" field="pathSolicitud"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${certificacionInstance?.pathAnulacion}">
        <div class="row">
            <div class="col-md-2">
                Path Anulacion
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${certificacionInstance}" field="pathAnulacion"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${certificacionInstance?.fechaAnulacion}">
        <div class="row">
            <div class="col-md-2">
                Fecha Anulacion
            </div>
            
            <div class="col-md-3">
                <g:formatDate date="${certificacionInstance?.fechaAnulacion}" format="dd-MM-yyyy" />
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${certificacionInstance?.fechaLiberacion}">
        <div class="row">
            <div class="col-md-2">
                Fecha Liberacion
            </div>
            
            <div class="col-md-3">
                <g:formatDate date="${certificacionInstance?.fechaLiberacion}" format="dd-MM-yyyy" />
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${certificacionInstance?.conceptoAnulacion}">
        <div class="row">
            <div class="col-md-2">
                Concepto Anulacion
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${certificacionInstance}" field="conceptoAnulacion"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${certificacionInstance?.pathSolicitudAnulacion}">
        <div class="row">
            <div class="col-md-2">
                Path Solicitud Anulacion
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${certificacionInstance}" field="pathSolicitudAnulacion"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${certificacionInstance?.pathLiberacion}">
        <div class="row">
            <div class="col-md-2">
                Path Liberacion
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${certificacionInstance}" field="pathLiberacion"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${certificacionInstance?.numeroContrato}">
        <div class="row">
            <div class="col-md-2">
                Numero Contrato
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${certificacionInstance}" field="numeroContrato"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${certificacionInstance?.fechaRevisionAnulacion}">
        <div class="row">
            <div class="col-md-2">
                Fecha Revision Anulacion
            </div>
            
            <div class="col-md-3">
                <g:formatDate date="${certificacionInstance?.fechaRevisionAnulacion}" format="dd-MM-yyyy" />
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${certificacionInstance?.montoLiberacion}">
        <div class="row">
            <div class="col-md-2">
                Monto Liberacion
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${certificacionInstance}" field="montoLiberacion"/>
            </div>
            
        </div>
    </g:if>
    
</g:else>