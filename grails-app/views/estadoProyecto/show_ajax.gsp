
<%@ page import="vesta.parametros.EstadoProyecto" %>

<g:if test="${!estadoProyectoInstance}">
    <elm:notFound elem="EstadoProyecto" genero="o" />
</g:if>
<g:else>

    <g:if test="${estadoProyectoInstance?.descripcion}">
        <div class="row">
            <div class="col-md-2">
                Descripcion
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${estadoProyectoInstance}" field="descripcion"/>
            </div>
            
        </div>
    </g:if>
    
</g:else>