
<%@ page import="vesta.parametros.PresupuestoUnidad" %>

<g:if test="${!presupuestoUnidadInstance}">
    <elm:notFound elem="PresupuestoUnidad" genero="o" />
</g:if>
<g:else>

    <g:if test="${presupuestoUnidadInstance?.unidad}">
        <div class="row">
            <div class="col-md-2 show-label">
                Unidad
            </div>
            
            <div class="col-md-3">
                ${presupuestoUnidadInstance?.unidad?.encodeAsHTML()}
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${presupuestoUnidadInstance?.anio}">
        <div class="row">
            <div class="col-md-2 show-label">
                Anio
            </div>
            
            <div class="col-md-3">
                ${presupuestoUnidadInstance?.anio?.encodeAsHTML()}
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${presupuestoUnidadInstance?.maxInversion}">
        <div class="row">
            <div class="col-md-2 show-label">
                Max Inversion
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${presupuestoUnidadInstance}" field="maxInversion"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${presupuestoUnidadInstance?.maxCorrientes}">
        <div class="row">
            <div class="col-md-2 show-label">
                Max Corrientes
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${presupuestoUnidadInstance}" field="maxCorrientes"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${presupuestoUnidadInstance?.ejeProgramatico}">
        <div class="row">
            <div class="col-md-2 show-label">
                Eje Programatico
            </div>
            
            <div class="col-md-3">
                ${presupuestoUnidadInstance?.ejeProgramatico?.encodeAsHTML()}
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${presupuestoUnidadInstance?.objetivoEstrategico}">
        <div class="row">
            <div class="col-md-2 show-label">
                Objetivo Estrategico
            </div>
            
            <div class="col-md-3">
                ${presupuestoUnidadInstance?.objetivoEstrategico?.encodeAsHTML()}
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${presupuestoUnidadInstance?.objetivoGobiernoResultado}">
        <div class="row">
            <div class="col-md-2 show-label">
                Objetivo Gobierno Resultado
            </div>
            
            <div class="col-md-3">
                ${presupuestoUnidadInstance?.objetivoGobiernoResultado?.encodeAsHTML()}
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${presupuestoUnidadInstance?.politica}">
        <div class="row">
            <div class="col-md-2 show-label">
                Politica
            </div>
            
            <div class="col-md-3">
                ${presupuestoUnidadInstance?.politica?.encodeAsHTML()}
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${presupuestoUnidadInstance?.aprobadoCorrientes}">
        <div class="row">
            <div class="col-md-2 show-label">
                Aprobado Corrientes
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${presupuestoUnidadInstance}" field="aprobadoCorrientes"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${presupuestoUnidadInstance?.aprobadoInversion}">
        <div class="row">
            <div class="col-md-2 show-label">
                Aprobado Inversion
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${presupuestoUnidadInstance}" field="aprobadoInversion"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${presupuestoUnidadInstance?.originalCorrientes}">
        <div class="row">
            <div class="col-md-2 show-label">
                Original Corrientes
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${presupuestoUnidadInstance}" field="originalCorrientes"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${presupuestoUnidadInstance?.originalInversion}">
        <div class="row">
            <div class="col-md-2 show-label">
                Original Inversion
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${presupuestoUnidadInstance}" field="originalInversion"/>
            </div>
            
        </div>
    </g:if>
    
</g:else>