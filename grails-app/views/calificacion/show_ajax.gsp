
<%@ page import="vesta.parametros.Calificacion" %>

<g:if test="${!calificacionInstance}">
    <elm:notFound elem="Calificacion" genero="o" />
</g:if>
<g:else>

    <g:if test="${calificacionInstance?.descripcion}">
        <div class="row">
            <div class="col-md-2 show-label">
                Descripcion
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${calificacionInstance}" field="descripcion"/>
            </div>
            
        </div>
    </g:if>
    
</g:else>