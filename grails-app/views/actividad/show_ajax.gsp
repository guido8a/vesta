
<%@ page import="vesta.poa.Actividad" %>

<g:if test="${!actividadInstance}">
    <elm:notFound elem="Actividad" genero="o" />
</g:if>
<g:else>

    <g:if test="${actividadInstance?.codigo}">
        <div class="row">
            <div class="col-md-2">
                Codigo
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${actividadInstance}" field="codigo"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${actividadInstance?.descripcion}">
        <div class="row">
            <div class="col-md-2">
                Descripcion
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${actividadInstance}" field="descripcion"/>
            </div>
            
        </div>
    </g:if>
    
</g:else>