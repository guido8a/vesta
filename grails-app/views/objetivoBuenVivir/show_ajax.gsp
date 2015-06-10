
<%@ page import="vesta.proyectos.ObjetivoBuenVivir" %>

<g:if test="${!objetivoBuenVivirInstance}">
    <elm:notFound elem="ObjetivoBuenVivir" genero="o" />
</g:if>
<g:else>
    <div class="modal-contenido">

        <g:if test="${objetivoBuenVivirInstance?.codigo}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Codigo
                </div>
                
                <div class="col-md-4">
                    <g:fieldValue bean="${objetivoBuenVivirInstance}" field="codigo"/>
                </div>
                
            </div>
        </g:if>
    
        <g:if test="${objetivoBuenVivirInstance?.descripcion}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Descripcion
                </div>
                
                <div class="col-md-4">
                    <g:fieldValue bean="${objetivoBuenVivirInstance}" field="descripcion"/>
                </div>
                
            </div>
        </g:if>
    
    </div>
</g:else>