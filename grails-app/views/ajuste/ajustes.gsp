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
        <title>Ajustes</title>
        <link href="${resource(dir: 'css', file: 'reformas-ajustes.css')}" rel="stylesheet">
    </head>

    <body>
        <elm:container tipo="horizontal" titulo="Ajustes">
            <p>
                Existen 3 tipos de ajustes posibles:
                asignaciones existentes, actividad nueva, partida nueva
            </p>

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
                <g:link action="actividad" class="list-group-item bgActividades">
                    <h4 class="list-group-item-heading"><span class="icon"></span>
                        <elm:tipoReformaStr tipo="Ajuste" tipoSolicitud="A"/>
                    </h4>

                    <p class="list-group-item-text">
                        se crea nuevas actividades con asignación de origen, valor, actividad nueva (con fecha de incio, fecha de fin, justificación, valor y componente)
                    </p>
                </g:link>
                <g:link action="techo" class="list-group-item bgTecho">
                    <h4 class="list-group-item-heading"><span class="icon"></span>
                        <elm:tipoReformaStr tipo="Ajuste" tipoSolicitud="T"/>
                    </h4>

                    <p class="list-group-item-text">
                        se incrementa o decrementa el valor de asignaciones, o se crean nuevas asignaciones
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