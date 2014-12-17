
<%@ page import="vesta.poa.ProgramacionAsignacion" %>

<g:if test="${!programacionAsignacionInstance}">
    <elm:notFound elem="ProgramacionAsignacion" genero="o" />
</g:if>
<g:else>

    <g:if test="${programacionAsignacionInstance?.asignacion}">
        <div class="row">
            <div class="col-md-2">
                Asignacion
            </div>
            
            <div class="col-md-3">
                ${programacionAsignacionInstance?.asignacion?.encodeAsHTML()}
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${programacionAsignacionInstance?.distribucion}">
        <div class="row">
            <div class="col-md-2">
                Distribucion
            </div>
            
            <div class="col-md-3">
                ${programacionAsignacionInstance?.distribucion?.encodeAsHTML()}
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${programacionAsignacionInstance?.mes}">
        <div class="row">
            <div class="col-md-2">
                Mes
            </div>
            
            <div class="col-md-3">
                ${programacionAsignacionInstance?.mes?.encodeAsHTML()}
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${programacionAsignacionInstance?.padre}">
        <div class="row">
            <div class="col-md-2">
                Padre
            </div>
            
            <div class="col-md-3">
                ${programacionAsignacionInstance?.padre?.encodeAsHTML()}
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${programacionAsignacionInstance?.modificacion}">
        <div class="row">
            <div class="col-md-2">
                Modificacion
            </div>
            
            <div class="col-md-3">
                ${programacionAsignacionInstance?.modificacion?.encodeAsHTML()}
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${programacionAsignacionInstance?.valor}">
        <div class="row">
            <div class="col-md-2">
                Valor
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${programacionAsignacionInstance}" field="valor"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${programacionAsignacionInstance?.estado}">
        <div class="row">
            <div class="col-md-2">
                Estado
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${programacionAsignacionInstance}" field="estado"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${programacionAsignacionInstance?.cronograma}">
        <div class="row">
            <div class="col-md-2">
                Cronograma
            </div>
            
            <div class="col-md-3">
                ${programacionAsignacionInstance?.cronograma?.encodeAsHTML()}
            </div>
            
        </div>
    </g:if>
    
</g:else>