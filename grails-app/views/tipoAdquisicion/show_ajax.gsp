
<%@ page import="vesta.parametros.TipoAdquisicion" %>

<g:if test="${!tipoAdquisicionInstance}">
    <elm:notFound elem="TipoAdquisicion" genero="o" />
</g:if>
<g:else>

    <g:if test="${tipoAdquisicionInstance?.descripcion}">
        <div class="row">
            <div class="col-md-2 show-label">
                Descripcion
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${tipoAdquisicionInstance}" field="descripcion"/>
            </div>
            
        </div>
    </g:if>
    
</g:else>