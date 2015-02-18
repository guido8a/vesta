<%--
  Created by IntelliJ IDEA.
  User: fabricio
  Date: 13/02/15
  Time: 04:08 PM
--%>

<%@ page import="vesta.contratacion.Aprobacion" %>


<div class="dialog" title="${title}">

    <div class="body">
        <g:if test="${flash.message}">
            <div class="message ui-state-highlight ui-corner-all">${flash.message}</div>
        </g:if>
        <div>


            <g:if test="${aprobacionInstance?.fecha}">
                <div class="row">
                    <div class="col-md-2 show-label">
                        Fecha Planificada:
                    </div>

                    <div class="col-md-3">
                        <g:formatDate date="${aprobacionInstance?.fecha}" format="dd-MM-yyyy" />
                    </div>

                </div>
            </g:if>
            <g:if test="${aprobacionInstance?.fechaRealizacion}">
                <div class="row">
                    <div class="col-md-2 show-label">
                        Fecha Realización:
                    </div>

                    <div class="col-md-3">
                        <g:formatDate date="${aprobacionInstance?.fechaRealizacion}" format="dd-MM-yyyy" />
                    </div>

                </div>
            </g:if>

            %{--<g:if test="${aprobacionInstance?.asistentes}">--}%
                <div class="row">
                    <div class="col-md-2 show-label">
                        Asistentes:
                    </div>

                    <div class="col-md-6">
                        <g:fieldValue bean="${aprobacionInstance}" field="asistentes"/>
                    </div>

                </div>
            %{--</g:if>--}%


            <g:if test="${aprobacionInstance?.observaciones}">
                <div class="row">
                    <div class="col-md-2 show-label">
                        Observaciones:
                    </div>

                    <div class="col-md-6">
                        <g:fieldValue bean="${aprobacionInstance}" field="observaciones"/>
                    </div>

                </div>
            </g:if>

            <g:if test="${aprobacionInstance?.pathPdf}">
                <div class="row">
                    <div class="col-md-2 show-label">
                        Path Pdf
                    </div>

                    <div class="col-md-3">
                        <g:fieldValue bean="${aprobacionInstance}" field="pathPdf"/>
                    </div>

                </div>
            </g:if>


                <div class="row">
                    <div class="col-md-2 show-label">
                       Solicitudes
                    </div>
                    <div class="col-md-8">
                        <ul>
                            <g:each in="${aprobacionInstance.solicitudes}" var="s">
                                <li>
                                    ${s?.objetoContrato}

                                </li>
                            </g:each>
                        </ul>
                        <g:link class="button btn btn-default btnVerSolicitud" controller="aprobacion" action="reunion" id="${aprobacionInstance?.id}">
                            <i class="fa fa-archive"></i> Ver Solicitudes
                        </g:link>
                    </div> <!-- campo -->
                </div> <!-- prop -->
        </div>
    </div> <!-- body -->
</div> <!-- dialog -->

<script type="text/javascript">
    $(function () {
        $(".button").button();
        $(".home").button("option", "icons", {primary : 'ui-icon-home'});
        $(".list").button("option", "icons", {primary : 'ui-icon-clipboard'});
        $(".create").button("option", "icons", {primary : 'ui-icon-document'});

        $(".edit").button("option", "icons", {primary : 'ui-icon-pencil'});
        $(".delete").button("option", "icons", {primary : 'ui-icon-trash'}).click(function () {
            if (confirm("${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}")) {
                return true;
            }
            return false;
        });
    });

</script>

%{--</body>--}%
%{--</html>--}%
