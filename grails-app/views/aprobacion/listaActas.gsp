<%--
  Created by IntelliJ IDEA.
  User: fabricio
  Date: 27/02/15
  Time: 04:07 PM
--%>

<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 09/10/14
  Time: 11:28 AM
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta name="layout" content="main"/>
    <title>Lista de aprobaciones</title>
</head>

<body>

<div class="dialog" title="Lista de aprobaciones">
    %{--<div id="" class="toolbar ui-widget-header ui-corner-all">--}%
    %{--<g:link class="button create" action="prepararReunionAprobacion">--}%
    %{--Nueva reunión--}%
    %{--</g:link>--}%
    %{--</div> <!-- toolbar -->--}%

    <div class="body">
        <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
        </g:if>
        <div class="list">
            <div class="fg-toolbar ui-toolbar ui-widget-header ui-corner-top ui-helper-clearfix">
                %{--<div id="example_length" class="dataTables_length">--}%
                %{--<g:message code="show" default="Show" />&nbsp;--}%
                %{--<g:select from="${[10,20,30,40,50,60,70,80,90,100]}" name="max" value="${params.max}" />&nbsp;--}%
                %{--<g:message code="entries" default="entries" />--}%


                %{--<g:select--}%
                %{--from="['asc':message(code:'asc', default:'Ascendente'), 'desc':message(code:'desc', default:'Descendente')]"--}%
                %{--name="order"--}%
                %{--optionKey="key"--}%
                %{--optionValue="value"--}%
                %{--value="${params.order}"--}%
                %{--class="ui-widget-content ui-corner-all"/>--}%
                %{--</div>--}%
            </div>
            <table border="1">
                <thead>
                <tr>
                    <tdn:sortableColumn property="fecha" class="ui-state-default"
                                        title="${message(code: 'aprobacion.fecha.label', default: 'Fecha')}"/>
                    <th class="ui-state-default">Solicitudes a tratar</th>
                    <tdn:sortableColumn property="fechaRealizacion" class="ui-state-default"
                                        title="${message(code: 'aprobacion.fechaRealizacion.label', default: 'Fecha Realizacion')}"/>

                    <tdn:sortableColumn property="observaciones" class="ui-state-default"
                                        title="${message(code: 'aprobacion.observaciones.label', default: 'Observaciones')}"/>

                    <tdn:sortableColumn property="asistentes" class="ui-state-default"
                                        title="${message(code: 'aprobacion.asistentes.label', default: 'Asistentes')}"/>

                    <tdn:sortableColumn property="pathPdf" class="ui-state-default"
                                        title="${message(code: 'aprobacion.pathPdf.label', default: 'Archivo')}"/>
                </tr>
                </thead>
                <tbody>
                <g:each in="${aprobaciones}" status="i" var="aprobacionInstance">
                    <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">

                        <td>
                            ${aprobacionInstance.fecha.format("dd-MM-yyyy HH:mm")}
                        </td>
                        <td>
                            <g:set var="solicitudes" value="${aprobacionInstance.solicitudes.size()}"/>
                            <g:if test="${solicitudes > 0}">
                                <a href="#" class="button btnVerSolicitudes" id="${aprobacionInstance.id}" title="Ver solicitudes a tratar">
                                    ${solicitudes} solicitud${solicitudes == 1 ? '' : 'es'}
                                </a>
                            </g:if>
                            <g:else>
                                - Sin solicitudes -
                            </g:else>
                        </td>
                        <td>${aprobacionInstance.fechaRealizacion?.format("dd-MM-yyyy HH:mm")}</td>

                        <td>${fieldValue(bean: aprobacionInstance, field: "observaciones")}</td>

                        <td>${fieldValue(bean: aprobacionInstance, field: "asistentes")}</td>

                        <td>
                            <g:link controller="solicitud" action="downloadActa" id="${aprobacionInstance.id}">
                                ${fieldValue(bean: aprobacionInstance, field: "pathPdf")}
                            </g:link>
                        </td>

                    </tr>
                </g:each>
                </tbody>
            </table>
        </div>

    </div> <!-- body -->
</div> <!-- dialog -->

<script type="text/javascript">
    $(function () {
        $(".button").button();

        $(".btnVerSolicitudes").click(function () {
            $.ajax({
                type    : "POST",
                url     : "${createLink(action:'solicitudes_ajax')}/" + $(this).attr("id"),
                success : function (msg) {
                    $.box({
                        imageClass : false,
                        title      : "Solicitudes",
                        text       : msg,
                        dialog     : {
                            width   : 600,
                            buttons : {
                                "Aceptar" : function (r) {
                                }
                            }
                        }
                    });
                }
            });
        });
    });
</script>

</body>
</html>