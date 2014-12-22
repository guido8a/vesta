
<%@ page import="vesta.parametros.Contratista" %>

<g:if test="${!contratistaInstance}">
    <elm:notFound elem="Contratista" genero="o" />
</g:if>
<g:else>

    <g:if test="${contratistaInstance?.ruc}">
        <div class="row">
            <div class="col-md-2">
                Ruc
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${contratistaInstance}" field="ruc"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${contratistaInstance?.direccion}">
        <div class="row">
            <div class="col-md-2">
                Direccion
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${contratistaInstance}" field="direccion"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${contratistaInstance?.fecha}">
        <div class="row">
            <div class="col-md-2">
                Fecha
            </div>
            
            <div class="col-md-3">
                <g:formatDate date="${contratistaInstance?.fecha}" format="dd-MM-yyyy" />
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${contratistaInstance?.nombreCont}">
        <div class="row">
            <div class="col-md-2">
                Nombre Cont
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${contratistaInstance}" field="nombreCont"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${contratistaInstance?.nombre}">
        <div class="row">
            <div class="col-md-2">
                Nombre
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${contratistaInstance}" field="nombre"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${contratistaInstance?.apellido}">
        <div class="row">
            <div class="col-md-2">
                Apellido
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${contratistaInstance}" field="apellido"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${contratistaInstance?.observaciones}">
        <div class="row">
            <div class="col-md-2">
                Observaciones
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${contratistaInstance}" field="observaciones"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${contratistaInstance?.telefono}">
        <div class="row">
            <div class="col-md-2">
                Telefono
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${contratistaInstance}" field="telefono"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${contratistaInstance?.mail}">
        <div class="row">
            <div class="col-md-2">
                Mail
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${contratistaInstance}" field="mail"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${contratistaInstance?.estado}">
        <div class="row">
            <div class="col-md-2">
                Estado
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${contratistaInstance}" field="estado"/>
            </div>
            
        </div>
    </g:if>
    
</g:else>