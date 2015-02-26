<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 26/02/15
  Time: 01:16 PM
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <meta name="layout" content="main"/>
        <title>Búsqueda del menú</title>

        <style type="text/css">
        .no-margin {
            margin : 0;
        }
        </style>

    </head>

    <body>

        <div class="alert alert-info">
            Resultados de la búsqueda de <strong><em>${params.search}</em></strong> en el menú
        </div>

        <div class="row">
            <g:each in="${items}" var="it">
                <div class="col-md-6">
                    <div class="panel panel-info">
                        <!-- Default panel contents -->
                        <div class="panel-heading">
                            <elm:textoBusqueda busca="${params.search}">
                                <h4 class="no-margin">
                                    ${it.value.modulo.nombre}
                                    <small>${it.value.modulo.descripcion}</small>
                                </h4>
                            </elm:textoBusqueda>
                        </div>

                        <!-- List group -->
                        <div class="list-group">
                            <g:each in="${it.value.acciones}" var="ac">
                                <g:link controller="${ac.control.nombre}" action="${ac.nombre}" class="list-group-item">
                                    <elm:textoBusqueda busca="${params.search}">
                                        ${ac.descripcion}
                                    </elm:textoBusqueda>
                                </g:link>
                            </g:each>
                        </div>
                    </div>
                </div>
            </g:each>
        </div>
    </body>
</html>