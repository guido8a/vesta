<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 14/04/15
  Time: 03:31 PM
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <meta name="layout" content="main">
        <title>Ajustes al POA de gasto permanente</title>
        <link href="${resource(dir: 'css', file: 'reformas-ajustes.css')}" rel="stylesheet">
    </head>

    <body>
        <elm:container tipo="horizontal" titulo="Ajustes al POA de gasto permanente">

            <div class="list-group">
                <g:link action="existente" class="list-group-item bgExistentes">
                    <h4 class="list-group-item-heading"><span class="icon"></span>
                        <elm:tipoReformaStr tipo="Ajuste" tipoSolicitud="E"/>
                    </h4>

                    <p class="list-group-item-text">
                        se selecciona asignación o asignaciones de origen, asignación o asignaciones de destino y valor
                    </p>
                </g:link>
                <g:link action="partida" class="list-group-item bgPartidas">
                    <h4 class="list-group-item-heading"><span class="icon"></span>
                        <elm:tipoReformaStr tipo="Ajuste" tipoSolicitud="P"/>
                    </h4>

                    <p class="list-group-item-text">
                        se parte del valor actual de la asignación de origen a la
                        cual se añaden partidas, repartiendo el valor de la asignación en nuevas partidas
                    </p>
                </g:link>
                <g:link action="nuevoAjusteCorriente" class="list-group-item">
                    <h4 class="list-group-item-heading"><span class="icon"></span>
                        <elm:tipoReformaStr tipo="Ajuste" tipoSolicitud="Q"/>
                    </h4>
                    <p class="list-group-item-text">
                    Nuevo Ajuste de gasto permanente
                    </p>
                </g:link>
            </div>
        </elm:container>

        <script type="text/javascript">
            $(function () {
                $(".list-group-item").hover(function () {
                    $(this).find(".icon").html('<i class="fa fa-arrow-right"></i>');
                }, function () {
                    $(this).find(".icon").html('');
                });
            });
        </script>

    </body>
</html>