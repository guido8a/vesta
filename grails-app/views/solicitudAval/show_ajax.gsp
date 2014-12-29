
<%@ page import="vesta.avales.SolicitudAval" %>

<g:if test="${!solicitudAvalInstance}">
    <elm:notFound elem="SolicitudAval" genero="o" />
</g:if>
<g:else>

    <g:if test="${solicitudAvalInstance?.concepto}">
        <div class="row">
            <div class="col-md-2 show-label">
                Concepto
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${solicitudAvalInstance}" field="concepto"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${solicitudAvalInstance?.proceso}">
        <div class="row">
            <div class="col-md-2 show-label">
                Proceso
            </div>
            
            <div class="col-md-3">
                ${solicitudAvalInstance?.proceso?.encodeAsHTML()}
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${solicitudAvalInstance?.aval}">
        <div class="row">
            <div class="col-md-2 show-label">
                Aval
            </div>
            
            <div class="col-md-3">
                ${solicitudAvalInstance?.aval?.encodeAsHTML()}
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${solicitudAvalInstance?.fechaRevision}">
        <div class="row">
            <div class="col-md-2 show-label">
                Fecha Revision
            </div>
            
            <div class="col-md-3">
                <g:formatDate date="${solicitudAvalInstance?.fechaRevision}" format="dd-MM-yyyy" />
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${solicitudAvalInstance?.estado}">
        <div class="row">
            <div class="col-md-2 show-label">
                Estado
            </div>
            
            <div class="col-md-3">
                ${solicitudAvalInstance?.estado?.encodeAsHTML()}
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${solicitudAvalInstance?.path}">
        <div class="row">
            <div class="col-md-2 show-label">
                Path
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${solicitudAvalInstance}" field="path"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${solicitudAvalInstance?.contrato}">
        <div class="row">
            <div class="col-md-2 show-label">
                Contrato
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${solicitudAvalInstance}" field="contrato"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${solicitudAvalInstance?.memo}">
        <div class="row">
            <div class="col-md-2 show-label">
                Memo
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${solicitudAvalInstance}" field="memo"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${solicitudAvalInstance?.observaciones}">
        <div class="row">
            <div class="col-md-2 show-label">
                Observaciones
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${solicitudAvalInstance}" field="observaciones"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${solicitudAvalInstance?.numero}">
        <div class="row">
            <div class="col-md-2 show-label">
                Numero
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${solicitudAvalInstance}" field="numero"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${solicitudAvalInstance?.tipo}">
        <div class="row">
            <div class="col-md-2 show-label">
                Tipo
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${solicitudAvalInstance}" field="tipo"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${solicitudAvalInstance?.firma}">
        <div class="row">
            <div class="col-md-2 show-label">
                Firma
            </div>
            
            <div class="col-md-3">
                ${solicitudAvalInstance?.firma?.encodeAsHTML()}
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${solicitudAvalInstance?.unidad}">
        <div class="row">
            <div class="col-md-2 show-label">
                Unidad
            </div>
            
            <div class="col-md-3">
                ${solicitudAvalInstance?.unidad?.encodeAsHTML()}
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${solicitudAvalInstance?.fecha}">
        <div class="row">
            <div class="col-md-2 show-label">
                Fecha
            </div>
            
            <div class="col-md-3">
                <g:formatDate date="${solicitudAvalInstance?.fecha}" format="dd-MM-yyyy" />
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${solicitudAvalInstance?.monto}">
        <div class="row">
            <div class="col-md-2 show-label">
                Monto
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${solicitudAvalInstance}" field="monto"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${solicitudAvalInstance?.usuario}">
        <div class="row">
            <div class="col-md-2 show-label">
                Usuario
            </div>
            
            <div class="col-md-3">
                ${solicitudAvalInstance?.usuario?.encodeAsHTML()}
            </div>
            
        </div>
    </g:if>
    
</g:else>