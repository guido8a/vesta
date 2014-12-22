
<%@ page import="vesta.parametros.Cuatrimestre" %>

<g:if test="${!cuatrimestreInstance}">
    <elm:notFound elem="Cuatrimestre" genero="o" />
</g:if>
<g:else>

    <g:if test="${cuatrimestreInstance?.numero}">
        <div class="row">
            <div class="col-md-2">
                Numero
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${cuatrimestreInstance}" field="numero"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${cuatrimestreInstance?.descripcion}">
        <div class="row">
            <div class="col-md-2">
                Descripcion
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${cuatrimestreInstance}" field="descripcion"/>
            </div>
            
        </div>
    </g:if>
    
</g:else>