
<%@ page import="vesta.parametros.CodigoComprasPublicas" %>

<g:if test="${!codigoComprasPublicasInstance}">
    <elm:notFound elem="CodigoComprasPublicas" genero="o" />
</g:if>
<g:else>

    <g:if test="${codigoComprasPublicasInstance?.padre}">
        <div class="row">
            <div class="col-md-2">
                Padre
            </div>
            
            <div class="col-md-3">
                ${codigoComprasPublicasInstance?.padre?.encodeAsHTML()}
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${codigoComprasPublicasInstance?.numero}">
        <div class="row">
            <div class="col-md-2">
                Numero
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${codigoComprasPublicasInstance}" field="numero"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${codigoComprasPublicasInstance?.descripcion}">
        <div class="row">
            <div class="col-md-2">
                Descripcion
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${codigoComprasPublicasInstance}" field="descripcion"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${codigoComprasPublicasInstance?.nivel}">
        <div class="row">
            <div class="col-md-2">
                Nivel
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${codigoComprasPublicasInstance}" field="nivel"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${codigoComprasPublicasInstance?.fecha}">
        <div class="row">
            <div class="col-md-2">
                Fecha
            </div>
            
            <div class="col-md-3">
                <g:formatDate date="${codigoComprasPublicasInstance?.fecha}" format="dd-MM-yyyy" />
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${codigoComprasPublicasInstance?.movimiento}">
        <div class="row">
            <div class="col-md-2">
                Movimiento
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${codigoComprasPublicasInstance}" field="movimiento"/>
            </div>
            
        </div>
    </g:if>
    
</g:else>