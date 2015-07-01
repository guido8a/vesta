<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 25/06/15
  Time: 11:39 AM
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <meta name="layout" content="main">
        <title>Procesos de aval corriente</title>

        <link rel="stylesheet" href="${resource(dir: 'css/custom', file: 'avales.css')}" type="text/css"/>
    </head>

    <body>

        <elm:message tipo="${flash.tipo}" clase="${flash.clase}">${flash.message}</elm:message>

        <div class="fila">
            <g:if test="${params.aval != 'no'}">
                <g:link action="nuevaSolicitud" class="btn btn-default">
                    <i class="fa fa-file-o"></i> Nuevo proceso para solicitud de aval
                </g:link>
            </g:if>
        </div>

        <table class="table table-bordered table-hover table-striped table-condensed" style="margin-top: 25px;">
            <thead>
                <tr>
                    <th>Solicita</th>
                    <th>Nombre del proceso</th>
                    <th>Concepto</th>
                    <th>Estado</th>
                    <th style="width: 85px">Fecha</th>
                    <th style="width: 85px">Inicio</th>
                    <th style="width: 85px">Fin</th>
                    <th>Monto</th>
                </tr>
            </thead>
            <tbody>
                <g:if test="${procesos.size() > 0}">
                    <g:each in="${procesos}" var="proc">
                        <tr>
                            <td>${proc.usuario.unidad} - ${proc.usuario}</td>
                            <td>${proc.nombreProceso}</td>
                            <td>${proc.concepto}</td>
                            <td class="${proc.estado.codigo}">${proc.estado.descripcion}</td>
                            <td>${proc.fechaSolicitud.format("dd-MM-yyyy")}</td>
                            <td>${proc.fechaInicioProceso.format("dd-MM-yyyy")}</td>
                            <td>${proc.fechaFinProceso.format("dd-MM-yyyy")}</td>
                            <td class="text-right"><g:formatNumber number="${proc.monto}" type="currency" currencySymbol=""/></td>
                        </tr>
                    </g:each>
                </g:if>
                <g:else>
                    <tr class="info text-info text-center text-shadow">
                        <td colspan="7">
                            <i class="fa icon-ghost"></i> No se encontraron resultados
                        </td>
                    </tr>
                </g:else>
            </tbody>
        </table>

    </body>
</html>