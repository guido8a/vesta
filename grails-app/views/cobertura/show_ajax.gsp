
<%@ page import="vesta.parametros.Cobertura" %>

<g:if test="${!coberturaInstance}">
    <elm:notFound elem="Cobertura" genero="o" />
</g:if>
<g:else>

    <g:if test="${coberturaInstance?.descripcion}">
        <div class="row">
            <div class="col-md-2 show-label">
                Descripcion
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${coberturaInstance}" field="descripcion"/>
            </div>
            
        </div>
    </g:if>
    
</g:else>