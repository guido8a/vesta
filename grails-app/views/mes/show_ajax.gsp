
<%@ page import="vesta.parametros.poaPac.Mes" %>

<g:if test="${!mesInstance}">
    <elm:notFound elem="Mes" genero="o" />
</g:if>
<g:else>
    <div class="modal-contenido">

        <g:if test="${mesInstance?.numero}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Numero
                </div>
                
                <div class="col-md-4">
                    <g:fieldValue bean="${mesInstance}" field="numero"/>
                </div>
                
            </div>
        </g:if>
    
        <g:if test="${mesInstance?.descripcion}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Descripcion
                </div>
                
                <div class="col-md-4">
                    <g:fieldValue bean="${mesInstance}" field="descripcion"/>
                </div>
                
            </div>
        </g:if>
    
    </div>
</g:else>