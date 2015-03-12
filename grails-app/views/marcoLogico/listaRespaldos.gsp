<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main">
    <title>Plan de Proyecto</title>
</head>

<body>

<div class="btn-toolbar toolbar">
    <div class="btn-group">
        <g:link controller="marcoLogico" action="marcoLogicoProyecto" id="${proy.id}" class="btn btn-sm btn-default">
            <i class="fa fa-list"></i> Regresar
        </g:link>
        <g:link controller="proyecto" action="${params.remove('list')}" params="${params}" class="btn btn-sm btn-default">
            <i class="fa fa-list"></i> Lista de proyectos
        </g:link>

    </div>
</div>
<elm:container tipo="horizontal" titulo="Respaldos del proyecto ${proy}">
    <div class="row">
        <div class="col-md-12">
            <table class="table table-bordered table-condensed">
                <thead>
                <tr>
                    <th>Fecha</th>
                    <th>Descripcion</th>
                    <th></th>
                </tr>
                </thead>
                <tbody>
                <g:each in="${resp}" var="r">
                    <tr>
                        <td>${r.fecha.format("dd-MM-yyyy")}</td>
                        <td>${r.descripcion}</td>
                        <td style="width: 80px;text-align: center">
                            <g:link controller="marcoLogico" action="verRespaldo" id="${r.id}" class="btn btn-info btn-sm">
                                <i class="fa fa-search"></i> Ver
                            </g:link>
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