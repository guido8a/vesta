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

<div class="dialog">
    <div class="body">

        <elm:message tipo="${flash.tipo}" clase="${flash.clase}">${flash.message}</elm:message>

        <div class="list">
            <table class="table table-condensed table-bordered table-striped table-hover">
                <thead>
                <tr>
                    <g:sortableColumn property="fecha" title="Fecha"/>
                    <th>Solicitudes a tratar</th>
                    <g:sortableColumn property="fechaRealizacion" title="Fecha Realizacion"/>
                    <g:sortableColumn property="observaciones" title="Observaciones"/>
                    <g:sortableColumn property="asistentes" title="Asistentes"/>
                    <th>Archivo</th>
                </tr>
                </thead>
                <tbody>
                <g:each in="${aprobaciones}" status="i" var="aprobacionInstance">
                    <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">

                        <td>
                            ${aprobacionInstance.fecha.format("dd-MM-yyyy HH:mm")}
                        </td>
                        <td style="text-align: center; font-weight: bold">
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
        $(".btnVerSolicitudes").click(function () {
            $.ajax({
                type    : "POST",
                url     : "${createLink(action:'solicitudes_ajax')}/" + $(this).attr("id"),
                success : function (msg) {
                    var b = bootbox.dialog({
                        id    : "dlgVer",
                        title : "Detalles de la Solicitud",

                        class : "modal-lg",

                        message : msg,
                        buttons : {
                            cancelar : {
                                label     : "Cancelar",
                                className : "btn-primary",
                                callback  : function () {
                                }
                            }
                        } //buttons
                    }); //dialog
                }
            });
        });
    });
</script>

</body>
</html>