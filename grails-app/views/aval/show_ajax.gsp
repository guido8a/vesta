
<%@ page import="vesta.avales.Aval" %>

<g:if test="${!avalInstance}">
    <elm:notFound elem="Aval" genero="o" />
</g:if>
<g:else>

    <g:if test="${avalInstance?.proceso}">
        <div class="row">
            <div class="col-md-2">
                Proceso
            </div>
            
            <div class="col-md-3">
                ${avalInstance?.proceso?.nombre?.encodeAsHTML()}
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${avalInstance?.fechaAprobacion}">
        <div class="row">
            <div class="col-md-2">
                Fecha Aprobación
            </div>
            
            <div class="col-md-3">
                <g:formatDate date="${avalInstance?.fechaAprobacion}" format="dd-MM-yyyy" />
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${avalInstance?.fechaLiberacion}">
        <div class="row">
            <div class="col-md-2">
                Fecha Liberación
            </div>
            
            <div class="col-md-3">
                <g:formatDate date="${avalInstance?.fechaLiberacion}" format="dd-MM-yyyy" />
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${avalInstance?.fechaAnulacion}">
        <div class="row">
            <div class="col-md-2">
                Fecha Anulación
            </div>
            
            <div class="col-md-3">
                <g:formatDate date="${avalInstance?.fechaAnulacion}" format="dd-MM-yyyy" />
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${avalInstance?.estado}">
        <div class="row">
            <div class="col-md-2">
                Estado
            </div>
            
            <div class="col-md-3">
                ${avalInstance?.estado?.descripcion?.encodeAsHTML()}
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${avalInstance?.memo}">
        <div class="row">
            <div class="col-md-2">
                Memo
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${avalInstance}" field="memo"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${avalInstance?.path}">
        <div class="row">
            <div class="col-md-2">
                Path
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${avalInstance}" field="path"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${avalInstance?.pathLiberacion}">
        <div class="row">
            <div class="col-md-2">
                Path Liberación
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${avalInstance}" field="pathLiberacion"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${avalInstance?.pathAnulacion}">
        <div class="row">
            <div class="col-md-2">
                Path Anulación
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${avalInstance}" field="pathAnulacion"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${avalInstance?.contrato}">
        <div class="row">
            <div class="col-md-2">
                Contrato
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${avalInstance}" field="contrato"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${avalInstance?.numero}">
        <div class="row">
            <div class="col-md-2">
                Número
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${avalInstance}" field="numero"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${avalInstance?.concepto}">
        <div class="row">
            <div class="col-md-2">
                Concepto
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${avalInstance}" field="concepto"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${avalInstance?.certificacion}">
        <div class="row">
            <div class="col-md-2">
                Certificación
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${avalInstance}" field="certificacion"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${avalInstance?.firma1}">
        <div class="row">
            <div class="col-md-2">
                Firma1
            </div>
            
            <div class="col-md-3">
                ${avalInstance?.firma1?.encodeAsHTML()}
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${avalInstance?.firma2}">
        <div class="row">
            <div class="col-md-2">
                Firma2
            </div>
            
            <div class="col-md-3">
                ${avalInstance?.firma2?.encodeAsHTML()}
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${avalInstance?.liberacion}">
        <div class="row">
            <div class="col-md-2">
                Liberación
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${avalInstance}" field="liberacion"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${avalInstance?.monto}">
        <div class="row">
            <div class="col-md-2">
                Monto
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${avalInstance}" field="monto"/>
            </div>
            
        </div>
    </g:if>
    
</g:else>