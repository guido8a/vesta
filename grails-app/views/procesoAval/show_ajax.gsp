
<%@ page import="vesta.avales.ProcesoAval" %>

<g:if test="${!procesoAvalInstance}">
    <elm:notFound elem="ProcesoAval" genero="o" />
</g:if>
<g:else>

    <g:if test="${procesoAvalInstance?.nombre}">
        <div class="row">
            <div class="col-md-2 show-label">
                Nombre
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${procesoAvalInstance}" field="nombre"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${procesoAvalInstance?.fechaFin}">
        <div class="row">
            <div class="col-md-2 show-label">
                Fecha Fin
            </div>
            
            <div class="col-md-3">
                <g:formatDate date="${procesoAvalInstance?.fechaFin}" format="dd-MM-yyyy" />
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${procesoAvalInstance?.fechaInicio}">
        <div class="row">
            <div class="col-md-2 show-label">
                Fecha Inicio
            </div>
            
            <div class="col-md-3">
                <g:formatDate date="${procesoAvalInstance?.fechaInicio}" format="dd-MM-yyyy" />
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${procesoAvalInstance?.informar}">
        <div class="row">
            <div class="col-md-2 show-label">
                Informar
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${procesoAvalInstance}" field="informar"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${procesoAvalInstance?.proyecto}">
        <div class="row">
            <div class="col-md-2 show-label">
                Proyecto
            </div>
            
            <div class="col-md-3">
                ${procesoAvalInstance?.proyecto?.encodeAsHTML()}
            </div>
            
        </div>
    </g:if>
    
</g:else>