<%@ page import="vesta.parametros.TipoElemento" contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta name="layout" content="main"/>
    <title>Lista de hitos</title>

    <style>
    .tipo{
        font-weight: bold;
    }
    </style>
</head>
<body>
<g:if test="${flash.message}">
    <div class="message ui-state-highlight ui-corner-all">
        ${flash.message}
    </div>
</g:if>
<div class="btn-toolbar toolbar" style="margin-top: 10px">
    <div class="btn-group">
        <g:link controller="hito" action="crearHito" class="btn btn-default"> <i class="fa fa-file-o"></i> Crear nuevo</g:link>
    </div>
</div>
<elm:container tipo="horizontal" titulo="Lista de hitos">

    <div class="row">
        <div class="col-md-12">
            <table  class="table table-stripped table-hover table-condensed">
                <thead>
                <tr>
                    <th>Descripción</th>
                    <th>Inicio</th>
                    <th>Fin</th>
                    <th>Ver</th>
                    <th>Editar</th>
                </tr>
                </thead>
                <tbody>
                <g:each in="${hitos}" var="h">
                    <tr>
                        <td >${h.descripcion}</td>
                        <td style="text-align: center">${h.inicio?.format("dd-MM-yyyy")}</td>
                        <td style="text-align: center">${h.fechaPlanificada?.format("dd-MM-yyyy")}</td>
                        <td style="text-align: center">
                            <g:link controller="hito" action="verHito" id="${h.id}" class="btn btn-info btn-sm" ><i class="fa fa-gear"></i> Ver ejecución</g:link>
                        </td>
                        <td style="text-align: center">
                            <g:link controller="hito" action="crearHito" id="${h.id}" class="btn btn-info btn-sm" ><i class="fa fa-pencil"></i> Editar</g:link>
                        </td>
                    </tr>
                </g:each>
                </tbody>
            </table>
        </div>
    </div>


</elm:container>

</body>
</html>