
<%@ page import="vesta.hitos.Hito" %>

<g:if test="${!hitoInstance}">
    <elm:notFound elem="Hito" genero="o" />
</g:if>
<g:else>

    <g:if test="${hitoInstance?.fecha}">
        <div class="row">
            <div class="col-md-2 show-label">
                Fecha
            </div>
            
            <div class="col-md-3">
                <g:formatDate date="${hitoInstance?.fecha}" format="dd-MM-yyyy" />
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${hitoInstance?.fechaCumplimiento}">
        <div class="row">
            <div class="col-md-2 show-label">
                Fecha Cumplimiento
            </div>
            
            <div class="col-md-3">
                <g:formatDate date="${hitoInstance?.fechaCumplimiento}" format="dd-MM-yyyy" />
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${hitoInstance?.fechaPlanificada}">
        <div class="row">
            <div class="col-md-2 show-label">
                Fecha Planificada
            </div>
            
            <div class="col-md-3">
                <g:formatDate date="${hitoInstance?.fechaPlanificada}" format="dd-MM-yyyy" />
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${hitoInstance?.inicio}">
        <div class="row">
            <div class="col-md-2 show-label">
                Inicio
            </div>
            
            <div class="col-md-3">
                <g:formatDate date="${hitoInstance?.inicio}" format="dd-MM-yyyy" />
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${hitoInstance?.descripcion}">
        <div class="row">
            <div class="col-md-2 show-label">
                Descripcion
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${hitoInstance}" field="descripcion"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${hitoInstance?.avanceFinanciero}">
        <div class="row">
            <div class="col-md-2 show-label">
                Avance Financiero
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${hitoInstance}" field="avanceFinanciero"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${hitoInstance?.avanceFisico}">
        <div class="row">
            <div class="col-md-2 show-label">
                Avance Fisico
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${hitoInstance}" field="avanceFisico"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${hitoInstance?.tipo}">
        <div class="row">
            <div class="col-md-2 show-label">
                Tipo
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${hitoInstance}" field="tipo"/>
            </div>
            
        </div>
    </g:if>
    
</g:else>