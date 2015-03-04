<%@ page import="vesta.parametros.UnidadEjecutora" %>

<g:if test="${!unidadEjecutoraInstance}">
    <elm:notFound elem="UnidadEjecutora" genero="o"/>
</g:if>
<g:else>
    <div class="modal-contenido">
        <g:if test="${unidadEjecutoraInstance?.nombre}">
            <div class="row">
                <div class="col-md-3  show-label">
                    Nombre
                </div>

                <div class="col-md-9">
                    <g:fieldValue bean="${unidadEjecutoraInstance}" field="nombre"/>
                </div>

            </div>
        </g:if>

        <g:if test="${unidadEjecutoraInstance?.padre}">
            <div class="row">
                <div class="col-md-3  show-label">
                    Depende de
                </div>

                <div class="col-md-9">
                    ${unidadEjecutoraInstance?.padre?.encodeAsHTML()}
                </div>

            </div>
        </g:if>

        <g:if test="${unidadEjecutoraInstance?.orden}">
            <div class="row">
                <div class="col-md-3  show-label">
                    Orden
                </div>

                <div class="col-md-9">
                    <g:fieldValue bean="${unidadEjecutoraInstance}" field="orden"/>
                </div>

            </div>
        </g:if>

        <g:if test="${unidadEjecutoraInstance?.objetivo}">
            <div class="row">
                <div class="col-md-3  show-label">
                    Misión
                </div>

                <div class="col-md-9">
                    <g:fieldValue bean="${unidadEjecutoraInstance}" field="objetivo"/>
                </div>

            </div>
        </g:if>

        <g:if test="${unidadEjecutoraInstance?.objetivo}">
            <div class="row">
                <div class="col-md-3  show-label">
                    Objetivo
                </div>

                <div class="col-md-9">
                    ${unidadEjecutoraInstance?.objetivoUnidad?.descripcion}
                </div>

            </div>
        </g:if>

        <g:if test="${unidadEjecutoraInstance?.tipoInstitucion}">
            <div class="row">
                <div class="col-md-3  show-label">
                    Área de gestión
                </div>

                <div class="col-md-9">
                    ${unidadEjecutoraInstance?.tipoInstitucion?.encodeAsHTML()}
                </div>

            </div>
        </g:if>

        <g:if test="${unidadEjecutoraInstance?.codigo}">
            <div class="row">
                <div class="col-md-3  show-label">
                    Código
                </div>

                <div class="col-md-9">
                    <g:fieldValue bean="${unidadEjecutoraInstance}" field="codigo"/>
                </div>

            </div>
        </g:if>

        <g:if test="${unidadEjecutoraInstance?.direccion}">
            <div class="row">
                <div class="col-md-3  show-label">
                    Ubicación
                </div>

                <div class="col-md-9">
                    <g:fieldValue bean="${unidadEjecutoraInstance}" field="direccion"/>
                </div>

            </div>
        </g:if>

        <g:if test="${unidadEjecutoraInstance?.telefono}">
            <div class="row">
                <div class="col-md-3  show-label">
                    Teléfono
                </div>

                <div class="col-md-9">
                    <g:fieldValue bean="${unidadEjecutoraInstance}" field="telefono"/>
                </div>

            </div>
        </g:if>

        <g:if test="${unidadEjecutoraInstance?.fax}">
            <div class="row">
                <div class="col-md-3  show-label">
                    Fax
                </div>

                <div class="col-md-9">
                    <g:fieldValue bean="${unidadEjecutoraInstance}" field="fax"/>
                </div>

            </div>
        </g:if>

        <g:if test="${unidadEjecutoraInstance?.email}">
            <div class="row">
                <div class="col-md-3  show-label">
                    E-mail
                </div>

                <div class="col-md-9">
                    <g:fieldValue bean="${unidadEjecutoraInstance}" field="email"/>
                </div>

            </div>
        </g:if>

        <g:if test="${unidadEjecutoraInstance?.fechaInicio}">
            <div class="row">
                <div class="col-md-3  show-label">
                    Fecha creación
                </div>

                <div class="col-md-9">
                    <g:formatDate date="${unidadEjecutoraInstance?.fechaInicio}" format="dd-MM-yyyy"/>
                </div>

            </div>
        </g:if>

        <g:if test="${unidadEjecutoraInstance?.fechaFin}">
            <div class="row">
                <div class="col-md-3  show-label">
                    Fecha Fin
                </div>

                <div class="col-md-9">
                    <g:formatDate date="${unidadEjecutoraInstance?.fechaFin}" format="dd-MM-yyyy"/>
                </div>

            </div>
        </g:if>

        <g:if test="${unidadEjecutoraInstance?.observaciones}">
            <div class="row">
                <div class="col-md-3  show-label">
                    Observaciones
                </div>

                <div class="col-md-9">
                    <g:fieldValue bean="${unidadEjecutoraInstance}" field="observaciones"/>
                </div>

            </div>
        </g:if>

        <g:if test="${presupuestos.size() > 0}">
            <div class="row">
                <div class="col-md-3  show-label">
                    Presupuesto
                </div>

                <div class="col-md-9">
                    <table border="1" cellpadding="2" style="border-collapse: collapse; border-color: #aaa;" width="100%">
                        <g:each in="${presupuestos}" var="pr" status="i">
                            <tr>
                                <th>Max. Inversión ${pr.anio}</th>

                                <td>
                                    <g:formatNumber number="${pr.maxInversion}" format="###,##0"
                                                    minFractionDigits="2" maxFractionDigits="2"/>
                                </td>
                            </tr>
                        </g:each>
                    </table>
                </div>
            </div>
        </g:if>
    </div>

</g:else>