
<%@ page import="vesta.poa.Asignacion" %>

<g:if test="${!asignacionInstance}">
    <elm:notFound elem="Asignacion" genero="o" />
</g:if>
<g:else>

    <g:if test="${asignacionInstance?.anio}">
        <div class="row">
            <div class="col-md-2">
                Anio
            </div>
            
            <div class="col-md-3">
                ${asignacionInstance?.anio?.encodeAsHTML()}
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${asignacionInstance?.fuente}">
        <div class="row">
            <div class="col-md-2">
                Fuente
            </div>
            
            <div class="col-md-3">
                ${asignacionInstance?.fuente?.encodeAsHTML()}
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${asignacionInstance?.marcoLogico}">
        <div class="row">
            <div class="col-md-2">
                Marco Logico
            </div>
            
            <div class="col-md-3">
                ${asignacionInstance?.marcoLogico?.encodeAsHTML()}
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${asignacionInstance?.actividad}">
        <div class="row">
            <div class="col-md-2">
                Actividad
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${asignacionInstance}" field="actividad"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${asignacionInstance?.presupuesto}">
        <div class="row">
            <div class="col-md-2">
                Presupuesto
            </div>
            
            <div class="col-md-3">
                ${asignacionInstance?.presupuesto?.encodeAsHTML()}
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${asignacionInstance?.tipoGasto}">
        <div class="row">
            <div class="col-md-2">
                Tipo Gasto
            </div>
            
            <div class="col-md-3">
                ${asignacionInstance?.tipoGasto?.encodeAsHTML()}
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${asignacionInstance?.componente}">
        <div class="row">
            <div class="col-md-2">
                Componente
            </div>
            
            <div class="col-md-3">
                ${asignacionInstance?.componente?.encodeAsHTML()}
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${asignacionInstance?.planificado}">
        <div class="row">
            <div class="col-md-2">
                Planificado
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${asignacionInstance}" field="planificado"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${asignacionInstance?.redistribucion}">
        <div class="row">
            <div class="col-md-2">
                Redistribucion
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${asignacionInstance}" field="redistribucion"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${asignacionInstance?.unidad}">
        <div class="row">
            <div class="col-md-2">
                Unidad
            </div>
            
            <div class="col-md-3">
                ${asignacionInstance?.unidad?.encodeAsHTML()}
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${asignacionInstance?.reubicada}">
        <div class="row">
            <div class="col-md-2">
                Reubicada
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${asignacionInstance}" field="reubicada"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${asignacionInstance?.programa}">
        <div class="row">
            <div class="col-md-2">
                Programa
            </div>
            
            <div class="col-md-3">
                ${asignacionInstance?.programa?.encodeAsHTML()}
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${asignacionInstance?.meta}">
        <div class="row">
            <div class="col-md-2">
                Meta
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${asignacionInstance}" field="meta"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${asignacionInstance?.indicador}">
        <div class="row">
            <div class="col-md-2">
                Indicador
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${asignacionInstance}" field="indicador"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${asignacionInstance?.padre}">
        <div class="row">
            <div class="col-md-2">
                Padre
            </div>
            
            <div class="col-md-3">
                ${asignacionInstance?.padre?.encodeAsHTML()}
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${asignacionInstance?.priorizado}">
        <div class="row">
            <div class="col-md-2">
                Priorizado
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${asignacionInstance}" field="priorizado"/>
            </div>
            
        </div>
    </g:if>
    
</g:else>