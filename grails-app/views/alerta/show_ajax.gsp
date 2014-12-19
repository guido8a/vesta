
<%@ page import="vesta.alertas.Alerta" %>

<g:if test="${!alertaInstance}">
    <elm:notFound elem="Alerta" genero="o" />
</g:if>
<g:else>

    <g:if test="${alertaInstance?.from}">
        <div class="row">
            <div class="col-md-2">
                From
            </div>
            
            <div class="col-md-3">
                ${alertaInstance?.from?.encodeAsHTML()}
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${alertaInstance?.persona}">
        <div class="row">
            <div class="col-md-2">
                Usro
            </div>
            
            <div class="col-md-3">
                ${alertaInstance?.persona?.encodeAsHTML()}
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${alertaInstance?.fechaEnvio}">
        <div class="row">
            <div class="col-md-2">
                Fecenvio
            </div>
            
            <div class="col-md-3">
                <g:formatDate date="${alertaInstance?.fechaEnvio}" format="dd-MM-yyyy" />
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${alertaInstance?.fechaRecibido}">
        <div class="row">
            <div class="col-md-2">
                Fecrecibido
            </div>
            
            <div class="col-md-3">
                <g:formatDate date="${alertaInstance?.fechaRecibido}" format="dd-MM-yyyy" />
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${alertaInstance?.mensaje}">
        <div class="row">
            <div class="col-md-2">
                Mensaje
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${alertaInstance}" field="mensaje"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${alertaInstance?.controlador}">
        <div class="row">
            <div class="col-md-2">
                Controlador
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${alertaInstance}" field="controlador"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${alertaInstance?.accion}">
        <div class="row">
            <div class="col-md-2">
                Accion
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${alertaInstance}" field="accion"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${alertaInstance?.id_remoto}">
        <div class="row">
            <div class="col-md-2">
                Idremoto
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${alertaInstance}" field="id_remoto"/>
            </div>
            
        </div>
    </g:if>
    
</g:else>