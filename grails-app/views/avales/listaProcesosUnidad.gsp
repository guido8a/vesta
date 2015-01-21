<%--
  Created by IntelliJ IDEA.
  User: fabricio
  Date: 21/01/15
  Time: 03:06 PM
--%>

<%@ page import="vesta.parametros.TipoElemento" contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta name="layout" content="main"/>
    <title>Lista de Procesos</title>
</head>
<body>

<div class="fila">
    <g:link controller="avales" action="crearProceso" class="btn">Crear nuevo Proceso de contratación</g:link>
</div>
<table style="width: 95%;margin-top: 10px" >
    <thead>
    <tr>
        <th>Proyecto</th>
        <th>Nombre</th>
        <th>Inicio</th>
        <th>Fin</th>
        <th>Monto</th>
        <th></th>
        <th></th>
    </tr>
    </thead>
    <tbody>
    <g:each in="${procesos}" var="p">
        <tr>
            <td>${p.proyecto}</td>
            <td>${p.nombre}</td>
            <td style="text-align: center">${p.fechaInicio?.format("dd-MM-yyyy")}</td>
            <td style="text-align: center">${p.fechaFin?.format("dd-MM-yyyy")}</td>
            <td style="text-align: right">
                <g:formatNumber number="${p.getMonto()}" format="###,##0" minFractionDigits="2" maxFractionDigits="2" />
            </td>
            <td style="text-align: center">
                <a href="${g.createLink(action: 'crearProceso',id: p.id)}" class="btn">Editar</a>
            </td>
            <td style="text-align: center">
                <a href="${g.createLink(action: 'avalesProceso',id: p.id)}" class="btn">Avales</a>
            </td>
        </tr>
    </g:each>

    </tbody>
</table>
<script>
    $(".btn").button()
</script>

</body>
</html>