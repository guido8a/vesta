
<%@ page import="vesta.parametros.TipoInstitucion" %>

<g:if test="${!tipoInstitucionInstance}">
    <elm:notFound elem="TipoInstitucion" genero="o" />
</g:if>
<g:else>

    <g:if test="${tipoInstitucionInstance?.codigo}">
        <div class="row">
            <div class="col-md-2">
                Codigo
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${tipoInstitucionInstance}" field="codigo"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${tipoInstitucionInstance?.descripcion}">
        <div class="row">
            <div class="col-md-2">
                Descripcion
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${tipoInstitucionInstance}" field="descripcion"/>
            </div>
            
        </div>
    </g:if>
    
</g:else>