
<%@ page import="vesta.poaCorrientes.MacroActividad" %>

<g:if test="${!macroActividadInstance}">
    <elm:notFound elem="MacroActividad" genero="o" />
</g:if>
<g:else>
    <div class="modal-contenido">

        <g:if test="${macroActividadInstance?.objetivoGastoCorriente}">
            <div class="row">
                <div class="col-md-4 show-label">
                    Objetivo de Gasto Corriente
                </div>

                <div class="col-md-4">
                    ${macroActividadInstance?.objetivoGastoCorriente?.encodeAsHTML()}
                </div>

            </div>
        </g:if>

        <g:if test="${macroActividadInstance?.descripcion}">
            <div class="row">
                <div class="col-md-4 show-label">
                    Descripción
                </div>
                
                <div class="col-md-4">
                    <g:fieldValue bean="${macroActividadInstance}" field="descripcion"/>
                </div>
                
            </div>
        </g:if>
    
    </div>
</g:else>