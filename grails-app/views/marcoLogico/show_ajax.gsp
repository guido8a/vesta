<%@ page import="vesta.proyectos.MarcoLogico" %>

<g:if test="${!marcoLogicoInstance}">
    <elm:notFound elem="MarcoLogico" genero="o"/>
</g:if>
<g:else>
    <div class="modal-contenido">

        <g:if test="${marcoLogicoInstance?.proyecto}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Proyecto
                </div>

                <div class="col-md-4">
                    ${marcoLogicoInstance?.proyecto?.encodeAsHTML()}
                </div>

            </div>
        </g:if>

        <g:if test="${marcoLogicoInstance?.tipoElemento}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Tipo Elemento
                </div>

                <div class="col-md-4">
                    ${marcoLogicoInstance?.tipoElemento?.encodeAsHTML()}
                </div>

            </div>
        </g:if>

        <g:if test="${marcoLogicoInstance?.marcoLogico}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Marco Logico
                </div>

                <div class="col-md-4">
                    ${marcoLogicoInstance?.marcoLogico?.encodeAsHTML()}
                </div>

            </div>
        </g:if>

        <g:if test="${marcoLogicoInstance?.modificacionProyecto}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Modificacion Proyecto
                </div>

                <div class="col-md-4">
                    ${marcoLogicoInstance?.modificacionProyecto?.encodeAsHTML()}
                </div>

            </div>
        </g:if>

        <g:if test="${marcoLogicoInstance?.objeto}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Objeto
                </div>

                <div class="col-md-4">
                    <g:fieldValue bean="${marcoLogicoInstance}" field="objeto"/>
                </div>

            </div>
        </g:if>

        <g:if test="${marcoLogicoInstance?.monto}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Monto
                </div>

                <div class="col-md-4">
                    <g:fieldValue bean="${marcoLogicoInstance}" field="monto"/>
                </div>

            </div>
        </g:if>

        <g:if test="${marcoLogicoInstance?.estado}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Estado
                </div>

                <div class="col-md-4">
                    <g:fieldValue bean="${marcoLogicoInstance}" field="estado"/>
                </div>

            </div>
        </g:if>

        <g:if test="${marcoLogicoInstance?.padreMod}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Padre Mod
                </div>

                <div class="col-md-4">
                    ${marcoLogicoInstance?.padreMod?.encodeAsHTML()}
                </div>

            </div>
        </g:if>

        <g:if test="${marcoLogicoInstance?.categoria}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Categoria
                </div>

                <div class="col-md-4">
                    ${marcoLogicoInstance?.categoria?.encodeAsHTML()}
                </div>

            </div>
        </g:if>

        <g:if test="${marcoLogicoInstance?.responsable}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Responsable
                </div>

                <div class="col-md-4">
                    ${marcoLogicoInstance?.responsable?.encodeAsHTML()}
                </div>

            </div>
        </g:if>

        <g:if test="${marcoLogicoInstance?.fechaFin}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Fecha Fin
                </div>

                <div class="col-md-4">
                    <g:formatDate date="${marcoLogicoInstance?.fechaFin}" format="dd-MM-yyyy"/>
                </div>

            </div>
        </g:if>

        <g:if test="${marcoLogicoInstance?.fechaInicio}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Fecha Inicio
                </div>

                <div class="col-md-4">
                    <g:formatDate date="${marcoLogicoInstance?.fechaInicio}" format="dd-MM-yyyy"/>
                </div>

            </div>
        </g:if>

        <g:if test="${marcoLogicoInstance?.tieneAsignacion}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Tiene Asignacion
                </div>

                <div class="col-md-4">
                    <g:fieldValue bean="${marcoLogicoInstance}" field="tieneAsignacion"/>
                </div>

            </div>
        </g:if>

        <g:if test="${marcoLogicoInstance?.numeroComp}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Numero Comp
                </div>

                <div class="col-md-4">
                    <g:fieldValue bean="${marcoLogicoInstance}" field="numeroComp"/>
                </div>

            </div>
        </g:if>

        <g:if test="${marcoLogicoInstance?.numero}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Numero
                </div>

                <div class="col-md-4">
                    <g:fieldValue bean="${marcoLogicoInstance}" field="numero"/>
                </div>

            </div>
        </g:if>

    </div>
</g:else>