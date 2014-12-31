
<%@ page import="vesta.parametros.poaPac.Fuente" %>

<g:if test="${!fuenteInstance}">
    <elm:notFound elem="Fuente" genero="o" />
</g:if>
<g:else>
    <div class="modal-contenido">

        <g:if test="${fuenteInstance?.codigo}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Codigo
                </div>
                
                <div class="col-md-4">
                    <g:fieldValue bean="${fuenteInstance}" field="codigo"/>
                </div>
                
            </div>
        </g:if>
    
        <g:if test="${fuenteInstance?.descripcion}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Descripcion
                </div>
                
                <div class="col-md-4">
                    <g:fieldValue bean="${fuenteInstance}" field="descripcion"/>
                </div>
                
            </div>
        </g:if>
    
    </div>
</g:else>