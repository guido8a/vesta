
<%@ page import="vesta.parametros.UnidadEjecutora" %>

<g:if test="${!unidadEjecutoraInstance}">
    <elm:notFound elem="UnidadEjecutora" genero="o" />
</g:if>
<g:else>

    <g:if test="${unidadEjecutoraInstance?.tipoInstitucion}">
        <div class="row">
            <div class="col-md-2">
                Tipo Institucion
            </div>
            
            <div class="col-md-3">
                ${unidadEjecutoraInstance?.tipoInstitucion?.encodeAsHTML()}
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${unidadEjecutoraInstance?.provincia}">
        <div class="row">
            <div class="col-md-2">
                Provincia
            </div>
            
            <div class="col-md-3">
                ${unidadEjecutoraInstance?.provincia?.encodeAsHTML()}
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${unidadEjecutoraInstance?.codigo}">
        <div class="row">
            <div class="col-md-2">
                Codigo
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${unidadEjecutoraInstance}" field="codigo"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${unidadEjecutoraInstance?.fechaInicio}">
        <div class="row">
            <div class="col-md-2">
                Fecha Inicio
            </div>
            
            <div class="col-md-3">
                <g:formatDate date="${unidadEjecutoraInstance?.fechaInicio}" format="dd-MM-yyyy" />
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${unidadEjecutoraInstance?.fechaFin}">
        <div class="row">
            <div class="col-md-2">
                Fecha Fin
            </div>
            
            <div class="col-md-3">
                <g:formatDate date="${unidadEjecutoraInstance?.fechaFin}" format="dd-MM-yyyy" />
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${unidadEjecutoraInstance?.padre}">
        <div class="row">
            <div class="col-md-2">
                Padre
            </div>
            
            <div class="col-md-3">
                ${unidadEjecutoraInstance?.padre?.encodeAsHTML()}
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${unidadEjecutoraInstance?.nombre}">
        <div class="row">
            <div class="col-md-2">
                Nombre
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${unidadEjecutoraInstance}" field="nombre"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${unidadEjecutoraInstance?.direccion}">
        <div class="row">
            <div class="col-md-2">
                Direccion
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${unidadEjecutoraInstance}" field="direccion"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${unidadEjecutoraInstance?.sigla}">
        <div class="row">
            <div class="col-md-2">
                Sigla
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${unidadEjecutoraInstance}" field="sigla"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${unidadEjecutoraInstance?.objetivo}">
        <div class="row">
            <div class="col-md-2">
                Objetivo
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${unidadEjecutoraInstance}" field="objetivo"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${unidadEjecutoraInstance?.telefono}">
        <div class="row">
            <div class="col-md-2">
                Telefono
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${unidadEjecutoraInstance}" field="telefono"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${unidadEjecutoraInstance?.fax}">
        <div class="row">
            <div class="col-md-2">
                Fax
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${unidadEjecutoraInstance}" field="fax"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${unidadEjecutoraInstance?.email}">
        <div class="row">
            <div class="col-md-2">
                Email
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${unidadEjecutoraInstance}" field="email"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${unidadEjecutoraInstance?.observaciones}">
        <div class="row">
            <div class="col-md-2">
                Observaciones
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${unidadEjecutoraInstance}" field="observaciones"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${unidadEjecutoraInstance?.objetivoUnidad}">
        <div class="row">
            <div class="col-md-2">
                Objetivo Unidad
            </div>
            
            <div class="col-md-3">
                ${unidadEjecutoraInstance?.objetivoUnidad?.encodeAsHTML()}
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${unidadEjecutoraInstance?.orden}">
        <div class="row">
            <div class="col-md-2">
                Orden
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${unidadEjecutoraInstance}" field="orden"/>
            </div>
            
        </div>
    </g:if>
    
</g:else>