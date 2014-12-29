
<%@ page import="vesta.parametros.CargoPersonal" %>

<g:if test="${!cargoPersonalInstance}">
    <elm:notFound elem="CargoPersonal" genero="o" />
</g:if>
<g:else>

    <g:if test="${cargoPersonalInstance?.codigo}">
        <div class="row">
            <div class="col-md-2 show-label">
                Código
            </div>

            <div class="col-md-3">
                <g:fieldValue bean="${cargoPersonalInstance}" field="codigo"/>
            </div>

        </div>
    </g:if>

    <g:if test="${cargoPersonalInstance?.descripcion}">
        <div class="row">
            <div class="col-md-2 show-label">
                Descripción
            </div>
            
            <div class="col-md-5">
                <g:fieldValue bean="${cargoPersonalInstance}" field="descripcion"/>
            </div>
            
        </div>
    </g:if>
    

    
</g:else>