
<%@ page import="vesta.contratacion.Aprobacion" %>

<g:if test="${!aprobacionInstance}">
    <elm:notFound elem="Aprobacion" genero="o" />
</g:if>
<g:else>

    <g:if test="${aprobacionInstance?.fecha}">
        <div class="row">
            <div class="col-md-2">
                Fecha
            </div>
            
            <div class="col-md-3">
                <g:formatDate date="${aprobacionInstance?.fecha}" format="dd-MM-yyyy" />
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${aprobacionInstance?.fechaRealizacion}">
        <div class="row">
            <div class="col-md-2">
                Fecha Realizacion
            </div>
            
            <div class="col-md-3">
                <g:formatDate date="${aprobacionInstance?.fechaRealizacion}" format="dd-MM-yyyy" />
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${aprobacionInstance?.observaciones}">
        <div class="row">
            <div class="col-md-2">
                Observaciones
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${aprobacionInstance}" field="observaciones"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${aprobacionInstance?.asistentes}">
        <div class="row">
            <div class="col-md-2">
                Asistentes
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${aprobacionInstance}" field="asistentes"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${aprobacionInstance?.pathPdf}">
        <div class="row">
            <div class="col-md-2">
                Path Pdf
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${aprobacionInstance}" field="pathPdf"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${aprobacionInstance?.numero}">
        <div class="row">
            <div class="col-md-2">
                Numero
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${aprobacionInstance}" field="numero"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${aprobacionInstance?.aprobada}">
        <div class="row">
            <div class="col-md-2">
                Aprobada
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${aprobacionInstance}" field="aprobada"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${aprobacionInstance?.creadoPor}">
        <div class="row">
            <div class="col-md-2">
                Creado Por
            </div>
            
            <div class="col-md-3">
                ${aprobacionInstance?.creadoPor?.encodeAsHTML()}
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${aprobacionInstance?.firmaDireccionPlanificacion}">
        <div class="row">
            <div class="col-md-2">
                Firma Direccion Planificacion
            </div>
            
            <div class="col-md-3">
                ${aprobacionInstance?.firmaDireccionPlanificacion?.encodeAsHTML()}
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${aprobacionInstance?.firmaGerenciaTecnica}">
        <div class="row">
            <div class="col-md-2">
                Firma Gerencia Tecnica
            </div>
            
            <div class="col-md-3">
                ${aprobacionInstance?.firmaGerenciaTecnica?.encodeAsHTML()}
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${aprobacionInstance?.firmaGerenciaPlanificacion}">
        <div class="row">
            <div class="col-md-2">
                Firma Gerencia Planificacion
            </div>
            
            <div class="col-md-3">
                ${aprobacionInstance?.firmaGerenciaPlanificacion?.encodeAsHTML()}
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${aprobacionInstance?.solicitudes}">
        <div class="row">
            <div class="col-md-2">
                Solicitudes
            </div>
            
            <div class="col-md-3">
                <ul>
                    <g:each in="${aprobacionInstance.solicitudes}" var="s">
                        <li>${s?.encodeAsHTML()}</li>
                    </g:each>
                </ul>
            </div>
            
        </div>
    </g:if>
    
</g:else>