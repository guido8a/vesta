
<%@ page import="vesta.hitos.AvanceFisico" %>

<g:if test="${!avanceFisicoInstance}">
    <elm:notFound elem="AvanceFisico" genero="o" />
</g:if>
<g:else>

    <g:if test="${avanceFisicoInstance?.proceso}">
        <div class="row">
            <div class="col-md-2">
                Proceso
            </div>
            
            <div class="col-md-3">
                ${avanceFisicoInstance?.proceso?.encodeAsHTML()}
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${avanceFisicoInstance?.observaciones}">
        <div class="row">
            <div class="col-md-2">
                Observaciones
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${avanceFisicoInstance}" field="observaciones"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${avanceFisicoInstance?.completado}">
        <div class="row">
            <div class="col-md-2">
                Completado
            </div>
            
            <div class="col-md-3">
                <g:formatDate date="${avanceFisicoInstance?.completado}" format="dd-MM-yyyy" />
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${avanceFisicoInstance?.inicio}">
        <div class="row">
            <div class="col-md-2">
                Inicio
            </div>
            
            <div class="col-md-3">
                <g:formatDate date="${avanceFisicoInstance?.inicio}" format="dd-MM-yyyy" />
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${avanceFisicoInstance?.fin}">
        <div class="row">
            <div class="col-md-2">
                Fin
            </div>
            
            <div class="col-md-3">
                <g:formatDate date="${avanceFisicoInstance?.fin}" format="dd-MM-yyyy" />
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${avanceFisicoInstance?.avance}">
        <div class="row">
            <div class="col-md-2">
                Avance
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${avanceFisicoInstance}" field="avance"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${avanceFisicoInstance?.fecha}">
        <div class="row">
            <div class="col-md-2">
                Fecha
            </div>
            
            <div class="col-md-3">
                <g:formatDate date="${avanceFisicoInstance?.fecha}" format="dd-MM-yyyy" />
            </div>
            
        </div>
    </g:if>
    
</g:else>