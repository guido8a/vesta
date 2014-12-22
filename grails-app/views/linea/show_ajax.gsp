
<%@ page import="vesta.parametros.Linea" %>

<g:if test="${!lineaInstance}">
    <elm:notFound elem="Linea" genero="o" />
</g:if>
<g:else>

    <g:if test="${lineaInstance?.descripcion}">
        <div class="row">
            <div class="col-md-2">
                Descripcion
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${lineaInstance}" field="descripcion"/>
            </div>
            
        </div>
    </g:if>
    
</g:else>