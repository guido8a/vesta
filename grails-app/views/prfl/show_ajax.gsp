
<%@ page import="vesta.seguridad.Prfl" %>

<g:if test="${!prflInstance}">
    <elm:notFound elem="Prfl" genero="o" />
</g:if>
<g:else>

    <g:if test="${prflInstance?.codigo}">
        <div class="row">
            <div class="col-md-2">
                Codigo
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${prflInstance}" field="codigo"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${prflInstance?.descripcion}">
        <div class="row">
            <div class="col-md-2">
                Descripcion
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${prflInstance}" field="descripcion"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${prflInstance?.nombre}">
        <div class="row">
            <div class="col-md-2">
                Nombre
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${prflInstance}" field="nombre"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${prflInstance?.observaciones}">
        <div class="row">
            <div class="col-md-2">
                Observaciones
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${prflInstance}" field="observaciones"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${prflInstance?.padre}">
        <div class="row">
            <div class="col-md-2">
                Padre
            </div>
            
            <div class="col-md-3">
                ${prflInstance?.padre?.encodeAsHTML()}
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${prflInstance?.perfiles}">
        <div class="row">
            <div class="col-md-2">
                Perfiles
            </div>
            
            <div class="col-md-3">
                <ul>
                    <g:each in="${prflInstance.perfiles}" var="p">
                        <li>${p?.encodeAsHTML()}</li>
                    </g:each>
                </ul>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${prflInstance?.permisos}">
        <div class="row">
            <div class="col-md-2">
                Permisos
            </div>
            
            <div class="col-md-3">
                <ul>
                    <g:each in="${prflInstance.permisos}" var="p">
                        <li>${p?.encodeAsHTML()}</li>
                    </g:each>
                </ul>
            </div>
            
        </div>
    </g:if>
    
</g:else>