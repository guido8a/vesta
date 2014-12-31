
<%@ page import="vesta.parametros.poaPac.Anio" %>

<g:if test="${!anioInstance}">
    <elm:notFound elem="Anio" genero="o" />
</g:if>
<g:else>
    <div class="modal-contenido">

        <g:if test="${anioInstance?.anio}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Año
                </div>
                
                <div class="col-md-4">
                    <g:fieldValue bean="${anioInstance}" field="anio"/>
                </div>
                
            </div>
        </g:if>
    
        %{--<g:if test="${anioInstance?.estado}">--}%
            %{--<div class="row">--}%
                %{--<div class="col-md-3 show-label">--}%
                    %{--Estado--}%
                %{--</div>--}%
                %{----}%
                %{--<div class="col-md-4">--}%
                    %{--<g:fieldValue bean="${anioInstance}" field="estado"/>--}%
                %{--</div>--}%
                %{----}%
            %{--</div>--}%
        %{--</g:if>--}%
    
    </div>
</g:else>