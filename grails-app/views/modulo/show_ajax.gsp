
<%@ page import="vesta.seguridad.Modulo" %>

<g:if test="${!moduloInstance}">
    <elm:notFound elem="Modulo" genero="o" />
</g:if>
<g:else>

    <g:if test="${moduloInstance?.descripcion}">
        <div class="row">
            <div class="col-md-2 show-label">
                Descripcion
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${moduloInstance}" field="descripcion"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${moduloInstance?.nombre}">
        <div class="row">
            <div class="col-md-2 show-label">
                Nombre
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${moduloInstance}" field="nombre"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${moduloInstance?.orden}">
        <div class="row">
            <div class="col-md-2 show-label">
                Orden
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${moduloInstance}" field="orden"/>
            </div>
            
        </div>
    </g:if>
    
</g:else>