
<%@ page import="vesta.modificaciones.SolicitudModPoa" %>

<g:if test="${!solicitudModPoaInstance}">
    <elm:notFound elem="SolicitudModPoa" genero="o" />
</g:if>
<g:else>

    <g:if test="${solicitudModPoaInstance?.fechaRevision}">
        <div class="row">
            <div class="col-md-2">
                Fecha Revision
            </div>
            
            <div class="col-md-3">
                <g:formatDate date="${solicitudModPoaInstance?.fechaRevision}" format="dd-MM-yyyy" />
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${solicitudModPoaInstance?.origen}">
        <div class="row">
            <div class="col-md-2">
                Origen
            </div>
            
            <div class="col-md-3">
                ${solicitudModPoaInstance?.origen?.encodeAsHTML()}
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${solicitudModPoaInstance?.destino}">
        <div class="row">
            <div class="col-md-2">
                Destino
            </div>
            
            <div class="col-md-3">
                ${solicitudModPoaInstance?.destino?.encodeAsHTML()}
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${solicitudModPoaInstance?.anio}">
        <div class="row">
            <div class="col-md-2">
                Anio
            </div>
            
            <div class="col-md-3">
                ${solicitudModPoaInstance?.anio?.encodeAsHTML()}
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${solicitudModPoaInstance?.fuente}">
        <div class="row">
            <div class="col-md-2">
                Fuente
            </div>
            
            <div class="col-md-3">
                ${solicitudModPoaInstance?.fuente?.encodeAsHTML()}
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${solicitudModPoaInstance?.marcoLogico}">
        <div class="row">
            <div class="col-md-2">
                Marco Logico
            </div>
            
            <div class="col-md-3">
                ${solicitudModPoaInstance?.marcoLogico?.encodeAsHTML()}
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${solicitudModPoaInstance?.presupuesto}">
        <div class="row">
            <div class="col-md-2">
                Presupuesto
            </div>
            
            <div class="col-md-3">
                ${solicitudModPoaInstance?.presupuesto?.encodeAsHTML()}
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${solicitudModPoaInstance?.valor}">
        <div class="row">
            <div class="col-md-2">
                Valor
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${solicitudModPoaInstance}" field="valor"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${solicitudModPoaInstance?.concepto}">
        <div class="row">
            <div class="col-md-2">
                Concepto
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${solicitudModPoaInstance}" field="concepto"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${solicitudModPoaInstance?.estado}">
        <div class="row">
            <div class="col-md-2">
                Estado
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${solicitudModPoaInstance}" field="estado"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${solicitudModPoaInstance?.usuario}">
        <div class="row">
            <div class="col-md-2">
                Usuario
            </div>
            
            <div class="col-md-3">
                ${solicitudModPoaInstance?.usuario?.encodeAsHTML()}
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${solicitudModPoaInstance?.revisor}">
        <div class="row">
            <div class="col-md-2">
                Revisor
            </div>
            
            <div class="col-md-3">
                ${solicitudModPoaInstance?.revisor?.encodeAsHTML()}
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${solicitudModPoaInstance?.tipo}">
        <div class="row">
            <div class="col-md-2">
                Tipo
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${solicitudModPoaInstance}" field="tipo"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${solicitudModPoaInstance?.observaciones}">
        <div class="row">
            <div class="col-md-2">
                Observaciones
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${solicitudModPoaInstance}" field="observaciones"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${solicitudModPoaInstance?.actividad}">
        <div class="row">
            <div class="col-md-2">
                Actividad
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${solicitudModPoaInstance}" field="actividad"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${solicitudModPoaInstance?.inicio}">
        <div class="row">
            <div class="col-md-2">
                Inicio
            </div>
            
            <div class="col-md-3">
                <g:formatDate date="${solicitudModPoaInstance?.inicio}" format="dd-MM-yyyy" />
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${solicitudModPoaInstance?.fin}">
        <div class="row">
            <div class="col-md-2">
                Fin
            </div>
            
            <div class="col-md-3">
                <g:formatDate date="${solicitudModPoaInstance?.fin}" format="dd-MM-yyyy" />
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${solicitudModPoaInstance?.firmaSol}">
        <div class="row">
            <div class="col-md-2">
                Firma Sol
            </div>
            
            <div class="col-md-3">
                ${solicitudModPoaInstance?.firmaSol?.encodeAsHTML()}
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${solicitudModPoaInstance?.firma1}">
        <div class="row">
            <div class="col-md-2">
                Firma1
            </div>
            
            <div class="col-md-3">
                ${solicitudModPoaInstance?.firma1?.encodeAsHTML()}
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${solicitudModPoaInstance?.firma2}">
        <div class="row">
            <div class="col-md-2">
                Firma2
            </div>
            
            <div class="col-md-3">
                ${solicitudModPoaInstance?.firma2?.encodeAsHTML()}
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${solicitudModPoaInstance?.fecha}">
        <div class="row">
            <div class="col-md-2">
                Fecha
            </div>
            
            <div class="col-md-3">
                <g:formatDate date="${solicitudModPoaInstance?.fecha}" format="dd-MM-yyyy" />
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${solicitudModPoaInstance?.valorDestino}">
        <div class="row">
            <div class="col-md-2">
                Valor Destino
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${solicitudModPoaInstance}" field="valorDestino"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${solicitudModPoaInstance?.valorDestinoSolicitado}">
        <div class="row">
            <div class="col-md-2">
                Valor Destino Solicitado
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${solicitudModPoaInstance}" field="valorDestinoSolicitado"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${solicitudModPoaInstance?.valorOrigen}">
        <div class="row">
            <div class="col-md-2">
                Valor Origen
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${solicitudModPoaInstance}" field="valorOrigen"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${solicitudModPoaInstance?.valorOrigenSolicitado}">
        <div class="row">
            <div class="col-md-2">
                Valor Origen Solicitado
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${solicitudModPoaInstance}" field="valorOrigenSolicitado"/>
            </div>
            
        </div>
    </g:if>
    
</g:else>