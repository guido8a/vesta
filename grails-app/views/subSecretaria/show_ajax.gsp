
<%@ page import="vesta.parametros.SubSecretaria" %>

<g:if test="${!subSecretariaInstance}">
    <elm:notFound elem="SubSecretaria" genero="o" />
</g:if>
<g:else>

    <g:if test="${subSecretariaInstance?.entidad}">
        <div class="row">
            <div class="col-md-2">
                Entidad
            </div>
            
            <div class="col-md-3">
                ${subSecretariaInstance?.entidad?.encodeAsHTML()}
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${subSecretariaInstance?.nombre}">
        <div class="row">
            <div class="col-md-2">
                Nombre
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${subSecretariaInstance}" field="nombre"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${subSecretariaInstance?.titulo}">
        <div class="row">
            <div class="col-md-2">
                Titulo
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${subSecretariaInstance}" field="titulo"/>
            </div>
            
        </div>
    </g:if>
    
</g:else>