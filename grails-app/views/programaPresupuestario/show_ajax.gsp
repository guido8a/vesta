
<%@ page import="vesta.parametros.poaPac.ProgramaPresupuestario" %>

<g:if test="${!programaPresupuestarioInstance}">
    <elm:notFound elem="ProgramaPresupuestario" genero="o" />
</g:if>
<g:else>
    <div class="modal-contenido">

        <g:if test="${programaPresupuestarioInstance?.codigo}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Codigo
                </div>
                
                <div class="col-md-4">
                    <g:fieldValue bean="${programaPresupuestarioInstance}" field="codigo"/>
                </div>
                
            </div>
        </g:if>
    
        <g:if test="${programaPresupuestarioInstance?.descripcion}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Descripcion
                </div>
                
                <div class="col-md-4">
                    <g:fieldValue bean="${programaPresupuestarioInstance}" field="descripcion"/>
                </div>
                
            </div>
        </g:if>
    
    </div>
</g:else>