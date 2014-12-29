
<%@ page import="vesta.hitos.AvanceFinanciero" %>

<g:if test="${!avanceFinancieroInstance}">
    <elm:notFound elem="AvanceFinanciero" genero="o" />
</g:if>
<g:else>

    <g:if test="${avanceFinancieroInstance?.proceso}">
        <div class="row">
            <div class="col-md-2 show-label">
                Proceso
            </div>
            
            <div class="col-md-3">
                ${avanceFinancieroInstance?.proceso?.encodeAsHTML()}
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${avanceFinancieroInstance?.observaciones}">
        <div class="row">
            <div class="col-md-2 show-label">
                Observaciones
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${avanceFinancieroInstance}" field="observaciones"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${avanceFinancieroInstance?.contrato}">
        <div class="row">
            <div class="col-md-2 show-label">
                Contrato
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${avanceFinancieroInstance}" field="contrato"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${avanceFinancieroInstance?.certificado}">
        <div class="row">
            <div class="col-md-2 show-label">
                Certificado
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${avanceFinancieroInstance}" field="certificado"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${avanceFinancieroInstance?.aval}">
        <div class="row">
            <div class="col-md-2 show-label">
                Aval
            </div>
            
            <div class="col-md-3">
                ${avanceFinancieroInstance?.aval?.encodeAsHTML()}
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${avanceFinancieroInstance?.fecha}">
        <div class="row">
            <div class="col-md-2 show-label">
                Fecha
            </div>
            
            <div class="col-md-3">
                <g:formatDate date="${avanceFinancieroInstance?.fecha}" format="dd-MM-yyyy" />
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${avanceFinancieroInstance?.monto}">
        <div class="row">
            <div class="col-md-2 show-label">
                Monto
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${avanceFinancieroInstance}" field="monto"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${avanceFinancieroInstance?.valor}">
        <div class="row">
            <div class="col-md-2 show-label">
                Valor
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${avanceFinancieroInstance}" field="valor"/>
            </div>
            
        </div>
    </g:if>
    
</g:else>