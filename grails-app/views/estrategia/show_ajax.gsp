
<%@ page import="vesta.proyectos.Estrategia" %>

<g:if test="${!estrategiaInstance}">
    <elm:notFound elem="Estrategia" genero="o" />
</g:if>
<g:else>

    <g:if test="${estrategiaInstance?.orden}">
        <div class="row">
            <div class="col-md-2">
                Orden
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${estrategiaInstance}" field="orden"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${estrategiaInstance?.descripcion}">
        <div class="row">
            <div class="col-md-2">
                Descripción
            </div>
            
            <div class="col-md-9">
                <g:fieldValue bean="${estrategiaInstance}" field="descripcion"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${estrategiaInstance?.objetivoEstrategico}">
        <div class="row">
            <div class="col-md-2">
                Objetivo Estratégico
            </div>
            
            <div class="col-md-9">
                ${estrategiaInstance?.objetivoEstrategico?.encodeAsHTML()}
            </div>
            
        </div>
    </g:if>
    
</g:else>