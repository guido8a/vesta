<%@ page import="vesta.poaCorrientes.ObjetivoGastoCorriente" %>

<g:if test="${!objetivoGastoCorrienteInstance}">
    <elm:notFound elem="ObjetivoGastoCorriente" genero="o"/>
</g:if>
<g:else>
    <div class="modal-contenido">

        <g:if test="${objetivoGastoCorrienteInstance?.descripcion}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Descripción
                </div>

                <div class="col-md-8">
                    <g:fieldValue bean="${objetivoGastoCorrienteInstance}" field="descripcion"/>
                </div>

            </div>
        </g:if>

    </div>
</g:else>